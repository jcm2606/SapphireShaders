/*
  SAPPHIRE.
  JCM2606.

  Before editing anything in this file, please read "LICENSE.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_COMMON_NORMALS
  #define INT_INCLUDED_COMMON_NORMALS

  #include "/lib/common/util/Noise.glsl"

  #if SHADER == GBUFFERS_WATER || STAGE == SHADOW || STAGE == COMPOSITE2
    c(float) windDirection = 0.7;

    /* WATER */
    float water0(in vec3 world) {
      float height = 0.0;

      vec2 position = world.xz - world.y;

      c(float) waveSpeed = 0.0017;
      c(vec2) waveDirection = swizzle2 * waveSpeed;
      vec2 move = waveDirection * frametime;

      c(mat2) rot = rot2(windDirection);

      position *= 0.0011;

      position *= rot;
      position *= rot; height += texnoise2D(noisetex, position + move);
      position *= rot; height -= texnoise2D(noisetex, position * 2.0 + (move * 2.0)) * 0.5;
      position *= rot; height += texnoise2D(noisetex, position * 4.0 + (move * 4.0)) * 0.25;
      position *= rot; height += texnoise2D(noisetex, position * 8.0 + (move * 8.0)) * 0.125;
      position *= rot; height += texnoise2D(noisetex, position * 16.0 + (move * 16.0)) * 0.0625;

      height *= 0.2;

      return 1.0 - powi(abs(height * 2.0 - 1.0), 3) * 3.0;
    }

    float water1(in vec3 world) {
      float height = 0.0;

      vec2 position = world.xz - world.y;

      c(float) waveSpeed = 0.0017;
      c(vec2) waveDirection = swizzle2 * waveSpeed;
      vec2 move = waveDirection * frametime;

      c(mat2) rot = rot2(windDirection);

      position *= 0.0007;

      //position *= rot; height += texnoise2D(noisetex, position * 0.5 + move) * 0.25;

      //position *= rot; height -= texnoise2D(noisetex, position * 0.75 + move) * 0.5;

      position *= rot; height += texnoise2D(noisetex, position + move) * 0.5;

      position *= rot; height += texnoise2D(noisetex, position * 2.0 + (move * 2.0)) * 0.5;

      position *= rot; height += texnoise2D(noisetex, position * 4.0 + (move * 4.0)) * 0.25;

      position *= rot; height -= texnoise2D(noisetex, position * 8.0 + (move * 8.0)) * 0.125;

      position *= rot; height += texnoise2D(noisetex, position * 16.0 + (move * 16.0)) * 0.0625;

      //position *= rot; height += texnoise2D(noisetex, position * 32.0 + (move * 32.0)) * 0.03125;
      
      //position *= rot; height += texnoise2D(noisetex, position * 64.0 + (move * 64.0)) * 0.015625;

      //position *= rot; height += texnoise2D(noisetex, position * 128.0 + (move * 128.0)) * 0.0078125;

      //position *= rot; height += texnoise2D(noisetex, position * 256.0 + (move * 256.0)) * 0.00390625;

      //position *= rot; height += texnoise2D(noisetex, position * 512.0 + (move * 512.0)) * 0.001953125;

      //position *= rot; height += texnoise2D(noisetex, position * 1024.0 + (move * 1024.0)) * 0.0009765625;

      return (pow(abs(height * 2.0 - 1.0), 0.75)) * 1.5;
    }

     float getWaterHeight(in vec3 world) {
      return WaterHeight(world);
    }

    /* ICE */
    float ice0(in vec3 world) {
      return 0.0;
    }

    float getIceHeight(in vec3 world) {
      return IceHeight(world);
    }

    /* STAINED GLASS */
    float glass0(in vec3 world) {
      return 0.0;
    }

    float getGlassHeight(in vec3 world) {
      return GlassHeight(world);
    }

    /* GENERIC */
    float getHeight(in vec3 world, in float material) {
      return (comparef(material, MATERIAL_WATER, ubyteMaxRCP)) ? getWaterHeight(world) : (
        (comparef(material, MATERIAL_ICE, ubyteMaxRCP)) ? getIceHeight(world) : (
          (comparef(material, MATERIAL_STAINED_GLASS, ubyteMaxRCP)) ? getGlassHeight(world) : 0.0
        )
      );
    }

    vec3 getNormal(in vec3 world, in float material) {
      c(float) normalDelta = 0.2;
      cRCP(float, normalDelta);

      float height0 = getHeight(world, material);

      vec4 heightVector = vec4(0.0);

      #define height1 heightVector.x
      #define height2 heightVector.y
      #define height3 heightVector.z
      #define height4 heightVector.w

      height1 = getHeight(world + vec3( normalDelta, 0.0, 0.0), material);
      height2 = getHeight(world + vec3(-normalDelta, 0.0, 0.0), material);
      height3 = getHeight(world + vec3(0.0, 0.0,  normalDelta), material);
      height4 = getHeight(world + vec3(0.0, 0.0, -normalDelta), material);

      vec2 delta = vec2(
        ((height1 - height0) + (height0 - height2)),
        ((height3 - height0) + (height0 - height4))
      ) * normalDeltaRCP;

      #undef height1
      #undef height2
      #undef height3
      #undef height4

      return fnormalize(vec3(delta.x, delta.y, 1.0 - pow2(delta.x) - pow2(delta.y)));
    }
  #endif
#endif
