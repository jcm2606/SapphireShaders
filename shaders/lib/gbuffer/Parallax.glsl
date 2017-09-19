/*
  SAPPHIRE BASE.
  JCM2606.

  Before editing anything in this file, please read "LICENSE.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_GBUFFER_PARALLAX
  #define INT_INCLUDED_GBUFFER_PARALLAX

  #if   SHADER == GBUFFERS_HAND || SHADER == GBUFFERS_TERRAIN
    c(vec3) intervalMult = vec3(1.0, 1.0, 1.0 / PARALLAX_TERRAIN_DEPTH) / TEXTURE_RESOLUTION;
    c(float) maxOcclusionDistance = 96.0;
    c(float) minOcclusionDistance = 64.0;
    c(float) occlusionDistance = maxOcclusionDistance - minOcclusionDistance;
    cRCP(float, occlusionDistance);
    c(int) maxOcclusionPoints = 
      #ifdef PARALLAX_TERRAIN_QUALITY_SCALING
        int(TEXTURE_RESOLUTION)
      #else
        PARALLAX_TERRAIN_QUALITY_FIXED
      #endif
    ;
    c(float) minCoord = 1.0 / 4096.0;

    mat2 parallaxDerivatives = mat2(
      dFdx(uvcoord * parallaxVector.zw),
      dFdy(uvcoord * parallaxVector.zw)
    );
  
    vec4 parallaxSample(in sampler2D tex, in vec2 coord) {
      return texture2DGradARB(tex, fract(coord) * parallaxVector.zw + parallaxVector.xy, parallaxDerivatives[0], parallaxDerivatives[1]);
    }
    
    vec2 getParallax(in vec3 view) {
      vec2 texcoord = uvcoord * parallaxVector.zw + parallaxVector.xy;

      #ifndef PARALLAX_TERRAIN
        return texcoord;
      #endif

      float dist = flength(view);

      if(dist < maxOcclusionDistance) {
        vec3 interval = view * intervalMult;
        vec3 coord = vec3(uvcoord, 1.0);

        for(int loopCount = 0; loopCount < maxOcclusionPoints && parallaxSample(normals, coord.xy).a < coord.p; loopCount++) {
          coord += interval;
        }

        if(coord.y < minCoord && parallaxSample(texture, coord.xy).a == 0.0) {
          coord.t = minCoord;
          discard;
        }

        texcoord = mix(fract(coord.xy) * parallaxVector.zw + parallaxVector.xy, texcoord, clamp01((dist - minOcclusionDistance) * occlusionDistanceRCP));
      }

      return texcoord;
    }
  #elif SHADER == GBUFFERS_WATER

  #endif
#endif
