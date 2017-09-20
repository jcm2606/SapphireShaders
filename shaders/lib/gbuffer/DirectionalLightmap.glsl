/*
  SAPPHIRE BASE.
  JCM2606.

  Before editing anything in this file, please read "LICENSE.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_GBUFFER_DIRECTIONALLIGHTMAP
  #define INT_INCLUDED_GBUFFER_DIRECTIONALLIGHTMAP

  #include "/lib/common/util/DiffuseModel.glsl"

  vec2 getLightmapShading(in vec2 lightmap, in vec3 surfaceNormal, in vec3 view, in float roughness, c(in float) steepness) {
    c(float) maxBrightness = 0.0625;
    c(float) maxBrightnessNoShading = maxBrightness * 6.55;

    #ifndef LIGHTMAPS_SHADING
      return vec2(maxBrightnessNoShading);
    #elif SHADER != GBUFFERS_TERRAIN && SHADER != GBUFFERS_HAND
      return vec2(maxBrightnessNoShading);
    #else
      vec2 shading = lightmap;

      #define blockShading shading.x
      #define skyShading shading.y

      c(float) a = 256.0;
      mat2 lights = mat2(
        vec2(dFdx(blockShading), dFdy(blockShading)) * a,
        vec2(dFdx(skyShading), dFdy(skyShading)) * a
      );

      #define lightBlock lights[0]
      #define lightSky lights[1]

      vec3 T = fnormalize(dFdx(vertex));
      vec3 B = fnormalize(dFdy(vertex));
      vec3 N = cross(T, B);

      c(float) b = 0.0005;
      mat2x3 tangentLights = mat2x3(
        fnormalize(vec3(lightBlock.x * T + (b * N + (lightBlock.y * B)))),
        fnormalize(vec3(lightSky.x * T + (b * N + (lightSky.y * B))))
      );

      #define tangentLightBlock tangentLights[0]
      #define tangentLightSky tangentLights[1]

      blockShading = LightmapShadingModel(vertex, tangentLightBlock, surfaceNormal, roughness);
      skyShading = LightmapShadingModel(vertex, tangentLightSky, surfaceNormal, roughness);

      c(float) threshold = 0.1;
      blockShading = (blockShading > threshold) ? maxBrightness : blockShading;
      skyShading = (skyShading > threshold) ? maxBrightness : skyShading;

      #undef tangentLightBlock
      #undef tangentLightSky

      #undef lightBlock
      #undef lightSky

      #undef blockShading
      #undef skyShading

      return cflatten2(shading, steepness);
    #endif
  }

  vec2 getLightmaps(in vec2 lightmap, in vec3 surfaceNormal, in vec3 view, in float roughness) {
    c(float) steepness = 0.6;
    c(float) strength = 3.75 * steepness;
    c(float) blockAttenuation = LIGHTMAPS_BLOCK_ATTENUATION;
    c(float) skyAttenuation = LIGHTMAPS_SKY_ATTENUATION;
    c(vec2) attenuation = vec2(blockAttenuation, skyAttenuation);

    vec2 shading = getLightmapShading(lightmap, surfaceNormal, view, roughness, steepness);

    return pow(lightmap, attenuation) * shading * strength;
  }
#endif
