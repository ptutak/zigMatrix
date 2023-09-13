const testing = @import("std").testing;
const zigMatrix = @import("add.zig");

test "basic add functionality" {
    try testing.expect(zigMatrix.add(3, 7) == 10);
}
