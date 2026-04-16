module register (In, Out, Clk);
	parameter BUS_WIDTH = 4;
	
	input  wire [BUS_WIDTH - 1 : 0] In;
	input  wire Clk;
	output reg [BUS_WIDTH - 1 : 0] Out;
	
	always @(posedge Clk) begin
		Out <= In;
	end
endmodule