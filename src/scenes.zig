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
    var scenes_dir_handle = try fs.cwd().openDir("./scenes/", .{ .iterate = true });
    defer scenes_dir_handle.close();
    var scenes_dir_contents = scenes_dir_handle.iterate();
    var scenes_zon_handle = scenes_dir_handle.createFile("../scenes.zon", .{}) catch |err| {
        std.log.err("poop", .{});
        std.log.err("poop {any}", .{err});
        std.debug.print("poop {any}", .{err});
        return fs.Dir.OpenError.FileNotFound;
    };
    // var buffer: [100]u8 = undefined;
    // var fileWriter = scenes_zon_handle.writer(&buffer);
    defer scenes_zon_handle.close();

    var arena: std.heap.ArenaAllocator = .init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();



    var writer: std.io.Writer.Allocating = try .initCapacity(allocator, 5);
    defer writer.deinit();

    var scene_files: std.ArrayList([]const u8) = try std.ArrayList([]const u8).initCapacity(allocator, 3);//try std.ArrayList([]const u8).initCapacity(allocator, 1);
    defer scene_files.deinit(allocator);

    while (try scenes_dir_contents.next()) |scene| {
        const name: []const u8 = try std.mem.Allocator.dupe(allocator, u8, scene.name);
        switch (scene.kind) {
            .file => {
                try scene_files.append(allocator, name);
                std.log.err("Saving node: {s}", .{name});

                // var new_scene: SceneFile = .{ .data = scene.name };
            },
            else => std.log.err("NOT Saving NOde: {s}", .{scene.name}),
        }
    }



    // var curr = scene_files.first.?;

    // scene_files.


    while (scene_files.pop()) |file| {
        // const node_data: *SceneFile = @fieldParentPtr("node", curr);
        std.log.err("Logging node: {s}", .{file});

        try std.zon.stringify.serialize(file, .{}, &writer.writer);
    }


    const written = writer.written();
    std.log.err("Log: {s}" , .{written});
}

pub fn main() void {
    getScenes() catch |err| {
        std.debug.print("{any}", .{err});
    };
}
