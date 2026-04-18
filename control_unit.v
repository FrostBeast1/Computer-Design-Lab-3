module control_unit (clk, reset, g_i, z_i, ctrl_i);
	// Conditional inputs from data path: g_i, z_i
	// g_i = {0 -> u < x}, {1 -> u >= x}
	// z_i = {0 -> i > 0}, {1 -> i == 0}
	input wire clk, reset, g_i, z_i;

	// Control signals to data path.
	// 0 - Start (used to clear and set appropriate registers)
	// 1 - Overflow
	// 2 - Finish
	// 3 - g -> {0 -> u < x}, {1 -> u >= x}
	// 4 - z -> {0 -> i > 0}, {1 -> i == 0}
	output reg [4 : 0] ctrl;

	reg [1:0] state;

	// State Machine
	control_state_register cu_sm(
		.clk_i(clk),
		.reset_i(reset),
		.g_i(g_i),
		.z_i(z_i),
		.Q_o(state),
	)

	// Combinational Flag logic
	always @(state) begin
		case(state)
			// Step 1
			2'b00: begin
				ctrl[3:0] = {4{g_i}}
			end
			2'b01: begin
				ctrl[3] = g_i
				ctrl[4] = z_i 
			end
			2'b10: ctrl[2] = z_i ? ctrl[2] : z_i
		endcase
	end

endmodule