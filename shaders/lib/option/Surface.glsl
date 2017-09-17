/*
  SAPPHIRE BASE.
  JCM2606.

  Before editing anything in this file, please read "LICENSE.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_OPTION_SURFACE
  #define INT_INCLUDED_OPTION_SURFACE

  #define RESOURCE_FORMAT 0 // [0 1 2 3]

  c(float) f0Metal = 0.8;
  c(float) f0Dielectric = 0.02;
  c(float) f0Water = 0.05;

  #define SURFACE_PROPERTIES_TRANSPARENT vec4(0.11, f0Water, 0.0, 0.0)
  #define SURFACE_PROPERTIES_WATER vec4(0.08, f0Water, 0.0, 0.0)
  #define SURFACE_PROPERTIES_STAINED_GLASS vec4(0.33, f0Water, 0.0, 0.0)
  #define SURFACE_PROPERTIES_ICE vec4(0.05, f0Water, 0.0, 0.0)

  #define SURFACE_PROPERTIES_ENTITIES vec4(0.81, f0Dielectric, 0.0, 0.0)
#endif
