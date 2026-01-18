const std = @import("std");
const Allocator = std.mem.Allocator;

pub const TrackingAllocator = struct {
	
    parent_allocator: std.mem.Allocator,
    bytes_allocated: usize = 0,
    allocation_count: usize = 0,
    free_count: usize = 0,

    const Self = @This();

    /// Initialize a tracking allocator wrapping a parent allocator
    pub fn init(parent_allocator:Allocator) Self {
        return .{
            .parent_allocator = parent_allocator,
        };
    }

    /// Get a std.mem.Allocator interface for this tracking allocator
    pub fn allocator(self:*Self) Allocator {
        return .{
            .ptr = self,
            .vtable = &.{
                .remap = remap,
                .alloc = alloc,
                .resize = resize,
                .free = free,
            },
        };
    }

    /// Print current statistics
    pub fn printStats(self: *const Self) void {
        std.debug.print("=== Allocator Statistics ===\n", .{});
        std.debug.print("\tBytes allocated: {d}\n", .{self.bytes_allocated});
        std.debug.print("\tAllocation count: {d}\n", .{self.allocation_count});
        std.debug.print("\tFree count: {d}\n", .{self.free_count});
        std.debug.print("\tActive allocations: {d}\n", .{self.allocation_count - self.free_count});
    }

    pub fn assertNoLeaks(self:*const Self) void {
        std.debug.assert(self.allocation_count == self.free_count);
    }

    fn remap(ctx:*anyopaque, buf:[]u8, buf_align:std.mem.Alignment, new_len:usize, ret_addr:usize) ?[*]u8 {
        const self: *Self = @ptrCast(@alignCast(ctx));
        
        const old_len = buf.len;
        const result = self.parent_allocator.rawRemap(buf, buf_align, new_len, ret_addr);
        
        if (result) |_| {
            // Adjust byte count based on size change
            if (new_len > old_len) {
                self.bytes_allocated += (new_len - old_len);
            } else {
                self.bytes_allocated -= (old_len - new_len);
            }
        }
        
        return result;
    }

    /// Reset statistics
    pub fn reset(self: *Self) void {
        self.bytes_allocated = 0;
        self.allocation_count = 0;
        self.free_count = 0;
    }

    // VTable implementation functions
    fn alloc(ctx:*anyopaque, len:usize, ptr_align:std.mem.Alignment, ret_addr:usize) ?[*]u8 {
        const self: *Self = @ptrCast(@alignCast(ctx));
        
        const result = self.parent_allocator.rawAlloc(len, ptr_align, ret_addr);
        if (result) |_| {
            self.bytes_allocated += len;
            self.allocation_count += 1;
        }
        
        return result;
    }

    fn resize(ctx:*anyopaque, buf:[]u8, buf_align:std.mem.Alignment, new_len:usize, ret_addr:usize) bool {
		
        const self: *Self = @ptrCast(@alignCast(ctx));
        
        const old_len = buf.len;
        const result = self.parent_allocator.rawResize(buf, buf_align, new_len, ret_addr);
        
        if (result) {
            // Adjust byte count based on size change
            if (new_len > old_len) {
                self.bytes_allocated += (new_len - old_len);
            } else {
                self.bytes_allocated -= (old_len - new_len);
            }
        }
        
        return result;
    }

    fn free(ctx:*anyopaque, buf:[]u8, buf_align:std.mem.Alignment, ret_addr:usize) void {
		
        const self: *Self = @ptrCast(@alignCast(ctx));
        
        self.parent_allocator.rawFree(buf, buf_align, ret_addr);
        self.bytes_allocated -= buf.len;
        self.free_count += 1;
    }
};
