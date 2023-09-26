const std = @import("std");

const Point = struct {
    x: f64,
    y: f64,
    vx: f64,
    vy: f64,
    m: f64,
    Fx: f64,
    Fy: f64,

    pub fn new(x: f64, y: f64, m: f64) Point {
        return Point{
            .x = x,
            .y = y,
            .m = m,
            .Fx = 0.0,
            .Fy = 0.0,
        };
    }

    pub fn update(self: *Point, dt: f64) void {
        const ax = self.Fx / self.m;
        const ay = self.Fy / self.m;
        self.vx += self.vx + ax * dt;
        self.vy += self.vy + ay * dt;
        self.x += self.x + self.vx * dt;
        self.y += self.y + self.vy * dt;
    }
};
