const std = @import("std");
const day1 = @import("aocday1.zig");
const day2 = @import("aocday2.zig");
const day3 = @import("aocday3.zig");
const day4 = @import("aocday4.zig");
const day5 = @import("aocday5.zig");

pub fn main() !void {
    try runTimed("day1 part 1", day1.part1);
    try runTimed("day1 part 2", day1.part2);
    try runTimed("day2 part 1", day2.part1);
    try runTimed("day2 part 2", day2.part2);
    try runTimed("day3 part 1", day3.part1);
    try runTimed("day3 part 2", day3.part2);
    try runTimed("day4 part 1", day4.part1);
    try runTimed("day4 part 2", day4.part2);
    try runTimed("day5 part 1", day5.part1);
    try runTimed("day5 part 2", day5.part2);
}

fn runTimed(comptime label: []const u8, func: anytype) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    const stdout = &stdout_writer.interface;

    const start = std.time.Instant.now() catch unreachable;

    const result = func();

    const end = std.time.Instant.now() catch unreachable;

    const elapsed_ns = end.since(start);

    try stdout.print("{s}: result = {any}, time = {d}µs\n", .{ label, result, elapsed_ns / 1_000 });
    try stdout.flush();
}
