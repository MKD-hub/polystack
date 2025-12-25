// Import memory.zig for its side effects (exporting malloc and free)

const heap = @import("std").heap;
const Mat4 = @import("mat4.zig").Mat4;

var gpa = heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

extern fn printMat4(mat: *Mat4) void;

extern fn logString(string: [*]const u8) void;

export fn malloc(size: usize) ?[*]u8 {
    // allocator.alloc returns a slice, but for FFI we want a pointer.
    // We return [*]u8 which is a "many-item pointer", the idiomatic way to return a pointer
    // that will be treated like an array on the other side.
    const slice = allocator.alloc(u8, size) catch |err| {
        if (err == error.OutOfBounds) {
            logString("No More Memory!");
        }
        return null;
    };
    return slice.ptr;
}

export fn free(ptr: [*]u8, size: usize) void {
    // We give the allocator a slice of the memory to free.
    allocator.free(ptr[0..size]);
}

export fn getIdentity(mat_ptr: *Mat4) void {
    mat_ptr.* = Mat4.Identity();
    // printMat4(mat_ptr);
}

export fn multiplier(number: f32) f32 {
    return number * number;
}
