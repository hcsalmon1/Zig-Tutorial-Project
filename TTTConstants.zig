

pub const QUIT = "quit";
pub const QUESTION_MARK = "?";
pub const ONE = "1";
pub const TWO = "2";
pub const THREE = "3";
pub const FOUR = "4";
pub const FIVE = "5";
pub const SIX = "6";
pub const SEVEN = "7";
pub const EIGHT = "8";
pub const NINE = "9";

pub const SQUARE_CHOICES = [9][]const u8 {ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE};

pub const EMPTY = 0;
pub const X = 1;
pub const O = 2;

pub const PIECE_CHARACTERS = [3]u8 {'_', 'X', 'O'};

pub const Squares = enum {
	one, two, three, four, five, six, seven, eight, nine
};

pub const INVALID = 10;

pub const HORIZONTAL_WIN_LINE_1:u9 = 7;
pub const HORIZONTAL_WIN_LINE_2:u9 = 56;
pub const HORIZONTAL_WIN_LINE_3:u9 = 448;
pub const DIAGONAL_WIN_0_9:u9 = 273;
pub const DIAGONAL_WIN_2_6:u9 = 84;
pub const VERTICAL_WIN_LINE_1 = 73;
pub const VERTICAL_WIN_LINE_2 = 146;
pub const VERTICAL_WIN_LINE_3 = 292;

pub const WIN_CHECK_BITBOARDS = [8]u9 {HORIZONTAL_WIN_LINE_1, HORIZONTAL_WIN_LINE_2, HORIZONTAL_WIN_LINE_3, DIAGONAL_WIN_0_9, DIAGONAL_WIN_2_6, VERTICAL_WIN_LINE_1, VERTICAL_WIN_LINE_2, VERTICAL_WIN_LINE_3};
