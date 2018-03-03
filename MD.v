`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:28:28 12/05/2016 
// Design Name: 
// Module Name:    MD 
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
module MD(
	 input clk,
	 input reset,
    input signed[31:0] D1,
    input signed[31:0] D2,
    input Start,
    input MDSign,
    input MD,
	 input HLWrite,
	 input InterruptRequest,
	 input [31:0] PCE,
	 output reg Busy = 0,
    output reg [31:0] HI = 0,
    output reg [31:0] LO = 0,
	 output Div0
    );
	 
	 integer counter = 0;
	 reg StartS = 0;
	 reg [31:0] preHI2 = 0;
	 reg [31:0] preLO2 = 0;
	 reg [31:0] PCS = 0;
	 reg MDSignS = 0;
	 reg MDS = 0;
	 
	 wire signed[31:0] preHI;
	 wire signed[31:0] preLO;
	 
	 wire [32:0] udiv;
	 wire [32:0] umod;
	 wire [63:0] mult;
	 wire [63:0] umult;
	 
	 assign udiv =  0;//(D2 == 0) ? 0: {1'b0,D1}/{1'b0,D2};
	 assign umod =  0;//(D2 == 0) ? 0: {1'b0,D1}%{1'b0,D2};
	 
	 assign mult = 0;//D1 * D2;
	 assign umult = 0;//{1'b0,D1} * {1'b0,D2};
	 
	 assign {preHI,preLO} = 0;//(MD == 0 && MDSign == 1) ?  mult:
									//(MD == 0 && MDSign == 0) ?  umult:
									//(MD == 1 && MDSign == 1) ?  {D1%D2,D1/D2}:
									//{umod[31:0],udiv[31:0]};
									
	 assign Div0 = (MD == 1)&&(D2 == 0);
	 
	 always @(posedge clk) begin
		if (reset) begin 
			HI <= 0;
			LO <= 0;
			Busy <= 0;
			counter <= 0;
		end
		else if (HLWrite) begin
			if (MD == 0) begin
				$display("Hi <= %h",D1);
				HI <= D1;  //md 0 - hi ; md 1 - lo
			end
 			if (MD == 1) begin 
				$display("Lo <= %h",D1);
				LO <= D1;
			end
		end
		if (Start && ((MD == 1 && D2 != 0) || MD == 0) && ~reset && ~InterruptRequest) begin
			StartS <= Start;
			preHI2 <= preHI;
			preLO2 <= preLO;
			MDSignS <= MDSign;
			MDS <= MD;
			
			PCS <= PCE;
			
			Busy <= 1;
			counter <= 0;
		end
		
		if (StartS) begin
			counter <= counter+1;
			if ((counter == 4-1 && MDS == 0) || (counter == 9-1 && MDS == 1)) begin
				Busy <= 0;
			end
			if ((counter == 4 && MDS == 0)) begin
				StartS <= 0;
				//Busy <= 0;
				HI <= preHI2;
				LO <= preLO2;
				$display("Hi <= %h",preHI2);
				$display("Lo <= %h",preLO2);
				//$display("PCE : %h",PCS);
				//calculate mul
			end
			if ((counter == 9 && MDS == 1)) begin
				StartS <= 0;
				//Busy <= 0;
				HI <= preHI2;
				LO <= preLO2;
				$display("Hi <= %h",preHI2);
				$display("Lo <= %h",preLO2);
				//$display("PCE : %h",PCS);
				//calculate div
			end	
		end
	end
endmodule
