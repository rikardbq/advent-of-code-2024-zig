const std = @import("std");

const day_one = @import("day1.zig");
const day_two = @import("day2.zig");

pub const DayOne = struct {
    pub fn run() !void {
        const part_one_res = try day_one.part_one();
        const part_two_res = try day_one.part_two();
        std.debug.print("part one -> {d}\n", .{part_one_res});
        std.debug.print("part two -> {d}\n", .{part_two_res});
    }
};

pub const DayTwo = struct {
    pub fn run() !void {
        const part_one_res = try day_two.part_one();
        const part_two_res = try day_two.part_two();
        std.debug.print("part one -> {d}\n", .{part_one_res});
        std.debug.print("part two -> {d}\n", .{part_two_res});
    }
};
