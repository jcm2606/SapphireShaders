/*
  SAPPHIRE.
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
  // POPULATE OBJECTS
  populateBufferObject(buffers, texcoord);

  // CONVERT FRAME TO HDR
  buffers.tex0.rgb = toFrameHDR(buffers.tex0.rgb);

  // DRAW BLOOM
  // TODO: Bloom.

  // PERFORM TONEMAPPING
  buffers.tex0.rgb = tonemap(buffers.tex0.rgb);

  // CONVERT FRAME TO GAMMA SPACE
  buffers.tex0.rgb = toGamma(buffers.tex0.rgb);

  // POPULATE FRAMEBUFFER
  gl_FragColor = buffers.tex0;
}
