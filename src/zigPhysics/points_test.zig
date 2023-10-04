const points = @import("zigPhysics.points");
const std = @import("std");
const testing = @import("std").testing;

test "force field" {
    const field = points.ForceField{ .Fx = 1, .Fy = 2 };
    const point = points.Point{ .x = 1, .y = 2, .r = 1, .vx = 1, .vy = 1, .m = 1 };
    var fields = [_]points.Field{points.Field{ .force_field = field }};
    const expected = points.Force{ .Fx = 1, .Fy = 2 };
    try testing.expect(expected.equals(point.calculate_force(&fields)));
}

test "collisions" {
    const a = points.Point{ .x = 1, .y = 2, .r = 1, .vx = 1, .vy = 1, .m = 1 };
    const b = points.Point{ .x = 3, .y = 4, .r = 1, .vx = 1, .vy = 1, .m = 1 };
    const c = points.Point{ .x = 1, .y = 3.99, .r = 1, .vx = 1, .vy = 1, .m = 1 };
    try testing.expect(!points.collision_detection(a, b));
    try testing.expect(points.collision_detection(a, c));
}

test "collision response 1" {
    var a = points.Point{ .x = 1, .y = 2, .r = 1, .vx = 1, .vy = 0, .m = 1 };
    var b = points.Point{ .x = 3, .y = 2, .r = 1, .vx = -1, .vy = 0, .m = 1 };
    points.collision_response(&a, &b);
    try testing.expect(a.vx == -1);
    try testing.expect(b.vx == 1);
}

test "collision response 2" {
    var a = points.Point{ .x = 1, .y = 2, .r = 1, .vx = 1, .vy = 0, .m = 1 };
    var b = points.Point{ .x = 3, .y = 2, .r = 1, .vx = 0, .vy = 0, .m = 1 };
    points.collision_response(&a, &b);
    try testing.expect(a.vx == 0);
    try testing.expect(b.vx == 1);
}
