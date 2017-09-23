/*
  SAPPHIRE.
  JCM2606.

  Before editing anything in this file, please read "LICENSE.txt" at the root of the pack.
*/

#version 120
#extension GL_EXT_gpu_shader4 : enable

#include "/lib/common/data/ShaderStructure.glsl"
#define STAGE COMPOSITE5
#define TYPE FSH
#define SHADER NONE
#include "/lib/Syntax.glsl"

// CONST
// USED BUFFERS
// VARYING
varying vec2 texcoord;

// UNIFORM
uniform sampler2D colortex0;

// STRUCT
#include "/lib/composite/struct/StructBuffer.glsl"

NewBufferObject(buffers);

// ARBITRARY
// INCLUDES
#include "/lib/common/debugging/DebugFrame.glsl"

// MAIN
void main() {
  // SAMPLE BLOOM
  // TODO: Bloom.

  // POPULATE OUTGOING BUFFERS
/* DRAWBUFFERS:5 */
  gl_FragData[0] = buffers.tex5;
}
