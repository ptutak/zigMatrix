const std = @import("std");

pub const G: f64 = 6.67408e-11;

pub const Force = struct {
    x: f64,
    y: f64,
};

pub const Acceleration = struct {
    x: f64,
    y: f64,
};

pub const ForceField = struct {
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

pub const GravityField = struct {
    m: f64,
    x: f64,
    y: f64,

    pub fn get_force(self: *const GravityField, point: *const Point) Force {
        const dx = self.x - point.x;
        const dy = self.y - point.y;
        const distance = std.math.sqrt(dx * dx + dy * dy);
        const F = G * self.m * point.m / (distance * distance);
        const nx = dx / distance;
        const ny = dy / distance;
        return Force{ .x = F * nx, .y = F * ny };
    }
};

pub const AccelerateField = struct {
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

const ComplexFieldTag = enum {
    force_field,
    accelerate_field,
    gravity_field,
};

pub const Field = union(ComplexFieldTag) {
    force_field: ForceField,
    accelerate_field: AccelerateField,
    gravity_field: GravityField,
};

pub const Point = struct {
    x: f64,
    y: f64,
    vx: f64,
    vy: f64,
    m: f64,
    r: f64,
    bounce_coefficient: f64 = 1.0,

    pub fn calculate_force(self: *const Point, fields: []const Field) Force {
        var Fx: f64 = 0.0;
        var Fy: f64 = 0.0;
        for (fields) |field| {
            switch (field) {
                ComplexFieldTag.force_field => {
                    const force = field.force_field.get_force(self);
                    Fx += force.x;
                    Fy += force.y;
                },
                ComplexFieldTag.accelerate_field => {
                    const force = field.accelerate_field.get_force(self);
                    Fx += force.x;
                    Fy += force.y;
                },
                ComplexFieldTag.gravity_field => {
                    const force = field.gravity_field.get_force(self);
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

pub fn collision_detection(point1: Point, point2: Point) bool {
    const dx = point1.x - point2.x;
    const dy = point1.y - point2.y;
    const distance = std.math.sqrt(dx * dx + dy * dy);
    return distance < point1.r + point2.r;
}

pub fn collision_response(point1: *Point, point2: *Point) void {
    const dx = point1.x - point2.x;
    const dy = point1.y - point2.y;
    const distance = std.math.sqrt(dx * dx + dy * dy);
    const nx = dx / distance;
    const ny = dy / distance;
    const s = point1.r + point2.r - distance;
    point1.x += s * nx * 0.5;
    point1.y += s * ny * 0.5;
    point2.x -= s * nx * 0.5;
    point2.y -= s * ny * 0.5;
    const p = 2 * ((point1.vx - point2.vx) * nx + (point1.vy - point2.vy) * ny) / (point1.m + point2.m);
    const vx1 = point1.vx - p * point1.m * nx;
    const vy1 = point1.vy - p * point1.m * ny;
    const vx2 = point2.vx + p * point2.m * nx;
    const vy2 = point2.vy + p * point2.m * ny;
    point1.vx = vx1 * point1.bounce_coefficient;
    point1.vy = vy1 * point1.bounce_coefficient;
    point2.vx = vx2 * point2.bounce_coefficient;
    point2.vy = vy2 * point2.bounce_coefficient;
}
