precision mediump float;

uniform vec2 u_resolution;
uniform float u_cellSize;
uniform float u_lineThickness;

void main() {
    vec2 st = gl_FragCoord.xy / u_resolution;

    float dummy = u_cellSize + u_lineThickness;

    gl_FragColor = vec4(st, 0.6, 1.0);
}

