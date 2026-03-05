export const drawGridQuad = (
  gl: WebGLRenderingContext,
  program: WebGLProgram,
  camera_pos: Float32Array,
  grid_verts: Float32Array,
  grid_tris: Float32Array,
  grid_model_matrix: Float32Array,
  view_matrix: Float32Array,
  projection_matrix: Float32Array
): void => {
  gl.useProgram(program);

  // vertext buffer
  const vbo = gl.createBuffer();
  gl.bindBuffer(gl.ARRAY_BUFFER, vbo);
  gl.bufferData(gl.ARRAY_BUFFER, grid_verts, gl.STATIC_DRAW);

  // index buffer
  const ebo = gl.createBuffer();
  gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, ebo);
  gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, grid_tris, gl.STATIC_DRAW);

  const vertex_pos_loc = gl.getAttribLocation(program, "a_vertexPosition");

  gl.vertexAttribPointer(vertex_pos_loc, 3, gl.FLOAT, false, 0, 0);
  gl.enableVertexAttribArray(vertex_pos_loc);

  const uCameraPosLoc = gl.getUniformLocation(program, "u_cameraPos");

  const uGridModelMatrixLoc = gl.getUniformLocation(
    program,
    "u_gridModelMatrix"
  );

  const uViewMatrixLoc = gl.getUniformLocation(program, "u_viewMatrix");

  const uProjectionMatrixLoc = gl.getUniformLocation(
    program,
    "u_projectionMatrix"
  );

  gl.uniform3fv(uCameraPosLoc, camera_pos);
  gl.uniformMatrix4fv(uGridModelMatrixLoc, false, grid_model_matrix);
  gl.uniformMatrix4fv(uViewMatrixLoc, false, view_matrix);
  gl.uniformMatrix4fv(uProjectionMatrixLoc, false, projection_matrix);
  gl.drawElements(gl.TRIANGLES, grid_tris.length, gl.UNSIGNED_SHORT, 0);
};
