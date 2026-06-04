/**
 * @definition pointer type added for readability
 */
export type pointer = number;

export interface WasmExports {
  memory: WebAssembly.Memory;
  malloc(size: number): pointer;
  free(ptr: pointer, size: number): void;

  getEditorConfig(
    fov: number,
    aspect: number,
    near: number,
    far: number,
    sensitivity: number,
    canvas_width: number,
    canvas_height: number
  ): void;

  getGridPtr(): pointer;
  updateCamera(): void;
  returnViewMatrix(): pointer; // to Float32Array
  returnPerspectiveMatrix(): pointer; // to Float32Array
  cameraRotate(theta: number, phi: number): void;
  getCameraPos(): pointer; // to Float32Array
  zoom(zoom: number): void;
  pan(delta_x: number, delta_y: number): void;
  getGridVerts(): pointer; // to Float32Array
  getGridTriangles(): pointer; // to Uint16Array
  generateAndReturnGridQuad(size: number): pointer; // Float32Array
  resetPan(): void;
  returnGizmoViewMatrix(): pointer;
  returnGizmoPerspectiveMatrix(): pointer;
  returnGizmoVerts(): pointer;
  returnGizmoTris(): pointer;
  returnGizmoColors(): pointer;
  returnGizmoUVs(): pointer;
}
