`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:36:38 12/13/2016 
// Design Name: 
// Module Name:    CP0 
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
module CP0 (
	 input [4:0] Address,
    input [31:0] DataIn,
    input [31:0] ExcPC,
    input ErrorRlM,
    input ErrorOvM,
    input [7:2] HWInterruptRequest,
    input CP0WriteM,
	 input MemWriteM,
	 input StartM,
    input EXLSet,//?
    input EXLClearM,
    input clk,
    input reset,
	 input [31:0] PCM,
	 input AtDelaySlotM,
    output InterruptRequest, //リクエストといっても、命令だ
    output reg [31:0] EPC = 0,
    output [31:0] DataOut
    );
	 wire [1:0] AddressLow;
	 wire [7:2] IM;
	 wire IE; //全局中断使能，1允许 0不给
	 wire EXL; //异常级 1-进入异常，不允许再中断； 0-允许中断
	 /*
		#7F00 Ctrl
		#7F04 Preset
		#7F08 Count
		#[3:3] 0 no interrupt
		#1 allow interrupt
		#00 mode 0
		#01 mode 1
		# 0  stop counting
		# 1 allow counting
		# 12 SR
		li $1,9 #1001
		sw $1, 0x7f14($0)
		li $1, 0x0000fffd #1111 1111 1111 1101 EXL==0 IM==1
		mtc0 $1, $12
		li $1,9 #1001
		sw $1, 0x7f10($0)
 
	   sw $1, 0($0)
		li $1, 25
		sw $1, 0x7f14($0)
		li $1, 9 #1001
		sw $1, 0x7f10($0)
		lw $1, 0($0)
		eret
		nop
		
		*/
	 assign AddressLow = Address[1:0];
	 
	 reg [31:0] SR = 0;						//12 1100
	 reg [31:0] Cause = 0;					//13 1101
	 //reg [31:0] EPC = 0;						//14 1110
	 reg [31:0] PRId = 32'hdead2333;		//15 1111
	 
	 MUX324 MUX324(.In0(SR),.In1(Cause),.In2(EPC),.In3(PRId),.Select(AddressLow),.Out(DataOut));
	 
	 assign  IM = SR[15:10];
	 assign  IE = SR[0];
	 assign  EXL = SR[1];
	 assign 	InterruptRequest = |(HWInterruptRequest[7:2] & IM) & IE & !EXL;

	 always @(posedge clk) begin
		Cause[15:10] <= HWInterruptRequest[7:2]; 
		if (reset) begin
			SR <= 0;
			Cause <= 0;
			EPC <= 0;
			PRId <= 32'hdead2333;
		end
		else if (InterruptRequest) begin
			EPC <= AtDelaySlotM ? (PCM-4) :
					 (MemWriteM || /*CP0WriteM ||*/ StartM)? (PCM+4) :
					 PCM;
			SR[1] <= 1; //EXL < 1, no interrupt
			Cause[6:2] <= 0; //exc code
		end
		else begin
			if (CP0WriteM) begin
				if (AddressLow == 0) begin
					{SR[15:10],SR[1],SR[0]} <= {DataIn[15:10],DataIn[1],DataIn[0]};
					//$display("#%d <= %h", Address, {SR[31:16],DataIn[15:10],SR[9:2],DataIn[1],DataIn[0]});
					//$display("PCM: %h",PCM);
				end
				if (AddressLow == 2) begin	
					EPC <= DataIn;
					//$display("#%d <= %h", Address, DataIn);
				end
			end
			if (EXLClearM) begin
				SR[1] <= 0;
			end
		end
	 end
	 
endmodule
