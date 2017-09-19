/*
  SAPPHIRE BASE.
  JCM2606.

  Before editing anything in this file, please read "LICENSE.txt" at the root of the pack.
*/

#version 120
#extension GL_EXT_gpu_shader4 : enable

#include "/lib/common/data/ShaderStructure.glsl"
#define STAGE SHADOW
#define TYPE FSH
#define SHADER NONE
#include "/lib/Syntax.glsl"

// CONST
// VARYING
varying mat3 ttn;

varying vec4 coordinates;
varying vec4 colour;

varying vec3 world;
varying vec3 shadow;
varying vec3 normal;

flat(vec2) entity;

flat(float) material;

#define uvcoord coordinates.xy
#define lmcoord coordinates.zw

// UNIFORM
uniform sampler2D texture;

// STRUCT
// ARBITRARY
// INCLUDES
// MAIN
void main() {
  vec4 albedo = texture2D(texture, uvcoord);

  gl_FragData[0] = albedo;
}

#undef uvcoord
#undef lmcoord
