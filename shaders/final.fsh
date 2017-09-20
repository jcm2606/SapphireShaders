/*
  SAPPHIRE BASE.
  JCM2606.

  Before editing anything in this file, please read "LICENSE.txt" at the root of the pack.
*/

#version 120
#extension GL_EXT_gpu_shader4 : enable

#include "/lib/common/data/ShaderStructure.glsl"
#define STAGE FINAL
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

// STRUCT
#include "/lib/composite/struct/StructBuffer.glsl"

NewBufferObject(buffers);

// ARBITRARY
// INCLUDES
#include "/lib/common/debugging/DebugFrame.glsl"

#include "/lib/final/Tonemap.glsl"

// MAIN
void main() {
  populateBufferObject(buffers, texcoord);

  buffers.tex0.rgb = toFrameHDR(buffers.tex0.rgb);

  buffers.tex0.rgb = tonemap(buffers.tex0.rgb);
  buffers.tex0.rgb = toGamma(buffers.tex0.rgb);

  gl_FragColor = buffers.tex0;
}
