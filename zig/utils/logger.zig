const std      = @import("std");
const myLogger = @import("../main.zig").logString;

pub const Logger = struct{
    buf: [256]u8, 
    fs:  [*c]const u8, // fs -> formatted string

    pub fn log(self: *Logger, comptime logString: []const u8, value: anytype) void {
        const formatted_string = std.fmt.bufPrintZ(&self.buf, logString, .{value}) catch |err| {
            myLogger("Log Broken");
            @panic(@errorName(err));
        };
        myLogger(formatted_string);
    }
};
