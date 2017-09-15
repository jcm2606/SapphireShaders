/*
  SAPPHIRE BASE.
  JCM2606.

  Before editing anything in this file, please read "LICENSE.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_SURFACE
  #define INT_INCLUDED_SURFACE

  struct Surface {
    vec3 albedo;

    float skyLight;
    float blockLight;

    vec4 surfaceProperties;
    float roughness;
    float f0;
    float emission;
    float porosity;

    float material;
  };

  #define NewSurfaceObject(name) Surface name = Surface(vec3(0.0), 0.0, 0.0, vec4(1.0, 0.02, 0.0, 0.0), 1.0, 0.02, 0.0, 0.0, 0.0)

  void populateSurfaceObject(io Surface surface, in mat2x4 buffers, in vec2 texcoord) {
    // TODO
  }
#endif