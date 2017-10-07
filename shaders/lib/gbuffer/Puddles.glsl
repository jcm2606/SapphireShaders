/*
  SAPPHIRE.
  JCM2606.

  Before editing anything in this file, please read "License.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_GBUFFER_PUDDLES
  #define INT_INCLUDED_GBUFFER_PUDDLES

  #if SHADER == GBUFFERS_TERRAIN || SHADER == GBUFFERS_HAND || SHADER == GBUFFERS_WATER || SHADER == GBUFFERS_ENTITIES
    // PUDDLE GENERATION
    float getPuddleWeight(in vec3 world, in float height, in float material) {
      float puddle = 0.0;

      c(mat2) rot = rot2(0.7);

      world *= vec3(1.0, 0.7, 1.0) * 0.3;
      world.xz *= rot; puddle += texnoise3D(noisetex, world);
      world.xz *= rot; puddle += texnoise3D(noisetex, world * 2.0) * 0.5;
      world.xz *= rot; puddle += texnoise3D(noisetex, world * 4.0) * 0.25;
      world.xz *= rot; puddle += texnoise3D(noisetex, world * 8.0) * 0.125;
      world.xz *= rot; puddle += texnoise3D(noisetex, world * 16.0) * 0.0625;

      puddle -= 0.4;
      puddle = puddle * 2.0 - 1.0;
      puddle = (max0(puddle));

      puddle += (1.0 - max0(height * 2.0 - 1.0)) * 2.2;

      return clamp(puddle, 0.5, 1.0) * wetness * pow4(lmcoord.y);
    }

    vec4 getPuddle(in vec3 world, in float height, in float material) {
      float weight0 = getPuddleWeight(world, height, material);
      vec3 normal = vec3(0.0);

      return vec4(normal, weight0);
    }

    // PUDDLE INTERACTION
    vec4 getPuddleSpecular(in vec4 surfaceSpecular, in float weight) {
      vec4 puddleSpecular = surfaceSpecular;
      c(vec4) waterSpecular = SURFACE_PROPERTIES_WATER;

      // SMOOTHNESS
      puddleSpecular.xzw = mix(puddleSpecular.xzw, waterSpecular.xzw, weight);

      // F0
      puddleSpecular.y = max(puddleSpecular.y, mix(puddleSpecular.y, waterSpecular.y, weight));

      return puddleSpecular;
    }
  #endif
#endif
