`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:09:48 11/21/2016 
// Design Name: 
// Module Name:    EXMEM 
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
module EXMEM(
	 input InterruptRequest,
	 input clk, input reset,
	 input [4:0] RdE,
    input [31:0] ALUOutE,
    input [31:0] WriteDataE,
    input [4:0] WriteRegE,
	 output reg [4:0] RdM, 
    output reg [31:0] ALUOutM = 0,
    output reg [31:0] WriteDataM = 0,
    output reg [4:0] WriteRegM = 0,
	 input [31:0] InstrE,
	 output reg [31:0] InstrM = 0
    );
	always @(posedge clk) begin
		if (reset || InterruptRequest) begin
			ALUOutM <= 0;
			WriteDataM <= 0;
			WriteRegM <= 0;
			InstrM <= 0;
			RdM <= 0;
		end
		else begin
			ALUOutM <= ALUOutE;
			WriteDataM <= WriteDataE;
			WriteRegM <= WriteRegE;
			InstrM <= InstrE;
			RdM <= RdE;
		end
	end

endmodule
