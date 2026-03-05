const std = @import("std");
const Vec3 = @import("../math/vec3.zig").Vec3;
const Mat4 = @import("../math/mat4.zig").Mat4;
const expect = std.testing.expect;

pub const Line = struct {
    start: Vec3,
    end: Vec3,
};

var g_grid_lines: []Line = undefined;
const epsilon: f32 = 0.00001;

pub fn generateGridData(allocator: std.mem.Allocator, size: f32, spacing: f32, aspect: f32) !void {
    const vertical_limit = size / aspect;

    var list = std.array_list.Managed(Line).init(allocator);
    defer list.deinit();

    var i: f32 = -size;
    while (i <= size + epsilon) : (i += spacing) {
        list.append(.{ .start = Vec3.init(i, 0, -vertical_limit), .end = Vec3.init(i, 0, vertical_limit) }) catch @panic("OOM");
    }

    i = -vertical_limit;
    while (i <= vertical_limit + epsilon) : (i += spacing) {
        list.append(.{ .start = Vec3.init(-size, 0, i), .end = Vec3.init(size, 0, i) }) catch @panic("OOM");
    }

    // perform appending logic to line array
    g_grid_lines = try list.toOwnedSlice();
}

pub fn getGridArrayPtr() [*]const Line {
    return g_grid_lines.ptr;
}

pub fn getGridLineCount() usize {
    return g_grid_lines.len;
}

/// @returns grid model matrix
/// @param grid_size - scale factor (make it larger than the far plane since we want to have a grid that stretches forever)
/// @param cam_pos use the camera position for the translation part (this makes the grid follow the camera around)
pub fn generateGridModelMatrix(grid_size: f32, cam_pos: Vec3) Mat4 {
    var grid_mat: Mat4 = Mat4.identity();
    grid_mat.col0 = grid_mat.col0.scale(grid_size); // x
    grid_mat.col2 = grid_mat.col2.scale(grid_size); // z
    grid_mat.col3.x = cam_pos.x;
    grid_mat.col3.y = 0; // we don't want the grid to move in the Y direction, it's the floor, we only need the XZ plane.
    grid_mat.col3.z = cam_pos.z;

    return grid_mat;
}

test "generate grid lines" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();

    try generateGridData(alloc, 10.0, 5.0, 2.0);

    const grid_ptr = getGridArrayPtr();

    try expect(@intFromPtr(grid_ptr) != 0);
}
