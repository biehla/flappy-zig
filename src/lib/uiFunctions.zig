const rl = @import("raylib");
const Env = @import("lib.zig");

pub fn drawRectangleOutline(x1: i32, y1: i32, x2: i32, y2: i32, width: i32, sides: []Env.OutlineEdges) void {
    for (sides) |side| {
        switch (side) {
            .Left => rl.drawRectangle(x1, y1 + 50, width, y2, .dark_green),
            .Right => rl.drawRectangle(x2 + 40, y1 + 50, width, y2, .dark_green),
            .Top => rl.drawRectangle(x1, y1 + 50, x2, width, .dark_green),
            .Bottom => rl.drawRectangle(x1, y2 + 150, x2, width, .dark_green),
        }
    }
}
