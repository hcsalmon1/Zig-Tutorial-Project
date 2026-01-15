const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;

pub fn run() void {
	print("\nShowing arraylists:\n\n", .{});
	showingArrayList();
}


//ArrayList Syntax:

//  var list = std.ArrayList('TYPE').init('ALLOCATOR'); - create the arrayList
//  list.deinit(); - destroys the arrayList
//  list.append('TYPE'); - adds to list
//  list.items[0] - gets the first index of the list
//  list.items.len - gets the current size of the list
//  list.clearAndFree - clears the list and frees the memory but the list is still usable

const Vector3 = struct {
	x: f64,
	y: f64,
	z: f64,
};

const Location = struct {
	position:Vector3,
	name: []const u8,
	id_no: Location_ID,
};

fn getDistance(location_a:Vector3, location_b:Vector3) f64 {
	const bx_minus_ax:f64 = location_b.x - location_a.x;
	const by_minus_ay:f64 = location_b.y - location_a.y;
	const bz_minus_az:f64 = location_b.z - location_a.z;
	
	const distance_squared:f64 = (bx_minus_ax * bx_minus_ax) + (by_minus_ay * by_minus_ay) + (bz_minus_az * bz_minus_az);
	return std.math.sqrt(distance_squared);
}

fn printVector3(position:Vector3) void {
	print("position - x: {}, y: {}, z: {}\n",  
	.{
		position.x, position.y, position.z
	});
}

const Location_ID = enum {
	home,
	park,
	shop,
	work,
	gym,	
};

const home_position:Vector3 = .{
	.x = 0,
	.y = 0,
	.z = 0,
};

const park_position:Vector3 = .{
	.x = 50,
	.y = 0,
	.z = 50,
};

const shop_position:Vector3 = .{
	.x = -150,
	.y = 0,
	.z = -5,
};

const work_position:Vector3 = .{
	.x = -500,
	.y = 0,
	.z = -200,
};

const gym_position:Vector3 = .{
	.x = -200,
	.y = 0,
	.z = 100,
};

const home:Location = .{
	.position = home_position,
	.name = "home",
	.id_no = Location_ID.home,
};

const work:Location = .{
	.position = work_position,
	.name = "work",
	.id_no = Location_ID.work,
};

const shop:Location = .{
	.position = shop_position,
	.name = "shop",
	.id_no = Location_ID.shop,
};

const gym:Location = .{
	.position = gym_position,
	.name = "gym",
	.id_no = Location_ID.gym,
};

const park:Location = .{
	.position = park_position,
	.name = "park",
	.id_no = Location_ID.park,
};


fn showingArrayList() void {
	

	//Arraylists are dynamic arrays, meaning arrays which can grow and shrink in size.
	//For this we need to allocate memory as the compiler won't know the size at compile time.
	
	//In this example I create a list of locations and count the total distance going through all of them.

	//We get the general purpose allocator
	var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const gpa_allocator = gpa.allocator();
	
	//We create the array list using the allocator
	var journey_list = ArrayList(Location).initCapacity(gpa_allocator, 0) catch return;
	print("   type of arraylist: {}\n", .{@TypeOf(journey_list)});
	defer journey_list.deinit(gpa_allocator); //we free the memory at the end of scope
	
	//create the list
	journey_list.append(gpa_allocator, home) catch unreachable;
	journey_list.append(gpa_allocator, park) catch unreachable;
	journey_list.append(gpa_allocator, gym) catch unreachable;
	journey_list.append(gpa_allocator, work) catch unreachable;
	journey_list.append(gpa_allocator, shop) catch unreachable;
	journey_list.append(gpa_allocator, home) catch unreachable;
	
	//We send the memory address of the list
	calculateAndPrintDistance(&journey_list);
	
}

fn calculateAndPrintDistance(journey_list: *ArrayList(Location)) void {
	//We send a pointer to the arraylist, so we don't copy it
	
	const JOURNEY_LENGTH = journey_list.items.len;
	print("   length: {}\n", .{JOURNEY_LENGTH});
	
	var totalDistance:f64 = 0;
	
	//we loop through all the locations and count the distance between them
	for (0..JOURNEY_LENGTH) |index| {

		const NEXT_INDEX:usize = index + 1;
		if (NEXT_INDEX >= JOURNEY_LENGTH) {
			break;
		}
		const position_a:Vector3 = journey_list.items[index].position;
		const position_b:Vector3 = journey_list.items[NEXT_INDEX].position;
		
		const distance_between_points = getDistance(position_a,position_b); //We get the distance between points
		
		totalDistance += distance_between_points;
		print("   {s} to {s}, distance: {d:.3}\n", 
		.{
			journey_list.items[index].name, 
			journey_list.items[NEXT_INDEX].name, 
			distance_between_points
		});
	}

	print("   total distance: {d:.3}\n",.{totalDistance});
	
}