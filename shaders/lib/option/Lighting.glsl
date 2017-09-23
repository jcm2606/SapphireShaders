/*
  SAPPHIRE.
  JCM2606.

  Before editing anything in this file, please read "License.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_OPTION_LIGHTING
  #define INT_INCLUDED_OPTION_LIGHTING

  #define LIGHTING_BLOCK_COLOUR_PRESET 0 // [0]

  #if LIGHTING_BLOCK_COLOUR_PRESET == 0
    c(vec3) lightingBlock = vec3(1.0, 0.22, 0.0);
  #endif

  #define DirectShadingModel orenNayer // [lambert orenNayer burley]
#endif
