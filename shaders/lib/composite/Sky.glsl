/*
  SAPPHIRE.
  JCM2606.

  Before editing anything in this file, please read "License.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_COMPOSITE_SKY
  #define INT_INCLUDED_COMPOSITE_SKY

  #include "/lib/composite/Atmosphere.glsl"

  #if TYPE == FSH
    #include "/lib/composite/Stars.glsl"
  #endif

  vec3 drawSky(in vec3 colour, in vec3 dir, in int mode) {
    #if TYPE == FSH
     if(getLandMask(position.depthBack) && mode == 0) return colour;
    #endif

    return getAtmosphere(
      #if TYPE == FSH
        drawStars(dir)
      #else
        vec3(0.0)
      #endif  
    , fnormalize(dir), mode);
  }
#endif
