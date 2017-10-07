/*
  SAPPHIRE.
  JCM2606.

  Before editing anything in this file, please read "License.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_OPTION_VOLUMETRICS
  #define INT_INCLUDED_OPTION_VOLUMETRICS

  #define VOLUMETRICS // Enables rendering of volumetrics within the scene. This includes various effects such as volumetric light, volumetric fog, volumetric scattering in water, etc. Does not include volumetric clouds.

  #define VOLUMETRICS_SHADOW_SKY_APPROXIMATION // Should volumetrics use an approximation for skylight shadowing? When disabled, skylight will just be shadowed alongside direct light. Unfortunately, with the limits that Optifine imposes unto us, there isn't an easy way to calculate shadowing of skylight within a volume.
#endif
