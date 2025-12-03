const std = @import("std");

pub fn part1() usize {
    const raw: []const u8 = @embedFile("inputs/2.txt");
    const max = raw.len;
    var index: usize = 0;
    var sum: usize = 0;
    while (index < max) {
        const vals = parseInputs(raw[index..]);
        index += vals.next + 1;
        sum += get_sum(vals.prefix, vals.sufix);
    }
    // std.debug.print("part1 {} \n", .{sum});
    return sum;
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
fn get_sum(pre: usize, suf: usize) usize {
    const len_sufix: usize = std.math.log10(suf) + 1;
    const len_prefix: usize = std.math.log10(pre) + 1;
    if (len_prefix < len_sufix) {
        const split = std.math.pow(u64, 10, len_prefix);
        return (get_sum(pre, split - 1) + get_sum(split, suf));
    }
    if (len_prefix < 2) {
        return 0;
    }
    const multiplyer = get_part1_divs(len_prefix);
    var sum: usize = 0;

    if (multiplyer == 0) {
        return 0;
    }
    var start = (pre / multiplyer);
    while (multiplyer * start <= suf) {
        const val = multiplyer * start;
        if (val >= pre) {
            sum += val;
        }
        start += 1;
    }
    return sum;
}
fn is_rep_op(val: usize) bool {
    const len: usize = std.math.log10(val) + 1;
    if (len % 2 != 0) {
        return false;
    }
    return val % get_part1_divs(len) == 0;
}
fn get_part1_divs(len: usize) usize {
    switch (len) {
        2 => return 11,
        4 => return 101,
        6 => return 1001,
        8 => return 10001,
        10 => return 100001,
        12 => return 1000001,
        14 => return 10000001,
        16 => return 100000001,
        18 => return 1000000001,
        else => {
            return 0;
        },
    }
    return 0;
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
pub fn part2() usize {
    const raw: []const u8 = @embedFile("inputs/2.txt");
    const max = raw.len;
    var index: usize = 0;
    var sum: usize = 0;
    while (index < max) {
        const vals = parseInputs(raw[index..]);
        index += vals.next + 1;
        sum += get_sum_part2(vals.prefix, vals.sufix);
    }
    // std.debug.print("part2 {} \n", .{sum});
    return sum;
}

fn get_sum_part2(pre: usize, suf: usize) usize {
    const len_sufix: usize = std.math.log10(suf) + 1;
    const len_prefix: usize = std.math.log10(pre) + 1;
    if (len_prefix < len_sufix) {
        const split = std.math.pow(u64, 10, len_prefix);
        return (get_sum_part2(pre, split - 1) + get_sum_part2(split, suf));
    }
    if (len_prefix < 2) {
        return 0;
    }
    const multiplyers = get_part2_divs(len_prefix);
    var sum: usize = 0;
    // var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    // const allocator = gpa.allocator();
    var buffer: [100000]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();
    var seen = std.hash_map.AutoHashMap(usize, usize).init(allocator);
    defer seen.deinit();
    for (multiplyers) |multiplyer| {
        if (multiplyer == 0) {
            continue;
        }
        var start = (pre / multiplyer);

        while (multiplyer * start <= suf) {
            const val = multiplyer * start;
            if (val >= pre and !seen.contains(val)) {
                //std.debug.print("{}\n", .{val});
                _ = seen.put(val, val) catch unreachable;
                sum += val;
            }
            start += 1;
        }
    }
    return sum;
}
fn get_part2_divs(len: usize) [2]usize {
    switch (len) {
        2 => return [2]usize{ 11, 0 },
        3 => return [2]usize{ 111, 0 },
        4 => return [2]usize{ 101, 0 },
        5 => return [2]usize{ 11111, 0 },
        6 => return [2]usize{ 1001, 10101 },
        7 => return [2]usize{ 1111111, 0 },
        8 => return [2]usize{ 10001, 1010101 },
        10 => return [2]usize{ 100001, 101010101 },
        12 => return [2]usize{ 1000001, 10101010101 },
        14 => return [2]usize{ 10000001, 101010101010101 },
        16 => return [2]usize{ 100000001, 10101010101010101 },
        18 => return [2]usize{ 1000000001, 1010101010101010101 },
        9 => return [2]usize{ 111111111, 1001001 },
        11 => return [2]usize{ 11111111111, 0 },
        13 => return [2]usize{ 1111111111111, 0 },
        15 => return [2]usize{ 111111111111111, 0 },
        17 => return [2]usize{ 11111111111111111, 0 },
        19 => return [2]usize{ 1111111111111111111, 0 },
        else => {
            return [2]usize{ 0, 0 };
        },
    }
    return 0;
}
