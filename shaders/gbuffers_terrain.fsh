/*
  SAPPHIRE BASE.
  JCM2606.

  Before editing anything in this file, please read "LICENSE.txt" at the root of the pack.
*/

#version 120
#extension GL_EXT_gpu_shader4 : enable

#include "/lib/common/data/ShaderStructure.glsl"
#define STAGE GBUFFERS
#define TYPE FSH
#define SHADER GBUFFERS_TERRAIN
#include "/lib/Syntax.glsl"

/* DRAWBUFFERS:12 */
#include "/gbuffers_main.fsh"
