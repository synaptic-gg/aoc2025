const std = @import("std");

pub fn part1() usize {
    const raw: []const u8 = @embedFile("inputs/3.txt");
    const max = raw.len;
    var index: usize = 0;
    var sum: usize = 0;
    while (index < max) {
        const vals = get_line_min_max(raw[index..]);
        index += vals.next + 1;
        sum += vals.max1 * 10 + vals.max2;
    }
    // std.debug.print("part1 {} \n", .{sum});
    return sum;
}
fn get_line_min_max(raw: []const u8) struct { max1: usize, max2: usize, next: usize } {
    var max1: usize = 0;
    var max2: usize = 0;
    var next: usize = 0;
    var max1_in: usize = 0;
    for (raw, 0..) |value, i| {
        if (value == ' ' or value == '\n') break;
        next += 1;
        const k: usize = value - '0';
        if (max1 < k) {
            if (i + 1 < raw.len and raw[i + 1] != '\n') {
                max1 = k;
                max1_in = i;
                const k2: usize = raw[i + 1] - '0';
                max2 = k2;
                continue;
            }
        }
        if (max2 < k) {
            max2 = k;
        }
    }
    return .{ .next = next, .max1 = max1, .max2 = max2 };
}
pub fn part2() usize {
    const raw: []const u8 = @embedFile("inputs/3.txt");
    var it = std.mem.splitScalar(u8, raw, '\n');
    var sum: usize = 0;
    while (it.next()) |line| {
        sum += get_jolten(line);
    }
    //std.debug.print("part 2 {}\n", .{sum});
    return sum;
}

fn get_jolten(line: []const u8) usize {
    const size: usize = 11;
    var sum: usize = 0;
    var index: usize = 0;
    if (line.len < 12) {
        return 0;
    }
    for (0..size + 1) |si| {
        var cur_i = index;
        const k = line.len - (size - si);

        for (index..k) |i| {
            if (line[i] > line[cur_i]) {
                cur_i = i;
            }
        }
        sum *= 10;
        sum += (line[cur_i] - '0');

        index = cur_i + 1;
    }
    return sum;
}
