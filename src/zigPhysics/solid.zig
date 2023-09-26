const std = @import("std");

const G: f64 = 6.67408e-11;

const Force = struct {
    x: f64,
    y: f64,
};

const Acceleration = struct {
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

    pub fn get_acceleration(self: *const ForceField, point: *const Point) Acceleration {
        return Acceleration{ .x = self.Fx / point.m, .y = self.Fy / point.m };
    }
};

const AccelerateField = struct {
    ax: f64,
    ay: f64,

    pub fn get_force(self: *const AccelerateField, point: *const Point) Force {
        return Force{ .x = self.ax * point.m, .y = self.ay * point.m };
    }

    pub fn get_acceleration(self: *const AccelerateField, point: *const Point) Acceleration {
        _ = point;
        return Acceleration{ .x = self.ax, .y = self.ay };
    }
};

const Field = union {
    force_field: ForceField,
    accelerate_field: AccelerateField,
};

const Point = struct {
    x: f64,
    y: f64,
    vx: f64,
    vy: f64,
    m: f64,

    pub fn calculate_force(self: *const Point, fields: []const Field) Force {
        var Fx: f64 = 0.0;
        var Fy: f64 = 0.0;
        for (fields) |field| {
            switch (field) {
                .force_field => {
                    const force = field.force_field.get_force(self);
                    Fx += force.x;
                    Fy += force.y;
                },
                .accelerate_field => {
                    const force = field.accelerate_field.get_force(self);
                    Fx += force.x;
                    Fy += force.y;
                },
            }
        }
        return Force{ .x = Fx, .y = Fy };
    }

    pub fn update(self: *Point, fields: []const Field, dt: f64) void {
        const force = self.calculate_force(fields);
        const ax = force.x / self.m;
        const ay = force.y / self.m;
        self.vx += self.vx + ax * dt;
        self.vy += self.vy + ay * dt;
        self.x += self.x + self.vx * dt;
        self.y += self.y + self.vy * dt;
    }
};
