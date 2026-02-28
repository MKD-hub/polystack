const std = @import("std");
const heap = @import("std").heap;
const Mat4 = @import("./math/mat4.zig").Mat4;
const Vec4 = @import("./math/vec4.zig").Vec4;
const Vec3 = @import("./math/vec3.zig").Vec3;
const Camera = @import("./core/camera.zig").Camera;
const utils = @import("./utils/utils.zig");
const core = @import("./core/mvp-pipeline.zig");
const grid = @import("./core/grid.zig");
const constants = @import("./constants.zig");
const EditorConfig = @import("./constants.zig").EditorConfig;

pub const CoreContext = struct {
    allocator: std.mem.Allocator,
    config: EditorConfig,
    camera: Camera,
    view_mat: [16]f32,
    perspective_mat: [16]f32,

    pub fn init(alloc: std.mem.Allocator) CoreContext {
        return .{
            .allocator = alloc,
            .config = undefined,
            .camera = Camera.init(),
            .view_mat = undefined,
            .perspective_mat = undefined,
        };
    }
};

