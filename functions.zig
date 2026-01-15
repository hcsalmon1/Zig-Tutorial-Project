//std contains code that allows you to print
const std = @import("std");

//to make calling print easier create this constant variable
const print = std.debug.print;

pub fn run() void {
	print("\nShowing Functions:\n\n",.{});
	showingFunctions(); //call a function like so
}

//Functions are created like this:

fn function() void {
	
}

//'fn' = function, defines where a function starts
//'Function' is the name of the function
//'()' inside the brackets go parameters, which are variables that you want to insert into the function
//'void' is what the function returns. void means it returns nothing

//In c / c++ functions need to be either declared above or written above for other functions to be able
//to use them. This doesn't happen in zig, functions can be below other functions.

fn functionWithAnError() !void {

}

//if a return type is prefixed '!' this means the function could return an error.
//More info in errors.zig

fn functionWithParameters(number:i32) void {
	_ = number;
}

//Parameters are constant by default unless passed by reference and the type needs to be specified

fn showingFunctions() void {
	
	print("   -Called function\n", .{});
	const number_a: i32 = 100;
	const number_b: i32 = 110;
	
	if (isHigherThan(number_a, number_b) == true) //we call the function
	//if the result is true then
	{
		print("   a:{} is higher than b:{}\n", .{number_a, number_b});
		return; //leave the function
	}
	//if it's true then 
	print("   -b:{} is higher than a:{}\n", .{number_b, number_a});
	print("   -end of function'\n", .{});
}
 
fn isHigherThan(number_a:i32, number_b:i32) bool { //checks if the first number is higher than the second
//This functions takes in two integers and returns a bool
	print("    -Called 'IsHigherThan'\n", .{});
	if (number_b > number_a)
	{
		print("    -Returned false\n", .{});
		return false;
	}
	print("    -Returned true\n", .{});
	return true;
}

