const std = @import("std");
const day1 = @import("aocday1.zig");

pub fn main() !void {
    try day1.part1();
    try day1.part2();
    // var stdout_buffer: [1024]u8 = undefined;
    // var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    // const stdout = &stdout_writer.interface;
    // try stdout.print("{}\n", .{});
    // try stdout.flush();
}
