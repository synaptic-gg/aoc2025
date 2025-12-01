const std = @import("std");
const day1 = @import("aocday1.zig");

pub fn main() !void {
    try day1.part1();
    try day1.part2();
    // const raw = @embedFile("inputs/1.txt");
    // const trimmed = comptime std.mem.trim(u8, raw, " \n\r\t");
    // const len = comptime trimmed.len;
    // var arr: [len]u8 = undefined;
    // @memcpy(arr[0..], trimmed[0..]);
    // const value = parseInput(raw);
    //const value = parseInputTest(len, arr);
    // var stdout_buffer: [1024]u8 = undefined;
    // var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    // const stdout = &stdout_writer.interface;
    // try stdout.print("{}\n", .{value << 1});
    // try stdout.flush();
}
