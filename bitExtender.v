`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:34:31 11/15/2016 
// Design Name: 
// Module Name:    bitExtender 
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
module bitExtender16to32(
    input [15:0] In,
	 input sign,
    output [31:0] Out
    );
	assign Out = sign? {{16{In[15]}}, In[15:0]} : {{16{1'b0}}, In[15:0]};

endmodule

module bitExtender18to32(
    input [17:0] In,
	 input sign,
    output [31:0] Out
    );
	assign Out = sign? {{14{In[15]}}, In[17:0]} : {{14{1'b0}}, In[17:0]};

endmodule

module bitExtender8to32(
    input [7:0] In,
	 input sign,
    output [31:0] Out
    );
	assign Out = sign? {{24{In[7]}}, In[7:0]} : {{24{1'b0}}, In[7:0]};
endmodule

module bitExtender5to32(
    input [4:0] In,
	 input sign,
    output [31:0] Out
    );
	assign Out = sign? {{27{In[4]}}, In[4:0]} : {{27{1'b0}}, In[4:0]};

endmodule
