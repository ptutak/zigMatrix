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

    const zigSharedLibModule = b.addModule("common", .{ .source_file = .{ .path = "src/common.zig" } });
    const zigDraw = b.addStaticLibrary(.{ .name = "zig-draw", .root_source_file = .{ .path = "src/zigDraw/draw.zig" }, .target = target, .optimize = optimize });
    const zigMatrix = b.addStaticLibrary(.{ .name = "zig-matrix", .root_source_file = .{ .path = "src/zigMatrix/matrix.zig" }, .target = target, .optimize = optimize });
    const zigPhysics = b.addStaticLibrary(.{ .name = "zig-physics", .root_source_file = .{ .path = "src/zigPhysics/points.zig" }, .target = target, .optimize = optimize });
    zigDraw.addModule("common", zigSharedLibModule);
    zigMatrix.addModule("common", zigSharedLibModule);
    zigPhysics.addModule("common", zigSharedLibModule);
    // This declares intent for the library to be installed into the standard
    // location when the user invokes the "install" step (the default step when
    // running `zig build`).
    b.installArtifact(zigDraw);
    b.installArtifact(zigMatrix);
    b.installArtifact(zigPhysics);

    const unit_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/common_test.zig" },
        .target = target,
        .optimize = optimize,
    });

    const run_unit_tests = b.addRunArtifact(unit_tests);

    // Similar to creating the run step earlier, this exposes a `test` step to
    // the `zig build --help` menu, providing a way for the user to request
    // running the unit tests.
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);
}
