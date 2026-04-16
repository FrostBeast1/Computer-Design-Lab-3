module data_path (U, V, X, Ctrl, U_neg, Done, Overflow);
	parameter BUS_WIDTH = 4;
	inout	reg [BUS_WIDTH - 1 : 0] U, V, X;
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