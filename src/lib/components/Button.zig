const std = @import("std");
const rl = @import("raylib");
const OutlineEdges = @import("../lib.zig").OutlineEdges;

pub const CallbackFunction = *const fn () void;

pub const Location = struct { x: i32, y: i32, width: i32, height: i32 };

pub const TextButton = struct {
    text: *const [8:0]u8,
    text_size: i32,
    textColour: rl.Color,
    backgroundColour: rl.Color,
    location: Location,
    border_size: i32,
    // callback: CallbackFunction,

    pub fn drawButton(self: TextButton) void {
        var hover = false;

        const location = self.location;
        const mouse = .{
            .x = rl.getMouseX(),
            .y = rl.getMouseY()
        };

        if ((mouse.x >= self.location.x and
            mouse.x <= self.location.x + self.location.width) and
            (mouse.y >= self.location.y and
            mouse.y <= self.location.y + self.location.height)) {
            hover = true;
        }

        switch (hover) {
            false => {
                var edges = [_]OutlineEdges{ .Left, .Bottom };
                const center = calculateCenter(self.location.x, self.location.y, self.location.width, self.location.height);

                rl.drawRectangle(self.location.x, self.location.y,
                                self.location.width, self.location.height,
                                self.backgroundColour
                );

                drawRectangleOutline(location.x, location.y,
                                    location.width, location.height,
                                    self.border_size,
                                    &edges,
                                    self.textColour
                );

                drawText(center[0], center[1], self.text, self.text_size, self.textColour);
            },
            true => {
                var edges = [_]OutlineEdges{ .Left, .Bottom };
                const center = calculateCenter(self.location.x, self.location.y, self.location.width, self.location.height);

                rl.drawRectangle(self.location.x, self.location.y,
                                self.location.width, self.location.height,
                                self.textColour
                );

                drawRectangleOutline(location.x, location.y,
                                    location.width, location.height,
                                    self.border_size,
                                    &edges,
                                    self.backgroundColour
                );

                drawText(center[0], center[1], self.text, self.text_size, self.backgroundColour);
            
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

    fn calculateCenter(x: i32, y: i32, width: i32, height: i32) [2]i32 {
        const x_center = x + @divFloor(width, 2);
        const y_center = y + @divFloor(height, 2);
        return [2]i32{x_center, y_center};
    }
};
