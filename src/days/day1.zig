const std = @import("std");
const util = @import("../util/util.zig");

pub const DayOne = struct {
    pub fn run() !void {
        const part_one_res = try part_one();
        const part_two_res = try part_two();
        std.debug.print("part one -> {d}\n", .{part_one_res});
        std.debug.print("part two -> {d}\n", .{part_two_res});
    }
};

fn part_one() !i32 {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const input = try util.read_input_file("assets/day1_input.txt", allocator);
    defer allocator.free(input);

    const inputs = try prepare_input(input, allocator);

    var sum: i32 = 0;
    var idx: usize = 0;

    for (inputs.left) |l| {
        var n = l - inputs.right[idx];

        if (n < 0) {
            n = ~n + 1;
        }

        sum = sum + n;
        idx += 1;
    }

    return sum;
}

fn part_two() !i32 {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const input = try util.read_input_file("assets/day1_input.txt", allocator);
    defer allocator.free(input);

    const inputs = try prepare_input(input, allocator);

    var hash_table = std.hash_map.AutoHashMap(i32, i32).init(allocator);
    defer hash_table.deinit();

    var idx: usize = 0;
    for (inputs.right) |l| {
        if (std.mem.containsAtLeast(i32, inputs.left, 1, &[1]i32{l})) {
            var count = hash_table.get(l);
            if (!hash_table.contains(l)) {
                count = 0;
            }
            try hash_table.put(l, count.? + 1);
        }
        idx += 1;
    }

    var sum: i32 = 0;
    var iterator = hash_table.iterator();
    while (iterator.next()) |entry| {
        sum = sum + entry.key_ptr.* * entry.value_ptr.*;
    }

    return sum;
}

fn prepare_input(input: []const u8, allocator: std.mem.Allocator) !struct { left: []i32, right: []i32 } {
    var split_input = std.mem.splitSequence(u8, input, "\n");
    var left = std.ArrayList(i32).init(allocator);
    var right = std.ArrayList(i32).init(allocator);

    while (split_input.next()) |row| {
        var sub_split = std.mem.splitSequence(u8, row, " ");
        var idx: usize = 1;

        while (sub_split.next()) |number| {
            const replace_size = std.mem.replacementSize(u8, number, " ", "");
            const output = try allocator.alloc(u8, replace_size);
            _ = std.mem.replace(u8, number, " ", "", output);
            defer allocator.free(output);

            if (output.len > 0) {
                const parsed_n = try std.fmt.parseInt(i32, output, 10);

                if (@mod(idx, 2) == 0) {
                    try right.append(parsed_n);
                } else {
                    try left.append(parsed_n);
                }

                idx += 1;
            }
        }
    }

    const left_sorted = try left.toOwnedSlice();
    const right_sorted = try right.toOwnedSlice();
    std.mem.sort(i32, left_sorted, {}, compare_by_value);
    std.mem.sort(i32, right_sorted, {}, compare_by_value);

    return .{ .left = left_sorted, .right = right_sorted };
}

fn compare_by_value(context: void, a: i32, b: i32) bool {
    return std.sort.asc(i32)(context, a, b);
}
