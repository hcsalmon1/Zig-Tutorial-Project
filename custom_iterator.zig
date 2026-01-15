
const std = @import("std");

pub fn assert(ok: bool) void {
    if (!ok) unreachable; // assertion failure
}

fn twoSlicesAreTheSame(first_slice:[]const u8, second_slice:[]const u8) bool {
	const FIRST_SLICE_LENGTH:usize = first_slice.len;

	if (FIRST_SLICE_LENGTH != second_slice.len)
	{
		return false;
	}
	for (0..FIRST_SLICE_LENGTH) |index|
	{
		if (first_slice[index] != second_slice[index])
		{
			return false;
		}
	}
	return true;
}

pub fn initSingle(buffer:[]const u8, delimiter:u8) CustomIteratorSingle {
    return CustomIteratorSingle {
        .buffer = buffer,
        .index = 0,
        .delimiter = delimiter,
    };
}

pub const CustomIteratorSingle = struct {
    buffer: []const u8,
    index: ?usize,
    delimiter: u8,

    //Get the first element, only can be called once
    pub fn first(self: *CustomIteratorSingle) []const u8 {
        //error if index isn't 0
        assert(self.index.? == 0);
        return self.next().?;
    }

    //Get the next element, returns an optional
    pub fn next(self: *CustomIteratorSingle) ?[]const u8 {
        const start_index:?usize = self.index orelse return null;
        const end_index:?usize = findLetter(self.*, start_index);

        //if no delimiter found
        if (end_index == null) {
            return null;
        }
        //if not null
        self.index.? = end_index.? + 1;
        return self.buffer[start_index.?..end_index.?];
    }

    //Look at the next index, 
    pub fn peek(self: *CustomIteratorSingle) ?[]const u8 {
        const start_index:?usize = self.index orelse return null;
        const end_index:?usize = findLetter(self.*, start_index);

        if (end_index == null) {
            return null;
        }
        return self.buffer[start_index.?..end_index.?];
    }


    fn findLetter(self:CustomIteratorSingle, start_index:?usize) ?usize {

        if (start_index == null) {
            return null;
        }
        var end_index:?usize = null;
        //loop through the letters
        for (start_index.?..self.buffer.len) |index| {
            //if the letter is the delimiter letter
            if (self.buffer[index] == self.delimiter) {
                end_index = index;
                break;
            }
        }
        return end_index;
    }

    // Returns a slice of the remaining characters. Does not affect iterator state.
    pub fn rest(self: CustomIteratorSingle) []const u8 {
        const end:usize = self.buffer.len;
        const start:usize = self.index orelse end;
        return self.buffer[start..end];
    }

    /// Resets the iterator to the initial slice.
    pub fn reset(self: *CustomIteratorSingle) void {
        self.index = 0;
    }

};

pub fn initSlice(buffer:[]const u8, delimiter:[]const u8) CustomIteratorSlice {
    return CustomIteratorSlice {
        .buffer = buffer,
        .index = 0,
        .delimiter = delimiter,
    };
}

pub const CustomIteratorSlice = struct {
    buffer: []const u8,
    index: ?usize,
    delimiter: []const u8,

    //Get the first element, only can be called once
    pub fn first(self: *CustomIteratorSlice) []const u8 {
        //error if index isn't 0
        assert(self.index.? == 0);
        return self.next().?;
    }

    pub fn next(self: *CustomIteratorSlice) ?[]const u8 {

        const start_index:?usize = self.index orelse return null;
        const end_index:?usize = findSlice(self.*, start_index);

        //if the slice delimiter wasn't found
        if (end_index == null) {
            return null;
        }
        //if not null
        self.index.? = end_index.? + self.delimiter.len;
        return self.buffer[start_index.?..end_index.?];
    }

    pub fn peek(self: *CustomIteratorSlice) ?[]const u8 {
        const start_index:?usize = self.index orelse null;
        const end_index:?usize = findSlice(self.*, start_index);

        if (start_index == null) {
            return null;
        }
        if (end_index == null) {
            return null;
        }
        return self.buffer[start_index.?..end_index.?];
    }


    fn findSlice(self:CustomIteratorSlice, start_index:?usize) ?usize {
        if (start_index == null) {
            return null;
        }
        var end_index:?usize = null;
        //loop through the letters
        for (start_index.?..self.buffer.len) |index| {
            if (self.delimiter.len - 1 + index >= self.buffer.len) {
                break;
            }
            //if the letter is the first delimiter letter
            if (self.buffer[index] != self.delimiter[0]) {
                //utils.printVariableMessageln("   set end index to ", index);
                continue;
            }
            const TEMP_END_INDEX = index + self.delimiter.len;
            if (twoSlicesAreTheSame(self.buffer[index..TEMP_END_INDEX], self.delimiter[0..]) == true) {
                end_index = index;
                break;
            }
        }
        return end_index;
    }

    // Returns a slice of the remaining characters. Does not affect iterator state.
    pub fn rest(self: CustomIteratorSlice) []const u8 {
        const end:usize = self.buffer.len;
        const start:usize = self.index orelse end;
        return self.buffer[start..end];
    }

    /// Resets the iterator to the initial slice.
    pub fn reset(self: *CustomIteratorSlice) void {
        self.index = 0;
    }

};
