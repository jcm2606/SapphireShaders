/*
  SAPPHIRE BASE.
  JCM2606.

  Before editing anything in this file, please read "LICENSE.txt" at the root of the pack.
*/

#version 410 compatibility
#extension GL_EXT_gpu_shader4 : enable

#include "/lib/common/data/ShaderStructure.glsl"
#define STAGE GBUFFERS
#define TYPE VSH
#define SHADER GBUFFERS_TERRAIN
#include "/lib/Syntax.glsl"

#include "/gbuffers_main.vsh"
