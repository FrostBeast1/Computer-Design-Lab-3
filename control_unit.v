module control_unit (clk, reset, g_i, z_i, ctrl_o);
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
	output reg [4 : 0] ctrl_o;

	wire [1:0] state;
	
	// State Machine
	control_state_register cu_sm(
		.clk_i(clk),
		.reset_i(reset),
		.z_i(z_i),
		.Q_o(state),
	);

	// Combinational Flag logic
	always @(state) begin
		case(state)
			// Step 0
			2'b00: ctrl_o[4:0] = 5'b00001;
			2'b01: begin
				ctrl_o[3:1] = {3{g_i}};
				ctrl_o[0] = 1'b0;
			end
			2'b10: begin
				ctrl_o[3] = g_i;
				ctrl_o[4] = z_i; 
			end
			2'b11: ctrl_o[2] = z_i ? ctrl_o[2] : z_i;
		endcase
	end

endmodule