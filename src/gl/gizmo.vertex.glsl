attribute vec4 aPosition;
attribute vec3 aColor;
  
uniform mat4 uViewMatrix;
uniform mat4 uProjectionMatrix;
  
varying vec3 vColor;
  
void main() {
  gl_Position = uProjectionMatrix * uViewMatrix * aPosition;
  vColor = aColor;
}

