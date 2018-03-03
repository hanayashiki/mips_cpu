`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:38:11 11/21/2016 
// Design Name: 
// Module Name:    MEMWBControlCarrier 
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
module MEMWBControlCarrier(
	 input InterruptRequest,
	 input clk, input reset,
    input RegWriteM,
    input MemtoRegM,
	 input LoadExtSignM,
	 input [1:0] MemTypeM,
	 input MemorySelectM,
	 input CP0ReadM,
    output reg RegWriteW = 0,
    output reg MemtoRegW = 0,
	 output reg LoadExtSignW = 0,
	 output reg [1:0] MemTypeW = 0,
	 output reg MemorySelectW = 0,
	 output reg CP0ReadW = 0
    );
	
	always @(posedge clk) begin
		if (reset || InterruptRequest) begin
			RegWriteW <= 0;
			MemtoRegW <= 0;
			LoadExtSignW <= 0;
			MemTypeW <= 0;
			MemorySelectW <= 0;
			CP0ReadW <= 0;
		end
		else begin
			RegWriteW <= RegWriteM;
			MemtoRegW <= MemtoRegM;
			LoadExtSignW <= LoadExtSignM;
			MemTypeW <= MemTypeM;
			MemorySelectW <= MemorySelectM;
			CP0ReadW <= CP0ReadM;
		end
	end

endmodule
