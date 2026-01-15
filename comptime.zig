
const std = @import("std");
const print = std.debug.print;


//Comptime syntax:

//   comptime - makes a comptime variable, the value needs to be deterministic and known at compile time
//   anytype  - the compiler works out the type
//   type     - placeholder for a type of variable: i8, u8, bool etc. Could be any
//   comptime var - a mutable variable that is possible to determine as compile time


const AddingError = error {
	Overflow,
};

fn max(comptime T: type, a: T, b:T) T {
	if (a > b) {
		return a;
	}
	return b;
}

fn min(comptime T: type, a: T, b:T) T {
	if (a < b) {
		return a;
	}
	return b;
}

fn add(comptime T: type, a: T, b: T) AddingError!T {
	//We insert the type of the variable that we inserted
	//The type is worked out at compile time and saved as the variable 'T'
	//if we insert an i32, T = i32. So we can insert any integer type.
	return a + b;
}


fn add_i8(a:i8, b:i8) AddingError!i8 {
	if (a + b > 127) {
		return AddingError.Overflow;
	}
	return a + b;
}



fn printType(input: anytype) void {
	//the 'anytype' keyword simply works out the type of variable at compile time.
	print("   type of variable is: {}\n",.{@TypeOf(input)});
}

fn showComptime() void {
	print("\nShowing comptime:\n\n",.{});
	const number1_i8:i8 = 20;
	const number2_i8:i8 = -10;
	//we want to add these two numbers
	const addResult_i8_bad:i8 = add_i8(number1_i8, number2_i8) catch number1_i8;
	print("   adding two i8s: {}\n", .{addResult_i8_bad});
	//The add_i8 function only works with i8s.

	const number1_u8:u8 = 20;
	const number2_u8:u8 = 10;
	
	const number1_i16:i16 = 5000;
	const number2_i16:i16 = 5000;
	
	const number1_u16:u16 = 10000;
	const number2_u16:u16 = 10000;
	//if we want to add these types we would need to make a function for each type.

    //However we can use comptime to determine the type. Look at 'add' above
	const addResult_i8 = add(i8, number1_i8, number2_i8) catch number1_i8;
		print("   add i8 with add: {}\n", .{addResult_i8});
		
	const addResult_u8 = add(u8, number1_u8, number2_u8) catch number1_u8;
		print("   add u8 with same function: {}\n", .{addResult_u8});
		
	const addResult_i16 = add(i16, number1_i16, number2_i16) catch number1_i16;
		print("   add i16 with same function: {}\n", .{addResult_i16});
		
	const addResult_u16 = add(u16, number1_u16, number2_u16) catch number1_u16;
		print("   add u16 with same function: {}\n", .{addResult_u16});
	
	//Here we want to print the types of these variables, see the 'printType' function above:
	const number1 = 10;
	const number2 = 1.0;
	const number3 = 1_000_000_000;
	const word = "This is an example";
	print("\n   Print types:\n", .{});
	printType(number1);
	printType(number2);
	printType(number3);
	printType(word);
	printType(std);
	printType(print);
	
	//Here we get the max value of these numbers:
	const number_a_u8: u8 = 10;
	const number_b_u8: u8 = 20;
	
	const max_value_u8 = max(u8, number_a_u8, number_b_u8);
	print("   max u8: {}\n", .{max_value_u8});
	//note it works with any type

	//Here we the min value of these numbers:
	const number_a_i32: i32 = 1000;
	const number_b_i32: i32 = -1000;
	
	const min_value_i32 = min(@TypeOf(number_a_i32), number_a_i32, number_b_i32);
	print("   min i32: {}\n", .{min_value_i32});
	
	const number_array = [10]i32 {1,2,3,4,5,6,7,8,9,10};
	comptime var index:usize = 0;
	//we create a 'comptime var'. This is a mutable variable that is known at compile time.
	
	index += 9; //as 9 is a constant this will work
	//if you add something that is not known at compile time you will get an error
	
	print("   index at {} = {}\n", .{index, number_array[index]});
	
	//Here we are going to dynamically create arrays:
	print("\n   Creating arrays with a mutable variable:\n",.{});
	const STARTING_LETTER:u8 = 'a';
	
	comptime var array_size = 1; 
	var char_array: [array_size]u8 = undefined; //the first array will have one index
	
	inline for (0..array_size) |i| { //inline for will simply write out each line for you
		char_array[i] = STARTING_LETTER + i;
	}
	//'inline for' loop needs to be used with comptime variables.
	
	array_size += 1;
	var char_array2: [array_size]u8 = undefined; //the second array will have two indexes
	
	inline for (0..array_size) |i| {
		char_array2[i] = STARTING_LETTER + i;
	}
	
	array_size += 1;
	var char_array3: [array_size]u8 = undefined; //the third array has three indexes
	
	inline for (0..array_size) |i| {
		char_array3[i] = STARTING_LETTER + i;
	}
	
	array_size += 1;
	var char_array4: [array_size]u8 = undefined; //the final array has 4
	
	inline for (0..array_size) |i| {
		char_array4[i] = STARTING_LETTER + i;
	}

	print("   char array 1: {s}\n", .{char_array});
	print("   char array 2: {s}\n", .{char_array2[0..]});
	print("   char array 3: {s}\n", .{char_array3[0..]});
	print("   char array 4: {s}\n", .{char_array4[0..]});
}


pub fn run() void {
	showComptime();
}