const Vec4 = @import("../math/vec4.zig").Vec4;
const Mat4 = @import("../math/mat4.zig").Mat4;
const Vec3 = @import("../math/vec3.zig").Vec3;
const std = @import("std");

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
