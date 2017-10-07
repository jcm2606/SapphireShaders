/*
  SAPPHIRE BASE.
  JCM2606.

  Before editing anything in this file, please read "LICENSE.txt" at the root of the pack.
*/

#extension GL_ARB_shader_texture_lod : enable

// CONST
// VARYING
varying mat3 ttn;

varying vec4 coordinates;
varying vec4 colour;
varying vec4 parallaxVector;

varying vec3 world;
varying vec3 normal;
varying vec3 vertex;
varying vec3 dir;

flat(vec2) entity;

flat(float) material;
varying float dist;

#define uvcoord coordinates.xy
#define lmcoord coordinates.zw

// UNIFORM
#if SHADER != GBUFFERS_BASIC && SHADER != GBUFFERS_SKYBASIC
  uniform sampler2D texture;
  uniform sampler2D lightmap;

  #if SHADER == GBUFFERS_TERRAIN || SHADER == GBUFFERS_HAND
    uniform sampler2D normals;
    uniform sampler2D specular;
  #endif

  #if SHADER == GBUFFERS_WATER || SHADER == GBUFFERS_TERRAIN || SHADER == GBUFFERS_HAND || SHADER == GBUFFERS_ENTITIES
    uniform sampler2D noisetex;

    uniform float frameTimeCounter;
    uniform float wetness;
  #endif

  uniform mat4 gbufferProjection;
  uniform mat4 gbufferProjectionInverse;
  uniform mat4 gbufferModelViewInverse;
#endif

// STRUCT
// ARBITRARY
// INCLUDES
#if SHADER == GBUFFERS_TERRAIN || SHADER == GBUFFERS_HAND
  #define textureSample(tex, uv) texture2DGradARB(tex, uv, parallaxDerivatives[0], parallaxDerivatives[1])
#else
  #define textureSample(tex, uv) texture2D(tex, uv)
#endif

#include "/lib/common/util/Encoding.glsl"

#include "/lib/common/normal/Normals.glsl"

#include "/lib/gbuffer/Parallax.glsl"
#include "/lib/gbuffer/DirectionalLightmap.glsl"

#include "/lib/gbuffer/Puddles.glsl"

// MAIN
void main() {
  vec2 texcoord = uvcoord;

  mat2x4 buffers = mat2x4(
    vec4(0.0, 0.0, 0.0, 1.0),
    vec4(0.0, 0.0, 0.0, 1.0)
  );

  mat3 tbn = mat3(
    ttn[0].x, ttn[1].x, ttn[2].x,
    ttn[0].y, ttn[1].y, ttn[2].y,
    ttn[0].z, ttn[1].z, ttn[2].z
  );

  vec3 view = fnormalize(tbn * vertex);

  #if SHADER == GBUFFERS_TERRAIN || SHADER == GBUFFERS_HAND
    texcoord = getParallax(view);
  #endif

  #define albedoBuffer buffers[0].x
  #define lightmapBuffer buffers[0].y
  #define materialBuffer buffers[0].z
  #define normalBuffer buffers[1].x
  #define surface0Buffer buffers[1].y
  #define surface1Buffer buffers[1].z

  #include "/lib/gbuffer/Buffers.glsl"

  #undef albedoBuffer
  #undef lightmapBuffer
  #undef materialBuffer
  #undef normalBuffer
  #undef surface0Buffer
  #undef surface1Buffer

  gl_FragData[0] = buffers[0];
  gl_FragData[1] = buffers[1];
}

#undef uvcoord
#undef lmcoord
