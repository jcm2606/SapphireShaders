/*
  SAPPHIRE.
  JCM2606.

  Before editing anything in this file, please read "License.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_COMPOSITE_SHADING
  #define INT_INCLUDED_COMPOSITE_SHADING

  #include "/lib/composite/Shadows.glsl"

  #include "/lib/common/util/DiffuseModel.glsl"

  vec3 getShadedFragment(in vec3 albedo, in mat2x3 lighting) {
    if(!getLandMask(position.depthBack)) return albedo;

    Shadows shadowObject = ShadowObject();
    getShadows(shadowObject);

    float directShading = (backMaterial.foliage > 0.5) ? 1.0 : DirectShadingModel(normalize(position.viewPositionBack), lightVector, backSurface.normal, backSurface.roughness);
    vec3 directTint = mix(vec3(shadowObject.occlusion.y), shadowObject.colour, shadowObject.difference);

    float ambientShading = cflattenf(DirectShadingModel(normalize(position.viewPositionBack), upVector, backSurface.normal, backSurface.roughness), 0.65);

    #define direct ((lighting[0] * shadowObject.occlusion.x) * directShading) * directTint
    #define ambient ((lighting[1] * 0.5) * backSurface.skyLight) * ambientShading
    #define block lightingBlock * backSurface.blockLight

    return albedo * (direct + (ambient + (block)));

    #undef direct
    #undef ambient
    #undef block
  }
#endif
