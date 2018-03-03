`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:02:02 11/21/2016 
// Design Name: 
// Module Name:    IDEX 
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
module IDEX(
	 input InterruptRequest,
    input clk,
	 input reset,
    input FlushE,
	 input Nullify,
    input [4:0] RsD,
    output reg[4:0] RsE  = 0,
    input [4:0] RtD,
    output reg[4:0] RtE = 0,
    input [4:0] RdD,
    output reg[4:0] RdE = 0,
    input [31:0] RD1D,
    output reg[31:0] RD1E = 0,
    input [31:0] RD2D,
    output reg[31:0] RD2E = 0,
	 input [31:0] SignImmD,
	 output reg[31:0] SignImmE,
	 input [31:0] InstrD,
	 output reg[31:0] InstrE
    );
	always @(posedge clk) begin
		if (FlushE || reset || Nullify || InterruptRequest) begin
			RsE <= 0;
			RtE <= 0;
			RdE <= 0;
			RD1E <= 0;
			RD2E <= 0;
			SignImmE <= 0;
			InstrE <= 0;
		end
		else begin
			RsE <= RsD;
			RtE <= RtD;
			RdE <= RdD;
			RD1E <= RD1D;
			RD2E <= RD2D;
			SignImmE <= SignImmD;
			InstrE <= InstrD;
		end
	end

endmodule
