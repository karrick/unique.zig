// unique.zig
//
// (my first non-trivial (for me) Zig program)
//
// Reads from standard input, printing lines it has not yet seen. Limited to
// lines of 4096 bytes, until I get a chance to look into better way.

const std = @import("std");

pub fn main() !void {
    const stdin = std.io.bufferedInStream(std.io.getStdIn().inStream()).inStream();
    const stdout = std.io.getStdOut().outStream();

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = &arena.allocator;
    var map = std.hash_map.AutoHashMap(u64, bool).init(allocator);
    defer map.deinit();

    var line_buf: [4096]u8 = undefined;

    while (try stdin.readUntilDelimiterOrEof(&line_buf, '\n')) |line| {
        if (line.len == 0) break;

        const h = std.hash.Fnv1a_64.hash(line);
        if (!map.contains(h)) {
            try stdout.print("{}\n", .{line});
            _ = try map.put(h, true);
        }
    }
}
