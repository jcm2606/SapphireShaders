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

  vec3 drawReflections(in vec3 diffuse, in vec3 direct) {
    if(!getLandMask(position.depthFront)) return diffuse;

    vec3 view = position.viewPositionFront;
    vec3 dir = -fnormalize(view);
    vec3 normal = fnormalize(selectSurface().normal);
    float roughness = selectSurface().roughness;
    float f0 = selectSurface().f0;
    float metallic = (f0 > 0.5) ? 1.0 : 0.0;

    // CREATE REFLECTION VECTORS
    vec3 reflView = reflect(fnormalize(view), normal);
    vec3 reflDir = reflect(dir, normal);

    // RAYTRACE USES CLIPSPACE RAYTRACER
    vec4 reflection = raytraceClip(-reflDir, view, texcoord, position.depthFront);

    // SAMPLE SKY IN REFLECTED DIRECTION
    vec3 sky = drawSky(diffuse, reflView, 2);

    // TODO: Volumetric clouds.

    // BLEND BETWEEN RAYTRACED AND SKY SAMPLES
    reflection.rgb = mix(sky, reflection.rgb, reflection.a);

    // APPLY FRESNEL
    reflection.rgb *= ((1.0 - f0) * pow5(1.0 - max0(dot(dir, fnormalize(reflView + dir)))) + f0) * max0(1.0 - pow2(roughness * 1.9));

    // APPLY SPECULAR HIGHLIGHT
    reflection.rgb += direct * ggx(fnormalize(view), normal, lightVector, roughness, metallic, f0);

    // APPLY METALLIC TINTING
    reflection.rgb *= (metallic > 0.5) ? selectSurface().albedo : vec3(1.0);

    return diffuse * (1.0 - metallic) + reflection.rgb;
  }
#endif
