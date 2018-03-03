`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:59:22 11/13/2016 
// Design Name: 
// Module Name:    IM 
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
module IM(
    input [31:0] Address, //???
    output [31:0] Instruction
    );
	 reg [31:0] Memory[2047:0];
	 wire [10:0] AddrTrans; // 11bits - 2048 words
	 integer i;
	initial begin
		for (i = 0; i<= 2047; i = i+1) begin
			Memory[i] = 0;
		end
		$readmemh("code/1code.txt", Memory);
		$readmemh("1codeExc.txt", Memory, 32'h00000460, 32'h000007ff);
	end
	assign AddrTrans = Address[12:2]-(32'h00000c00);
	assign Instruction = Memory[AddrTrans];
endmodule
