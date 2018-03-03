`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:26:45 11/21/2016 
// Design Name: 
// Module Name:    IDEXControlCarrier 
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
module IDEXControlCarrier(
	 input InterruptRequest,
	 input clk,
	 input reset,
	 input FlushE,
	 input Nullify,
    input RegWriteD,
    input MemtoRegD,
    input MemWriteD,
    input [3:0] ALUControlD,
    input ALUSrcD,
    input RegDstD,
	 input BranchD,
	 input ShiftD,
	 input [1:0] MemTypeD,
	 input LoadExtSignD,
	 input LeftRightD,
	 //overflow
	 input OverflowCheckD,
	 //md
	 input StartD,
	 input MDSignD,
	 input MDD,
	 input [1:0] ALUOutESelectD,
	 input HLWriteD,
	 //cp0
	 input CP0ReadD,
	 input CP0WriteD,
	 input EXLClearD,
	 input AtDelaySlotD,
    output reg RegWriteE = 0,
    output reg MemtoRegE = 0,
    output reg MemWriteE = 0,
    output reg [3:0] ALUControlE = 0,
    output reg ALUSrcE = 0,
    output reg RegDstE = 0,
	 output reg BranchE = 0,
	 output reg ShiftE = 0,
	 output reg [1:0] MemTypeE = 0,
	 output reg LoadExtSignE = 0,
	 output reg LeftRightE = 0,
	 //overflow
	 output reg OverflowCheckE = 0,
	 //md
	 output reg StartE = 0,
	 output reg MDSignE = 0,
	 output reg MDE = 0,
	 output reg [1:0] ALUOutESelectE = 0,
	 output reg HLWriteE = 0,
	 //cp0
	 output reg CP0ReadE = 0,
	 output reg CP0WriteE = 0,
	 output reg EXLClearE = 0,
	 output reg AtDelaySlotE = 0
    );
	always @(posedge clk) begin
		if (FlushE || reset || Nullify || InterruptRequest) begin
			LeftRightE <= 0;
			LoadExtSignE <= 0;
			MemTypeE <= 0;
			RegWriteE <= 0;
			MemtoRegE <= 0;
			MemWriteE <= 0;
			ALUControlE <= 0;
			ALUSrcE <= 0;
			RegDstE <= 0;
			BranchE <= 0;
			ShiftE <= 0;
			
			StartE <= 0;
			MDSignE <= 0;
			MDE <= 0;
			ALUOutESelectE <= 0;
			HLWriteE <= 0;
			
			OverflowCheckE <= 0;
			
			CP0ReadE <= 0;
			CP0WriteE <= 0;
			EXLClearE <= 0;
			AtDelaySlotE <= 0;
		end
		else begin
			LeftRightE <= LeftRightD;
			LoadExtSignE <= LoadExtSignD;
			MemTypeE <= MemTypeD;
			RegWriteE <= RegWriteD;
			MemtoRegE <= MemtoRegD;
			MemWriteE <= MemWriteD;
			ALUControlE <= ALUControlD;
			ALUSrcE <= ALUSrcD;
			RegDstE <= RegDstD;
			BranchE <= BranchD;
			ShiftE <= ShiftD;
			
			StartE <= StartD;
			MDSignE <= MDSignD;
			MDE <= MDD;
			ALUOutESelectE <= ALUOutESelectD;
			HLWriteE <= HLWriteD;
			
			OverflowCheckE <= OverflowCheckD;
			
			CP0ReadE <= CP0ReadD;
			CP0WriteE <= CP0WriteD;
			EXLClearE <= EXLClearD;
			AtDelaySlotE <= AtDelaySlotD;
		end 
 	end

endmodule
