const std = @import("std");
const Vec3 = @import("../math/vec3.zig").Vec3;
const Mat4 = @import("../math/mat4.zig").Mat4;
const constants = @import("../constants.zig");

const CameraState = struct {
    position: Vec3,
    target: Vec3, // The point we orbit (the "Pivot")

    const default: CameraState = .{
        .position = Vec3.init(0, 0, 5),
        .target = Vec3.init(0, 0, 0),
    };
};

const CameraRotation = struct {
    radius: f32,
    phi: f32,   // Vertical angle (Polar)
    theta: f32, // Horizontal angle (Azimuthal)

    const default: CameraRotation = .{
        .radius = 10.0,
        .phi = std.math.pi / 2.5,
        .theta = std.math.pi / 2.0,
    };
};

const CameraDerived = struct {
    right: Vec3,
    up: Vec3,
    forward: Vec3,

    const default: CameraDerived = .{
        .right = Vec3.init(0, 0, 0),
        .up = Vec3.init(0, 0, 0),
        .forward = Vec3.init(0, 0, 0),
    };
};

pub const Camera = struct {
    state: CameraState,
    derived: CameraDerived,
    rotation: CameraRotation,

    pub fn init() Camera {
        var cam = Camera{
            .state = CameraState.default,
            .derived = CameraDerived.default,
            .rotation = CameraRotation.default,
        };
        // Initialize position based on default rotation
        cam.updateSpherical(0, 0);
        return cam;
    }

    /// Calculates the Basis Vectors (Right, Up, Forward)
    pub fn updateOrientation(self: *Camera) void {
        // Forward is the vector from Position to Target
        const fwd = self.state.position.subtract(self.state.target).normalize() catch Vec3.init(0, 0, 1);
        
        // Right is perpendicular to World Up and Forward
        const right = constants.world_up.cross(fwd).normalize() catch Vec3.init(1, 0, 0);
        
        // Up is perpendicular to Forward and Right
        const up = fwd.cross(right).normalize() catch Vec3.init(0, 1, 0);

        self.derived.forward = fwd;
        self.derived.right = right;
        self.derived.up = up;
    }

    /// Updates rotation angles and recalculates world position
    pub fn updateSpherical(self: *Camera, delta_theta: f32, delta_phi: f32) void {
        self.rotation.theta += delta_theta;
        self.rotation.phi += delta_phi;

        // Clamp Phi to prevent "Gymbal Lock" or flipping at the poles (Blender style)
        const epsilon = 0.01;
        self.rotation.phi = std.math.clamp(self.rotation.phi, epsilon, std.math.pi - epsilon);

        // Spherical to Cartesian conversion
        // x = r * sin(phi) * cos(theta)
        // y = r * cos(phi)  (Assuming Y is UP)
        // z = r * sin(phi) * sin(theta)
        const x = self.rotation.radius * @sin(self.rotation.phi) * @cos(self.rotation.theta);
        const y = self.rotation.radius * @cos(self.rotation.phi);
        const z = self.rotation.radius * @sin(self.rotation.phi) * @sin(self.rotation.theta);

        // Position is relative to the Target
        self.state.position = Vec3.init(
            self.state.target.x + x,
            self.state.target.y + y,
            self.state.target.z + z,
        );

        self.updateOrientation();
    }

    /// Panning moves the Target and Position together along the camera's local axes
    pub fn pan(self: *Camera, delta_x: f32, delta_y: f32) void {
        // Scale the movement by the camera's Right and Up vectors
        const offset_x = self.derived.right.scale(delta_x);
        const offset_y = self.derived.up.scale(delta_y);
        const total_offset = offset_x.add(offset_y);

        self.state.target = self.state.target.add(total_offset);
        self.state.position = self.state.position.add(total_offset);
    }

    /// Zooming scales the radius, bringing the position closer to the target
    pub fn zoom(self: *Camera, delta: f32) void {
        self.rotation.radius += delta * 25;
        
        // Prevent radius from becoming negative or zero
        if (self.rotation.radius < 0.1) self.rotation.radius = 0.1;

        // Refresh position using new radius
        self.updateSpherical(0, 0);
    }
};
