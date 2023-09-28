const std = @import("std");
const testing = @import("std").testing;
const draw = @import("draw.zig");

test "draw" {
    const plane = draw.Plane{ .x_size = 10, .y_size = 10 };
    const points = [_]draw.Circle{ draw.Circle{ .x = 1, .y = 1, .r = 1 }, draw.Circle{ .x = 5, .y = 5, .r = 2 } };
    const result = try plane.draw_circles(&points);
    std.debug.print("{any}", .{result});
}
