/*
  SAPPHIRE.
  JCM2606.

  Before editing anything in this file, please read "License.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_COMPOSITE_WATERABSORPTION
  #define INT_INCLUDED_COMPOSITE_WATERABSORPTION

  vec3 absorbWater(in float dist) { return pow(waterColour, vec3(dist) * WATER_ABSORPTION_COEFF); }
#endif
