// unique.zig
// 
// (my first non-trivial (for me) Zig program)
//
// reads from standard input, printing lines it has not yet seen.

const std = @import("std");
const debug = std.debug;

pub fn main() !void {
    const stdout = try std.io.getStdOut();
    try stdout.write("hello world\n");

    var buffer = try std.Buffer.initSize(debug.global_allocator, 1024);

    var map = std.hash_map.AutoHashMap(u64, u2).init(debug.global_allocator);
    defer map.deinit();

    while (true) {
        var line = std.io.readLine(&buffer) catch |err| switch (err) {
            error.EndOfStream => return,
            else => |e| return e,
        };

        var h = std.hash.Fnv1a_64.hash(line);

        if (!map.contains(h)) {
            try stdout.write(line);
            try stdout.write("\n");
            _ = try map.put(h, 1);
        }
    }
}
