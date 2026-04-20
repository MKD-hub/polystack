import { wasmStore } from "@/scripts/wasm-store";

export const panReset = () => {
  wasmStore.exports?.resetPan();
};
