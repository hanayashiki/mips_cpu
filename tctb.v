`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:04:25 12/12/2016
// Design Name:   TC
// Module Name:   Q:/p/pipeline/tctb.v
// Project Name:  pipeline
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: TC
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tctb;

	// Inputs
	reg clk;
	reg reset;
	reg [3:2] PrAddr;
	reg WE;
	reg [31:0] DataIn;

	// Outputs
	wire [31:0] DataOut;
	wire InterruptRequest;

	// Instantiate the Unit Under Test (UUT)
		//Ctrl: 		[3:3] 0 no interrupt
	//				  1 allow interrupt
	//		¡¡		[2:1]	00 mode 0
	//						01 mode 1
	//				[0:0] 0  stop counting
	//						1  allow counting
	
	//Ctrl 	short addr 	00
	//Preset         	 	01
	//Count           	10
	TC uut (
		.clk(clk), 
		.reset(reset), 
		.PrAddr(PrAddr), 
		.WE(WE), 
		.DataIn(DataIn), 
		.DataOut(DataOut), 
		.InterruptRequest(InterruptRequest)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		PrAddr = 0;
		WE = 0;
		DataIn = 0;

		// Wait 100 ns for global reset to finish
	//Ctrl 	short addr 	00
	//Preset         	 	01
	//Count           	10
		#90;
		WE = 1;
		PrAddr = 0;
		DataIn = 32'b1011;
		#20
		WE = 1;
		PrAddr = 1;
		DataIn = 10;
		

	end
   always #10 clk = ~clk;
endmodule

