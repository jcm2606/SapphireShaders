/*
  SAPPHIRE BASE.
  JCM2606.

  Before editing anything in this file, please read "License.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_SETTINGS
  #define INT_INCLUDED_SETTINGS

  // OPTION INCLUDES
  // OPTIONS
  c(float) gammaCurve = 2.2; // [1.0 1.2 1.4 1.6 1.8 2.0 2.2 2.4 2.6 2.8 3.0]
  cRCP(float, gammaCurve);

  c(float) dynamicRangeFrame = 48.0;
  cRCP(float, dynamicRangeFrame);

  c(float) dynamicRangeShadow = 4.0;
  cRCP(float, dynamicRangeShadow);

  c(float) dynamicRangeFog = 48.0;
  cRCP(float, dynamicRangeFog);
#endif
