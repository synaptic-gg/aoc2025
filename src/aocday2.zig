const std = @import("std");

pub fn part1() !void {
    const raw: []const u8 = @embedFile("inputs/2.txt");
    const max = raw.len;
    var index: usize = 0;
    var sum: usize = 0;
    while (index < max) {
        const vals = parseInputs(raw[index..]);
        index += vals.next + 1;
        var pre = vals.prefix;
        while (pre <= vals.sufix) {
            if (isRep(pre)) {
                sum += pre;
            }

            pre += 1;
        }
    }
    std.debug.print("part1 {} \n", .{sum});
}
fn isRep(val: usize) bool {
    const len: usize = std.math.log10(val) + 1;
    const mid = @divTrunc(len, 2);
    if (len % 2 != 0) {
        return false;
    }
    const pow = std.math.pow(usize, 10, mid);
    const second_part = val % pow;
    const first_part = @divTrunc(val, pow);
    if (first_part == second_part) {
        return true;
    }
    return false;
}

fn parseInputs(raw: []const u8) struct { prefix: usize, sufix: usize, next: usize } {
    var pre: usize = 0;
    var suf: usize = 0;
    var next: usize = 0;
    var is_pre = true;
    for (raw) |value| {
        if (value == ',' or value == '\n') break;
        next += 1;
        if (value == '-') {
            is_pre = false;
            continue;
        }
        const k: usize = value - '0';
        if (is_pre) {
            pre = pre * 10 + k;
        } else {
            suf = suf * 10 + k;
        }
    }
    return .{ .prefix = pre, .sufix = suf, .next = next };
}

fn isRep2(val: usize) bool {
    var tmp = val;
    var digits: [20]u4 = undefined;
    var len: usize = 0;

    while (tmp > 0) : (tmp /= 10) {
        digits[len] = @intCast(tmp % 10);
        len += 1;
    }
    for (0..len / 2) |i| {
        const j = len - 1 - i;
        const t = digits[i];
        digits[i] = digits[j];
        digits[j] = t;
    }

    for (1..len) |d| {
        if (len % d != 0) continue;
        var done = true;
        for (d..len) |i| {
            if (digits[i] != digits[i % d]) {
                done = false;
                break;
            }
        }
        if (done) return true;
    }

    return false;
}
pub fn part2() !void {
    const raw: []const u8 = @embedFile("inputs/2.txt");
    const max = raw.len;
    var index: usize = 0;
    var sum: usize = 0;
    while (index < max) {
        const vals = parseInputs(raw[index..]);
        index += vals.next + 1;
        var pre = vals.prefix;

        while (pre <= vals.sufix) {
            if (isRep2(pre)) {
                sum += pre;
            }

            pre += 1;
        }
    }
    std.debug.print("part2 {} \n", .{sum});
}
