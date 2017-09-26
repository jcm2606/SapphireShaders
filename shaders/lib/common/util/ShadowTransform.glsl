/*
  SAPPHIRE BASE.
  JCM2606.

  Before editing anything in this file, please read "License.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_UTIL_SHADOWTRANSFORM
  #define INT_INCLUDED_UTIL_SHADOWTRANSFORM

  #include "/lib/common/util/SpaceTransform.glsl"

  mat4 shadowMVP = shadowProjection * shadowModelView;

  vec3 getShadowPosition(in vec3 world) {
    return transMAD(shadowMVP, world) * 0.5 + 0.5;
  }

  c(float) shadowBias = SHADOW_BIAS;
  c(float) shadowBiasInverse = 1.0 - shadowBias;

  vec2 distortShadowPosition(in vec2 shadow, in int rangeConversion) {
    shadow = (rangeConversion == 0) ? shadow : shadow * 2.0 - 1.0;

    shadow /= flength(shadow) * shadowBias + shadowBiasInverse;

    shadow = (rangeConversion == 0) ? shadow : shadow * 0.5 + 0.5;

    return shadow;
  }
#endif
