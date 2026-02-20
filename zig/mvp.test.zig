const std = @import("std");
const expect = std.testing.expect;
const expectApproxEqAbs = std.testing.expectApproxEqAbs;
const mvp = @import("core/mvp-pipeline.zig");
const Vec4 = @import("math/vec4.zig").Vec4;
const Mat4 = @import("math/mat4.zig").Mat4;
const Vec3 = @import("math/vec3.zig").Vec3;

test "project vector transforms" {
    const epsilon = 0.000001;
    const input_vertex = Vec3.init(1, 1, 0);
    const projection = Mat4.identity();
    const view = Mat4.identity();
    const model = Mat4.identity();
    const clip_space_result = mvp.calculateMVP(input_vertex, model, view, projection);

    const expected = Vec4.init(0, 0, 0, 0);

    try expectApproxEqAbs(expected.x, clip_space_result.x, epsilon);
    try expectApproxEqAbs(expected.y, clip_space_result.y, epsilon);
    try expectApproxEqAbs(expected.z, clip_space_result.z, epsilon);
    try expectApproxEqAbs(expected.w, clip_space_result.w, epsilon);
}
