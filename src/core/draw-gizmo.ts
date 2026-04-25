const drawGizmo = (
  gl: WebGLRenderingContext,
  sizeViewPort = 100,
  marginViewPort = 12
): void => {
  const dpr = window.devicePixelRatio || 1;
  const size = Math.round(sizeViewPort * dpr);
  const margin = Math.round(marginViewPort * dpr);

  const canvas = gl.canvas as HTMLCanvasElement;
  const canvasW = canvas.width;
  // const canvasH = canvas.height;

  const x = canvasW - size - margin;
  const y = margin;

  const prevViewport: number[] = gl.getParameter(gl.VIEWPORT);
  const prevClearColor = gl.getParameter(gl.COLOR_CLEAR_VALUE);

  gl.enable(gl.SCISSOR_TEST);
  gl.viewport(x, y, size, size);
  gl.scissor(x, y, size, size);

  gl.clearColor(0.0, 0.0, 0.0, 1.0);
  gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);

  gl.disable(gl.SCISSOR_TEST);
  gl.viewport(
    prevViewport[0],
    prevViewport[1],
    prevViewport[2],
    prevViewport[3]
  );
  gl.clearColor(
    prevClearColor[0],
    prevClearColor[1],
    prevClearColor[2],
    prevClearColor[3]
  );
};

export default drawGizmo;
