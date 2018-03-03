`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:27:37 12/12/2016 
// Design Name: 
// Module Name:    TC 
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
module TC(
    input clk,
    input reset,
    input [3:2] PrAddr,
    input WE,
    input [31:0] DataIn,
    output [31:0] DataOut,
    output InterruptRequest
    );
	//Ctrl: 		[3:3] 0 no interrupt
	//				  1 allow interrupt
	//		¡¡		[2:1]	00 mode 0
	//						01 mode 1
	//				[0:0] 0  stop counting
	//						1  allow counting
	
	reg [31:0] Ctrl = 0;   //short addr 00
	reg [31:0] Preset = 0; //           01
	reg [31:0] Count = 0;  //           10
	reg [15:0] Stage = 0;
	reg idle = 0;
	
	wire Interruptable;
	reg Interrupt = 0;
	wire [1:0] Mode;
	wire AllowCount;

	
	assign Interruptable = Ctrl[3];
	assign Mode = Ctrl[2:1];
	assign AllowCount = Ctrl[0];
	
	assign InterruptRequest = Interruptable && Count == 0;
	
	assign DataOut = (PrAddr == 0) ? Ctrl :
						  (PrAddr == 1) ? Preset :
						  (PrAddr == 2) ? Count :
						  32'hdead2333;
						  

	/*	0	idle
		1	load
		2  cnting
		3 	int */
	
	 always @(posedge clk)
		if (reset)
		begin
			Ctrl <= 0;
			Preset <= 0;
			Count <= 0;
			Stage <= 0;
		end
		else 
		begin
			if (Stage == 0) begin
				if (Preset >= 1 & Ctrl[0] ) begin
					Count <= Preset;
					Stage <= 1;
				end
			end
			if (Stage == 1) begin
				if (Ctrl[0]) begin
					if (Count >= 1) 
						Count <= Count - 1;
					else begin
						if (Ctrl[2:1] == 0) begin
							Stage <= 0;
							Ctrl[0] <= 0;
						end
						if (Ctrl[2:1] == 1) begin
							Count <= Preset;
						end						
					end
				end
			end
			if (WE == 1) begin
				if (PrAddr == 0) begin 
					Ctrl[3:0] <= DataIn[3:0];
					Count <= Preset;
					Stage <= 1;
				end
				if (PrAddr == 1) Preset <= DataIn;
				if (PrAddr == 2) Count <= DataIn;
			end
		end
endmodule
