/*
  SAPPHIRE.
  JCM2606.

  Before editing anything in this file, please read "LICENSE.txt" at the root of the pack.
*/

#version 120
#extension GL_EXT_gpu_shader4 : enable

#include "/lib/common/data/ShaderStructure.glsl"
#define STAGE COMPOSITE3
#define TYPE FSH
#define SHADER NONE
#include "/lib/Syntax.glsl"

// CONST
// USED BUFFERS
#define IN_TEX0
#define IN_TEX1
#define IN_TEX2
#define IN_TEX3
#define IN_TEX4

// VARYING
varying vec2 texcoord;

flat(vec3) sunVector;
flat(vec3) moonVector;
flat(vec3) lightVector;

flat(mat2x3) lighting;

// UNIFORM
uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D colortex3;
uniform sampler2D colortex4;

uniform sampler2D depthtex0;
uniform sampler2D depthtex1;

uniform sampler2D shadowtex0;

uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;

uniform int isEyeInWater;

uniform float viewWidth;
uniform float viewHeight;
uniform float near;
uniform float far;

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

#include "/lib/composite/Reflections.glsl"

// MAIN
void main() {
  // POPULATE OBJECTS
  populateBufferObject(buffers, texcoord);
  populateSurfaces(backSurface, frontSurface, buffers, true, true);
  populateMaterials(backMaterial, frontMaterial, backSurface, frontSurface, true, true);
  populateDepths(position, texcoord);
  createViewPositions(position, texcoord, true, true);

  // CONVERT FRAME TO HDR
  buffers.tex0.rgb = toFrameHDR(buffers.tex0.rgb);

  // DRAW REFLECTIONS
  buffers.tex0.rgb = drawReflections(buffers.tex0.rgb, lighting[0]);

  // DRAW VOLUMETRIC CLOUDS
  // TODO: Volumetric clouds.

  // PERFORM DEBUGGING
  Debug();

  // CONVERT FRAME TO LDR
  buffers.tex0.rgb = toFrameLDR(buffers.tex0.rgb);

  // POPULATE OUTGOING BUFFERS
/* DRAWBUFFERS:0 */
  gl_FragData[0] = buffers.tex0;
}
