const std = @import("std");

pub fn part1() !void {
    var start: i64 = 50;
    var count: i64 = 0;
    const raw: []const u8 = @embedFile("inputs/1.txt");
    for (raw, 0..) |value, i| {
        if (value == '\n' or (value != 'L' and value != 'R')) continue;
        const int = parseToint(raw[i + 1 ..]);
        if (value == 'L') {
            start -= int;
        } else if (value == 'R') {
            start += int;
        } else {
            continue;
        }
        const val = (@mod(start, 100));
        if (val == 0) {
            count += 1;
        }
    }
    std.debug.print("part 1 : {}\n", .{count});
}
fn parseToint(raw: []const u8) i64 {
    var i: i64 = 0;
    for (raw) |val| {
        if (val == '\n') break;
        const k: i64 = val - '0';
        i = i * 10 + k;
    }

    return i;
}
pub fn part2() !void {
    var start: i64 = 50;
    var count: i64 = 0;
    const raw: []const u8 = @embedFile("inputs/1.txt");
    for (raw, 0..) |value, i| {
        if (value == '\n' or (value != 'L' and value != 'R')) continue;
        const int = parseToint(raw[i + 1 ..]);
        const initil = start;
        if (value == 'L') {
            start -= int;
        } else if (value == 'R') {
            start += int;
        }
        const val = @mod(start, 100);

        if (val == 0) {
            count += 1;
        } else if (initil == 0) {} else if (value == 'R') {
            if (initil > val) {
                count += 1;
            }
        } else if (value == 'L') {
            if (initil < val) {
                count += 1;
            }
        }
        count += @divTrunc(int, 100);
        start = val;
    }
    std.debug.print("part 2 : {}\n", .{count});
}
