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
    var scenes_dir_handle = try fs.cwd().openDir("./scenes/", .{.iterate = true});
    defer scenes_dir_handle.close();
    var scenes_dir_contents = scenes_dir_handle.iterate();
    var scenes_zon_handle = try fs.cwd().openFile("scenes.zon", .{.mode = .write_only});
    defer scenes_zon_handle.close();

    // var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    // defer arena.deinit();
    // const allocator = arena.allocator();

    var scene_files: std.SinglyLinkedList = .{};

    while (try scenes_dir_contents.next()) |scene| {
        if (scene.kind == .file) {
            var new_scene: SceneFile = .{ .data = scene.name };
            scene_files.prepend(&new_scene.node);
        }
    }

    var current_file = scene_files.first;
    while (current_file) |file| : (current_file = file.next) {
        const fileNode: *SceneFile = @fieldParentPtr("node", file);

        const fileName = std.zon.stringify.serialize(fileNode, .{}, scenes_zon_handle.write())  //(fileNode.data);
        scenes_zon_handle.writer(fileName);
    }
}

pub fn main() void {
    getScenes() catch |err| {
        std.debug.print("{any}", .{ err });
    };
}
