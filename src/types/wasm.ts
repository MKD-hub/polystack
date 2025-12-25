export interface WasmExports {
  memory: WebAssembly.Memory;
  getIdentity(ptr: number): void;
  malloc(size: number): number;
  free(ptr: number, size: number): void;
  multiplier(num: number): number;
}
