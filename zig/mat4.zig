const vec3 = @import("vec3.zig").Vec3;

pub const Mat4 = struct {
    elements: [16]f32,

    pub fn init() Mat4 {
        return Mat4{ .elements = [_]f32{0} ** 16 };
    }

    pub fn identity() Mat4 {
        return Mat4{ .elements = [_]f32{ 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 } };
    }

    pub fn multiplyMat4(self: *Mat4, other: *Mat4) Mat4 {
        var out: Mat4 = Mat4.init();
        for (0..3) |col| {
            for (0..3) |row| {
                for (0..3) |k| {
                    out.elements[col * 4 + row] += self.elements[k * 4 + row] * other.elements[col * 4 + k];
                }
            }
        }
    }

    pub fn multiplyVec3(self: *Mat4, vec: vec3) Mat4 {

    }
};
