`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:15:57 11/21/2016 
// Design Name: 
// Module Name:    LevelE 
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
module LevelE(
	 input InterruptRequest,
    input clk, inout reset,
    input [1:0] ForwardAE,input [1:0] ForwardBE,
    input [31:0] ResultW,
	 inout [31:0] ALUOutM,
	 input [31:0] InstrE, output [31:0] InstrM,
    input [31:0] RD1E,input [31:0] RD2E,
    input [4:0] RsE,input [4:0] RtE,input [4:0] RdE,
    input [31:0] SignImmE,
	 input [1:0] MemTypeE, input LoadExtSignE,
    input ShiftE, input RegWriteE,input MemtoRegE,input MemWriteE,input [3:0] ALUControlE,input ALUSrcE,input RegDstE,
	 output [1:0] MemTypeM, output LoadExtSignM,
    output RegWriteM,output MemtoRegM,output MemWriteM, 
    output [31:0] WriteDataM,output [4:0] WriteRegM,
    output [4:0] WriteRegE,
	 input LeftRightE,
	 output LeftRightM,
	 //error
	 input [31:0] PCE,
	 output [31:0] PCM,
	 input ErrorRlE,
	 output ErrorRlM,
	 output ErrorOvM,
	 //overflow
	 input OverflowCheckE,
	 //md
	 input StartE, input MDSignE, input MDE,
	 input [1:0] ALUOutESelectE,
	 input HLWriteE,
	 output BusyE,
	 output StartM,
	 //cp0
	 input CP0WriteE, 
	 output CP0WriteM,
	 input CP0ReadE,
	 output CP0ReadM,
	 input EXLClearE,
	 output EXLClearM,
	 input AtDelaySlotE,
	 output AtDelaySlotM,
	 output [4:0] RdM
    );
	 wire [31:0] Shift;
	 
	 wire [31:0] ALUA;
	 wire [31:0] ALUA1;
	 wire [31:0] ALUB;
	 wire [31:0] ALUB1;
	 wire [31:0] ALUOutEN;
	 wire [31:0] ALUOutE;
	 wire [31:0] WriteDataE;
	 
	 wire [4:0] msbE;
	 wire [4:0] lsbE;
	 
	 wire [31:0] HI;
	 wire [31:0] LO;
	 
	 wire ErrorOvE;
	 wire OverflowE;
	 wire Div0E;
	 
	 assign ErrorOvE = OverflowE && OverflowCheckE || Div0E;
	 
	 assign WriteDataE = ALUB1;
	 assign Shift = {27'b0,SignImmE[10:6]};
	 
	 //for ins
	 assign msbE = SignImmE[15:11];
	 assign lsbE = SignImmE[10:6];

	MD MD(.clk(clk),.reset(reset),.D1(ALUA),.D2(ALUB),.Start(StartE),.MDSign(MDSignE),.MD(MDE),.HLWrite(HLWriteE),
		.PCE(PCE),
	   .Busy(BusyE),
		.HI(HI),.LO(LO),
		.Div0(Div0E),
		.InterruptRequest(InterruptRequest));

	ALU ALU(.A(ALUA),.B(ALUB),.msb(msbE),.lsb(lsbE),.Out(ALUOutEN),.OP(ALUControlE),.Overflow(OverflowE));	 
	
	MUX323 MUX323a(.In0(RD1E),.In1(ResultW),.In2(ALUOutM),.Select(ForwardAE),.Out(ALUA1));// for ALU A1
	MUX322 MUX322c(.In0(ALUA1),.In1(Shift),.Select(ShiftE),.Out(ALUA));	
	
	MUX323 MUX323b(.In0(RD2E),.In1(ResultW),.In2(ALUOutM),.Select(ForwardBE),.Out(ALUB1));// for ALU B1
	MUX322 MUX322d(.In0(ALUB1),.In1(SignImmE),.Select(ALUSrcE),.Out(ALUB));
	
	MUX52  MUX52d (.In0(RtE),.In1(RdE),.Select(RegDstE),.Out(WriteRegE));
	
	MUX323 MUX323e(.In0(ALUOutEN),.In1(HI),.In2(LO),.Select(ALUOutESelectE),.Out(ALUOutE));
	

	EXMEM EXMEM(
	 .InterruptRequest(InterruptRequest),
	 .clk(clk),.reset(reset),
	 .InstrE(InstrE),.InstrM(InstrM),
	 .RdE(RdE),
	 .RdM(RdM),
    .ALUOutE(ALUOutE),.WriteDataE(WriteDataE),.WriteRegE(WriteRegE),
	 .ALUOutM(ALUOutM),.WriteDataM(WriteDataM),.WriteRegM(WriteRegM));
	
	EXMEMControlCarrier EXMEMControlCarrier(
	 .InterruptRequest(InterruptRequest),
	 .clk(clk),.reset(reset),
	 .LeftRightE(LeftRightE),
	 .LeftRightM(LeftRightM),
	 .StartE(StartE),
	 .StartM(StartM),
	 .CP0WriteE(CP0WriteE),.CP0ReadE(CP0ReadE),.EXLClearE(EXLClearE),.AtDelaySlotE(AtDelaySlotE),
	 .CP0WriteM(CP0WriteM),.CP0ReadM(CP0ReadM),.EXLClearM(EXLClearM),.AtDelaySlotM(AtDelaySlotM),
	 .LoadExtSignE(LoadExtSignE),.MemTypeE(MemTypeE),.RegWriteE(RegWriteE),.MemtoRegE(MemtoRegE),.MemWriteE(MemWriteE),
    .LoadExtSignM(LoadExtSignM),.MemTypeM(MemTypeM),.RegWriteM(RegWriteM),.MemtoRegM(MemtoRegM),.MemWriteM(MemWriteM));
	 
	ExcCarrierE ExcCarrierE(
	 .InterruptRequest(InterruptRequest),
    .clk(clk),
    .reset(reset),
	 .ErrorRlE(ErrorRlE),
	 .ErrorRlM(ErrorRlM),
    .ErrorOvE(ErrorOvE),
    .ErrorOvM(ErrorOvM),
    .PCE(PCE),
    .PCM(PCM));
endmodule
