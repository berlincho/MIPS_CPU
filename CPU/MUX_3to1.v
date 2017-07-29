`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:45:22 05/10/2016 
// Design Name: 
// Module Name:    Mux_3to1 
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
//0316303¨ô¬fÀM_0316309½²©ú®S
module MUX_3to1(
               data0_i,
               data1_i,
				data2_i,
               select_i,
               data_o
               );

parameter size = 0;			   
			
//I/O ports               
input   [size-1:0] data0_i;          
input   [size-1:0] data1_i;
input   [size-1:0] data2_i;

input    [2-1:0]         select_i;
output  [size-1:0] data_o; 

//Internal Signals
reg     [size-1:0] data_o;

//Main function
always@(*)
begin
	case(select_i)
	0:
		data_o = data0_i;
	1:
		data_o = data1_i;
	2:
		data_o = data2_i;
	endcase
	
end
endmodule   