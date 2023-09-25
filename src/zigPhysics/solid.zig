const std = @import("std");

const Point = struct {
    x: f64,
    y: f64,
    ax: f64,
    ay: f64,
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
        self.ax = self.Fx / self.m;
        self.ay = self.Fy / self.m;
        self.vx += self.ax * dt;
        self.vy += self.ay * dt;
        self.x += self.vx * dt;
        self.y += self.vy * dt;
    }
};
