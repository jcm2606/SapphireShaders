/*
  SAPPHIRE BASE.
  JCM2606.

  Before editing anything in this file, please read "LICENSE.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_STRUCT_MATERIAL
  #define INT_INCLUDED_STRUCT_MATERIAL

  struct Material {
    float rawMaterial;

    float unlit;

    float emissive;
    float terrain;
    float foliage;
    float metal;

    float particle;
    float entity;
    float hand;
    float weather;

    float ice;
    float stainedGlass;
    float transparent;
    float water;
  };

  #define MaterialObject() Material(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
  #define NewMaterialObject(name) Material name = MaterialObject()

  #define checkEquality(mat) comparef(material.rawMaterial, mat, ubyteMaxRCP)

  void populateMaterialObject(io Material material, io Surface surface) {
    material.rawMaterial = surface.material * materialRange;

    material.unlit = (checkEquality(MATERIAL_UNLIT)) ? 1.0 : 0.0;

    material.emissive = (checkEquality(MATERIAL_EMISSIVE)) ? 1.0 : 0.0;
    material.terrain = (checkEquality(MATERIAL_TERRAIN)) ? 1.0 : 0.0;
    material.foliage = (checkEquality(MATERIAL_FOLIAGE)) ? 1.0 : 0.0;
    material.metal = (checkEquality(MATERIAL_METAL)) ? 1.0 : 0.0;

    material.particle = (checkEquality(MATERIAL_PARTICLE)) ? 1.0 : 0.0;
    material.entity = (checkEquality(MATERIAL_ENTITY)) ? 1.0 : 0.0;
    material.hand = (checkEquality(MATERIAL_HAND)) ? 1.0 : 0.0;
    material.weather = (checkEquality(MATERIAL_WEATHER)) ? 1.0 : 0.0;

    material.ice = (checkEquality(MATERIAL_ICE)) ? 1.0 : 0.0;
    material.stainedGlass = (checkEquality(MATERIAL_STAINED_GLASS)) ? 1.0 : 0.0;
    material.transparent = (checkEquality(MATERIAL_TRANSPARENT)) ? 1.0 : 0.0;
    material.water = (checkEquality(MATERIAL_WATER)) ? 1.0 : 0.0;
  }

  #undef checkEquality

  void populateMaterials(io Material backMaterial, io Material frontMaterial, io Surface backSurface, io Surface frontSurface, in bool back, in bool front) {
    if(back) populateMaterialObject(backMaterial, backSurface);
    if(front) populateMaterialObject(frontMaterial, frontSurface);
  }
#endif
