# unique.zig

unique reads from standard input, printing lines it has not yet seen

## Example

```Bash
zig build && printf "line 1\nline 2\nline 1\nline 3\n" | ./zig-out/bin/unique
```
