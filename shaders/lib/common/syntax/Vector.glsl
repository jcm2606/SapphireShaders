/*
  SAPPHIRE BASE.
  JCM2606.

  Before editing anything in this file, please read "LICENSE.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_VECTOR
  #define INT_INCLUDED_VECTOR

  const vec2 swizzle2 = vec2(1.0, 0.0);
  const vec3 swizzle3 = vec3(1.0, 0.0, 0.5);
  const vec4 swizzle4 = vec4(1.0, 0.0, 0.5, -1.0);

  #define reverse2(v) v.yx
  #define reverse3(v) v.zyx
  #define reverse4(v) v.wzyx

  #define rot2(a) mat2(cos(a), -sin(a), sin(a), cos(a))

  void swap2(io vec2 a, io vec2 b) {
    vec2 temp = a;
    a = b;
    b = temp;
  }

  void swap3(io vec3 a, io vec3 b) {
    vec3 temp = a;
    a = b;
    b = temp;
  }
#endif
