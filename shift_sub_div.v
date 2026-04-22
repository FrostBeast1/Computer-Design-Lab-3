module shift_sub_divide #(parameter BUS_WIDTH = 4) (Reset, Clk, Dividend, Divisor, Quotient, Remainder, Overflow, Finish, debug_o);
	input		wire	Reset, Clk;
	input    wire  [2*BUS_WIDTH-1:0] Dividend;
	input		wire	[BUS_WIDTH - 1:0] Divisor;
	output	wire	[BUS_WIDTH - 1:0] Quotient, Remainder;
	output	wire	Overflow;
	output   wire  Finish;
	output	wire  [1:0] debug_o;

	wire [3:0] stat_flags;
	wire [2:0] ctrl_sig;
	
	assign Overflow = stat_flags[2];
	assign Finish = stat_flags[3];
	
	//assign debug_o = ctrl_sig;

	
	control_unit cu (
		.clk(Clk),
		.reset(Reset),
		.g_i(stat_flags[0]),
		.z_i(stat_flags[1]),
		.ctrl_o(ctrl_sig),
		.Q_o(debug_o)
	);
	
	data_path #(.BUS_WIDTH(BUS_WIDTH)) dp (
		.Divisor(Divisor), 
		.Dividend(Dividend), 
		.Ctrl_In(ctrl_sig), 
		.Clk(Clk), 
		.Data_Out(stat_flags),
		.Quotient(Quotient), 
		.Remainder(Remainder)
	);
	
endmodule