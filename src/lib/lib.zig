const rl = @import("raylib");
pub const drawRectangleOutline = @import("uiFunctions.zig").drawRectangleOutline;
pub const button = @import("components/Button.zig");

pub const SCREEN_WIDTH: i32 = 800;
pub const SCREEN_HEIGHT: i32 = 450;

pub const EnvItem = struct {
    blocking: bool,
    rect: rl.Rectangle,
    color: rl.Color,
};

pub const Player = struct {
    can_jump: bool,
    speed: rl.Vector2,
    position: rl.Vector2,
};

pub const OutlineEdges = enum { Top, Left, Right, Bottom };


