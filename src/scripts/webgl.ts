export function clear(gl: WebGLRenderingContext) {
  gl.clearColor(0.0, 0.0, 0.0, 1.0);
  gl.clear(gl.COLOR_BUFFER_BIT);
}

export function initCanvas(canvas: HTMLCanvasElement | null) {
  const gl = canvas?.getContext("webgl");
  return gl;
}
