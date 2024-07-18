// Based on https://github.com/unicode-rs/unicode-properties
//
// Copyright 2012-2015 The Rust Project Developers. See <COPYRIGHT-RUST>
// or <https://github.com/rust-lang/rust/blob/master/COPYRIGHT>.
//
// Licensed under the Apache License, Version 2.0 <LICENSE-APACHE> or
// <http://www.apache.org/licenses/LICENSE-2.0> or the MIT license
// <LICENSE-MIT> or <http://opensource.org/licenses/MIT>, at your
// option. This file may not be copied, modified, or distributed
// except according to those terms.

//! Query character Unicode properties according to
//! [Unicode Standard Annex #44](https://www.unicode.org/reports/tr44/)
//! and [Unicode Technical Standard #51](https://www.unicode.org/reports/tr51/)
//! rules.
//!
//! Currently we support the `General_Category` property as well as `Emoji` and `Emoji_Component`.
//!
//! Future properties can be added as requested.
//!
//! ```zig
//! const std = @import("std");
//! const debug = std.debug;
//! const unicode = std.unicode;
//!
//! const unicode_properties = @import("unicode_properties");
//! const EmojiStatus = unicode_properties.EmojiStatus;
//! const GeneralCategory = unicode_properties.GeneralCategory;
//!
//! const ch = '⚡'; // U+26A1 HIGH VOLTAGE SIGN
//! const is_emoji = EmojiStatus.from(ch).isEmojiChar();
//! const group = GeneralCategory.from(ch).group();
//!
//! var buf: [4]u8 = undefined;
//! const len = try unicode.utf8Encode(ch, &buf);
//! debug.print("{s}({s})\n", .{ buf[0..len], @tagName(group) });
//! debug.print("The above char {s} for use as emoji char.\n", .{
//!     if (is_emoji) "is recommended" else "is not recommended",
//! });
//! ```
//!
//! # Features
//!
//! ## `general-category`
//!
//! Provides the most general classification of a character,
//! based on its primary characteristic.
//!
//! ## `emoji`
//!
//! Provides the emoji character properties of a character.
//!

const tables = @import("unicode_properties/tables.zig");
pub const UNICODE_VERSION = tables.UNICODE_VERSION;

pub const emoji = @import("unicode_properties/emoji.zig");
pub const EmojiStatus = emoji.EmojiStatus;

pub const general_category = @import("unicode_properties/general_category.zig");
pub const GeneralCategory = general_category.GeneralCategory;
pub const GeneralCategoryGroup = general_category.GeneralCategoryGroup;

test {
    _ = emoji;
    _ = general_category;
}
