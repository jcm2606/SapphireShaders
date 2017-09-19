/*
  SAPPHIRE BASE.
  JCM2606.

  Before editing anything in this file, please read "LICENSE.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_GBUFFER_MATERIALS
  #define INT_INCLUDED_GBUFFER_MATERIALS

  material = MATERIAL_DEFAULT;

  #if   SHADER == GBUFFERS_TERRAIN || STAGE == SHADOW
    // TERRAIN
    material = MATERIAL_TERRAIN;

    // FOLIAGE
    material = (
      compareID(SAPLING) ||
      compareID(LEAVES1) ||
      compareID(LEAVES2) ||
      compareID(TALLGRASS) ||
      compareID(DEADBUSH) ||
      compareID(FLOWER_YELLOW) ||
      compareID(FLOWER_RED) ||
      compareID(MUSHROOM_BROWN) ||
      compareID(MUSHROOM_RED) ||
      compareID(WHEAT) ||
      compareID(REEDS) ||
      compareID(VINE) ||
      compareID(LILYPAD) ||
      compareID(NETHERWART) ||
      compareID(CARROTS) ||
      compareID(POTATOES) ||
      compareID(DOUBLE_PLANT) ||
      (
        // Place any extra IDs you want to check for in here, replacing 'false'.
        false
      )
    ) ?
      MATERIAL_FOLIAGE :
      material;

    // EMISSIVE
    material = (
      compareID(TORCH) ||
      compareID(FIRE) ||
      compareID(GLOWSTONE) ||
      compareID(REDSTONE_LAMP_LIT) ||
      compareID(REDSTONE_LAMP_UNLIT) ||
      compareID(BEACON) ||
      compareID(SEA_LANTERN) ||
      compareID(END_ROD) ||
      (
        // Place any extra IDs you want to check for in here, replacing 'false'.
        false
      )
    ) ?
      MATERIAL_EMISSIVE :
      material;

    // METALS
    material = (
      compareID(BLOCK_IRON) ||
      compareID(BLOCK_GOLD) ||
      (
        // Place any extra IDs you want to check for in here, replacing 'false'.
        false
      )
    ) ?
      MATERIAL_METAL :
      material;
  #elif SHADER == GBUFFERS_WATER || STAGE == SHADOW
    // TRANSPARENT
    material = MATERIAL_TRANSPARENT;
    
    // WATER
    material = (
      entity.x == WATER.x ||
      entity.x == WATER.y ||
      (
        // Place any extra IDs you want to check for in here, replacing 'false'.
        false
      )
    ) ?
      MATERIAL_WATER :
      material;

    // ICE
    material = (
      compareID(ICE) ||
      (
        // Place any extra IDs you want to check for in here, replacing 'false'.
        false
      )
    ) ?
      MATERIAL_ICE :
      material;

    // STAINED GLASS
    material = (
      entity.x == STAINED_GLASS.x ||
      entity.x == STAINED_GLASS.y ||
      (
        // Place any extra IDs you want to check for in here, replacing 'false'.
        false
      )
    ) ?
      MATERIAL_STAINED_GLASS :
      material;
  #elif SHADER == GBUFFERS_ENTITIES
    material = MATERIAL_ENTITY;
  #elif SHADER == GBUFFERS_WEATHER
    material = MATERIAL_WEATHER;
  #elif SHADER == GBUFFERS_TEXTURED || SHADER == GBUFFERS_GLINT || SHADER == GBUFFERS_BEAM || SHADER == GBUFFERS_EYES
    material = MATERIAL_UNLIT;
  #elif SHADER == GBUFFERS_TEXTURED_LIT
    material = MATERIAL_PARTICLE;
  #elif SHADER == GBUFFERS_HAND
    material = MATERIAL_HAND;
  #endif

  material *= materialRangeRCP;
#endif