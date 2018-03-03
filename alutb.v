`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:16:33 11/28/2016
// Design Name:   ALU
// Module Name:   Q:/p/pipeline/alutb.v
// Project Name:  pipeline
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ALU
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module alutb;

	// Inputs
	reg [31:0] A;
	reg [31:0] B;
	reg [4:0] msb;
	reg [4:0] lsb;
	reg [3:0] OP;

	// Outputs
	wire [31:0] Out;

	// Instantiate the Unit Under Test (UUT)
	ALU uut (
		.A(A), 
		.B(B),
		.msb(msb),
		.lsb(lsb),
		.Out(Out), 
		.OP(OP)
	);

	initial begin
		// Initialize Inputs
		A = 32'h12345678;
		B = 32'hffffffff;
		OP = 13;
		msb = 3;
		lsb = 0;
		// Wait 100 ns for global reset to finish
		#100;
      OP = 13;
		msb = 11;
		lsb = 12;
		// Wait 100 ns for global reset to finish
		#100;  
		// Add stimulus here

	end
      
endmodule

