`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:03:30 11/21/2016 
// Design Name: 
// Module Name:    HazardUnit 
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
module HazardUnit(
    output reg StallF,
    output reg StallD,
    output reg [1:0] ForwardAD = 0, 
    output reg [1:0] ForwardBD = 0,
    output reg FlushE,
    output reg [1:0] ForwardAE = 0,
    output reg [1:0] ForwardBE = 0,
	 output reg ForwardM = 0,
	 output reg MulFlushE = 0,
	 input clk,
    input BranchD,
	 input BranchE,
	 input MemtoRegD,
    input MemtoRegE,
    input RegWriteE,
    input MemtoRegM,
    input RegWriteM,
    input RegWriteW,
	 input MemWriteD,
	 input MemWriteM,
	 input EXLClearD,
	 input CP0WriteE,
	 input CP0WriteM,
    input [4:0] RsD,
    input [4:0] RtD,
    input [4:0] RsE,
    input [4:0] RtE,
	 input [4:0] RdE,
	 input [4:0] RdM,
    input [4:0] WriteRegE,
    input [4:0] WriteRegM,
    input [4:0] WriteRegW,
	 
	 input MDUseD,
	 input BusyE,
	 input StartE
    );
	 //01, ResultW; 10, ALUOutM

	 always @(*) begin
		//���壬XY��ָ�����X�׶�(��ʼʱ)��Ҫ���µ�ֵ��������Y�׶Σ���ʼʱ���ó��Ĵ����ı�ֵ�����Ĵ��ڸ����Ĵ�����
		//EM	addu,subu,ori,lui
		//EW lw
		//forwardings��if������˳�����жϽ���ת����
		if (RsE == WriteRegM && RegWriteM == 1 && WriteRegM != 0 && MemtoRegM == 0 && BranchE != 1) ForwardAE <= 2; //Iָ����E�׶Σ�I-1ָ����M�׶Σ�I-1Ҫ�ı�I������Rs
		else
		if (RsE == WriteRegW && RegWriteW == 1 && WriteRegW != 0 && BranchE != 1) ForwardAE <= 1; //Iָ����E�׶Σ�I-2ָ����W�׶Σ�I-2Ҫ�ı�I������Rs
		else
		ForwardAE <= 0;
		if (RtE == WriteRegM && RegWriteM == 1 && WriteRegM != 0 && MemtoRegM == 0 && BranchE != 1) ForwardBE <= 2; //Iָ����E�׶Σ�I-1ָ����M�׶Σ�I-1Ҫ�ı�I������Rt
		else
		if (RtE == WriteRegW && RegWriteW == 1 && WriteRegW != 0 && BranchE != 1) ForwardBE <= 1; //Iָ����E�׶Σ�I-2ָ����W�׶Σ�I-2Ҫ�ı�I������Rt		
		else 
		ForwardBE <= 0;
		
		//�Ĵ�����ת�� ��beq,jrת��
		if (RsD == WriteRegM && RegWriteM == 1 && WriteRegM != 0 && MemtoRegM == 0 && BranchD == 1) ForwardAD <= 2;
		else
		if (RsD == WriteRegW && RegWriteW == 1 && WriteRegW != 0) ForwardAD <= 1;
		else
		ForwardAD <= 0;
		
		if (RtD == WriteRegM && RegWriteM == 1 && WriteRegM != 0 && MemtoRegM == 0 && BranchD == 1) ForwardBD <= 2;
		else
		if (RtD == WriteRegW && RegWriteW == 1 && WriteRegW != 0) ForwardBD <= 1;
		else
		ForwardBD <= 0;		
		//
		//mark M forwarding
		if (WriteRegM == WriteRegW && RegWriteW == 1 && WriteRegW != 0) ForwardM <= 1;     //any at M, other at W��ת����WriteDataM����ҪΪ��lwl��sw�࣬���Ǳ��ת����Ҳû��ϵ
		else
		ForwardM <= 0;
	
		//$display("FA %b, FB %b",ForwardAE,ForwardBE);
		//lw rs'base rt'source
		// load����MemtoRegE=1 cal������0
		//stalls
		if ((RsD == WriteRegE) && RegWriteE == 1 && WriteRegE != 0 && MemtoRegE == 1) begin //need rs at d(���cal����lw), lw at E
			FlushE <= 1;
			StallD <= 1;
			StallF <= 1;
		end//��W��M��ת���Թ�д��
		else if ((RtD == WriteRegE) && MemWriteD == 0 && MemtoRegD == 0 && RegWriteE == 1 && WriteRegE != 0 && MemtoRegE == 1) begin // need rt for cal,except sw which does not, load at E
			FlushE <= 1;
			StallD <= 1;
			StallF <= 1;
		end
		else if ((RsD == WriteRegE || RtD == WriteRegE) && RegWriteE == 1 && WriteRegE != 0 && BranchD == 1) begin //beq at D, cal/load at E
			FlushE <= 1;
			StallD <= 1;
			StallF <= 1;
		end
		else if ((RsD == WriteRegM || RtD == WriteRegM) && RegWriteM == 1 && WriteRegM != 0 && MemtoRegM == 1 && BranchD == 1) begin //beq at D, load at M
			FlushE <= 1;
			StallD <= 1;
			StallF <= 1;
		end
		else if (MDUseD && (BusyE||StartE)) begin
			FlushE <= 1;
			StallD <= 1;
			StallF <= 1;
			MulFlushE <= 1;
		end
		else if (EXLClearD == 1 &&  (((CP0WriteE && RdE == 14)|| (CP0WriteM && RdM == 14))) ) begin
			FlushE <= 1;
			StallD <= 1;
			StallF <= 1;
		end
		else begin
			FlushE <= 0;
			StallD <= 0;
			StallF <= 0;
			MulFlushE <= 0;
		end
	 end
	 
endmodule
