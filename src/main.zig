const std = @import("std");

const ma_engine = opaque {};
const MA_SUCCESS = 0;

pub extern fn ma_engine_init(pConfig: ?*anyopaque, pEngine: *ma_engine) c_int;
pub extern fn ma_engine_uninit(pEngine: *ma_engine) void;
pub extern fn ma_engine_play_sound(pEngine: *ma_engine, pFilePath: [*c]const u8, pGroup: ?*anyopaque) c_int;

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator(); 

    const engine_bytes = try allocator.alloc(u8, 4096); 
    const engine = @as(*ma_engine, @ptrCast(engine_bytes.ptr));

    if (ma_engine_init(null, engine) != MA_SUCCESS) {
        try stdout.print("failed to initialize audio engine!\n", .{});
        return;
    }
    defer ma_engine_uninit(engine);

    if (ma_engine_play_sound(engine, "bad_apple.mp3", null) != MA_SUCCESS) {
        try stdout.print("failed to load bad_apple.mp3!\n", .{});
        return;
    }

    var timer = try std.time.Timer.start();
    const file = std.fs.cwd().openFile("bad_apple_all.txt", .{}) catch {
        try stdout.print("failed to open bad_apple_all.txt!\n", .{}); 
        return;
    };
    defer file.close();

    const buffer = try file.readToEndAlloc(allocator, 100 * 1024 * 1024);
    var frame_iterator = std.mem.splitSequence(u8, buffer, "SPLIT");

    const ms_per_frame: f64 = 66.66;
    var current_frame_index: u32 = 0;

    while (frame_iterator.next()) |raw_frame| {
        const frame = std.mem.trim(u8, raw_frame, "\r\n");
        if (frame.len == 0) continue;

        current_frame_index += 1;
        const ideal_time_ms = @as(f64, @floatFromInt(current_frame_index)) * ms_per_frame;
        const elapsed_ms = @as(f64, @floatFromInt(timer.read())) / @as(f64, @floatFromInt(std.time.ns_per_ms));

        if (elapsed_ms < ideal_time_ms) {
            const delay_ms = ideal_time_ms - elapsed_ms;
            std.time.sleep(@intFromFloat(delay_ms * @as(f64, std.time.ns_per_ms)));
        } 

        try stdout.print("\x1B[2J\x1B[H", .{});
        try stdout.print("{s}\n", .{frame});
        try stdout.print("--------------------------------------------------\n", .{});
        try stdout.print("zig bad apple, Frame: {d}, delta timing: {d} ms\n", .{ current_frame_index, @as(i32, @intFromFloat(elapsed_ms - ideal_time_ms)) });
    }
    try stdout.print("\npulang pulang dh selesai\n", .{});
}
