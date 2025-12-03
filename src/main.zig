const std = @import("std");
const day1 = @import("aocday1.zig");
const day2 = @import("aocday2.zig");
const day3 = @import("aocday3.zig");

pub fn main() !void {
    std.debug.print("day 1\n", .{});
    try day1.part1();
    try day1.part2();
    std.debug.print("day 2\n", .{});
    try day2.part1();
    try day2.part2();
    std.debug.print("day 3\n", .{});
    try day3.part1();
    try day3.part2();

    // var stdout_buffer: [1024]u8 = undefined;
    // var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    // const stdout = &stdout_writer.interface;
    // try stdout.print("{}\n", .{});
    // try stdout.flush();
}
