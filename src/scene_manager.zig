const rl = @import("raylib");
const std = @import("std");
const fs = std.fs;

const screen_width = 800;
const screen_height = 450;

/// Valid game states used in the state machine
const GameScreen = Scenes();

fn Scenes() @TypeOf(enum {}) {
    // const scenes_dir = fs.
    const cwd = fs.cwd();
    const scene_path = fs.openDirZ(cwd., args: OpenOptions)
    const scene_dir_list = fs.openDirAbsolute(scene_path, .{ .iterate = true });
    defer scene_path.close();
    defer scene_dir_list.close();

    const num_scenes: u8 = {
        var scenes: u8 = 0;

        inline for (scenes) |_| {
            scenes = scenes + 1;
        }

        return scenes;
    };

    var scenes: [num_scenes]std.builtin.Type.EnumField =  undefined;

    for (scene_dir_list, 0..) |scene, index| {
        scenes[index] = .{ .name = scene.name };
    }

    return @Type(.{.@"enum" =  .{
        .tag_type = u8,
        .fields = &scenes,
        .decls = .{},
        .is_exhaustive = true
    }});
}

pub fn main() anyerror!void {
    // const current_screen = GameScreen.main_menu;

    for (GameScreen) |screen| {
        std.debug.print("{any}", .{screen});
    }

    // switch (current_screen) {
    //     .main_menu => {
    //         //do something
    //         con
    //     },
    // }
    // ---------------------------------------------------------------------

    // Draw
    // ---------------------------------------------------------------------
    // {
    //     rl.beginDrawing();
    //     defer rl.endDrawing();
    //
    //     switch (current_screen) {
    //         .logo => {
    //             // TODO: Draw `logo` state here!
    //             rl.drawText("LOGO SCREEN", 20, 20, 40, .light_gray);
    //             rl.drawText(
    //                 "WAIT for 2 SECONDS...",
    //                 290,
    //                 220,
    //                 20,
    //                 .gray,
    //             );
    //         },
    //         .title => {
    //             // TODO: Draw `title` state here!
    //             rl.drawRectangle(
    //                 0,
    //                 0,
    //                 screen_width,
    //                 screen_height,
    //                 .green,
    //             );
    //             rl.drawText(
    //                 "TITLE SCREEN",
    //                 20,
    //                 20,
    //                 40,
    //                 .dark_green,
    //             );
    //             rl.drawText(
    //                 "PRESS ENTER or TAP to JUMP to GAMEPLAY SCREEN",
    //                 120,
    //                 220,
    //                 20,
    //                 .dark_green,
    //             );
    //         },
    //         .gameplay => {
    //             // TODO: Draw `gameplay` state here!
    //             rl.drawRectangle(
    //                 0,
    //                 0,
    //                 screen_width,
    //                 screen_height,
    //                 .purple,
    //             );
    //             rl.drawText("GAMEPLAY SCREEN", 20, 20, 40, .maroon);
    //             rl.drawText(
    //                 "PRESS ENTER or TAP to JUMP to ENDING SCREEN",
    //                 130,
    //                 220,
    //                 20,
    //                 .maroon,
    //             );
    //         },
    //         .ending => {
    //             // TODO: Draw `ending` state here!
    //             rl.drawRectangle(
    //                 0,
    //                 0,
    //                 screen_width,
    //                 screen_height,
    //                 .blue,
    //             );
    //             rl.drawText(
    //                 "ENDING SCREEN",
    //                 20,
    //                 20,
    //                 40,
    //                 .dark_blue,
    //             );
    //             rl.drawText(
    //                 "PRESS ENTER or TAP to RETURN to TITLE SCREEN",
    //                 120,
    //                 220,
    //                 20,
    //                 .dark_blue,
    //             );
    //         },
    //     }
    // }
    // ---------------------------------------------------------------------
}
