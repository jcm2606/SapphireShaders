/*
  SAPPHIRE BASE.
  JCM2606.

  Before editing anything in this file, please read "LICENSE.txt" at the root of the pack.
*/

#version 120
#extension GL_EXT_gpu_shader4 : enable

#include "/lib/common/data/ShaderStructure.glsl"
#define STAGE SHADOW
#define TYPE VSH
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
attribute vec4 mc_Entity;
attribute vec4 at_tangent;

uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowProjection;
uniform mat4 shadowModelView;
uniform mat4 shadowModelViewInverse;

uniform vec3 cameraPosition;

uniform int isEyeInWater;

// STRUCT
// ARBITRARY
// INCLUDES
#include "/lib/common/util/ShadowTransform.glsl"

// MAIN
void main() {
  colour = gl_Color;

  uvcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
  lmcoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;

  vec3 position = deprojectVertex(shadowModelViewInverse, gl_ModelViewMatrix, gl_Vertex.xyz);
  world = position + cameraPosition;

  entity = mc_Entity.xz;

  #include "/lib/gbuffer/Materials.glsl"

  gl_Position = reprojectVertex(shadowModelView, position);
  
  shadow = gl_Position.xyz;

  gl_Position.xy = distortShadowPosition(gl_Position.xy, 0);

  ttn = mat3(0.0);

  normal = fnormalize(gl_NormalMatrix * gl_Normal);

  ttn[0] = fnormalize(gl_NormalMatrix * at_tangent.xyz);
  ttn[1] = cross(ttn[0], normal);
  ttn[2] = normal;
}

#undef uvcoord
#undef lmcoord
