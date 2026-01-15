import type { Prefs } from "@/scripts/prefs";

export const setupUniforms = (
  gl: WebGLRenderingContext,
  program: WebGLProgram,
  prefs: Prefs
) => {
  console.log("[PREFS]", gl);
  const uResolutionLoc = gl.getUniformLocation(program, "u_resolution");
  const uCellSizeLoc = gl.getUniformLocation(program, "u_cellSize");
  const uLineThicknessLoc = gl.getUniformLocation(program, "u_lineThickness");

  gl.uniform2f(uResolutionLoc, prefs.canvasWidth, prefs.canvasHeight);
  gl.uniform1f(uCellSizeLoc, prefs.cellSize);
  gl.uniform1f(uLineThicknessLoc, prefs.lineThickness);

  if (!uResolutionLoc || !uCellSizeLoc || !uLineThicknessLoc) {
    console.warn(
      "Some uniforms were not found. Maybe check your fragment/vertex shader to see if the compiler might have optimized them away."
    );
  }

  // For debugging
  return {
    res: uResolutionLoc,
    cell: uCellSizeLoc,
    thick: uLineThicknessLoc,
  };
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
    throw new Error("Unable to create Shader!");
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
