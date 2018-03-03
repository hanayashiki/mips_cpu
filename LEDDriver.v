`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:07:40 12/25/2016 
// Design Name: 
// Module Name:    LEDDriver 
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
module LEDDriver(
    input clk,
    input reset,
    input [31:0] DataIn,
    output reg [31:0] Drive = 0,
    input WE
    );
	 
	 always @(posedge clk) begin
		if (reset) begin
			Drive <= 0;
		end
		else 
		begin
			if (WE) begin
				Drive <= DataIn;
			end
		end
	 end


endmodule
