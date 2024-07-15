
const std = @import("std");
const print = std.debug.print;
const fmt = std.fmt;

pub fn run() void
{
	//floatTypes();
	
	//printFloats();
	
	convertWeight();
}

fn floatTypes() void
{
	print("Float Types:\n",.{});
	//The float types
	const decimal1:f16 = 1.1;
	const decimal2:f32 = 1.1111;
	const decimal3:f64 = 1.11111111;
	const decimal4:f80 = 1.1111111111;
	const decimal5:f128 = 1.111111111111;
	//These are fundamentally the same and only change the accuracy
	//The less bits the less accurate
	
	print("   decimal1: {}\n", .{decimal1});
	print("   decimal2: {}\n", .{decimal2});	
	print("   decimal3: {}\n", .{decimal3});	
	print("   decimal4: {}\n", .{decimal4});	
	print("   decimal5: {}\n", .{decimal5});
		
}

fn printFloats() void
{
	//By default floats are printed in scientific notation
	//So you will have an 'e0' at the end.
	
	const decimal1:f64 = 1.111111;
	
	//To print them in decimal form we will call 'format' from 'std.fmt'.
	//At the top we import 'fmt' as 'std.fmt'
	
	print("   Printing float in decimal format:\n", .{});
	print("   ", .{}); //for spaces
	
	printFloat6digits(decimal1); //we make a function to make it easier
	
}

fn printFloat6digits(input:f64) void
{
	const stdout = std.io.getStdOut().writer(); //we need to send a writer to the function
	
	fmt.format
	(
		stdout, //the writer
		"{d:.6}", //the format of float
		.{input} //the variable to show
	) catch unreachable;
	print("\n",.{});
	//This will print a float in decimal format
}


fn convertWeight() void
{
	//Here we will get input (number of pounds) from the user and parse it.
	//Then we will convert it to kilograms
	
	const KGS_IN_A_POUND:f64 = 0.453592;
	const stdout = std.io.getStdOut().writer();
	const stdin = std.io.getStdIn().reader();
	
	//Get the allocator and reader
	var buffer: [100]u8 = undefined; 
	var fba = std.heap.FixedBufferAllocator.init(&buffer);
	const fba_allocator = fba.allocator();

	//Get the input
	print("   What is your weight in pounds?\n   ", .{});
	const userInput = stdin.readUntilDelimiterAlloc(fba_allocator, '\n', 100,) catch "invalid input\n"; 
	defer fba_allocator.free(userInput);
	
	//Trim the input
	const trimmedInput = std.mem.trim(u8, userInput, " \t\r\n");
	
	//parse the input to a float
    const weight_pounds = fmt.parseFloat(f64, trimmedInput) catch |err| 
	{
        std.debug.print("   Error parsing float: {}\n", .{err});
        return;
    };
	
	const KILOGRAM_CONVERSION:f64 = weight_pounds * KGS_IN_A_POUND;
	
	print("   pounds ", .{});
	//Print in decimal format:
	fmt.format(stdout, "{d:.2}", .{weight_pounds}) catch unreachable;
	
	print(" = ", .{});
	//Print in decimal format:	
	fmt.format(stdout, "{d:.6}", .{KILOGRAM_CONVERSION}) catch unreachable;
	
	print(" kgs\n", .{});
}
