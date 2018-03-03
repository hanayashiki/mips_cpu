`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:59:29 11/21/2016 
// Design Name: 
// Module Name:    EXMEMControlCarrier 
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
module EXMEMControlCarrier(
	 input InterruptRequest,
	 input clk, input reset,
    input RegWriteE,
    input MemtoRegE,
    input MemWriteE,
	 input [1:0] MemTypeE,
	 input LoadExtSignE,
	 input LeftRightE,
	 input CP0WriteE,
	 input CP0ReadE,
	 input EXLClearE,
	 input AtDelaySlotE,
	 input StartE,
    output reg RegWriteM = 0,
    output reg MemtoRegM = 0,
    output reg MemWriteM = 0,
	 output reg [1:0] MemTypeM = 0,
	 output reg LoadExtSignM = 0,
	 output reg LeftRightM = 0,
	 output reg CP0WriteM = 0,
	 output reg CP0ReadM = 0,
	 output reg EXLClearM = 0,
	 output reg AtDelaySlotM = 0,
	 output reg StartM = 0
    );
	always @(posedge clk) begin
		if (reset || InterruptRequest) begin
			MemTypeM <= 0;
			RegWriteM <= 0;
			MemtoRegM <= 0;
			MemWriteM <= 0;
			LoadExtSignM <= 0;
			LeftRightM <= 0;
			CP0WriteM <= 0;
			CP0ReadM <= 0;
			EXLClearM <= 0;
			AtDelaySlotM <= 0;
			StartM <= 0;
		end
		else begin
			MemTypeM <= MemTypeE;
			RegWriteM <= RegWriteE;
			MemtoRegM <= MemtoRegE;
			MemWriteM <= MemWriteE;
			LoadExtSignM <= LoadExtSignE;
			LeftRightM <= LeftRightE;
			CP0WriteM <= CP0WriteE;
			CP0ReadM <= CP0ReadE;
			EXLClearM <= EXLClearE;
			AtDelaySlotM <= AtDelaySlotE;
			StartM <= StartE;
		end
	end

endmodule
