/*
  SAPPHIRE BASE.
  JCM2606.

  Before editing anything in this file, please read "License.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_SETTINGS
  #define INT_INCLUDED_SETTINGS

  // BUFFER FORMATS
  /*
    const int colortex0Format = RGBA16;
    const int colortex1Format = RGB32F;
    const int colortex2Format = RGB32F;
    const int colortex3Format = RGB32F;
    const int colortex4Format = RGB32F;
  */

  // OPTIFINE OPTIONS
  const int shadowMapResolution = 2048; // [512 1024 2048 4096 8192]
  const int noiseTextureResolution = 256;
  cRCP(float, noiseTextureResolution);

  const float wetnessHalflife = 400.0;
  const float drynessHalflife = 20.0;
  const float sunPathRotation = -30.0;
  const float centerDepthHalflife = 2.0;
  const float ambientOcclusionLevel = 0.0f; // This should be set to 0.0f to disable Minecraft's AO. Minecraft's AO breaks the encoding method used for albedo. [0.0f 1.0f]

  // OPTION INCLUDES
  #include "/lib/option/Vanilla.glsl"
  #include "/lib/option/Normals.glsl"
  #include "/lib/option/Shadows.glsl"
  #include "/lib/option/Surface.glsl"
  #include "/lib/option/Lightmaps.glsl"
  #include "/lib/option/Parallax.glsl"

  // OPTIONS
  #define TEXTURE_RESOLUTION 128.0 // [16.0 32.0 64.0 128.0 256.0 512.0 1024.0 2048.0 4096.0 8192.0]

  c(float) screenGammaCurve = 2.2; // [1.0 1.2 1.4 1.6 1.8 2.0 2.2 2.4 2.6 2.8 3.0]
  cRCP(float, screenGammaCurve);

  c(float) albedoGammaCurve = 4.4;
  cRCP(float, albedoGammaCurve);

  c(float) dynamicRangeFrame = 48.0;
  cRCP(float, dynamicRangeFrame);

  c(float) dynamicRangeShadow = 4.0;
  cRCP(float, dynamicRangeShadow);

  c(float) dynamicRangeFog = 48.0;
  cRCP(float, dynamicRangeFog);

  c(float) materialRange = 255.0;
  cRCP(float, materialRange);
#endif
