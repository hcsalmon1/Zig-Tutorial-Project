const std = @import("std");
const print = std.debug.print;


pub fn run() void {
    print("Loops Tutorial:\n", .{});
    forLoops();
    whileLoops();
}

fn forLoops() void {
    print("\n   For Loops\n\n", .{});
    //This is the most common type of loop. It's a bit different to c based languages though.

	print("   Looping:\n   i = ", .{});
    for (0..5) |i| {
        print("{}, ", .{i});
    }
	print("\n", .{});
	
    //this will go from 0 to 4 and creates a usize variable called 'i' that you can use as an index.
    //If we don't use this 'i' variable we'll get an error so we need discard it with '_'

    for (0..5) |i| {
        _ = i;
    }

    //Or we can use an underscore to not have a variable at all.

    for (0..5) |_| {

    }

    //To show this is an usize this will give us an error:

    //var index: i32 = 0;
    //for (0..4) |i|
    //{
    //    index = i;
    //} //remove comments to see

    //64 bits can't fit into 32 bits

    var index1: u64 = 0;
    for (0..4) |i| {
        index1 = i;
    }
    print("\n   Index u64: {}\n", .{index1});

    //A usize is basically an unsigned 64 bit integer so we either need to cast it or use a u64.
    //if you don't want to deal with casting or changing another variable to a 64 bit integer you can create your own variable.

    var index2: i32 = 0;
    for (0..4) |_| {
        index2 += 1;
    }
    //You then increment this value manually.

    //To go through the elements in an array we do this:

    const word = [_]u8 {'a', 'b', 'c'};
	
	print("\n   Printing char array:\n   ", .{});
    for (word) |character_index| {
        print("{c}, ", .{character_index});
    }

    //This is similar to a foreach in other languages. The loop will run for each element in the array.

    //I haven't found a way to loop in reverse yet using the given variable.
    //for (4..0) |i|
    //{
    //    Print("{}\n", .{i});
    //} //comment to see error

    //to get around this you can manually go backwards

	print("\n\n   Printing Backwards:\n   ", .{});
    var custom_index: usize = 4;
    for (0..4) |_| {
        print("{}, ", .{custom_index});
        custom_index -= 1;
    }
	print("\n", .{});

    //Inline for loops
    //There is a small overhead to using for loops because every time you cycle through there will
    //be a check to see if the condition has been met. If you want to avoid this you will need to manually write it all out.
    //To save you doing this there is a way to have an inline loop. This will basically write out each line for you.

    const array_size = 10;
    var temp_value: i32 = 0;
    var values = [_]i32 {0,0,0,0,0,0,0,0,0,0};

    inline for (0..array_size) |i| {
        values[i] = temp_value;
        temp_value += 1;
    }

    //This range of the loop will need to be known at compile time however. This is normally only using for compile time things
    //See 'comptime.zig' for more

	print("\n   Showing Break:\n", .{});
    //To break from loops you use 'break'

    var temp_index: i32 = 0;
    for (0..10) |_| {
        temp_index+= 10;
        if (temp_index > 50) {
            print("   index is over 50, break loop\n", .{});
            break; //breaks out of the loop
        }
        print("   tempIndex: {}\n", .{temp_index});
    }

    //Continue does the same but will skip the rest of the code and recycle through

    print("\n   Showing Continue:\n",.{});
    var temp_index2: i32 = 0;
    for (0..10) |_| {
        temp_index2+= 10;
        if (temp_index2 == 20) {
            print("   temp index = 20, continue\n", .{});
            continue; //Here we will recycle the 'for loop' and skip the rest of the code.
        }
        if (temp_index2 > 50) {
            break; //breaks out of the loop
        }
        print("   tempIndex: {}\n", .{temp_index2});
    }

    print("\n\n   Printing multidimensional array:\n", .{});
    //You can nest loops like so:
    const multidimensional_array = [4][2]i32 {
      [_]i32{1,0},
      [_]i32{0,1},
      [_]i32{0,0},
      [_]i32{1,1},
    };
    for (0..4) |x| { //loop for the first index
        for (0..2) |y| { //loop for the second index
            const number:i32 = multidimensional_array[x][y];
            print("   number {}x{}= {}\n", .{x,y, number});
        }
    }

    print("\n\n   Showing outer loop breaks:\n", .{});

    //Sometimes you may want to break out of an outer loop entirely and not just the inner one.
    //For this you can label the outer loop:

    outer: for (0..4) |x| { //this labels this loop as 'outer'

        for (0..2) |y| {

            const number:i32 = multidimensional_array[x][y];
            print("   number {}x{}= {}\n", .{x,y, number});
            if (x == 2) {

                if (y == 1) {
                    print("   Outer loop break\n", .{});
                    break :outer; //if some condition is met we can then break the outer loop like so.
                }
            }
        }
    }

    //This works exactly the same with 'continue'.

}

fn whileLoops() void {

    print("\n   While Loops:\n\n", .{});
    //While loops are probably the simplest loop that exists. It just goes forever until a
    //condition is met, like other languages.

    var index:i32 = 0;
	print("   While started\n   ", .{});
    while (true) {
        index += 1;
        if (index > 10) {
            break; //ends the while loop
        }
        print("index: {}, ", .{index});
    }
	print("\n   While ended\n", .{});

    //Of course you need to be careful with 'while' loops because they go on forever and the program will freeze.

    //var temporaryNumber:i32 = 0;
    //Print("while loop started\n", .{});
    //while (temporaryNumber > -1)
    //{
       // temporaryNumber += 1; //this goes forever
    //}
    //Print("while loop ended\n", .{});

    //The while condition will never be filled with this code and it will go forever until there is an integer overflow.

	//You can also create a statement that will be run whenever the loop recycles
	//These are called 'continue statements' and are optional
	
	var index2:i32 = 0;
	print("\n   While started\n   ", .{});
	// We write ':' then a statement in brackets
    while (index2 < 10) : (index2 += 1) { //we add 1 to 'index' every time the loop recycles
        print("index: {}, ", .{index2});
    }
	print("\n   While ended\n", .{});
	//This does the same as the above loop.
	
}








