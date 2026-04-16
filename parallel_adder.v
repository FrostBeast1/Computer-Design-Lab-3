// No need for third input
// Inputs Save Carry named after output of CarrySaveAdder
module parallel_adder (Save, Carry, Cin, Out, Cout);
	// Bus width of output, may change to bus width of input if it makes more sense later
	parameter BUS_WIDTH = 4;
	input  wire [BUS_WIDTH - 1 : 0] Save, Carry;
	input  wire Cin;
	output wire [BUS_WIDTH - 1 : 0] Out;
	output wire Cout;
	
	assign {Cout, Out} = Save + Carry + Cin;
endmodule