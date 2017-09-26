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

  #define cRCP(type, name) const ##type name##RCP = 1.0 / ##name

  #define clamp01(n) clamp(n, 0.0, 1.0)
  #define max0(n) max(n, 0.0)
  #define min1(n) min(n, 1.0)

  #define selectSurface() ((position.depthBack > position.depthFront) ? frontSurface : backSurface)
  #define selectMaterial() ((position.depthBack > position.depthFront) ? frontMaterial : backMaterial)

  #define random(x) fract(sin(dot(x, vec2(12.9898, 4.1414))) * 43758.5453)

  #define getLandMask(x) (x < (1.0 - near / far / far))

  #define getSunVector()   ( sunVector  = fnormalize( sunPosition) )
  #define getMoonVector()  ( moonVector = fnormalize(-sunPosition) )
  #define getLightVector() ( lightVector = (sunAngle > 0.5) ? moonVector : sunVector )

  #define smoothMoonPhase ( (float(worldTime) + float(moonPhase) * 24000.0) * 0.00000595238095238 )

  #define upVector gbufferModelView[1].xyz

  #define timeNoon timeVector.x
  #define timeNight timeVector.y
  #define timeHorizon timeVector.z
  #define timeMorning timeVector.w
#endif
