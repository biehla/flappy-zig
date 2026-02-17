const rl = @import("raylib");
const Vec2 = rl.Vector2;

const env = @import("../lib/lib.zig");
const EnvItem = env.EnvItem;
const Player = env.Player;

const Rect = rl.Rectangle;

pub fn showScene(camera: rl.Camera2D) void {
    const player: Player = .{ .can_jump = false, .speed = Vec2.init(0, 0), .position = Vec2.init(400, 280) };
    const env_items = [_]EnvItem{
        .{ .rect = Rect.init(700, 300, 75, 250), .blocking = true, .color = .blue },
        .{ .rect = Rect.init(700, 0, 75, 250), .blocking = true, .color = .blue },
    };

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
