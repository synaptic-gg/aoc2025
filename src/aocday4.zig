const std = @import("std");

pub fn part1() usize {
    const raw: []const u8 = @embedFile("inputs/4.txt");
    const line_len = get_line_len(raw);
    var total: usize = 0;
    for (raw, 0..) |value, i| {
        if (value == '\n' or value != '@') {
            continue;
        }
        var found: usize = 0;
        const in_matrix = [2]usize{ i - 1, i + 1 };
        for (in_matrix) |in| {
            check_bounds(raw, in, &found);
        }

        if (i > line_len) {
            const pre_matrix = [3]usize{ i - line_len - 1, i - line_len, i - line_len + 1 };
            for (pre_matrix) |in| {
                check_bounds(raw, in, &found);
            }
        }

        if (i < (raw.len - line_len)) {
            const post_matrix = [3]usize{ i + line_len - 1, i + line_len, i + line_len + 1 };
            for (post_matrix) |in| {
                check_bounds(raw, in, &found);
            }
        }
        if (found < 4) {
            total += 1;
        }
    }

    return total;
}
inline fn check_bounds(raw: []const u8, index: usize, val: *usize) void {
    if (raw.len > index and raw[index] == '@') {
        val.* += 1;
    }
}

const queue_len: usize = 1024 * 10;

inline fn get_line_len(raw: []const u8) usize {
    var len: usize = 0;
    for (raw) |value| {
        len += 1;
        if (value == '\n') break;
    }
    return len;
}
pub fn part2() usize {
    const rawc: []const u8 = @embedFile("inputs/4.txt");
    var buffer: [1024 * 64]u8 = undefined;
    @memcpy(buffer[0..rawc.len], rawc);
    var queue: [queue_len]usize = undefined;
    var qs_index: usize = 0;
    var qe_index: usize = 0;
    const raw = buffer[0..rawc.len];
    const line_len = get_line_len(raw);
    var total: usize = 0;
    for (raw, 0..) |ch, i| {
        if (ch != '@') {
            continue;
        }
        const value = check_neighbour(raw, i, line_len);
        if (value.len < 4) {
            total += 1;
            raw[i] = '.';
            for (value.found[0..value.len]) |el| {
                queue[qe_index % queue_len] = el;
                qe_index += 1;
            }
        }
    }
    while (qe_index > qs_index) {
        const i = queue[qs_index % queue_len];
        qs_index += 1;
        if (raw[i] != '@') continue;
        const value = check_neighbour(raw, i, line_len);
        if (value.len < 4) {
            total += 1;
            raw[i] = '.';
            for (value.found[0..value.len]) |el| {
                queue[qe_index % queue_len] = el;
                qe_index += 1;
            }
        }
    }

    return total;
}

inline fn check_neighbour(raw: []u8, i: usize, line_len: usize) struct { found: [8]usize, len: usize } {
    var found: [8]usize = undefined;
    var len: usize = 0;
    const in_matrix = [2]usize{ i - 1, i + 1 };
    for (in_matrix) |index| {
        if (raw.len > index and raw[index] == '@') {
            found[len] = index;
            len += 1;
        }
    }

    if (i > line_len) {
        const pre_matrix = [3]usize{ i - line_len - 1, i - line_len, i - line_len + 1 };
        for (pre_matrix) |index| {
            if (raw.len > index and raw[index] == '@') {
                found[len] = index;
                len += 1;
            }
        }
    }

    if (i < (raw.len - line_len)) {
        const post_matrix = [3]usize{ i + line_len - 1, i + line_len, i + line_len + 1 };
        for (post_matrix) |index| {
            if (raw.len > index and raw[index] == '@') {
                found[len] = index;
                len += 1;
            }
        }
    }
    return .{ .found = found, .len = len };
}
