const std = @import("std");
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;
const print = std.debug.print;

const Person = struct {
    name: []const u8,
    age: u8,
    email: []const u8,
};

const ParseError = error {
    ageNotParsed,
    nameNotParsed,
    emailNotParsed,
	commaNotFound,
};


fn findCommaIndex(line: []const u8) !usize {
    var index:usize = 0;
	for (line) |character| {
		if (character == ',') {
			return index;
		}
        index += 1;
	}
	return ParseError.commaNotFound;
}

fn findSecondCommaIndex(line: []const u8, index:usize) !usize {
	const LENGTH: usize = line.len;
	for (index..LENGTH) |i| {

		if (line[i] == ',') {
			return i;
		}
	}
	return ParseError.commaNotFound;
}

fn parseLine(line: []const u8) !Person {
    //find the first comma in the line
    const firstCommaIndex:usize = try findCommaIndex(line);
    //fill the name up to the comma
	const name:[]const u8 = line[0..firstCommaIndex];

    //find the second comma in the line
	const secondCommaIndex:usize = try findSecondCommaIndex(line, firstCommaIndex + 2);
    //fill the age up to the second comma
	const ageAsSlice:[]const u8 = line[firstCommaIndex + 2..secondCommaIndex];
    const age:u8 = try std.fmt.parseInt(u8, ageAsSlice, 0);

    //fill the email to the end from the second comma
	const email:[]const u8 = line[secondCommaIndex + 2..];

    return Person {
        .name = name,
        .age = age,
        .email = email,
    };
}

fn fillLines(allocator:Allocator, lines:*ArrayList([]const u8), buffer:[]const u8) void {
	const BUFFER_LENGTH:usize = buffer.len;
	var currentIndex:usize = 0; //this will store the start of each line
	//Loop through each character
	for (0..BUFFER_LENGTH) |i| {
		//look for a new line character
		if (buffer[i] == '\n') {
			//if you find it then fill the line to that index and add it to the list
			lines.append(allocator, buffer[currentIndex..i]) catch unreachable;
			currentIndex = i + 1;
		}
	}
}

pub fn run() void {
	const allocator = std.heap.page_allocator;
	
	// Open the file
	const file = std.fs.cwd().openFile("people.txt", .{}) catch unreachable;
	defer file.close();

	// Read the entire file into a buffer
	const file_size:u64 = file.getEndPos() catch unreachable;
	const buffer:[]u8 = allocator.alloc(u8, file_size) catch unreachable;
	defer allocator.free(buffer);
	
	_ = file.readAll(buffer) catch unreachable;
	
	var lines = std.ArrayList([]const u8).initCapacity(allocator, 0) catch return;
	defer lines.deinit(allocator);
	fillLines(allocator, &lines, buffer);
	
	// Parse each line
	var people = std.ArrayList(Person).initCapacity(allocator, 0) catch return;
	defer people.deinit(allocator);

	const LINE_COUNT:usize = lines.items.len;
	//Loop and parse each line
	for (0..LINE_COUNT) |i| {
		//Get the data
	        const person:Person = parseLine(lines.items[i]) catch unreachable;
	        //add it to the list
	        people.append(allocator, person) catch unreachable;
	}
	
	// Output the parsed data
	for (people.items) |person| {
		std.debug.print("Name: {s},\nAge: {},\nEmail: {s}\n\n",
	        .{ person.name, person.age, person.email });
	}
}
