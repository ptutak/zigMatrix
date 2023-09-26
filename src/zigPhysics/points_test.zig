const points = @import("points.zig");
const testing = @import("std").testing;

test "collisions" {
    const a = points.Point{ .x = 1, .y = 2, .r = 1, .vx = 1, .vy = 1, .m = 1 };
    const b = points.Point{ .x = 3, .y = 4, .r = 1, .vx = 1, .vy = 1, .m = 1 };
    const c = points.Point{ .x = 1, .y = 3.99, .r = 1, .vx = 1, .vy = 1, .m = 1 };
    try testing.expect(!points.collision_detection(a, b));
    try testing.expect(points.collision_detection(a, c));
}
