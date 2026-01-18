const std = @import("std");

pub fn build(_build: *std.Build) void {

    const target = _build.standardTargetOptions(.{});
    const optimize = _build.standardOptimizeOption(.{});

    const exe = _build.addExecutable(.{
        .name = "Name",
        .root_module = _build.createModule(.{
            .root_source_file = _build.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    _build.installArtifact(exe);

    const run_step = _build.step("run", "Run the app");

    const run_cmd = _build.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);

    run_cmd.step.dependOn(_build.getInstallStep());

    if (_build.args) |args| {
        run_cmd.addArgs(args);
    }
}
