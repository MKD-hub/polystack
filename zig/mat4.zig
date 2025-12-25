pub const Mat4 = struct {
    elements: [16]f32,

    pub fn Identity() Mat4 {
        return Mat4{ .elements = [_]f32{ 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 } };
    }
};


