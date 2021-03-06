/*
  SAPPHIRE BASE.
  JCM2606.

  Before editing anything in this file, please read "LICENSE.txt" at the root of the pack.
*/

#version 120
#extension GL_EXT_gpu_shader4 : enable

#include "/lib/common/data/ShaderStructure.glsl"
#define STAGE SHADOW
#define TYPE FSH
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
uniform sampler2D texture;

uniform sampler2D noisetex;

uniform float frameTimeCounter;

// STRUCT
// ARBITRARY
// INCLUDES
#include "/lib/common/normal/Normals.glsl"

// MAIN
void main() {
  vec4 albedo = texture2D(texture, uvcoord) * colour;

  vec4 customNormal = vec4(0.0);
  if(comparef(material, MATERIAL_WATER, ubyteMaxRCP) || comparef(material, MATERIAL_ICE, ubyteMaxRCP) || comparef(material, MATERIAL_STAINED_GLASS, ubyteMaxRCP)) {
    customNormal.xyz = getNormal(world, material);
    customNormal.a = getHeight(world, material);
  }

  if(comparef(material, MATERIAL_WATER, ubyteMaxRCP)) {
    vec3 nworld = fnormalize(world);
    vec3 refractPos = refract(nworld, customNormal.xyz, refractInterfaceAirWater);
    float newArea = flength(dFdx(refractPos)) * flength(dFdy(refractPos));

    albedo.rgb = toGamma(vec3(mix(mix(0.35, 0.5, customNormal.x + customNormal.y), 1.5, pow((flength(dFdx(world)) * flength(dFdy(world))) / newArea, 0.2))));
  }

  albedo.rgb = toShadowLDR(albedo.rgb);

  gl_FragData[0] = albedo;
  gl_FragData[1] = vec4(vec3(0.0), material * materialRangeRCP);
}

#undef uvcoord
#undef lmcoord
