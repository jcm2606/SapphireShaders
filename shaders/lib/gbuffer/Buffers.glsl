/*
  SAPPHIRE BASE.
  JCM2606.

  Before editing anything in this file, please read "LICENSE.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_GBUFFER_BUFFERS
  #define INT_INCLUDED_GBUFFER_BUFFERS

  // SAMPLE NORMAL MAP
  #if SHADER == GBUFFERS_TERRAIN || SHADER == GBUFFERS_HAND
    vec4 normalMap = texture2D(normals, uvcoord);
  #endif

  // PUDDLES
  // FEATURE: Puddles.

  // ALBEDO
  #if   SHADER == GBUFFERS_TERRAIN || SHADER == GBUFFERS_HAND
    vec4 albedo = texture2D(texture, uvcoord) * colour;
  #elif SHADER == GBUFFERS_TEXTURED || SHADER == GBUFFERS_TEXTURED_LIT || SHADER == GBUFFERS_SKY_TEXTURED || SHADER == GBUFFERS_CLOUDS || SHADER == GBUFFERS_BEAM || SHADER == GBUFFERS_GLINT || SHADER == GBUFFERS_EYES || SHADER == GBUFFERS_WEATHER || SHADER == GBUFFERS_ENTITIES
    vec4 albedo = texture2D(texture, uvcoord) * colour;
  #elif SHADER == GBUFFERS_WATER
    vec4 albedo = texture2D(texture, uvcoord) * colour;
  #elif SHADER == GBUFFERS_SKY_BASIC
    vec4 albedo = colour;
  #elif SHADER == GBUFFERS_BASIC
    vec4 albedo = colour;
  #endif

  // VANILLA LIGHTMAP
  #ifdef VANILLA_LIGHTING
    #if SHADER == GBUFFERS_TERRAIN || SHADER == GBUFFERS_WATER || SHADER == GBUFFERS_ENTITIES || SHADER == GBUFFERS_WEATHER || SHADER == GBUFFERS_TEXTURED_LIT
      albedo.rgb *= texture2D(lightmap, lmcoord).rgb;
    #endif
  #endif

  // COMMIT ALBEDO TO BUFFER
  albedoBuffer = encodeColour(toGamma(albedo.rgb));

  // SET ALPHA OF BOTH BUFFERS TO ALBEDO ALPHA
  #if SHADER == GBUFFERS_WATER
    albedo.a = 1.0;
  #elif SHADER == GBUFFERS_TEXTURED || SHADER == GBUFFERS_TEXTUREDLIT || SHADER == GBUFFERS_HAND || SHADER == GBUFFERS_WEATHER
    albedo.a = sign(albedo.a);
  #endif

  buffers[0].a = albedo.a;
  buffers[1].a = buffers[0].a;

  // LIGHTMAP SCALARS
  lightmapBuffer = encode2x8(lmcoord);

  // MATERIAL
  materialBuffer = material;

  // NORMAL
  vec3 surfaceNormal = normal;

  #if   SHADER == GBUFFERS_TERRAIN
    float normalMaxAngle = mix(NORMAL_ANGLE_SOLID, NORMAL_ANGLE_WET, 0.0); // TODO: If you add puddles, change the 0.0 here to the puddle scalar.

    surfaceNormal = normalMap.xyz * 2.0 - 1.0;
  #elif SHADER == GBUFFERS_HAND
    c(float) normalMaxAngle = NORMAL_ANGLE_SOLID;

    surfaceNormal = normalMap.xyz * 2.0 - 1.0;
  #elif SHADER == GBUFFERS_WATER
    c(float) normalMaxAngle = NORMAL_ANGLE_TRANSPARENT;

    surfaceNormal = vec3(0.0, 0.0, 1.0);
  #endif

  #if SHADER == GBUFFERS_TERRAIN || SHADER == GBUFFERS_HAND || SHADER == GBUFFERS_WATER
    surfaceNormal  = surfaceNormal * vec3(normalMaxAngle) + vec3(0.0, 0.0, 1.0 - normalMaxAngle);
    surfaceNormal *= tbn;
    surfaceNormal  = fnormalize(surfaceNormal);
  #endif

  normalBuffer = encodeNormal(surfaceNormal);

  // SURFACE PROPERTIES
  vec4 surfaceProperties = vec4(
    0.0, // Smoothness. Inverted with `1.0 - smoothness` to get roughness.
    0.02, // f0
    0.0, // emission
    0.0 // porosity/placeholder
  );

  #define smoothness surfaceProperties.x
  #define f0 surfaceProperties.y
  #define emission surfaceProperties.z
  #define porosity surfaceProperties.w

  #if   SHADER == GBUFFERS_TERRAIN
    vec4 specularMap = texture2D(specular, uvcoord);

    #if   RESOURCE_FORMAT == 0
      smoothness = specularMap.x;
      f0 = (comparef(material, MATERIAL_METAL, ubyteMaxRCP)) ? f0Metal : f0Dielectric;
      emission = (comparef(material, MATERIAL_EMISSIVE, ubyteMaxRCP)) ? 1.0 : 0.0;
    #elif RESOURCE_FORMAT == 1
      smoothness = specularMap.x;
      f0 = mix(f0Dielectric, f0Metal, specularMap.y);
      emission = (comparef(material, MATERIAL_EMISSIVE, ubyteMaxRCP)) ? 1.0 : 0.0;
    #elif RESOURCE_FORMAT == 2
      smoothness = specularMap.x;
      f0 = mix(f0Dielectric, f0Metal, specularMap.y);
      emission = specularMap.z;
    #elif RESOURCE_FORMAT == 3
      smoothness = specularMap.z;
      f0 = specularMap.x;
      emission = (comparef(material, MATERIAL_EMISSIVE, ubyteMaxRCP)) ? specularMap.w : 0.0;
    #endif
  #elif SHADER == GBUFFERS_WATER
    surfaceProperties = (comparef(material, MATERIAL_TRANSPARENT, ubyteMaxRCP)) ? SURFACE_PROPERTIES_TRANSPARENT : surfaceProperties;

    surfaceProperties = (comparef(material, MATERIAL_WATER, ubyteMaxRCP)) ? SURFACE_PROPERTIES_WATER : surfaceProperties;

    surfaceProperties = (comparef(material, MATERIAL_STAINED_GLASS, ubyteMaxRCP)) ? SURFACE_PROPERTIES_STAINED_GLASS : surfaceProperties;

    surfaceProperties = (comparef(material, MATERIAL_ICE, ubyteMaxRCP)) ? SURFACE_PROPERTIES_ICE : surfaceProperties;
  #elif SHADER == GBUFFERS_ENTITIES
    surfaceProperties = SURFACE_PROPERTIES_ENTITIES;
  #endif

  smoothness = 1.0 - smoothness;

  #undef smoothness
  #undef f0
  #undef emission
  #undef porosity

  surface0Buffer = encode2x8(surfaceProperties.xy);
  surface1Buffer = encode2x8(surfaceProperties.zw);
#endif