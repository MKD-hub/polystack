const std = @import("std");
const math = std.math;

pub const Vec4 = struct {
    x: f32 = 0.0,
    y: f32 = 0.0,
    z: f32 = 0.0,
    w: f32 = 0.0,

    pub fn init(x: f32, y: f32, z: f32, w: f32) Vec4 {
        return .{ .x = x, .y = y, .z = z, .w = w };
    }

    pub fn magnitude(self: Vec4) f32 {
        return math.sqrt(self.x * self.x + self.y * self.y + self.z * self.z + self.w * self.w);
    }

    pub fn dot(self: Vec4, other: Vec4) f32 {
        return self.x * other.x + self.y * other.y + self.z * other.z + self.w * other.w;
    }

    pub fn subtract(self: Vec4, other: Vec4) Vec4 {
        return .{ .x = self.x - other.x, .y = self.y - other.y, .z = self.z - other.z, .w = self.w - other.w };
    }

    pub fn add(self: Vec4, other: Vec4) Vec4 {
        return .{ .x = self.x + other.x, .y = self.y + other.y, .z = self.z + other.z, .w = self.w + other.w };
    }

    pub fn scale(self: Vec4, s: f32) Vec4 {
        return .{
            .x = self.x * s,
            .y = self.y * s,
            .z = self.z * s,
            .w = self.w * s,
        };
    }

    pub fn normalize(self: Vec4) Vec4 {
        const len = self.magnitude();
        if (len == 0.0) return self;
        return self.scale(1.0 / len);
    }
};
