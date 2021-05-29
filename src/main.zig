// unique.zig
//
// (my first non-trivial (for me) Zig program)
//
// Reads from standard input, printing lines to standard output that it has not
// yet seen.

const std = @import("std");
const math = std.math;

pub fn main() anyerror!void {
    const stdin = std.io.bufferedReader(std.io.getStdIn().reader()).reader();
    const stdout = std.io.getStdOut().writer();
    const stderr = std.io.getStdErr().writer();

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = &arena.allocator;
    var map = std.hash_map.AutoHashMap(u64, bool).init(allocator);
    defer map.deinit();

    while (true) {
        const eline = stdin.readUntilDelimiterAlloc(allocator, '\n', math.maxInt(usize));
        if (eline) |line| {
            const h = std.hash.Fnv1a_64.hash(line);
            if (!map.contains(h)) {
                try stdout.print("{s}\n", .{line});
                try map.put(h, true);
            }
        } else |err| {
            if (err != error.EndOfStream) {
                try stderr.print("{s}\n", .{err});
            }
            break;
        }
    }
}
