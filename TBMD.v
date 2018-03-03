`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:40:48 12/05/2016
// Design Name:   MD
// Module Name:   Q:/p/pipeline/TBMD.v
// Project Name:  pipeline
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: MD
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TBMD;

	// Inputs
	reg clk;
	reg reset;
	reg [31:0] D1;
	reg [31:0] D2;
	reg Start;
	reg MDSign;
	reg MD;

	// Outputs
	wire Busy;
	wire signed [31:0] HI;
	wire signed [31:0] LO;

	// Instantiate the Unit Under Test (UUT)
	MD uut (
		.clk(clk), 
		.reset(reset), 
		.D1(D1), 
		.D2(D2), 
		.Start(Start), 
		.MDSign(MDSign), 
		.MD(MD), 
		.Busy(Busy), 
		.HI(HI), 
		.LO(LO)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		D1 = 0;
		D2 = 0;
		Start = 0;
		MDSign = 1;
		MD = 1;

		D1 = 85;
		D2 = 2;
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

