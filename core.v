`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:31:09 11/20/2016 
// Design Name: 
// Module Name:    mips 
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
module core(
    input clk,
	 input clk2,
    input reset,
	 output MemWriteM,
	 output [31:0] CPUWD,
	 output [31:0] CPUAddress,
	 output [31:0] PCM,
	 input [31:0] CPURD,
	 input MemorySelectM,
	 input [5:0]CP0InterruptRequest
    );
	 //for Bridge Connection
	 assign CPUAddress = ALUOutM;
	 assign CPUWD = WriteDataMF;

	 wire [31:0] InstrE;
	 wire [31:0] InstrM;
	 wire [31:0] InstrW;
	 
	 // F
	 wire StallF,StallD;//CLRF;
	 wire [2:0] PCSrcD;
	 wire [31:0] PCPlus4D;
	 wire [31:0] PCBranch1D;
	 wire [31:0] PCBranch2D;
	 wire [31:0] PCBranch3D;
	 wire [31:0] InstrD;
	 
	 wire [31:0] PCD;
	 wire AtDelaySlotF;
	 wire AtDelaySlotD;
	 wire AtDelaySlotE;
	 wire AtDelaySlotM;
	 wire CancelF;
	 // D
	 wire [1:0] ForwardAD;
	 wire [1:0] ForwardBD;
	 wire FlushE,CLRD;
	 wire RegWriteW;
	 wire MemtoRegD;
	 wire MemWriteD;
	 wire [1:0] MemTypeD;
	 wire [4:0] WriteRegW; //亟GRF仇峽
	 wire [31:0] ResultW;
	 wire [31:0] ALUOutM;
	 wire [31:0] RD1E;
	 wire [31:0] RD2E;
	 wire [4:0] RsE;
	 wire [4:0] RtE;
	 wire [4:0] RdE;
	 wire [4:0] RtD;
	 wire [4:0] RsD;
	 wire [31:0] SignImmE;
	 
	 wire RegWriteE, MemtoRegE, MemWriteE;
	 wire [3:0] ALUControlE;
	 wire ALUSrcE, RegDstE, BranchD, BranchE ,ShiftE, CP0WriteE, CP0ReadE, EXLClearE;
	 
	 wire StartE, MDSignE, MDE;
	 wire [1:0] ALUOutESelectE;
	 wire HLWriteE;
	 wire MDUseD;
	 wire MulFlushE;
	 
	 wire LeftRightE;
	 
	 wire OverflowCheckE;
	 wire ErrorRlE;
	 wire [31:0] PCE;
	 //E
	 wire [1:0] ForwardAE;
	 wire [1:0] ForwardBE;
 	 wire RegWriteM,MemtoRegM,/*MemWriteM,*/ALUControlM,ALUSrcM,RegDstM,LoadExtSignE;
	 wire [1:0] MemTypeE;
	 wire [31:0] WriteDataM;
	 wire [31:0] WriteDataMF;
	 wire [4:0] WriteRegM;
	 wire [4:0] WriteRegE;
	
	 wire BusyE;
	
	 wire LeftRightM;
	
	 //wire [31:0] PCM;
	 wire ErrorRlM;
	 wire ErrorOvM;
	
	 wire [4:0] RdM;
	 wire CP0ReadM;
	 wire EXLClearM;
	 // M
	 wire MemtoRegW;
	 wire [31:0] ALUOutW;
	 wire [1:0] MemTypeM;
	 wire [1:0] MemTypeW;
	 wire LoadExtSignM;
	 wire LoadExtSignW;
	 wire [31:0] ReadDataW; 
	 wire [31:0] ReadDataCW;
	 wire [15:0] ReadDataHW;
	 wire [7:0] ReadDataBW;
	 
	 wire ForwardM;
	 
	 //bridge
	 wire MemorySelectW;
	 wire [31:0] CPURDW;
	 //cp0
	 wire CP0ReadW;
	 wire [31:0] CP0DataOutW;
	 wire [31:0] PCW;
	 
	 wire InterruptRequest;
	 wire [31:0] CP0EPCM;
	 wire [31:0] CP0DataOutM;

	LevelF LevelF(
	 .InterruptRequest(InterruptRequest),
    .clk(clk),.clk2(clk2),.reset(reset),
	 .StallF(StallF),.StallD(StallD),//.CLR(CLRF),
	 .PCSrcD(PCSrcD),.PCPlus4D(PCPlus4D),.PCBranch1D(PCBranch1D),.PCBranch2D(PCBranch2D),.PCBranch3D(PCBranch3D),.EPC(CP0EPCM),
	 .InstrD(InstrD),.PCD(PCD),
	 .CancelF(CancelF),
	 .AtDelaySlotF(AtDelaySlotF),
	 .AtDelaySlotD(AtDelaySlotD));
	 
	
	 
	LevelD LevelD(
	 .InterruptRequest(InterruptRequest),
	 .clk(clk),.reset(reset),.FlushE(FlushE),.CLR(CLRD),
    .ForwardAD(ForwardAD),
    .ForwardBD(ForwardBD),
    .RegWriteW(RegWriteW),
	 .InstrW(InstrW),
	 .InstrD(InstrD),
	 .PCPlus4D(PCPlus4D),
	 .WriteRegW(WriteRegW),
    .ResultW(ResultW),
    .ALUOutM(ALUOutM),
	 .PCSrcD(PCSrcD),
    .PCBranch1D(PCBranch1D),
    .PCBranch2D(PCBranch2D),
	 .PCBranch3D(PCBranch3D),
	 //.CLRF(CLRF),
    .RD1E(RD1E),
    .RD2E(RD2E),
    .RsE(RsE),
    .RtE(RtE),
    .RdE(RdE),
    .SignImmE(SignImmE),
	 
	 .ShiftE(ShiftE),
	 .RegWriteE(RegWriteE),
	 .MemtoRegE(MemtoRegE),
	 .MemWriteE(MemWriteE),
	 .ALUControlE(ALUControlE),
	 .ALUSrcE(ALUSrcE),
	 .RegDstE(RegDstE),
	 .MemTypeE(MemTypeE),
	 .LoadExtSignE(LoadExtSignE),
	 
	 .RsD(RsD),
	 .RtD(RtD),
	 .BranchD(BranchD),
	 .BranchE(BranchE),
	 .MemtoRegD(MemtoRegD),
	 .MemWriteD(MemWriteD),
	 
	 .InstrE(InstrE),
	 //error
	 .ErrorRlE(ErrorRlE),
	 .PCD(PCD),
	 .PCE(PCE),
	 .PCW(PCW),
	 //md
	 .MulFlushE(MulFlushE),
	 .StartE(StartE),.MDSignE(MDSignE),.MDE(MDE),
	 .ALUOutESelectE(ALUOutESelectE),
	 .HLWriteE(HLWriteE),
	 .MDUseD(MDUseD),
	 //cp0
	 .EXLClearD(EXLClearD),.CP0WriteE(CP0WriteE),.CP0ReadE(CP0ReadE),.EXLClearE(EXLClearE),.CancelF(CancelF),
	 
	 .LeftRightE(LeftRightE),
	 
	 .OverflowCheckE(OverflowCheckE),
	 
	 .AtDelaySlotF(AtDelaySlotF),
	 .AtDelaySlotD(AtDelaySlotD),
	 .AtDelaySlotE(AtDelaySlotE)
	 );
	 
	 

	
	LevelE LevelE(
	 .InterruptRequest(InterruptRequest),
    .clk(clk),.reset(reset),
    .ForwardAE(ForwardAE),.ForwardBE(ForwardBE),
    .ResultW(ResultW),.ALUOutM(ALUOutM),
    .RD1E(RD1E),.RD2E(RD2E),
    .RsE(RsE),.RtE(RtE),.RdE(RdE),
    .SignImmE(SignImmE),
	 
	 .ShiftE(ShiftE),
    .RegWriteE(RegWriteE),.MemtoRegE(MemtoRegE),.MemWriteE(MemWriteE),.ALUControlE(ALUControlE),.ALUSrcE(ALUSrcE),.RegDstE(RegDstE),
    .RegWriteM(RegWriteM),.MemtoRegM(MemtoRegM),.MemWriteM(MemWriteM),
    .WriteDataM(WriteDataM),.WriteRegM(WriteRegM),
    .WriteRegE(WriteRegE),
	 .MemTypeE(MemTypeE),
	 .MemTypeM(MemTypeM),
	 .LoadExtSignE(LoadExtSignE),
	 .LoadExtSignM(LoadExtSignM),
	 
	 .InstrE(InstrE),
	 .InstrM(InstrM),
	 
	 .LeftRightE(LeftRightE),
	 .LeftRightM(LeftRightM),
	 
	 //mdHLWriteE
	 .StartE(StartE),.MDSignE(MDSignE),.MDE(MDE),
	 .HLWriteE(HLWriteE),
	 .ALUOutESelectE(ALUOutESelectE),
	 .BusyE(BusyE),
	 .StartM(StartM),
	 
	 .OverflowCheckE(OverflowCheckE),
	 
	 .PCE(PCE),
	 .PCM(PCM),
	 .ErrorRlE(ErrorRlE),
	 .ErrorRlM(ErrorRlM),
	 .ErrorOvM(ErrorOvM),
	 //cp0
	 .CP0ReadE(CP0ReadE),.CP0ReadM(CP0ReadM),
	 .CP0WriteE(CP0WriteE),.CP0WriteM(CP0WriteM),
	 .EXLClearE(EXLClearE),.EXLClearM(EXLClearM),
	 .RdM(RdM),
	 .AtDelaySlotE(AtDelaySlotE),
	 .AtDelaySlotM(AtDelaySlotM)
	 );
	 

	 
	 LevelM LevelM(
	 .InterruptRequest(InterruptRequest),
    .clk(clk),.clk2(clk2),.reset(reset),
	 .ForwardM(ForwardM),
	 .ResultW(ResultW),
    .WriteDataM(WriteDataM),
	 .LoadExtSignM(LoadExtSignM),
	 .MemWriteM(MemWriteM),.MemTypeM(MemTypeM),
	 .RegWriteM(RegWriteM),.MemtoRegM(MemtoRegM),
	 .RegWriteW(RegWriteW),.MemtoRegW(MemtoRegW),
	 .ALUOutM(ALUOutM),
    .ReadDataW(ReadDataW),.ALUOutW(ALUOutW),
	 .WriteRegM(WriteRegM),
	 .WriteRegW(WriteRegW),
	 
	 .ReadDataCW(ReadDataCW),.ReadDataHW(ReadDataHW),.ReadDataBW(ReadDataBW),
	 .MemTypeW(MemTypeW),.LoadExtSignW(LoadExtSignW),
	 
	 .InstrM(InstrM),
	 .InstrW(InstrW),
	 
	 .LeftRightM(LeftRightM),
	 
	 //bridge
	 .CPURD(CPURD),
	 .CPURDW(CPURDW),
	 .MemorySelectM(MemorySelectM),
	 .MemorySelectW(MemorySelectW),
	 .WriteDataMF(WriteDataMF),
	 
	 //cp0
	 .CP0ReadM(CP0ReadM),.CP0ReadW(CP0ReadW),
	 .CP0DataOutM(CP0DataOutM),
	 .CP0DataOutW(CP0DataOutW),
	 .PCM(PCM),
	 .PCW(PCW)
	 );
	 
	 //W
	 LevelW LevelW(
	 .InterruptRequest(InterruptRequest),
    .ReadDataW(ReadDataW),
	 .ReadDataCW(ReadDataCW),.ReadDataHW(ReadDataHW),.ReadDataBW(ReadDataBW),
	 .MemTypeW(MemTypeW),.LoadExtSignW(LoadExtSignW),
    .ALUOutW(ALUOutW),
    .ResultW(ResultW),
    .MemtoRegW(MemtoRegW),
	 
	 //bridge
	 .CPURDW(CPURDW),
	 .MemorySelectW(MemorySelectW),
	 //cp0
	 .CP0ReadW(CP0ReadW),
	 .CP0DataOutW(CP0DataOutW)
    );
	
	 HazardUnit HazardUnit(
	 .clk(clk),
    .StallF(StallF),
    .StallD(StallD),
    .ForwardAD(ForwardAD), 
    .ForwardBD(ForwardBD),
    .FlushE(FlushE),
    .ForwardAE(ForwardAE),
    .ForwardBE(ForwardBE),
	 .ForwardM(ForwardM),
	 
    .BranchD(BranchD),
	 .BranchE(BranchE),
    .MemtoRegD(MemtoRegD),
    .MemtoRegE(MemtoRegE),
	 .MemWriteD(MemWriteD),
	 .MemWriteM(MemWriteM),
    .RegWriteE(RegWriteE),
    .MemtoRegM(MemtoRegM),
    .RegWriteM(RegWriteM),
    .RegWriteW(RegWriteW),
    .RsD(RsD),
    .RtD(RtD),
    .RsE(RsE),
    .RtE(RtE),
    .WriteRegE(WriteRegE),
    .WriteRegM(WriteRegM),
    .WriteRegW(WriteRegW),
	 //md
	 .MDUseD(MDUseD),
	 .BusyE(BusyE),
	 .StartE(StartE),
	 .MulFlushE(MulFlushE),
	 //cp0
	 .EXLClearD(EXLClearD),
	 .CP0WriteE(CP0WriteE),
	 .CP0WriteM(CP0WriteM),
	 .RdE(RdE),
	 .RdM(RdM)

	 
    );
	 

	 
	 CP0 CP0(.clk(clk),.reset(reset),
	 .PCM(PCM),
	 .Address(RdM), //read cp0 for mfc0
    .DataIn(WriteDataM),
    .ExcPC(PCM),
    .ErrorRlM(ErrorRlM),
    .ErrorOvM(ErrorOvM),
    .HWInterruptRequest(CP0InterruptRequest),
    .CP0WriteM(CP0WriteM),
	 .MemWriteM(MemWriteM),
	 .StartM(StartM),
    //input EXLSet,//?
    .EXLClearM(EXLClearM),
    .InterruptRequest(InterruptRequest), //リクエストといっても、凋綜だ
    .EPC(CP0EPCM),
    .DataOut(CP0DataOutM),
	 .AtDelaySlotM(AtDelaySlotM)
    );
	 
	integer i = 0;
	always @(posedge clk) begin
		/*$display("%h",IMAddress);
		if (Iaddu) 		$display("addu");
		if (Ibeq) 		$display("beq");
		if (Isubu) 		$display("subu");
		if (Ijr) 		$display("jr");
		if (Ilw) 		$display("lw");
		if (Isw) 		$display("sw");
		if (Ijal) 		$display("jal");
		if (Iori) 		$display("ori");
		if (Ilui) 		$display("lui");
		
		
		$display("%h",Instruction);
		$display("%h",BranchSelect);	
		$display("pcn %h",PCNext);
		$display("gfwd %h",GRFWD);
		$display("gfwdsel %h",GRFWDSelect);
		$display("a3c %d",BConst);		
		$display("a3sel %h",GRFA3Select);	
		$display("a3 %h",GRFA3);
		$display("beqOut %h",beqALUOut);
		$display("pcin %h",PCIn);*/

		/*
		$display("%d",i);
		$display("InstrD %h",InstrD);
		$display("InstrE %h",InstrE);
		$display("RsE %d",RsE);
		$display("RD2E %h",RD2E);
		$display("ALUControlE %h",ALUControlE);
		$display("ALUSrcE %h",ALUSrcE);
		$display("InstrM %h",InstrM);
		$display("ALUOutM %h",ALUOutM);
		$display("WriteDataM %h",WriteDataM);
		$display("WriteRegM %d",WriteRegM);
		$display("InstrW %h",InstrW);
		$display("ResultW %h",ResultW);
		$display("RegWriteW %h",RegWriteW);
		$display("WriteRegW %d",WriteRegW);
		
		$display("-----------------------");*/
		//$display("InstrW %h",InstrW);


		i <= i+1;
	end
endmodule
