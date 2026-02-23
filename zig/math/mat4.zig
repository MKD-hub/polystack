///! This module provides a basic mat4 implementation
const Vec4 = @import("vec4.zig").Vec4;
const Vec3 = @import("vec3.zig").Vec3;
const constants = @import("../constants.zig");

pub const Mat4 = struct {
    col0: Vec4,
    col1: Vec4,
    col2: Vec4,
    col3: Vec4,

    pub fn init() Mat4 {
        return .{
            .col0 = Vec4.init(0, 0, 0, 0),
            .col1 = Vec4.init(0, 0, 0, 0),
            .col2 = Vec4.init(0, 0, 0, 0),
            .col3 = Vec4.init(0, 0, 0, 0),
        };
    }

    pub fn identity() Mat4 {
        return .{
            .col0 = Vec4.init(1, 0, 0, 0),
            .col1 = Vec4.init(0, 1, 0, 0),
            .col2 = Vec4.init(0, 0, 1, 0),
            .col3 = Vec4.init(0, 0, 0, 1),
        };
    }

    pub fn multiplyWithVec4(self: Mat4, vec: Vec4) Vec4 {
        const outVec4 = self.col0.scale(vec.x)
            .add(self.col1.scale(vec.y))
            .add(self.col2.scale(vec.z))
            .add(self.col3.scale(vec.w));

        return outVec4;
    }

    pub fn multiplyMat4(self: Mat4, other: Mat4) Mat4 {
        return .{
            .col0 = self.multiplyWithVec4(other.col0),
            .col1 = self.multiplyWithVec4(other.col1),
            .col2 = self.multiplyWithVec4(other.col2),
            .col3 = self.multiplyWithVec4(other.col3),
        };
    }

    pub fn viewMatrix(right: Vec3, up: Vec3, forward: Vec3, camPos: Vec3) Mat4 {
        var viewMat: Mat4 = Mat4.init();

        viewMat.col0 = Vec4.init(right.x, up.x, forward.x, 0);

        viewMat.col1 = Vec4.init(right.y, up.y, forward.y, 0);

        viewMat.col2 = Vec4.init(right.z, up.z, forward.z, 0);

        viewMat.col3 = Vec4.init(-right.dot(camPos), -up.dot(camPos), -forward.dot(camPos), 1);

        return viewMat;
    }
};
