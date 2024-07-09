const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;
const test_allocator = std.testing.allocator;

pub fn run () void
{
    allocatingMemory() catch |err|
	{
		print("{}\n",.{err});
	};
}

//Allocating syntax:
//          Syntax depends on the allocator:
//          PAGE ALLOCATOR:
//          const page_allocator = std.heap.page_allocator;     - gets the page allocator
//          const VARIABLE:*u8 = page_allocator.create(u8);     - creates a pointers to a heap variable
//          defer page_allocator.destroy(VARIABLE);             - the defer keyword will run this code whenever the scope ends, 

//          FIXES BUFFER ALLOCATOR:
//          var buffer: [100]u8 = undefined;                    - buffer for the allocator 
//          const fb_allocator = std.heap.FixedBufferAllocator.init(&buffer); - initiates and gets the fixed buffer allocator
//          const memory = try fba_allocator.alloc(u8, 100);    - allocated memory
//          fb_allocator.free(memory);                          - frees memory
//          defer fb_allocator.deinit();                        - deinitialises the allocator at the end of scope
          



fn allocatingMemory() !void
{

	print("Allocating Memory:\n", .{});
	//Allocators
	
	//_____C_ALLOCATOR______:
	
	//uses the standard allocator in c
	//requires you to link libc. You do this by adding: '-lc'
	//at the end when you run the application, example: 'zig run name.zig -lc'
		
	//This is normally used when you want to import a c library.
	
	//_____PAGE_ALLOCATOR______:
	
	//This allocator will make a system call every time you want to allocate and free.
	//So it's slow but more reliable.
	
	//______FIXED BUFFER ALLOCATOR______:
	
	//Will not allocate on the heap. If you know the amount
	//of data at compile time and want to be efficient, use this allocator.

	//____ARENA_ALLOCATOR____:
	
	//This is allows you to allocate memory multiple times and then free it
	//all at once.

	//_____GENERAL_PURPOSE_ALLOCATOR____:
	
	//This is the safest allocator and has lots of safety checks for double
	//free and memory leaks. Use this allocator to be safe at the slight cost
	//to performance.


    //By default variables will be saved on the stack. This is temporary memory that each function is given to create
    //variables. It is fast and will be deleted when the function or the scope is over.

    //Scope normally means any form of curly brackets. If you create a variable in curly brackets, like in an if statement,
    //then it will only exist within those brackets. After it will be deleted.

    {
        var temporary_number:u8 = 10;
        while (temporary_number > 100)
        {
            temporary_number += 10;
        }
    } //the scope ends here

    //Print("Temp number: {}", .{temporaryNumber}); //uncomment for error

    //You can't use a variable out of scope because this is a temporary stack variable.

    //Heap variables, however, are permanent variables until they are deleted. You need to ask the operating system
    //for some memory and it has to be freed by you. This is slow but the memory is permanent.

    //To allocate memory in zig you need to use an allocator. There are different types for different tasks.
    //The most basic allocator is the 'page_allocator':

    const page_allocator = std.heap.page_allocator; //we get the allocator from the standard library

    const heap_memory = try page_allocator.create(u8);

    heap_memory.* = 'a'; //allocating memory will create a pointer to that memory. To set the value we use '.*' this is because a pointer is
    //a memory address and we want to change the data at that memory address and not the address itself.

    print("   Heap memory created: {}\n\n", .{heap_memory.*});

    defer std.heap.page_allocator.destroy(heap_memory); //This will delete the memory when it's not being used.

    //The defer keyword will run the written code at the end of the current scope. This is an efficient way to make sure
    //that you free any memory that you have created.

    //if you don't free memory then you can have what's called a memory leak. This is where a program will permanently
    //take some of your system memory while opened because it was never freed. If you allocate memory in an infinite loop
    //then you can also take all of the memory from someone's system until it runs out.

    //Here is an example of an infinite loop memory leak, warning this may crash your computer so use at your own risk:

    //Uncomment to see the memory leak

    //Print("WARNING: Memory leak started. Close the program to stop it\n", .{});

    //var integerList = ArrayList(i32).init(pageAllocator);
    //var whileCount:i32 = 0;

    //while (true) //go forever
    //{
    //    whileCount += 1;
    //    try integerList.append(whileCount); //add to the list
    //    if (whileCount >= 2147483647) //stops an integer overflow
    //    {
    //        whileCount = 0;
    //    }
    //}

    //For this reason you should avoid allocating memory in while loop and always try to use 'defer' after each allocation.

    //If you know the size of the allocation then you can choose the 'FixedBufferAllocator'.
    //This allocator will not actually heap allocate but will give an error if you go over the listed size.

    print("   Printing Fixed buffer:\n", .{});
    var buffer: [100]u8 = undefined; //creates an array with hundred
    var fba:std.heap.FixedBufferAllocator = std.heap.FixedBufferAllocator.init(&buffer); //this sets the size of the buffer to 100 u8, so 100 bytes
    const fba_allocator:std.mem.Allocator = fba.allocator();

    const memory = try fba_allocator.alloc(u8, 100); //then we create the memory
    memory[0] = 'a';
    memory[1] = 'b';
    memory[2] = 'c';
    memory[3] = 'd';
    const slice = memory[0..4];

    print("   memory: {s}\n", .{slice});

    defer fba_allocator.free(memory); //then we free the data when out of scope
	

    //if allocate with a size higher than defined we will get an error / crash:

    //remove comments to see:

    //var buffer2: [100]u8 = undefined; //creates an array with hundred
    //var fba2 = std.heap.FixedBufferAllocator.init(&buffer2); //this sets the size of the buffer to 100 u8, so 100 bytes
    //const allocator2 = fba2.allocator();

    //const errorAllocating = try allocator2.alloc(u8, 110);
    //defer allocator2.free(errorAllocating);

    //this crashes because we set the buffer2 to 100 and then tried to allocate 110.

	//Often a good practice is to create an allocator in a main place and send them to
	//functions that will allocate. This way you know which functions are allocating memory.


}
