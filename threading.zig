const std = @import("std");
const print = std.debug.print;
const thread = std.Thread;
const Mutex = std.Thread.Mutex;

fn println(input:[]const u8) void
{
	print("{s}\n", .{input});
}

const ONE_SECOND = 1_000_000_000;


//Threading syntax:
//  create a thread:
//  const thread = std.Thread.spawn
//  (
//  .{}, //spawnConfig, above my pay grade
//  FUNCTION_NAME, //name of the function to run
//  .{PARAMETERS}, //parameters to put into to the function
//  ) catch unreachable; //if there is an error making a thread do something...
			
//  thread.join(); - will pause the current function and wait for the thread to finish.

//  mutexes:
//  create a mutex:
//  var mutex: std.Thread.Mutex = std.Thread.Mutex{};
//  mutex.tryLock(); - sees if you can lock the mutex without blocking, returns a bool
//  mutex.lock(); - locks the mutex so other threads can't access it
//  mutex.unlock(); - frees the mutex


pub fn run() void {
	//simpleExample();
	showMutex();
}

fn simpleExample() void {
	{
		
		println("started thread 1");
		const thread1 = thread.spawn(
			.{}, //spawnConfig - leave it empty
			count, //function to run
			.{1} //the parameters to the function
		) catch unreachable;
		
		defer thread1.join();
		
		println("started thread 2");
		const thread2 = thread.spawn(.{}, count, .{2}) catch unreachable;
		
		defer thread2.join();
		
		println("started thread 3");
		const thread3 = thread.spawn(.{}, count, .{3}) catch unreachable;
		
		defer thread3.join();

	}
	
	println("end function");
}

fn count(thread_index:u8) void {
	//print("  thread {} started\n",.{thread_index});
	var seconds_passed:u8 = 0;
	for (0..thread_index) |_| {
		std.time.sleep(ONE_SECOND * 5);
		seconds_passed += 1;
		print("  thread {} {} seconds\n", .{thread_index, seconds_passed * 5});
	}
	print("  thread {} ended\n", .{thread_index});
}

var count_mutex: Mutex = Mutex{};
var call_count:u32 = 0;

fn showMutex() void {
	{
		
		println("started thread 1");
		const thread1 = thread.spawn(.{}, countCalls, .{1}) catch unreachable;
		
		defer thread1.join();
		
		println("started thread 2");
		const thread2 = thread.spawn(.{}, countCalls, .{2}) catch unreachable;
		
		defer thread2.join();
		
		println("started thread 3");
		const thread3 = thread.spawn(.{}, countCalls, .{3}) catch unreachable;
		
		defer thread3.join();

	}
	
	print("   Call count: {}\n", .{call_count});
	print("   mutex example finished\n", .{});
	
}

fn countCalls(index:u32) void {
	const LOOP_COUNT = index * 1000;
	for (0..LOOP_COUNT) |_| {
		const canLock:bool = count_mutex.tryLock();
		
		if (canLock == true) { //the mutex can be acquired without interuption
			defer count_mutex.unlock();
			call_count += 1;
		} else {
			print("   Couldn't acquire lock mutex\n", .{});
			count_mutex.lock();
			defer count_mutex.unlock();
			call_count+= 1;
		}
	}
	print("   thread {} finished\n", .{index});
}
