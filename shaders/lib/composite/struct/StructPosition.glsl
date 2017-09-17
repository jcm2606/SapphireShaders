/*
  SAPPHIRE BASE.
  JCM2606.

  Before editing anything in this file, please read "License.txt" at the root of the pack.
*/

#ifndef INT_INCLUDED_STRUCT_POSITION
  #define INT_INCLUDED_STRUCT_POSITION

  struct Position {
    float depthBack;
    float depthFront;

    vec3 viewPositionBack;
    vec3 viewPositionFront;

    vec3 worldPositionBack;
    vec3 worldPositionFront;
  };

  #define PositionObject() Position(0.0, 0.0, vec3(0.0), vec3(0.0), vec3(0.0),vec3(0.0))
  #define NewPositionObject(name) Position name = PositionObject()

  void populateBackDepth(io Position position, in vec2 texcoord) {
    position.depthBack = texture2D(depthtex1, texcoord).x;
  }

  void populateFrontDepth(io Position position, in vec2 texcoord) {
    position.depthFront = texture2D(depthtex0, texcoord).x;
  }

  void populateDepths(io Position position, in vec2 texcoord) {
    position.depthBack = texture2D(depthtex1, texcoord).x;
    position.depthFront = texture2D(depthtex0, texcoord).x;
  }
#endif