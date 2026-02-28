const std = @import("std");
const heap = @import("std").heap;
const Mat4 = @import("./math/mat4.zig").Mat4;
const utils = @import("./utils/utils.zig");
const core = @import("./core/mvp-pipeline.zig");
const grid = @import("./core/grid.zig");
const constants = @import("./constants.zig");
const context = @import("./context.zig");

pub extern fn logString(string: [*c]const u8) void; // Take C-style string and print on the JS side.
pub const std_options: std.Options = .{ .log_level = .info, .logFn = wasmLog };

pub fn wasmLog(comptime level: std.log.Level, comptime scope: @Type(.enum_literal), comptime format: []const u8, args: anytype) void {
    const scope_prefix = "(" ++ switch (scope) {
        .camera, .math, .editor_config, std.log.default_log_scope => @tagName(scope),
        else => if (@intFromEnum(level) <= @intFromEnum(std.log.Level.err))
            @tagName(scope)
        else
            return,
    } ++ "): ";

    const prefix = "[" ++ comptime level.asText() ++ "] " ++ scope_prefix;

    var buf: [256]u8 = undefined;
    const formatted_string = std.fmt.bufPrintZ(&buf, prefix ++ format, args) catch |err| {
        logString("Log Broken");
        @panic(@errorName(err));
    };
    logString(formatted_string);
}


var gpa = heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator(); // Not sure if this is idiomatic, but global allocator over here. Just one. Used everywhere.
var g_context: context.CoreContext = context.CoreContext.init(allocator);

pub const editor_config_log = std.log.scoped(.editor_config);
pub const camera_log = std.log.scoped(.camera);

export fn getEditorConfig(
    fov:           f32,
    aspect:        f32,
    near:          f32,
    far:           f32,
    sensitivity:   f32,
    canvas_width:  f32,
    canvas_height: f32
) void {
    g_context.config.fov           = fov;
    g_context.config.aspect        = aspect;
    g_context.config.near          = near;
    g_context.config.far           = far;
    g_context.config.sensitivity   = sensitivity;
    g_context.config.canvas_width  = canvas_width;
    g_context.config.canvas_height = canvas_height;

    // zig fmt: off
    // For printing from Zig to JS
    editor_config_log.warn("Editor Config: FOV={d:.4}, Aspect={d:.4}, Near={d:.4}, Far={d:.4}, Sensitivity={d:.4}, CanvasW={d:.4}, CanvasH={d:.4}\n", .{
        g_context.config.fov,
        g_context.config.aspect,
        g_context.config.near,
        g_context.config.far,
        g_context.config.sensitivity,
        g_context.config.canvas_width,
        g_context.config.canvas_height
    });
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

export fn getGridPtr(grid_size: f32, grid_spacing: f32) usize {
    grid.generateGridData(allocator, grid_size, grid_spacing, g_context.config.aspect) catch {
        logString("Grid Creation Failed");
    };
    return @intFromPtr(grid.getGridArrayPtr());
}

export fn updateCamera() void {
    g_context.camera.updateOrientation();
}

export fn returnViewMatrix() *[16]f32 {
    // zig fmt: off
    utils.flattenMat4ToF32Array(
        Mat4.viewMatrix(
            g_context.camera.derived.right,
            g_context.camera.derived.up,
            g_context.camera.derived.forward,
            g_context.camera.state.position
        ),
        &g_context.view_mat
    );

    return &g_context.view_mat;
}

export fn cameraRotate(theta: i32, phi: i32) void {
    camera_log.info("theta = {d:.4}, phi = {d:.4}\n", .{theta, phi});
    const r_theta = @as(f32, @floatFromInt(theta))   * g_context.config.sensitivity;
    const r_phi   = @as(f32, @floatFromInt(phi))     * g_context.config.sensitivity;
    g_context.camera.updateSpherical(r_theta, r_phi);
}

export fn zoom(js_delta_y: f32) void {
    const zoom_sensitivity: f32 = 0.05;
    const delta_radius = js_delta_y * zoom_sensitivity; 
    g_context.camera.zoom(delta_radius);
}

export fn returnPerspectiveMatrix() *[16]f32 {
    // zig fmt: off
     utils.flattenMat4ToF32Array(core.perspective(
        g_context.config.fov,
        g_context.config.aspect,
        g_context.config.near,
        g_context.config.far
    ), 
        &g_context.perspective_mat
    );

    return &g_context.perspective_mat;
}
