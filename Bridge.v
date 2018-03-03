`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:09:19 12/12/2016 
// Design Name: 
// Module Name:    Bridge 
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
module Bridge(
	 input MemWriteM,
	 input [31:0]CPUAddress,
    output [31:0]DevAddress, // 7F00-7F0B; 7F10-7F1B; 

	 input [31:0]CPUWD,
	 output [31:0]DevWD,
	 output [5:0]DevWE, //for 6 devices
	 
	 input [31:0]DevRD, // cpu reads from dev
	 output [31:0]CPURD,// cpu reads from dev
	 
	 output MemorySelectM, //M sel at M
	 
	 input [5:0]DevInterruptRequest,
	 output [5:0]CP0InterruptRequest //for cp0
    );
	 assign DevAddress = CPUAddress;
	 assign DevWE = (CPUAddress[15:4] == 12'h7f0 && MemWriteM)  ? 6'b000001:
						 (CPUAddress[15:4] == 12'h7f1 && MemWriteM)  ? 6'b000010:
						 (CPUAddress[15:0] == 16'h7f38 && MemWriteM) ? 6'b000100:
						 (CPUAddress[15:0] == 16'h7f34 && MemWriteM) ? 6'b001000:
						 6'b000000;
	 assign DevWD = CPUWD;
	 assign CPURD = DevRD;
	 
	 assign MemorySelectM = CPUAddress[15:8] == 12'h7f;
	 
	 assign CP0InterruptRequest = DevInterruptRequest;
	 

	 

endmodule
