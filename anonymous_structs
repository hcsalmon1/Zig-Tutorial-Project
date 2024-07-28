
const std = @import("std");

fn Colour(comptime T: type) type 
{
    return struct 
	{
        r: T,
        g: T,
        b: T,
    };
}

const Color255 = struct
{
	r: u8,
	g: u8,
	b: u8,
};
const Color01 = struct
{
	r: f32,
	g: f32,
	b: f32,
};

fn PrintColour(colour: anytype) void
{
	std.debug.print("Colour: r {} g {} b {}\n", 
	.{
		colour.r, colour.g, colour.b
	});
}

pub fn showAnonymousStructs() void
{
	const colour255 = Colour(u8)
	{
		.r = 200,
		.g = 0,
		.b = 0,
	};
	
	const colour01 = Colour(f32)
	{
		.r = (200.0 / 255.0),
		.g = 0,
		.b = 0,
	};
	
	PrintColour(colour255);
	PrintColour(colour01);

}
