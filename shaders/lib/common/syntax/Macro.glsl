/*
  SAPPHIRE BASE.
  JCM2606.

  Before editing anything in this file, please read "LICENSE.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_SYNTAX_MACRO
  #define INT_INCLUDED_SYNTAX_MACRO

  #define io inout
  #define c(type) const type
  #define flat(type) flat varying type

  #define cRCP(type, name) c(##type) name##RCP = 1.0 / ##name

  #define clamp01(n) clamp(n, 0.0, 1.0)
  #define max0(n) max(n, 0.0)
  #define min1(n) min(n, 1.0)

  #define getSunVector()   ( sunVector  = fnormalize( sunPosition) )
  #define getMoonVector()  ( moonVector = fnormalize(-sunPosition) )
  #define getLightVector() ( lightVector = (sunAngle > 0.5) ? moonVector : sunVector )
#endif
