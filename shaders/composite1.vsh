/*
  SAPPHIRE.
  JCM2606.

  Before editing anything in this file, please read "LICENSE.txt" at the root of the pack.
*/

#version 120
#extension GL_EXT_gpu_shader4 : enable

#include "/lib/common/data/ShaderStructure.glsl"
#define STAGE COMPOSITE1
#define TYPE VSH
#define SHADER NONE
#include "/lib/Syntax.glsl"

// CONST
// VARYING
varying vec2 texcoord;

flat(vec3) sunVector;
flat(vec3) moonVector;
flat(vec3) lightVector;

flat(vec4) timeVector;

// UNIFORM
uniform vec3 sunPosition;

uniform float sunAngle;

// STRUCT
// ARBITRARY
// INCLUDES
// MAIN
void main() {
  gl_Position = ftransform();

  texcoord = gl_MultiTexCoord0.xy;

  getSunVector();
  getMoonVector();
  getLightVector();
}
