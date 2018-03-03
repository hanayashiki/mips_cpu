`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:41:56 11/13/2016 
// Design Name: 
// Module Name:    PC 
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
module PC(
    input [31:0] In,
    input Clk,
	 input Clr,
	 input StallF,
	 input [2:0] Source,
	 input InterruptRequest,
    output reg [31:0] Address = 32'h00003000
    );
	
	always @(posedge Clk) begin
		if (Clr) begin
			Address = 32'h00003000;
		end
		else begin
			if (StallF != 1 || InterruptRequest == 1) begin 
				Address = In;
				//if (Source != 0) $display("j %h", Address);
			end
		end
	end
endmodule
