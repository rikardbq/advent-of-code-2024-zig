const std = @import("std");
const days = @import("days/index.zig");

pub fn main() !void {
    std.debug.print("*****************************\n", .{});
    std.debug.print("**** ADVENT OF CODE 2024 ****\n", .{});
    std.debug.print("*****************************\n", .{});

    std.debug.print("\n\n*********** DAY 1 ***********\n", .{});
    std.debug.print("*****************************\n", .{});
    try days.DayOne.run();

    std.debug.print("\n\n*********** DAY 2 ***********\n", .{});
    std.debug.print("*****************************\n", .{});
    try days.DayTwo.run();
}
