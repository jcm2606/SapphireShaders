/*
  SAPPHIRE BASE.
  JCM2606.

  Before editing anything in this file, please read "LICENSE.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_ENCODING
  #define INT_INCLUDED_ENCODING

  // 3xNf / COLOUR
  c(vec3) values = exp2(vec3(5.0, 6.0, 5.0));
  c(vec3) maxValues = values - 1.0;
  cRCP(vec3, maxValues);
  c(vec3) positions = vec3(1.0, values.x, values.x * values.y);
  cRCP(vec3, positions);

  float encodeColour(in vec3 c) {
    // TODO: Add a dither here. Just uncomment the line below.
    //c += (bayer8(gl_FragCoord.xy) - 0.5) * maxValuesRCP;
    c = clamp01(c);
    return dot(round(c * maxValues), positions) * uhalfMaxRCP;
  }

  vec3 decodeColor(in float f) {
    return mod(f * positionsRCP, values) * maxValuesRCP;
  }

  // 2x8f
  float encode2x8(in vec2 v) {
    ivec2 i = ivec2(v * ubyteMax);

    return float(i.x | (i.y << 8)) * uhalfMaxRCP;
  }

  vec2 decode2x8(in float f) {
    int i = int(f * uhalfMax);

    return vec2(i % 256, i >> 8) * ubyteMaxRCP;
  }

  // NORMALS
  c(float) bits = 11.0;

  c(float) bitsExp2_a = exp2(bits);
  c(float) bitsExp2_b = exp2(bits + 2.0);
  cRCP(float, bitsExp2_b);

  c(vec2) bitsExp2_cRCP = vec2(1.0) / exp2(vec2(bits, bits * 2.0 + 2.0));

  float encodeNormal(in vec3 normal) {
    normal = clamp(normal, -1.0, 1.0);

    normal.xy = round(((vec2(atan(normal.x, normal.z), acos(normal.y)) * piRCP) + vec2(1.0, 0.0)) * bitsExp2_a);
    
    return normal.y * bitsExp2_b + normal.x;
  }

  vec3 decodeNormal(in float encodedNormal) {
    vec4 normal = vec4(0.0);

    normal.y = bitsExp2_b * floor(encodedNormal * bitsExp2_bRCP);
    normal.x = encodedNormal - normal.y;

    normal.xy = ((normal.xy * bitsExp2_cRCP) - swizzle2) * pi;
    normal.xwzy = vec4(sin(normal.xy), cos(normal.xy));
    
    normal.xz *= normal.w;
    
    return normal.xyz;
  }
#endif
