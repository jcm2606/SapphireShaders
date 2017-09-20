/*
  SAPPHIRE BASE.
  JCM2606.

  Before editing anything in this file, please read "License.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_FINAL_TONEMAP
  #define INT_INCLUDED_FINAL_TONEMAP

  /* UNCHARTED 2 */
  struct OptionsUC2 {
    float A;
    float B;
    float C;
    float D;
    float E;
    float F;
    float W;
  };

  c(OptionsUC2) uc2Preset0 = OptionsUC2(
    /* A */ 0.15,
    /* B */ 0.15,
    /* C */ 0.10,
    /* D */ 0.10,
    /* E */ 0.01,
    /* F */ 0.50, // Contrast
    /* W */ 11.2
  );

  c(OptionsUC2) uc2Preset = uc2Preset0;

  vec3 operatorUC2(c(in OptionsUC2) options, in vec3 colour) {
    return ((colour * (options.A * colour + (options.C * options.B)) + options.D * options.E) / (colour * (options.A * colour + options.B) + (options.D * options.F))) - options.E / options.F;
  }

  vec3 tonemapUC2(in vec3 colour) {
    return operatorUC2(uc2Preset, colour) / operatorUC2(uc2Preset, vec3(uc2Preset.W));
  }

  /* GENERIC */
  vec3 tonemap(in vec3 colour) {
    colour = saturation(colour * EXPOSURE, actualSaturation);

    return Tonemap(colour);
  }
#endif
