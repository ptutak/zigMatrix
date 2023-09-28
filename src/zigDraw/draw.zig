const std = @import("std");
const allocate = @import("../zigTools/allocate.zig");

pub const Circle = struct {
    x: u32,
    y: u32,
    r: u32,
};

pub const Plane = struct {
    x_size: u32,
    y_size: u32,

    pub fn draw_circles(self: *const Plane, circles: []const Circle) ![]u8 {
        var plane = try allocate.allocate(u8, self.x_size * (self.y_size + 1));
        for (0..self.x_size) |x| {
            for (0..self.y_size) |y| {
                for (circles) |circle| {
                    const dx = circle.x - x;
                    const dy = circle.y - y;
                    if (dx * dx + dy * dy < circle.r * circle.r) {
                        plane[x * self.y_size + y] = @as(u8, "o");
                    } else {
                        plane[x * self.y_size + y] = @as(u8, " ");
                    }
                }
            }
            plane[x * self.y_size + self.y_size] = @as(u8, "\n");
        }
        return plane;
    }
};
