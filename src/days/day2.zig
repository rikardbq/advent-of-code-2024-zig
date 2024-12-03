const std = @import("std");
const util = @import("../util/util.zig");

fn check_row_entries(input_levels: []const i32, desc: bool) !bool {
    var predicate = true;

    for (0.., input_levels) |i, entry| {
        if (i < input_levels.len - 1) {
            const next = input_levels[i + 1];
            const dir_check = if (desc) entry > next else entry < next;
            const diff = entry - next;
            const diff_abs = if (diff < 0) ~diff + 1 else diff;

            predicate = predicate and diff_abs > 0 and diff_abs < 4 and dir_check;
        }
    }

    return predicate;
}

pub fn part_one() !i32 {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const input = try util.read_input_file("assets/day2_input.txt", allocator);
    defer allocator.free(input);

    const inputs = try prepare_input(input, allocator);

    var count: i32 = 0;

    for (inputs) |levels| {
        const a = try check_row_entries(levels, false);
        const b = try check_row_entries(levels, true);

        if ((a or b) and levels.len > 0) {
            count += 1;
        }
    }

    return count;
}

pub fn part_two() !i32 {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const input = try util.read_input_file("assets/day2_input.txt", allocator);
    defer allocator.free(input);

    const inputs = try prepare_input(input, allocator);

    var count: i32 = 0;

    for (inputs) |levels| {
        for (0.., levels) |i, _| {
            var levels_arraylist = std.ArrayList(i32).init(allocator);
            try levels_arraylist.appendSlice(levels);
            _ = levels_arraylist.orderedRemove(i);

            const sub_list = try levels_arraylist.toOwnedSlice();

            const a = try check_row_entries(sub_list, false);
            const b = try check_row_entries(sub_list, true);

            if ((a or b) and levels.len > 0) {
                count += 1;
                break;
            }
        }
    }

    return count;
}

fn prepare_input(input: []const u8, allocator: std.mem.Allocator) ![]const []const i32 {
    var split_input = std.mem.splitSequence(u8, input, "\n");
    var res = std.ArrayList([]const i32).init(allocator);

    while (split_input.next()) |row| {
        var sub_split = std.mem.splitSequence(u8, row, " ");
        var levels = std.ArrayList(i32).init(allocator);

        while (sub_split.next()) |item| {
            if (item.len > 0) {
                const parsed_n = try std.fmt.parseInt(i32, item, 10);
                try levels.append(parsed_n);
            }
        }

        const levels_slice = try levels.toOwnedSlice();

        try res.append(levels_slice);
    }

    const res_slice = try res.toOwnedSlice();

    return res_slice;
}
