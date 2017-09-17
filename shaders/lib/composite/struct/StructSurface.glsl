/*
  SAPPHIRE BASE.
  JCM2606.

  Before editing anything in this file, please read "LICENSE.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_STRUCT_SURFACE
  #define INT_INCLUDED_STRUCT_SURFACE

  struct Surface {
    vec3 albedo;

    vec3 normal;

    float skyLight;
    float blockLight;

    vec4 surfaceProperties;
    float roughness;
    float f0;
    float emission;
    float porosity;

    float material;
  };

  #define SurfaceObject() Surface(vec3(0.0), vec3(0.0), 0.0, 0.0, vec4(1.0, 0.02, 0.0, 0.0), 1.0, 0.02, 0.0, 0.0, 0.0)
  #define NewSurfaceObject(name) Surface name = SurfaceObject()

  #include "/lib/common/util/Encoding.glsl"

  void populateSurfaceObject(io Surface surface, in mat2x4 buffers) {
    // ALBEDO
    surface.albedo = decodeColour(buffers[0].x);
    surface.albedo = toLinear(surface.albedo, albedoGammaCurve);

    // LIGHTMAP
    vec2 lightmap = toLinear(decode2x8(buffers[0].y));
    surface.blockLight = lightmap.x;
    surface.skyLight = lightmap.y;

    // MATERIAL
    surface.material = buffers[0].z;

    // NORMAL
    surface.normal = decodeNormal(buffers[1].x);

    // SURFACE PROPERTIES
    surface.surfaceProperties = vec4(
      decode2x8(buffers[1].y),
      decode2x8(buffers[1].z)
    );
    surface.roughness = surface.surfaceProperties.x;
    surface.f0 = surface.surfaceProperties.y;
    surface.emission = surface.surfaceProperties.z;
    surface.porosity = surface.surfaceProperties.w;
  }

  void populateSurfaces(io Surface backSurface, io Surface frontSurface, io Buffer buffers, in bool back, in bool front) {
    if(back) populateSurfaceObject(backSurface, mat2x4(buffers.tex1, buffers.tex2));
    if(front) populateSurfaceObject(frontSurface, mat2x4(buffers.tex3, buffers.tex4));
  }
#endif