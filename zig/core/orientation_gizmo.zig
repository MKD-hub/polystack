const std = @import("std");
const cube = @import("../primitives/cube.zig").cube;
const vec3 = @import("../math/vec3.zig").Vec3;
const context = @import("../context.zig").CoreContext;
const Mat4 = @import("../math/mat4.zig").Mat4;
const utils = @import("../utils/utils.zig");
// declare vertices for orientation cube

export fn returnGizmoViewMatrix(g_context: context) *[16]f32 {
    const distance: f32 = 5.0;
    const gizmoCamPos: vec3 = g_context.camera.derived.forward.scale(-distance);

    // zig fmt: off
    const mat = Mat4.viewMatrix(
        g_context.camera.derived.right,
        g_context.camera.derived.up,
        g_context.camera.derived.forward,
        gizmoCamPos
    );

    utils.flattenMat4ToF32Array(mat, &g_context.gizmo_view_mat);
    return &g_context.gizmo_view_mat;
}

export fn returnGizmoPerspectiveMatrix(g_context: context) *[16]f32 {
    const fov: f32 = 45 * (std.math.pi / 180);
    const aspect: f32 = 1.0;
    const near: f32 = 0.1;
    const far: f32 = 10.0;

    const proj_mat = Mat4.perspective(fov, aspect, near, far);

    utils.flattenMat4ToF32Array(proj_mat, &g_context.gizmo_perspecitve_mat);
    return &g_context.gizmo_perspecitve_mat;
}
