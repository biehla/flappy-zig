// raylib-zig (c) Axel Magnuson 2025
//
// This is a fairly close 1-1 copy of the original example from raylib, and
// thus might not represent completely idiomatic or clean zig.

const rl = @import("raylib");
const rm = @import("raymath");

const Rect = rl.Rectangle;
const Vec2 = rl.Vector2;
const Color = rl.Color;
const Camera2D = rl.Camera2D;

const CameraUpdater = *const fn (
    camera: *Camera2D,
    player: *Player,
    env_items: []EnvItem,
    delta: f32,
    width: i32,
    height: i32,
) void;

const G: i32 = 400;
// const G: i32 = 0;
const PLAYER_JUMP_SPD: f32 = 225;
const PLAYER_HOR_SPD: f32 = 200;

const SCREEN_WIDTH: i32 = 800;
const SCREEN_HEIGHT: i32 = 450;

const Player = struct {
    can_jump: bool,
    speed: rl.Vector2,
    position: rl.Vector2,
};

const EnvItem = struct {
    blocking: bool,
    rect: rl.Rectangle,
    color: rl.Color,
};

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width = SCREEN_WIDTH;
    const screen_height = SCREEN_HEIGHT;

    rl.initWindow(screen_width, screen_height, "raylib [core] example - 2d camera");
    defer rl.closeWindow(); // Close window and OpenGL context

    var player: Player = .{ .can_jump = false, .speed = Vec2.init(0, 0), .position = Vec2.init(400, 280) };
    var env_items = [_]EnvItem{
        .{ .rect = Rect.init(700, 300, 75, 250), .blocking = true, .color = .blue },
        .{ .rect = Rect.init(700, 0, 75, 250), .blocking = true, .color = .blue },
    };

    var camera: rl.Camera2D = .{
        .target = player.position,
        .offset = Vec2.init(screen_width / 2, screen_height / 2),
        .rotation = 0,
        .zoom = 1,
    };

    rl.setTargetFPS(60); // Set our game to run at 60 frames per second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) {
        // Update
        //----------------------------------------------------------------------------------
        const delta_time = rl.getFrameTime();

        updatePlayer(&player, &env_items, delta_time);

        camera.zoom += rl.getMouseWheelMove() * 0.05;
        if (camera.zoom > 3) camera.zoom = 3;
        if (camera.zoom < 0.25) camera.zoom = 0.25;

        // input: reset
        if (rl.isKeyPressed(.r)) {
            camera.zoom = 1;
            player.position = Vec2.init(400, 280);
        }

        // call update camera by pointer
        // updateCameraCenter(
        //     &camera,
        //     &player,
        //     &env_items,
        //     delta_time,
        //     screen_width,
        //     screen_height,
        // );

        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        {
            rl.beginDrawing();
            defer rl.endDrawing();

            rl.clearBackground(.sky_blue);

            {
                rl.beginMode2D(camera);
                defer rl.endMode2D();

                for (env_items) |env_item| {
                    rl.drawRectangleRec(env_item.rect, env_item.color);
                }

                rl.drawCircle(100, 100, 100, .yellow);

                const player_rect = Rect.init(player.position.x - 20, player.position.y - 40, 40, 40);
                rl.drawRectangleRec(player_rect, .red);
                rl.drawCircleV(player.position, 5, .gold);
            }

            rl.drawText("Controls:", 20, 20, 10, .black);
            rl.drawText("- Right/Left to move", 40, 40, 10, .dark_gray);
        }

        //----------------------------------------------------------------------------------
    }
}

//------------------------------------------------------------------------------------
// Player update function
//------------------------------------------------------------------------------------

fn updatePlayer(player: *Player, env_items: []EnvItem, delta: f32) void {
    if (rl.isKeyDown(.left)) {
        player.speed.x = -PLAYER_HOR_SPD;
    } else if (rl.isKeyDown(.right)) {
        player.speed.x = PLAYER_HOR_SPD;
    } else {
        player.speed.x = 0;
    }

    if (rl.isKeyDown(.space)) {
        player.speed.y = -PLAYER_JUMP_SPD;
    }

    if (player.position.x >= SCREEN_WIDTH - 40 or player.position.x <= 40) {
        player.speed.x *= 0;
    }
    if (player.position.y >= SCREEN_HEIGHT + 40 or player.position.y <= 100) {
        player.speed.y *= 0;
    }

    var hit_obstacle = false;
    for (env_items) |ei| {
        var p: *Vec2 = &player.position;
        if (ei.blocking and
            ei.rect.x <= p.x and
            ei.rect.x + ei.rect.width >= p.x and
            ei.rect.y >= p.y and
            ei.rect.y <= p.y + player.speed.x * delta)
        {
            hit_obstacle = true;
            player.speed.x = 0;
            p.y = ei.rect.y;
            break;
        }
    }

    if (!hit_obstacle) {
        player.position.y += player.speed.y * delta;
        player.position.x += player.speed.x * delta;
        // player.speed.y += G * delta;
    }
}

//------------------------------------------------------------------------------------
// Selectable camera update functions
//------------------------------------------------------------------------------------

// Follow player center
fn updateCameraCenter(
    camera: *Camera2D,
    player: *Player,
    _: []EnvItem,
    _: f32,
    width: i32,
    height: i32,
) void {
    const widthf: f32 = @floatFromInt(width);
    const heightf: f32 = @floatFromInt(height);
    camera.offset = Vec2.init(widthf / 2, heightf / 2);
    camera.target = player.position;
}
