/*
  SAPPHIRE BASE.
  JCM2606.

  Before editing anything in this file, please read "License.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_UTIL_DIFFUSEMODEL
  #define INT_INCLUDED_UTIL_DIFFUSEMODEL

  float lambert(in vec3 normal, in vec3 light) {
    return max0(dot(normal, light));
  }

  float orenNayer(in vec3 view, in vec3 light, in vec3 normal, in float roughness) {
    roughness = pow2(roughness);

    float NdotL = dot(normal, light);
    float NdotV = dot(normal, view);

    float t = max(NdotL, NdotV);
    float g = max0(dot(view - normal * NdotV, light - normal * NdotL));

    return max0(NdotL) * ((0.45 * roughness / (roughness + 0.09)) * (g / t - g * t) + (0.285 / (roughness + 0.57) + 0.5));
  }
#endif
