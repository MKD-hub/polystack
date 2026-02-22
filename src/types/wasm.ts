export interface WasmExports {
  memory: WebAssembly.Memory;
  getIdentity(ptr: number): void;
  init_vec3(array: number, x: number, y: number, z: number): void;
  init_mat4(array: number): void;
  multiply_mat4(array: number): void;
  dot_vec3(vec1: number, vec2: number): number;
  malloc(size: number): number;
  free(ptr: number, size: number): void;
  multiplier(num: number): number;
  return_view_matrix(target: number, res: number): void;
  return_perspective(
    fov: number,
    aspect: number,
    near: number,
    far: number,
    res: number
  ): void;

  getEditorConfig(
    fov: number,
    aspect: number,
    canvas_width: number,
    canvas_height: number
  ): void;

  getGridPtr(): number;
}
