`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:55:11 11/14/2016 
// Design Name: 
// Module Name:    GCS 
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
module GCS(
	 input nop,
    input addu,
    input subu,
    input ori,
    input lui,
    input jal,
	 input jalr,
	 input j,
    input jr,
	 input sll,
	 input srl,
	 input and0,
	 input or0,
	 input slt,
	 input sltu,
	 input sra,
	 input sllv,
	 input srlv,
	 input srav,
	 input xor0,
	 input nor0,
	 
	 input addiu,
	 input xori,
	 input slti,
	 input sltiu,
	 input andi,
	 
	 input beq,
	 input bne,
	 input blez,
	 input bgtz,
	 input bltz,
	 input bgez,
	 input bltzall, 
	 
	 input lw,
	 input lb,
	 input lbu,
	 input lh,
	 input lhu,
	 
	 input sw,
	 input sb,
	 input sh,
	 
	 input mult,
	 input multu,
	 input div,
	 input divu,

	 input mfhi,
	 input mflo,
	 input mthi,
	 input mtlo,
	 
	 input ins,
	 input ext,
	 
	 input lwl,
	 input lwr,
	 
	 input add,
	 input sub,
	 input addi,
	 
	 input eret,
	 input mfc0,
	 input mtc0,
	 
	 output Shift,
    output GRFWE,
    output RAMWE,
    output GRFA3Select,
    output GRFWDSelect,
    output ALUBSelect,
    output [3:0] ALUOP,
	 output ExtSign,
	 output ALUASelect,
	 output Branch,
	 // for jal
	 output RsDSelect,
	 output RtDSelect,
	 output RdDSelect,
	 output RD1DSelect,
	 output RD2DSelect,
	 
	 output [1:0] MemType,
	 output LoadExtSign,
	 
	 output Start,
	 output MDSign,
	 output MD,
	 
	 output [1:0] ALUOutESelect,
	 
	 output MDUse,
	 output HLWrite,
	 
	 output LeftRight, //lwl lwr
	 
	 output OverflowCheck,
	 
	 output CP0Write,
	 output CP0Read,
	 output EXLClear,
	 output CancelF
    );

	wire calR = addu || subu || slt || sltu || sll || srl || sra || sllv || srlv || srav || xor0 || nor0 || add || sub; // xor0 || nor0;
	wire calI = addiu || ext || xori || slti || sltiu || andi || addi;
	wire beqType = beq || bne || blez || bgtz || bltz || bgez || bltzall;
	wire store = sw || sh || sb;
	wire load = lw || lb || lbu || lh || lhu || lwl || lwr || mfc0;
	wire mf = mfhi || mflo;

	//wire calI =

	 
	assign ALUOutESelect =  mfhi ? 1:
									mflo ? 2: 0;
	
	assign Start = mult || multu || div || divu;
	assign MDSign = mult || div;
	assign MD = div || divu || mtlo; // mult , hi: 0 , div, lo: 1 
	assign HLWrite = mthi || mtlo;
	assign MDUse = mult || multu || div || divu || mfhi || mflo || mthi || mtlo;
	
	 
	assign Shift = sll || srl || sra; 
	assign GRFWE = addu||subu||ori||lui||jal||and0||or0||jalr||bltzall||calR||calI||load||mf||ins; //写入grf
	assign RAMWE = store;
	// lw=00(rs);addu, subu,sll,srl,and0,or0= 01(rd);jal = 10(31);
	assign GRFA3Select = addu||subu||sll||srl||and0||or0||jal||jalr||bltzall||calR||mf; //目的是rt/0还是rd/1，注意凡是设定输出到$31的要在此设定。
	//assign GRFA3Select[1] = jal;
	// addu, subu,ori,lui = 00(ALUOut);
	// jal = 10 （pcnext）
	// lw = 01	(ramout)
	assign GRFWDSelect = load;//ALUOutW = 1; ReadDataW = 0
	//assign GRFWDSelect[1] = jal;
	
	assign ALUBSelect = load||store||lui||ori||calI; //immediate calculation
	// beq 1
	assign ExtSign = beqType||load||store||addiu||addi||slti||sltiu;
	assign LoadExtSign = lb || lh;
	// sw lw addu=000; beq subu=001; ori=010; and0= 011;lui = 100; sll = 101 ; srl/srlv=110; slt = 7; sltu = 8, sra = 9, xor0 = 10, nor0 = 11
	// sltu = 8 ; ins = 12; ext = 13
	assign ALUOP[0] = jal || bltzall || jalr || beq || subu || sub || sll || sllv || and0 || andi || slt || slti || sra || srav || nor0 || ext;
	assign ALUOP[1] = jal || bltzall || jalr || ori || or0 || srl || srlv || and0 || andi || slt || slti || xor0 || xori || nor0;
	assign ALUOP[2] = lui || sll || sllv || srl || srlv || slt || slti || ins || ext;
	assign ALUOP[3] = sltu || sltiu || sra || srav || xor0 || xori || nor0 || ins || ext;
	// sll,srl = 1
	assign ALUASelect = sll || srl;
	// beq, jal, jr, j
	assign Branch = beqType || jal || jr || j || jalr;
	// jal
	assign RsDSelect = jal;//0 normal 1 zero 防止转发 注意除了jal都不要用这个，防止导致完全不能转发
	assign RtDSelect = jal || bltzall;//0 normal 1 zero 防止转发
	assign RdDSelect = jal || bltzall;//0 normal 1 31 jal存入31
	assign RD1DSelect = jal || jalr || bltzall || mf;//0 normal 1 PC+8
	assign RD2DSelect = jal || jalr || bltzall || mf;//
	
	assign MemType = (sw || lw) ? 2'b00:
						  (sh || lh || lhu)? 2'b01:
						  (lwl || lwr)? 2'b10:
						  2'b11;// 00 word, 01 half word, 11 byte, 10 for changeable(lwl lwr)
						  
	assign LeftRight = lwr;
	assign OverflowCheck = add || sub || addi;
	//cp0
	assign CP0Write = mtc0;
	assign CP0Read  = mfc0;
	assign CancelF = eret;
	assign EXLClear = eret;
	
endmodule
