/*
  SAPPHIRE.
  JCM2606.

  Before editing anything in this file, please read "License.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_COMPOSITE_WATERABSORPTION
  #define INT_INCLUDED_COMPOSITE_WATERABSORPTION

  vec3 absorbWater(in float dist) { return pow(waterColour, vec3(dist) * WATER_ABSORPTION_COEFF); }

  vec3 scatterWater(in vec3 background, in vec3 impurityAlbedo, in float dist) { return mix(impurityAlbedo, background, exp2(-dist * waterImpurity)); }

  vec3 interactWater(in vec3 background, in vec3 impurityAlbedo, in float dist) { return scatterWater(background * absorbWater(dist), impurityAlbedo, dist); }

  float diffuseWater(in float dist) {
    return max0(exp2(-dist * waterDiffusionFactor));
  }

  vec3 getWaterLightInteraction(in vec3 colour, in vec3 lightColour, in float dist) {
    return mix(
      impurityColour * lightColour,
      colour,
      (exp2(-dist * waterImpurity))
    ) * absorbWater(dist);
  }
#endif
