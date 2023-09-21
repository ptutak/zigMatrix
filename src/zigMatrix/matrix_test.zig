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

test "prod" {
    var data = [_]f64{ 1, 2, 3, 4 };
    var data2 = [_]f64{ 1, 2, 3, 4 };
    var matrix1 = try matr.matrix(data[0..data.len], 4, 1);
    var matrix2 = try matr.matrix(data2[0..data2.len], 1, 4);
    var matrix3 = try matrix1.prod(matrix2);
    var expected_data = [_]f64{ 1, 2, 3, 4, 2, 4, 6, 8, 3, 6, 9, 12, 4, 8, 12, 16 };
    const expected = try matr.matrix(
        expected_data[0..expected_data.len],
        4,
        4,
    );
    try testing.expect(matrix3.equal(expected));
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

test "multiply" {
    var data = [_]f64{ 1, 2, 3, 4 };
    var size = data.len;
    const matrix = try matr.matrix(data[0..size], 2, 2);
    var matrix2 = try matrix.multiply(2.0);
    try testing.expect(matrix2.at(0, 0) == 2.0);
    try testing.expect(matrix2.at(0, 1) == 4.0);
    try testing.expect(matrix2.at(1, 0) == 6.0);
    try testing.expect(matrix2.at(1, 1) == 8.0);
}

test "concat" {
    var data = [_]f64{ 1, 2, 3, 4 };
    var data2 = [_]f64{ 5, 6, 7, 8 };
    var size = data.len;
    var matrix1 = try matr.matrix(data[0..size], 2, 2);
    var matrix2 = try matr.matrix(data2[0..size], 2, 2);
    var matrix3 = try matrix1.concat(matrix2);
    try testing.expect(matrix3.at(0, 0) == 1.0);
    try testing.expect(matrix3.at(0, 1) == 2.0);
    try testing.expect(matrix3.at(0, 2) == 5.0);
    try testing.expect(matrix3.at(0, 3) == 6.0);
    try testing.expect(matrix3.at(1, 0) == 3.0);
    try testing.expect(matrix3.at(1, 1) == 4.0);
    try testing.expect(matrix3.at(1, 2) == 7.0);
    try testing.expect(matrix3.at(1, 3) == 8.0);
}

test "det" {
    var data = [_]f64{ 1, 2, 3, 4 };
    var size = data.len;
    var matrix = try matr.matrix(data[0..size], 2, 2);
    const det = try matrix.det();
    try testing.expect(det == -2.0);
}

test "lu_decomposition" {
    var data = [_]f64{ 4, 3, 6, 3 };
    var size = data.len;
    var matrix = try matr.matrix(data[0..size], 2, 2);
    var lu = try matrix.lu_decomposition();
    try testing.expect(lu.at(0, 0) == 1.0);
    try testing.expect(lu.at(0, 1) == 0.0);
    try testing.expect(lu.at(0, 2) == 4);
    try testing.expect(lu.at(0, 3) == 3);
    try testing.expect(lu.at(1, 0) == 1.5);
    try testing.expect(lu.at(1, 1) == 1.0);
    try testing.expect(lu.at(1, 2) == 0.0);
    try testing.expect(lu.at(1, 3) == -1.5);
}

test "split_col" {
    var data = [_]f64{ 4, 3, 6, 3 };
    var size = data.len;
    var matrix = try matr.matrix(data[0..size], 2, 2);
    var mat_arr = try matrix.split_col(1);
    var col = mat_arr[0];
    try testing.expect(col.at(0, 0) == 4.0);
    try testing.expect(col.at(1, 0) == 6.0);
    var col2 = mat_arr[1];
    try testing.expect(col2.at(0, 0) == 3.0);
    try testing.expect(col2.at(1, 0) == 3.0);
}

test "upper triangular" {
    var data = [_]f64{ 4, 3, 6, 3 };
    var size = data.len;
    var matrix = try matr.matrix(data[0..size], 2, 2);
    var upper = try matrix.upper_triangular();
    try testing.expect(upper.at(0, 0) == 4.0);
    try testing.expect(upper.at(0, 1) == 3.0);
    try testing.expect(upper.at(1, 0) == 0.0);
    try testing.expect(upper.at(1, 1) == -1.5);
}

test "inverse" {
    var data = [_]f64{ -1, 1.5, 1.0, -1.0 };
    var size = data.len;
    var matrix = try matr.matrix(data[0..size], 2, 2);
    var inverse = try matrix.inverse();
    try testing.expect(inverse.at(0, 0) == 2);
    try testing.expect(inverse.at(0, 1) == 3);
    try testing.expect(inverse.at(1, 0) == 2);
    try testing.expect(inverse.at(1, 1) == 2);
    const eye = try matrix.prod(inverse);
    const ideal_eye = try matr.eye(2);
    try testing.expect(eye.equal(ideal_eye));
}

test "reshape" {
    var data = [_]f64{ 1, 2, 3, 4 };
    var size = data.len;
    var matrix = try matr.matrix(data[0..size], 2, 2);
    var matrix2 = try matrix.reshape(4, 1);
    try testing.expect(matrix2.at(0, 0) == 1.0);
    try testing.expect(matrix2.at(1, 0) == 2.0);
    try testing.expect(matrix2.at(2, 0) == 3.0);
    try testing.expect(matrix2.at(3, 0) == 4.0);
}

test "flatten" {
    var data = [_]f64{ 1, 2, 3, 4 };
    var size = data.len;
    var matrix = try matr.matrix(data[0..size], 2, 2);
    var matrix2 = try matrix.flatten();
    try testing.expect(matrix2.equal(try matr.matrix(
        data[0..size],
        1,
        4,
    )));
}
