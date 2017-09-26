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

flat(vec3) sunVector;
flat(vec3) moonVector;
flat(vec3) lightVector;

flat(mat2x3) lighting;

// UNIFORM
uniform vec3 sunPosition;

uniform float sunAngle;

uniform mat4 gbufferModelView;

// STRUCT
// ARBITRARY
// INCLUDES
#include "/lib/composite/Sky.glsl"

// MAIN
void main() {
  gl_Position = reprojectVertex(gl_ModelViewMatrix, gl_Vertex.xyz);

  texcoord = gl_MultiTexCoord0.xy;

  getSunVector();
  getMoonVector();
  getLightVector();

  #include "/lib/composite/AtmosphereLighting.glsl"
}
