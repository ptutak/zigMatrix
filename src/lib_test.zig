const std = @import("std");
const root = @import("root");

test "test" {
    std.debug.print("{any}", .{"xxx"});
    std.debug.print("{any}", .{root});
}
