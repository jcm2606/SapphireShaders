/*
  SAPPHIRE BASE.
  JCM2606.

  Before editing anything in this file, please read "LICENSE.txt" at the root of the pack.
*/

#if !defined(INT_INCLUDED_GBUFFER_DIRECTIONALLIGHTMAP) && SHADER == GBUFFERS_TERRAIN
  #define INT_INCLUDED_GBUFFER_DIRECTIONALLIGHTMAP

  #if 0
    vec2 getLightmapShading(in vec2 lightmap, in vec3 vertexNormal, in vec3 tangentNormal, in mat3 tbn) {
      if(comparef(material, MATERIAL_EMISSIVE, ubyteMaxRCP)) return lightmap;
      
      vec2 shading = lightmap;

      #define blockShading shading.x
      #define skyShading shading.y

      mat2x3 tangents = mat2x3(
        cross(gbufferModelViewInverse[1].xyz, tbn[2]),
        cross(tbn[2], gbufferModelViewInverse[0].xyz)
      );

      vec2 derivatives = vec2(dFdx(blockShading), dFdy(blockShading));

      derivatives = (derivatives == vec2(0.0)) ? vec2(1.0) : derivatives;

      vec3 L = tangents * derivatives;

      L = normalize(L + tbn[2] * length(derivatives));

      blockShading = max0(dot(L, tangentNormal));

      #undef blockShading
      #undef skyShading

      return shading;
    }
  #else
    vec2 getLightmapShading(in vec2 lightmap, in vec3 vertexNormal, in vec3 tangentNormal, in mat3 tbn) {
      if(comparef(material, MATERIAL_EMISSIVE, ubyteMaxRCP)) return lightmap;

      mat2x3 tangents = mat2x3(0.0);

      #define xTangent tangents[0]
      #define yTangent tangents[1]

      xTangent = ttn[1];
      yTangent = cross(vertexNormal, xTangent);

      vec2 shading = lightmap;

      #define blockShading shading.x
      #define skyShading shading.y

      mat2 derivatives = mat2(
        vec2(dFdx(blockShading), dFdy(blockShading)),
        vec2(dFdx(skyShading), dFdy(skyShading))
      );

      derivatives[0] = (derivatives[0] == vec2(0.0)) ? vec2(1.0) : derivatives[0];
      derivatives[1] = (derivatives[1] == vec2(0.0)) ? vec2(1.0) : derivatives[1];

      blockShading = clamp01(dot(fnormalize(xTangent * derivatives[0].x + (yTangent * derivatives[0].y)), tangentNormal));

      skyShading = clamp01(dot(fnormalize(xTangent * derivatives[1].x + (yTangent * derivatives[1].y)), tangentNormal));

      #undef blockShading
      #undef skyShading

      #undef xTangent
      #undef yTangent

      return shading * 0.5 + 0.5;
    }
  #endif
#endif
