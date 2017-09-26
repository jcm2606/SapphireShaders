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
      entity.x == SAPLING.x ||
      entity.x == LEAVES1.x ||
      entity.x == LEAVES2.x ||
      entity.x == TALLGRASS.x ||
      entity.x == DEADBUSH.x ||
      entity.x == FLOWER_YELLOW.x ||
      entity.x == FLOWER_RED.x ||
      entity.x == MUSHROOM_BROWN.x ||
      entity.x == MUSHROOM_RED.x ||
      entity.x == WHEAT.x ||
      entity.x == REEDS.x ||
      entity.x == VINE.x ||
      entity.x == LILYPAD.x ||
      entity.x == NETHERWART.x ||
      entity.x == CARROTS.x ||
      entity.x == POTATOES.x ||
      entity.x == DOUBLE_PLANT.x ||
      (
        // Place any extra IDs you want to check for in here, replacing 'false'.
        false
      )
    ) ?
      MATERIAL_FOLIAGE :
      material;

    // EMISSIVE
    material = (
      entity.x == TORCH.x ||
      entity.x == FIRE.x ||
      entity.x == GLOWSTONE.x ||
      entity.x == REDSTONE_LAMP_LIT.x ||
      entity.x == REDSTONE_LAMP_UNLIT.x ||
      entity.x == BEACON.x ||
      entity.x == SEA_LANTERN.x ||
      entity.x == END_ROD.x ||
      (
        // Place any extra IDs you want to check for in here, replacing 'false'.
        false
      )
    ) ?
      MATERIAL_EMISSIVE :
      material;

    // METALS
    material = (
      entity.x == BLOCK_IRON.x ||
      entity.x == BLOCK_GOLD.x ||
      (
        // Place any extra IDs you want to check for in here, replacing 'false'.
        false
      )
    ) ?
      MATERIAL_METAL :
      material;
  #endif
  #if SHADER == GBUFFERS_WATER || STAGE == SHADOW
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
      entity.x == ICE.x ||
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
#endif