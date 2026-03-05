const Vec3 = @import("./math/vec3.zig").Vec3;

pub const world_up = Vec3.init(0, 1, 0);
pub const world_origin = Vec3.init(0, 0, 0);

pub const EditorConfig = struct {
    fov: f32,
    aspect: f32,
    near: f32,
    far: f32,
    sensitivity: f32,
    canvas_width: f32,
    canvas_height: f32,
};

/// Grid vertices that will get scaled up later.
/// Hours wasted here: **3**
/// Make sure to follow WebGL requirements for rendering
/// Start at bottom_left and work your way up to top_right, this is the array order WebGL expects
pub const v_grid = struct {
    top_left: Vec3,
    top_right: Vec3,
    bottom_left: Vec3,
    bottom_right: Vec3,

    pub const default: v_grid = .{
        .bottom_left = Vec3.init(-1, 0, -1),
        .bottom_right = Vec3.init(1, 0, -1),
        .top_left = Vec3.init(-1, 0, 1),
        .top_right = Vec3.init(1, 0, 1),
    };
};

// Grid triangles
pub const t_grid = struct {
    first: [3]u16,
    second: [3]u16,

    pub const default: t_grid = .{
        .first = [3]u16{0, 1, 2},
        .second = [3]u16{1, 3, 2},
    };
};
