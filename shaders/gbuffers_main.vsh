/*
  SAPPHIRE BASE.
  JCM2606.

  Before editing anything in this file, please read "LICENSE.txt" at the root of the pack.
*/

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
varying vec2 pcoord;

flat(float) material;
varying float dist;

#define uvcoord coordinates.xy
#define lmcoord coordinates.zw

// UNIFORM
attribute vec4 mc_Entity;
attribute vec4 mc_midTexCoord;
attribute vec4 at_tangent;

uniform vec3 cameraPosition;

uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;

// STRUCT
// ARBITRARY
// INCLUDES
// MAIN
void main() {
  colour = gl_Color;

  uvcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
  lmcoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;

  normal = fnormalize(gl_NormalMatrix * gl_Normal);

  entity = mc_Entity.xz;

  #if SHADER == GBUFFERS_TERRAIN || SHADER == GBUFFERS_HAND
    vec2 mid = (gl_TextureMatrix[0] * mc_midTexCoord).xy;
    vec2 uvMinusMid = gl_MultiTexCoord0.xy - mid;
    parallaxVector.zw = abs(uvMinusMid) * 2.0;
    parallaxVector.xy = min(uvcoord, mid - uvMinusMid);

    uvcoord = sign(uvMinusMid) * 0.5 + 0.5;
  #endif

  #include "/lib/gbuffer/Materials.glsl"

  #if SHADER == GBUFFERS_TERRAIN || SHADER == GBUFFERS_WATER
    vec3 position = deprojectVertex(gbufferModelViewInverse, gl_ModelViewMatrix, gl_Vertex.xyz);

    world = position + cameraPosition;
  #endif

  // FEATURE: Vertex deformation.
  // FEATURE: Waving terrain.

  #if SHADER == GBUFFERS_TERRAIN || SHADER == GBUFFERS_WATER
    gl_Position = reprojectVertex(gbufferModelView, position.xyz);
  #else
    gl_Position = reprojectVertex(gl_ModelViewMatrix, gl_Vertex.xyz);
  #endif

  vertex = (gl_ModelViewMatrix * gl_Vertex).xyz;

  #if SHADER == GBUFFERS_TERRAIN || SHADER == GBUFFERS_HAND
    dist = flength(vertex);  
  #endif

  ttn = mat3(0.0);

  ttn[0] = normalize(gl_NormalMatrix * at_tangent.xyz);
  ttn[1] = cross(ttn[0], normal);
  ttn[2] = normal;
}

#undef uvcoord
#undef lmcoord
