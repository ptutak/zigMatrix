pub const std = @import("std");
pub const common = @import("common");
test {
    _ = @import("zigDraw/draw_test.zig");
    _ = @import("zigMatrix/matrix_test.zig");
    _ = @import("zigPhysics/points_test.zig");
}

test "some test" {
    std.debug.print("Hello, world!\n", .{});
}
