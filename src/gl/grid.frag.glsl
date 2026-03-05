// precision mediump float;
//
// uniform vec2 u_resolution;
// uniform float u_cellSize;
// uniform float u_lineThickness; // Keep this declared to test it's not optimized away
// uniform vec3 u_cameraPos;
//
// // received from the vertex shader
// varying vec3 v_worldPos;
//
// void main() {
//     vec2 pos = fract(v_worldPos.xz);
//
//     // Basic grid math
//     float lineX = step(u_lineThickness, pos.x);
//     float lineZ = step(u_lineThickness, pos.y);
//     float grid = 1.0 - (lineX * lineZ);
//
//     // Fade logic: smoothstep(far_limit, near_limit, distance)
//     float dist = distance(v_worldPos.xz, u_cameraPos.xz);
//     float alpha = smoothstep(80.0, 40.0, dist); // Fades completely by 100 units
//
//     gl_FragColor = vec4(vec3(0.1), grid * alpha);
// }
//
precision mediump float;

uniform float u_lineThickness; 
uniform vec3 u_cameraPos;

varying vec3 v_worldPos;

// Helper to draw a grid line at a specific scale
float drawGrid(vec2 space, float scale, float thickness) {
    vec2 grid = abs(fract(space / scale - 0.5) - 0.5);
    // Use the camera distance to sharpen/fade lines manually
    float line = smoothstep(thickness, thickness * 0.5, min(grid.x, grid.y));
    return line;
}

void main() {
    vec2 uv = v_worldPos.xz;
    float dist = distance(uv, u_cameraPos.xz);
    
    // 1. Draw Small Grid (1.0 unit)
    float subGrid = drawGrid(uv, 1.0, 0.01);
    
    // 2. Draw Major Grid (10.0 units)
    float majorGrid = drawGrid(uv, 10.0, 0.02);
    
    // 3. Draw the Crosses (+) at 10-unit intersections
    // We check if we are very close to a 10.0 multiple on BOTH axes
    vec2 crossPos = abs(fract(uv / 10.0 - 0.5) - 0.5) * 10.0;
    float isCross = step(min(crossPos.x, crossPos.y), 0.1) * step(max(crossPos.x, crossPos.y), 0.5);

    // 4. Combine with different intensities
    vec3 color = vec3(0.0);
    float alpha = 0.0;
    
    alpha += subGrid * 0.2;     // Faint small lines
    alpha += majorGrid * 0.5;   // Stronger major lines
    alpha += isCross * 0.8;     // Brightest intersection points
    
    // 5. Global Distance Fade
    float fade = smoothstep(500.0, 50.0, dist);

    gl_FragColor = vec4(vec3(0.1), alpha * fade);
}
