`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:58:43 11/15/2016 
// Design Name: 
// Module Name:    BranchContorl 
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
module BranchControl(
	 input [31:0] PCD,
	 input FlushE,
		
	 input signed [1:0] EqualZeroD,
    input signed [1:0] EqualD,
    input jal,
	 input jalr,
    input jr,
	 input j,
	 
	 input beq,
	 input bne,
	 input blez,
	 input bgtz,
	 input bltz,
	 input bgez,
	 input bltzall, 
	 
	 input eret,
	 
    output reg [2:0] BranchSelect = 0,
	 output reg Nullify = 0,
	 output reg AtDelaySlotF = 0
    );
	 always @(*) begin
		AtDelaySlotF = 0;
		BranchSelect = 0;
		Nullify = 0;
		if (jal || j) BranchSelect = 2; //(jalAddress)
		if (jr || jalr) BranchSelect = 3;  // GRFRD1D
		if (beq && EqualD == 0) BranchSelect = 1;// beqALU
		if (bne && EqualD != 0) BranchSelect = 1;
		if (blez && EqualZeroD <= 0) BranchSelect = 1;
		if (bgtz && EqualZeroD > 0) BranchSelect = 1;
		if (bltz && EqualZeroD < 0) BranchSelect = 1;
		if (bgez && EqualZeroD >= 0) BranchSelect = 1;
		
		if (bltzall && EqualZeroD == -1) BranchSelect = 1;// beqALU
		if (bltzall && EqualZeroD != -1) Nullify = 1;
		
		if (eret) BranchSelect = 4;
		
		if (BranchSelect != 0) AtDelaySlotF = 1;
		
		//if (BranchSelect != 0 & ~FlushE) $display("fuck! PCD:%h",PCD);
		
	 end

endmodule

module beqALU(
   input [15:0] Immediate,
	input [31:0] PCNext,
	output [31:0] Out
	);
	wire [17:0] ImmediateM4;
	wire [31:0] ImmediateExt;
	assign ImmediateM4 = {Immediate,2'b0};
	bitExtender18to32 bitExtender18to32(.In(ImmediateM4),.Out(ImmediateExt),.sign(1'b1));
	assign Out = (PCNext + ImmediateExt);//·ûºÅÒÆ¶¯
endmodule
