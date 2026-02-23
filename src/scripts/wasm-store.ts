import type { WasmExports } from "@/types/wasm";

// This is our singleton store.
// It holds the memory and the exported functions from the WASM module.
interface WasmStore {
  memory: WebAssembly.Memory | null;
  exports: WasmExports | null;
}

export const wasmStore: WasmStore = {
  memory: null,
  exports: null,
};

// This function initializes our store.
export function setWasmStore(instance: WebAssembly.Instance) {
  wasmStore.memory = instance.exports.memory as WebAssembly.Memory;
  wasmStore.exports = instance.exports as unknown as WasmExports;
  console.log("WASM Store Initialized.");
}
