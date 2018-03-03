`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:46:10 11/21/2016 
// Design Name: 
// Module Name:    MEMWB 
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
module MEMWB(
	 input InterruptRequest,
	 input clk, input reset,
    input [31:0] ReadDataM,
	 output reg [31:0] ReadDataW = 0,
    input [31:0] ReadDataCM,
	 output reg [31:0] ReadDataCW = 0,
	 input [15:0] ReadDataHM,
	 output reg [15:0] ReadDataHW = 0,
	 input [7:0] ReadDataBM,
	 output reg [7:0] ReadDataBW = 0,
    input [31:0] ALUOutM,
    output reg [31:0] ALUOutW = 0,
    input [4:0] WriteRegM,
    output reg [4:0] WriteRegW = 0,
	 input [31:0] InstrM,
	 output reg [31:0] InstrW = 0,
	 input [31:0] CPURD,
	 output reg [31:0] CPURDW = 0,
	 input [31:0] CP0DataOutM,
	 output reg [31:0] CP0DataOutW = 0,
	 input [31:0] PCM,
	 output reg [31:0] PCW = 0
    );
	always @(posedge clk) begin
		if (reset || InterruptRequest) begin
			ReadDataW <= 0;
			ReadDataCW <= 0;
			ReadDataHW <= 0;
			ReadDataBW <= 0;
			ALUOutW <= 0;
			WriteRegW <= 0;
			InstrW <= 0;
			CPURDW <= 0;
			CP0DataOutW <= 0;
			PCW <= 0;
		end
		else begin
			ReadDataW <= ReadDataM;
			ReadDataCW <= ReadDataCM;
			ReadDataHW <= ReadDataHM;
			ReadDataBW <= ReadDataBM;
			ALUOutW <= ALUOutM;
			WriteRegW <= WriteRegM;
			InstrW <= InstrM;
			CPURDW <= CPURD;
			CP0DataOutW <= CP0DataOutM;
			PCW <= PCM;
			//$display("%h",PCW);
		end
	end

endmodule
