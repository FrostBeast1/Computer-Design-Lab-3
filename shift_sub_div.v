module shift_sub_div(U, V, X, Y);
	parameter BUS_WIDTH = 4;

<<<<<<< Updated upstream
	inout  wire [BUS_WIDTH - 1:0] U;
	input  wire [BUS_WIDTH - 1:0] V, X;
	output wire [BUS_WIDTH - 1:0] Y;


endmodule
=======
	// connecting wire for z and g registers to CU
	wire [1:0] stat_flags;

	// control signals from cu
	wire [4:0] ctrl_sig;
	
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
>>>>>>> Stashed changes
