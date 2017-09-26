/*
  SAPPHIRE.
  JCM2606.

  Before editing anything in this file, please read "License.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_COMPOSITE_DEPTHFOG
  #define INT_INCLUDED_COMPOSITE_DEPTHFOG

  #include "/lib/common/util/SpaceTransform.glsl"

  #include "/lib/composite/WaterAbsorption.glsl"

  vec3 drawWaterFog(in vec3 colour, in vec2 refractOffset, in vec3 direct) {
    if(isEyeInWater == 0 && frontMaterial.water < 0.5) return colour;
    
    vec2 coord = texcoord + refractOffset;

    vec2 depths = vec2(
      texture2D(depthtex0, coord).x,
      texture2D(depthtex1, coord).x
    );

    mat2x3 view = mat2x3(
      getViewPosition(coord, depths.x),
      getViewPosition(coord, depths.y)
    );

    float dist = distance(view[1] * (1.0 - isEyeInWater), view[0]);

    return mix(
      vec3(0.0),
      colour * absorbWater(dist),
      exp2(-dist * WATER_IMPURITY)
    );
  }
#endif
