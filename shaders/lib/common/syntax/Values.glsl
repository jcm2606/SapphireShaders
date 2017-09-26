/*
  SAPPHIRE BASE.
  JCM2606.

  Before editing anything in this file, please read "LICENSE.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_SYNTAX_VALUES
  #define INT_INCLUDED_SYNTAX_VALUES

  c(float) pi = 3.14159265358979;
  cRCP(float, pi);

  c(float) tau = 2.0 * pi;
  cRCP(float, tau);

  c(float) phi = 1.61803398875;
  cRCP(float, phi);

  c(float) ubyteMax = exp2(8);
  cRCP(float, ubyteMax);

  c(float) uhalfMax = exp2(16);
  cRCP(float, uhalfMax);

  c(float) uintMax = exp2(32);
  cRCP(float, uintMax);

  c(float) ulongMax = exp2(64);
  cRCP(float, ulongMax);

  c(float) iorAir = 1.0003;
  c(float) iorWater = 1.333;

  c(float) refractInterfaceAirWater = iorAir / iorWater;
  c(float) refractInterfaceWaterAir = iorWater / iorAir;
#endif
