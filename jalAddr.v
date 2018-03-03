`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:46:08 11/16/2016 
// Design Name: 
// Module Name:    jalAddr 
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
module jalAddr(
    input [31:0] IMAddress,
    input [25:0] InstrIndex,
    output [31:0] Out
    );
	assign Out = {IMAddress[31:28], InstrIndex[25:0], 2'b00};

endmodule
