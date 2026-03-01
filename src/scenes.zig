const std = @import("std");
const fs = std.fs;
const Allocator = std.mem.Allocator;

const mainMenu = @import("scenes/mainMenu.zig");
const mainScene = @import("scenes/mainScene.zig");
const rl = @import("raylib");

pub const Scenes = enum(usize) { MAIN_MENU, MAIN };

pub const SceneFile = struct {
    data: []const u8,
    node: std.SinglyLinkedList.Node = .{},
};

pub fn displayScene(scene: Scenes, camera: rl.Camera2D) void {
    switch (scene) {
        .MAIN_MENU => mainMenu.showScene(camera),
        .MAIN => mainScene.showScene(camera),
    }
}

fn getScenes() anyerror!void {
    // Set up handles for the scene directory and zon output file
    var scenes_dir_handle = try fs.cwd().openDir("./scenes/", .{ .iterate = true });
    var scenes_dir_contents = scenes_dir_handle.iterate();
    var scenes_zon_handle = try scenes_dir_handle.createFile("../scenes.zon", .{});
    defer scenes_dir_handle.close();
    defer scenes_zon_handle.close();

    // Set up memory allocators to temporarily store scene list
    var arena: std.heap.ArenaAllocator = .init(std.heap.page_allocator);
    const allocator = arena.allocator();
    var scene_files: std.ArrayList([]const u8) = try std.ArrayList([]const u8).initCapacity(allocator, 2);
    defer arena.deinit();
    defer scene_files.deinit(allocator);

    // Setup string writer 
    var writer: std.io.Writer.Allocating = try .initCapacity(allocator, 5);
    defer writer.deinit();

    while (try scenes_dir_contents.next()) |scene| {
        switch (scene.kind) {
            .file => {
                try scene_files.append(allocator, try std.mem.Allocator.dupe(allocator, u8, scene.name));
                std.log.err("Saving node: {s}", .{scene.name});
            },
            else => std.log.err("NOT Saving NOde: {s}", .{scene.name}),
        }
    }

    try std.zon.stringify.serialize(scene_files, .{}, &writer.writer);


    const written = writer.written();
    _ = try scenes_zon_handle.write(written);
    std.log.err("Log: {s}" , .{written});
}

pub fn main() void {
    getScenes() catch |err| {
        std.debug.print("{any}", .{err});
    };
}
