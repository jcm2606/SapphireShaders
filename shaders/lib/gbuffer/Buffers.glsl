/*
  SAPPHIRE BASE.
  JCM2606.

  Before editing anything in this file, please read "LICENSE.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_GBUFFER_BUFFERS
  #define INT_INCLUDED_GBUFFER_BUFFERS

  // SAMPLE NORMAL MAP
  #if SHADER == GBUFFERS_TERRAIN || SHADER == GBUFFERS_HAND
    vec4 normalMap = textureSample(normals, texcoord);
  #endif

  // PUDDLES
  #if SHADER == GBUFFERS_TERRAIN || SHADER == GBUFFERS_HAND || SHADER == GBUFFERS_ENTITIES
    vec4 puddle = getPuddle(world, 
      #if SHADER == GBUFFERS_TERRAIN || SHADER == GBUFFERS_HAND
        normalMap.a
      #else
        0.0
      #endif
    , material);
  #else
    vec4 puddle = vec4(0.0);
  #endif

  // NORMAL
  vec3 surfaceNormal = normal;

  #if   SHADER == GBUFFERS_TERRAIN
    float normalMaxAngle = mix(NORMAL_ANGLE_SOLID, NORMAL_ANGLE_WET, puddle.w); // TODO: If you add puddles, change the 0.0 here to the puddle scalar.

    surfaceNormal = normalMap.xyz * 2.0 - 1.0;
  #elif SHADER == GBUFFERS_HAND
    c(float) normalMaxAngle = NORMAL_ANGLE_SOLID;

    surfaceNormal = normalMap.xyz * 2.0 - 1.0;
  #elif SHADER == GBUFFERS_WATER
    c(float) normalMaxAngle = NORMAL_ANGLE_TRANSPARENT;

    vec3 pos = world;
    #ifdef PARALLAX_TRANSPARENT
      pos = getParallax(pos, view, material);
    #endif

    surfaceNormal = getNormal(pos, material);
  #endif

  #if SHADER == GBUFFERS_TERRAIN || SHADER == GBUFFERS_HAND || SHADER == GBUFFERS_WATER
    surfaceNormal  = surfaceNormal * vec3(normalMaxAngle) + vec3(0.0, 0.0, 1.0 - normalMaxAngle);
    surfaceNormal *= tbn;
    surfaceNormal  = fnormalize(surfaceNormal);
  #endif

  normalBuffer = encodeNormal(surfaceNormal);

  // ALBEDO
  #if   SHADER == GBUFFERS_TERRAIN || SHADER == GBUFFERS_HAND
    vec4 albedo = textureSample(texture, texcoord) * colour;
  #elif SHADER == GBUFFERS_TEXTURED || SHADER == GBUFFERS_TEXTURED_LIT || SHADER == GBUFFERS_SKY_TEXTURED || SHADER == GBUFFERS_CLOUDS || SHADER == GBUFFERS_BEAM || SHADER == GBUFFERS_GLINT || SHADER == GBUFFERS_EYES || SHADER == GBUFFERS_ENTITIES
    vec4 albedo = textureSample(texture, texcoord) * colour;
  #elif SHADER == GBUFFERS_WATER
    vec4 albedo = textureSample(texture, texcoord) * colour;

    if(comparef(material, MATERIAL_WATER, ubyteMaxRCP)) albedo.rgb = vec3(0.0);
  #elif SHADER == GBUFFERS_SKY_BASIC
    vec4 albedo = colour;
  #elif SHADER == GBUFFERS_WEATHER
    vec4 albedo = textureSample(texture, texcoord) * colour;
    albedo.rgb = vec3(0.8, 0.9, 1.0);
  #elif SHADER == GBUFFERS_BASIC
    vec4 albedo = colour;
  #endif

  //albedo.rgb = vec3(puddle.w);

  // SURFACE PROPERTIES
  vec4 surfaceProperties = SURFACE_PROPERTIES_DEFAULT;

  #define smoothness surfaceProperties.x
  #define f0 surfaceProperties.y
  #define emission surfaceProperties.z
  #define porosity surfaceProperties.w

  #if   SHADER == GBUFFERS_TERRAIN || SHADER == GBUFFERS_HAND
    vec4 specularMap = textureSample(specular, texcoord);

    #if   RESOURCE_FORMAT == 0
      // Specular pack. Uses a hardcoded metalness mask to determine f0, also uses a hardcoded emissive mask to determine emission.
      smoothness = (specularMap.x > 0.0) ? specularMap.x : smoothness;
      f0 = (comparef(material, MATERIAL_METAL, ubyteMaxRCP)) ? f0Metal : f0Dielectric;
      emission = (comparef(material, MATERIAL_EMISSIVE, ubyteMaxRCP)) ? 1.0 : 0.0;
    #elif RESOURCE_FORMAT == 1
      // Old PBR pack. Uses metalness mask from texture to determine f0. Uses a hardcoded emissive mask to determine emission.
      smoothness = (specularMap.x > 0.0) ? specularMap.x : smoothness;
      f0 = mix(f0Dielectric, f0Metal, specularMap.y);
      emission = (comparef(material, MATERIAL_EMISSIVE, ubyteMaxRCP)) ? 1.0 : 0.0;
    #elif RESOURCE_FORMAT == 2
      // Old PBR pack, w/ emissive support. Uses metalness mask and emissive mask from texture.
      smoothness = (specularMap.x > 0.0) ? specularMap.x : smoothness;
      f0 = mix(f0Dielectric, f0Metal, specularMap.y);
      emission = specularMap.z;
    #elif RESOURCE_FORMAT == 3
      // New PBR pack. Everything comes from texture.
      smoothness = (specularMap.z > 0.0) ? specularMap.z : smoothness;
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

  #if SHADER == GBUFFERS_TERRAIN || SHADER == GBUFFERS_HAND || SHADER == GBUFFERS_WATER || SHADER == GBUFFERS_ENTITIES
    surfaceProperties = getPuddleSpecular(surfaceProperties, puddle.w);
  #endif

  c(float) roughnessMax = 0.9999999;
  c(float) roughnessMin = 1.0 - roughnessMax;
  smoothness = clamp(1.0 - smoothness, roughnessMin, roughnessMax);

  surface0Buffer = encode2x8(surfaceProperties.xy);
  surface1Buffer = encode2x8(surfaceProperties.zw);

  // VANILLA LIGHTMAP
  #ifdef VANILLA_LIGHTING
    #if SHADER == GBUFFERS_TERRAIN || SHADER == GBUFFERS_WATER || SHADER == GBUFFERS_ENTITIES || SHADER == GBUFFERS_WEATHER || SHADER == GBUFFERS_TEXTURED_LIT
      albedo.rgb *= textureSample(lightmap, lmcoord).rgb;
    #endif
  #endif

  vec2 lightmaps = getLightmaps(lmcoord, surfaceNormal, view, smoothness);

  #undef smoothness
  #undef f0
  #undef emission
  #undef porosity

  if(lightmaps.x > 1.0) albedo.rgb = vec3(1.0, 0.0, 0.0);
  if(lightmaps.y > 1.0) albedo.rgb = vec3(0.0, 1.0, 0.0);

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
  lightmapBuffer = encode2x8(lightmaps);

  // MATERIAL
  materialBuffer = material * materialRangeRCP;
#endif
