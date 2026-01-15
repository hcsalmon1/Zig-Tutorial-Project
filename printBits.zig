const std = @import("std");
const print = std.debug.print;



pub fn printU8(input:u8) void {

	const bitValues = [8]u8 {1,2,4,8,16,32,64,128};
	
	var message:[8]u8 = undefined;
	for (0..8) |i| {

		if ((input & bitValues[i]) != 0) {
			message[i] = '1';
			continue;
		}
		message[i] = '0';
	}
	const slice = message[0..];
	print("Variable: {}\n", .{input});
	print("{s}\n", .{slice});
}
pub fn printU32(input:u32) void {

	var checkValue:u32 = 1;
	
	var message:[32]u8 = undefined;
	for (0..32) |i| {

		if ((input & checkValue) != 0) {
			message[i] = '1';
			if (i != 31) {
				checkValue *= 2;
			}
			continue;
		}
		message[i] = '0';
		if (i != 31) {
			checkValue *= 2;
		}
	}
	const slice = message[0..];
	print("Variable: {}\n", .{input});
	print("{s}\n", .{slice});
}

pub fn printF32(input:f32) !void {
	var checkValue:f32 = 1;
	
	const stdout = std.io.getStdOut().writer();
	var message:[32]u8 = undefined;
	for (0..32) |i| {

		if ((input & checkValue) != 0) {
			message[i] = '1';
			if (i != 31) {
				checkValue *= 2;
			}
			continue;
		}
		message[i] = '0';
		if (i != 31) {
			checkValue *= 2;
		}
	}
	const slice = message[0..];
	try stdout.print("Variable: {}\n", .{input});
	try stdout.print("{s}\n", .{slice});
}