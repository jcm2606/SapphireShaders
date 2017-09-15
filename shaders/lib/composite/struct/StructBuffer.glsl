/*
  SAPPHIRE BASE.
  JCM2606.

  Before editing anything in this file, please read "LICENSE.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_BUFFER
  #define INT_INCLUDED_BUFFER

  struct Buffer {
    vec4 tex0;
    vec4 tex1;
    vec4 tex2;
    vec4 tex3;
    vec4 tex4;
    vec4 tex5;
    vec4 tex6;
    vec4 tex7;
  };

  #define NewBufferObject(name) Buffer name = Buffer(vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0))

  void populateBufferObject(io Buffer buffers, in vec2 texcoord) {
    #ifdef IN_TEX0
      buffers.tex0 = texture2D(colortex0, texcoord);
    #endif

    #ifdef IN_TEX1
      buffers.tex1 = texture2D(colortex1, texcoord);
    #endif

    #ifdef IN_TEX2
      buffers.tex2 = texture2D(colortex2, texcoord);
    #endif

    #ifdef IN_TEX3
      buffers.tex3 = texture2D(colortex3, texcoord);
    #endif

    #ifdef IN_TEX4
      buffers.tex4 = texture2D(colortex4, texcoord);
    #endif

    #ifdef IN_TEX5
      buffers.tex5 = texture2D(colortex5, texcoord);
    #endif

    #ifdef IN_TEX6
      buffers.tex6 = texture2D(colortex6, texcoord);
    #endif

    #ifdef IN_TEX7
      buffers.tex7 = texture2D(colortex7, texcoord);
    #endif
  }
#endif
