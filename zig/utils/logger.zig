const std = @import("std");
const ls = @import("../main.zig").logString;

pub fn wasmLog(comptime level: std.log.Level, comptime scope: @Type(.enum_literal), comptime format: []const u8, args: anytype) void {
    const scope_prefix = "(" ++ switch (scope) {
        // TODO: add proper enum
        .camera, .math, .editor_config, std.log.default_log_scope => @tagName(scope),
        else => if (@intFromEnum(level) <= @intFromEnum(std.log.Level.err))
            @tagName(scope)
        else
            return,
    } ++ "): ";

    const prefix = "[" ++ comptime level.asText() ++ "] " ++ scope_prefix;

    var buf: [256]u8 = undefined;
    const formatted_string = std.fmt.bufPrintZ(&buf, prefix ++ format, args) catch |err| {
        ls("Log Broken");
        @panic(@errorName(err));
    };
    ls(formatted_string);
}

pub const log_editor = std.log.scoped(.editor_config);
pub const log_Cam = std.log.scoped(.camera);
