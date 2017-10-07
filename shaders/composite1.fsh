/*
  SAPPHIRE.
  JCM2606.

  Before editing anything in this file, please read "LICENSE.txt" at the root of the pack.
*/

#version 120
#extension GL_EXT_gpu_shader4 : enable

#include "/lib/common/data/ShaderStructure.glsl"
#define STAGE COMPOSITE1
#define TYPE FSH
#define SHADER NONE
#include "/lib/Syntax.glsl"

// CONST
// USED BUFFERS
#define IN_TEX1
#define IN_TEX2
#define IN_TEX3

// VARYING
varying vec2 texcoord;

flat(vec3) sunVector;
flat(vec3) moonVector;
flat(vec3) lightVector;

flat(vec4) timeVector;

flat(mat2x3) lighting;

// UNIFORM
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D colortex3;

uniform sampler2D depthtex0;
uniform sampler2D depthtex1;

uniform sampler2D shadowtex0;
uniform sampler2D shadowtex1;
uniform sampler2D shadowcolor0;
uniform sampler2D shadowcolor1;

uniform sampler2D noisetex;

uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowProjection;
uniform mat4 shadowModelView;

uniform vec3 cameraPosition;

uniform float viewWidth;
uniform float viewHeight;
uniform float near;
uniform float far;
uniform float rainStrength;
uniform float frameTimeCounter;

uniform int isEyeInWater;

uniform ivec2 eyeBrightnessSmooth;

// STRUCT
#include "/lib/composite/struct/StructBuffer.glsl"
#include "/lib/composite/struct/StructPosition.glsl"
#include "/lib/composite/struct/StructSurface.glsl"
#include "/lib/composite/struct/StructMaterial.glsl"

NewBufferObject(buffers);
NewPositionObject(position);
NewSurfaceObject(backSurface);
NewSurfaceObject(frontSurface);
NewMaterialObject(backMaterial);
NewMaterialObject(frontMaterial);

// ARBITRARY
// INCLUDES
#include "/lib/common/debugging/DebugFrame.glsl"

#include "/lib/common/util/ShadowTransform.glsl"

#include "/lib/composite/Sky.glsl"

#include "/lib/composite/Shading.glsl"

#include "/lib/composite/Volumetrics.glsl"

// MAIN
void main() {
  // POPULATE OBJECTS
  populateBufferObject(buffers, texcoord);
  populateSurfaces(backSurface, frontSurface, buffers, true, true);
  populateMaterials(backMaterial, frontMaterial, backSurface, frontSurface, true, true);
  populateDepths(position, texcoord);
  createViewPositions(position, texcoord, true, true);

  // SET FRAME TO BACK ALBEDO
  buffers.tex0.rgb = backSurface.albedo;

  // DRAW SKY
  buffers.tex0.rgb = drawSky(buffers.tex0.rgb, position.viewPositionBack, 0);

  // PERFORM SHADING ON FRAME
  float frontOcclusion = 0.0;
  buffers.tex0.rgb = getShadedFragment(frontOcclusion, buffers.tex0.rgb, lighting);

  // SAMPLE VOLUMETRICS
  buffers.tex6.rgb = getVolumetrics(lighting, position.viewPositionBack);

  // SEND FRONT SHADOW DOWN FOR SPECULAR HIGHLIGHT
  buffers.tex0.a = frontOcclusion;

  // PERFORM DEBUGGING
  Debug();

  // CONVERT FRAME TO LDR
  buffers.tex0.rgb = toFrameLDR(buffers.tex0.rgb);

  // POPULATE OUTGOING BUFFERS
/* DRAWBUFFERS:06 */
  gl_FragData[0] = buffers.tex0;
  gl_FragData[1] = buffers.tex6;
}
