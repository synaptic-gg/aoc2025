const std = @import("std");

const Range = struct { min: usize, max: usize };
pub fn part1() usize {
    const raw: []const u8 = @embedFile("inputs/5.txt");
    var lines = std.mem.splitScalar(u8, raw, '\n');
    var arr: [256]Range = undefined;
    var total: usize = 0;
    var index: usize = 0;
    while (lines.next()) |val| {
        if (val.len == 0) {
            break;
        }
        var min: usize = 0;
        var max: usize = 0;
        var is_min = true;
        for (val) |value| {
            if (value == '-') {
                is_min = false;
                continue;
            }

            const k: usize = value - '0';
            if (is_min) {
                min = min * 10 + k;
            } else {
                max = max * 10 + k;
            }
        }
        arr[index] = .{ .min = min, .max = max };
        index += 1;
    }
    std.mem.sort(Range, arr[0..index], {}, comptime sort_range);
    var end: usize = 0;
    var arr_merged: [256]Range = undefined;
    var index_m: usize = 0;

    for (arr[0..index]) |r| {
        if (end < r.min) {
            arr_merged[index_m] = r;
            index_m += 1;
        } else if (end >= r.max) {
            continue;
        } else {
            arr_merged[index_m - 1].max = r.max;
        }
        end = r.max;
    }

    while (lines.next()) |val| {
        var number: usize = 0;
        for (val) |value| {
            const k: usize = value - '0';
            number = number * 10 + k;
        }
        const bs_found = std.sort.binarySearch(Range, arr_merged[0..index_m], number, comptime struct {
            fn search(k: usize, r: Range) std.math.Order {
                if (k >= r.min and k <= r.max) {
                    return std.math.Order.eq;
                } else if (k < r.min) {
                    return std.math.Order.lt;
                } else {
                    return std.math.Order.gt;
                }
            }
        }.search);
        if (bs_found) |_| {
            total += 1;
        }
    }

    return total;
}

fn sort_range(_: void, a: Range, b: Range) bool {
    return a.min < b.min;
}

pub fn part2() usize {
    const raw: []const u8 = @embedFile("inputs/5.txt");
    var lines = std.mem.splitScalar(u8, raw, '\n');
    var arr: [128 * 2]Range = undefined;
    var total: usize = 0;
    var index: usize = 0;
    while (lines.next()) |val| {
        if (val.len == 0) {
            break;
        }
        var min: usize = 0;
        var max: usize = 0;
        var is_min = true;
        for (val) |value| {
            if (value == '-') {
                is_min = false;
                continue;
            }

            const k: usize = value - '0';
            if (is_min) {
                min = min * 10 + k;
            } else {
                max = max * 10 + k;
            }
        }
        arr[index] = .{ .max = max, .min = min };
        index += 1;
    }

    std.mem.sort(Range, arr[0..index], {}, comptime sort_range);
    var end: usize = 0;
    for (arr[0..index]) |r| {
        if (end < r.min) {
            total += r.max - r.min + 1;
        } else if (end >= r.max) {
            continue;
        } else {
            total += r.max - end;
        }
        end = r.max;
    }

    return total;
}
