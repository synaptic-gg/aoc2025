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
            check_boounds(raw, in, &found);
        }

        if (i > line_len) {
            const pre_matrix = [3]usize{ i - line_len - 1, i - line_len, i - line_len + 1 };
            for (pre_matrix) |in| {
                check_boounds(raw, in, &found);
            }
        }

        if (i < (raw.len - line_len)) {
            const post_matrix = [3]usize{ i + line_len - 1, i + line_len, i + line_len + 1 };
            for (post_matrix) |in| {
                check_boounds(raw, in, &found);
            }
        }
        if (found < 4) {
            total += 1;
        }
    }

    return total;
}
inline fn check_boounds(raw: []const u8, index: usize, val: *usize) void {
    if (raw.len > index and index > 0 and raw[index] == '@') {
        val.* += 1;
    }
}
fn get_line_len(raw: []const u8) usize {
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

    const raw = buffer[0..rawc.len];
    const line_len = get_line_len(raw);
    var total_out: usize = 0;
    inline for (0..12) |_| {
        var total: usize = 0;
        for (0..raw.len) |i| {
            if (raw[i] == '@') {
                var found: usize = 0;
                const in_matrix = [2]usize{ i - 1, i + 1 };
                for (in_matrix) |in| {
                    check_boounds(raw, in, &found);
                }

                if (i > line_len) {
                    const pre_matrix = [3]usize{ i - line_len - 1, i - line_len, i - line_len + 1 };
                    for (pre_matrix) |in| {
                        check_boounds(raw, in, &found);
                    }
                }

                if (i < (raw.len - line_len)) {
                    const post_matrix = [3]usize{ i + line_len - 1, i + line_len, i + line_len + 1 };
                    for (post_matrix) |in| {
                        check_boounds(raw, in, &found);
                    }
                }
                if (found < 4) {
                    total += 1;
                    raw[i] = 'x';
                }
            }
            const i_b = raw.len - i - 1;
            if (raw[i_b] == '@') {
                var found: usize = 0;
                const in_matrix = [2]usize{ i_b - 1, i_b + 1 };
                for (in_matrix) |in| {
                    check_boounds(raw, in, &found);
                }

                if (i_b > line_len) {
                    const pre_matrix = [3]usize{ i_b - line_len - 1, i_b - line_len, i_b - line_len + 1 };
                    for (pre_matrix) |in| {
                        check_boounds(raw, in, &found);
                    }
                }

                if (i_b < (raw.len - line_len)) {
                    const post_matrix = [3]usize{ i_b + line_len - 1, i_b + line_len, i_b + line_len + 1 };
                    for (post_matrix) |in| {
                        check_boounds(raw, in, &found);
                    }
                }
                if (found < 4) {
                    total += 1;
                    raw[i_b] = 'x';
                }
            }
        }
        total_out += total;
        if (total == 1 or total == 0) {
            break;
        }
    }
    return total_out;
}
