import { wasmStore } from "@/scripts/wasm-store";
import { Reader } from "@/utils/utils";

// 24 verts * 4 (float32) bytes/vert
const sizeOfVerts = 96;

// 12 tris * 3 (uint16) bytes/tri
const sizeOfTris = 36;

// 24 verts * 2 (float32) bytes
const sizeOfUVs = 48;

const drawGizmo = (
  gl: WebGLRenderingContext,
  gizmoProgram: WebGLProgram,
  texture: WebGLTexture,
  sizeViewPort = 100,
  marginViewPort = 12
): void => {
  gl.useProgram(gizmoProgram);
  const gizmoData = getGizmoParams();

  if (gizmoData instanceof Error) {
    throw new Error(gizmoData.message);
  }

  const dpr = window.devicePixelRatio || 1;
  const size = Math.round(sizeViewPort * dpr);
  const margin = Math.round(marginViewPort * dpr);

  const canvas = gl.canvas as HTMLCanvasElement;
  const canvasW = canvas.width;
  // const canvasH = canvas.height;
  //

  gl.uniformMatrix4fv(
    gl.getUniformLocation(gizmoProgram, "uViewMatrix"),
    false,
    gizmoData.viewMat
  );
  gl.uniformMatrix4fv(
    gl.getUniformLocation(gizmoProgram, "uProjectionMatrix"),
    false,
    gizmoData.projMat
  );

  const x = canvasW - size - margin;
  const y = margin;

  const prevViewport: number[] = gl.getParameter(gl.VIEWPORT);
  // const prevClearColor = gl.getParameter(gl.COLOR_CLEAR_VALUE);

  gl.enable(gl.SCISSOR_TEST);
  gl.viewport(x, y, size, size);
  gl.scissor(x, y, size, size);

  // gl.clearColor(0.0, 0.0, 0.0, 0.0);
  // gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);

  // create buffers
  const triBuf = gl.createBuffer();
  const texBuf = gl.createBuffer();

  // bind Buffers
  const posBuf = gl.createBuffer();
  gl.bindBuffer(gl.ARRAY_BUFFER, posBuf);
  gl.bufferData(gl.ARRAY_BUFFER, gizmoData.verts, gl.STATIC_DRAW);
  const aPosLoc = gl.getAttribLocation(gizmoProgram, "aPosition");
  gl.vertexAttribPointer(aPosLoc, 4, gl.FLOAT, false, 0, 0);
  gl.enableVertexAttribArray(aPosLoc);

  // bind texture
  gl.activeTexture(gl.TEXTURE0);

  gl.bindTexture(gl.TEXTURE_2D, texture);
  gl.uniform1i(gl.getUniformLocation(gizmoProgram, "uSampler"), 0);

  gl.bindBuffer(gl.ARRAY_BUFFER, texBuf);
  gl.bufferData(gl.ARRAY_BUFFER, gizmoData.uvs, gl.STATIC_DRAW);
  const aTexLoc = gl.getAttribLocation(gizmoProgram, "aTexCoord");
  gl.vertexAttribPointer(aTexLoc, 2, gl.FLOAT, false, 0, 0);
  gl.enableVertexAttribArray(aTexLoc);

  // write buffer data
  gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, triBuf);
  gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, gizmoData.tris, gl.STATIC_DRAW);

  gl.drawElements(gl.TRIANGLES, 36, gl.UNSIGNED_SHORT, 0);

  gl.disableVertexAttribArray(aPosLoc);
  gl.disableVertexAttribArray(aTexLoc);

  gl.deleteBuffer(posBuf);
  gl.deleteBuffer(triBuf);
  gl.deleteBuffer(texBuf);

  gl.disable(gl.SCISSOR_TEST);
  gl.viewport(
    prevViewport[0],
    prevViewport[1],
    prevViewport[2],
    prevViewport[3]
  );
  // gl.clearColor(
  //   prevClearColor[0],
  //   prevClearColor[1],
  //   prevClearColor[2],
  //   prevClearColor[3]
  // );
};

const getGizmoParams = ():
  | {
      viewMat: Float32Array;
      projMat: Float32Array;
      verts: Float32Array;
      tris: Uint16Array;
      uvs: Float32Array;
    }
  | Error => {
  if (!wasmStore.exports) return new Error("wasmStore exports haven't loaded");

  const viewMatPtr = wasmStore.exports.returnGizmoViewMatrix();
  const projMatPtr = wasmStore.exports.returnGizmoPerspectiveMatrix();

  const viewMat = Reader(viewMatPtr, 16, Float32Array, wasmStore.exports);

  const projMat = Reader(projMatPtr, 16, Float32Array, wasmStore.exports);

  const gizmo_verts = wasmStore.exports.returnGizmoVerts();
  const gizmo_tris = wasmStore.exports.returnGizmoTris();
  const gizmo_uvs = wasmStore.exports.returnGizmoUVs();

  const gizmo_tris_view = Reader(
    gizmo_tris,
    sizeOfTris,
    Uint16Array,
    wasmStore.exports
  );
  const gizmo_verts_view = Reader(
    gizmo_verts,
    sizeOfVerts,
    Float32Array,
    wasmStore.exports
  );
  const gizmo_uvs_view = Reader(
    gizmo_uvs,
    sizeOfUVs,
    Float32Array,
    wasmStore.exports
  );

  return {
    viewMat: viewMat,
    projMat: projMat,
    verts: gizmo_verts_view,
    tris: gizmo_tris_view,
    uvs: gizmo_uvs_view,
  };
};

export default drawGizmo;
