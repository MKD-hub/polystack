const generateGizmoTexture = (
  gl: WebGLRenderingContext
): WebGLTexture | null => {
  const canvas = document.createElement("canvas");
  canvas.width = 512; // Higher resolution = crisper text
  canvas.height = 512;
  const ctx = canvas.getContext("2d");

  if (!ctx) return null;

  // 1. Draw your 2x3 grid of labels
  ctx.fillStyle = "#ffffff"; // White background
  ctx.fillRect(0, 0, 512, 512);

  ctx.fillStyle = "#000000"; // Black text
  ctx.font = "bold 60px sans-serif";
  ctx.textAlign = "center";
  ctx.textBaseline = "middle";

  // Example: Drawing "TOP" in the first box of the 2x3 grid
  ctx.fillText("TOP", 128, 85);

  // BOTTOM Face (Row 2, Col 1)
  ctx.fillText("DOWN", 384, 85);

  // FRONT Face (Row 1, Col 0)
  ctx.fillText("FRONT", 128, 256);

  // BACK Face (Row 1, Col 1)
  ctx.fillText("BACK", 384, 256);

  // LEFT Face (Row 0, Col 0)
  ctx.fillText("LEFT", 128, 426);

  // RIGHT Face (Row 0, Col 1)
  ctx.fillText("RIGHT", 384, 426);

  // 2. Turn this canvas into a WebGL Texture
  const texture = gl.createTexture();
  gl.bindTexture(gl.TEXTURE_2D, texture);

  gl.pixelStorei(gl.UNPACK_FLIP_Y_WEBGL, true);
  // Use the hidden 'offscreen' canvas as the source
  gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, canvas);
  gl.generateMipmap(gl.TEXTURE_2D);

  gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, canvas);

  // Set scaling filters so it looks good
  gl.generateMipmap(gl.TEXTURE_2D);

  return texture;
};

export default generateGizmoTexture;
