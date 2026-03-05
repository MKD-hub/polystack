precision mediump float;
    
uniform vec2 u_resolution;
uniform float u_cellSize;
uniform float u_lineThickness; // Keep this declared to test it's not optimized away
uniform vec3 u_cameraPos;

// received from the vertex shader
varying vec3 v_worldPos;

void main() {
    vec2 pos = fract(v_worldPos.xz);
    
    // Basic grid math
    float lineX = step(u_lineThickness, pos.x);
    float lineZ = step(u_lineThickness, pos.y);
    float grid = 1.0 - (lineX * lineZ);

    // Fade logic: smoothstep(far_limit, near_limit, distance)
    float dist = distance(v_worldPos.xz, u_cameraPos.xz);
    float alpha = smoothstep(80.0, 40.0, dist); // Fades completely by 100 units

    gl_FragColor = vec4(vec3(0.1), grid * alpha);
}
