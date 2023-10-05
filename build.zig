const std = @import("std");

pub fn discover_modules(b: *std.Build, root_source_path: []const u8, root_module_prefix: []const u8) !std.StringHashMap(*std.Build.Module) {
    const dir_iterator = try std.fs.cwd().openIterableDir(root_source_path, .{});
    var iterator = dir_iterator.iterate();
    var map = std.StringHashMap(*std.Build.Module).init(std.heap.page_allocator);
    errdefer map.deinit();
    while (try iterator.next()) |path| {
        switch (path.kind) {
            .directory => {
                std.debug.print("directory: {s}\n", .{path.name});
                const subdir = try std.mem.join(std.heap.page_allocator, "/", &[_][]const u8{ root_source_path, path.name });
                const modules = try discover_modules(b, subdir, root_module_prefix);
                var modules_iterator = modules.iterator();
                while (modules_iterator.next()) |module| {
                    try map.put(module.key_ptr.*, module.value_ptr.*);
                }
            },
            .file => {
                if (std.mem.eql(u8, path.name[path.name.len - 4 .. path.name.len], ".zig") and
                    !std.mem.eql(u8, path.name[path.name.len - 8 .. path.name.len], "test.zig"))
                {
                    const module_path = try std.mem.join(std.heap.page_allocator, "/", &[_][]const u8{ root_source_path, path.name });
                    const module_path_without_root = module_path[root_module_prefix.len..module_path.len];
                    const module_name: []const u8 = module_path_without_root[0 .. module_path_without_root.len - 4];
                    var output_module_name: []u8 = try std.heap.page_allocator.alloc(u8, module_name.len);
                    _ = std.mem.replace(u8, module_name, "/", ".", output_module_name);
                    const module = b.addModule(output_module_name, .{ .source_file = .{ .path = module_path } });
                    std.debug.print("path: {s}, module: {s}\n", .{ module_path, output_module_name });
                    try map.put(output_module_name, module);
                }
            },
            else => {},
        }
    }
    return map;
}

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});
    const modules = try discover_modules(b, "src", "src/");
    const unit_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/common_test.zig" },
        .target = target,
        .optimize = optimize,
    });
    var iterator = modules.iterator();
    while (iterator.next()) |module| {
        unit_tests.addModule(module.key_ptr.*, module.value_ptr.*);
    }
    const run_unit_tests = b.addRunArtifact(unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);
}
