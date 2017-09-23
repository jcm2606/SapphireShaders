/*
  SAPPHIRE.
  JCM2606.

  Before editing anything in this file, please read "LICENSE.txt" at the root of the pack.
*/

#version 120
#extension GL_EXT_gpu_shader4 : enable

#include "/lib/common/data/ShaderStructure.glsl"
#define STAGE COMPOSITE4
#define TYPE FSH
#define SHADER NONE
#include "/lib/Syntax.glsl"

// CONST
// USED BUFFERS
#define IN_TEX0

// VARYING
varying vec2 texcoord;

// UNIFORM
uniform sampler2D colortex0;

uniform sampler2D depthtex0;
uniform sampler2D depthtex1;
uniform sampler2D depthtex2;

// STRUCT
#include "/lib/composite/struct/StructBuffer.glsl"
#include "/lib/composite/struct/StructPosition.glsl"

NewBufferObject(buffers);
NewPositionObject(position);

// ARBITRARY
// INCLUDES
#include "/lib/common/debugging/DebugFrame.glsl"

// MAIN
void main() {
  // POPULATE OBJECTS
  populateBufferObject(buffers, texcoord);

  // CONVERT FRAME TO HDR
  buffers.tex0.rgb = toFrameHDR(buffers.tex0.rgb);

  // DRAW DEPTH OF FIELD
  // TODO: Depth of field.

  // PERFORM DEBUGGING
  Debug();

  // CONVERT FRAME TO LDR
  buffers.tex0.rgb = toFrameLDR(buffers.tex0.rgb);

  // POPULATE OUTGOING OBJECTS
/* DRAWBUFFERS:0 */
  gl_FragData[0] = buffers.tex0;
}
