
const std = @import("std");
const print = std.debug.print;
const fmt = std.fmt;
const FixedBufferAllocator = std.heap.FixedBufferAllocator;
const Allocator = std.mem.Allocator;

pub fn run() void {
	//floatTypes();
	//convertingFloats();
	convertWeight();
}

fn floatTypes() void {
	print("Float Types:\n",.{});
	//The float types
	const decimal1:f16 = 1.1;
	const decimal2:f32 = 1.1111;
	const decimal3:f64 = 1.11111111;
	const decimal4:f80 = 1.1111111111;
	const decimal5:f128 = 1.111111111111;
	//These are fundamentally the same and only change the accuracy
	//The less bits the less accurate
	
	//If you print like this then you will get scientific format
	print("Printing scientific:\n",.{});
	print("   decimal1: {}\n", .{decimal1});
	print("   decimal2: {}\n", .{decimal2});	
	print("   decimal3: {}\n", .{decimal3});	
	print("   decimal4: {}\n", .{decimal4});	
	print("   decimal5: {}\n\n", .{decimal5});
	
	//If you want to print in decimal format then you use '{d}'
	print("Printing regular:\n",.{});
	print("   decimal1: {d}\n", .{decimal1});
	print("   decimal2: {d}\n", .{decimal2});	
	print("   decimal3: {d}\n", .{decimal3});	
	print("   decimal4: {d}\n", .{decimal4});	
	print("   decimal5: {d}\n", .{decimal5});
	
	//If you want to specify the amount of decimal places then you use '{d:.5}
	//This will show 5 decimal places
	print("\nChoosing decimal place count:\n",.{});
	print("   decimal2: {d}\n", .{decimal2});	
	print("   decimal2: {d:.2}\n", .{decimal2});	
}

fn convertingFloats() void {
	print("\nConverting floats:\n",.{});
	const number:i32 = 100;
	var decimal:f32 = number;
	const safer_conversion:f32 = @floatFromInt(number);
	
	print("   number: {}\n",.{number});
	print("   decimal: {d}\n",.{decimal});
	print("   safer_conversion: {d}\n",.{safer_conversion});
	
	decimal += 0.01;
	const converted_decimal:i32 = @intFromFloat(decimal);
	//You can't just convert directly to an int:
	//const error_conversion:i32 = decimal;
	//_ = error_conversion;

	print("   decimal: {d}\n",.{decimal});
	print("   converted_decimal: {}\n",.{converted_decimal});

	//To convert to a small float type we use '@floatCast'
	const decimal_f128:f128 = 1.123456789012345678;
	const decimal_f80:f80 = @floatCast(decimal_f128);
	const decimal_f64:f64 = @floatCast(decimal_f80);
	const decimal_f32:f32 = @floatCast(decimal_f64);
	const decimal_f16:f16 = @floatCast(decimal_f32);

	print("\n   decimal_f128: {d}\n",.{decimal_f128});
	print("   decimal_f80: {d}\n",.{decimal_f80});
	print("   decimal_f64: {d}\n",.{decimal_f64});
	print("   decimal_f32: {d}\n",.{decimal_f32});
	print("   decimal_f16: {d}\n",.{decimal_f16});	
}

fn convertWeight() void {
	print("\nConverting weight:\n",.{});
	
	//Here we will get input (number of pounds) from the user and parse it.
	//Then we will convert it to kilograms
	
	const KGS_IN_A_POUND:f64 = 0.453592;
	
	//Get the allocator and reader
	var buffer: [100]u8 = undefined; 
	var fba:FixedBufferAllocator = FixedBufferAllocator.init(&buffer);
	const fba_allocator:Allocator = fba.allocator();

	var stdin_reader = std.fs.File.stdin().reader(&buffer);
	const stdin = &stdin_reader.interface;

	//Get the input
	print("   What is your weight in pounds?\n   ", .{});
	const userInput:[]const u8 = stdin.takeDelimiterExclusive('\n') catch "invalid input\n"; 
	defer fba_allocator.free(userInput);
	
	//Trim the input
	const trimmedInput:[]const u8 = std.mem.trim(u8, userInput, " \t\r\n");
	
	//parse the input to a float
	const weight_pounds:f64 = fmt.parseFloat(f64, trimmedInput) catch |err| {
		print("   Error parsing float: {}\n", .{err});
		return;
	};
	
	const KILOGRAM_CONVERSION:f64 = weight_pounds * KGS_IN_A_POUND;
	
	print("   pounds {d:.2} = {d:.6} kgs\n", .{weight_pounds, KILOGRAM_CONVERSION});
	
}
