//std contains code that allows you to print
const std = @import("std");

//to make calling print easier create this constant variable
const print = std.debug.print;

pub fn run() void {
	print("Getting Input\n",.{});
	
	getUserInput();
    parsingInput();
}

fn getUserInput() void {

    //You can use the fixed buffer allocator to get user input
    const BUFFER_SIZE = 100;
	var buffer:[BUFFER_SIZE]u8 = undefined; 
	var fba = std.heap.FixedBufferAllocator.init(&buffer); 
	const fba_allocator = fba.allocator(); //look at allocation.zig for more info
	var stdin_reader = std.fs.File.stdin().reader(&buffer);
	var stdin = &stdin_reader.interface;

    print("   Write something: ", .{}); //ask for input
	const user_input:[]u8 = stdin.takeDelimiterExclusive('\n') catch return;
	defer fba_allocator.free(user_input); //free the memory at the end of the scope

    print("   input from fixed buffer: {s}\n\n",.{user_input}); //write the input

    //This can only be done if you know the size of the desired output. The program will crash
    //if the user types over this amount.

    //You can also use the page allocator which is slower but can allocate more memory.
    const page_allocator = std.heap.page_allocator;
		
	const second_buffer = page_allocator.alloc(u8, 1000) catch unreachable; //allocate the 1000 u8s on the heap
	defer page_allocator.free(second_buffer); //free at end of scope
    print("   Write something again: ", .{}); //ask for input
	stdin_reader = std.fs.File.stdin().reader(&buffer);
	stdin = &stdin_reader.interface;
	const user_input2:[]u8 = stdin.takeDelimiterExclusive('\n') catch return;
    print("   input from page allocator: {s}\n", .{user_input2}); //print the input


}

fn parsingInput() void {

	print("\n   Showing parsing:\n", .{});
	//let's say we get input and the user writes 250
	const input = "250"; 
	//we want to parse this into a number
	const trimmedInput = std.mem.trim(u8, input, " \t\r\n");
	//we will get an error if we don't remove extra characters, as there is usually a new line character

	//to parse it to a float we call parseFloat in std.fmt.
	//This takes in the type you want and the input.
	const input_as_float = std.fmt.parseFloat(f64, trimmedInput) catch |err| {
		//if it's an error then we print it
		std.debug.print("   Error parsing float: {}\n", .{err});
		return;
	};
	print("   input as float: {}\n", .{input_as_float});

	//Parsing integers is the same except we need to put a ten in the parameters.
	//This is because it can work for many formats of number:
	//2 for binary
	//8 for octal numbers
	//10 for decimal numbers
	//16 for hexadecimal
	const input_as_integer = std.fmt.parseInt(i32, trimmedInput, 10) catch |err| {
		//if it's an error then we print it
		std.debug.print("   Error parsing int: {}\n", .{err});
		return;
	};
	print("   input as int: {}\n", .{input_as_integer});
}
