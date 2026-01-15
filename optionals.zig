const std = @import("std");

pub fn run() void {
	showingOptionals();
	optionalPointersYoDawg();
}

//Syntax:

//  const number:?i32 = null;  - an integer that could be null
//  const number_pointer:?*const i32 = &number; - an optional pointer to a non optional integer
//  const number_pointer:?*const ?i32 = &number; - an optional pointer to a non optional integer

//  if (number) |num| { //if 'number' isn't null, store in this non null variable
// 
//  } else { //if it is null
//
//  }

//   number.? - unwraps an optional to use the value, will be an error if it is null
//   number_pointer.?.*.? - unwraps the optional pointer, then dereferences the optional pointer
//                          then, as the variable is also an option you need to unwrap that too.

//    orelse - sets a value if a variable is null

fn getIndex() ?usize {
	return null;
}

fn showingOptionals() void {
	//Optionals are variables that could be null
	
	const number_array:[10]i32 = [10]i32 {1,2,3,4,5,6,7,8,9,10};
	const VALUE_TO_FIND = 5;
	var index:?usize = null;
	
	for (0..10) |i| {
		if (number_array[i] == VALUE_TO_FIND) {
			index = i;
			break;
		}
	}
	
	//To unwrap an optional you use '.?'
	
	//std.debug.print("index {}\n",.{index.?});
	
	//However this will be an error if the value is null.
	//Best is to check:
	
	if (index) |i| {
		std.debug.print("index {}, value: {}\n",.{i, number_array[i]});
	} else {
		std.debug.print("index is null\n",.{});
	}
	
	//'Orelse' will set a default value if the variable is null
	
	const found_index:?usize = getIndex() orelse 0;
	_ = found_index;
	//This will be zero as the value will be null.
	
}


/// Yo dawg, I heard you like optional pointers to optional variables,
/// so I made an optional pointer to an optional pointer to an optional pointer
/// to an optional pointer to an optional variable, so you can unwrap while you dereference 
/// while you unwrap while dereference while you unwrap and dereference while you unwrap and dereference.
fn optionalPointersYoDawg() void {
	//Here are some optional pointers. We need to unwrap and dereference them at the same time:
	//  .?.*
	//  .? unwraps, .* dereferences.
	//This can lead to memes like this:
	
	const number: ?i32 = 1;
	const number_pointer: ?*const ?i32 = &number;
	const number_pointer_pointer: ?*const ?*const ?i32 = &number_pointer;
	const number_pointer_pointer_pointer: ?*const ?*const ?*const ?i32 = &number_pointer_pointer;

	std.debug.print("number_pointer: {}\n",.{number_pointer.?.*.?});
	std.debug.print("number_pointer_pointer: {}\n",.{number_pointer_pointer.?.*.?.*.?});
	std.debug.print("number_pointer_pointer_pointer: {}\n",.{number_pointer_pointer_pointer.?.*.?.*.?.*.?});
}
