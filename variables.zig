const std = @import("std");
const print = std.debug.print;
const printBits = @import("PrintBits.zig");
const fmt = std.fmt;

pub fn run() void
{
	print("\nShowing Variables\n\n",.{});
    creatingVariables();
    integerVariables();
    integerOverflows();
	creatingArrays();
	optionalVariables();
	convertingVariables();
	showingFloats();
	textVariables();
}

//Variable syntax:
//			
//			const number:i32 = 10;   	- makes a constant variable with 32 bits and sets it to 10
//			var number:i32 = 15;		- makes a mutable variable with 32 bits and sets it to 15
//			const number = 10;			- types are optional if the type is const

//Array syntax:
//			const number_array:[5]u8 = [5]u8 {1,2,3,4,5};	- creates a constant array of 8 bit integers
//			const number_array = [_]u8 {1,2,3,4,5};			- the type is optional and the length can be inferred

//Slice syntax:
//			const word:[]const u8 = "Hello";	- Creates a slice

//			const number_array = [_]i32 {1,2,3};
//			const slice:[]const i32 = number_array[0..];	- creates a slice of the number array above
//			const slice:[]const i32 = number_array[0..2];	- creates a slice of only the first two number in the number array
//			[_] / [5]i32 	= array
//			[]i32 			= mutable slice - you can change values at the indexes
//			[]const i32		= constant slice


fn printTypes() void
{
	print("{}\n", .{@TypeOf("Hello")});
}

fn creatingVariables() void
{
	print("   Creating Variables:\n", .{});
    //To create a variable you start with either 'const' or 'var'
    //const will make it constant and it won't be able to be changed.
    //You then write the name of the variable '=' then it's value.
    const number = 10;
    //The type will be inferred by the compiler if you don't specify
    //Zig will give you an error if you declare a variable and don't use it.
    //We use '_ = variable;' to show that we won't use a variable and we won't get an error.
    _ = number;
	
	//If we try to change the number we will get an error because it's constant.
    //number = 12; //uncomment to see error

    //To create a mutable variable we use 'var'
    var number2:u8 = 12;
    //This variable can be changed:
    number2 = 13;

    //if you want to specify the type then use ':' then the type:
    const number3:i32 = 10;
    
	print("   number2: {}\n", .{number2});

	print("   number3: {}\n", .{number3});

    //if you create constant variable then you don't need to specify the type and it will be inferred
    //by the compiler. However you will need to specify the bit size if you create a mutable variable:

    //var number4 = 12;
    //number4 = 13;  //uncomment to view error

    //these variables will all be stack variables and temporary
}

fn integerVariables() void
{
	print("\n   Integer Types:\n",.{});
    //integers are either signed or unsigned. A signed integer can go below zero
    //whereas an unsigned bit can only be positive.

    //Unsigned integers can normally be double the size of signed integers.
    //This is because in signed integers the last bit represents a plur or a minus.

    //Here are all the integer types:
    const number_i8: i8 = 120; //signed 8bit integer, min -128, max 127
    const number_U8: u8 = 200; //unsigned 8bit integer, min 0, max 255
    const number_i16: i16 = -10000; //signed 16bit integer, min -32768, max 32767
    const number_U16: u16 = 10000; //unsigned 16bit integer, min 0, max 65535
    const number_i32: i32 = -10000; //signed 32bit integer, min -2,147,483,648, max 2,147,483,647
    const number_U32: u32 = 10000; //unsigned 32bit integer, min 0, max 4,294,967,295
    const number_i64: i64 = -10000; //signed 64bit integer, min -9,223,372,036,854,775,808, max 9,223,372,036,854,775,807
    const number_U64: u64 = 10000; //unsigned 64bit integer, min 0, max 18,446,744,073,709,551,615
    const number_i128: i128 = -10000; //signed 128 bit integer
    const number_U128: u128 = 10000; //unsigned 128 bit integer

	//Ignore this long print, I'm just print all the numbers above
	print("   numberi8 type: {} value: {}\n   numberU8 type: {} value: {}\n   numberi16 type: {} value: {}\n   numberU16 type: {} value: {}\n   numberi32 type: {} value: {}\n   numberU32 type: {} value: {}\n   numberi64 type: {} value: {}\n   numberU64 type: {} value: {}\n   numberi128 type: {} value: {}\n   numberU128 type: {} value: {}\n", 
	.{
		 @TypeOf(number_i8), number_i8,
		 @TypeOf(number_U8), number_U8,
		 @TypeOf(number_i16), number_i16,
		 @TypeOf(number_U16), number_U16,
		 @TypeOf(number_i32), number_i32,
		 @TypeOf(number_U32), number_U32,
		 @TypeOf(number_i64), number_i64,
		 @TypeOf(number_U64), number_U64,
		 @TypeOf(number_i128), number_i128,
		 @TypeOf(number_U128), number_U128
	});

    //When creating a variable you can use underscores to increase reabability of big numbers:
    const long_number: u32 = 1_000_000_000;
    _ = long_number;

    //You can actually make an integer of an arbitrary length if you need a specific max number.

    const specific_number: u7 = 127; //this creates an integer with 7 bits. This will be from 0 to 127
    _ = specific_number;

	//There is a special kind of integer called a usize.
	const index:usize = 0;
	_ = index;
	//The size of the variable will be the size of a pointer, normally u64.
	//These variables are the default type for accessing indexes of arrays.

	//Zig won't let you access the index of an array with a signed integer as they can be negative.

}

fn integerOverflows() void
{
    print("\n   Integer Overflows:\n", .{});

    //By default zig will throw an error if there is an integer overflow.
    //An overflow is where the value specified is above or below the possible value from the given bits.
    //for example:

    var unsigned_number: u8 = 255;
    print("   The value of unsignedNumber before: {}\n", .{unsigned_number});
    //A u8 has 8 bits, so the value goes from 0 to 255. If you go over or under this we will get an error:

    //number += 1; //uncomment to see

    //There is a way to ignore overflows and that's to include the '%' symbol.

    unsigned_number +%= 1;
    print("   The value of unsignedNumber after adding 1: {}\n", .{unsigned_number});

    //When an integer overflows up all the bits will be flipped back to zero. So the integer will go to it's lowest value.
    //For an unsigned integer, it's zero. For a signed integer it is '(theMaxValue * -1) - 1'.
    //So the max value of an i8 is 127 so the lowest number is -128:

    var signed_number: i8 = 127;
    print("   The value of signedNumber before: {}\n", .{signed_number});

    signed_number +%= 1;
    print("   The value of signedNumber after: {}\n", .{signed_number});
}

fn creatingArrays() void
{
	print("\nCreating arrays:\n\n",.{});
	//We create arrays using square brackets
	
	const number_array = [_]i32 {1, 2, 3};
	//if we use an underscore in the array then the compiler will work out the size.
	const number_array2 = [3]i32 {4, 5, 6};
	//we can specify the size as well using a number.

	for (0..3) |i|
	{
		print("   First array: {} = {}\n", .{i, number_array[i]});
		print("   Second array: {} = {}\n", .{i, number_array2[i]});
	}
	
	//if you don't know the contents of the array when declaring it you can use 'undefined':
	
	var undefined_array: [3]i32 = undefined;
	
	//the array can't be constant if you do this
	
	var count : i32 = 0;
	for	(0..3) |i|
	{
		undefined_array[i] = count; //setting the array index to equivalent of the index
		count += 1;
	}
	
	for (0..3) |i|
	{
		print("   Undefined array: {} = {}\n", .{i, undefined_array[i]});
	}
	
	//array length
	
	//To get the length of an array we use '.len;'
	
	const undefined_array_length: usize = undefined_array.len;
	print("   array length = {}", .{undefined_array_length});
	
	//Multidimensional arrays can be defined like so
	
	const multi_dimensional_array = [3][3]i32
	{
		[_]i32{0, 1, 2},
        [_]i32{3, 4, 5},
        [_]i32{6, 7, 8},
	}; 
	
	print("\n\n   Multidimensional array:\n", .{});
	
	for (0..3) |x|
	{
		for (0..3) |y|
		{
			print("   x {} y {} value = {}\n", .{x, y, multi_dimensional_array[x][y]});
		}
	}
	
}

fn optionalVariables() void
{
	print("\nOptional Variables:\n", .{});
	//Optional variables are variables that can be null or an unset value.
	//Make something optional using a question mark '?'
	var found_index: ?usize = null; //we don't know the index yet, so make it null
	const data_array = [_]i32 {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
	const value_to_find: i32 = 10; //the value we want to find in the array
	const array_length: usize = data_array.len;
	
	for (0..array_length) |index|
	{
		if (data_array[index] == value_to_find)
		{
			found_index = index;
		}
	}
	//we can't directly use an optional variable. We use this syntax to do so:
	if (found_index) |converted_index| //if 'foundIndex' isn't null, store it in 'convertedIndex'
	{
		print("   found index = {}\n", .{converted_index});
	}
	else
	{
		print("   Index wasn't found, the optional variable was null", .{});
	}
}

fn convertToU32(input:i32) u32
{
	const MAX_U32_VALUE: u32 = 4294967295;
	if (input > MAX_U32_VALUE)
	{
		return 0; //it can't fit inside
	}
	if (input < 0)
	{
		return 0; //it can't fit inside
	}
	return @intCast(input);
}

fn convertingVariables() void
{
	print("\nConverting Variables:\n", .{});
	//We can convert types using '@as'
	const number:i32 = 10;
	const converted_number:u32 = @as(u32, number); //we want to make into a unsigned 32 bit integer
	print("   converted number: {}\n", .{converted_number}); //we print the converted integer
	
	const negative_number:i32 = -1;
	//This will give an error. -1 can't fit inside a u32
	//const convertedNegativeNumber2:u32 = @as(u32, negativeNumber);
	//print("converted negative number: {}\n", .{convertedNegativeNumber2});	

	//intCast is less safe and it will force the cast, so it could give you errors.
	//The safest way to use this is to check the bounds yourself.


	const converted_u32:u32 = convertToU32(negative_number);
	print("   convertedU32: {}\n",.{converted_u32});
	
	//If you try to cast a constant variable that won't fit, using intCast, it won't let you
	const negative_number2:i32 = -1;
	_ = negative_number2; //comment this if you uncomment the error below
	//const converted_negative_number3:u32 = @intCast(negative_number2);  //Uncomment to see error
	//print("converted negative number 3: {}\n", .{converted_negative_number3});
	
	//The compiler will know the value won't fit as the value is constant.
	
	//If you want to make a value into a smaller value, you can use '@truncate'
	
	const random_number:u32 = 500;
	const converted_random_number:u8 = @truncate(random_number);
	print("   Converted random: {}\n", .{converted_random_number});
	
	//Both variables need to be the same sign. So if you want to convert a u32 to 8 bits, it will need to
	//to be a u8.
	//If the value is over the max value of the type you are converting to, then the extra bits will be removed.
	
	//Looking at the bits:
	//randomNumber: 500 			= 00101111100000000000000000000000
	//convertedRandomNumber: 244 	= 00101111

	//the bit worth 256 was removed so 500 - 256 = 244
	print("   Printing bits:\n", .{});
	print("   ", .{}); //spaces
	printBits.printU32(random_number);
	print("   ", .{}); //spaces
	printBits.printU8(converted_random_number);

}

fn showingFloats() void
{
	print("\nShowing floats:\n\n",.{});
	floatTypes();
	printFloats();
	convertWeight();
}

fn floatTypes() void
{
	print("   Float Types:\n",.{});
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
	print("\n   Print float in decimal\n", .{});
	//By default floats are printed in scientific notation
	//So you will have an 'e0' at the end.
	
	const decimal1:f64 = 1.111111;
	
	//To print them in decimal form we will call 'format' from 'std.fmt'.
	//At the top we import 'fmt' as 'std.fmt'
	
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
	print("\n   parsing floats from input:\n",.{});
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
	const user_input = stdin.readUntilDelimiterAlloc(fba_allocator, '\n', 100,) catch "invalid input\n"; 
	defer fba_allocator.free(user_input);
	
	//Trim the input
	const trimmed_input = std.mem.trim(u8, user_input, " \t\r\n");
	
	//parse the input to a float
    const weight_pounds = fmt.parseFloat(f64, trimmed_input) catch |err| 
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

fn textVariables() void
{
	print("\nText variables:\n\n",.{});
	//The equivalent of a 'char' in c is a 'u8' in zig:
	const letter:u8 = 'a';
	//u8 can represent a number as well as text
	print("   letter: {}\n", .{letter});
	//just putting the variable into print will show the number

	//if you put {c} in the brackets then the text will be printed:
	print("   letter as text: {c}\n", .{letter});

	//You can make a char array to have a word:
	const word:[5]u8 = [5]u8{'h','e','l','l','o'};
	//then print it using the index
	print("   {c},{c},{c},{c},{c}", 
	.{
		word[0], word[1], word[2], word[3], word[4],
	});
	print("\n", .{});

	//Much easier is to use a slice. This is a pointer and a length.
	//This means it is a combination of two variables, one that stores the memory address
	//of the first element and one for the size.

	//You don't need to think about this though when using them.
	const slice:[]const u8 = "Hello";
	//A slice is like a pointer, this is const though
	print("   slice = {s}\n", .{slice});
	//To print a slice you use 's' in the curly brackets.

	var mutable_word:[5]u8 = [5]u8{'h','e','l','l','o'}; //mutable array
	const mutable_slice:[]u8 = mutable_word[0..]; //we create a slice from the array like so
	//This is now mutable as we wrote '[]u8' and not '[]const u8'

	mutable_slice[0] = 'M'; //We change the value at the address
	print("   mutable slice: {s}\n", .{mutable_slice});
	//Then print it.
	//As slices are basically pointers it will change the original array too.

}






