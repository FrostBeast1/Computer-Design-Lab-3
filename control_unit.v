module control_unit (clk, reset, data_in, ctrl_out);
	// Conditional inputs from data path.
	// 0 - g_i = {0 -> u < x}, {1 -> u >= x}
	// 1 - z_i = {0 -> i > 0}, {1 -> i == 0}
	input		wire	[1 : 0] data_in;
	input		wire	clk, reset;

	// Control signals to data path.
	// 0 - Step 1
	// 1 - Step 2
	// 2 - Step 3
	// 3 - Finish flag
	output wire [3:0] ctrl_out;
	
	reg [3:0] control;
	wire [1:0] state;
	
	// Sets the finish flag if z = 1
	assign ctrl_out[3:0] = control;
	
	// State Machine
	control_state_register cu_sm(
		.clk_i(clk),
		.reset_i(reset),
		.z_i(data_in[1]),
		.Q_o(state)
	);

	// Combinational Flag logic
	always @(state, data_in[1]) begin
	control[3] <= data_in[1];
		
		// Locks control unit output if z = 1
		if (!(data_in[1])) begin
			case(state)
				// Step 1
				2'b00 : control <= 3'b001;
				// Step 2
				2'b01 : control <= 3'b010;
				// Step 3
				2'b10 : control <= 3'b100;
			endcase
		end
	end

endmodule