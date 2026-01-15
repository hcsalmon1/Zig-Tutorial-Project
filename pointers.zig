const Std = @import("std");
const Print = Std.debug.print;

pub fn run() void {
	Print("\nShowing Pointers:\n\n", .{});
	showingPointers();
	potentialPointerErrors();
	pointingToObjects();
}

//Pointer syntax:

//const pointer_name1: *u8 - a mutable pointer to a 8 bit variable
//var pointer_name2: *u8 = &variable;
//const pointer_name: *const u8 - a constant pointer to a 8 bit variable
//var pointer_name2: *const u8
//slice_name: []u8 - A slice: a mutable pointer to an array of 8 bit variables, with the length included
//slice_name: []const u8 - A constant slice
//pointer_array_name: [*]u8 - An array of mutable pointers linking to 8 bit variables
//pointer_array_name: [*]const u8 - an array of constant pointers linking to 8 bit variables
//pointer_name - will show the memory address of the pointer
//pointer_name.* - dereference: will show the value stored at the memory address
//pointer_name.*. - accesses a member variable in the struct the pointer links to


fn showingPointers() void {
	
	//Pointers work the same way as other languages
	
	var mutableNumber:i32 = 20;
	var mutableNumber2:i32 = 10;
	//To create a pointer you put '*' before the type
	var mutableNumberPointer: *i32 = &mutableNumber; //store the memory address of 'mutableNumber'
	//The types will need to be the same. You can't, for example, create a 'u32' pointer
	//that points to an 'i32' variable.
	
	//Using '&' will get the memory address of a variable.
	
	Print("   mutableNumber: {}\n", .{mutableNumber});
	Print("   mutableNumberPointer: {}\n", .{mutableNumberPointer});
	//if you just write the name of a variable you will be shown the memory address.
	Print("   mutableNumberPointer dereferenced: {}\n", .{mutableNumberPointer.*});
	//If you want to access the value at the memory address you use '.*' after the name.
	
	mutableNumberPointer.* = 30; //Here we change the value of the value at the memory address with '.*'
	Print("\n   After change:\n", .{});
	Print("   mutableNumber: {}\n", .{mutableNumber});
	Print("   mutableNumberPointer: {}\n", .{mutableNumberPointer});
	Print("   mutableNumberPointer dereferenced: {}\n", .{mutableNumberPointer.*});
	//As the pointer is pointing to the original variable, when we change the value at the address
	//it also changes the original number.
	
	mutableNumberPointer = &mutableNumber2; //we can set the pointer to point to something else as it's mutable
	mutableNumberPointer.* += 10;
	
	Print("   mutableNumberPointer (new variable): {}\n", .{mutableNumberPointer}); //there will now be a different memory address
	Print("   mutableNumberPointer dereferenced (new variable): {}\n", .{mutableNumberPointer.*});
	
	
	Print("\n   Constant pointers:\n", .{});
	
	//Zig has different types of pointers
	const constNumber:i32 = 10;
	const numberPointer: *const i32 = &constNumber;
	//This is a constant pointer and can't be changed. The value is it pointing to also can't be changed.
	
	//This gives an error because you can't point to a constant variable with
	//a pointer that isn't constant:
	//const invalidPointer: *i32 = &constNumber; //Uncomment to see error
	
	//invalidPointer.* = 20; //Uncomment to see error
	//numberPointer.* = 20; //Uncomment to see error
	
	//You can't change constant variables.
	
	Print("   constNumber: {}\n", .{constNumber});
	Print("   numberPointer: {}\n", .{numberPointer});
	Print("   numberPointer dereferenced: {}\n", .{numberPointer.*});
	//The same as above but you can't change the values.
	
	//You are not allowed to point to a const variable with a mutable pointer.
	//However you can point to mutable variable with a const pointer.
	
	const immutablePointer: *const i32 = &mutableNumber; //this is linking to the mutable variable.
	
	//However, as this is a constant pointer, it can only use the value and not change it.
	
	Print("   immutable address: {}\n", .{immutablePointer});
	Print("   mutable address: {}\n", .{mutableNumberPointer});
	Print("   immutable value: {}\n", .{immutablePointer.*});
	Print("   mutable value: {}\n", .{mutableNumberPointer.*});

	//These values are the same, but the immutablepointer can't change the value but the original can:
	
	//immutablePointer.* += 1; //ERROR
	mutableNumberPointer.* += 1;
	
}

fn GetPointer() *i32 { //we return a pointer to a 32 bit integer
	var count:u8 = 0;
	var numberPointer:*i32 = undefined;
	
	while (count < 5) {
		var tempNumber:i32 = count;
		numberPointer = &tempNumber; //we set the pointer to a temporary stack variable
		count += 1;
	}
	
	return numberPointer; //Then return it
	//This is a terrible idea because the stack variable is temporary.
	//You shouldn't return a pointer to a variable that might not exist in memory
}

fn potentialPointerErrors() void {
	Print("\n   Potential Pointer Errors:\n",.{});
	const numberPointer:*i32 = GetPointer(); //We get the pointer to a stack variable
	
	const numberPointerOptional:?*i32 = numberPointer; //To avoid potential errors we will convert it to an optional
	//In Variables.zig you can see more information about optionals.

	if (numberPointerOptional) |checkedPointer| { //we check the optional to make sure it's not null
		Print("   Pointer wasn't null", .{});
		Print("   value: {}\n", .{checkedPointer.*});
	} else {
		Print("   The pointer is null\n", .{});
	}
	//If you don't make this optional then you could get errors if the address you are pointing to
	//doesn't exist anymore.
}

const User = struct {
	name: []const u8, //slice, the equivalent of a string
	age:u8,
	admin:bool,
};


fn PrintUserArray_Slice(users:[]User) void { //We pass the slice to the function
	for (users) |user| {
		Print("   Name: {s}, age: {}, admin: {}\n", .{
			user.name, 
			user.age, 
			user.admin
		});
	}
}

fn pointingToObjects() void {
	Print("\n   Pointing to objects:\n",.{});
	var user1 = User { //we create a user object
		.name = "John Smith", 
		.age = 30, 
		.admin = true
	};
		
	const userPointer: *User = &user1; //we create a pointer to the user object
	//To access a struct variables from a pointer we use '.*.' The .* to dereference and the last to access the variable.
	userPointer.*.age += 1; 
	
	Print("   user1 age: {}\n", .{user1.age}); //This will change the age
	
	Print("\n   Slice to array:\n", .{});
	
	var users = [5]User {
		User{ .name = "John Smith", .age = 30, .admin = true },
		User{ .name = "Jimmy Jones", .age = 38, .admin = true },
		User{ .name = "Mike Adams", .age = 32, .admin = false },
		User{ .name = "Phil Cummins", .age = 31, .admin = false },
		User{ .name = "Tim Anderson", .age = 40, .admin = true }
	};
	//We create an array of the user struct.
	
	//Best practice is to create a slice and not a pointer to an array.
	PrintUserArray_Slice(users[0..]); //Instead of creating a pointer we use a slice
	
	//Normally it's best to send a slice/pointer to another function because then you don't want to
	//copy the data, which is slow.
	
	//Imagine you have a struct that has 5 u8 arrays with a length of 60.
	//A u8 is one byte, so (1 x 60) x 5 = 300bytes.
	//Now you have an array with 500 of these structs which is 150KB of data. If you want to print all of these in another 
	//function that's how much you would have to copy.
	//If you use a slice then a slice is a pointer, which is 64 bits, and a length which is probably the same.
	//16bytes vs 150KB, obviously the slice is preferable.
	
	//The problem with pointers in c is that you don't actually know what you are getting.
	//When you get a 'const char *' in c and c++, is it a single character? Is it an array of characters?
	//Is it a multidimensional array of characters?
	//You don't know unless you pass some other bits of information.
	
	//Pointer arithmetic is possible in zig but not recommended. It's a lot safer to use slices.
	//As a slice is a pointer with a length, you always know the size.

	Print("\n   Pointer to arrays:\n", .{});
	//What you can also do is create an array of pointers:

	const array: [3]u8 = [3]u8{1, 2, 3};
	const arrayPointers: [*]const u8 = &array; //This is an array of pointers
	//So we have a group of pointers together: { pointer1 = &array[0], pointer2 = &array[1], pointer3 = &array[2] }
	
	Print("   values:\n", .{});
	//I'm not sure how you use a normal for loop with an array of pointers as the compiler says that 
	//pointer arrays have no upper bound so the loop goes forever.
	//Instead we use a for loop with the length
	const arrayLength = array.len;
	for (0..arrayLength) |index| { //usize for the index
		Print("   {}, ", .{arrayPointers[index]});
		//I have no idea why but we don't need to dereference array pointers.
		//I guess it's not possible to see the memory address directly.
	}
	Print("\n", .{}); //new line
	
	//Slices are still preferred over this
	//If you have an array of 50 elements and then creates a pointer array to that then 
	//a pointer is usually 8 bytes. 8 * 50 = 400bytes, whereas a slice would be 16bytes.
	
	//So most of the time you should use slices.
	//They are safer, as they have the length includes, can use for loop and are smaller.
}

