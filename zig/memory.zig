const std = @import("std");

// 1. Create a General Purpose Allocator.
//    This gives us memory safety in debug builds and speed in release builds.
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
pub const allocator = gpa.allocator();

// 2. Export malloc and free for JavaScript to use.
export fn malloc(size: usize) ?[*]u8 {
    // allocator.alloc returns a slice, but for FFI we want a pointer.
    // We return [*]u8 which is a "many-item pointer", the idiomatic way to return a pointer
    // that will be treated like an array on the other side.
    const slice = allocator.alloc(u8, size) catch |err| {
        std.debug.print("malloc failed: {}\n", .{err});
        return null;
    };
    return slice.ptr;
}

export fn free(ptr: [*]u8, size: usize) void {
    // We give the allocator a slice of the memory to free.
    allocator.free(ptr[0..size]);
}

