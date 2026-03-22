#extension GL_OES_standard_derivatives : enable
precision mediump float;

uniform float u_minorLineThickness; 
uniform float u_majorLineThickness; 
uniform float u_gridSpacingMajor;
uniform float u_gridSpacingMinor;
uniform vec3 u_cameraPos;
uniform vec4 u_bgColor;

varying vec3 v_worldPos;

void main() {
  vec2 gridPts = v_worldPos.xz;
  vec2 scaledMinor = gridPts/u_gridSpacingMinor;
  vec2 scaledMajor = gridPts/u_gridSpacingMajor;
  vec2 cell = fract(scaledMinor);
  vec2 cellMajor = fract(scaledMajor);

  vec2 distToEdge = min(cell, 1.0 - cell);
  vec2 distToMajorEdge = min(cellMajor, 1.0 - cellMajor);

  vec2 aaMinor = fwidth(distToEdge);
  vec2 aaMajor = fwidth(distToMajorEdge);

  float lineMinorX = 1.0 - smoothstep(u_minorLineThickness - aaMinor.x, u_minorLineThickness + aaMinor.x, distToEdge.x);
  float lineMinorY = 1.0 - smoothstep(u_minorLineThickness - aaMinor.y, u_minorLineThickness + aaMinor.y, distToEdge.y);
  float lineMajorX = 1.0 - smoothstep(u_majorLineThickness - aaMajor.x, u_majorLineThickness + aaMajor.x, distToMajorEdge.x);
  float lineMajorY = 1.0 - smoothstep(u_majorLineThickness - aaMajor.y, u_majorLineThickness + aaMajor.y, distToMajorEdge.y);

  float lineMaskMinor = clamp(lineMinorX + lineMinorY, 0.0, 1.0);
  float lineMaskMajor = clamp(lineMajorX + lineMajorY, 0.0, 1.0);

  float dist = length(v_worldPos - u_cameraPos);
  float fade = 1.0 - smoothstep(20.0, 100.0, dist); // tweak these numbers
  lineMaskMinor *= fade;
  lineMaskMajor *= fade;

  vec4 lineColor = vec4(0.95, 0.99, 0.94, 1.0);
  vec4 lineColorMajor = vec4(0.498, 0.545, 0.600, 1.0);

  vec4 color = mix(u_bgColor, lineColor, lineMaskMinor);
  color = mix(color, lineColorMajor, lineMaskMajor);
  gl_FragColor = color;
}
