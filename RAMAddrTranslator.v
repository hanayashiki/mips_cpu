`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:40:39 11/14/2016 
// Design Name: 
// Module Name:    RAMAddrTranslator 
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
module RAMAddrTranslator(
    input [31:0] In,
    output [10:0] Out,
	 output [1:0] Low
    );
	assign Out = In[12:2];
	assign Low = In[1:0];
endmodule
