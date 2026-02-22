import { expect, test } from "vitest";
import { loadWasm } from "@/scripts/loader";
import { wasmStore } from "@/scripts/wasm-store";
import { ArrayWriter, Reader } from "@/utils/utils";

void loadWasm();

/**
 * Passing wasmStore.exports is also passing the allocator. Trying to follow in Zig's footsteps and be explicit about memory.
 * */
test("Array writer test", () => {
  const vec3Array = new Float32Array(3);
  if (wasmStore.exports) {
    const vec3ptr = ArrayWriter(vec3Array, wasmStore.exports);
    expect(vec3ptr).toBeDefined();
  }
});

test("wasm_init_vec3", () => {
  const array = new Float32Array(3);
  if (wasmStore.exports) {
    const ptr = ArrayWriter(array, wasmStore.exports);
    wasmStore.exports.init_vec3(ptr, 1, 3, 1);
    expect(ptr).toBeDefined();

    const bytesRead = Reader(ptr, 3, Float32Array, wasmStore.exports);
    expect(bytesRead).toBeDefined();
  }
});

test("wasm_dot_product_vec3", () => {
  const vec3array1 = new Float32Array(3);
  const vec3array2 = new Float32Array(3);
  if (wasmStore.exports) {
    const vec3ptr1 = ArrayWriter(vec3array1, wasmStore.exports);
    const vec3ptr2 = ArrayWriter(vec3array2, wasmStore.exports);
    wasmStore.exports.init_vec3(vec3ptr1, 8, 3, 1);
    wasmStore.exports.init_vec3(vec3ptr2, 2, 5, 2);

    expect(vec3ptr1).toBeDefined();
    expect(vec3ptr2).toBeDefined();

    const bytesRead1 = Reader(vec3ptr1, 3, Float32Array, wasmStore.exports);
    const bytesRead2 = Reader(vec3ptr2, 3, Float32Array, wasmStore.exports);

    const dotProduct = wasmStore.exports.dot_vec3(vec3ptr1, vec3ptr2);

    expect(dotProduct).toBe(33);
    expect(bytesRead1).toBeDefined();
    expect(bytesRead2).toBeDefined();
  }
});

test("wasm_init_mat4", () => {
  const array = new Float32Array(16);
  if (wasmStore.exports) {
    const ptr = ArrayWriter(array, wasmStore.exports);
    wasmStore.exports.init_mat4(ptr);
    expect(ptr).toBeDefined();

    const bytesRead = Reader(ptr, 16, Float32Array, wasmStore.exports);
    expect(bytesRead).toBeDefined();
  }
});

test("wasm_multiply_mat4", () => {
  const mat = new Float32Array(16);

  if (wasmStore.exports) {
    const ptr = ArrayWriter(mat, wasmStore.exports);
    wasmStore.exports.multiply_mat4(ptr);
    expect(ptr).toBeDefined();

    const bytesRead = Reader(ptr, 16, Float32Array, wasmStore.exports);
    expect(bytesRead).toBeDefined();

    console.log(bytesRead);
  }
});

/**
 * @test return_view_matrix
 */
test("return_view_matrix", () => {
  const target = new Float32Array([0.6, 4.0, 1.0]);
  const result = new Float32Array(16);

  if (wasmStore.exports) {
    const ptr = ArrayWriter(target, wasmStore.exports);
    const res = ArrayWriter(result, wasmStore.exports);
    wasmStore.exports.return_view_matrix(ptr, res);
    expect(ptr).toBeDefined();
    expect(res).toBeDefined();

    const bytesRead = Reader(res, 16, Float32Array, wasmStore.exports);
    expect(bytesRead).toBeDefined();

    console.log(bytesRead);
  }
});

/**
 * @test return_perspective
 */
test("return_perspective", () => {
  const result = new Float32Array(16);

  const fov = 55;
  const aspect = 16.0 / 9.0;
  const near = 10;
  const far = 50;

  if (wasmStore.exports) {
    const res = ArrayWriter(result, wasmStore.exports);
    wasmStore.exports.return_perspective(fov, aspect, near, far, res);
    expect(res).toBeDefined();

    const bytesRead = Reader(res, 16, Float32Array, wasmStore.exports);
    expect(bytesRead).toBeDefined();

    console.log("perspective ", bytesRead);
  }
});
