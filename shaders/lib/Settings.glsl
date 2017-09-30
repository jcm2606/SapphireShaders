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
    const int colortex5Format = RGBA16;
    const int colortex6Format = RGBA16;
  */

  // OPTIFINE OPTIONS
  const int shadowMapResolution = 2048; // [512 1024 2048 4096 8192]
  cRCP(float, shadowMapResolution);
  const int noiseTextureResolution = 256;
  cRCP(float, noiseTextureResolution);

  const float wetnessHalflife = 400.0;
  const float drynessHalflife = 20.0;
  const float sunPathRotation = -30.0;
  const float centerDepthHalflife = 2.0;
  const float ambientOcclusionLevel = 0.0f; // This should be set to 0.0f to disable Minecraft's AO. Minecraft's AO breaks the encoding method used for albedo. [0.0f 1.0f]

  // OPTION INCLUDES
  #include "/lib/option/Debugging.glsl"
  #include "/lib/option/Vanilla.glsl"
  #include "/lib/option/Normals.glsl"
  #include "/lib/option/Shadows.glsl"
  #include "/lib/option/Surface.glsl"
  #include "/lib/option/Lightmaps.glsl"
  #include "/lib/option/Parallax.glsl"
  #include "/lib/option/Post.glsl"
  #include "/lib/option/Lighting.glsl"
  #include "/lib/option/Water.glsl"
  #include "/lib/option/Reflections.glsl"
  #include "/lib/option/Volumetrics.glsl"

  // OPTIONS
  #define GLOBAL_SPEED 1.0 // [0.03125 0.0625 0.125 0.2 0.25 0.4 0.5 0.6 0.8 1.0 1.2 1.4 1.6 1.8 2.0 4.0 8.0 16.0]
  #define frametime (frameTimeCounter * GLOBAL_SPEED)

  #ifndef MC_SEA_LEVEL
    #define MC_SEA_LEVEL 63.0 // The height of the water plane in the world. Change this depending on your world so certain effects work properly. [4.0 8.0 12.0 16.0 20.0 24.0 28.0 32.0 36.0 40.0 44.0 48.0 52.0 56.0 60.0 63.0 64.0 68.0 72.0 76.0 80.0 84.0 88.0 92.0 96.0 100.0 104.0 108.0 112.0 116.0 120.0 124.0 128.0 132.0 136.0 140.0 144.0 148.0 152.0 156.0 160.0 164.0 168.0 172.0 176.0 180.0 184.0 188.0 192.0 196.0 200.0 204.0 208.0 212.0 216.0 220.0 224.0 228.0 232.0 236.0 240.0 244.0 248.0 252.0]
  #endif

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

  c(float) shadowDepthBlocks = 256.0; // How many blocks does the depth encompass? A depth of 1.0 represents X blocks.
  c(float) shadowDepthMult = 256 / shadowDepthBlocks;
#endif
