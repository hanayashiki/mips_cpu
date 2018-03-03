`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:26:40 12/22/2016 
// Design Name: 
// Module Name:    clkmips 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module clkmips(
    input clk_in,
    input reset,
	 output [7:0] digital_tube0,
	 output [7:0] digital_tube1,
	 output [7:0] digital_tube2,
	 output [3:0] digital_tube_sel0,
	 output [3:0] digital_tube_sel1,
	 output digital_tube_sel2,
	 
	 output [31:0] led_light,
	 
	 input [7:0] dip_switch0,
	 input [7:0] dip_switch1,
	 input [7:0] dip_switch2,
	 input [7:0] dip_switch3,
	 input [7:0] dip_switch4,
	 input [7:0] dip_switch5,
	 input [7:0] dip_switch6,
	 input [7:0] dip_switch7,
	 
	 input [7:0] user_key
	 
    );
	/*reg clk1 = 0;
	reg clk2 = 0;*/

	Clock Clock
   (// Clock in ports
    .CLK_IN1(clk_in),      // IN
    // Clock out ports
    .CLK_OUT1(clk1),  // OUT
	 .CLK_OUT2(clk2)  // OUT
    );    // OUT
	 
	 
	 
	mips mips (
    .clk(clk1), 
    .clk2(clk2), 
    .reset(~reset), 
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
	 
	/* */
endmodule
