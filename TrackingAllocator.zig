const std = @import("std");


const BITS_IN_BYTE = 8;
const BYTES_IN_MEGABYTE = 1000;

//Creates the Tracking Allocator
pub fn init(allocator: *std.mem.Allocator) TrackingAllocator {
    return TrackingAllocator {
        .allocator = allocator,
        .allocated_bytes = 0,
    };
}

//Prints the size in bytes of a type with a size
//Example: i32 = 4 bytes number = 100
//  4 * 100 = 400 bytes
pub fn printSizeInBytes(comptime T: type, number: usize) void {
    const SIZE_IN_BYTES = @sizeOf(T) * number;
    std.debug.print("     size: {} bytes\n",.{SIZE_IN_BYTES});
}

pub const TrackingAllocator = struct {
	allocator: *std.mem.Allocator,
	allocated_bytes: usize,

	pub fn alloc(self:*TrackingAllocator, comptime T: type, n: usize) ![]T {
		const slice:[]T = try self.allocator.alloc(T, n);
		self.allocated_bytes += @sizeOf(T) * n;
		return slice;
	}

	pub fn create(self:*TrackingAllocator, comptime T: type) !*T {
		const memory:*T = try self.allocator.create(T);
		self.allocated_bytes += @sizeOf(T);
		return memory;
	}

	pub fn free(self: *TrackingAllocator, comptime T: type, slice: []T) void {
		if (slice.len > 0) {
			self.allocated_bytes -= @sizeOf(T) * slice.len;
			self.allocator.free(slice);
		}
	}

	pub fn destroy(self: *TrackingAllocator, comptime T: type, memory: *T) void {
		self.allocated_bytes -= @sizeOf(T);
		self.allocator.destroy(memory);
	}

	pub fn debugAlloc(self: *TrackingAllocator, comptime T: type, n: usize) ![]T {
		const ALLOCATED_BYTES_BEFORE:usize = self.allocated_bytes;
		const slice:[]T = try self.allocator.alloc(T, n);
		self.allocated_bytes += @sizeOf(T) * n;
		const JUST_ALLOCATED = self.allocated_bytes - ALLOCATED_BYTES_BEFORE;
		std.debug.print("allocated {}, current bytes: {}\n",.{JUST_ALLOCATED, self.allocated_bytes});
		return slice;
	}

	pub fn debugFree(self: *TrackingAllocator, comptime T: type, slice: []T) void {
		if (slice.len > 0) 	{
			const ALLOCATED_BYTES_BEFORE: usize = self.allocated_bytes;
			self.allocated_bytes -= @sizeOf(T) * slice.len;
			self.allocator.free(slice);
			const BYTES_FREED:usize = ALLOCATED_BYTES_BEFORE - self.allocated_bytes;
			std.debug.print("freed {} bytes, current bytes: {}\n",.{BYTES_FREED, self.allocated_bytes});
		}
	}

	pub fn debugCreate(self: *TrackingAllocator, comptime T: type) !*T {
		const ALLOCATED_BYTES_BEFORE:usize = self.allocated_bytes;
		const memory:*T = try self.allocator.create(T);
		self.allocated_bytes += @sizeOf(T);
		const JUST_ALLOCATED = self.allocated_bytes - ALLOCATED_BYTES_BEFORE;
		std.debug.print("allocated {}, current bytes {}\n",.{JUST_ALLOCATED, self.allocated_bytes});
		return memory;
	}

	pub fn debugDestroy(self: *TrackingAllocator, comptime T: type, memory: *T) void {
		const ALLOCATED_BYTES_BEFORE: usize = self.allocated_bytes;
		self.allocated_bytes -= @sizeOf(T);
		self.allocator.destroy(memory);
		const BYTES_FREED:usize = ALLOCATED_BYTES_BEFORE - self.allocated_bytes;
		std.debug.print("freed {} bytes, current bytes: {}\n",.{BYTES_FREED, self.allocated_bytes});
	}

	pub fn bytesAllocated(self: *TrackingAllocator) usize {
		return self.allocated_bytes;
	}

	pub fn printBytes(self:TrackingAllocator) void {
		std.debug.print("     Memory: {} bytes\n",.{self.allocated_bytes});
	}

	pub fn printBits(self:TrackingAllocator) void {
		std.debug.print("     Memory: {} bits\n",.{self.allocated_bytes * BITS_IN_BYTE});
	}

	pub fn printMegaBytes(self: TrackingAllocator) void {
		const ALLOCATED_BYTES_U64: f64 = @floatFromInt(self.allocated_bytes);
		const SIZE_IN_MEGABYTES: f64 = ALLOCATED_BYTES_U64 / @as(f64, BYTES_IN_MEGABYTE);

		std.debug.print("     Memory: {d:.3}",.{SIZE_IN_MEGABYTES});
	}

};
