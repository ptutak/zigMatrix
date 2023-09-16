const std = @import("std");
const errors = @import("./errors.zig");

const Array = struct {
    m: usize,
    n: usize,
    _data: []f64,
    pub fn init(data: []f64, m: usize, n: usize) !Array {
        return array(data, m, n);
    }

    pub fn add(self: *Array, arr: Array) !Array {
        if (self._data.len != arr._data.len) {
            std.debug.print("array: array length does not match\n", .{});
            return errors.ZigMatrixError;
        }
        var data = std.heap.page_allocator.alloc(f64, self._data.len) catch |err| {
            std.debug.print("array: unable to allocate memory: {!}\n", .{err});
            return err;
        };
        for (0.., self._data) |i, value| {
            data[i] = value + arr._data[i];
        }
        return array(data, self.m, self.n);
    }

    pub fn sub(self: *Array, arr: Array) !Array {
        if (self._data.len != arr._data.len) {
            std.debug.print("array: array length does not match\n", .{});
            return errors.ZigMatrixError;
        }
        var data = std.heap.page_allocator.alloc(f64, self._data.len) catch |err| {
            std.debug.print("array: unable to allocate memory: {!}\n", .{err});
            return err;
        };
        for (0.., self._data) |i, value| {
            data[i] = value - arr._data[i];
        }
        return array(data, self.m, self.n);
    }

    pub fn prod(self: *Array, arr: Array) !Array {
        if (self._data.len != arr._data.len) {
            std.debug.print("array: array length does not match\n", .{});
            return errors.ZigMatrixError;
        }
        if ((self.m != arr.n) or (self.n != arr.m)) {
            std.debug.print("array: array dimensions do not match\n", .{});
            return errors.ZigMatrixError;
        }
        var data = std.heap.page_allocator.alloc(f64, self._data.len) catch |err| {
            std.debug.print("array: unable to allocate memory: {!}\n", .{err});
            return err;
        };
        for (0.., self._data) |k, value| {
            _ = value;
            const i = k / self.n;
            const j = k % self.n;
            const row = self._data[i * self.n .. (i + 1) * self.n];
            var sum: f64 = 0.0;
            for (0.., row) |ij, xi| {
                sum += xi * arr._data[ij * arr.n + j];
            }
            data[k] = sum;
        }
        return array(data, self.m, self.n);
    }

    pub fn at(self: *Array, i: usize, j: usize) f64 {
        return self._data[i * self.n + j];
    }
};

pub fn array(data: []f64, m: usize, n: usize) !Array {
    if (data.len != m * n) {
        std.debug.print("array: array length does not match dimensions: {d}, m*n: {d}\n", .{ data.len, m * n });
        return errors.ZigMatrixError;
    }
    return Array{ .m = m, .n = n, ._data = data };
}
