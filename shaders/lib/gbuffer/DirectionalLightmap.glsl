/*
  SAPPHIRE BASE.
  JCM2606.

  Before editing anything in this file, please read "LICENSE.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_GBUFFER_DIRECTIONALLIGHTMAP
  #define INT_INCLUDED_GBUFFER_DIRECTIONALLIGHTMAP

  vec2 getLightmapShading(in vec2 lightmap, in vec3 surfaceNormal) {
    c(float) maxBrightness = 0.0625;

    #if SHADER != GBUFFERS_TERRAIN || !defined(LIGHTMAPS_SHADING)
      return vec2(maxBrightness * 6.55);
    #else
      vec2 shading = lightmap;

      #define blockShading shading.x
      #define skyShading shading.y

      mat2 lights = mat2(
        vec2(dFdx(blockShading), dFdy(blockShading)) * 120.0,
        vec2(dFdx(skyShading), dFdy(skyShading)) * 120.0
      );

      #define lightBlock lights[0]
      #define lightSky lights[1]

      c(float) a = 0.0005;
      mat2x3 tangentLights = mat2x3(
        fnormalize(vec3(lightBlock.x * ttn[0] + (a * normal + (lightBlock.y * ttn[1])))),
        fnormalize(vec3(lightSky.x * ttn[0] + (a * normal + (lightSky.y * ttn[1]))))
      );

      #define tangentLightBlock tangentLights[0]
      #define tangentLightSky tangentLights[1]

      blockShading = clamp01(dot(surfaceNormal, tangentLightBlock));
      skyShading = clamp01(dot(surfaceNormal, tangentLightSky));

      c(float) threshold = 0.1;
      blockShading = (blockShading > threshold) ? maxBrightness : blockShading;
      skyShading = (skyShading > threshold) ? maxBrightness : skyShading;

      #undef tangentLightBlock
      #undef tangentLightSky

      #undef lightBlock
      #undef lightSky

      #undef blockShading
      #undef skyShading

      return (shading * 0.75 + 0.25);
    #endif
  }

  vec2 getLightmaps(in vec2 lightmap, in vec3 surfaceNormal) {
    c(float) strength = 2.75;
    c(float) blockAttenuation = LIGHTMAPS_BLOCK_ATTENUATION;
    c(float) skyAttenuation = LIGHTMAPS_SKY_ATTENUATION;
    c(vec2) attenuation = vec2(blockAttenuation, skyAttenuation);

    vec2 shading = getLightmapShading(lightmap, surfaceNormal);

    return pow(lightmap, attenuation) * shading * strength;
  }
#endif
