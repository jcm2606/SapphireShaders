/*
  SAPPHIRE.
  JCM2606.

  Before editing anything in this file, please read "License.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_COMPOSITE_STARS
  #define INT_INCLUDED_COMPOSITE_STARS

  #include "/lib/common/util/Noise.glsl"

  #include "/lib/common/util/SpaceTransform.glsl"

  vec3 drawStars(in vec3 view) {
    #define move (frametime * vec3(1.0, 0.0, 0.0)) * 0.001

    return vec3(0.5) * pow16(simplex3D((move + normalize(getWorldPosition(view))) * 128.0));

    #undef move
  }
#endif
