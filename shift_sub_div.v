module shift_sub_div #(parameter BUS_WIDTH = 4) (U, V, X, Y, Reset, Clk, Overflow);
	input		wire	Reset, Clk;
	inout		wire	[BUS_WIDTH - 1:0] U;
	input		wire	[BUS_WIDTH - 1:0] V, X;
	output	wire	[BUS_WIDTH - 1:0] Y;
	output	wire	Overflow;

endmodule