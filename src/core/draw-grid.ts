export const drawGrid = (
  gl: WebGLRenderingContext,
  program: WebGLProgram,
  grid_lines: Float32Array,
  grid_buffer: WebGLBuffer,
  grid_vert_count: number,
  view_matrix: Float32Array,
  projection_matrix: Float32Array
) => {
  gl.useProgram(program);
  gl.bindBuffer(gl.ARRAY_BUFFER, grid_buffer);
  gl.bufferData(gl.ARRAY_BUFFER, grid_lines, gl.STATIC_DRAW);

  const vertex_pos_loc = gl.getAttribLocation(program, "aVertexPosition");
  gl.enableVertexAttribArray(vertex_pos_loc);
  gl.vertexAttribPointer(vertex_pos_loc, 3, gl.FLOAT, false, 0, 0);

  const uModelViewMatrixLoc = gl.getUniformLocation(
    program,
    "uModelViewMatrix"
  );
  const uProjectionMatrixLoc = gl.getUniformLocation(
    program,
    "uProjectionMatrix"
  );

  gl.uniformMatrix4fv(uModelViewMatrixLoc, false, view_matrix);
  gl.uniformMatrix4fv(uProjectionMatrixLoc, false, projection_matrix);

  gl.drawArrays(gl.LINES, 0, grid_vert_count);
};
