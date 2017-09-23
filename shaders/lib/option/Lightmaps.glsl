/*
  SAPPHIRE BASE.
  JCM2606.

  Before editing anything in this file, please read "License.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_OPTION_LIGHTMAPS
  #define LIGHTMAPS_SHADING // When enabled, lightmaps on blocks will use diffuse shading to simulate directional lighting.
  #ifdef LIGHTMAPS_SHADING // Required for the damn option to show up in Optifine.
  #endif
  #define LightmapShadingModel lambert // The shading model that is used for lightmap shading. Oren Nayer and Burley are both physically-based models, where Lambert is an approximate. Oren Nayer, for some reason, is broken with some packs. [lambert orenNayer burley]

  #define LIGHTMAPS_BLOCK_ATTENUATION 2.0 // [0.6 0.8 1.0 1.2 1.4 1.6 1.8 2.0 2.2 2.4 2.6 2.8 3.0 3.2 3.4 3.6 3.8 4.0]
  #define LIGHTMAPS_SKY_ATTENUATION 2.0 // [2.0 2.2 2.4 2.6 2.8 3.0 3.2 3.4 3.6 3.8 4.0 4.2 4.4 4.6 4.8 5.0 5.2 5.4 5.6 5.8 6.0 6.2 6.4 6.6 6.8 7.0 7.2 7.4 7.6 7.8 8.0]
#endif
