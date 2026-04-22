module data_path #(parameter BUS_WIDTH = 4) (Divisor, Dividend, Ctrl_In, Clk, Data_Out, Quotient, Remainder);
	input wire [2*BUS_WIDTH - 1:0] Dividend
    input wire [BUS_WIDTH - 1:0] Divisor
	
	// Control signals from control unit:
	// 0 - Step 1
	// 1 - Step 2
	// 2 - Step 3
	input wire [2:0] Ctrl_In;
    input wire clock;
	
	// Conditional output to control unit:
	// 0 - g_i = {0 -> u < x}, {1 -> u >= x}
	// 1 - z_i = {0 -> i > 0}, {1 -> i == 0}
    // 2 - Overflow flag (set if initial overflow occurs)
    // 3 - Finish flag (set once algorithm is finished)
	output wire [3:0] Data_Out;
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
    reg overflow;
    reg finish;
	
	// Z & G combinational assigments (we can read from these in the always block as well)
    assign Data_Out[0] = {C,U} < Divisor ? 1'b0 : 1'b1;
	assign Data_Out[1] = Counter > 1'd0 ? 1'b0 : 1'b1;

    assign Data_Out[2] = overflow;
    assign Data_Out[3] = finish;
	
	// Sequential logic
	always @(posedge Clk) begin
        // Set flag registers
        G_flag = Data_Out[0];
        Z_flag = Data_Out[1];

        case(Ctrl_In)
            3'b001 : begin
                // Initialize operation registers with dividend
                {U, V} <= Dividend;

                // Other unconditional initializations
                Counter <= BUS_WIDTH;
                Y <= 0;

                // Initialize based on g flag
                overflow <= G_flag ? 1'b0 : 1'b1;
                finish <= G_flag ? 1'b0 : 1'b1;
            end
            3'b010 : begin
                // Logical Shift left of CUV (accumulator) and 
                {C, U, V} <= {C, U, V} << 1;
                Y <= Y << 1;
                Counter <= Counter - 1;
            end
            3'b100 : begin
                Y[0] <= (C or G_flag) ? 1'b1 : Y[0];
                U <= (C or G_flag) ? {C, U} - Divisor : U;
            end
        endcase
    end

endmodule