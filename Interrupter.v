`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:12:01 12/16/2016 
// Design Name: 
// Module Name:    Interrupter 
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
module Interrupter(
    input [31:0] PCM,
    output [0:0] IntReq
    );
	 assign IntReq = PCM == 32'h0000419c;

endmodule
