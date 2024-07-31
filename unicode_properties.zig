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

const tables = @import("tables.zig");
pub const unicode_version = tables.unicode_version;
pub const emoji = @import("emoji.zig");
pub const general_category = @import("general_category.zig");

test {
    _ = emoji;
    _ = general_category;
}
