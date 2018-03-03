`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:53:40 12/13/2016 
// Design Name: 
// Module Name:    ExcCarrierE 
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
module ExcCarrierE(
	 input InterruptRequest,
    input clk,
    input reset,
    input ErrorOvE,
    output reg ErrorOvM = 0,
	 input ErrorRlE,
	 output reg ErrorRlM = 0,
    input [31:0] PCE,
    output reg [31:0] PCM = 0
    );
	always @(posedge clk) begin
		if (reset || InterruptRequest) begin
			ErrorRlM <= 0;
			ErrorRlM <= 0;
			PCM <= 0;
		end
		else begin
			ErrorRlM <= ErrorRlE;
			ErrorOvM <= ErrorOvE;
			PCM <= PCE;
		end 
 	end

endmodule
