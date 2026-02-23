const Vec3 = @import("../math/vec3.zig").Vec3;
const Mat4 = @import("../math/mat4.zig").Mat4;
const constants = @import("../constants.zig");

// zig fmt: off
const CameraState = struct { 
    position: Vec3, 

    const default: CameraState = .{
        .position = Vec3.init(0, -2, 10),
    };
};

// zig fmt: off
const CameraDerived = struct { 
    right: Vec3, 
    up: Vec3, 
    forward: Vec3, 

    const default: CameraDerived = .{
        .right = Vec3.init(0, 0, 0),
        .up = Vec3.init(0, 0, 0),
        .forward = Vec3.init(0, 0, 0)
    };
};

// zig fmt: off
const CameraLens = struct {
    zoom_level: f32, 
    near_plane: f32, 
    far_plane: f32, 

    const default: CameraLens = .{
        .zoom_level = 1,
        .near_plane = 2,
        .far_plane = 4,
    };
};

// zig fmt: off
pub const Camera = struct {
    state: CameraState,
    derived: CameraDerived,
    lens: CameraLens,

    pub fn init() Camera {
        return .{
            .state = CameraState.default,
            .derived = CameraDerived.default,
            .lens = CameraLens.default // TODO: Make this user defined, these defaults are temporary
        };
    }

    pub fn lookAt(self: *const Camera, target: Vec3) CameraDerived {
        // LookAt function
        const cameraZ: Vec3 = target.subtract(self.state.position).normalize() catch |err| {
            @panic(err);
        };
        const cameraX: Vec3 = cameraZ.cross(constants.world_up).normalize() catch |err| {
            @panic(err);
        };
        const cameraY: Vec3 = cameraX.cross(cameraZ).normalize() catch |err| {
            @panic(err);
        };

        return .{
            .right = cameraX,
            .up = cameraY,
            .forward = cameraZ
        };
    }

    pub fn moveCamera(self: *Camera, position: Vec3) void {
        self.state.position = position;
    }

    pub fn updateCamera(self: *Camera, target: Vec3) void {
        const newOrientation = lookAt(self, target);

        self.derived = newOrientation;
    }
};
