const std = @import("std");
const rl = @import("raylib");
const drawOutline = @import("../uiFunctions.zig").drawRectangleOutline;
const OutlineEdges = @import("../structs.zig").OutlineEdges;

pub const CallbackFunction = *const fn () void;

pub const Location = struct {
    x1: i32,
    x2: i32,
    y1: i32,
    y2: i32
};

pub const ShadowDirection = enum {
    bottom_left,
    top_left,
    top_right,
    bottom_right
};


pub const TextButton = struct {
    shadow: ShadowDirection,
    text: *const [8:0]u8,
    textColour: rl.Color,
    backgroundColour: rl.Color,
    location: Location,
    hover: bool,
    // callback: CallbackFunction,

    pub fn drawButton(self: TextButton) void {
        const location = self.location;
        switch (self.hover) {
            true => {
                rl.drawRectangle(location.x1, location.y1, location.x2, location.y2, self.backgroundColour);
                drawOutline(location.x1, location.y1, location.x2, location.y2, OutlineEdges{});
            },
            false => {
                rl.drawRectangle(location.x1, location.y1, location.x2, location.y2, self.textColour);
                drawOutline(location.x1, location.y1, location.x2, location.y2, self.backgroundColour);
            }
        }
    }
};
