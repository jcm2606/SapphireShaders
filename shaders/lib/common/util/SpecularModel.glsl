/*
  SAPPHIRE BASE.
  JCM2606.

  Before editing anything in this file, please read "License.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_UTIL_SPECULARMODEL
  #define INT_INCLUDED_UTIL_SPECULARMODEL

  vec3 halfVector(in vec3 a, in vec3 b) {
    return fnormalize(a - b);
  }

  float fresnelSchlick(in float angle, in float f0) {
    return (1.0 - f0) * pow5(1.0 - max0(angle)) + f0;
  }

  float ggx(in vec3 view, in vec3 normal, in vec3 light, in float roughness, in float f0) {
    roughness = clamp(roughness, 0.05, 0.99);

    float alpha = pow2(roughness);

    vec3 halfVector = halfVector(light, view);

    float alphaSqr = pow2(alpha);

    float k2 = pow2(((f0 > 0.5) ? 0.5 : 2.0) * alpha);

    return max0(dot(normal, light)) * alphaSqr / (pi * pow2(pow2(max0(dot(normal, halfVector))) * (alphaSqr - 1.0) + 1.0)) * fresnelSchlick(dot(halfVector, light), f0) / (pow2(max0(dot(light, halfVector))) * (1.0 - k2) + k2);
  }

  float GGX (vec3 v, vec3 n, vec3 l, float r, float F0) {
    r*=r;r*=r;
    vec3 h = normalize(l + v);

    float dotLH = max(0., dot(l,h));
    float dotNH = max(0., dot(n,h));
    float dotNL = max(0., dot(n,l));
    
    float denom = (dotNH * r - dotNH) * dotNH + 1.;
    float D = r / (3.141592653589793 * denom * denom);
    float F = F0 + (1. - F0) * pow(1.-dotLH,5.);
    float k2 = .25 * r;

    return dotNL * D * F / (dotLH*dotLH*(1.0-k2)+k2);
  }
#endif
