`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:54:40 11/13/2016 
// Design Name: 
// Module Name:    RAM 
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
module RAM(
    input Clk,
    input Clr,
	 input WE,
	 input Sign,
	 input LeftRight,
	 input [1:0] MemType, // 00 word, 01 half word, 11 byte
    input [10:0] Address,
	 input [1:0] Low,
    input [31:0] DataIn,
	 input InDMM,
    output [31:0] Out,
	 output [15:0] OutH,
	 output [7:0] OutB,
	 output [31:0] OutC
    );
	 //Address from 0x00000000 to 0x00001fff
	reg [31:0] Data [2047:0]; //2048 words
	wire [31:0]AddrShow;
	wire [31:0]DataPre;
	
	wire [15:0]HalfWord;
	wire [31:0]HalfWordOut;
	wire [7:0]Byte;
	wire [31:0]ByteOut;
	
	wire [31:0]OutCL;
	wire [31:0]OutCR;
	
	assign OutH = (Low == 0) ? DataPre[15:0] :  DataPre[31:16];
	assign OutB = (Low == 0) ? DataPre[7:0] :
					  (Low == 1) ? DataPre[15:8] :	
					  (Low == 2) ? DataPre[23:16] :	DataPre[31:24];
					  
	assign OutCL = (Low == 0) ? {DataPre[7:0],DataIn[23:0]}:
						(Low == 1) ? {DataPre[15:0],DataIn[15:0]}:
						(Low == 2) ? {DataPre[23:0],DataIn[7:0]}:
						DataPre[31:0];
	assign OutCR = (Low == 0) ? DataPre[31:0]:
						(Low == 1) ? {DataIn[31:24],DataPre[31:8]}:
						(Low == 2) ? {DataIn[31:16],DataPre[31:16]}:
						{DataIn[31:8],DataPre[31:24]};
	
	assign OutC = (LeftRight == 0) ? OutCL: OutCR;
		
	assign Out = Data[Address];
	assign AddrShow = {19'h00000,Address,Low[1:0]}; // 20+10+2
	assign DataPre = Data[Address];
	integer i;
	initial begin
		for (i = 0;i<=2047;i=i+1) begin
			Data[i] =  0;
		end
	end
	always @(posedge Clk) begin
		if (Clr) begin
			//for (i = 0;i<100;i=i+1) begin
				//$display("ram %d:%d",i,Data[i]);
			//end
			for (i = 0;i<=2047;i=i+1) begin
				Data[i] = 0;
			end
		end
		else begin
			if (WE && InDMM) begin
				if (MemType == 0) begin
					Data[Address] = DataIn;
					//$display("*%h <= %h",AddrShow,DataIn);
				end
				if (MemType == 1) begin  // half word
					if (Low == 0) 	Data[Address] = {DataPre[31:16],DataIn[15:0]};
					if (Low == 2) 	Data[Address] = {DataIn[15:0],DataPre[15:0]};
				//	$display("*%h <= %h",AddrShow,DataIn[15:0]);
				end
				if (MemType == 3) begin // byte
					if (Low == 0) 	Data[Address] = {DataPre[31:8],DataIn[7:0]};
					if (Low == 1) 	Data[Address] = {DataPre[31:16],DataIn[7:0],DataPre[7:0]};
					if (Low == 2) 	Data[Address] = {DataPre[31:24],DataIn[7:0],DataPre[15:0]};
					if (Low == 3) 	Data[Address] = {DataIn[7:0],DataPre[23:0]};
				//	$display("*%h <= %h",AddrShow,DataIn[7:0]);
				end
			end
		end
	end
endmodule
