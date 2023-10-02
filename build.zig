const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard optimization options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. Here we do not
    // set a preferred release mode, allowing the user to decide how to optimize.
    const optimize = b.standardOptimizeOption(.{});

    const zigCommon = b.addModule("common", .{ .source_file = .{ .path = "src/common.zig" } });
    const zigDraw = b.addModule("zig-draw", .{ .source_file = .{ .path = "src/zigDraw/draw.zig" }, .dependencies = &[_]std.build.ModuleDependency{.{ .name = "common", .module = zigCommon }} });
    const zigMatrix = b.addModule("zig-matrix", .{ .source_file = .{ .path = "src/zigMatrix/matrix.zig" }, .dependencies = &[_]std.build.ModuleDependency{.{ .name = "common", .module = zigCommon }} });
    const zigPhysics = b.addModule("zig-physics", .{ .source_file = .{ .path = "src/zigPhysics/points.zig" }, .dependencies = &[_]std.build.ModuleDependency{.{ .name = "common", .module = zigCommon }} });
    // This declares intent for the library to be installed into the standard
    // location when the user invokes the "install" step (the default step when
    // running `zig build`).

    const unit_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/common_test.zig" },
        .target = target,
        .optimize = optimize,
    });
    unit_tests.addModule("common", zigCommon);
    unit_tests.addModule("zig-draw", zigDraw);
    unit_tests.addModule("zig-matrix", zigMatrix);
    unit_tests.addModule("zig-physics", zigPhysics);
    const run_unit_tests = b.addRunArtifact(unit_tests);

    // Similar to creating the run step earlier, this exposes a `test` step to
    // the `zig build --help` menu, providing a way for the user to request
    // running the unit tests.
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);
}
