const std = @import("std");

pub fn read_input_file(file_name: []const u8, allocator: std.mem.Allocator) ![]const u8 {
    const file = try std.fs.cwd().openFile(
        file_name,
        .{},
    );
    defer file.close();

    const end_pos = try file.getEndPos();
    const f_len = @as(usize, end_pos);

    const contents = try file.reader().readAllAlloc(allocator, f_len);

    return contents;
}
