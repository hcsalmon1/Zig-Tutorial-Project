const std = @import("std");
const GeneralPurposeAllocator = std.heap.GeneralPurposeAllocator;
const tracking_allocator = @import("TrackingAllocator.zig");
const TrackingAllocator = tracking_allocator.TrackingAllocator;
const Allocator = std.mem.Allocator;

const NodeI32 = struct {
    data:i32,
    next_node:?*NodeI32,
};

fn createNodeI32(data:i32, allocation_tracker:*TrackingAllocator) *NodeI32 {
    const node:*NodeI32 = allocation_tracker.debugCreate(NodeI32) catch unreachable;
    
    node.*.data = data;
    node.*.next_node = null;
    return node;
}

fn createLinkedListI32() LinkedListI32 {
    return LinkedListI32 {
        .source_node = null,
        .length = 0,
    };
}

const LinkedListI32 = struct {

    source_node:?*NodeI32,
    length:usize,

    pub fn append(self:*LinkedListI32, data:i32, allocation_tracker:*TrackingAllocator) void {
        //Create the new node
        const newNode:*NodeI32 = createNodeI32(data, allocation_tracker);

        //if the first node is empty
        if (self.source_node == null) {
            //set this as the first node
            self.source_node = newNode;
            self.length += 1;
            return;
        }

        //if the first node isn't empty

        //find the first node that's null
        var temp:?*NodeI32 = self.source_node;
        while (temp.?.*.next_node != null) {
            temp = temp.?.*.next_node;
        }
        //add the new node to the end of the list
        temp.?.*.next_node = newNode;
        self.length += 1;
    }

    pub fn insert(self:*LinkedListI32, data:i32, position:usize, allocation_tracker:*TrackingAllocator) void {
        //Create the new node
        const newNode:*NodeI32 = createNodeI32(data, allocation_tracker);

        //if the position of the new node is the route
        if (position == 0) {
            //Set the next node of the new node to the original source node
            newNode.*.next_node = self.source_node;
            self.*.source_node = newNode;
            self.length += 1;
            return;
        }

        //The temp node is used to increment through each element
        var temp:?*NodeI32 = self.source_node;
        var node_count:usize = 0;
        while (true) {
            if (node_count > 100) {
                std.debug.print("infinite loop stopped, insert\n",.{});
                break;
            }
            if (temp == null) {
                break;
            }
            if (node_count >= position - 1) {
                break;
            }
            temp = temp.?.next_node;
            node_count += 1;
        }

        if (temp == null) {
            std.debug.print("Position out of bounds\n", .{});
            //delete newNode;
            return;
        }

        newNode.*.next_node = temp.?.*.next_node;
        temp.?.*.next_node = newNode;
        self.length += 1;
    }

    fn remove(self:*LinkedListI32, data:i32, allocation_tracker:*TrackingAllocator) void {
        //if the list is empty
        if (self.source_node == null) {
            return;
        }

        //if the first node has the same data
        if (self.source_node.?.*.data == data) {
            const temp:*NodeI32 = self.source_node.?;
            //Move the next node to his position
            self.source_node = self.source_node.?.next_node;
            allocation_tracker.debugDestroy(NodeI32, temp);
            self.length -= 1;
            return;
        }

        var temp:*NodeI32 = self.source_node.?;
        //if the next node isn't empty and the data doesn't match
        while (true) {
            //If the next node is null then we didn't find the data
            if (temp.*.next_node == null) {
                std.debug.print("Element not found",.{});
                return;
            }
            //if the data matches, end the loop
            if (temp.*.next_node.?.*.data == data) {
                break;
            }
            //Look at the next node
            temp = temp.*.next_node.?;
        }

        const node_to_delete:*NodeI32 = temp.next_node.?;
        //set the next node to the node after
        temp.*.next_node = temp.*.next_node.?.*.next_node;
        //delete the found node
        allocation_tracker.debugDestroy(NodeI32, node_to_delete);
        self.length -= 1;
    }

    fn remove_index(self:*LinkedListI32, index_to_delete:usize, allocation_tracker:*TrackingAllocator) void {
        //if the list is empty
        if (self.source_node == null) {
            return;
        }

        if (index_to_delete >= self.length) {
            std.debug.print("Index: {}, out of range, length: {}\n", .{index_to_delete, self.length});
            return;
        }

        if (index_to_delete == 0) {
            const temp:*NodeI32 = self.source_node.?;
            //Move the next node to his position
            self.source_node = self.source_node.?.next_node;
            allocation_tracker.debugDestroy(NodeI32, temp);
            self.length -= 1;
            return;
        }

        var temp:*NodeI32 = self.source_node.?;
        var index_count:usize = 1;
        //if the next node isn't empty and the data doesn't match
        while (true) {
            //If the next node is null then we didn't find the data
            if (temp.*.next_node == null) {
                std.debug.print("Index not found",.{});
                return;
            }
            //if the data matches, end the loop
            if (index_count == index_to_delete) {
                break;
            }
            //Look at the next node
            temp = temp.*.next_node.?;
            index_count += 1;
        }

        const node_to_delete:*NodeI32 = temp.next_node.?;
        //set the next node to the node after
        temp.*.next_node = temp.*.next_node.?.*.next_node;
        //delete the found node
        allocation_tracker.debugDestroy(NodeI32, node_to_delete);
        self.length -= 1;

    }

    fn print(self:LinkedListI32) void {
        var temp:?*NodeI32 = self.source_node;
        while (temp != null) {
            std.debug.print("{} -> ",.{temp.?.*.data});
            temp = temp.?.*.next_node;
        }
        std.debug.print("null\n", .{});
    }

    fn printLength(self:LinkedListI32) void {
        std.debug.print("Length: {}\n",.{self.length});
    }

    fn clear(self:*LinkedListI32, allocation_tracker:*TrackingAllocator) void {
        while (self.*.source_node != null) {
            const temp:?*NodeI32 = self.*.source_node;
            self.*.source_node = self.*.source_node.?.*.next_node;
            allocation_tracker.debugDestroy(NodeI32, temp.?);
        }
        self.length = 0;
    }
};


pub fn testList() void {

    var general_purpose_allocator = GeneralPurposeAllocator(.{}){};
    var gpa_allocator:Allocator = general_purpose_allocator.allocator();
    var allocation_tracker:TrackingAllocator = tracking_allocator.init(&gpa_allocator);

    testLinkedListI32(&allocation_tracker);
}

fn testLinkedListI32(allocation_tracker:*TrackingAllocator) void {
    var list: LinkedListI32 = createLinkedListI32();
    defer list.clear(allocation_tracker);
    list.append(1, allocation_tracker);
    list.append(2, allocation_tracker);
    list.append(3, allocation_tracker);
    list.print(); // Output: 1 -> 2 -> 3 -> null

    list.insert(0, 0, allocation_tracker);
    list.print(); // Output: 0 -> 1 -> 2 -> 3 -> null

    list.insert(4, 4, allocation_tracker);
    list.print(); // Output: 0 -> 1 -> 2 -> 3 -> 4 -> null

    list.remove(2, allocation_tracker);
    list.print(); // Output: 0 -> 1 -> 3 -> 4 -> null

    list.remove_index(3, allocation_tracker);

    list.print();

}

