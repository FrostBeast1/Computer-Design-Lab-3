module control_unit (Clk, Reset, U_neg, Done, Ctrl);
	input  wire Clk, Reset, U_neg, Done;
	// Control signals to data path.
	// 0-load
	// 1-shift
	// 2-subtract
	// 3-restore
	// 4-set Q
	// 5-count enabled
	output	wire [5 : 0] Ctrl;
	
endmodule