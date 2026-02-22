const std = @import("std");
const Vec3 = @import("../math/vec3.zig").Vec3;
const mem = @import("../memory.zig");
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

pub fn getGridLinePtr() [*]const Line {
    return g_grid_lines.ptr;
}

pub fn getGridLineCount() usize {
    return g_grid_lines.len;
}

test "generate grid lines" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();
    
    try gen_grid.generateGridData(alloc, 10.0, 5.0, 2.0);    

    const grid_ptr = gen_grid.getGridLinePtr();

    try expect(@intFromPtr(grid_ptr) != 0);
}
