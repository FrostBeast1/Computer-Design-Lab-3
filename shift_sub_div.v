module shift_sub_div #(parameter BUS_WIDTH = 4) (U, V, X, Y, Reset, Clk, Overflow);
	input		wire	Reset, Clk;
	inout		wire	[BUS_WIDTH - 1:0] U;
	input		wire	[BUS_WIDTH - 1:0] V, X;
	output	wire	[BUS_WIDTH - 1:0] Y;
	output	wire	Overflow;

	wire [1:0] stat_flags;
	wire [5:0] ctrl_sig;
	
	control_unit cu (
		.clk(Clk),
		.reset(Reset),
		.data_in(stat_flags),
		.ctrl_out(ctrl_sig)
	);
	
	data_path #(.BUS_WIDTH(BUS_WIDTH)) dp (
		.U(U),
		.V(V),
		.X(X),
		.Y(Y),
		.Overflow(Overflow),
		.Ctrl_In(ctrl_sig),
		.Data_Out(stat_flags)
	);
	
endmodule
