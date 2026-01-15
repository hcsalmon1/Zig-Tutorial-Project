//how to write output in zig

//std contains code that allows you to print
const std = @import("std");

//to make calling print easier create this constant function copy
const print = std.debug.print;

pub fn run() void {
    print("\nOutput tutorial:\n\n", .{});
    debugPrint();
    regularPrint();
    printCharacter('a');
    printSlice("HELLO THERE");
}


fn debugPrint() void {
    print("Debug Print:\n", .{});
    //debug.print allows you to print without a variable

    //debug.print requires two parameters
    //if you don't want to use any parameters then write .{} as the second parameter, as below.
    print("   Hello\n", .{});

    //if you write just the text you will get an error:
    //std.debug.print("Hello");
    //uncomment the above line to see the error. You need ', .{}' after the text.

    //Printing an integer:
    //if you want to print a variable then you use {} to specify where in the text you want the variable.
    //then in the second part you put the variable name in .{} also.
    const number:i32 = 10;
    print("   Number is {}\n", .{number});

    //Print multiple variables:
    //to print more than one variable, in the second curly brackets you put both variables in order of use separated
    //by a comma:
    const number2:i32 = 20;
    const float1:f32 = 1.5;

    print("   Number2 is {}, float1 is {}\n", .{number2, float1});

    const float2:f32 = 0.55;
    print("   Number2 is {}, float1 is {} float2 is {}\n", .{number2, float1, float2});

}

fn regularPrint() void {
    print("\nRegular Print:\n", .{});
    //To print you need to get a variable from the standard library:
    var stdout_buffer:[1024]u8 = undefined;
    var stdout_writer:std.fs.File.Writer = std.fs.File.stdout().writer(&stdout_buffer);
    const stdout:*std.Io.Writer = &stdout_writer.interface;
    // you then use this to print same as debug:
    stdout.print("   Hello, world!\n", .{}) catch {};
    stdout.flush() catch return;

    //You will need to include this in every function where you wish to write this way. I'm unaware
    //of a way to make it global but you can send it to a function.
}

fn printCharacter(character_input: u8) void {
    print("\nPrint Character:\n", .{});
    //This prints a character as text
    print("   character is '{c}'\n", .{character_input});
    //this prints the ascii value of the character
    print("   character value is '{}'\n", .{character_input});
}

fn printSlice(input: []const u8) void {
    print("\nPrint Slice:\n", .{});

    //This function takes in an array of characters that we want to print.

    //slices are basically a combination of a pointer and a 'usize' storing the length of array.
    //The simplest way to create a slice is to go to the end of the array:
    const slice = input[0..];
    //this will fill with all of the characters in the 'input' array

    //We then print a slice using {s} in the curly brackets. This tells the language that it
    //needs to print a slice.
    print("   The slice is '{s}'\n", .{slice});

    //if you want only a certain part of the array then you will need to specify the end point:
    const smaller_slice = input[0..2];

    print("   The smaller slice is '{s}'\n", .{smaller_slice});

    //You need to be careful doing this however. The second index needs to be within range.
    //Here we get the array length:
    const input_length:usize = input.len;
    print("   Array size is '{}'\n", .{input_length});

    //You can then use bounds checking:
    const second_index:usize = 12;
    if (second_index >= input_length) {
        print("   index is out of range of slice: {}, array length {}\n", .{second_index, input_length});
    } else if (second_index < 0) {
        print("   index is out of range of slice: {}, array length {}\n", .{second_index, input_length});
    } else {
        //if it is inbounds we then use the second Index to create the slice
        const desired_slice = input[0..second_index];
        print("   The slice is {s}", .{desired_slice});
    }

    //The alternative to slices is to print with loops:
    if (input_length != 0) {
        print("   Individually printing characters: ", .{});
        //we loop through each element
        for (0..input_length) |i|
        {
            //and print each character individually
            print("{c}", .{input[i]});
        }
        print("\n", .{});
    }

    //Slices can contain anything

    const number_array:[5]i32 = [5]i32 {1,2,3,4,5};
    print("   number slice: ", .{});
    const number_slice = number_array[0..];
    print("{any}\n", .{number_slice});
    //to print a slice of number you use {d} or {any} instead of {s}
}

fn PrintVariable(comptime unknownType: type, input: unknownType) !void {
	const word = "   Hello";
	if (@TypeOf(input) == @TypeOf(word)) {
		const slice = input[0..];
		print("   {s}\n", .{slice});
	} else {
		print("   {}\n", .{input});
	}
}







