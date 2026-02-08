// This module defines where to store information.

const std = @import("std");
const Mat4 = @import("../math/mat4.zig").Mat4;
const Vec4 = @import("../math/vec4.zig").Vec4;

/// @params  fovY, aspect, near and far planes
/// @returns Mat4 representing the persepective matrix
pub fn perspective(fovY: f32, aspect: f32, near: f32, far: f32) Mat4 {
    return .{
        .col0 = Vec4.init(1 / (aspect * (@tan(fovY / 2))), 0, 0, 0),
        .col1 = Vec4.init(0, 1 / @tan(fovY / 2), 0, 0),
        .col2 = Vec4.init(0, 0, (near + far) / (near - far), -1),
        .col3 = Vec4.init(0, 0, (2 * near * far) / (near - far), 0),
    };
}
