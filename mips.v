`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:04:27 11/13/2016
// Design Name:   mips
// Module Name:   Q:/p/mips/TBmips.v
// Project Name:  mips
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mips
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module mips
	(input clk,input clk2, input reset,
	 output [7:0] digital_tube0,
	 output [7:0] digital_tube1,
	 output [7:0] digital_tube2,
	 output [3:0] digital_tube_sel0,
	 output [3:0] digital_tube_sel1,
	 output digital_tube_sel2,
	 
	 output [31:0] led_light,
	 
	 input [7:0] dip_switch0,
	 input [7:0] dip_switch1,
	 input [7:0] dip_switch2,
	 input [7:0] dip_switch3,
	 
	 input [7:0] dip_switch4,
	 input [7:0] dip_switch5,
	 input [7:0] dip_switch6,
	 input [7:0] dip_switch7,
	 
	 input [7:0] user_key
	);

	// Inputs
	
	wire MemWriteM;
	wire [31:0] CPUAddress;
	wire [31:0] DevAddress;
	
	wire [31:0] CPUWD;
	wire [31:0] DevWD;
	wire [5:0] DevWE;
	
	wire [31:0] DevRD;
	wire [31:0] CPURD;
	
	wire MemorySelectM;
	
	wire [7:2]DevInterruptRequest;
	wire [7:2]CP0InterruptRequest;
	
	wire WE0, WE1, WE2, WE3;
	
	wire [31:0] PCM;

	// Instantiate the Unit Under Test (UUT)
	core CPU (
		.clk(clk),
		.clk2(clk2),
		.reset(reset),
		.MemWriteM(MemWriteM),
		.CPUAddress(CPUAddress),
		.CPUWD(CPUWD),
		.CPURD(CPURD),
		.MemorySelectM(MemorySelectM),
		.CP0InterruptRequest(CP0InterruptRequest),
		.PCM(PCM)
	);
   // 7F00 Ctrl
	// 7F04 Preset
	// 7F08 Count
	Bridge Bridge (
		.MemWriteM(MemWriteM),
		.CPUAddress(CPUAddress),
		.DevAddress(DevAddress), // 7F00-7F0B; 7F10-7F1B; 

		.CPUWD(CPUWD),
		.DevWD(DevWD),
		.DevWE(DevWE), //for 6 devices
	 
		.DevRD(DevRD), // cpu reads from dev
		.CPURD(CPURD), // cpu reads from dev
	 
		.MemorySelectM(MemorySelectM), //M sel at M
	 
		.DevInterruptRequest(DevInterruptRequest),
		.CP0InterruptRequest(CP0InterruptRequest)
	 );
	 
	wire [31:0] DataRD0;
	wire [31:0] DataRD1;
	wire [31:0] DataRD2;
	// 00007F00 
	TC Timer0 (
		.clk(clk), 
		.reset(reset), 
		.PrAddr(DevAddress[3:2]), 
		.WE(WE0), 
		.DataIn(DevWD), 
		.DataOut(DataRD0), 
		.InterruptRequest(DevInterruptRequest[2])
	);
	// 00007F10
	TC Timer1 (
		.clk(clk), 
		.reset(reset), 
		.PrAddr(DevAddress[3:2]), 
		.WE(WE1), 
		.DataIn(DevWD), 
		.DataOut(DataRD1), 
		.InterruptRequest(DevInterruptRequest[3])
	);
	
	/*Interrupter Interrupter (
		.PCM(PCM),
		.IntReq(DevInterruptRequest[4])
	);*/
	
	TubeDriver TubeDriver (
    .clk(clk), 
    .reset(reset), 
    .Call(DevInterruptRequest[2]), 
    .WE(WE2), 
    .DataIn(DevWD), 
    .tube0sel(digital_tube_sel0), 
    .tube1sel(digital_tube_sel1), 
    .tube2sel(digital_tube_sel2), 
    .tube0(digital_tube0), 
    .tube1(digital_tube1), 
    .tube2(digital_tube2)
    );

	SwitchReceiver SwitchReceiver (
    .switch0(dip_switch0), 
    .switch1(dip_switch1), 
    .switch2(dip_switch2), 
    .switch3(dip_switch3), 
    .switch4(dip_switch4), 
    .switch5(dip_switch5), 
    .switch6(dip_switch6), 
    .switch7(dip_switch7),

	 .userkey(user_key),
    .Address(CPUAddress[7:0]), 
    .DataOut(DataRD2)
    );
	 
	LEDDriver LEDDriver (
    .clk(clk), 
    .reset(reset), 
    .DataIn(DevWD), 
    .Drive(led_light), 
    .WE(WE3)
    );


	
	assign {WE3,WE2,WE1,WE0} = DevWE[3:0];
	
	assign DevRD = DevAddress[7:4] == 0 ? DataRD0 : 
						DevAddress[7:4] == 1 ? DataRD1 :
						DataRD2; //sel which rd
		
	assign DevInterruptRequest[7:4] = 0;
	//assign DevRD = 32'hdead2333;
endmodule

