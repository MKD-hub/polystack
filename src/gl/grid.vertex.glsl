precision mediump float;

attribute vec4 a_vertexPosition; // Grid verts go here
uniform mat4 u_gridModelMatrix;
uniform mat4 u_viewMatrix;
uniform mat4 u_projectionMatrix;

varying vec3 v_worldPos;

void main() {
  vec4 worldPos = u_gridModelMatrix * a_vertexPosition;
  v_worldPos = worldPos.xyz;
  gl_Position = u_projectionMatrix * u_viewMatrix * worldPos;
}
