const std = @import("std");
const print = std.debug.print;
const Con = @import("TTTConstants.zig");


var board = [9]u2 {
	Con.EMPTY, Con.EMPTY, Con.EMPTY,
	Con.EMPTY, Con.EMPTY, Con.EMPTY,
	Con.EMPTY, Con.EMPTY, Con.EMPTY,
};
var x_to_play = true;


fn printCommands() void {
	print("Commands:\n 1-9 selects the square\n 'quit' - quits the program\n '?' - list of commands\n\n", .{});
}
fn printBoard() void {
	
	const sq_1:u8 = Con.PIECE_CHARACTERS[board[@intFromEnum(Con.Squares.one)]];
	const sq_2:u8 = Con.PIECE_CHARACTERS[board[@intFromEnum(Con.Squares.two)]];
	const sq_3:u8 = Con.PIECE_CHARACTERS[board[@intFromEnum(Con.Squares.three)]];
	const sq_4:u8 = Con.PIECE_CHARACTERS[board[@intFromEnum(Con.Squares.four)]];
	const sq_5:u8 = Con.PIECE_CHARACTERS[board[@intFromEnum(Con.Squares.five)]];
	const sq_6:u8 = Con.PIECE_CHARACTERS[board[@intFromEnum(Con.Squares.six)]];
	const sq_7:u8 = Con.PIECE_CHARACTERS[board[@intFromEnum(Con.Squares.seven)]];
	const sq_8:u8 = Con.PIECE_CHARACTERS[board[@intFromEnum(Con.Squares.eight)]];
	const sq_9:u8 = Con.PIECE_CHARACTERS[board[@intFromEnum(Con.Squares.nine)]];
	
	const line_1 = "_______";
	const line_2 = [7]u8 {'|',sq_1,'|',sq_2,'|',sq_3,'|'};
	const line_3 = [7]u8 {'|',sq_4,'|',sq_5,'|',sq_6,'|'};
	const line_4 = [7]u8 {'|',sq_7,'|',sq_8,'|',sq_9,'|'};
	
	
	print("{s}\n", .{line_1});
	print("{s}\n", .{line_2[0..]});
	print("{s}\n", .{line_3[0..]});
	print("{s}\n\n", .{line_4[0..]});
	if (x_to_play == true)  {
		print("To play: X\n", .{});
	} else {
		print("To play: O\n", .{});
	}
	
	//_______
	//|O|X|_|
	//|_|_|_|
	//|_|_|_|
}

fn resetBoard() void {
	for (0..9) |index| {
		board[index] = Con.EMPTY;
	}
	x_to_play = true;
}

 
fn makeMove(index:u4) void {

	if (board[index] != Con.EMPTY) {
		print("Square occupied!\n", .{});
		return;
	}
	if (x_to_play == true) {
		board[index] = Con.X;
		x_to_play = false;
		printBoard();
		checkWinner();
		return;
	}
	
	board[index] = Con.O;
	x_to_play = true;
	printBoard();
	checkWinner();
}

fn checkWinner() void {
	const BIT_INDEX = [9]u9 {1, 2, 4, 8, 16, 32, 64, 128, 256 };
	
	var O_BITBOARD:u9 = 0;
	var X_BITBOARD:u9 = 0;
	var EMPTY_BITBOARD:u9 = 0;
	
	for (0..9) |index| {

		if (board[index] == Con.EMPTY) {
			EMPTY_BITBOARD |= BIT_INDEX[index];
			continue;
		}
		if (board[index] == Con.O) {
			O_BITBOARD |= BIT_INDEX[index];
			continue;
		}
		X_BITBOARD |= BIT_INDEX[index];
	}

	if (x_to_play == true) { //it was just O move, so check if O won

		for (0..8) |index| {

			if ((O_BITBOARD & Con.WIN_CHECK_BITBOARDS[index]) == Con.WIN_CHECK_BITBOARDS[index]) {
				o_Won();
				return;
			}
		}

	} else { //check if x won
		for (0..8) |index| {

			if ((X_BITBOARD & Con.WIN_CHECK_BITBOARDS[index]) == Con.WIN_CHECK_BITBOARDS[index]) {
				x_Won();
				return;
			}
		}
	}
	if (EMPTY_BITBOARD == 0) {
		draw();
	}
}

fn o_Won() void {
	print("\nO Won!\n", .{});
	resetBoard();
	printBoard();
}

fn x_Won() void {
	print("\nX Won!\n", .{});
	resetBoard();
	printBoard();
}

fn draw() void {
	print("\nDraw!\n", .{});
	resetBoard();
	printBoard();
}


fn slicesAreTheSame(first:[]const u8, second:[]const u8) bool {
	//print("called slices the same\n", .{});
	//print(" first: '{s}'\n", .{first});
	//print(" second: '{s}'\n", .{second});
	
	const FIRST_LENGTH = first.len - 1; //removing the new line character
	const SECOND_LENGTH = second.len;
	if (FIRST_LENGTH != SECOND_LENGTH) {
		//print(" different length - first {} second {}\n", .{FIRST_LENGTH, SECOND_LENGTH});
		return false;
	}
	
	for (0..FIRST_LENGTH) |index| {

		if (first[index] != second[index]) {
			//print(" not same - first {} second {}\n", .{first[index], second[index]});
			return false;
		}
	}
	//print(" The same\n", .{});
	return true;
}


fn processInput(input:[]const u8) bool {
		
	if (slicesAreTheSame(input, Con.QUIT) == true) { //if the user wrote "quit"
		return true;
	}
		
	if (slicesAreTheSame(input, Con.QUESTION_MARK) == true) { //if the user wrote "?"
		printCommands();
		return false;
	}
	
	var found_index:u4 = 0; //This will be the index where we make a move if that is the choice
	//loop 1-9
	for (Con.SQUARE_CHOICES) |choice| {

		if (slicesAreTheSame(input, choice) == true) {
			makeMove(found_index);
			return false;
		}
		found_index += 1;
	}
	
	//No valid commands found
	print("Invalid command: '?' for commands\n", .{});
	return false;
}

fn consoleLoop() void {
	
	var buffer: [100]u8 = undefined; 
	var fba = std.heap.FixedBufferAllocator.init(&buffer); 
	const fba_allocator = fba.allocator(); //store the allocator so it's easier to write
	const stdin = std.io.getStdIn().reader(); //this gets a way to read input from the OS
	
	while (true) {
		
		print("Choose a move: ", .{}); //ask for input
		const userInput = stdin.readUntilDelimiterAlloc(fba_allocator, '\n', 100,) catch "invalid input\n"; //if there is an error save it as the message.
		defer fba_allocator.free(userInput); //free the memory at the end of the scope
		
		const should_quit = processInput(userInput);
		if (should_quit == true) { //if the user type "quit"
			break;
		}
	}
}

fn setPosition(position_slice:[]const u8) void {
	
	resetBoard();
	
	for (0..9) |index| {

		if (position_slice[index] == Con.PIECE_CHARACTERS[Con.EMPTY]) {
			continue;
		}
		if (position_slice[index] == Con.PIECE_CHARACTERS[Con.X]) {
			board[index] = Con.X;
			continue;
		}
		if (position_slice[index] == Con.PIECE_CHARACTERS[Con.O]) {
			board[index] = Con.O;
			continue;
		}
	}
	
	printBoard();
	
}


pub fn main() void {
	//checkWinner();
	print("Tic tac toe:\n", .{});
	printCommands();
	printBoard();
	consoleLoop();
}


const Result = enum {
	none,
	x_win,
	o_win,
	draw
};

test "settingPositions" {
	const position1 = "XXXOO____";
	setPosition(position1);
	std.testing.expect(checkWinnerTest() == Result.x_win) catch unreachable;
	
	const position2 = "X_XO_O_X_";
	setPosition(position2);
	std.testing.expect(checkWinnerTest() == Result.none) catch unreachable;
	
	const position3 = "___XXXOO_";
	setPosition(position3);
	std.testing.expect(checkWinnerTest() == Result.x_win) catch unreachable;
	
	const position4 = "X__OXO__X";
	setPosition(position4);
	std.testing.expect(checkWinnerTest() == Result.x_win) catch unreachable;
		
	const position5 = "__OXOXOX__";
	setPosition(position5);
	std.testing.expect(checkWinnerTest() == Result.o_win) catch unreachable;
		
	const position6 = "OXOOXOXOX";
	setPosition(position6);
	std.testing.expect(checkWinnerTest() == Result.draw) catch unreachable;
		
	const position7 = "XXOX_O__O";
	setPosition(position7);
	std.testing.expect(checkWinnerTest() == Result.o_win) catch unreachable;
}



fn checkWinnerTest() Result {
	const BIT_INDEX = [9]u9 {1, 2, 4, 8, 16, 32, 64, 128, 256 };
	
	var O_BITBOARD:u9 = 0;
	var X_BITBOARD:u9 = 0;
	var EMPTY_BITBOARD:u9 = 0;
	
	for (0..9) |index| {

		if (board[index] == Con.EMPTY) {
			EMPTY_BITBOARD |= BIT_INDEX[index];
			continue;
		}
		if (board[index] == Con.O) {
			O_BITBOARD |= BIT_INDEX[index];
			continue;
		}
		X_BITBOARD |= BIT_INDEX[index];
	}


		for (0..8) |index| {
			if ((O_BITBOARD & Con.WIN_CHECK_BITBOARDS[index]) == Con.WIN_CHECK_BITBOARDS[index]) {
				//o_Won();
				return Result.o_win;
			}
		}

	

		for (0..8) |index| {

			if ((X_BITBOARD & Con.WIN_CHECK_BITBOARDS[index]) == Con.WIN_CHECK_BITBOARDS[index]) {
				//x_Won();
				return Result.x_win;
			}
		}
	
	if (EMPTY_BITBOARD == 0) {
		//draw();
		return Result.draw;
	}
	return Result.none;
}
