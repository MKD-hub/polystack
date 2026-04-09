// Might need to add object names here when implementing a scene graph later.
pub const cube = struct {
    vertices: f32[8][4],
    tris: u16[12][3],

    pub const defaultCube: cube = .{
        // zig fmt: off
        .vertices = .{
            .{  1,  1, -1, 1 },
            .{ -1,  1, -1, 1 },
            .{ -1, -1, -1, 1 },
            .{  1, -1, -1, 1 },
            .{  1,  1,  1, 1 },
            .{ -1,  1,  1, 1 },
            .{ -1, -1,  1, 1 },
            .{  1, -1,  1, 1 }
        },

        .tris = .{
            .{ 0, 1, 2 },
            .{ 0, 2, 3 },
            .{ 4, 0, 3 },
            .{ 4, 3, 7 },
            .{ 5, 4, 7 },
            .{ 5, 7, 6 },
            .{ 1, 5, 6 },
            .{ 1, 6, 2 },
            .{ 4, 5, 1 },
            .{ 4, 1, 0 },
            .{ 2, 6, 7 },
            .{ 2, 7, 3 }

        }
    };
};
