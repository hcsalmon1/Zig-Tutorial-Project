const std = @import("std");
const print = std.debug.print;

pub fn run() void {
	print("\nShowing Errors:\n\n", .{});
	//Errors are a type of enum.
	
	//Functions return either:
	//  a type - void, bool, i32...
	//  an error
	//  a union of an error or a type

	print("   Show add errors:\n", .{});
	showAddErrors(MAX_I32, 1);
	showAddErrors(MIN_I32, -1);
	showAddErrors(10, 10);

	print("\n   Showing array errors:\n", .{});
	showGlobalArrayErrors();
	
	showingErrorLists();
}

//Error syntax:

//   try    - If the function returns an error, return that error to the previous function

//   catch  - sets a default value if there is an error.
//   catch unreachable; - if there is an error end the program and show the error

//   catch |err| { - if there is an error do something with it, like print
//   }

//   catch |err| switch (err) { - makes a switch for each error value, to do something in each case
	
//   }

//   if (result) |res| { - if it's not an error, do something with this variable
//   }
//   else |err| { - if it's an error
//   }

//   fn function() ErrorName!void - returns an error or nothing
//   fn function() !bool - returns any error or a bool
//   fn function() ErrorName - returns only a created error



const MAX_I32:i32 = 2147483647;
const MIN_I32:i32 = -2147483648;

const GLOBAL_ARRAY_LENGTH:usize = 100;
const global_number_array = [GLOBAL_ARRAY_LENGTH]i32 {
	0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,
};

const AddingError = error { //this creates an error, like an enum
	IntegerOverflowHigh,
	IntegerOverflowLow
};

const ArrayError = error {
	IndexTooLow,
	IndexTooHigh
};

fn add(a:i32, b:i32) AddingError!i32 {
	var temp:i64 = a;
	temp += b;
	if (temp > MAX_I32) {
		return AddingError.IntegerOverflowHigh;
	}
	if (temp < MIN_I32) {
		return AddingError.IntegerOverflowLow;
	}
	return a + b;
}

fn showAddErrors(a:i32, b:i32) void {
	const result = add(a, b); //If this function returns set the default value to 'a'.
	//Print("result {}\n", .{result});
	//print("    type of result: {}\n", .{@TypeOf(result)}); //uncomment to see the type

	if (result) |value| { //if this is not an error, store it in 'value'
		//Print("type of result: {}\n", .{@TypeOf(result)});
		print("   {} + {} = {}\n", .{a, b, value});
	} else |err| { //if it an error, store the error in 'err'
		//Print("type of result: {}\n", .{@TypeOf(result)});
		print("   ADD ERROR: {} + {} resulted in {}\n", .{a, b, err});
	}
}

fn showGlobalArrayErrors() void {
	for (80..110) |index| {
		const value = getArrayIndex(index);
		if (value) |val| { //if the result wasn't an error
			print("   value at {} = {}\n", .{index, val});
		} else |err| { //if it was an error, print the error
			print("   ERROR index {} = {}\n", .{index, err});
		}
	}
}

fn getArrayIndex(index:usize) ArrayError!i32 {
	if (index >= GLOBAL_ARRAY_LENGTH) {
		return ArrayError.IndexTooHigh;
	}
	return global_number_array[index];
}
 
fn showingErrorLists() void {
	//To get the list of possible errors you simply use catch directly and an empty switch:
	//Uncomment to see:
	
	//const number_as_text:[]const u8 = "10";
	//const age:u8 = std.fmt.parseInt(u8, number_as_text, 0) catch |err| switch (err) {
		
	//};
	//_ = age;
	
	//As switches need to cover all possibilities the compiler will show you all
	//the possible errors that could come from this function.

}
