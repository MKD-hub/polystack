const std = @import("std");
const Vec3 = @import("math/vec3.zig").Vec3;
const mem = @import("../memory.zig");

pub const Line = struct {
    start: Vec3,
    end: Vec3,
};

var g_grid_lines: []Line = undefined;

pub fn generateGridData(allocator: std.mem.Allocator, size: f32, spacing: f32, aspect: f32) !void {
    var list = std.ArrayList(Line).init(allocator);
    defer list.deinit();

    if (g_grid_lines.len > 0) {
        allocator.free(g_grid_lines);
    }

    // perform appending logic to line array
    g_grid_lines = try list.toOwnedSlice();
}

pub fn getGridLinePtr() *const Line {
    return g_grid_lines;
}

pub fn getGridLineCount() usize {
    return g_grid_lines.len;
}
