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

//! Query the emoji character properties of a character.

const std = @import("std");
const testing = std.testing;

const tables = @import("tables.zig");
const util = @import("util.zig");

/// The emoji character properties of a character.
pub const EmojiStatus = enum(u4) {
    /// `Emoji=NO`, `Emoji_Component=NO`
    non_emoji,
    /// `Emoji=NO`, `Emoji_Component=YES`
    non_emoji_but_emoji_component,
    /// `Emoji=YES`, `Emoji_Component=NO`;`Emoji_Presentation=YES`
    emoji_presentation,
    /// `Emoji=YES`, `Emoji_Component=NO`;`Emoji_Modifier_Base=YES`
    emoji_modifier_base,
    /// `Emoji=YES`, `Emoji_Component=NO`;`Emoji_Presentation=YES`, `Emoji_Modifier_Base=YES`
    emoji_presentation_and_modifier_base,
    /// `Emoji=YES`, `Emoji_Component=NO`
    emoji_other,
    /// `Emoji=YES`, `Emoji_Component=YES`;`Emoji_Presentation=YES`
    emoji_presentation_and_emoji_component,
    /// `Emoji=YES`, `Emoji_Component=YES`;`Emoji_Presentation=YES`, `Emoji_Modifier=YES`
    emoji_presentation_and_modifier_and_emoji_component,
    /// `Emoji=YES`, `Emoji_Component=YES`
    emoji_other_and_emoji_component,
    _,

    inline fn from(c: u21) EmojiStatus {
        // FIXME: do we want to special case ASCII here?
        return util.bsearch_range_value_table(EmojiStatus, c, tables.emoji_status).?;
    }

    inline fn isEmojiCharOrEmojiComponent(s: EmojiStatus) bool {
        return s != .non_emoji;
    }

    inline fn isEmojiChar(s: EmojiStatus) bool {
        return s != .non_emoji and s != .non_emoji_but_emoji_component;
    }

    inline fn isEmojiComponent(s: EmojiStatus) bool {
        return switch (s) {
            .emoji_presentation_and_emoji_component,
            .emoji_presentation_and_modifier_and_emoji_component,
            .emoji_other_and_emoji_component,
            => true,
            else => false,
        };
    }
};

/// Returns the emoji character properties in a status enum.
pub fn emojiStatus(c: u21) EmojiStatus {
    return EmojiStatus.from(c);
}

test EmojiStatus {
    try testing.expectEqual(.emoji_presentation, emojiStatus('🦀'));
}

/// Checks whether this character is recommended for use as emoji, i.e. `Emoji=YES`.
pub fn isEmojiChar(c: u21) bool {
    return EmojiStatus.from(c).isEmojiChar();
}

test isEmojiChar {
    try testing.expect(isEmojiChar('🦀'));
}

/// Checks whether this character are used in emoji sequences where they're not
/// intended for independent, direct input, i.e. `Emoji_Component=YES`.
pub fn isEmojiComponent(c: u21) bool {
    return EmojiStatus.from(c).isEmojiComponent();
}

test isEmojiComponent {
    try testing.expectEqual(false, isEmojiComponent('🦀'));
}

/// Checks whether this character occurs in emoji sequences, i.e. `Emoji=YES | Emoji_Component=YES`
pub fn isEmojiCharOrEmojiComponent(c: u21) bool {
    return EmojiStatus.from(c).isEmojiCharOrEmojiComponent();
}

test isEmojiCharOrEmojiComponent {
    try testing.expect(isEmojiCharOrEmojiComponent('🦀'));
}

/// Checks whether this character is the U+200D ZERO WIDTH JOINER (ZWJ) character.
///
/// It can be used between the elements of a sequence of characters to indicate that
/// a single glyph should be presented if available.
pub inline fn isZwj(c: u21) bool {
    return c == '\u{200D}';
}

test isZwj {
    try testing.expect(isZwj('\u{200D}'));
    try testing.expectEqual(false, isZwj(0));
}

/// Checks whether this character is the U+FE0F VARIATION SELECTOR-16 (VS16) character, used to
/// request an emoji presentation for an emoji character.
pub inline fn isEmojiPresentationSelector(c: u21) bool {
    return c == '\u{FE0F}';
}

test isEmojiPresentationSelector {
    try testing.expect(isEmojiPresentationSelector('\u{FE0F}'));
    try testing.expectEqual(false, isEmojiPresentationSelector(0));
}

/// Checks whether this character is the U+FE0E VARIATION SELECTOR-15 (VS15) character, used to
/// request a text presentation for an emoji character.
pub inline fn isTextPresentationSelector(c: u21) bool {
    return c == '\u{FE0E}';
}

test isTextPresentationSelector {
    try testing.expect(isTextPresentationSelector('\u{FE0E}'));
    try testing.expectEqual(false, isTextPresentationSelector(0));
}

/// Checks whether this character is one of the Regional Indicator characters.
///
/// A pair of REGIONAL INDICATOR symbols is referred to as an emoji_flag_sequence.
pub inline fn isRegionalIndicator(c: u21) bool {
    return switch (c) {
        '\u{1F1E6}'...'\u{1F1FF}' => true,
        else => false,
    };
}

test isRegionalIndicator {
    try testing.expect(isRegionalIndicator('\u{1F1E6}'));
    try testing.expect(isRegionalIndicator('\u{1F1FF}'));
    try testing.expectEqual(false, isRegionalIndicator(0));
}

/// Checks whether this character is one of the Tag Characters.
///
/// These can be used in indicating variants or extensions of emoji characters.
pub inline fn isTagCharacter(c: u21) bool {
    return switch (c) {
        '\u{E0020}'...'\u{E007F}' => true,
        else => false,
    };
}

test isTagCharacter {
    try testing.expect(isTagCharacter('\u{E0020}'));
    try testing.expect(isTagCharacter('\u{E007F}'));
    try testing.expectEqual(false, isTagCharacter(0));
}

test "all ascii are either non_emoji or emoji_other" {
    var c: u21 = 0;
    while (c <= 255) : (c += 1) {
        const s = EmojiStatus.from(c);
        try testing.expect(switch (s) {
            .non_emoji,
            .emoji_other,
            .emoji_other_and_emoji_component,
            => true,
            else => false,
        });
    }
}
