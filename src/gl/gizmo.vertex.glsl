attribute vec4 aPosition;
attribute vec2 aTexCoord;
  
uniform mat4 uViewMatrix;
uniform mat4 uProjectionMatrix;
  
varying vec2 vTexCoord; 

void main() {
  gl_Position = uProjectionMatrix * uViewMatrix * aPosition;
  vTexCoord = aTexCoord;
}

