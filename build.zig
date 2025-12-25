const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.resolveTargetQuery(.{ .cpu_arch = .wasm32, .os_tag = .freestanding });

    const wasmModule = b.addModule("wasmModule", .{ .root_source_file = b.path("zig/WASM.test.zig"), .target = target, .optimize = .ReleaseSmall });

    wasmModule.export_symbol_names = &.{ "multiplier", "getIdentity", "malloc", "free" };

    const exe = b.addExecutable(.{
        .name = "wasmtest",
        .root_module = wasmModule,
    });

    exe.entry = .disabled;

    b.installArtifact(exe);
    const installStep = b.addInstallFile(exe.getEmittedBin(), "../public/wasmtest.wasm");

    b.getInstallStep().dependOn(&installStep.step);
}
