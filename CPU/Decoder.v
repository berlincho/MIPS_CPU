//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
//0316303¨ô¬fÀM_0316309½²©ú®S
module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
	MemRead_o,
	MemWrite_o,
	MemToReg_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
output 			MemRead_o;
output			MemWrite_o;
output			MemToReg_o;
 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;
reg				MemRead_o;
reg				MemWrite_o;
reg				MemToReg_o;

//Parameter
parameter addi = 6'b001000;//8
parameter R_type = 6'b000000; //0
parameter beq = 6'b000100; //4
parameter bne = 6'b000101; //5
//parameter lui = 6'b001111; //15
parameter ori = 6'b001101; //13
parameter sltiu = 6'b001001; //9
parameter lw = 6'b100011;
parameter sw = 6'b101011;

parameter alu_R_type = 3'b000; //0
parameter alu_addi = 3'b001;//1
parameter alu_beq = 3'b010;//2
parameter alu_bne = 3'b011;//3
//parameter alu_lui = 3'b100;//4
parameter alu_ori = 3'b101;//5
parameter alu_sltiu = 3'b110;//6
parameter alu_lwsw = 3'b111;//7


//Main function
always@(*)
begin
	case(instr_op_i)
	addi: //addi
	begin
		RegDst_o = 0;
		ALUSrc_o = 1;
		RegWrite_o = 1; 
		ALU_op_o = alu_addi; 
		Branch_o = 0;
		MemRead_o = 0;
		MemWrite_o = 0;
		MemToReg_o = 0;
	end
	R_type://r_type
	begin
		RegDst_o = 1;
		ALUSrc_o = 0;
		RegWrite_o = 1; 
		ALU_op_o = alu_R_type; 
		Branch_o = 0;
		MemRead_o = 0;
		MemWrite_o = 0;
		MemToReg_o = 0;
	end
	beq://beq
	begin
		RegDst_o = 1; //ignore
		ALUSrc_o = 0;
		RegWrite_o = 0; 
		ALU_op_o = alu_beq; 
		Branch_o = 1;
		MemRead_o = 0;
		MemWrite_o = 0;
		MemToReg_o = 0; //ignore
	end
	bne://bne
	begin
		RegDst_o = 1; //ignore
		ALUSrc_o = 0;
		RegWrite_o = 0; 
		ALU_op_o = alu_bne; 
		Branch_o = 1;
		MemRead_o = 0;
		MemWrite_o = 0;
		MemToReg_o = 0; //ignore
	end
	/*lui://lui
	begin
		RegDst_o = 0;
		ALUSrc_o = 1;
		RegWrite_o = 1; 
		ALU_op_o = alu_lui; 
		Branch_o = 0;
	end*/
	ori://ori
	begin
		RegDst_o = 0;
		ALUSrc_o = 1;
		RegWrite_o = 1; 
		ALU_op_o = alu_ori; 
		Branch_o = 0;
		MemRead_o = 0;
		MemWrite_o = 0;
		MemToReg_o = 0;
	end
	sltiu://sltiu
	begin
		RegDst_o = 0;
		ALUSrc_o = 1;
		RegWrite_o = 1; 
		ALU_op_o = alu_sltiu; 
		Branch_o = 0;
		MemRead_o = 0;
		MemWrite_o = 0;
		MemToReg_o = 0;
	end
	lw:
	begin
		RegDst_o = 0; 
		ALUSrc_o = 1;
		RegWrite_o = 1; 
		ALU_op_o = alu_lwsw; 
		Branch_o = 0;
		MemRead_o = 1;
		MemWrite_o = 0;
		MemToReg_o = 1; 
	end
	sw:
	begin
		RegDst_o = 1; //ignore
		ALUSrc_o = 1;
		RegWrite_o = 0; 
		ALU_op_o = alu_lwsw; 
		Branch_o = 0;
		MemRead_o = 0;
		MemWrite_o = 1;
		MemToReg_o = 0; //ignore
	end
	endcase
end
endmodule





                    
                    