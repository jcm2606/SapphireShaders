/*
  SAPPHIRE BASE.
  JCM2606.

  Before editing anything in this file, please read "License.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_UTIL_DITHER
  #define INT_INCLUDED_UTIL_DITHER

  float bayer2(vec2 a){
    a = floor(a);
    return fract( dot(a, vec2(.5, a.y * .75)) );
  }
  #define bayer4(a)   (bayer2( .5*(a))*.25+bayer2(a))
  #define bayer8(a)   (bayer4( .5*(a))*.25+bayer2(a))
  #define bayer16(a)  (bayer8( .5*(a))*.25+bayer2(a))
  #define bayer32(a)  (bayer16(.5*(a))*.25+bayer2(a))
  #define bayer64(a)  (bayer32(.5*(a))*.25+bayer2(a))
  #define bayer128(a) (bayer64(.5*(a))*.25+bayer2(a))

  #define dither2(p)   (bayer2(  p)-.375      )
  #define dither4(p)   (bayer4(  p)-.46875    )
  #define dither8(p)   (bayer8(  p)-.4921875  )
  #define dither16(p)  (bayer16( p)-.498046875)
  #define dither32(p)  (bayer32( p)-.499511719)
  #define dither64(p)  (bayer64( p)-.49987793 )
  #define dither128(p) (bayer128(p)-.499969482)
#endif
