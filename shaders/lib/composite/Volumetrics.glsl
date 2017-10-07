/*
  SAPPHIRE.
  JCM2606.

  Before editing anything in this file, please read "LICENSE.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_COMPOSITE_VOLUMETRICS
  #define INT_INCLUDED_COMPOSITE_VOLUMETRICS

  #if   STAGE == COMPOSITE1
    #include "/lib/composite/WaterAbsorption.glsl"

    #include "/lib/common/util/Noise.glsl"

    // OPTIONS
    c(int) steps = 8;
    cRCP(float, steps);
    c(float) finalMult = stepsRCP * 1.0;

    // FOG
    float getGroundFog(in vec3 world) {
      float fog = 0.0;

      c(float) windDirection = 0.7;

      c(float) fogSpeed = 0.3;
      c(vec3) fogDirection = swizzle3 * fogSpeed;
      vec3 move = fogDirection * frametime;

      c(mat2) rot = rot2(windDirection);

      vec3 pos = world;
      pos *= vec3(1.0, 1.3, 1.0) * 0.7;

      pos.xz *= rot;
      pos.xz *= rot; fog += texnoise3D(noisetex, pos + move);
      pos.xz *= rot; fog -= texnoise3D(noisetex, pos * 2.0 + (move * 2.0)) * 0.5;
      pos.xz *= rot; fog += texnoise3D(noisetex, pos * 4.0 + (move * 4.0)) * 0.25;

      fog *= 0.4;
      //fog = 1.0;

      fog = fog * 0.75 + 0.25;

      fog *= exp2(-abs(world.y - MC_SEA_LEVEL) * 0.4);

      return fog * fogDensityGround;
    }

    // MARCHER    
    vec3 getVolumetrics(in mat2x3 lighting, in vec3 view) {
      #ifndef VOLUMETRICS
        return vec3(0.0);
      #endif

      vec3 colour = vec3(0.0);

      // LIGHTING TWEAKS
      lighting[0] *= 2.0;

      // BACK DEPTH
      mat2x3 nViewPosition = mat2x3(
        fnormalize(position.viewPositionBack),
        fnormalize(position.viewPositionFront)
      );
      float backDepthRCP = 1.0 / nViewPosition[0].z;

      // WORLD LIGHT POSITION
      vec3 light = fnormalize(getWorldPosition(lightVector));

      // MIE TAIL
      //float mieTail = dot(nViewPosition)

      // EYE BRIGHTNESS
      c(float) skyAttenuation = LIGHTMAPS_SKY_ATTENUATION;
      c(float) attenuation = skyAttenuation;

      float ebs = pow(getEBS().y, attenuation);

      // RAYS
      // For volumetrics to work properly, I need access to the view, world, and shadow positions simultaneously.
      // This requires multiple rays to be present, so to save on performance, I do everything outside the loop, and just step the rays inside the loop.
      float dither = bayer64(ivec2(int(texcoord.x * viewWidth), int(texcoord.y * viewHeight)));

      mat4 worldToShadow = shadowProjection * shadowModelView;

      mat4x3 viewRay = mat4x3(0.0);

      #define viewStart viewRay[0]
      #define viewEnd viewRay[1]
      #define viewStep viewRay[2]
      #define viewPos viewRay[3]

      viewStart = vec3(0.0);
      viewEnd = (!getLandMask(position.depthBack)) ? getViewPosition(texcoord, getExpDepth(48.0)) : view;

      float viewDist = distance(viewEnd, viewStart);

      viewStep = fnormalize(viewEnd - viewStart) * viewDist * stepsRCP;

      viewPos = viewStep * dither + viewStart;

      mat4x3 worldRay = mat4x3(0.0);

      #define worldStart worldRay[0]
      #define worldEnd worldRay[1]
      #define worldStep worldRay[2]
      #define worldPos worldRay[3]

      worldStart = getWorldPosition(viewStart);
      worldEnd = getWorldPosition(viewEnd);

      worldStep = fnormalize(worldEnd - worldStart) * distance(worldEnd, worldStart) * stepsRCP;

      worldPos = worldStep * dither + worldStart;

      mat4x3 shadowRay = mat4x3(0.0);

      #define shadowStart shadowRay[0]
      #define shadowEnd shadowRay[1]
      #define shadowStep shadowRay[2]
      #define shadowPos shadowRay[3]

      shadowStart = transMAD(worldToShadow, worldStart);
      shadowEnd = transMAD(worldToShadow, worldEnd);

      shadowStep = fnormalize(shadowEnd - shadowStart) * distance(shadowEnd, shadowStart) * stepsRCP;

      shadowPos = shadowStep * dither + shadowStart;

      // MARCHING LOOP
      #if 1
        float weight = flength(shadowStep);
      #else
        #define weight flength(shadowPos)
      #endif

      vec3 absorbPos = (isEyeInWater == 1) ? viewStart : position.viewPositionFront;

      vec3 shadow = vec3(0.0);
      vec3 world = vec3(0.0);

      float depthFront = 0.0;
      float depthView = 0.0;
      
      float distSurface = 0.0;
      float distEye = 0.0;

      float material = 0.0;
      bool water = false;

      vec2 occlusionVector = vec2(0.0);

      vec2 visibility = vec2(0.0);

      vec3 rayColour = vec3(0.0);
      vec3 lightColour = vec3(0.0);

      vec3 shadowColour = vec3(0.0);

      for(int i = 0; i < steps; i++, viewPos += viewStep, worldPos += worldStep, shadowPos += shadowStep) {
        // POSITIONS
        shadow = vec3(distortShadowPosition(shadowPos.xy, 0), shadowPos.z) * 0.5 + 0.5;
        world = worldPos + cameraPosition;

        // DEPTHS
        depthFront = texture2D(shadowtex0, shadow.xy).x;

        // OCCLUSION
        occlusionVector = vec2(0.0);

        #define occlusionBack occlusionVector.x
        #define occlusionFront occlusionVector.y

        occlusionBack = compareShadow(texture2D(shadowtex1, shadow.xy).x, shadow.z);
        occlusionFront = compareShadow(depthFront, shadow.z);

        // DISTANCES
        distSurface = max0(shadow.z - depthFront) * shadowDepthBlocks;
        distEye =  distance(absorbPos, (!(occlusionBack - occlusionFront > 0.0)) ? position.viewPositionFront : viewPos);

        // MATERIAL
        material = texture2D(shadowcolor1, shadow.xy).a * materialRange;

        water = comparef(material, MATERIAL_WATER, ubyteMaxRCP);

        // VISIBILITY
        visibility = vec2(0.0);

        // PARTICIPATING MEDIA
        // HEIGHT FOG
        visibility += exp2(-max0(world.y - MC_SEA_LEVEL) * 0.05) * fogDensityHeight;

        // VOLUME FOG
        visibility += getGroundFog(world);

        // WATER
        visibility = (occlusionBack - occlusionFront > 0.0 && water) ? vec2(4.0) : visibility;

        // VISIBILITY OCCLUSION
        #ifdef VOLUMETRICS_SHADOW_SKY_APPROXIMATION
          visibility *= vec2(occlusionBack, (isEyeInWater == 1 || (viewPos.z < position.viewPositionFront.z && frontMaterial.water > 0.5)) ? occlusionBack : mix(ebs, (viewPos.z < position.viewPositionFront.z) ? frontSurface.skyLight : backSurface.skyLight, (!getLandMask(position.depthBack)) ? 0.0 : pow4(distance(viewStart, viewPos) / viewDist)));
        #else
          visibility *= occlusionBack;
        #endif

        // COLOUR
        rayColour = (lighting[0] * visibility.x) * max0(dot(fnormalize(worldPos), light) * 0.5 + 0.5) + (lighting[1] * visibility.y);
        lightColour = rayColour;

        shadowColour = toLinear(toShadowHDR(texture2D(shadowcolor0, shadow.xy).rgb));
        rayColour *= (occlusionBack - occlusionFront > 0.0) ? shadowColour : vec3(1.0);

        // VOLUME INTERACTION
        // SOURCE -> RAY WATER ABSORPTION & SCATTERING
        rayColour = (occlusionBack - occlusionFront > 0.0 && water) ? getWaterLightInteraction(rayColour, lightColour, distSurface) : rayColour;

        // RAY -> EYE WATER ABSORPTION & SCATTERING
        rayColour = ((occlusionBack - occlusionFront > 0.0 || (isEyeInWater == 1 && frontMaterial.water > 0.5)) && water) ? getWaterLightInteraction(rayColour, lightColour, distEye) : rayColour;

        // SOURCE -> RAY WATER DIFFUSION
        rayColour *= (occlusionBack - occlusionFront > 0.0 && water) ? diffuseWater(distSurface) : 1.0;

        // RAY -> EYE WATER DIFFUSION
        rayColour *= (occlusionBack - occlusionFront > 0.0 && water) ? diffuseWater(distEye) : 1.0;

        // ACCUMULATION
        colour = rayColour * weight + colour;

        #undef occlusionBack
        #undef occlusionFront
      }

      #undef shadowStart
      #undef shadowEnd
      #undef shadowStep
      #undef shadowPos

      #undef worldStart
      #undef worldEnd
      #undef worldStep
      #undef worldPos

      #undef viewStart
      #undef viewEnd
      #undef viewStep
      #undef viewPos

      colour = toShadowLDR(colour * finalMult);

      return colour;
    }
  #elif STAGE == COMPOSITE2
    vec3 drawVolumetrics(in vec3 background, in vec2 texcoord, in vec2 refractOffset) {
      #ifndef VOLUMETRICS
        return background;
      #endif

      c(int) width = 3;
      cRCP(float, width);
      c(float) weight = 1.0 / pow(float(width) * 2.0 + 1.0, 2.0);
      c(float) threshold = 0.001;

      float rotAngle = bayer64(ivec2(int(texcoord.x * viewWidth), int(texcoord.y * viewHeight))) * tau;
      mat2 rotation = rot2(rotAngle);

      vec2 radius = vec2(0.002) * widthRCP * rotation;
      vec2 refraction = refractOffset * frontMaterial.water;

      vec4 volumetrics = vec4(0.0);

      for(int i = -width; i <= width; i++) {
        for(int j = -width; j <= width; j++) {
          vec2 offset = vec2(i, j) * radius + texcoord;

          volumetrics += texture2DLod(colortex6, offset + refraction, 2);
        }
      }

      volumetrics *= weight;

      return background + max0(toShadowHDR(volumetrics.rgb));
    }
  #endif
#endif
