const Vec4 = @import("../math/vec4.zig").Vec4;
const Mat4 = @import("../math/mat4.zig").Mat4;
const Vec3 = @import("../math/vec3.zig").Vec3;
const Camera = @import("../core/camera.zig").Camera;
const std = @import("std");
const config = @import("../constants.zig");

pub fn flattenMat4ToF32Array(mat: Mat4, out: *[16]f32) void {
    comptime var i: usize = 0;
    inline for (@typeInfo(Mat4).@"struct".fields) |field| {
        const col: Vec4 = @field(mat, field.name);

        out[i + 0] = col.x;
        out[i + 1] = col.y;
        out[i + 2] = col.z;
        out[i + 3] = col.w;

        i += 4;
    }
}

pub fn f32ArrayToVec4(arr: *[4]f32) Vec4 {
    std.debug.assert(arr.len >= 4);

    return .{
        .x = arr[0],
        .y = arr[1],
        .z = arr[2],
        .w = arr[3],
    };
}

pub fn f32ArrayToVec3(arr: *[3]f32) Vec3 {
    std.debug.assert(arr.len >= 3);

    return .{
        .x = arr[0],
        .y = arr[1],
        .z = arr[2],
    };
}

/// -> Use this to convert from pixel units to world coordinates
/// -> Returns tuple (anonymous struct) containing world_pixel_x and world_pixel_y
pub fn convertPixelToWorldCoordinates(camera: Camera, editorConfig: config.EditorConfig) struct { x: f32, y: f32 } {
    const half_height = camera.rotation.radius * @tan(editorConfig.fov / 2);
    const world_y = (2 * half_height) / editorConfig.canvas_height;
    const world_x = world_y; 

    return .{ .x = world_x, .y = world_y };
}
