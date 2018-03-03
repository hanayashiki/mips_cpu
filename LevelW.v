`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:59:42 11/21/2016 
// Design Name: 
// Module Name:    LevelW 
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
module LevelW(
	 input InterruptRequest,
    input [31:0] ReadDataW,
	 input [31:0] ReadDataCW,
	 input [15:0] ReadDataHW,
	 input [7:0] ReadDataBW,
    input [31:0] ALUOutW,
	 input [1:0] MemTypeW, // 00 word, 01 half word, 11 byte
	 input LoadExtSignW,
    output [31:0] ResultW,
    input MemtoRegW,
	 input MemorySelectW,
	 input [31:0] CPURDW,
	 input [31:0] CP0DataOutW,
	 input CP0ReadW
    );
	 wire [31:0] ReadDataHExt;
	 wire [31:0] ReadDataBExt;
	 wire [31:0] ReadDataFW;
	 wire [31:0] ReadDataFFW;
	 wire [31:0] ReadDataFFFW;
	 
	 bitExtender16to32 bitExtender1(.In(ReadDataHW),.Out(ReadDataHExt),.sign(LoadExtSignW));	 
	 bitExtender8to32 bitExtender2(.In(ReadDataBW),.Out(ReadDataBExt),.sign(LoadExtSignW));	
	 
	 MUX324 MUX324(.In0(ReadDataW),.In1(ReadDataHExt),.In2(ReadDataCW),.In3(ReadDataBExt),.Select(MemTypeW),.Out(ReadDataFW));
	 
	 MUX322 MUX322a(.In0(ReadDataFW),.In1(CPURDW),.Select(MemorySelectW),.Out(ReadDataFFW));
	 
	 MUX322 MUX322b(.In0(ReadDataFFW),.In1(CP0DataOutW),.Select(CP0ReadW),.Out(ReadDataFFFW));
	 
	 MUX322 MUX322c(.In0(ALUOutW),.In1(ReadDataFFFW),.Select(MemtoRegW),.Out(ResultW));
	 


endmodule
