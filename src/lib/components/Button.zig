const std = @import("std");
const rl = @import("raylib");
const OutlineEdges = @import("../structs.zig").OutlineEdges;

pub const CallbackFunction = *const fn () void;

pub const Location = struct { x1: i32, x2: i32, y1: i32, y2: i32 };


pub const TextButton = struct {
    text: *const [8:0]u8,
    text_size: i32,
    textColour: rl.Color,
    backgroundColour: rl.Color,
    location: Location,
    hover: bool,
    // callback: CallbackFunction,

    pub fn drawButton(self: TextButton) void {
        const location = self.location;
        switch (self.hover) {
            false => {
                var edges = [_]OutlineEdges{ .Left, .Bottom };
                const center = calculateCenter(location.x1, location.y1, location.x2, location.y2);

                rl.drawRectangle(location.x1, location.y1, location.x2, location.y2, self.backgroundColour);
                drawRectangleOutline(location.x1, location.y1, location.x2, location.y2, 10, &edges, self.textColour);
                drawText(center[0], center[1], self.text, self.text_size, self.textColour);
            },
            true => {
                // var edges = [_]OutlineEdges{ .Right, .Top };

                rl.drawRectangle(location.x1, location.y1, location.x2, location.y2, self.textColour);
                // drawOutline(location.x1, location.y1, location.x2, location.y2, 10, &edges);
            },
        }
    }

    fn drawRectangleOutline(x1: i32, y1: i32, x2: i32, y2: i32, width: i32, sides: []OutlineEdges, outline_colour: rl.Color) void {
        for (sides) |side| {
            switch (side) {
                .Left => rl.drawRectangle(x1, y1, width, y2, outline_colour),
                .Right => rl.drawRectangle(x2 + 40, y1 + 50, width, y2, .dark_green),
                .Top => rl.drawRectangle(x1, y1 + 50, x2, width, .dark_green),
                .Bottom => rl.drawRectangle(x1, y2 + 200, x2, width, outline_colour),
            }
        }
    }

    fn drawText(x: i32, y: i32, text: []const u8, text_size: i32, text_colour: rl.Color) void {
        const cText: [:0]const u8 = @ptrCast(text.ptr[0..text.len]);
        rl.drawText(cText, x, y, text_size, text_colour);
    }

    fn calculateCenter(x1: i32, y1: i32, x2: i32, y2: i32) [2]i32 {
        return [_]i32{@divFloor(x2-x1, 2)+x1, @divFloor(y2-y1, 2)+y1};
    }
};
