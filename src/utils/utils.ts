import type {
  SliceableTypedArray,
  SliceableTypedArrayConstructor,
} from "@/types/types";
import type { WasmExports } from "@/types/wasm";

/**
 * Writes a TypedArray into Wasm Memory
 *
 * @param array
 * @param exports The Wasm exports object
 * @returns The pointer address of where the written data is
 *
 **/

export const ArrayWriter = (
  array: Int32Array | Float32Array,
  exports: WasmExports
): number => {
  const sizeInBytes = array.byteLength;
  const ptr = exports.malloc(sizeInBytes) as number; // Call Zig's malloc to get a pointer

  if (ptr === 0) {
    throw new Error("WASM malloc failed to allocate memory.");
  }

  const memoryBuffer = exports.memory.buffer;
  const bufferView = new Uint8Array(memoryBuffer, ptr, sizeInBytes);

  const sourceData = new Uint8Array(
    array.buffer,
    array.byteOffset,
    array.byteLength
  );
  bufferView.set(sourceData);

  return ptr;
};

/**
 * Reads from Wasm Memory
 *
 * @param ptr The pointer that is an offset to Wasm Memory that we want to read from
 * @param sizeToRead The size to read from Wasm Memory
 * @param elementType The element type e.g Int32Array Float32Array
 * @param exports The Wasm exports object
 *
 * @returns a shallow copy of the elementType buffer
 **/

export const Reader = <T extends SliceableTypedArray>(
  ptr: number,
  sizeToRead: number,
  elementType: SliceableTypedArrayConstructor<T>,
  exports: WasmExports
): T => {
  const memoryBuffer = exports.memory.buffer;

  const readView = new elementType(memoryBuffer, ptr, sizeToRead);

  return readView.slice() as T;
};
