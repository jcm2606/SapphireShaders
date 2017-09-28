/*
  SAPPHIRE BASE.
  JCM2606.

  Before editing anything in this file, please read "License.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_SYNTAX_FUNCTION
  #define INT_INCLUDED_SYNTAX_FUNCTION

  float toGamma(in float f) { return pow(f, screenGammaCurveRCP); }
  vec2 toGamma(in vec2 f) { return pow(f, vec2(screenGammaCurveRCP)); }
  vec3 toGamma(in vec3 f) { return pow(f, vec3(screenGammaCurveRCP)); }
  vec4 toGamma(in vec4 f) { return pow(f, vec4(screenGammaCurveRCP)); }

  float toLinear(in float f) { return pow(f, screenGammaCurve); }
  vec2 toLinear(in vec2 f) { return pow(f, vec2(screenGammaCurve)); }
  vec3 toLinear(in vec3 f) { return pow(f, vec3(screenGammaCurve)); }
  vec4 toLinear(in vec4 f) { return pow(f, vec4(screenGammaCurve)); }

  float toGamma(in float f, in float curve) { return pow(f, curve); }
  vec2 toGamma(in vec2 f, in float curve) { return pow(f, vec2(curve)); }
  vec3 toGamma(in vec3 f, in float curve) { return pow(f, vec3(curve)); }
  vec4 toGamma(in vec4 f, in float curve) { return pow(f, vec4(curve)); }

  float toLinear(in float f, in float curve) { return pow(f, curve); }
  vec2 toLinear(in vec2 f, in float curve) { return pow(f, vec2(curve)); }
  vec3 toLinear(in vec3 f, in float curve) { return pow(f, vec3(curve)); }
  vec4 toLinear(in vec4 f, in float curve) { return pow(f, vec4(curve)); }

  float toLDR(in float f, in float range) { return toGamma(f * range); }
  vec2 toLDR(in vec2 f, in float range) { return toGamma(f * range); }
  vec3 toLDR(in vec3 f, in float range) { return toGamma(f * range); }
  vec4 toLDR(in vec4 f, in float range) { return toGamma(f * range); }

  float toHDR(in float f, in float range) { return toLinear(f) * range; }
  vec2 toHDR(in vec2 f, in float range) { return toLinear(f) * range; }
  vec3 toHDR(in vec3 f, in float range) { return toLinear(f) * range; }
  vec4 toHDR(in vec4 f, in float range) { return toLinear(f) * range; }

  #define toFrameLDR(col) toLDR(col, dynamicRangeFrameRCP)
  #define toFrameHDR(col) toHDR(col, dynamicRangeFrame)

  #define toShadowLDR(col) toLDR(col, dynamicRangeShadowRCP)
  #define toShadowHDR(col) toHDR(col, dynamicRangeShadow)

  #define toFogLDR(col) toLDR(col, dynamicRangeFogRCP)
  #define toFogHDR(col) toHDR(col, dynamicRangeFog)

  float flengthsqr(in vec2 n) { return dot(n, n); }
  float flengthsqr(in vec3 n) { return dot(n, n); }
  float flengthsqr(in vec4 n) { return dot(n, n); }

  float flength(in vec2 n) { return sqrt(flengthsqr(n)); }
  float flength(in vec3 n) { return sqrt(flengthsqr(n)); }
  float flength(in vec4 n) { return sqrt(flengthsqr(n)); }

  float flengthinv(in vec2 n) { return inversesqrt(flengthsqr(n)); }
  float flengthinv(in vec3 n) { return inversesqrt(flengthsqr(n)); }
  float flengthinv(in vec4 n) { return inversesqrt(flengthsqr(n)); }

  vec2 fnormalize(in vec2 n) { return n * flengthinv(n); }
  vec3 fnormalize(in vec3 n) { return n * flengthinv(n); }
  vec4 fnormalize(in vec4 n) { return n * flengthinv(n); }

  bool comparef(in float a, in float b, const in float width) { return abs(a - b) < width; }

  bool checkNAN(in float f) { return (f < 0.0 || 0.0 < f || f == 0.0) ? false : true; }

  float cflattenf(in float f, c(in float) weight) { c(float) weightInverse = 1.0 - weight; return f * weight + weightInverse; }
  vec2 cflatten2(in vec2 f, c(in float) weight) { c(float) weightInverse = 1.0 - weight; return f * weight + weightInverse; }
  vec3 cflatten3(in vec3 f, c(in float) weight) { c(float) weightInverse = 1.0 - weight; return f * weight + weightInverse; }
  vec4 cflatten4(in vec4 f, c(in float) weight) { c(float) weightInverse = 1.0 - weight; return f * weight + weightInverse; }

  float compareShadow(in float depth, in float comparison) { return clamp01(1.0 - max0(comparison - depth) * float(shadowMapResolution)); }

  c(vec3) lumaCoeff = vec3(0.2125, 0.7154, 0.0721);
  float getLuma(in vec3 colour) { return dot(colour, lumaCoeff); }

  vec3 saturation(in vec3 colour, in float saturation) { return mix(colour, vec3(getLuma(colour)), saturation); }

  #define getLinearDepth(depth) linearDepth(depth, near, far)
  float linearDepth(in float depth, in float near, in float far) { return 2.0 * near * far / (far + near - (depth * 2.0 - 1.0) * (far - near)); }

  #define getExpDepth(depth) expDepth(depth, near, far)
  float expDepth(in float dist, in float near, in float far) { return (far * (dist - near)) / (dist * (far - near)); }
#endif
