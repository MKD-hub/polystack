import { wasmStore, setWasmStore } from "@/scripts/wasm-store";

const importObject = {
  env: {
    printMat4: (ptr: number) => {
      if (wasmStore.memory) {
        const matrixData = new Float32Array(wasmStore.memory.buffer, ptr, 16);
        console.log("Matrix Data:", matrixData);
      }
    },
    logString: (ptr: number) => {
      if (wasmStore.memory) {
        const bytes = new Uint8Array(wasmStore.memory.buffer);
        let end = ptr;
        while (bytes[end] !== 0) {
          end++;
        }
        const text = new TextDecoder().decode(bytes.slice(ptr, end));
        console.log("LOG FROM ZIG: ", text);
      }
    },
  },
};

export async function loadWasm() {
  // const response = await fetch("/wasmtest.wasm");
  // const buffer = await response.arrayBuffer();
  const { instance } = await WebAssembly.instantiateStreaming(
    fetch("/polystack.wasm"),
    importObject
  );

  // Initialize our singleton store with the instance
  setWasmStore(instance);

  // // Return the exports for convenience
  // return instance.exports;
}
