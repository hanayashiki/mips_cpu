`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:43:01 11/14/2016 
// Design Name: 
// Module Name:    GIS 
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
//尚未实现的指令：
//add,sub,mult/div类，异常，陷阱，传输，特权类
module GIS(
    input [5:0] Opcode,
    input [5:0] Func,
	 input [4:0] RS,
	 input [4:0] RT,
	 input [31:0] InstrD,

	 output nop,
    output addu,
    output subu,
    output ori,

    output lui,
    output jal,
	 output jalr,
	 output j,
    output jr,
	 output sll,
	 output srl,
	 output or0,
	 output and0,
	 output slt,
	 output sltu,
	 output sra,
	 output sllv,
	 output srlv,
	 output srav,
	 output xor0,
	 output nor0,
	 
	 output addiu,
	 output xori,
	 output slti,
	 output sltiu,
	 output andi,
	 
	 output beq,
	 output bne,
	 output blez,
	 output bgtz,
	 output bltz,
	 output bgez,
	 output bltzall,
	 
	 output lw,
	 output lb,
	 output lbu,
	 output lh,
	 output lhu,
	 
	 output sw,
	 output sb,
	 output sh,
	 
	 output mult,
	 output multu,
	 output div,
	 output divu,
	 
	 output mfhi,
	 output mflo,
	 output mthi,
	 output mtlo,
	 
	 output ins,
	 output ext,
	 
	 output lwl,
	 output lwr,
	 //悪辣たるオーバーフロー可能
	 output add,
	 output sub,
	 output addi,
	 //闇の中の奴ら
	 output eret,
	 output mfc0,
	 output mtc0,
	 
	 output except
    );
	 assign nop = (InstrD == 0);
	 assign addu = (Opcode == 6'b000000)&&(Func == 6'b100001);
	 assign add =  (Opcode == 6'b000000)&&(Func == 6'b100000);
	 assign subu = (Opcode == 6'b000000)&&(Func == 6'b100011);	
	 assign sub =  (Opcode == 6'b000000)&&(Func == 6'b100010);
	 assign and0 = (Opcode == 6'b000000)&&(Func == 6'b100100);
	 assign or0 =  (Opcode == 6'b000000)&&(Func == 6'b100101);	
	 assign sll =	(Opcode == 6'b000000)&&(Func == 6'b000000)&&~nop;		 
	 assign srl =	(Opcode == 6'b000000)&&(Func == 6'b000010);
	 assign sra =	(Opcode == 6'b000000)&&(Func == 6'b000011);
	 assign sllv = (Opcode == 6'b000000)&&(Func == 6'b000100);
	 assign srlv =	(Opcode == 6'b000000)&&(Func == 6'b000110);
	 assign srav =	(Opcode == 6'b000000)&&(Func == 6'b000111);
	 assign jalr = (Opcode == 6'b000000)&&(Func == 6'b001001);
	 assign slt = (Opcode == 6'b000000)&&(Func == 6'b101010);
	 assign sltu = (Opcode == 6'b000000)&&(Func == 6'b101011);
	 assign xor0 = (Opcode == 6'b000000)&&(Func == 6'b100110);
	 assign nor0 = (Opcode == 6'b000000)&&(Func == 6'b100111);
	 
	 assign ori = 	(Opcode == 6'b001101);
	 assign lui =	(Opcode == 6'b001111);
	 assign jal = 	(Opcode == 6'b000011);
	 assign j = 	(Opcode == 6'b000010);
	 assign jr = 	(Opcode == 6'b000000)&&(Func == 6'b001000);
	 
	 assign addiu = (Opcode == 6'b001001); //addiu / addi
	 assign addi =  (Opcode == 6'b001000);
	 assign xori  = (Opcode == 6'b001110);
	 assign slti  = (Opcode == 6'b001010);
	 assign sltiu = (Opcode == 6'b001011);
	 assign andi =  (Opcode == 6'b001100);

	 assign beq = 	(Opcode == 6'b000100);
	 assign bne =  (Opcode == 6'b000101);
	 assign blez = (Opcode == 6'b000110);
	 assign bgtz = (Opcode == 6'b000111);
	 assign bltz = (Opcode == 6'b000001)&&(RT == 5'b00000);
	 assign bgez = (Opcode == 6'b000001)&&(RT == 5'b00001);	 
	 assign bltzall = (Opcode == 6'b000001)&&(RT == 5'b10000);
	 
	 assign sw = 	(Opcode == 6'b101011);
	 assign sh =	(Opcode == 6'b101001);
	 assign sb = 	(Opcode == 6'b101000);
	 
	 assign lw = 	(Opcode == 6'b100011);
	 assign lh =	(Opcode == 6'b100001);
	 assign lhu =	(Opcode == 6'b100101);
	 assign lb =	(Opcode == 6'b100000);
	 assign lbu =	(Opcode == 6'b100100);
	 
	 //邪悪なる乗除法家族
	 
	 assign mult = 	(Opcode == 6'b000000)&&(Func == 6'b011000);
	 assign multu = 	(Opcode == 6'b000000)&&(Func == 6'b011001);
	 assign div = 		(Opcode == 6'b000000)&&(Func == 6'b011010);	 
	 assign divu = 	(Opcode == 6'b000000)&&(Func == 6'b011011);	 	 
	 
	 assign mfhi = 	(Opcode == 6'b000000)&&(Func == 6'b010000);	 
	 assign mflo = 	(Opcode == 6'b000000)&&(Func == 6'b010010);	
	 assign mthi =		(Opcode == 6'b000000)&&(Func == 6'b010001);
	 assign mtlo =		(Opcode == 6'b000000)&&(Func == 6'b010011);
	 
	 //ins
	 
	 assign ins = 		(Opcode == 6'b011111)&&(Func == 6'b000100);
	 assign ext =		(Opcode == 6'b011111)&&(Func == 6'b000000);
	 
	 //lwl lwr
	 
	 assign lwl =		(Opcode == 6'b100010);
	 assign lwr =		(Opcode == 6'b100110);
	 
	 //闇の中の奴ら
	 
	 assign eret =		(Opcode == 6'b010000)&&(Func == 6'b011000);
	 assign mfc0 =		(Opcode == 6'b010000)&&(RS == 5'b00000)&&(InstrD[10:0] == 11'b00000000000);
	 assign mtc0 =		(Opcode == 6'b010000)&&(RS == 5'b00100)&&(InstrD[10:0] == 11'b00000000000);
	 
	 assign except = ~(nop || addu || subu || ori || lui || jal || jalr || j || jr || sll || srl || or0 || and0 || slt || sltu ||
							 sra || sllv || srlv || srav || xor0 || nor0 || addiu || xori || slti || sltiu || andi ||
							 beq || bne || blez || bgtz || bltz || bgez || bltzall ||
							 sw || sh || sb||
							 lw || lh || lhu || lb || lbu ||
							 mult || multu || div || divu ||
							 mfhi || mflo || mthi || mtlo ||
							 ins || ext ||
							 lwl || lwr ||
							 add || sub || addi ||
							 eret || mfc0 || mtc0);
	 
endmodule
