export type SliceableTypedArray =
  | Int8Array
  | Uint8Array
  | Int16Array
  | Uint16Array
  | Int32Array
  | Uint32Array
  | Float32Array
  | Float64Array;

export type SliceableTypedArrayConstructor<T extends SliceableTypedArray> = {
  new (buffer: ArrayBuffer, byteOffset?: number, length?: number): T;
};
