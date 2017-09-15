/*
  SAPPHIRE BASE.
  JCM2606.

  Before editing anything in this file, please read "License.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_FUNCTION
  #define INT_INCLUDED_FUNCTION

  float toGamma(in float f) { return pow(f, gammaCurveRCP); }
  vec2 toGamma(in vec2 f) { return pow(f, vec2(gammaCurveRCP)); }
  vec3 toGamma(in vec3 f) { return pow(f, vec3(gammaCurveRCP)); }
  vec4 toGamma(in vec4 f) { return pow(f, vec4(gammaCurveRCP)); }

  float toLinear(in float f) { return pow(f, gammaCurve); }
  vec2 toLinear(in vec2 f) { return pow(f, vec2(gammaCurve)); }
  vec3 toLinear(in vec3 f) { return pow(f, vec3(gammaCurve)); }
  vec4 toLinear(in vec4 f) { return pow(f, vec4(gammaCurve)); }

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
#endif
