/*
  SAPPHIRE.
  JCM2606.

  Before editing anything in this file, please read "License.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_COMPOSITE_RAYTRACER
  #define INT_INCLUDED_COMPOSITE_RAYTRACER

  #include "/lib/common/util/SpaceTransform.glsl"

  #define faceVisible() abs(pos.z - currDepth) < abs(stepLength * direction.z)
  #define onScreen() (floor(pos.xy) == vec2(0.0))

  vec4 raytraceClip(in vec3 dir, in vec3 view, in vec2 texcoord, in float depth) {
    c(float) quality = 16.0;

    vec3 clip = vec3(texcoord, depth);

    vec3 direction = normalize(getClipPosition(view + dir) - clip);

    direction.xy = normalize(direction.xy);
    
    vec3 maxLengths = (step(0.0, direction) - clip) / direction;

    float mult = min(min(maxLengths.x, maxLengths.y), maxLengths.z);
    float maxStepLength = mult / quality;
    float minStepLength = maxStepLength * 0.1;

    float stepLength = maxStepLength * (0.0 * 0.9 + 0.1);
    vec3 pos = direction * stepLength + clip;

    float currDepth = texture2D(depthtex1, pos.xy).x;

    bool rayHit = false;

    for(int i = 0; i < int(quality) + 4; i++) {
      rayHit = currDepth < pos.z;

      if(rayHit || !onScreen()) break;

      stepLength = (currDepth - pos.z) / abs(direction.z);
      stepLength = clamp(stepLength, minStepLength, maxStepLength);

      pos = direction * stepLength + pos;
      
      currDepth = texture2D(depthtex1, pos.xy).x;
    }

    if(faceVisible()) {
      stepLength = (currDepth - pos.z) / abs(direction.z);
      pos = direction * stepLength + pos;
      currDepth = texture2D(depthtex1, pos.xy).x;
    }

    if(
      faceVisible() + 0.001 // Not backface.
      && currDepth < 1.0 // Not sky.
      && 0.97 < pos.z // Not camera clipping.
      && onScreen()
      && rayHit
    ) return vec4(toFrameHDR(texture2D(colortex0, pos.xy).rgb), 1.0);

    return vec4(0.0);
  }
#endif