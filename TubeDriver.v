`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:49:33 12/25/2016 
// Design Name: 
// Module Name:    TubeDriver 
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
module TubeDriver(
	 input clk,
	 input reset,
	 input Call,
	 input WE,
    input [31:0] DataIn,
    output reg [3:0] tube0sel = 0,
    output reg [3:0] tube1sel = 0,
    output reg tube2sel = 1,
    
    output [7:0] tube0,
    output [7:0] tube1,
    output [7:0] tube2
    );
	 reg [31:0] Data = 0;
	 reg [3:0] Num0 = 0;
	 reg [3:0] Num1 = 0;
	 reg [1:0] State = 0;
	 reg Positive = 1;
	 
	 assign tube2 = Positive == 1 ? 8'b11111111 : 8'b11111110;
	 
	 TubeDigiTranlator Tran0 (
    .Num(Num0), 
    .Out(tube0)
    );

	 TubeDigiTranlator Tran1 (
    .Num(Num1), 
    .Out(tube1)
    );
	 
	 always @(posedge clk) begin
		if (reset) begin
			Data <= 0;
			Num0 <= 0;
			Num1 <= 0;
		end
		else begin
		   if (WE == 1) begin
				Data <= DataIn[31] == 0 ? DataIn : ~(DataIn-1);
				Positive <= (DataIn[31] == 0);
				$display("Tube <= %h", DataIn);
			end
			if (Call) begin
				if (State == 0) begin
					Num0 <= Data[3:0];
					Num1 <= Data[19:16];
					tube0sel <= 4'b0001;
					tube1sel <= 4'b0001;
					State <= 1;
				end
				if (State == 1) begin
					Num0 <= Data[7:4];
					Num1 <= Data[23:20];
					tube0sel <= 4'b0010;
					tube1sel <= 4'b0010;
					State <= 2;
				end
				if (State == 2) begin
					Num0 <= Data[11:8];
					Num1 <= Data[27:24];
					tube0sel <= 4'b0100;
					tube1sel <= 4'b0100;
					State <= 3;
				end
				if (State == 3) begin
					Num0 <= Data[15:12];
					Num1 <= Data[31:28];
					tube0sel <= 4'b1000;
					tube1sel <= 4'b1000;
					State <= 0;
				end
			end
		end
	 end

	 
endmodule
