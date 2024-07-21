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

const std = @import("std");

pub fn RangeWithValue(comptime T: type) type {
    return struct { u21, u21, T };
}

pub fn bsearch_range_value_table(comptime T: type, c: u21, r: []const RangeWithValue(T)) ?T {
    const compare = struct {
        fn func(_: void, key: u21, mid_item: RangeWithValue(T)) std.math.Order {
            const lo, const hi, _ = mid_item;
            return if (lo <= key and key <= hi)
                .eq
            else if (hi < key)
                .gt
            else
                .lt;
        }
    };
    const idx = std.sort.binarySearch(RangeWithValue(T), c, r, {}, compare.func) orelse
        return null;
    _, _, const cat = r[idx];
    return cat;
}
