const std = @import("std");

pub fn discover_modules(b: *std.Build, root_source_path: []const u8) !std.ArrayList(*std.Build.Module) {
    const dir_iterator = try std.fs.cwd().openIterableDir(root_source_path, .{});
    var iterator = dir_iterator.iterate();
    var array = std.ArrayList(*std.Build.Module).init(std.heap.page_allocator);
    errdefer array.deinit();
    while (try iterator.next()) |path| {
        switch (path.kind) {
            .directory => {
                std.debug.print("directory: {s}\n", .{path.name});
                const subdir = try std.mem.join(std.heap.page_allocator, "/", &[_][]const u8{ root_source_path, path.name });
                const modules = try discover_modules(b, subdir);
                for (modules.items) |module| {
                    try array.append(module);
                }
            },
            .file => {
                if (std.mem.eql(u8, path.name[path.name.len - 4 .. path.name.len], ".zig")) {
                    const module_path = try std.mem.join(std.heap.page_allocator, "/", &[_][]const u8{ root_source_path, path.name });
                    const module_name: []const u8 = module_path[0 .. module_path.len - 4];
                    var output_module_name: []u8 = try std.heap.page_allocator.alloc(u8, module_name.len);
                    _ = std.mem.replace(u8, module_name, "/", ".", output_module_name);
                    const module = b.addModule(output_module_name, .{ .source_file = .{ .path = module_path } });
                    try array.append(module);
                }
            },
            else => {},
        }
    }
    return array;
}

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});
    const modules = try discover_modules(b, "src");
    const common = b.addModule("common", .{ .source_file = .{ .path = "src/common.zig" } });
    const zigPhysics_points = b.addModule("zigPhysics.points", .{ .source_file = .{ .path = "src/zigPhysics/points.zig" } });
    const unit_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/common_test.zig" },
        .target = target,
        .optimize = optimize,
    });
    for (modules.items) |module| {
        std.debug.print("module: {any}\n", .{module});
    }
    unit_tests.addModule("common", common);
    unit_tests.addModule("zigPhysics.points", zigPhysics_points);
    const run_unit_tests = b.addRunArtifact(unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);
}
