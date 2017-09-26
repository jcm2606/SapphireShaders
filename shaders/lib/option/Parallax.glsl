/*
  SAPPHIRE BASE.
  JCM2606.

  Before editing anything in this file, please read "LICENSE.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_OPTION_PARALLAX
  #define INT_INCLUDED_OPTION_PARALLAX

  #define PARALLAX_TERRAIN
  //#define PARALLAX_TERRAIN_QUALITY_SCALING // When enabled, the quality of terrain parallax scales with texture resolution, making parallax much more accurate, at the cost of performance.
  #define PARALLAX_TERRAIN_QUALITY_FIXED 32 // When quality scaling is disabled, this setting is used instead. [16 32 64 128 256]
  #define PARALLAX_TERRAIN_DEPTH 0.6 // The depth of the parallax effect. Turn it down to make parallax shallower, up to make it deeper. [0.02 0.04 0.06 0.08 0.1 0.12 0.14 0.16 0.18 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]

  #define PARALLAX_TRANSPARENT
  #define PARALLAX_TRANSPARENT_STEPS 4
  #define PARALLAX_TRANSPARENT_HEIGHT_WATER 1.0
  #define PARALLAX_TRANSPARENT_HEIGHT_ICE 0.2
  #define PARALLAX_TRANSPARENT_HEIGHT_GLASS 0.2
#endif
