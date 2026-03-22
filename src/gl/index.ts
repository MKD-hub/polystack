import type { Prefs } from "@/scripts/prefs";

export const setupUniforms = (
  gl: WebGLRenderingContext,
  program: WebGLProgram,
  prefs: Prefs
): void => {
  const uniforms = {
    uMinorLineThicknessLoc: gl.getUniformLocation(
      program,
      "u_minorLineThickness"
    ),
    uMajorLineThicknessLoc: gl.getUniformLocation(
      program,
      "u_majorLineThickness"
    ),
    uGridSpacingMajorLoc: gl.getUniformLocation(program, "u_gridSpacingMajor"),
    uGridSpacingMinorLoc: gl.getUniformLocation(program, "u_gridSpacingMinor"),
    uBgColorLoc: gl.getUniformLocation(program, "u_bgColor"),
  };

  gl.uniform1f(uniforms.uMinorLineThicknessLoc, prefs.minorGridLineThickness);
  gl.uniform1f(uniforms.uMajorLineThicknessLoc, prefs.majorGridLineThickness);
  gl.uniform1f(uniforms.uGridSpacingMajorLoc, prefs.gridSpacingMajor);
  gl.uniform1f(uniforms.uGridSpacingMinorLoc, prefs.gridSpacingMinor);
  gl.uniform4f(
    uniforms.uBgColorLoc,
    prefs.gridColor.r,
    prefs.gridColor.g,
    prefs.gridColor.b,
    prefs.gridColor.a
  );

  // Loop through the uniform locations
  for (const [key, location] of Object.entries(uniforms)) {
    if (location === null) {
      console.warn(
        `Uniform Location Error: "${key}" was not found in the shader program. Check if it's being used, it may have been optimized away by the GLSL compiler.`
      );
    }
  }
};

export const loadShader = (
  gl: WebGLRenderingContext,
  type: number,
  source: string
) => {
  const shader = gl.createShader(type);

  if (shader) {
    gl.shaderSource(shader, source);

    gl.compileShader(shader);

    if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) {
      alert(
        `An error occurred compiling the shaders: ${gl.getShaderInfoLog(shader)}`
      );
      gl.deleteShader(shader);
      return null;
    }
  }
  return shader;
};

export const initShaderProgram = (
  gl: WebGLRenderingContext,
  vsSource: string,
  fsSource: string
) => {
  const vertexShader = loadShader(gl, gl.VERTEX_SHADER, vsSource);
  const fragShader = loadShader(gl, gl.FRAGMENT_SHADER, fsSource);

  if (!vertexShader || !fragShader) {
    throw new Error("Unable to create Shader(s)!");
  }

  const shaderProgram = gl.createProgram();
  gl.attachShader(shaderProgram, vertexShader);
  gl.attachShader(shaderProgram, fragShader);

  gl.linkProgram(shaderProgram);

  if (!gl.getProgramParameter(shaderProgram, gl.LINK_STATUS)) {
    alert(
      `Unable to initialize the shader program: ${gl.getProgramInfoLog(
        shaderProgram
      )}`
    );
    return null;
  }

  return shaderProgram;
};
