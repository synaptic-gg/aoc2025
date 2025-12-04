const std = @import("std");
const ans = @import("ans.zig");
pub fn main() !void {
    var args = std.process.args();
    _ = args.next();
    const fun_fn = ans.solve;
    const Context = struct { day: usize, part: usize };
    const day_str = args.next().?;
    const part_str = args.next().?;
    const context: Context = Context{
        .day = try std.fmt.parseInt(usize, day_str, 10),
        .part = try std.fmt.parseInt(usize, part_str, 10),
    };

    const allocator = std.heap.page_allocator;
    var stdout_buffer: [1024 * 8]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    const stdout = &stdout_writer.interface;
    defer stdout.flush() catch unreachable;

    const file_path_input = try std.fmt.allocPrint(allocator, "/Users/yash/projects/aoc2025/src/inputs/{}.txt", .{context.day});
    const file_path_output = try std.fmt.allocPrint(allocator, "/Users/yash/projects/aoc2025/src/part{}_outputs/{}.txt", .{ context.part, context.day });
    //try stdout.print("{s} {s}\n", .{ file_path_input, file_path_output });
    const file_input = try std.fs.openFileAbsolute(file_path_input, .{ .mode = .read_only });
    const file_output = try std.fs.openFileAbsolute(file_path_output, .{ .mode = .read_only });

    var file_buffer: [1024 * 1024]u8 = undefined;
    const content = try file_input.read(&file_buffer);
    const content_out = try file_output.read(file_buffer[content..]);
    const input = file_buffer[0..content];
    const output = file_buffer[content .. content_out + content];
    file_input.close();
    file_output.close();
    const start = std.time.Instant.now() catch unreachable;
    const result = fun_fn(input);
    const end = std.time.Instant.now() catch unreachable;
    const elapsed_ns = end.since(start);
    const result_as_string = try std.fmt.allocPrint(allocator, "{}", .{result});
    const output_trimed = std.mem.trim(u8, output, " \n");

    const expected = std.mem.eql(u8, output_trimed, result_as_string);
    if (!expected) {
        const out = .{ .correct = expected, .msg = result_as_string };
        const fmt = std.json.fmt(out, .{ .whitespace = .indent_2 });
        var writer = std.Io.Writer.Allocating.init(allocator);
        try fmt.format(&writer.writer);
        defer writer.deinit();
        const json = try writer.toOwnedSlice();
        try stdout.print("{s}\n", .{json});
        return;
    }
    //std.debug.print("sucess = {}, time = {d}µs\n", .{ std.mem.eql(u8, output_trimed, result_as_string), elapsed_ns / 1_000 });
    const MAX_TIME: usize = 2_500_000_000;
    const samples = MAX_TIME / elapsed_ns;
    var results: []u64 = try std.heap.page_allocator.alloc(u64, samples);
    defer std.heap.page_allocator.free(results);

    var timer = try std.time.Timer.start();
    var i: usize = 0;
    while (i < samples) : (i += 1) {
        _ = std.mem.doNotOptimizeAway(timer.lap());
        const result_in = fun_fn(input);
        const elapsed = timer.lap();
        results[i] = elapsed;
        const result_as_string_in = try std.fmt.allocPrint(allocator, "{}", .{result_in});
        const expected_inner = std.mem.eql(u8, output_trimed, result_as_string_in);
        if (!expected_inner) {
            @panic("expected failed in inner block");
        }
    }

    std.mem.sort(u64, results, {}, std.sort.asc(u64));
    const out = .{ .correct = expected, .min = results[0], .max = results[samples - 1], .median = results[samples / 2], .cycles = samples };
    const fmt = std.json.fmt(out, .{ .whitespace = .indent_2 });
    var writer = std.Io.Writer.Allocating.init(allocator);
    try fmt.format(&writer.writer);
    defer writer.deinit();
    const json = try writer.toOwnedSlice();
    try stdout.print("{s}\n", .{json});
    return;
}
