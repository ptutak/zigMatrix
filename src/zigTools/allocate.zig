const std = @import("std");

pub fn allocate(comptime t: type, size: usize) ![]t {
    return std.heap.page_allocator.alloc(t, size) catch |err| {
        std.debug.print("matrix: unable to allocate memory: {!}\n", .{err});
        return err;
    };
}

pub fn allocate_matrix(m: usize, n: usize) ![]f64 {
    return std.heap.page_allocator.alloc(f64, m * n) catch |err| {
        std.debug.print("matrix: unable to allocate memory: {!}\n", .{err});
        return err;
    };
}

pub fn allocate_matrix_data(size: usize) ![]f64 {
    return std.heap.page_allocator.alloc(f64, size) catch |err| {
        std.debug.print("matrix: unable to allocate memory: {!}\n", .{err});
        return err;
    };
}
