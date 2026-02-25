const std          = @import("std");
const heap         = @import("std").heap;
const Mat4         = @import("./math/mat4.zig").Mat4;
const Vec4         = @import("./math/vec4.zig").Vec4;
const Vec3         = @import("./math/vec3.zig").Vec3;
const Camera       = @import("./core/camera.zig").Camera;
const utils        = @import("./utils/utils.zig");
const core         = @import("./core/mvp-pipeline.zig");
const grid         = @import("./core/grid.zig");
const constants    = @import("./constants.zig");
const EditorConfig = @import("./constants.zig").EditorConfig;
const Logger       = @import("./utils/logger.zig").Logger;

var gpa = heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator(); // Not sure if this is idiomatic, but global allocator over here. Just one. Used everywhere.

pub var g_print_buf: [256]u8 = undefined; // buffer to print from. TODO: Abstract this into a logger.
var lg: Logger = undefined;

var g_editor_config: EditorConfig = undefined;
var g_camera: Camera = undefined;

var g_view_mat: [16]f32 = undefined;
var g_perspective_mat: [16]f32 = undefined;

extern fn printMat4(mat: *Mat4) void;

pub extern fn logString(string: [*c]const u8) void; // Take C-style string and print on the JS side.

// zig fmt: off
export fn getEditorConfig(
    fov:           f32,
    aspect:        f32,
    near:          f32,
    far:           f32,
    sensitivity:   f32,
    canvas_width:  f32,
    canvas_height: f32
) void {
    g_editor_config.fov           = fov;
    g_editor_config.aspect        = aspect;
    g_editor_config.near          = near;
    g_editor_config.far           = far;
    g_editor_config.sensitivity   = sensitivity;
    g_editor_config.canvas_width  = canvas_width;
    g_editor_config.canvas_height = canvas_height;

    // zig fmt: off
    // For printing from Zig to JS
    const formatted_string = std.fmt.bufPrintZ(&g_print_buf, "Editor Config: FOV={d:.2}, Aspect={d:.4}, Near={d:.4}, Far={d:.4}, Sensitivity={d:.4}, CanvasW={d:.0}, CanvasH={d:.0}", .{
        g_editor_config.fov,
        g_editor_config.aspect,
        g_editor_config.near,
        g_editor_config.far,
        g_editor_config.sensitivity,
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
    lg.buf = undefined;
    lg.log("{any}\n", g_camera.derived);
    const formatted_string = std.fmt.bufPrintZ(&g_print_buf, "CAMERA: {any}\n", .{
        g_camera.derived
    }) catch { 
        logString("Error formatting string");
        return;
    };
    logString(formatted_string);
}

export fn getGridPtr() usize {
    // TODO: make size adjust based on zoom level, save grid spacing in constants, save aspect in editor_configs
    grid.generateGridData(allocator, 40, 2, 1.77) catch {
        logString("Grid Creation Failed");
    };
    return @intFromPtr(grid.getGridArrayPtr());
}

export fn updateCamera() void {
    g_camera.updateOrientation();
}

export fn returnViewMatrix() *[16]f32 {
    // zig fmt: off
    utils.flattenMat4ToF32Array(
        Mat4.viewMatrix(
            g_camera.derived.right,
            g_camera.derived.up,
            g_camera.derived.forward,
            g_camera.state.position
        ),
        &g_view_mat
    );

    return &g_view_mat;
}

export fn cameraRotate(theta: i32, phi: i32) void {
    lg.log("theta, phi {any}\n", .{theta, phi});
    const r_theta = @as(f32, @floatFromInt(theta))   * g_editor_config.sensitivity;
    const r_phi   = @as(f32, @floatFromInt(phi))     * g_editor_config.sensitivity;
    g_camera.updateSpherical(r_theta, r_phi);
}

export fn zoom(js_delta_y: f32) void {
    const zoom_sensitivity: f32 = 0.05;
    const delta_radius = js_delta_y * zoom_sensitivity; 
    g_camera.zoom(delta_radius);
}

export fn returnPerspectiveMatrix() *[16]f32 {
    // zig fmt: off
     utils.flattenMat4ToF32Array(core.perspective(
        g_editor_config.fov,
        g_editor_config.aspect,
        g_editor_config.near,
        g_editor_config.far
    ), 
        &g_perspective_mat
    );

    return &g_perspective_mat;
}
