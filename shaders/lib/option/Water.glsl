/*
  SAPPHIRE.
  JCM2606.

  Before editing anything in this file, please read "LICENSE.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_OPTION_WATER
  #define INT_INCLUDED_OPTION_WATER

  #define WATER_IMPURITY 0.15 // [0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]
  #define WATER_ABSORPTION_COEFF 0.1 // [0.025 0.05 0.075 0.1 0.125 0.15 0.175 0.2 0.225 0.25 0.275 0.3 0.325 0.35 0.375 0.4 0.425 0.45 0.475 0.5]

  c(vec3) waterColour = vec3(0.1, 0.6, 0.9);
  c(vec3) impurityColour = vec3(0.1, 0.5, 0.35) * 2.0;
#endif
