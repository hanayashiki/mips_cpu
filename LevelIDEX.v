`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:59:51 11/20/2016 
// Design Name: 
// Module Name:    LevelIDEX 
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
module LevelD(
	 input InterruptRequest,
    input clk,
    input reset,
    input FlushE,
	 input CLR,
    input [1:0]ForwardAD,
    input [1:0]ForwardBD,
    input RegWriteW,
	 input [31:0] InstrD,
	 input [31:0] PCPlus4D,
	 input [4:0] WriteRegW,
    input [31:0] ResultW,
    input [31:0] ALUOutM,
	 input [31:0] InstrW,
	 input AtDelaySlotD,
	 output BranchD,
	 output BranchE,
	 output [2:0] PCSrcD,
    output [31:0] PCBranch1D,
	 output [31:0] PCBranch2D,
	 output [31:0] PCBranch3D,
	 //output CLRF,
    output [31:0] RD1E,
    output [31:0] RD2E,
    output [4:0] RsE,
    output [4:0] RtE,
    output [4:0] RdE,
    output [31:0] SignImmE,
	 output CancelF,
	 
	 output RegWriteE,output MemtoRegE,output MemWriteE,
	 output [3:0] ALUControlE,
	 output ALUSrcE,output RegDstE,output ShiftE,
	 output [1:0] MemTypeE,output LoadExtSignE,
	 
	 output [4:0]RsD, output [4:0]RtD,
	 output MemtoRegD,output MemWriteD,
	 
	 output [31:0]InstrE,
	 //md
	 output StartE, output MDSignE, output MDE,
	 output [1:0] ALUOutESelectE,
	 output HLWriteE,
	 output MDUseD,
	 input MulFlushE,
	 //lwl lwr
	 output LeftRightE,
	 //cp0
	 output EXLClearD,
	 output CP0WriteE,
	 output CP0ReadE,
	 output EXLClearE,
	 output AtDelaySlotF,
	 output AtDelaySlotE,
	 //overflow
	 output OverflowCheckE,
	 //error
	 output ErrorRlE,
	 input [31:0] PCD,
	 output [31:0] PCE,
	 input [31:0] PCW
    );
	 //error
	wire ErrorRlD;
	assign ErrorRlD = Iexcept;
	 //Interpreter
	wire [5:0] IOpcode;
	wire [5:0] IFunc;
	wire [4:0] GRFA1;
	wire [4:0] GRFA2;
	wire [4:0] IRD;
	wire [4:0] IShift;
	wire [25:0] IInstrIndex;
	wire [15:0] IImmediate; 
	//GRF
	wire [31:0] GRFRD1;
	wire [31:0] GRFRD2;
	wire signed [31:0] RD1D;
	wire signed [31:0] RD2D;
	wire signed [31:0] RD1DN;
	wire signed [31:0] RD2DN;
	//commands
	wire Iaddu;
	wire Isubu;
	wire Iori;
	wire Ior0;
	wire Iand0;
	wire Ilui;
	wire Ijal;
	wire Ijalr;
	wire Ij;
	wire Ijr;
	wire Isll;
	wire Isrl;
	wire Ibltzall;
	wire Islt;
	wire Isltu;
	wire Isra;
	wire Isllv;
	wire Isrlv;
	wire Israv;
	wire Ixor0;
	wire Inor0;
	
	wire Iaddiu;
	wire Ixori;
	wire Islti;
	wire Isltiu;
	wire Iandi;
	
	wire Ibeq;
	wire Ibne;
	wire Iblez;
	wire Ibgtz;
	wire Ibltz;
	wire Ibgez;
	
	wire Ilw;
	wire Ilb;
	wire Ilbu;
	wire Ilh;
	wire Ilhu;
	
	wire Isw;
	wire Isb;
	wire Ish;
	
	wire Imult;
	wire Imultu;
	wire Idiv;
	wire Idivu;
	
	wire Imfhi;
	wire Imflo;
	wire Imthi;
	wire Imtlo;
	
	wire Iins;
	wire Iext;
	
	wire Ilwl;
	wire Ilwr;
	
	wire Iadd;
	wire Isub;
	wire Iaddi;
	
	wire Ieret;
	wire Imfc0;
	wire Imtc0;
	
	wire Iexcept;
	//controls to carry
	wire ShiftD;
	wire Nullify;
	wire RegWriteD;
	wire [1:0] MemTypeD;
	wire [3:0] ALUControlD;
	wire LoadExtSignD,ALUSrcD,RegDstD, ExtSignD;
	wire RsDSelectD;
	wire RtDSelectD;
	wire RdDSelectD;
	wire RD1DSelectD;
	wire RD2DSelectD;
	wire [4:0] IRDN;
	wire [4:0] RdD;
	//cp0
	wire CP0WriteD;
	wire CP0ReadD;
	//Extenders
	wire [31:0] SignImmD;
	wire [1:0] EqualD;
	wire [1:0] EqualZeroD;

	wire [31:0] PCPlus4Plus4D;
	//overflow
	wire OverflowCheckD;
	//md
	wire StartD, MDSignD, MDD;
	wire [1:0] ALUOutESelectD;
	wire HLWriteD;
	//lwl lwr
	wire LeftRightD;
	//controls
	Interpreter Interpreter(.Instruction(InstrD),.Opcode(IOpcode),.Func(IFunc),.RS(GRFA1),.RT(GRFA2),.RD(IRDN),
									.Shift(IShift),.InstrIndex(IInstrIndex),.Immediate(IImmediate));
	GIS GIS(.Opcode(IOpcode),.Func(IFunc),.RS(GRFA1),.RT(GRFA2),.InstrD(InstrD),.except(Iexcept),
				.addu(Iaddu),.subu(Isubu),.ori(Iori),.bltzall(Ibltzall),.lui(Ilui),.jal(Ijal),.jalr(Ijalr),.j(Ij),.jr(Ijr),
				.sll(Isll),.srl(Isrl),.and0(Iand0),.or0(Ior0),.slt(Islt),.sltu(Isltu),.sra(Isra),.sllv(Isllv),.srlv(Isrlv),.srav(Israv),.xor0(Ixor0),.nor0(Inor0),
				.addiu(Iaddiu),.xori(Ixori),.slti(Islti),.sltiu(Isltiu),.andi(Iandi),
				.beq(Ibeq),.bne(Ibne),.blez(Iblez),.bgtz(Ibgtz),.bltz(Ibltz),.bgez(Ibgez),
				.lw(Ilw),.lb(Ilb),.lbu(Ilbu),.lh(Ilh),.lhu(Ilhu),
				.sw(Isw),.sb(Isb),.sh(Ish),
				.mult(Imult),.multu(Imultu),.div(Idiv),.divu(Idivu),
				.mfhi(Imfhi),.mflo(Imflo),.mthi(Imthi),.mtlo(Imtlo),
				.ins(Iins),.ext(Iext),
				.lwl(Ilwl),.lwr(Ilwr),
				.add(Iadd),.sub(Isub),.addi(Iaddi),
				.eret(Ieret),.mfc0(Imfc0),.mtc0(Imtc0)
				);
	GCS GCS( .addu(Iaddu),.subu(Isubu),.ori(Iori),.bltzall(Ibltzall),.lui(Ilui),.jal(Ijal),.jalr(Ijalr),.j(Ij),.jr(Ijr),
				.sll(Isll),.srl(Isrl),.and0(Iand0),.or0(Ior0),.slt(Islt),.sltu(Isltu),.sra(Isra),.sllv(Isllv),.srlv(Isrlv),.srav(Israv),.xor0(Ixor0),.nor0(Inor0),
				.addiu(Iaddiu),.xori(Ixori),.slti(Islti),.sltiu(Isltiu),.andi(Iandi),
				.beq(Ibeq),.bne(Ibne),.blez(Iblez),.bgtz(Ibgtz),.bltz(Ibltz),.bgez(Ibgez),
				.lw(Ilw),.lb(Ilb),.lbu(Ilbu),.lh(Ilh),.lhu(Ilhu),
				.sw(Isw),.sb(Isb),.sh(Ish),
				.mult(Imult),.multu(Imultu),.div(Idiv),.divu(Idivu),
				.mfhi(Imfhi),.mflo(Imflo),.mthi(Imthi),.mtlo(Imtlo),
				.ins(Iins),.ext(Iext),
				.lwl(Ilwl),.lwr(Ilwr),
				.add(Iadd),.sub(Isub),.addi(Iaddi),
				.eret(Ieret),.mfc0(Imfc0),.mtc0(Imtc0),
				//cp0
				.CP0Write(CP0WriteD),.CP0Read(CP0ReadD),.EXLClear(EXLClearD),.CancelF(CancelF),
				//overflow
				.OverflowCheck(OverflowCheckD),
				//lwl lwr
				.LeftRight(LeftRightD),
				//md
				.Start(StartD),.MDSign(MDSignD),.MD(MDD),
				.ALUOutESelect(ALUOutESelectD),
				.MDUse(MDUseD),.HLWrite(HLWriteD),
				
				.MemType(MemTypeD),.LoadExtSign(LoadExtSignD),
				.Shift(ShiftD),
				.GRFWE(RegWriteD),.GRFWDSelect(MemtoRegD),.RAMWE(MemWriteD),
				.ALUOP(ALUControlD),
				.ALUBSelect(ALUSrcD),.GRFA3Select(RegDstD),
				.ExtSign(ExtSignD),
				.Branch(BranchD),
				.RsDSelect(RsDSelectD),
				.RtDSelect(RtDSelectD),
				.RdDSelect(RdDSelectD),
				.RD1DSelect(RD1DSelectD),
				.RD2DSelect(RD2DSelectD));				
   //cp0
	//BranchControl
	reg [4:0] const31 = 31;
	reg [4:0] const0 = 0;
	assign EqualD = (RD1DN==RD2DN) ? 0:
						 (RD1DN<RD2DN) ?  -1:  1;
	assign EqualZeroD = (RD1DN==0) ? 0:
						 (RD1DN<0) ?  -1:  1;
	//assign CLRF = ~(PCSrcD == 0); //考虑延时槽要去掉
	BranchControl BranchControl(.PCD(PCD),.FlushE(FlushE),
										 .jal(Ijal),.j(Ij),.jr(Ijr),.jalr(Ijalr),
										 .beq(Ibeq),.bne(Ibne),.blez(Iblez),.bgtz(Ibgtz),.bltz(Ibltz),.bgez(Ibgez),.bltzall(Ibltzall),
										 .eret(Ieret),
										 .EqualD(EqualD),.EqualZeroD(EqualZeroD),.BranchSelect(PCSrcD),.Nullify(Nullify),
										 .AtDelaySlotF(AtDelaySlotF));	
	beqALU beqALU(.Immediate(IImmediate),.PCNext(PCPlus4D),.Out(PCBranch1D)); //get result for beq. here signed is needed because we might turn back
	jalAddr jalAddr(.IMAddress(PCPlus4D),.InstrIndex(IInstrIndex),.Out(PCBranch2D));//for j or jal
	assign PCBranch3D = RD1DN;// for jr/jalr 必须选择原版，因为rd1d用来输出pc+8了
	assign PCPlus4Plus4D = PCPlus4D+4;

	// 								
	GRF GRF(.Clk(clk),.Clr(reset),.A1(GRFA1),.A2(GRFA2),.A3(WriteRegW),.WD(ResultW),.WE(RegWriteW),.RD1(GRFRD1),.RD2(GRFRD2),.InstrW(InstrW),.PCW(PCW));	

	MUX323 MUX323a(.In0(GRFRD1),.In1(ResultW),.In2(ALUOutM),.Select(ForwardAD),.Out(RD1DN)); //select RD1D
	MUX323 MUX323b(.In0(GRFRD2),.In1(ResultW),.In2(ALUOutM),.Select(ForwardBD),.Out(RD2DN)); //select RD2D
	
	
	MUX322 MUX322a(.In0(RD1DN),.In1(PCPlus4Plus4D),.Select(RD1DSelectD),.Out(RD1D));
	MUX322 MUX322b(.In0(RD2DN),.In1(PCPlus4Plus4D),.Select(RD2DSelectD),.Out(RD2D));
	MUX52 MUX322c(.In0(GRFA1),.In1(const0),.Select(RsDSelectD),.Out(RsD));
	MUX52 MUX322d(.In0(GRFA2),.In1(const0),.Select(RtDSelectD),.Out(RtD));
	MUX52 MUX322e(.In0(IRDN),.In1(const31),.Select(RdDSelectD),.Out(RdD));	
	
	bitExtender16to32 bitExtender1(.In(IImmediate),.Out(SignImmD),.sign(ExtSignD)); //extend imme16 to 32
	
	//output for Hazard
	IDEX IDEX(
		.InterruptRequest(InterruptRequest),
		.clk(clk),.FlushE(FlushE),.reset(reset),.Nullify(Nullify),
		.RsD(RsD),.RsE(RsE),
		.RtD(GRFA2),.RtE(RtE),
		.RdD(RdD),.RdE(RdE),
		.RD1D(RD1D),.RD1E(RD1E),
		.RD2D(RD2D),.RD2E(RD2E),
		.SignImmD(SignImmD),.SignImmE(SignImmE),
		.InstrD(InstrD),.InstrE(InstrE));
	
	IDEXControlCarrier IDEXControlCarrier(
		 .InterruptRequest(InterruptRequest),
		 .clk(clk),.FlushE(FlushE),.reset(reset),.Nullify(Nullify),
		 .OverflowCheckD(OverflowCheckD),
		 .OverflowCheckE(OverflowCheckE),
		 .LeftRightD(LeftRightD),
		 .LeftRightE(LeftRightE),
		 .ShiftD(ShiftD),
		 .ShiftE(ShiftE),
		 .StartD(StartD),.MDSignD(MDSignD),.MDD(MDD),.ALUOutESelectD(ALUOutESelectD),.HLWriteD(HLWriteD), 
		 .StartE(StartE),.MDSignE(MDSignE),.MDE(MDE),.ALUOutESelectE(ALUOutESelectE),.HLWriteE(HLWriteE),
		 .LoadExtSignD(LoadExtSignD),.MemTypeD(MemTypeD),.RegWriteD(RegWriteD), .MemtoRegD(MemtoRegD),.MemWriteD(MemWriteD),.ALUControlD(ALUControlD),.ALUSrcD(ALUSrcD),.RegDstD(RegDstD),
		 .LoadExtSignE(LoadExtSignE),.MemTypeE(MemTypeE),.RegWriteE(RegWriteE), .MemtoRegE(MemtoRegE),.MemWriteE(MemWriteE),.ALUControlE(ALUControlE),.ALUSrcE(ALUSrcE),.RegDstE(RegDstE),
		 .BranchD(BranchD),.BranchE(BranchE),
		 .CP0WriteD(CP0WriteD),.CP0ReadD(CP0ReadD),.EXLClearD(EXLClearD),
		 .CP0WriteE(CP0WriteE),.CP0ReadE(CP0ReadE),.EXLClearE(EXLClearE),
		 .AtDelaySlotD(AtDelaySlotD),
		 .AtDelaySlotE(AtDelaySlotE));
	
	ExcCarrierD ExcCarrierD(
		 .InterruptRequest(InterruptRequest),
		 .clk(clk),.FlushE(FlushE),.reset(reset),.Nullify(Nullify),
		 .ErrorRlD(ErrorRlD),
		 .ErrorRlE(ErrorRlE),
		 .PCD(PCD),
		 .PCE(PCE),
		 .MulFlushE(MulFlushE));
endmodule
