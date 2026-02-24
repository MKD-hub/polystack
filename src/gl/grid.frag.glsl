precision mediump float;
    
uniform vec2 u_resolution;
uniform float u_cellSize;
uniform float u_lineThickness; // Keep this declared to test it's not optimized away

void main() {
	vec2 st = gl_FragCoord.xy / u_resolution;
	float intensity = (u_cellSize + u_lineThickness) * 0.15; // Minimal influence for now

	// gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0); // Pure Red, fully opaque
	// Or, to see the effect of st:
	gl_FragColor = vec4(st.x, st.y, intensity, 1.0); 
}

