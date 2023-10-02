pub const std = @import("std");
pub usingnamespace @import("zigDraw/draw_test.zig");
pub usingnamespace @import("zigMatrix/matrix_test.zig");
pub usingnamespace @import("zigPhysics/points_test.zig");

test "some test" {
    std.debug.print("Hello, world!\n", .{});
}
