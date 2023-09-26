const std = @import("std");

const G: f64 = 6.67408e-11;

const Force = struct {
    x: f64,
    y: f64,
};

const ForceField = struct {
    Fx: f64,
    Fy: f64,

    pub fn get_force(self: *const ForceField, point: *const Point) Force {
        _ = point;
        return Force{ .x = self.Fx, .y = self.Fy };
    }
};

const Field = union {
    force_field: ForceField,
};

const Point = struct {
    x: f64,
    y: f64,
    vx: f64,
    vy: f64,
    m: f64,

    pub fn calculate_force(self: *const Point, fields: []Field) Force {
        var Fx: f64 = 0.0;
        var Fy: f64 = 0.0;
        for (fields) |field| {
            switch (field) {
                .force_field => {
                    const force = field.force_field.get_force(self);
                    Fx += force.x;
                    Fy += force.y;
                },
            }
        }
        return Force{ .x = Fx, .y = Fy };
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
