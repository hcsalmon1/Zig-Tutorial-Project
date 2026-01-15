const Std = @import("std");
const print = Std.debug.print;

pub fn run() void {
	print("\nShowing Structs\n\n",.{});
	showingStructs();
}


const User = struct { //We create structs like this

	name: []const u8, //The equivalent of a string
	age:u8,
	admin:bool,

	fn printData(self:User) void {
		//This is a local function in a struct
		//The only thing you need is self in the parameters
		print("   name '{s}', age '{}', admin: '{}'\n", 
		.{
			self.name, self.age, self.admin
		});
		//self will be the struct that called so you can access the parameters with 'self.variable'
	}

	fn printRandomNumber(self:User, number:i32) void {	
		//if you don't want to use the local variables in the struct you will need to discard 'self':
		_ = self;
		print("   printing number in struct: {}\n", .{number});
	}

};

fn showingStructs() void {

	//We create a struct object like this
	var user1:User = User //This is like a constructor
	{ 
		.name = "Michael Jones", 
		.age = 30, 
		.admin = false 
	};	// you need to include all fields here


	user1.printData(); //call functions on structs like so
	//self is a parameter but it will automatically be inserted for you.
	user1.printRandomNumber(10);

	//You can create an array of users like this:

	var users:[3]User = undefined; //undefined means not created yet

	users[0] = User {
		.name = "Jim Bob",
		.age = 33,
		.admin = true,
	};

	users[1] = User {
		.name = "Dan James",
		.age = 30,
		.admin = false,
	};

	users[2] = User {
		.name = "Rachel Rick",
		.age = 25,
		.admin = false,
	};
	
	print("\n   Printing array of users:\n", .{});
	for	(users) |user| {
		user.printData();
	}
}
