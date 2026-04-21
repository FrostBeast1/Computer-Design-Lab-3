<<<<<<< Updated upstream
module data_path (U, V, X, Ctrl, U_neg, Done, Overflow);
	parameter BUS_WIDTH = 4;
	inout	reg [BUS_WIDTH - 1 : 0] U, V, X;
=======
module data_path #(parameter BUS_WIDTH = 4) (U, V, X, Ctrl_In, Data_Out);
	inout		wire	[BUS_WIDTH - 1 : 0] U, V, X;
	
	// Control signals from control unit:
	// 0 - Start (used to clear and set appropriate registers)
	// 1 - Overflow
	// 2 - Finish
	// 3 - g -> {0 -> u < x}, {1 -> u >= x}
	// 4 - z -> {0 -> i > 0}, {1 -> i == 0}
	input		reg	[4 : 0] Ctrl_In;
	
	// Conditional output to control unit:
	// 0 - g_i = {0 -> u < x}, {1 -> u >= x}
	// 1 - z_i = {0 -> i > 0}, {1 -> i == 0}
	output	wire [1 : 0] Data_Out;

	
>>>>>>> Stashed changes
	// Control signals from control unit.
	// 0-load
	// 1-shift
	// 2-subtract
	// 3-restore
	// 4-set Q
	// 5-count enabled
	input		wire [5 : 0] Ctrl;
	output	wire U_neg, Done, Overflow;
	
endmodule