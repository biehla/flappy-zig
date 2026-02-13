const rl = @import("raylib");
const Env = @import("../lib/structs.zig");
const EnvItem = Env.EnvItem;
const Player = Env.Player;
const Rect = rl.Rectangle;

pub fn showScene(camera: rl.Camera2D) void {
    const button: Env.button.TextButton = .{ .backgroundColour = .red, .textColour = .ray_white, .shadow = .bottom_left, .hover = false, .location = .{ .x1 = 50, .y1 = 150, .x2 = 700, .y2 = 300 }, .text = "Hello :)" };

    rl.beginDrawing();
    defer rl.endDrawing();

    rl.clearBackground(.sky_blue);

    {
        rl.beginMode2D(camera);
        defer rl.endMode2D();

        rl.drawRectangle(50, 150, 700, 300, .green);

        const edge = Env.OutlineEdges;

        const edges = .{ edge.Left, edge.Right, edge.Top, edge.Bottom };
        Env.drawRectangleOutline(50, 100, 700, 300, 10, edges);

        rl.drawText("Florpy Borb", (Env.SCREEN_WIDTH / 2) - 150, 70, 50, .white);
        button.drawButton();
    }
}
