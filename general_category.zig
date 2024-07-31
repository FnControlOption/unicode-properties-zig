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

//! Query the general category property of a character.

const std = @import("std");
const testing = std.testing;

const tables = @import("tables.zig");
const util = @import("util.zig");

/// The most general classification of a character.
pub const GeneralCategory = enum {
    /// `Lu`, an uppercase letter
    uppercase_letter,
    /// `Ll`, a lowercase letter
    lowercase_letter,
    /// `Lt`, a digraphic character, with first part uppercase
    titlecase_letter,
    /// `Lm`, a modifier letter
    modifier_letter,
    /// `Lo`, other letters, including syllables and ideographs
    other_letter,
    /// `Mn`, a nonspacing combining mark (zero advance width)
    nonspacing_mark,
    /// `Mc`, a spacing combining mark (positive advance width)
    spacing_mark,
    /// `Me`, an enclosing combining mark
    enclosing_mark,
    /// `Nd`, a decimal digit
    decimal_number,
    /// `Nl`, a letterlike numeric character
    letter_number,
    /// `No`, a numeric character of other type
    other_number,
    /// `Pc`, a connecting punctuation mark, like a tie
    connector_punctuation,
    /// `Pd`, a dash or hyphen punctuation mark
    dash_punctuation,
    /// `Ps`, an opening punctuation mark (of a pair)
    open_punctuation,
    /// `Pe`, a closing punctuation mark (of a pair)
    close_punctuation,
    /// `Pi`, an initial quotation mark
    initial_punctuation,
    /// `Pf`, a final quotation mark
    final_punctuation,
    /// `Po`, a punctuation mark of other type
    other_punctuation,
    /// `Sm`, a symbol of mathematical use
    math_symbol,
    /// `Sc`, a currency sign
    currency_symbol,
    /// `Sk`, a non-letterlike modifier symbol
    modifier_symbol,
    /// `So`, a symbol of other type
    other_symbol,
    /// `Zs`, a space character (of various non-zero widths)
    space_separator,
    /// `Zl`, U+2028 LINE SEPARATOR only
    line_separator,
    /// `Zp`, U+2029 PARAGRAPH SEPARATOR only
    paragraph_separator,
    /// `Cc`, a C0 or C1 control code
    control,
    /// `Cf`, a format control character
    format,
    /// `Cs`, a surrogate code point
    surrogate,
    /// `Co`, a private-use character
    private_use,
    /// `Cn`, a reserved unassigned code point or a noncharacter
    unassigned,

    inline fn from(c: u21) GeneralCategory {
        return util.bsearch_range_value_table(GeneralCategory, c, tables.general_category) orelse .unassigned;
    }

    inline fn isLetterCased(gc: GeneralCategory) bool {
        return switch (gc) {
            .uppercase_letter, .lowercase_letter, .titlecase_letter => true,
            else => false,
        };
    }

    inline fn group(gc: GeneralCategory) GeneralCategoryGroup {
        return switch (gc) {
            .uppercase_letter,
            .lowercase_letter,
            .titlecase_letter,
            .modifier_letter,
            .other_letter,
            => .letter,
            .nonspacing_mark,
            .spacing_mark,
            .enclosing_mark,
            => .mark,
            .decimal_number,
            .letter_number,
            .other_number,
            => .number,
            .connector_punctuation,
            .dash_punctuation,
            .open_punctuation,
            .close_punctuation,
            .initial_punctuation,
            .final_punctuation,
            .other_punctuation,
            => .punctuation,
            .math_symbol,
            .currency_symbol,
            .modifier_symbol,
            .other_symbol,
            => .symbol,
            .space_separator,
            .line_separator,
            .paragraph_separator,
            => .separator,
            .control,
            .format,
            .surrogate,
            .private_use,
            .unassigned,
            => .other,
        };
    }
};

/// Groupings of the most general classification of a character.
pub const GeneralCategoryGroup = enum {
    /// Lu | Ll | Lt | Lm | Lo
    letter,
    /// Mn | Mc | Me
    mark,
    /// Nd | Nl | No
    number,
    /// Pc | Pd | Ps | Pe | Pi | Pf | Po
    punctuation,
    /// Sm | Sc | Sk | So
    symbol,
    /// Zs | Zl | Zp
    separator,
    /// Cc | Cf | Cs | Co | Cn
    other,
};

/// Queries the most general classification of a character.
pub fn generalCategory(c: u21) GeneralCategory {
    return GeneralCategory.from(c);
}

test GeneralCategory {
    try testing.expectEqual(.uppercase_letter, generalCategory('A'));
    try testing.expectEqual(.space_separator, generalCategory(' '));
    try testing.expectEqual(.other_letter, generalCategory('一'));
    try testing.expectEqual(.other_symbol, generalCategory('🦀'));
}

/// Queries the grouping of the most general classification of a character.
pub fn generalCategoryGroup(c: u21) GeneralCategoryGroup {
    return GeneralCategory.from(c).group();
}

test GeneralCategoryGroup {
    try testing.expectEqual(.letter, generalCategoryGroup('A'));
    try testing.expectEqual(.separator, generalCategoryGroup(' '));
    try testing.expectEqual(.letter, generalCategoryGroup('一'));
    try testing.expectEqual(.symbol, generalCategoryGroup('🦀'));
}

/// Queries whether the most general classification of a character belongs to the `LetterCased` group
///
/// The `LetterCased` group includes `LetterUppercase`, `LetterLowercase`, and `LetterTitlecase`
/// categories, and is a subset of the `Letter` group.
pub fn isLetterCased(c: u21) bool {
    return GeneralCategory.from(c).isLetterCased();
}

test isLetterCased {
    try testing.expect(isLetterCased('A'));
    try testing.expectEqual(false, isLetterCased(' '));
    try testing.expectEqual(false, isLetterCased('一'));
    try testing.expectEqual(false, isLetterCased('🦀'));
}
