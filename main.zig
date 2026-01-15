
const std = @import("std");
const print = std.debug.print;
const show_output = @import("output.zig");
const show_variables = @import("Variables.zig");
const show_loops = @import("loops.zig");
const show_allocators = @import("allocation.zig");
const show_branching = @import("branching.zig");
const show_input = @import("input.zig");
const show_floats = @import("Floats.zig");
const show_comptime = @import("comptime.zig");
const show_pointers = @import("pointers.zig");
const show_functions = @import("functions.zig");
const show_arrayLists = @import("arrayLists.zig");
const show_structs = @import("structs.zig");
const show_errors = @import("errors.zig");
const openingFiles = @import("OpeningFiles.zig");
const show_threading = @import("threading.zig");
const show_optionals = @import("optionals.zig");
const FsReader = std.fs.File.Reader;
const IoReader = std.io.Reader;

pub fn main() void {
	//to run in windows open a powershell in the folder of these files. Shift + right click on an empty space in the folder.
	//in the powershell type the command:
	//'zig run main.zig'
	
	//Comment and uncomment these to see the code results of each section:
	
	//show_functions.run();
	//show_variables.run();
	//show_structs.run();
	//show_branching.run();
	//show_input.run();
	//show_output.run();
	//show_floats.run();
	//show_loops.run();
	//show_errors.run();
	//show_allocators.run();
	//show_arrayLists.run();
	//show_pointers.run();
	//show_comptime.run();
	//openingFiles.run();
	//show_threading.run();
	//show_optionals.run();

	pressEnter();
}

fn pressEnter() void {
	//This stops the program closing instantly until you press enter.
	print("Press Enter to exit\n", .{}); 

	//This stops the program closing instantly until you press enter.
	var user_input:[60]u8 = undefined; 
	var stdin_reader:FsReader = std.fs.File.stdin().reader(&user_input);
	const stdin:*IoReader = &stdin_reader.interface;

	const line:[]u8 = stdin.takeDelimiterExclusive('\n') catch return;
    _ = line;
}

	//var user_input: [60]u8 = undefined; 
	//const stdin = std.io.getStdIn().reader();

	//print("Press enter to exit\n", .{}); 

	//const result: []const u8 = stdin.readUntilDelimiter(&user_input, '\n') catch "____"; 
    //_ = result;