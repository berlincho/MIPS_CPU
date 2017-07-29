`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:55:54 05/25/2016 
// Design Name: 
// Module Name:    Forwarding_Unit 
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
module Forwarding_Unit(
	exmem_rd,
	idex_rs,
	idex_rt,
	memwb_rd,
	exmem_RegWrite,
	memwb_RegWrite,
	forwardA,
	forwardB
    );
input [4:0]	exmem_rd;
input [4:0]	idex_rs;
input [4:0]	idex_rt;
input [4:0]	memwb_rd;
input   		exmem_RegWrite;
input       memwb_RegWrite;
output reg [1:0]  forwardA;
output reg [1:0]	forwardB;
wire ex_hazard_rs, ex_hazard_rt, mem_hazard_rs, mem_hazard_rt;
assign ex_hazard_rs = (exmem_RegWrite && (exmem_rd!=0) && (exmem_rd==idex_rs))? 1:0;
assign ex_hazard_rt = (exmem_RegWrite && (exmem_rd!=0) && (exmem_rd==idex_rt))? 1:0;
assign mem_hazard_rs = (memwb_RegWrite && (memwb_rd!=0) && (memwb_rd==idex_rs) && !(ex_hazard_rs))? 1:0;
assign mem_hazard_rt = (memwb_RegWrite && (memwb_rd!=0) && (memwb_rd==idex_rt) && !(ex_hazard_rt))? 1:0;

always@(*)begin
	if(ex_hazard_rs) //ex hazard
	begin
		forwardA <= 2'b10;
		if(mem_hazard_rt)
			forwardB <=	2'b01;
		else
			forwardB <=	2'b00;
	end
	else if(ex_hazard_rt) //ex hazard
	begin
		if(mem_hazard_rs)
			forwardA <= 2'b01;
		else
			forwardA <= 2'b00;
		forwardB <=	2'b10;
	end
	else if(mem_hazard_rs)//mem hazard
	begin
		forwardA <= 2'b01;
		if(ex_hazard_rt)
		forwardB <=	2'b10;
		else
			forwardB <=	2'b00;
	end
	else if(mem_hazard_rt) //mem hazard
	begin
		if(ex_hazard_rs)
			forwardA <= 2'b10;
		else
			forwardA <= 2'b00;
		forwardB <=	2'b01;
	end
	else
	begin
		forwardA <= 2'b00;
		forwardB <=	2'b00;
	end
end
endmodule
