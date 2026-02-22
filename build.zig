const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.resolveTargetQuery(.{ .cpu_arch = .wasm32, .os_tag = .freestanding });

    const wasmModule = b.addModule("wasmModule", .{ .root_source_file = b.path("zig/main.zig"), .target = target, .optimize = .ReleaseSmall });

    // zig fmt: off
    wasmModule.export_symbol_names = &.{ 
        "malloc",
        "free",
        "getEditorConfig"
    };

    const exe = b.addExecutable(.{
        .name = "main-wasm",
        .root_module = wasmModule,
    });

    exe.entry = .disabled;

    b.installArtifact(exe);
    const installStep = b.addInstallFile(exe.getEmittedBin(), "../public/polystack.wasm");

    b.getInstallStep().dependOn(&installStep.step);
}
