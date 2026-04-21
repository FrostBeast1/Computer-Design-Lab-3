module data_path #(parameter BUS_WIDTH = 4) (Divisor, Dividend, Ctrl_In, Clk, Data_Out, Quotient, Remainder);
	input wire [2*BUS_WIDTH - 1:0] Dividend
    input wire [BUS_WIDTH - 1:0] Divisor
	
	// Control signals from control unit:
	// 0 - Step 1
	// 1 - Step 2
	// 2 - Step 3
	// 3 - Overflow flag
	// 4 - Finish flag
	input wire [4:0] Ctrl_In;
    input wire clock;
	
	// Conditional output to control unit:
	// 0 - g_i = {0 -> u < x}, {1 -> u >= x}
	// 1 - z_i = {0 -> i > 0}, {1 -> i == 0}
	output wire [1:0] Data_Out;
    output wire [3:0] Quotient;
    output wire [3:0] Remainder;
	
	// Internal registers and flags per specification
	reg [BUS_WIDTH - 1 : 0] Y;       // y: n-bit quotient register
	reg C;                           // c: 1-bit register (carry/borrow)
    reg U;                           // u: n-bit operation register
    reg V;                           // v: n-bit operation register

    // $clog2 takes log base 2 of a number. 
    //In this case we see how many bits are needed to encode the bus_width.
	reg [$clog2(BUS_WIDTH)-1:0] Counter; // iteration counter
	reg Z_flag;                           // z: 1 when Counter == 0
	reg G_flag;                           // G: 1 when U >= X
	
	// Z & G combinational assigments (we can read from these in the always block as well)
    assign Data_Out[0] = U < Divisor ? 1'b0 : 1'b1;
	assign Data_Out[1] = Counter > 1'd0 ? 1'b0 : 1'b1;
	
	// Sequential logic
	always @(posedge Clk) begin
        // Set flag registers
        G_flag = Data_Out[0]
        Z_flag = Data_Out[1]

        case(Ctrl_In) begin
            1'b00001 : begin
                // Initialize operation registers with dividend
                {U, V} <= Dividend;

                // Initialize based on flags
                


            end
        end
		if (Ctrl_In[0]) begin
			// LOAD: Capture external inputs
			drive_internal <= 1'b0;      // Tristate to read external values
			#1;                           // Small delay to capture
			U_reg <= U;
			V_reg <= V;
			X_reg <= X;
			drive_internal <= 1'b1;
			
			// Set flags
			G <= (U >= X);               // G = 1 when U >= X
			Counter <= 3'b100;           // Initialize counter to 4
			Z <= 1'b0;
			Y <= 0;
		end
		
		else if (Ctrl_In[1]) begin
			// SHIFT: Shift UV left by 1
			// U gets {U[2:0], V[3]}, V gets {V[2:0], 0}
			U_reg <= {U_reg[BUS_WIDTH-2:0], V_reg[BUS_WIDTH-1]};
			V_reg <= {V_reg[BUS_WIDTH-2:0], 1'b0};
			C <= 1'b0;                   // Clear carry
		end
		
		else if (Ctrl_In[2]) begin
			// SUBTRACT: U - X, set C (borrow)
			if (U_reg >= X_reg) begin
				// U >= X, no borrow
				C <= 1'b0;
				G <= 1'b1;
			end
			else begin
				// U < X, borrow occurs
				C <= 1'b1;
				G <= 1'b0;
			end
			// Compute difference for potential restore
			// (stored implicitly in next state)
		end
		
		else if (Ctrl_In[3]) begin
			// RESTORE: If no borrow (C=0), restore U = U - X, set V[0]=1
			// If borrow (C=1), keep U, set V[0]=0
			if (!C) begin
				// No borrow: U >= X
				U_reg <= U_reg - X_reg;  // Restore with subtract result
				V_reg[0] <= 1'b1;         // Quotient bit = 1
			end
			else begin
				// Borrow: U < X
				// U_reg unchanged
				V_reg[0] <= 1'b0;         // Quotient bit = 0
			end
			
			// Decrement counter if enabled
			if (Ctrl[5]) begin
				Counter <= Counter - 1'b1;
				if (Counter == 3'b001) begin
					Z <= 1'b1;           // Z = 1 when Counter becomes 0
					Y <= V_reg;          // Latch quotient
				end
			end
		end
		
		else if (Ctrl[4]) begin
			// SET Q: Output final results
			V_reg <= Y;                  // V gets final quotient
			// U_reg already has remainder
		end
	end
	
	// Initialization
	initial begin
		U_reg <= 0;
		V_reg <= 0;
		X_reg <= 0;
		Y <= 0;
		C <= 0;
		Counter <= 0;
		Z <= 0;
		G <= 0;
		drive_internal <= 0;
	end

endmodule