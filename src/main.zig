const std = @import("std");
const dayOne = @import("days/day1.zig");

pub fn main() !void {
    try dayOne.DayOne.run();
}
