module data_path #(parameter BUS_WIDTH = 4) (U, V, X, Ctrl_In, Data_Out);
	inout		wire	[BUS_WIDTH - 1 : 0] U, V, X;
	
	// Control signals from control unit.
	// 0 - Step 1
	// 1 - Step 2
	// 2 - Step 3
	// 3 - Finish flag
	output wire [3:0] ctrl_out;
	
	// Conditional output to control unit.
	// 0 - g_i = {0 -> u < x}, {1 -> u >= x}
	// 1 - z_i = {0 -> i > 0}, {1 -> i == 0}
	output	wire [1 : 0] Data_Out;

	
	
	
	
	
	
	
	// Control signals from control unit.
	// 0-load
	// 1-shift
	// 2-subtract
	// 3-restore
	// 4-set Q
	// 5-count enabled
	input		wire	[5 : 0] Ctrl_In;
	output	wire	U_neg, Done, Overflow;
	
	// Internal registers and flags per specification
	reg [BUS_WIDTH - 1 : 0] Y;       // y: n-bit quotient register
	reg C;                           // c: 1-bit register (carry/borrow)
	reg [2:0] Counter;               // iteration counter
	reg Z;                           // z: 1 when Counter == 0
	reg G;                           // G: 1 when U >= X
	
	// Output assignments
	assign U_neg = C;                // C is borrow from subtract
	assign Done = Z;                 // Done when counter reaches 0
	assign Overflow = (G && Ctrl_In[0]); // Overflow flag on load if U >= X
	
	// Drive inout ports (internal drive when operating)
	reg [BUS_WIDTH - 1 : 0] U_reg, V_reg, X_reg;
	reg drive_internal;
	
	assign U = drive_internal ? U_reg : {BUS_WIDTH{1'bz}};
	assign V = drive_internal ? V_reg : {BUS_WIDTH{1'bz}};
	assign X = drive_internal ? X_reg : {BUS_WIDTH{1'bz}};
	
	// Sequential logic
	always @(posedge Ctrl_In[0] or posedge Ctrl_In[1] or posedge Ctrl_In[2]
		or posedge Ctrl_In[3] or posedge Ctrl_In[4]) begin
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