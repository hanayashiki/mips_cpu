`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:19:52 11/14/2016 
// Design Name: 
// Module Name:    Interpreter 
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
module Interpreter(
    input [31:0] Instruction,
    output [5:0] Opcode,
    output [5:0] Func,
    output [4:0] RS,
    output [4:0] RT,
    output [4:0] RD,
    output [4:0] Shift,
    output [25:0] InstrIndex,
	 output [15:0] Immediate
    );
	assign Opcode = 		Instruction[31:26];
	assign Func = 			Instruction[5:0];
	assign RS = 			Instruction[25:21];
	assign RT = 			Instruction[20:16];
	assign RD = 			Instruction[15:11];
	assign Shift = 		Instruction[10:6];
	assign InstrIndex = 	Instruction[25:0];
	assign Immediate = 	Instruction[15:0];

endmodule
