/*
  SAPPHIRE.
  JCM2606.

  Before editing anything in this file, please read "LICENSE.txt" at the root of the pack.
*/

#version 120
#extension GL_EXT_gpu_shader4 : enable

#include "/lib/common/data/ShaderStructure.glsl"
#define STAGE COMPOSITE2
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

// UNIFORM
uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D colortex3;
uniform sampler2D colortex4;

uniform sampler2D depthtex0;
uniform sampler2D depthtex1;

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

// MAIN
void main() {
  // POPULATE OBJECTS
  populateBufferObject(buffers, texcoord);
  populateSurfaces(backSurface, frontSurface, buffers, true, true);
  populateMaterials(backMaterial, frontMaterial, backSurface, frontSurface, true, true);

  // CONVERT FRAME TO HDR
  buffers.tex0.rgb = toFrameHDR(buffers.tex0.rgb);

  // CALCULATE REFRACTION OFFSET
  // TODO: Refraction.

  // DRAW REFRACTION
  // TODO: Refraction.

  // APPLY FRONT ALBEDO TO FRAME
  buffers.tex0.rgb *= (any(greaterThan(frontSurface.albedo, vec3(0.0)))) ? frontSurface.albedo : vec3(1.0);

  // DRAW DEPTH FOG
  // TODO: Depth fog.

  // DRAW VOLUMETRIC FOG
  // TODO: Volumetric fog.

  // PERFORM DEBUGGING
  Debug();

  // CONVERT FRAME TO LDR
  buffers.tex0.rgb = toFrameLDR(buffers.tex0.rgb);

  // POPULATE OUTGOING BUFFERS
/* DRAWBUFFERS:0 */
  gl_FragData[0] = buffers.tex0;
}
