const std = @import("std");
const expect = std.testing.expect;
const trailx = @import("trailx.zig").trailx;

test "hello world" {
    try expect(std.mem.eql(u8, trailx("hello world   "), "hello world"));
}

test "obi wan" {
    try expect(std.mem.eql(u8, trailx("hello, there   "), "hello, there"));
}

test "lotr" {
    try expect(std.mem.eql(u8, trailx("The world is changed. I feel it in the water. I feel it in the earth. I smell it in the air.                 "), "The world is changed. I feel it in the water. I feel it in the earth. I smell it in the air."));
}
