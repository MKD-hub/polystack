const Vec3 = @import("../math/vec3.zig").Vec3;
const constants = @import("../constants.zig");

// zig fmt: off
const CameraState = struct { 
    position: Vec3, 
    orientation: Vec3 
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
    far_plane: f32 
};

// zig fmt: off
const Camera = struct {
    state: CameraState,
    derived: CameraDerived,
    lens: CameraLens,

    pub fn computeOrientation(self: *Camera, target: Vec3) CameraDerived {
        // LookAt function
        const cameraZ: Vec3 = self.state.position.subtract(target).normalize();
        const cameraX: Vec3 = cameraZ.cross(constants.world_up).normalize();
        const cameraY: Vec3 = cameraX.cross(cameraZ).normalize();

        return .{
            cameraX,
            cameraY,
            cameraZ
        };
    }

    pub fn udateState(self: *Camera, position: Vec3, orientation: CameraDerived) void {
        self.state.position = position;
        self.state.orientation = orientation;
    }

    pub fn updateDerived(self: *Camera, target: Vec3) void {
        const newOrientation = computeOrientation(self, target);

        self.derived = newOrientation;
    }
};
