const Vec3 = @import("../math/vec3.zig").Vec3;
const constants = @import("../constants.zig");

// zig fmt: off
const CameraState = struct { 
    position: Vec3, 

    const default: CameraState = .{
        .position = constants.world_origin
    };
};

// zig fmt: off
const CameraDerived = struct { 
    x: Vec3, 
    y: Vec3, 
    z: Vec3, 

    const default: CameraDerived = .{
        .x = Vec3.init(0, 0, 0),
        .y = Vec3.init(0, 0, 0),
        .z = Vec3.init(0, 0, 0)
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
            .lens = CameraLens.default
        };
    }

    pub fn computeOrientation(self: *const Camera, target: Vec3) CameraDerived {
        // LookAt function
        const cameraZ: Vec3 = target.subtract(self.state.position).normalize();
        const cameraX: Vec3 = cameraZ.cross(constants.world_up).normalize();
        const cameraY: Vec3 = cameraX.cross(cameraZ).normalize();

        return .{
            .x = cameraX,
            .y = cameraY,
            .z = cameraZ
        };
    }

    pub fn updateState(self: *Camera, position: Vec3, orientation: CameraDerived) void {
        self.state.position = position;
        self.state.orientation = orientation;
    }

    pub fn updateDerived(self: *Camera, target: Vec3) void {
        const newOrientation = computeOrientation(self, target);

        self.derived = newOrientation;
    }
};
