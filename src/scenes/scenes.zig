const mainMenu = @import("mainMenu.zig");
const mainScene = @import("mainScene.zig");
const rl = @import("raylib");

pub const Scenes = enum(usize) { MAIN_MENU, MAIN };

pub fn displayScene(scene: Scenes, camera: rl.Camera2D) void {
    switch (scene) {
        .MAIN_MENU => mainMenu.showScene(camera),
        .MAIN => mainScene.showScene(camera),
    }
}
