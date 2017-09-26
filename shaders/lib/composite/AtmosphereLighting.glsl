/*
  SAPPHIRE.
  JCM2606.

  Before editing anything in this file, please read "License.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_COMPOSITE_ATMOSPHERELIGHTING
  #define INT_INCLUDED_COMPOSITE_ATMOSPHERELIGHTING

  lighting[0]  = drawSky(vec3(0.0), lightVector, 1);
  lighting[0] *= 0.02;

  lighting[1]  = drawSky(vec3(0.0), upVector, 1);
  lighting[1] *= 4.0;
#endif
