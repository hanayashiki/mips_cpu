`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:22:44 11/20/2016 
// Design Name: 
// Module Name:    IFID 
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
module IFID(
	 input InterruptRequest,
    input [31:0] RD,
    input StallD,
    input CLR,
	 input reset,
	 input clk,
	 input [31:0] PCPlus4F,
	 input [31:0] PCF,
	 input AtDelaySlotF,
	 input CancelF,
	 output reg [31:0] PCD = 0,
    output reg [31:0] InstrD = 0,
    output reg [31:0] PCPlus4D = 0,
	 output reg AtDelaySlotD
    );
	always @(posedge clk) begin
		if (reset == 1 || ((InterruptRequest == 1 || CancelF) && StallD != 1)) begin
			InstrD <= 0;
			if (CancelF && !reset) begin
				PCPlus4D <= PCPlus4F;
				PCD <= PCF;
				AtDelaySlotD <= AtDelaySlotF;
			end
			else begin
				PCPlus4D <= 0;
				PCD <= 0;
				AtDelaySlotD <= 0;
			end
			
		end
		else if (StallD != 1) begin
			InstrD <= RD;
			PCPlus4D <= PCPlus4F;
			PCD <= PCF;
			AtDelaySlotD <= AtDelaySlotF;
		end
	end
endmodule
