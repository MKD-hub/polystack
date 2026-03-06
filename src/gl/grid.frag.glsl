precision mediump float;

uniform float u_lineThickness; 
uniform float u_gridSpacingMajor;
uniform float u_gridSpacingMinor;
uniform vec3 u_cameraPos;

varying vec3 v_worldPos;

// Enhanced grid drawer with distance-aware thickness
float drawGrid(vec2 space, float scale, float thickness, float dist) {
    vec2 grid = abs(fract(space / scale - 0.5) - 0.5);
    
    // Scale thickness by distance to prevent sub-pixel thinning
    float dynamicThickness = thickness + (dist * 0.001); 
    float line = smoothstep(dynamicThickness, dynamicThickness * 0.5, min(grid.x, grid.y));
    return line;
}

void main() {
    vec2 uv = v_worldPos.xz;
    float dist = distance(uv, u_cameraPos.xz);
    
    // Define Color Palette
    vec3 majorColor = vec3(0.6);           // White major lines
    vec3 minorColor = vec3(0.2, 0.3, 0.4); // Subtle blue-ish minor lines
    vec3 crossColor = vec3(0.6);           // Highlight color for intersections
    
    // 1. Calculate Grid LOD Factors
    // Minor lines fade out completely by distance 50
    float minorLOD = smoothstep(50.0, 10.0, dist);
    // Major lines fade out completely by distance 500
    float majorLOD = smoothstep(200.0, 100.0, dist);
    
    // 2. Compute Patterns
    float subGrid = drawGrid(uv, u_gridSpacingMinor, 0.01, dist);
    float majorGrid = drawGrid(uv, u_gridSpacingMajor, u_lineThickness, dist);
    
    vec2 crossPos = abs(fract(uv / u_gridSpacingMajor - 0.5) - 0.5) * u_gridSpacingMajor;
    float isCross = step(min(crossPos.x, crossPos.y), 0.1) * step(max(crossPos.x, crossPos.y), 0.5);

    // 3. Layering with Transparency
    vec3 finalColor = vec3(0.0);
    float alpha = 0.0;

    // Layer: Minor Lines (Only show if close)
    finalColor = mix(finalColor, minorColor, subGrid * minorLOD);
    alpha = max(alpha, subGrid * 0.2 * minorLOD);

    // Layer: Major Lines
    finalColor = mix(finalColor, majorColor, majorGrid * majorLOD);
    alpha = max(alpha, majorGrid * 0.5 * majorLOD);

    // Layer: Intersections
    finalColor = mix(finalColor, crossColor, isCross * majorLOD);
    alpha = max(alpha, isCross * 1.0 * majorLOD);

    // 4. Output
    gl_FragColor = vec4(finalColor, alpha);
}
