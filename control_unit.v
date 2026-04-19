module control_unit (clk, reset, data_in, ctrl_out);
	// Conditional inputs from data path:
	// 0 - g_i = {0 -> u < x}, {1 -> u >= x}
	// 1 - z_i = {0 -> i > 0}, {1 -> i == 0}
	input		wire	[1 : 0] data_in;
	input		wire	clk, reset;

	// Control signals to data path:
	// 0 - Start (used to clear and set appropriate registers)
	// 1 - Overflow
	// 2 - Finish
	// 3 - g -> {0 -> u < x}, {1 -> u >= x}
	// 4 - z -> {0 -> i > 0}, {1 -> i == 0}
	output	reg	[4 : 0] ctrl_out;

	wire [1:0] state;
	
	// State Machine
	control_state_register cu_sm(
		.clk_i(clk),
		.reset_i(reset),
		.z_i(data_in[1]),
		.Q_o(state)
	);

	// Combinational Flag logic
	always @(state) begin
		case(state)
			// Step 0
			2'b00: ctrl_out[4:0] = 5'b00001;
			2'b01: begin
				ctrl_out[3:1] = {3{data_in[0]}};
				ctrl_out[0] = 1'b0;
			end
			2'b10: begin
				ctrl_out[3] = data_in[0];
				ctrl_out[4] = data_in[1]; 
			end
			2'b11: ctrl_out[2] = data_in[1] ? ctrl_out[2] : data_in[1];
		endcase
	end

endmodule