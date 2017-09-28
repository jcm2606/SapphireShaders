/*
  SAPPHIRE.
  JCM2606.

  Before editing anything in this file, please read "LICENSE.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_COMPOSITE_VOLUMETRICS
  #define INT_INCLUDED_COMPOSITE_VOLUMETRICS

  #if   STAGE == COMPOSITE1
    #include "/lib/composite/WaterAbsorption.glsl"

    // OPTIONS
    c(int) steps = 8;
    cRCP(float, steps);
    c(float) finalMult = stepsRCP * 1.0;

    // MARCHER
    vec3 getWaterInteraction(in vec3 colour, in vec3 lightColour, in float occlusion, in float dist) {
      return mix(
        impurityColour * lightColour * absorbWater(dist),
        colour * absorbWater(dist),
        (exp2(-dist * WATER_IMPURITY))
      );
    }
    
    vec3 getVolumetrics(in mat2x3 lighting, in vec3 view) {
      vec3 colour = vec3(0.0);

      // LIGHTING TWEAKS
      float mieTail = dot(fnormalize(view), lightVector);

      lighting[0] *= mieTail * 0.5 + 0.5;

      // RAYS
      // For volumetrics to work properly, I need access to the view, world, and shadow positions simultaneously.
      // This requires multiple rays to be present, so to save on performance, I do everything outside the loop, and just step the rays inside the loop.
      float dither = bayer16(ivec2(int(texcoord.x * viewWidth), int(texcoord.y * viewHeight)));

      mat4 worldToShadow = shadowProjection * shadowModelView;

      mat4x3 viewRay = mat4x3(0.0);

      #define viewStart viewRay[0]
      #define viewEnd viewRay[1]
      #define viewStep viewRay[2]
      #define viewPos viewRay[3]

      viewStart = vec3(0.0);
      viewEnd = (!getLandMask(position.depthBack)) ? getViewPosition(texcoord, getExpDepth(48.0)) : view;

      viewStep = fnormalize(viewEnd - viewStart) * distance(viewEnd, viewStart) * stepsRCP;

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
      float weight = flength(shadowStep);

      vec3 absorbPos = (isEyeInWater == 1) ? viewStart : position.viewPositionFront;

      for(int i = 0; i < steps; i++, viewPos += viewStep, worldPos += worldStep, shadowPos += shadowStep) {
        // POSITIONS
        vec3 shadow = vec3(distortShadowPosition(shadowPos.xy, 0), shadowPos.z) * 0.5 + 0.5;
        vec3 world = worldPos + cameraPosition;

        // DEPTHS
        float depthFront = texture2D(shadowtex0, shadow.xy).x;
        float depthView = getExpDepth(viewPos.z);

        float penetration = max0(shadow.z - depthFront) * shadowDepthBlocks;

        // OCCLUSION
        vec2 occlusionVector = vec2(0.0);

        #define occlusionBack occlusionVector.x
        #define occlusionFront occlusionVector.y

        occlusionBack = compareShadow(texture2D(shadowtex1, shadow.xy).x, shadow.z);
        occlusionFront = compareShadow(depthFront, shadow.z);

        // VISIBILITY
        float visibility = 0.0;

        if(occlusionBack - occlusionFront > 0.0) visibility += 4.0;

        // PARTICIPATING MEDIA
        // HEIGHT FOG
        visibility += exp2(-max0(world.y - MC_SEA_LEVEL) * 0.05) * 4.0;

        // VISIBILITY OCCLUSION
        visibility *= occlusionBack;

        // COLOUR
        vec3 rayColour = lighting[0] * visibility + (lighting[1] * visibility);
        vec3 lightColour = rayColour;

        vec3 shadowColour = toLinear(toShadowHDR(texture2D(shadowcolor0, shadow.xy).rgb));
        rayColour *= (occlusionBack - occlusionFront > 0.0) ? shadowColour : vec3(1.0);

        // VOLUME INTERACTION
        // SOURCE -> RAY WATER ABSORPTION
        rayColour = (occlusionBack - occlusionFront > 0.0) ? getWaterInteraction(rayColour, lightColour, occlusionBack, penetration) : rayColour;

        // RAY -> EYE WATER ABSORPTION
        rayColour = (occlusionBack - occlusionFront > 0.0 || (isEyeInWater == 1 && frontMaterial.water > 0.5)) ? getWaterInteraction(rayColour, lightColour, occlusionBack, distance(
          absorbPos,
          (!(occlusionBack - occlusionFront > 0.0)) ? position.viewPositionFront : viewPos
        )) : rayColour;

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
      c(int) width = 2;
      cRCP(float, width);
      c(float) weight = 1.0 / pow(float(width) * 2.0 + 1.0, 2.0);
      c(float) threshold = 0.001;

      float rotAngle = dither64(ivec2(int(texcoord.x * viewWidth), int(texcoord.y * viewHeight))) * tau;
      mat2 rotation = rot2(rotAngle);

      vec2 radius = vec2(0.002) * widthRCP * rotation;
      vec2 refraction = refractOffset * frontMaterial.water;

      vec4 volumetrics = vec4(0.0);

      for(int i = -width; i <= width; i++) {
        for(int j = -width; j <= width; j++) {
          volumetrics += texture2DLod(colortex6, vec2(i, j) * radius + (refraction + texcoord), 2);
        }
      }

      volumetrics *= weight;

      return background + max0(toShadowHDR(volumetrics.rgb));
    }
  #endif
#endif
