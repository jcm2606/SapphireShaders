/*
  SAPPHIRE.
  JCM2606.

  Before editing anything in this file, please read "License.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_OPTION_VOLUMETRICS
  #define INT_INCLUDED_OPTION_VOLUMETRICS

  #define VOLUMETRICS

  #define VOLUMETRICS_SKY_SHADOW // Forces sky light contribution to be occluded by shadows. Unfortunately there isn't a way to do occlusion checks for sky lighting in a volume, so this is used as an alternative, but incorrect method of occlusion.
#endif
