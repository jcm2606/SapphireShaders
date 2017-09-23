/*
  SAPPHIRE.
  JCM2606.

  Before editing anything in this file, please read "LICENSE.txt" at the root of the pack.
*/

#version 120
#extension GL_EXT_gpu_shader4 : enable

#include "/lib/common/data/ShaderStructure.glsl"
#define STAGE COMPOSITE3
#define TYPE VSH
#define SHADER NONE
#include "/lib/Syntax.glsl"

// CONST
// VARYING
varying vec2 texcoord;

// UNIFORM
// STRUCT
// ARBITRARY
// INCLUDES
// MAIN
void main() {
  gl_Position = ftransform();

  texcoord = gl_MultiTexCoord0.xy;
}
