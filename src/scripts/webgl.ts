export function clear(gl: WebGLRenderingContext) {
  gl.clearColor(0.0, 0.0, 0.0, 1.0); // Clear to black, fully opaque
  gl.clearDepth(1.0); // Clear everything
  gl.enable(gl.DEPTH_TEST); // Enable depth testing
  gl.depthFunc(gl.LEQUAL); // Near things obscure far things

  // Clear the canvas before we start drawing on it.

  gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
}

export function initCanvas(canvas: HTMLCanvasElement | null) {
  const gl = canvas?.getContext("webgl");
  if (!gl) {
    throw new Error("WebGL 1 not supported!");
  }
  return gl;
}

export async function loadShaderSource(url: string) {
  const res = await fetch(url);
  return await res.text();
}
