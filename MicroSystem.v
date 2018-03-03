`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:08:53 12/12/2016
// Design Name:   Bridge
// Module Name:   Q:/p/pipeline/MicroSystem.v
// Project Name:  pipeline
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Bridge
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module MicroSystem;

	// Inputs
	reg clk;
	reg reset;
	
	reg MemWriteM;
	reg CPUAddress;

	// Instantiate the Unit Under Test (UUT)
	Bridge Bridge (
		.MemWriteM(MemWriteM), 
		.CPUAddress(CPUAddress)
	);


	// Instantiate the Unit Under Test (UUT)
	mips uut (
		.clk(clk),
		.reset(reset)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;

		// Wait 100 ns for global reset to finish
		//#(10*2*500/80)
		//reset = 1;
		// Add stimulus here
		//#999 reset = 1;
	end
   always #(500/160) clk = ~clk;   
	initial begin
		// Initialize Inputs
		MemWriteM = 0;
		CPUAddress = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

