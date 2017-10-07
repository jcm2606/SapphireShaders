/*
  SAPPHIRE.
  JCM2606.

  Before editing anything in this file, please read "LICENSE.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_COMPOSITE_REFRACTION
  #define INT_INCLUDED_COMPOSITE_REFRACTION

  #include "/lib/common/normal/Normals.glsl"

  vec2 getRefractionOffset(in vec2 texcoord, in vec3 view) {
    if(frontMaterial.water < 0.5 && frontMaterial.ice < 0.5 && frontMaterial.stainedGlass < 0.5) return vec2(0.0);

    mat2 refraction = mat2(0.0);

    #define viewRefraction refraction[0]
    #define surfaceRefraction refraction[1]

    c(float) viewRefractionStrength = 0.03;
    viewRefraction = frontSurface.normal.xy * viewRefractionStrength * ((isEyeInWater == 0) ? refractInterfaceAirWater : refractInterfaceWaterAir);

    float surfaceRefractionStrength = 0.009;
    surfaceRefractionStrength /= getLinearDepth(position.depthFront) * 0.25;
    surfaceRefraction = getNormal(getWorldPosition(view) + cameraPosition, frontMaterial.rawMaterial).xy * surfaceRefractionStrength;

    vec2 refractOffset = surfaceRefraction - viewRefraction;

    float reprojectedMaterial = texture2D(colortex3, texcoord + refractOffset).b;

    if(
      any(greaterThan(abs((texcoord + refractOffset) - 0.5), vec2(0.5))) || (
        reprojectedMaterial != frontSurface.material
      )
    ) return vec2(0.0);

    return refractOffset;

    #undef viewRefraction
    #undef surfaceRefraction
  }

  vec3 drawRefraction(in vec3 colour, in vec2 texcoord, in vec2 offset) {
    if(frontMaterial.water < 0.5 && frontMaterial.ice < 0.5 && frontMaterial.stainedGlass < 0.5) return colour;

    return toFrameHDR(texture2D(colortex0, texcoord + offset).rgb);
  }
#endif
