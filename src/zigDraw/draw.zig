const std = @import("std");
const allocate = @import("allocate.zig");

pub const Circle = struct {
    x: i32,
    y: i32,
    r: i32,
};

pub const Plane = struct {
    x_size: usize,
    y_size: usize,

    pub fn draw_circles(self: *const Plane, circles: []const Circle) ![]u8 {
        var plane = try allocate.allocate(u8, self.x_size * (self.y_size + 1));
        for (0..self.x_size) |x| {
            for (0..self.y_size) |y| {
                for (circles) |circle| {
                    const dx = circle.x - @as(i32, @intCast(x));
                    const dy = circle.y - @as(i32, @intCast(y));
                    if (dx * dx + dy * dy <= circle.r * circle.r) {
                        plane[x * (self.y_size + 1) + y] = @as(u8, 'o');
                    } else {
                        plane[x * (self.y_size + 1) + y] = @as(u8, ' ');
                    }
                }
            }
            plane[x * (self.y_size + 1) + self.y_size] = @as(u8, '\n');
        }
        return plane;
    }
};
