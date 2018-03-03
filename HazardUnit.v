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
		//定义，XY型指令：最晚X阶段(开始时)需要最新的值；最早在Y阶段（开始时）得出寄存器改变值（并寄存在附属寄存器）
		//EM	addu,subu,ori,lui
		//EW lw
		//forwardings，if有优先顺序，先判断近的转发。
		if (RsE == WriteRegM && RegWriteM == 1 && WriteRegM != 0 && MemtoRegM == 0 && BranchE != 1) ForwardAE <= 2; //I指令在E阶段，I-1指令在M阶段，I-1要改变I依赖的Rs
		else
		if (RsE == WriteRegW && RegWriteW == 1 && WriteRegW != 0 && BranchE != 1) ForwardAE <= 1; //I指令在E阶段，I-2指令在W阶段，I-2要改变I依赖的Rs
		else
		ForwardAE <= 0;
		if (RtE == WriteRegM && RegWriteM == 1 && WriteRegM != 0 && MemtoRegM == 0 && BranchE != 1) ForwardBE <= 2; //I指令在E阶段，I-1指令在M阶段，I-1要改变I依赖的Rt
		else
		if (RtE == WriteRegW && RegWriteW == 1 && WriteRegW != 0 && BranchE != 1) ForwardBE <= 1; //I指令在E阶段，I-2指令在W阶段，I-2要改变I依赖的Rt		
		else 
		ForwardBE <= 0;
		
		//寄存器内转发 ，beq,jr转发
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
		if (WriteRegM == WriteRegW && RegWriteW == 1 && WriteRegW != 0) ForwardM <= 1;     //any at M, other at W，转发给WriteDataM，主要为了lwl和sw类，但是别的转发了也没关系
		else
		ForwardM <= 0;
	
		//$display("FA %b, FB %b",ForwardAE,ForwardBE);
		//lw rs'base rt'source
		// load类型MemtoRegE=1 cal类型是0
		//stalls
		if ((RsD == WriteRegE) && RegWriteE == 1 && WriteRegE != 0 && MemtoRegE == 1) begin //need rs at d(针对cal还有lw), lw at E
			FlushE <= 1;
			StallD <= 1;
			StallF <= 1;
		end//把W到M的转发乖乖写好
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
