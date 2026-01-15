
const std = @import("std");
const GeneralPurposeAllocator = std.heap.GeneralPurposeAllocator;
const tracking_allocator = @import("TrackingAllocator.zig");
const TrackingAllocator = tracking_allocator.TrackingAllocator;
const Allocator = std.mem.Allocator;


fn Node(comptime T:type) type {

    return struct {
        data:T,
        next_node:?*Node(T),
    };
}

fn LinkedList(comptime T: type) type {
    return struct 
	{
       	source_node:?*Node(T),
       	length:usize,

       	const This = @This();

       	pub fn append(self:*This, data:T, allocation_tracker:*TrackingAllocator) void {
			//Create the new node
			const newNode:*Node(T) = createNode(T,data, allocation_tracker);

			//if the first node is empty
			if (self.source_node == null) {
				//set this as the first node
				self.source_node = newNode;
				self.length += 1;
				return;
			}

			//if the first node isn't empty

			//find the first node that's null
			var temp:?*Node(T) = self.source_node;
			while (temp.?.*.next_node != null) {
				temp = temp.?.*.next_node;
			}
			//add the new node to the end of the list
			temp.?.*.next_node = newNode;
			self.length += 1;
		}

		pub fn insert(self:*This, data:T, position:usize, allocation_tracker:*TrackingAllocator) void {
			//Create the new node
			const newNode:*Node(T) = createNode(T, data, allocation_tracker);

			//if the position of the new node is the route
			if (position == 0) {
				//Set the next node of the new node to the original source node
				newNode.*.next_node = self.source_node;
				self.*.source_node = newNode;
				self.length += 1;
				return;
			}

			//The temp node is used to increment through each element
			var temp:?*Node(T) = self.source_node;
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

		fn remove(self:*This, data:T, allocation_tracker:*TrackingAllocator) void {
			//if the list is empty
			if (self.source_node == null) {
				return;
			}

			//if the first node has the same data
			if (self.source_node.?.*.data == data) {
				const temp:*Node(T) = self.source_node.?;
				//Move the next node to his position
				self.source_node = self.source_node.?.next_node;
				allocation_tracker.debugDestroy(Node(T), temp);
				self.length -= 1;
				return;
			}

			var temp:*Node(T) = self.source_node.?;
			//if the next node isn't empty and the data doesn't match
			while (true) {
				//If the next node is null then we didn't find the data
				if (temp.*.next_node == null) {
					std.debug.print("Element not found {}\n",.{data});
					return;
				}
				//if the data matches, end the loop
				if (temp.*.next_node.?.*.data == data) {
					break;
				}
				//Look at the next node
				temp = temp.*.next_node.?;
			}

			const node_to_delete:*Node(T) = temp.next_node.?;
			//set the next node to the node after
			temp.*.next_node = temp.*.next_node.?.*.next_node;
			//delete the found node
			allocation_tracker.debugDestroy(Node(T), node_to_delete);
			self.length -= 1;
		}

		fn remove_index(self:*This, index_to_delete:usize, allocation_tracker:*TrackingAllocator) void {
			//if the list is empty
			if (self.source_node == null) {
				return;
			}

			if (index_to_delete >= self.length) {
				std.debug.print("Index: {}, out of range, length: {}\n", .{index_to_delete, self.length});
				return;
			}

			if (index_to_delete == 0) {
				const temp:*Node(T) = self.source_node.?;
				//Move the next node to his position
				self.source_node = self.source_node.?.next_node;
				allocation_tracker.debugDestroy(Node(T), temp);
				self.length -= 1;
				return;
			}

			var temp:*Node(T) = self.source_node.?;
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

			const node_to_delete:*Node(T) = temp.next_node.?;
			//set the next node to the node after
			temp.*.next_node = temp.*.next_node.?.*.next_node;
			//delete the found node
			allocation_tracker.debugDestroy(Node(T), node_to_delete);
			self.length -= 1;
		}

		fn print(self:This) void {

			var temp:?*Node(T) = self.source_node;
			if (T == u8) {
				while (temp != null) {
					std.debug.print("{c} -> ",.{temp.?.*.data});
					temp = temp.?.*.next_node;
				}
			} else {
				while (temp != null) {
					std.debug.print("{} -> ",.{temp.?.*.data});
					temp = temp.?.*.next_node;
				}
			}

			std.debug.print("null\n", .{});
		}

		fn printLength(self:This) void {
			std.debug.print("Length: {}\n",.{self.length});
		}

		fn clear(self:*This, allocation_tracker:*TrackingAllocator) void {
			while (self.*.source_node != null) {
				const temp:?*Node(T) = self.*.source_node;
				self.*.source_node = self.*.source_node.?.*.next_node;
				allocation_tracker.debugDestroy(Node(T), temp.?);
			}
			self.length = 0;
		}
	};
}

fn createNode(comptime T:type, data:T, allocation_tracker:*TrackingAllocator) *Node(T) {
	const node:*Node(T) = allocation_tracker.debugCreate(Node(T)) catch unreachable;
    
	node.*.data = data;
	node.*.next_node = null;
	return node;
}

fn createLinkedList(comptime T:type) type {
	const list = LinkedList(T);
	list.source_node = null;
	list.length = 0;
	return list;
}

pub fn testList() void {

	var general_purpose_allocator = GeneralPurposeAllocator(.{}){};
	var gpa_allocator:Allocator = general_purpose_allocator.allocator();
	var allocation_tracker:TrackingAllocator = tracking_allocator.init(&gpa_allocator);

	//testLinkedListI32(&allocation_tracker);
	testLinkedList(&allocation_tracker);
}

fn testLinkedList(allocation_tracker:*TrackingAllocator) void {

	var list:LinkedList(u64) = LinkedList(u64){.source_node = null, .length = 0};
	defer list.clear(allocation_tracker);
	list.append(100000, allocation_tracker);
	list.append(200000, allocation_tracker);
	list.append(300000, allocation_tracker);
	list.print(); 

	list.insert(0, 0, allocation_tracker);
	list.print(); 

	list.insert(500000, 4, allocation_tracker);
	list.print(); 

	list.remove(200000, allocation_tracker);
	list.print(); 

	list.remove_index(3, allocation_tracker);

	list.print();

	list.clear(allocation_tracker);
}
