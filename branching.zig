const std = @import("std");
const print = std.debug.print;


pub fn run() void
{
	showIfStatements();
	showSwitches();
}

//if syntax:
//same as c:
//   if (true)
//   {

//   }
//   else if (false)
//   {

//   }
//   else
//  {

//  }

//To have multiple conditions 'use' and and 'or'
//   if (true && false) - no
//   if (true and false) - yes

//   if (true || false) - no
//   if (true or false) - yes

//Statements must be a bool
//   const number = 10;
//   if (number) - no

//   if (number == 10) - yes

//Switch syntax:
//   switch (VARIABLE) {
//     1 => ,
//     2 => ,
//     3 => ,
//   }
//   '=>' after the value 
//   ',' separate each case

//   const result = switch (VARIABLE) {
//          1 => 2,
//          2 => 3,
//          else => 4, //default case
//    }
//    This switch will return an integer

//   0...100 => , //case will be a range between two numbers

//   0, 1, 2 => , //case will be the three numbers


fn showIfStatements() void {
	//If statements are the same as most languages

	var do_something:bool = true;

	if (do_something == true) {
		print("   first if: 'do something' is true\n",.{});
	}

	do_something = false;

	if (do_something == true) {
		print("   second if: 'do something' is true\n",.{});
	} else if (do_something == false) {
		print("   second if: 'do something' is false\n",.{});
	} else  {
		print("Why isn't it possible? It's just not!\n",.{});
	}

	//To have multiple conditions you use 'and' or 'or'

	const number = 10;

	//if (do_something == true && number == 10) // - no 
	
	if (do_something == true and number == 10) { // - yes

	}

	//if (do_something == false || number != 10) // - no

	if (do_something == false or number != 10) { // - yes

	}

	//'&&' and '||' are not used as they can be ambigiuous with '&' and '|' which are bitwise operands.

	//the condition needs to be a bool value:

	//if (number) // - no
	
	if (number == 10) { // - yes 

	}

}


fn println(message:[]const u8) void {
	print("{s}\n", .{message});
}

const ColourType = enum {
	White,
	Black,
	DarkBlue,
	LightBlue,
	Green,
	Red,
	Orange,
	Pink,
	Yellow
};

const Colour = struct {
	r:u8,
	g:u8,
	b:u8,
};

fn printColour(colour:Colour) void {
	print("Colour: {}, {}, {}\n", .{colour.r, colour.g, colour.b});
}

fn processNumber(number:u8) []const u8 {
	return switch (number) {
		0 => "number 0",
		1 => "number 1",
		2 => "number 2",
		3 => "number 3",
		4 => "number 4",
		5 => "number 5",
		else => "Too high",
	};
}

fn showSwitches() void {
	println("\nShow switches:\n");
	var number:u8 = 0;
	for (0..6) |_| {
		number += 1;
		print("   {s}\n", .{processNumber(number)});
	}

	const colour_choice = ColourType.Black;
	const chosen_colour:Colour = switch (colour_choice) {
		.White => 		Colour{.r=255, .g=255, .b=255},
		.Black => 		Colour{.r=0, .g=0, .b=0},
		.DarkBlue => 	Colour{.r=32, .g=40, .b=161},
		.LightBlue => 	Colour{.r=0, .g=162, .b=232},
		.Green => 		Colour{.r=34, .g=177, .b=76},
		.Red => 		Colour{.r=237, .g=28, .b=26},
		.Orange => 		Colour{.r=255, .g=127, .b=39},
		.Pink => 		Colour{.r=255, .g=174, .b=201},
		.Yellow => 		Colour{.r=255, .g=242, .b=0},
	};
	
	print("   ", .{});
	printColour(chosen_colour);
	
	const user_age:u8 = 15;
	
	switch (user_age) {
		0...17 => println("   Too young"),
		18...59 => println("   Valid age"),
		60...100 => println("   Too old!"),
		101...255 => println("   Invalid age"),
	}
	
	
}
