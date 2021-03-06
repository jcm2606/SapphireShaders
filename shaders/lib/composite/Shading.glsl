/*
  SAPPHIRE.
  JCM2606.

  Before editing anything in this file, please read "License.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_COMPOSITE_SHADING
  #define INT_INCLUDED_COMPOSITE_SHADING

  #include "/lib/composite/WaterAbsorption.glsl"

  #include "/lib/composite/Shadows.glsl"

  #include "/lib/common/util/DiffuseModel.glsl"

  vec3 getShadedFragment(out float frontOcclusion, in vec3 albedo, in mat2x3 lighting) {
    if(!getLandMask(position.depthBack)) return albedo;

    Shadows shadowObject = ShadowObject();
    getShadows(shadowObject);

    //return vec3(shadowObject.dist);

    float directShading = (backMaterial.foliage > 0.5) ? 1.0 : DirectShadingModel(fnormalize(position.viewPositionBack), lightVector, backSurface.normal, backSurface.roughness);
    vec3 directTint = mix(vec3(shadowObject.occlusion.x), shadowObject.colour * ((comparef(shadowObject.material, MATERIAL_WATER, ubyteMaxRCP)) ? absorbWater(shadowObject.dist) * diffuseWater(shadowObject.dist) : vec3(1.0)), shadowObject.difference);

    float ambientShading = cflattenf(DirectShadingModel(fnormalize(position.viewPositionBack), upVector, backSurface.normal, backSurface.roughness), 0.65);

    frontOcclusion = shadowObject.occlusion.z;

    vec3 direct = lighting[0] * shadowObject.occlusion.x * directShading * directTint;
    vec3 ambient = lighting[1] * backSurface.skyLight * ambientShading;
    vec3 block = mix(lightingBlock * backSurface.blockLight, mix(vec3(1.0), lightingBlock * 12.0, backMaterial.emissive), backSurface.emission);

    return albedo * (direct + ambient + block);
  }
#endif
