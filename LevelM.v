`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:16:06 11/21/2016 
// Design Name: 
// Module Name:    LevelM 
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
module LevelM(
	 input InterruptRequest,
    input clk,
	 input clk2,
	 input reset,
	 input ForwardM,
	 input [31:0] ResultW,
	 input [31:0] InstrM, output [31:0] InstrW,
    input [31:0] ALUOutM,
    input [31:0] WriteDataM,
    input [4:0] WriteRegM,
    input RegWriteM,
    input MemtoRegM,
    input MemWriteM,
	 input [1:0] MemTypeM, // 00 word, 01 half word, 11 byte
	 input LoadExtSignM,
	 //lwl lwr
	 input LeftRightM,
    output RegWriteW,
    output MemtoRegW,
	 output LoadExtSignW,
    output [31:0] ReadDataW,
	 output [31:0] ReadDataCW,
	 output [15:0] ReadDataHW,
	 output [7:0] ReadDataBW,
	 
    output [31:0] ALUOutW,
    output [4:0] WriteRegW,
	 output [1:0] MemTypeW,
	 //bridge
	 input [31:0] CPURD,
	 output [31:0] CPURDW,
	 input MemorySelectM,
	 output MemorySelectW,
	 output [31:0] WriteDataMF,
	 //cp0
	 input [31:0] CP0DataOutM,
	 output [31:0] CP0DataOutW,
	 input CP0ReadM,
	 output CP0ReadW,
	 input [31:0] PCM,
	 output [31:0] PCW
    );
	 wire [31:0] ReadDataM;
	 wire [31:0] ReadDataCM;
	 wire [15:0] ReadDataHM;
	 wire [7:0] ReadDataBM;
//	 wire [31:0] WriteDataMF;
	 wire [10:0] Address;
	 wire [1:0] Low;
	 wire InDMM;
	 
	 wire [3:0] wea;
	 
	 
	 reg LoadExtSignWUse;
	 
	 wire [31:0] WriteDataMFMove;
	 
	 
	 assign wea = MemWriteM ? (
	 (MemTypeM == 0) ? 4'b1111 :
	 (MemTypeM == 1 && Low == 0) ? 4'b0011 :
	 (MemTypeM == 1 && Low == 2) ? 4'b1100 :
	 (MemTypeM == 3 && Low == 0) ? 4'b0001 :
	 (MemTypeM == 3 && Low == 1) ? 4'b0010 :
	 (MemTypeM == 3 && Low == 2) ? 4'b0100 :
	/*(MemType == 3 && Low == 3)*/4'b1000
	 ) : 0;
	 
	 assign WriteDataMFMove = (Low == 3) ? (WriteDataMF << 24) :
									  (Low == 2) ? (WriteDataMF << 16) :
									  (Low == 1) ? (WriteDataMF << 8) :
									  WriteDataMF;
									  
	 assign ReadDataHM = (Low == 0) ? ReadDataM[15:0] :  ReadDataM[31:16];
	 assign ReadDataBM = (Low == 0) ? ReadDataM[7:0] :
								(Low == 1) ? ReadDataM[15:8] :	
								(Low == 2) ? ReadDataM[23:16] :	ReadDataM[31:24];
	 
	 
	 assign InDMM = ALUOutM <= 8191;

 	/*RAM RAM(.Clk(clk),.Clr(reset),.Address(Address),.Sign(LoadExtSignM),.Low(Low),.MemType(MemTypeM),.DataIn(WriteDataMF),
	.Out(ReadDataM),.WE(MemWriteM),
	.OutH(ReadDataHM),.OutB(ReadDataBM),.OutC(ReadDataCM),
	.LeftRight(LeftRightM),.InDMM(InDMM));*/
	
	DMBlock RAM (
		.clka(clk2), // input clka
		.wea(wea), // input [3 : 0] wea
		.addra(Address), // input [10 : 0] addra
		.dina(WriteDataMFMove), // input [31 : 0] dina
		.douta(ReadDataM) // output [31 : 0] douta
	);
	
	MUX322 MUX322(.In0(WriteDataM),.In1(ResultW),.Select(ForwardM),.Out(WriteDataMF));
	
	RAMAddrTranslator RAMAddrTranslator(.In(ALUOutM),.Out(Address),.Low(Low)); 
	MEMWB MEMWB(
	 .PCM(PCM),
	 .PCW(PCW),
	 .InterruptRequest(InterruptRequest),
	 .clk(clk),.reset(reset),
    .ReadDataM(ReadDataM),.ReadDataW(ReadDataW),
	 .ReadDataCM(ReadDataCM),.ReadDataHM(ReadDataHM),.ReadDataBM(ReadDataBM),
	 .ReadDataCW(ReadDataCW),.ReadDataHW(ReadDataHW),.ReadDataBW(ReadDataBW),	 

	 .ALUOutM(ALUOutM),.ALUOutW(ALUOutW),
    .WriteRegM(WriteRegM),.WriteRegW(WriteRegW),
	 .InstrM(InstrM),.InstrW(InstrW),
	 .CPURD(CPURD),.CPURDW(CPURDW),
	 .CP0DataOutM(CP0DataOutM),
	 .CP0DataOutW(CP0DataOutW));
	
	 MEMWBControlCarrier MEMWBControlCarrier(
	 .InterruptRequest(InterruptRequest),
	 .clk(clk),.reset(reset),
	 .CP0ReadM(CP0ReadM),
	 .CP0ReadW(CP0ReadW),
	 .MemTypeM(MemTypeM),.LoadExtSignM(LoadExtSignM),
	 .MemTypeW(MemTypeW),.LoadExtSignW(LoadExtSignW),
	 .RegWriteM(RegWriteM),.MemtoRegM(MemtoRegM),
    .RegWriteW(RegWriteW),.MemtoRegW(MemtoRegW),
	 .MemorySelectM(MemorySelectM),
	 .MemorySelectW(MemorySelectW)
	 );
	 
	 always @(posedge clk) begin
		LoadExtSignWUse <= LoadExtSignW;
	 end
endmodule