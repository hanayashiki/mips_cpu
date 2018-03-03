`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:58:24 11/13/2016 
// Design Name: 
// Module Name:    GRF 
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
module GRF(
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WD,

	 input [31:0] InstrW,
	 input Clr,
	 input Clk,
    output [31:0] RD1,
    output [31:0] RD2,
    input WE,
	 input [31:0] PCW
    );
	 
	reg [31:0] Registers [31:0];
	assign RD1 = Registers[A1];
	assign RD2 = Registers[A2];
	integer i;
	initial begin
		for (i = 0;i<32;i=i+1) begin
			Registers[i] = 0;
		end
	end
	always @(posedge Clk) begin
		if (Clr) begin
			for (i = 0;i<32;i=i+1) begin
				Registers[i] = 0;
				//$display("i = %h",A3,WD);
			end
		end
		else begin
			if (WE) begin
				Registers[A3] = WD;
				//if (PCW < 32'h00004180) begin
				$display("$%d <= %h",A3,WD);
				//end
				//if (A3 == 29 && WD == 32'h000089cc) $display("fuck---------------: %b,%b,%b,%b, %h",InstrW[31:26],InstrW[20:16],InstrW[15:11],InstrW[5:0], PCW);
				
			end
		end
		Registers[0] = 0;
		for (i = 0;i<32;i=i+1) begin
			//$display("$%d = %h",i,Registers[i]);
		end
	end
endmodule
