const std = @import("std");
const fmt = std.fmt;

/// trailx takes in a string and returns
/// the same string stripped of trailing spaces
pub fn trailx(in: []const u8) []const u8 {
    if (in.len == 0) {
        return in;
    }

    var last = in.len - 1;
    var final_len = in.len;

    while (in[last] == ' ') : (last -= 1) {
        final_len -= 1;
    }

    return in[0..final_len];
}

pub fn main() !void {
    // get the cli args
    var general_purpose_allocator = std.heap.GeneralPurposeAllocator(.{}){};
    const gpa = general_purpose_allocator.allocator();
    const args = try std.process.argsAlloc(gpa);
    defer std.process.argsFree(gpa, args);

    // get the current directory
    const cur_dir = std.fs.cwd();

    if (args.len == 1) {
        std.debug.print("trailx trims trailing spaces from files in-place\nusage: {s} <filename(s)>\n", .{args[0]});
    }

    // iterate over files
    for (args[1..]) |f| {
        var file = try cur_dir.openFile(f, .{});
        defer file.close();

        // create a tmp file to write to
        var tmp_name_buf: [100]u8 = undefined;
        const tmp_name = try fmt.bufPrint(tmp_name_buf[0..], "{s}.tmp", .{f});
        const tmp = try std.fs.cwd().createFile(
            tmp_name[0..],
            .{},
        );

        // open the input file
        var buf_reader = std.io.bufferedReader(file.reader());
        var in_stream = buf_reader.reader();

        // read the file line by line
        var buf: [1024]u8 = undefined;
        while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
            // trailx the line and write it to the tmp file
            try tmp.writeAll(trailx(line));
            try tmp.writeAll("\n");
        }

        // close the file
        tmp.close();

        // mv the tmp to the filename
        try cur_dir.rename(tmp_name, f);
    }
}
