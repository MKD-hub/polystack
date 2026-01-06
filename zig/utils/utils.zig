const Vec4 = @import("../math/vec4.zig").Vec4;
const Mat4 = @import("../math/mat4.zig").Mat4;
const std = @import("std");

pub fn flattenMat4ToF32Array(mat: Mat4, out: []f32) void {
    comptime var i: usize = 0;
    inline for (@typeInfo(Mat4).Struct.fields) |field| {
        const col: Vec4 = @field(mat, field.name);

        out[i + 0] = col.x;
        out[i + 1] = col.y;
        out[i + 2] = col.z;
        out[i + 3] = col.w;

        i += 4;
    }
}

pub fn f32ArrayToVec4(arr: []const f32) Vec4 {
    std.debug.assert(arr.len >= 4);

    return .{
        .x = arr[0],
        .y = arr[1],
        .z = arr[2],
        .w = arr[3],
    };
}
