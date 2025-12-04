pub fn solve(raw: []u8) i64 {
    var start: i64 = 50;
    var count: i64 = 0;
    // const raw: []const u8 = @embedFile("inputs/1.txt");
    for (raw, 0..) |value, i| {
        if (value == '\n' or (value != 'L' and value != 'R')) continue;
        const int = parseToint(raw[i + 1 ..]);
        const mult: i64 = if (value == 'L') -1 else 1;
        start += mult * int;
        const val = (@mod(start, 100));
        if (val == 0) {
            count += 1;
        }
    }
    //std.debug.print("part 1 : {}\n", .{count});
    return count;
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
