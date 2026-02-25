export interface WasmExports {
  memory: WebAssembly.Memory;
  malloc(size: number): number;
  free(ptr: number, size: number): void;

  getEditorConfig(
    fov: number,
    aspect: number,
    near: number,
    far: number,
    sensitivity: number,
    canvas_width: number,
    canvas_height: number
  ): void;

  getGridPtr(): number;
  updateCamera(): void;
  returnViewMatrix(): Float32Array;
  returnPerspectiveMatrix(): Float32Array;
  cameraRotate(theta: number, phi: number): void;
  zoom(zoom: number): void;
}
