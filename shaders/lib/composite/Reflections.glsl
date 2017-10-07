/*
  SAPPHIRE.
  JCM2606.

  Before editing anything in this file, please read "License.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_COMPOSITE_REFLECTIONS
  #define INT_INCLUDED_COMPOSITE_REFLECTIONS

  #include "/lib/composite/Raytracer.glsl"

  #include "/lib/composite/Sky.glsl"

  #include "/lib/common/util/SpecularModel.glsl"

  vec3 sunMRP(in vec3 normal, in vec3 view, in vec3 light) {
    vec3 reflected = reflect(view, normal);

    c(float) radius = 0.02;
    float d = cos(radius);

    float LdotR = dot(light, reflected);

    return (LdotR < d) ? fnormalize(d * light + (fnormalize(reflected - LdotR * light) * sin(radius))) : reflected;
  }

  vec3 drawReflections(in vec3 diffuse, in vec3 direct) {
    if(!getLandMask(position.depthFront) || isEyeInWater == 1) return diffuse;

    vec3 view = position.viewPositionFront;
    vec3 dir = -fnormalize(view);
    vec3 normal = fnormalize(selectSurface().normal);
    float roughness = selectSurface().roughness;
    vec2 alpha = pow2(vec2(roughness * 2.45, roughness * 1.6));
    float f0 = selectSurface().f0;
    float metallic = (f0 > 0.5) ? 1.0 : 0.0;

    // CREATE REFLECTION VECTORS
    vec3 reflView = reflect(fnormalize(view), normal);
    
    // RAYTRACE USES CLIPSPACE RAYTRACER
    vec4 specular = raytraceClip(-reflect(dir, normal), view, texcoord, position.depthFront);

    // SAMPLE SKY IN REFLECTED DIRECTION
    vec3 sky = drawSky(diffuse, reflView, 2) * 2.5;

    // TODO: Volumetric clouds.

    // BLEND BETWEEN RAYTRACED AND SKY SAMPLES
    specular.rgb = mix(sky, specular.rgb, specular.a);

    // APPLY FRESNEL
    float fresnel = ((1.0 - f0) * pow5(1.0 - max0(dot(dir, fnormalize(reflView + dir)))) + f0) * max0(1.0 - alpha.x);
    #if REFLECTIONS_BLENDING == 0
      specular.rgb *= fresnel;
    #else
      specular.rgb = mix(diffuse, specular.rgb, fresnel);
    #endif

    // APPLY SPECULAR HIGHLIGHT
    //reflection.rgb += ggx(fnormalize(view), normal, lightVector, roughness, metallic, f0);
    vec3 light = sunMRP(normal, fnormalize(view), lightVector);
    float highlight = ggx(fnormalize(view), fnormalize(normal), light, alpha.y, f0);

    specular.rgb += direct * ((!getLandMask(position.depthBack)) ? 1.0 : buffers.tex0.a) * highlight;

    // APPLY METALLIC TINTING
    specular.rgb *= (metallic > 0.5) ? selectSurface().albedo : vec3(1.0);

    #if REFLECTIONS_BLENDING == 0
      return diffuse * (1.0 - metallic) + specular.rgb;
    #else
      return specular.rgb;
    #endif
  }
#endif
