const std = @import("std");
const testing = @import("std").testing;
const matr = @import("matrix.zig");
const errors = @import("errors.zig");

test "basic add functionality" {
    var data = [_]f64{ 1, 2, 3, 4 };
    var size = data.len;
    var matrix1 = try matr.matrix(data[0..size], 2, 2);
    try testing.expect(matrix1.at(0, 0) == 1.0);
    try testing.expect(matrix1.at(0, 1) == 2.0);
    try testing.expect(matrix1.at(1, 0) == 3.0);
    try testing.expect(matrix1.at(1, 1) == 4.0);
    var matrix2 = try matr.matrix(data[0..size], 2, 2);
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
    var data = [_]f64{ 1, 2, 3, 4 };
    var size = data.len;
    var matrix1 = try matr.matrix(data[0..size], 2, 2);
    var matrix2 = try matr.matrix(data[0..size], 2, 2);
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
    var data = [_]f64{ 1, 2, 3, 4 };
    var size = data.len;
    var matrix1 = try matr.matrix(data[0..size], 2, 2);
    var matrix2 = try matr.matrix(data[0..size], 2, 2);
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
    var data = [_]f64{ 1, 2, 3, 4 };
    var data2 = [_]f64{ 1, 2, 3, 4, 5, 6 };
    var size = data.len;
    _ = size;
    var matrix1 = try matr.matrix(data[0..data.len], 2, 2);
    var matrix2 = try matr.matrix(data2[0..data2.len], 2, 3);
    if (matrix1.prod(matrix2)) |value| {
        _ = value;
        unreachable;
    } else |err| {
        try testing.expect(err == errors.ZigMatrixError);
    }
    var matrix3 = try matr.matrix(data2[0..data2.len], 1, 6);
    if (matrix2.prod(matrix3)) |value| {
        _ = value;
        unreachable;
    } else |err| {
        try testing.expect(err == errors.ZigMatrixError);
    }
}

test "zeros" {
    var matrix = try matr.zeros(2, 2);
    try testing.expect(matrix.at(0, 0) == 0.0);
    try testing.expect(matrix.at(0, 1) == 0.0);
    try testing.expect(matrix.at(1, 0) == 0.0);
    try testing.expect(matrix.at(1, 1) == 0.0);
}

test "ones" {
    var matrix = try matr.ones(2, 2);
    try testing.expect(matrix.at(0, 0) == 1.0);
    try testing.expect(matrix.at(0, 1) == 1.0);
    try testing.expect(matrix.at(1, 0) == 1.0);
    try testing.expect(matrix.at(1, 1) == 1.0);
}

test "eye" {
    var matrix = try matr.eye(2);
    try testing.expect(matrix.at(0, 0) == 1.0);
    try testing.expect(matrix.at(0, 1) == 0.0);
    try testing.expect(matrix.at(1, 0) == 0.0);
    try testing.expect(matrix.at(1, 1) == 1.0);
}

test "diag" {
    var data = [_]f64{ 1, 2, 3, 4 };
    var size = data.len;
    var matrix = try matr.diag(data[0..size]);
    try testing.expect(matrix.at(0, 0) == 1.0);
    try testing.expect(matrix.at(1, 1) == 2.0);
    try testing.expect(matrix.at(2, 2) == 3.0);
    try testing.expect(matrix.at(3, 3) == 4.0);
    try testing.expect(matrix.at(0, 1) == 0.0);
    try testing.expect(matrix.at(0, 2) == 0.0);
    try testing.expect(matrix.at(0, 3) == 0.0);
    try testing.expect(matrix.at(1, 0) == 0.0);
    try testing.expect(matrix.at(1, 2) == 0.0);
    try testing.expect(matrix.at(1, 3) == 0.0);
    try testing.expect(matrix.at(2, 0) == 0.0);
    try testing.expect(matrix.at(2, 1) == 0.0);
    try testing.expect(matrix.at(2, 3) == 0.0);
    try testing.expect(matrix.at(3, 0) == 0.0);
    try testing.expect(matrix.at(3, 1) == 0.0);
    try testing.expect(matrix.at(3, 2) == 0.0);
}

test "transpose" {
    var data = [_]f64{ 1, 2, 3, 4 };
    var size = data.len;
    var matrix = try matr.matrix(data[0..size], 2, 2);
    var matrix2 = try matrix.transpose();
    try testing.expect(matrix2.at(0, 0) == 1.0);
    try testing.expect(matrix2.at(0, 1) == 3.0);
    try testing.expect(matrix2.at(1, 0) == 2.0);
    try testing.expect(matrix2.at(1, 1) == 4.0);
}
