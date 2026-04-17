module control_unit (Clk, Reset, U_neg, Done, Ctrl);
	input  wire Clk, Reset, U_neg, Done;
	// Control signals to data path.
	// 0 - Overflow
	// 1 - Finish
	// 2 - Start
	// 3 - z -> i > 0
	// 4 - g -> u <= x
	output	wire [4 : 0] Ctrl;
	
endmodule