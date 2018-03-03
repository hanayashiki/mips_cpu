`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:48:37 11/15/2016 
// Design Name: 
// Module Name:    bitLowerer 
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
module bitLowerer(
    input [31:0] In,
    output [4:0] Out
    );
	assign Out = In[4:0];
	
endmodule
