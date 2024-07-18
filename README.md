# unicode-properties-zig

![License: MIT/Apache-2.0](https://img.shields.io/crates/l/unicode-properties.svg)

Zig port of the [unicode-properties](https://github.com/unicode-rs/unicode-properties) Rust crate

```zig
const std = @import("std");
const debug = std.debug;
const unicode = std.unicode;

const unicode_properties = @import("unicode_properties");
const EmojiStatus = unicode_properties.EmojiStatus;
const GeneralCategory = unicode_properties.GeneralCategory;

const ch = '⚡'; // U+26A1 HIGH VOLTAGE SIGN
const is_emoji = EmojiStatus.from(ch).isEmojiChar();
const group = GeneralCategory.from(ch).group();

var buf: [4]u8 = undefined;
const len = try unicode.utf8Encode(ch, &buf);
debug.print("{s}({s})\n", .{ buf[0..len], @tagName(group) });
debug.print("The above char {s} for use as emoji char.\n", .{
    if (is_emoji) "is recommended" else "is not recommended",
});
```
