const std = @import("std");
const errors = @import("./errors.zig");

const Matrix = struct {
    m: usize,
    n: usize,
    _data: []f64,
    pub fn init(data: []f64, m: usize, n: usize) !Matrix {
        return matrix(data, m, n);
    }

    pub fn add(self: *const Matrix, matr: Matrix) !Matrix {
        if (self._data.len != matr._data.len) {
            std.debug.print("matrix: matrix length does not match\n", .{});
            return errors.ZigMatrixError;
        }
        var data = std.heap.page_allocator.alloc(f64, self._data.len) catch |err| {
            std.debug.print("matrix: unable to allocate memory: {!}\n", .{err});
            return err;
        };
        for (0.., self._data) |i, value| {
            data[i] = value + matr._data[i];
        }
        return matrix(data, self.m, self.n);
    }

    pub fn sub(self: *const Matrix, matr: Matrix) !Matrix {
        if (self._data.len != matr._data.len) {
            std.debug.print("matrix: matrix length does not match\n", .{});
            return errors.ZigMatrixError;
        }
        var data = std.heap.page_allocator.alloc(f64, self._data.len) catch |err| {
            std.debug.print("matrix: unable to allocate memory: {!}\n", .{err});
            return err;
        };
        for (0.., self._data) |i, value| {
            data[i] = value - matr._data[i];
        }
        return matrix(data, self.m, self.n);
    }

    pub fn prod(self: *const Matrix, matr: Matrix) !Matrix {
        if (self._data.len != matr._data.len) {
            std.debug.print("matrix: matrix length does not match\n", .{});
            return errors.ZigMatrixError;
        }
        if ((self.m != matr.n) or (self.n != matr.m)) {
            std.debug.print("matrix: matrix dimensions do not match\n", .{});
            return errors.ZigMatrixError;
        }
        var data = std.heap.page_allocator.alloc(f64, self.m * matr.n) catch |err| {
            std.debug.print("matrix: unable to allocate memory: {!}\n", .{err});
            return err;
        };
        for (0..self.m) |i| {
            for (0..matr.n) |j| {
                var sum: f64 = 0.0;
                for (0..self.n) |k| {
                    sum += self.at(i, k) * matr.at(k, j);
                }
                data[i * matr.n + j] = sum;
            }
        }
        return matrix(data, self.m, matr.n);
    }

    pub fn at(self: *const Matrix, i: usize, j: usize) f64 {
        return self._data[i * self.n + j];
    }

    pub fn determinant(self: *const Matrix) !f64 {
        if (self.m != self.n) {
            std.debug.print("matrix: matrix is not square\n", .{});
            return errors.ZigMatrixError;
        }
        if (self.m == 1) {
            return self._data[0];
        }
        var det: f64 = 0.0;
        for (0..self.n) |j| {
            const submatr = try self.submatrix(0, j);
            det += (-1.0).pow(f64, 0.0 + j) * self._data[j] * submatr.determinant() catch |err| {
                std.debug.print("matrix: unable to calculate determinant: {!}\n", .{err});
                return err;
            };
        }
    }

    pub fn upper_traingular(self: *const Matrix) !Matrix {
        if (self.m != self.n) {
            std.debug.print("matrix: matrix is not square\n", .{});
            return errors.ZigMatrixError;
        }
        var data = std.heap.page_allocator.alloc(f64, self._data.len) catch |err| {
            std.debug.print("matrix: unable to allocate memory: {!}\n", .{err});
            return err;
        };
        @memcpy(data, self._data);
        for (0..self.m) |k| {
            const i = k / self.n;
            const j = k % self.n;
            if (i > j) {
                data[k] = 0.0;
            } else {
                data[k] = 0.0;
            }
        }
        return matrix(data, self.m, self.n);
    }

    pub fn multiply(self: *const Matrix, scalar: f64) !Matrix {
        var data = std.heap.page_allocator.alloc(f64, self._data.len) catch |err| {
            std.debug.print("matrix: unable to allocate memory: {!}\n", .{err});
            return err;
        };
        for (0.., self._data) |i, value| {
            data[i] = value * scalar;
        }
        return matrix(data, self.m, self.n);
    }

    pub fn concat(self: *const Matrix, matr: Matrix) !Matrix {
        if (self.m != matr.m) {
            std.debug.print("matrix: matrix dimensions do not match\n", .{});
            return errors.ZigMatrixError;
        }
        var data = std.heap.page_allocator.alloc(f64, self._data.len + matr._data.len) catch |err| {
            std.debug.print("matrix: unable to allocate memory: {!}\n", .{err});
            return err;
        };
        for (0..self.m) |i| {
            @memcpy(data[i * (self.n + matr.n) .. i * (self.n + matr.n) + self.n], self._data[i * self.n .. (i + 1) * self.n]);
            @memcpy(data[i * (self.n + matr.n) + self.n .. (i + 1) * (self.n + matr.n)], matr._data[i * matr.n .. (i + 1) * matr.n]);
        }
        return matrix(data, self.m, self.n + matr.n);
    }

    fn swap_rows(self: *Matrix, in1: usize, in2: usize) !Matrix {
        if (in1 >= self.m or in2 >= self.m) {
            std.debug.print("matrix: row index out of bounds\n", .{});
            return errors.ZigMatrixError;
        }
        for (0..self.n) |j| {
            const tmp = self._data[in1 * self.n + j];
            self._data[in1 * self.n + j] = self._data[in2 * self.n + j];
            self._data[in2 * self.n + j] = tmp;
        }
    }

    pub fn transpose(self: *const Matrix) !Matrix {
        var data = std.heap.page_allocator.alloc(f64, self._data.len) catch |err| {
            std.debug.print("matrix: unable to allocate memory: {!}\n", .{err});
            return err;
        };
        for (0.., self._data) |k, value| {
            const i = k / self.n;
            const j = k % self.n;
            data[j * self.m + i] = value;
        }
        return matrix(data, self.n, self.m);
    }
};

pub fn matrix(data: []f64, m: usize, n: usize) !Matrix {
    if (data.len != m * n) {
        std.debug.print("matrix: matrix length does not match dimensions: {d}, m*n: {d}\n", .{ data.len, m * n });
        return errors.ZigMatrixError;
    }
    return Matrix{ .m = m, .n = n, ._data = data };
}

pub fn zeros(m: usize, n: usize) !Matrix {
    var data = std.heap.page_allocator.alloc(f64, m * n) catch |err| {
        std.debug.print("matrix: unable to allocate memory: {!}\n", .{err});
        return err;
    };
    for (0..data.len) |index| {
        data[index] = 0.0;
    }
    return matrix(data, m, n);
}

pub fn ones(m: usize, n: usize) !Matrix {
    var data = std.heap.page_allocator.alloc(f64, m * n) catch |err| {
        std.debug.print("matrix: unable to allocate memory: {!}\n", .{err});
        return err;
    };
    for (0..data.len) |index| {
        data[index] = 1.0;
    }
    return matrix(data, m, n);
}

pub fn eye(n: usize) !Matrix {
    var data = std.heap.page_allocator.alloc(f64, n * n) catch |err| {
        std.debug.print("matrix: unable to allocate memory: {!}\n", .{err});
        return err;
    };
    for (0..data.len) |index| {
        const i = index / n;
        const j = index % n;
        if (i == j) {
            data[index] = 1.0;
        } else {
            data[index] = 0.0;
        }
    }
    return matrix(data, n, n);
}

pub fn diag(data: []f64) !Matrix {
    var n = data.len;
    var matr = try zeros(n, n);
    for (0..n, data) |i, value| {
        matr._data[i * n + i] = value;
    }
    return matr;
}

pub fn vector(data: []f64) !Matrix {
    return matrix(data, data.len, 1);
}
