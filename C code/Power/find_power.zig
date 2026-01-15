
const c = @cImport({
    // See https://github.com/ziglang/zig/issues/515
    @cDefine("_NO_CRT_STDIO_INLINE", "1");
    @cInclude("stdio.h");
});

pub fn main() void {
	
    var base: c_int = undefined;
    var exp: c_int = undefined;
    var result: f64 = 1.0;
	
    _ = c.printf("Enter a base number: ");
    _ = c.scanf("%d", &base);
    _ = c.printf("Enter an exponent: ");
    _ = c.scanf("%d", &exp);
	
	
    while (exp != @as(c_int, 0)) {
        _ = c.printf("Looping = %.0f\n", result);
        result *= @as(f64, @floatFromInt(base));
        exp -= @as(c_int, 1);
    }
    _ = c.printf("Answer = %.0f\n", result);

}