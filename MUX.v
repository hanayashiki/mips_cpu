`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:33:10 11/14/2016 
// Design Name: 
// Module Name:    MUX5 
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
module MUX52(
    input [4:0] In0,
    input [4:0] In1,
    input Select,
	 output [4:0] Out
    );
	assign Out = (Select == 0)? In0:In1;
endmodule

module MUX53(
    input [4:0] In0,
    input [4:0] In1,
    input [4:0] In2,
    input [1:0]Select,
	 output [4:0] Out
    );
	assign Out = (Select == 0)? In0:(Select == 1? In1 : In2);
endmodule

module MUX322(
    input [31:0] In0,
    input [31:0] In1,
    input Select,
	 output [31:0] Out
    );
	assign Out = (Select == 0)? In0:In1;
endmodule

module MUX323(
    input [31:0] In0,
    input [31:0] In1,
    input [31:0] In2,
    input [1:0]Select,
	 output [31:0] Out
    );
	assign Out = (Select == 0)? In0:(Select == 1? In1 : In2);
endmodule

module MUX324(
    input [31:0] In0,
    input [31:0] In1,
    input [31:0] In2,
	 input [31:0] In3,
    input [1:0]Select,
	 output [31:0] Out
    );
	assign Out = (Select == 0)? In0:(Select == 1? In1 : (Select == 2? In2 : In3));
endmodule

module MUX328(
    input [31:0] In0,
    input [31:0] In1,
    input [31:0] In2,
	 input [31:0] In3,
    input [31:0] In4,
    input [31:0] In5,
    input [31:0] In6,
	 input [31:0] In7,
    input [2:0] Select,
	 output [31:0] Out
    );
    assign Out = Select == 0 ? In0 :
					  Select == 1 ? In1 :
					  Select == 2 ? In2 :
					  Select == 3 ? In3 :
					  Select == 4 ? In4 :
					  Select == 5 ? In5 :
					  Select == 6 ? In6 :
					  In7;
endmodule

module MUX54(
    input [4:0] In0,
    input [4:0] In1,
    input [4:0] In2,
	 input [4:0] In3,
    input [1:0]Select,
	 output [4:0] Out
    );
	assign Out = (Select == 0)? In0:(Select == 1? In1 : (Select == 2? In2 : In3));
endmodule

