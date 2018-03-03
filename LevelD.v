`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:37:27 11/20/2016 
// Design Name: 
// Module Name:    LevelD 
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
module LevelF(
	 input InterruptRequest,
    input clk,
	 input clk2,
	 input reset,
	 input StallF,
	 input StallD,
	 input CancelF,
	 input [31:0] EPC,
	 //input CLR,
	 input [2:0] PCSrcD,
	 input [31:0] PCBranch1D,
	 input [31:0] PCBranch2D,
	 input [31:0] PCBranch3D,
	 input AtDelaySlotF,
	 output [31:0] PCPlus4D,
	 output [31:0] InstrD,
	 output ErrorF,
	 output [31:0] PCD,
	 output AtDelaySlotD
    );
	 wire [31:0] PCIn;
	 wire [31:0] PCInF;
	 wire [31:0] PCPlus4F;
	 wire [31:0] RD;
	 wire [31:0] PCF;
	 wire [3:0] wea;
	 wire [10:0] PCFTrans;

	 
	 assign ErrorF = PCF < 32'h3000 || PCF > 32'h4fff; 
	 assign wea = 0; 
	 assign PCFTrans = PCF[12:2] - 32'h00000c00;
	 
	 reg [31:0] ExcEntrance = 32'h00004180;

	PC PC(.Clk(clk),.Clr(reset),.In(PCInF),.Address(PCF),.StallF(StallF),.Source(PCSrcD),.InterruptRequest(InterruptRequest));
	/*IM IM(.Address(PCF),.Instruction(RD));*/
	IMBlock IM (
		.clka(clk2), // input clka
		.addra(PCFTrans), // input [10 : 0] addra
		//.dina(dina), // input [31 : 0] dina
		.douta(RD) // output [31 : 0] douta
	);
	PCALU PCALU(.In(PCF),.Out(PCPlus4F));
	
	MUX328 MUX328(.In0(PCPlus4F),.In1(PCBranch1D),.In2(PCBranch2D),.In3(PCBranch3D),.In4(EPC),.Select(PCSrcD),.Out(PCIn));
	MUX322 MUX322(.In0(PCIn),.In1(ExcEntrance),.Select(InterruptRequest),.Out(PCInF));
	
	IFID IFID (.CLR(CLR),.reset(reset),.clk(clk),.InterruptRequest(InterruptRequest),
				  .CancelF(CancelF),
				  .RD(RD),.StallD(StallD),.InstrD(InstrD),.PCPlus4D(PCPlus4D),.PCPlus4F(PCPlus4F),
				  .PCF(PCF),.PCD(PCD),
				  .AtDelaySlotF(AtDelaySlotF),
				  .AtDelaySlotD(AtDelaySlotD));
	
endmodule
