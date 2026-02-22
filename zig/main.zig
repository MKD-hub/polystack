const std = @import("std");
const heap = @import("std").heap;
const Mat4 = @import("./math/mat4.zig").Mat4;
const Vec4 = @import("./math/vec4.zig").Vec4;
const Vec3 = @import("./math/vec3.zig").Vec3;
const Camera = @import("./core/camera.zig").Camera;
const utils = @import("./utils/utils.zig");
const core = @import("./core/mvp-pipeline.zig");
const EditorConfig = @import("./constants.zig").EditorConfig;

var gpa = heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator(); // Not sure if this is idiomatic, but global allocator over here. Just one. Used everywhere.

var g_print_buf: [256]u8 = undefined; // buffer to print from

var g_editor_config: EditorConfig = undefined;
var g_camera: Camera = undefined;

extern fn printMat4(mat: *Mat4) void;

extern fn logString(string: [*c]const u8) void; // Take C-style string and print on the JS side.

export fn getEditorConfig(fov: f32, aspect: f32, canvas_width: f32, canvas_height: f32) void {
    g_editor_config.fov = fov;
    g_editor_config.aspect = aspect;
    g_editor_config.canvas_width = canvas_width;
    g_editor_config.canvas_height = canvas_height;

    // zig fmt: off
    // For printing from Zig to JS
    const formatted_string = std.fmt.bufPrintZ(&g_print_buf, "Editor Config: FOV={d:.2}, Aspect={d:.4}, CanvasW={d:.0}, CanvasH={d:.0}", .{
        g_editor_config.fov,
        g_editor_config.aspect,
        g_editor_config.canvas_width,
        g_editor_config.canvas_height
    }) catch { 
        logString("Error formatting string");
        return; 
    };

    logString(formatted_string);
}

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

export fn initCamera() void {
    g_camera = Camera.init();   
}

export fn get_grid_ptr() void {
}
