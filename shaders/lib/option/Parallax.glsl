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
  #define PARALLAX_TRANSPARENT_HEIGHT_WATER 0.25 // [0.0125 0.025 0.0375 0.05 0.0625 0.075 0.0875 0.1 0.1125 0.125 0.1375 0.15 0.1625 0.175 0.1875 0.2 0.2125 0.225 0.2375 0.25 0.2625 0.275 0.2875 0.3 0.3125 0.325 0.3375 0.35 0.3625 0.375 0.3875 0.4 0.4125 0.425 0.4375 0.45 0.4625 0.475 0.4875 0.5 0.5125 0.525 0.5375 0.55 0.5625 0.575 0.5875 0.6 0.6125 0.625 0.6375 0.65 0.6625 0.675 0.6875 0.7 0.7125 0.725 0.7375 0.75 0.7625 0.775 0.7875 0.8 0.8125 0.825 0.8375 0.85 0.8625 0.875 0.8875 0.9 0.9125 0.925 0.9375 0.95 0.9625 0.975 0.9875 1.0 ]
  #define PARALLAX_TRANSPARENT_HEIGHT_ICE 0.2
  #define PARALLAX_TRANSPARENT_HEIGHT_GLASS 0.2

  c(float) parallaxHeightWater = PARALLAX_TRANSPARENT_HEIGHT_WATER * 4.8;
#endif
