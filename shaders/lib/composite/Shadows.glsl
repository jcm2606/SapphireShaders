/*
  SAPPHIRE.
  JCM2606.

  Before editing anything in this file, please read "License.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_COMPOSITE_SHADOWS
  #define INT_INCLUDED_COMPOSITE_SHADOWS

  #define ShadowObject() Shadows(vec2(0.0), vec3(0.0), 0.0, vec3(0.0), 0.0, 0.0)

  struct Shadows {
    vec2 depth;
    vec3 occlusion;
    float difference;

    vec3 colour;
    
    float dist;
    float material;
  };

  void getShadows(io Shadows shadowObject) {
    // CALCULATE SHADOW POSITIONS
    mat2x3 shadowPosition = mat2x3(0.0);

    #define shadowPositionFront shadowPosition[0]
    #define shadowPositionBack shadowPosition[1]

    shadowPositionFront = getShadowPosition(getWorldPosition(position.viewPositionFront));
    shadowPositionBack = getShadowPosition(getWorldPosition(position.viewPositionBack));
    
    c(float) shadowBias = 0.0001;
    shadowPositionFront.z += shadowBias;
    shadowPositionBack.z += shadowBias;

    // FIND BLOCKERS
    float rotAngle = dither64(ivec2(int(texcoord.x * viewWidth), int(texcoord.y * viewHeight))) * tau;
    mat2 rotation = rot2(rotAngle);

    vec2 blocker = vec2(0.0);
    float blockerSearchWidth = 0.001;
    c(int) blockerSearchLOD = 0;

    #define blockerFront blocker.x
    #define blockerBack blocker.y

    for(int i = -1; i <= 1; i++) {
      for(int j = -1; j <= 1; j++) {
        vec2 offset = (vec2(i, j) + 0.5) * rotation * blockerSearchWidth;

        blockerFront += texture2DLod(shadowtex0, distortShadowPosition(offset + shadowPositionFront.xy, 1), blockerSearchLOD).x;
        blockerBack += texture2DLod(shadowtex1, distortShadowPosition(offset + shadowPositionBack.xy, 1), blockerSearchLOD).x;
      }
    }
    
    c(float) iterRCP = 1.0 / 9.0;
    blocker *= iterRCP;

    // SAMPLE SHADOWS WITH PERCENTAGE-CLOSER FILTER
    c(float) lightDistance = 64.0;
    cRCP(float, lightDistance);
    c(int) shadowQuality = SHADOW_FILTER_QUALITY;
    cRCP(float, shadowQuality);

    c(float) minWidth = 0.0;
    //vec2 width = max(vec2(minWidth), vec2(shadowPositionFront.z, shadowPositionBack.z) - blocker * lightDistance) * shadowQualityRCP;
    vec2 width = max(vec2(minWidth), (vec2(shadowPositionFront.z, shadowPositionBack.z) - blocker) * lightDistanceRCP) * shadowQualityRCP;

    mat2 widths = mat2(
      vec2(width.x) * rotation,
      vec2(width.y) * rotation
    );

    #define widthFront widths[0]
    #define widthBack widths[1]

    c(float) weight = 1.0 / pow(float(shadowQuality) * 2.0 + 1.0, 2.0);

    for(int i = -shadowQuality; i <= shadowQuality; i++) {
      for(int j = -shadowQuality; j <= shadowQuality; j++) {
        #if 1
          mat2 offsets = mat2(
            vec2(i, j) * widthFront,
            vec2(i, j) * widthBack
          );

          #define offsetFront offsets[0]
          #define offsetBack offsets[1]

          vec3 depths = vec3(
            texture2D(shadowtex1, distortShadowPosition(offsetBack + shadowPositionBack.xy, 1)).x,
            texture2D(shadowtex0, distortShadowPosition(offsetFront + shadowPositionBack.xy, 1)).x,
            texture2D(shadowtex0, distortShadowPosition(offsetFront + shadowPositionFront.xy, 1)).x
          );

          shadowObject.depth += depths.xy;

          shadowObject.occlusion.x += ceil(compareShadow(depths.x, shadowPositionBack.z));
          shadowObject.occlusion.y += ceil(compareShadow(depths.y, shadowPositionBack.z));
          shadowObject.occlusion.z += ceil(compareShadow(depths.z, shadowPositionFront.z));

          shadowObject.colour += texture2D(shadowcolor0, distortShadowPosition(offsetFront + shadowPositionBack.xy, 1)).rgb;

          #undef offsetFront
          #undef offsetBack
        #else
          mat2 offsets = mat2(
            vec2(i, j) * widthFront,
            vec2(i, j) * widthBack
          );

          vec3 depths = vec3(
            texture2D(shadowtex0, distortShadowPosition(offsets[0] + shadowPositionFront.xy, 1)).x,
            texture2D(shadowtex0, distortShadowPosition(offsets[0] + shadowPositionBack.xy, 1)).x,
            texture2D(shadowtex1, distortShadowPosition(offsets[0] + shadowPositionBack.xy, 1)).x
          );

          shadowObject.depth += depths.yz;

          shadowObject.occlusion.x += ceil(compareShadow(depths.x, shadowPositionFront.z));
          shadowObject.occlusion.y += ceil(compareShadow(depths.y, shadowPositionBack.z));
          shadowObject.occlusion.z += ceil(compareShadow(depths.z, shadowPositionBack.z));

          shadowObject.colour += texture2D(shadowcolor0, distortShadowPosition(offsets[0] + shadowPositionBack.xy, 1)).rgb;
        #endif
      }
    }

    shadowObject.depth *= weight;
    shadowObject.occlusion *= weight;
    shadowObject.colour *= weight;

    shadowObject.colour = toLinear(toShadowHDR(shadowObject.colour));

    shadowObject.difference = max0(shadowObject.occlusion.x - shadowObject.occlusion.y);

    #undef widthFront
    #undef widthBack

    #undef blockerFront
    #undef blockerBack

    #undef shadowPositionFront
    #undef shadowPositionBack
  }
#endif
