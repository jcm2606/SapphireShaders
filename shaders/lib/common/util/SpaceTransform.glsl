/*
  SAPPHIRE BASE.
  JCM2606.

  Before editing anything in this file, please read "License.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_UTIL_SPACETRANSFORM
  #define INT_INCLUDED_UTIL_SPACETRANSFORM

  float fovScale = gbufferProjection[1][1] * tan(atan(1.0 / gbufferProjection[1][1]) * 0.85);

  vec3 getViewPosition(in vec2 texcoord, in float depth) {
    vec4 vpos = projMAD4(gbufferProjectionInverse, (vec3(texcoord, depth) * 2.0 - 1.0).xyzz);
    vpos /= vpos.w;

    if(isEyeInWater == 1) vpos.xy *= fovScale;

    return vpos.xyz;
  }

  vec3 getWorldPosition(in vec3 view) {
    return transMAD(gbufferModelViewInverse, view);
  }

  #ifdef INT_INCLUDED_STRUCT_POSITION
    void createViewPositions(io Position position, in vec2 texcoord, in bool back, in bool front) {
      if(back) position.viewPositionBack = getViewPosition(texcoord, position.depthBack);
      if(front) position.viewPositionFront = getViewPosition(texcoord, position.depthFront);
    }

    void createWorldPositions(io Position position, in bool back, in bool front) {
      if(back) position.worldPositionBack = getWorldPosition(position.viewPositionBack);
      if(front) position.worldPositionFront = getWorldPosition(position.viewPositionFront);
    }
  #endif
#endif
