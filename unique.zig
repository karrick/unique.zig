// unique.zig
// 
// (my first non-trivial (for me) Zig program)
//
// Reads from standard input, printing lines it has not yet seen. Limited to
// lines of 4096 bytes, until I get a chance to look into better way.

const std = @import("std");
const debug = std.debug;

pub fn main() !void {
    const stdout = try std.io.getStdOut();

    var arena = std.heap.ArenaAllocator.init(std.heap.direct_allocator);
    defer arena.deinit();

    const allocator = &arena.allocator;

    var buffer = try std.Buffer.initSize(allocator, 4096);

    var map = std.hash_map.AutoHashMap(u64, bool).init(allocator);
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
            _ = try map.put(h, true);
        }
    }
}
