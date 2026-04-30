const std = @import("std");
const context = @import("../../context.zig");
const utils = @import("../../utils/utils.zig");
const Mat4 = @import("../../math/mat4.zig").Mat4;

const cube24_vertices: [24][4]f32 = .{
    // Front (+Z)
    .{ 1, 1, 1, 1 },   .{ -1, 1, 1, 1 },  .{ -1, -1, 1, 1 },  .{ 1, -1, 1, 1 },
    // Back (-Z)
    .{ -1, 1, -1, 1 }, .{ 1, 1, -1, 1 },  .{ 1, -1, -1, 1 },  .{ -1, -1, -1, 1 },
    // Left (-X)
    .{ -1, 1, 1, 1 },  .{ -1, 1, -1, 1 }, .{ -1, -1, -1, 1 }, .{ -1, -1, 1, 1 },
    // Right (+X)
    .{ 1, 1, -1, 1 },  .{ 1, 1, 1, 1 },   .{ 1, -1, 1, 1 },   .{ 1, -1, -1, 1 },
    // Top (+Y)
    .{ 1, 1, -1, 1 },  .{ -1, 1, -1, 1 }, .{ -1, 1, 1, 1 },   .{ 1, 1, 1, 1 },
    // Bottom (-Y)
    .{ 1, -1, 1, 1 },  .{ -1, -1, 1, 1 }, .{ -1, -1, -1, 1 }, .{ 1, -1, -1, 1 },
};

const cube24_tris: [12][3]u16 = .{
    .{ 0, 1, 2 }, .{ 0, 2, 3 }, // Front
    .{ 4, 5, 6 }, .{ 4, 6, 7 }, // Back
    .{ 8, 9, 10 }, .{ 8, 10, 11 }, // Left
    .{ 12, 13, 14 }, .{ 12, 14, 15 }, // Right
    .{ 16, 17, 18 }, .{ 16, 18, 19 }, // Top
    .{ 20, 21, 22 }, .{ 20, 22, 23 }, // Bottom
};

pub const cube24_colors: [24][3]f32 = .{
    // Front (red)
    .{ 1.0, 0.0, 0.0 }, .{ 1.0, 0.0, 0.0 }, .{ 1.0, 0.0, 0.0 }, .{ 1.0, 0.0, 0.0 },
    // Back (orange)
    .{ 1.0, 0.5, 0.0 }, .{ 1.0, 0.5, 0.0 }, .{ 1.0, 0.5, 0.0 }, .{ 1.0, 0.5, 0.0 },
    // Left (green)
    .{ 0.0, 1.0, 0.0 }, .{ 0.0, 1.0, 0.0 }, .{ 0.0, 1.0, 0.0 }, .{ 0.0, 1.0, 0.0 },
    // Right (blue)
    .{ 0.0, 0.0, 1.0 }, .{ 0.0, 0.0, 1.0 }, .{ 0.0, 0.0, 1.0 }, .{ 0.0, 0.0, 1.0 },
    // Top (yellow)
    .{ 1.0, 1.0, 0.0 }, .{ 1.0, 1.0, 0.0 }, .{ 1.0, 1.0, 0.0 }, .{ 1.0, 1.0, 0.0 },
    // Bottom (magenta)
    .{ 1.0, 0.0, 1.0 }, .{ 1.0, 0.0, 1.0 }, .{ 1.0, 0.0, 1.0 }, .{ 1.0, 0.0, 1.0 },
};

pub fn getVerts() *const [24][4]f32 {
    return &cube24_vertices;
}

pub fn getTris() *const [12][3]u16 {
    return &cube24_tris;
}

pub fn returnViewMat(g_context: context.CoreContext) *const [16]f32 {
    const gizmo_cam_pos = g_context.camera.derived.forward.scale(-5.0);

    // zig fmt: off
    utils.flattenMat4ToF32Array(
        Mat4.viewMatrix(
            g_context.camera.derived.right,
            g_context.camera.derived.up,
            g_context.camera.derived.forward,
            gizmo_cam_pos
        ),
        &g_context.gizmo_view_mat
    );
    return &g_context.gizmo_view_mat;

}

pub fn returnGizmoProjectionMatrix(g_context: context.CoreContext) *[16]f32 {
    // Since the gizmo is in a square 100x100 box, aspect is 1.0.
    utils.flattenMat4ToF32Array(Mat4.perspective(std.math.degreesToRadians(45.0), 1.0, 0.1, 10.0), &g_context.gizmo_perspective_mat);
    return &g_context.gizmo_perspective_mat;
}
