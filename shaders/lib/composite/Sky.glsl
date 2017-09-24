/*
  SAPPHIRE.
  JCM2606.

  Before editing anything in this file, please read "License.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_COMPOSITE_SKY
  #define INT_INCLUDED_COMPOSITE_SKY

  #include "/lib/composite/Atmosphere.glsl"

  vec3 drawSky(in vec3 colour, in vec3 dir, in int mode) {
    if(getLandMask(position.depthBack) && mode == 0) return colour;

    return getAtmosphere(vec3(0.0), normalize(dir), mode);
  }
#endif
