`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   03:27:12 12/25/2016
// Design Name:   clkmips
// Module Name:   Q:/p/pipeline/clkmipstb.v
// Project Name:  pipeline
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: clkmips
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module clkmipstb;

	// Inputs
	reg clk_in;
	reg reset;
	reg [7:0] dip_switch0;
	reg [7:0] dip_switch1;
	reg [7:0] dip_switch2;
	reg [7:0] dip_switch3;
	reg [7:0] dip_switch4;
	reg [7:0] dip_switch5;
	reg [7:0] dip_switch6;
	reg [7:0] dip_switch7;
	reg [7:0] user_key;

	// Outputs
	wire [7:0] digital_tube0;
	wire [7:0] digital_tube1;
	wire [7:0] digital_tube2;
	wire [3:0] digital_tube_sel0;
	wire [3:0] digital_tube_sel1;
	wire [31:0] led_light;
	wire digital_tube_sel2;

	// Instantiate the Unit Under Test (UUT)
	clkmips uut (
		.clk_in(clk_in), 
		.reset(reset), 
		.digital_tube0(digital_tube0), 
		.digital_tube1(digital_tube1), 
		.digital_tube2(digital_tube2), 
		.digital_tube_sel0(digital_tube_sel0), 
		.digital_tube_sel1(digital_tube_sel1), 
		.digital_tube_sel2(digital_tube_sel2), 
		.led_light(led_light), 
		.dip_switch0(dip_switch0), 
		.dip_switch1(dip_switch1), 
		.dip_switch2(dip_switch2), 
		.dip_switch3(dip_switch3), 
		.dip_switch4(dip_switch4), 
		.dip_switch5(dip_switch5), 
		.dip_switch6(dip_switch6), 
		.dip_switch7(dip_switch7),
		.user_key(user_key)
	);

	initial begin
		// Initialize Inputs
		clk_in = 0;
		reset = 1;
		dip_switch0 = 1;
		dip_switch1 = 1;
		dip_switch2 = 1;
		dip_switch3 = 1;
		dip_switch4 = 2;
		dip_switch5 = 2;
		dip_switch6 = 2;
		dip_switch7 = 2;
		user_key = 8'b11111101;
		// Wait 100 ns for global reset to finish
		#600;
		reset = 0;
		#650;
		reset = 1;
		#900;
		dip_switch0 = 1;
		dip_switch1 = 1;
		dip_switch2 = 1;
		dip_switch3 = 1;
		dip_switch4 = 2;
		dip_switch5 = 2;
		dip_switch6 = 2;
		dip_switch7 = 2;
		#900;
		dip_switch0 = 1;
		dip_switch1 = 0;
		dip_switch2 = 0;
		dip_switch3 = 0;
		dip_switch4 = 2;
		dip_switch5 = 0;
		dip_switch6 = 0;
		dip_switch7 = 0; 
		// Add stimulus here

	end
   always #20 begin
		clk_in = ~clk_in; 
		//user_key = user_key<<1;
	end
endmodule

