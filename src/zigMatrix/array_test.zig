const std = @import("std");
const testing = @import("std").testing;
const arr = @import("array.zig");
const errors = @import("errors.zig");

test "basic add functionality" {
    var array = [_]f64{ 1, 2, 3, 4 };
    var size = array.len;
    var matrix1 = try arr.array(array[0..size], 2, 2);
    try testing.expect(matrix1.at(0, 0) == 1.0);
    try testing.expect(matrix1.at(0, 1) == 2.0);
    try testing.expect(matrix1.at(1, 0) == 3.0);
    try testing.expect(matrix1.at(1, 1) == 4.0);
    var matrix2 = try arr.array(array[0..size], 2, 2);
    var matrix3 = try matrix1.add(matrix2);
    try testing.expect(matrix3.at(0, 0) == 2.0);
    try testing.expect(matrix3.at(0, 1) == 4.0);
    try testing.expect(matrix3.at(1, 0) == 6.0);
    try testing.expect(matrix3.at(1, 1) == 8.0);
    try testing.expect(matrix1.at(0, 0) == 1.0);
    try testing.expect(matrix1.at(0, 1) == 2.0);
    try testing.expect(matrix1.at(1, 0) == 3.0);
    try testing.expect(matrix1.at(1, 1) == 4.0);
    try testing.expect(matrix2.at(0, 0) == 1.0);
    try testing.expect(matrix2.at(0, 1) == 2.0);
    try testing.expect(matrix2.at(1, 0) == 3.0);
    try testing.expect(matrix2.at(1, 1) == 4.0);
}

test "basic substract functionality" {
    var array = [_]f64{ 1, 2, 3, 4 };
    var size = array.len;
    var matrix1 = try arr.array(array[0..size], 2, 2);
    var matrix2 = try arr.array(array[0..size], 2, 2);
    var matrix3 = try matrix1.sub(matrix2);
    try testing.expect(matrix3.at(0, 0) == 0.0);
    try testing.expect(matrix3.at(0, 1) == 0.0);
    try testing.expect(matrix3.at(1, 0) == 0.0);
    try testing.expect(matrix3.at(1, 1) == 0.0);
    try testing.expect(matrix1.at(0, 0) == 1.0);
    try testing.expect(matrix1.at(0, 1) == 2.0);
    try testing.expect(matrix1.at(1, 0) == 3.0);
    try testing.expect(matrix1.at(1, 1) == 4.0);
    try testing.expect(matrix2.at(0, 0) == 1.0);
    try testing.expect(matrix2.at(0, 1) == 2.0);
    try testing.expect(matrix2.at(1, 0) == 3.0);
    try testing.expect(matrix2.at(1, 1) == 4.0);
}

test "basic prod" {
    var array = [_]f64{ 1, 2, 3, 4 };
    var size = array.len;
    var matrix1 = try arr.array(array[0..size], 2, 2);
    var matrix2 = try arr.array(array[0..size], 2, 2);
    var matrix3 = try matrix1.prod(matrix2);
    try testing.expect(matrix3.at(0, 0) == 7.0);
    try testing.expect(matrix3.at(0, 1) == 10.0);
    try testing.expect(matrix3.at(1, 0) == 15.0);
    try testing.expect(matrix3.at(1, 1) == 22.0);
    try testing.expect(matrix1.at(0, 0) == 1.0);
    try testing.expect(matrix1.at(0, 1) == 2.0);
    try testing.expect(matrix1.at(1, 0) == 3.0);
    try testing.expect(matrix1.at(1, 1) == 4.0);
    try testing.expect(matrix2.at(0, 0) == 1.0);
    try testing.expect(matrix2.at(0, 1) == 2.0);
    try testing.expect(matrix2.at(1, 0) == 3.0);
    try testing.expect(matrix2.at(1, 1) == 4.0);
}

test "prod errors" {
    var array = [_]f64{ 1, 2, 3, 4 };
    var array2 = [_]f64{ 1, 2, 3, 4, 5, 6 };
    var size = array.len;
    _ = size;
    var matrix1 = try arr.array(array[0..array.len], 2, 2);
    var matrix2 = try arr.array(array2[0..array2.len], 2, 3);
    if (matrix1.prod(matrix2)) |value| {
        _ = value;
        unreachable;
    } else |err| {
        try testing.expect(err == errors.ZigMatrixError);
    }
    var matrix3 = try arr.array(array2[0..array2.len], 1, 6);
    if (matrix2.prod(matrix3)) |value| {
        _ = value;
        unreachable;
    } else |err| {
        try testing.expect(err == errors.ZigMatrixError);
    }
}

test "deallocate" {
    var array = [_]f64{ 1, 2, 3, 4 };
    var size = array.len;
    var matrix1 = try arr.array(array[0..size], 2, 2);
    try testing.expect(matrix1.at(0, 0) == 1.0);
    try testing.expect(matrix1.at(0, 1) == 2.0);
    try testing.expect(matrix1.at(1, 0) == 3.0);
    try testing.expect(matrix1.at(1, 1) == 4.0);
}
