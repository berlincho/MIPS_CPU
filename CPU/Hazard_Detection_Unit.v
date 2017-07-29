`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:55:27 05/25/2016 
// Design Name: 
// Module Name:    Hazard_Detection_Unit 
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
module Hazard_Detection_Unit(
	idex_MemRead,
	idex_rt,
	ifid_rs,
	ifid_rt,
	PCWrite,
	ifid_Write,
	if_flush,
	mem_branch,
	ex_branch,
	id_branch
    );
input  		 idex_MemRead;
input  [4:0] idex_rt;
input  [4:0] ifid_rs;
input  [4:0] ifid_rt;
input  		 ex_branch;
input  		 id_branch;
input  		 mem_branch;
output	reg PCWrite;
output	reg ifid_Write;
output	reg if_flush;

parameter beq = 6'b000100; //4
parameter bne = 6'b000101; //5

always@(*)begin
	if(idex_MemRead && ((idex_rt==ifid_rs) || (idex_rt==ifid_rt)))
	begin
		PCWrite <= 0;
		ifid_Write <= 0;
		if_flush <= 0;
	end
	else if(mem_branch | ex_branch | id_branch )
	begin
		if(mem_branch)
			PCWrite <= 1;
		else 
			PCWrite <= 0;
		ifid_Write <= 0;
		if_flush <= 1;
	end
	else
	begin
		PCWrite <= 1;
		ifid_Write <= 1;
		if_flush <= 0;
	end
end

endmodule
