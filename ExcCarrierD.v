`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:27:23 12/13/2016 
// Design Name: 
// Module Name:    ExcCarrierD 
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
module ExcCarrierD(
    input InterruptRequest,
	 input clk,
	 input reset,
	 input FlushE,
	 input Nullify,
    input ErrorRlD,
	 input MulFlushE,
    output reg ErrorRlE = 0,
    input [31:0] PCD,
    output reg [31:0] PCE = 0
    );
	 always @(posedge clk) begin
		if ((!FlushE &&(Nullify || InterruptRequest)) || reset) begin
			ErrorRlE <= 0;
			PCE <= 0;
		end
		else if (FlushE) begin
			ErrorRlE <= 0;
			PCE <= PCD;
		end
		else begin
			ErrorRlE <= ErrorRlD;
			PCE <= PCD;
		end 
 	end
endmodule
