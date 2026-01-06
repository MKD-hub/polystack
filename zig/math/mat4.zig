const Vec4 = @import("vec4.zig").Vec4;

pub const Mat4 = struct {
    colx: Vec4,
    coly: Vec4,
    colz: Vec4,
    col3: Vec4,

    pub fn init() Mat4 {
        return .{
            .col0 = Vec4.init{ 0, 0, 0, 0 },
            .col1 = Vec4.init{ 0, 0, 0, 0 },
            .col2 = Vec4.init{ 0, 0, 0, 0 },
            .col3 = Vec4.init{ 0, 0, 0, 0 },
        };
    }

    pub fn identity() Mat4 {
        return .{
            .col0 = Vec4.init{ 1, 0, 0, 0 },
            .col1 = Vec4.init{ 0, 1, 0, 0 },
            .col2 = Vec4.init{ 0, 0, 1, 0 },
            .col3 = Vec4.init{ 0, 0, 0, 1 },
        };
    }

    pub fn multiplyWithVec4(self: Mat4, vec: Vec4) Vec4 {
        return .{
            self.col0.scale(vec.x)
            .add(self.col1.scale(vec.y))
            .add(self.col2.scale(vec.z))
            .add(self.col3.scale(vec.w))
        };
    }

    pub fn multiplyMat4(self: Mat4, other: Mat4) Mat4 {
        return .{
            .col0 = self.multiplyWithVec4(other.col0),
            .col1 = self.multiplyWithVec4(other.col1),
            .col2 = self.multiplyWithVec4(other.col2),
            .col3 = self.multiplyWithVec4(other.col3),
        };
    }
};
