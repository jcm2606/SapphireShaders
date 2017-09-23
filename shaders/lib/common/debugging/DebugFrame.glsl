/*
  SAPPHIRE BASE.
  JCM2606.

  Before editing anything in this file, please read "License.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_DEBUGGING_DEBUGFRAME
  #define INT_INCLUDED_DEBUGGING_DEBUGFRAME

  c(int) tiles = 5;
  c(int) lastSlot = tiles - 1;
  cRCP(float, tiles);

  bool isInSlot(in vec2 texcoord, in ivec2 slot) {
    slot = min(slot, lastSlot);

    return all( greaterThan(texcoord, vec2(tilesRCP * slot)) && lessThan(texcoord, vec2(tilesRCP * slot + tilesRCP)) );
  }

  // GBUFFERS
  vec3 debugGbufferOutput(in vec3 colour, in vec2 texcoord) {
    #ifndef DEBUGGING
      return colour;
    #endif

    #ifndef DEBUG_GBUFFERS
      return colour;
    #elif STAGE != DEBUG_STAGE
      return colour;
    #else
      vec2 uv = fract(texcoord * tiles);
      
      mat4x4 gbuffers = mat4x4(0.0);

      #ifdef IN_TEX1
        gbuffers[0] = texture2D(colortex1, uv);
      #else
        gbuffers[0] = vec4(0.0);
      #endif

      #ifdef IN_TEX2
        gbuffers[1] = texture2D(colortex2, uv);
      #else
        gbuffers[1] = vec4(0.0);
      #endif

      #ifdef IN_TEX3
        gbuffers[2] = texture2D(colortex3, uv);
      #else
        gbuffers[2] = vec4(0.0);
      #endif

      #ifdef IN_TEX4
        gbuffers[3] = texture2D(colortex4, uv);
      #else
        gbuffers[3] = vec4(0.0);
      #endif

      #define back0 gbuffers[0]
      #define back1 gbuffers[1]
      #define front0 gbuffers[2]
      #define front1 gbuffers[3]

      // BACK ALBEDO
      if(isInSlot(texcoord, ivec2(0, 0))) {
        colour = toLinear(decodeColour(back0.x), albedoGammaCurve);
      }

      // FRONT ALBEDO
      if(isInSlot(texcoord, ivec2(1, 0))) {
        colour = toLinear(decodeColour(front0.x), albedoGammaCurve);
      }

      // BACK MATERIAL
      if(isInSlot(texcoord, ivec2(0, lastSlot - 2))) {
        colour = vec3(back0.z);
      }

      // FRONT MATERIAL
      if(isInSlot(texcoord, ivec2(0, lastSlot - 3))) {
        colour = vec3(front0.z);
      }

      // BACK NORMAL
      if(isInSlot(texcoord, ivec2(lastSlot - 2, 0))) {
        colour = decodeNormal(back1.x) * 0.5 + 0.5;
      }

      // FRONT NORMAL
      if(isInSlot(texcoord, ivec2(lastSlot - 1, 0))) {
        colour = decodeNormal(front1.x) * 0.5 + 0.5;
      }

      // BACK DEPTH
      if(isInSlot(texcoord, ivec2(lastSlot, 0))) {
        colour = vec3(texture2D(depthtex1, uv).x);
      }

      // FRONT DEPTH
      if(isInSlot(texcoord, ivec2(lastSlot, 1))) {
        colour = vec3(texture2D(depthtex0, uv).x);
      }

      // BACK LIGHTMAP & EMISSION
      if(isInSlot(texcoord, ivec2(lastSlot, lastSlot - 2))) {
        colour = vec3(decode2x8(back0.y), decode2x8(back1.z).x);
      }

      // FRONT LIGHTMAP & EMISSION
      if(isInSlot(texcoord, ivec2(lastSlot, lastSlot - 1))) {
        colour = vec3(decode2x8(front0.y), decode2x8(front1.z).x);
      }

      // BACK ROUGHNESS
      if(isInSlot(texcoord, ivec2(lastSlot, lastSlot))) {
        colour = vec3(decode2x8(back1.y).x);
      }

      // FRONT ROUGHNESS
      if(isInSlot(texcoord, ivec2(lastSlot - 1, lastSlot))) {
        colour = vec3(decode2x8(front1.y).x);
      }

      // BACK F0
      if(isInSlot(texcoord, ivec2(lastSlot - 2, lastSlot))) {
        colour = vec3(decode2x8(back1.y).y);
      }

      // FRONT F0
      if(isInSlot(texcoord, ivec2(lastSlot - 3, lastSlot))) {
        colour = vec3(decode2x8(front1.y).y);
      }

      return colour;
    #endif
  }

  // DEBUGGING
  #define Debug() buffers.tex0.rgb  = debug(buffers.tex0.rgb, texcoord)

  vec3 debug(in vec3 colour, in vec2 texcoord) {
    vec3 output = colour;

    output = debugGbufferOutput(colour, texcoord);

    return output;
  }
#endif
