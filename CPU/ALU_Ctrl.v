//Subject:     CO project 2 - ALU Controller
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
module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o,
			 shamt_o,
			 bne_beq_o,
			 is_nop
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output  reg   [4-1:0] ALUCtrl_o;    
output  reg           shamt_o ;
output  reg           bne_beq_o;
output  reg           is_nop;
//Internal Signals

//Parameter
parameter AND = 4'b0000;//0
parameter OR = 4'b0001;//1
parameter ADD = 4'b0010;//2
parameter SUB = 4'b0110;//6
parameter SLT = 4'b0111;//7
parameter NOR = 4'b1100;//12
parameter SLTU = 4'b1101;//13
parameter SHIFT = 4'b1110;//14
//parameter LUI = 4'B1111;//15
parameter MUL = 4'b1000;//8

parameter alu_R_type = 3'b000;//0
parameter alu_addi = 3'b001;//1
parameter alu_beq = 3'b010;//2
parameter alu_bne = 3'b011;//3
//parameter alu_lui = 3'b100;//4
parameter alu_ori = 3'b101;//5
parameter alu_sltiu = 3'b110;//6
parameter alu_lwsw = 3'b111;//7

//Select exact operation
always @(*) begin
	shamt_o <= 0;
	is_nop <= 0;
	case(ALUOp_i)
		alu_R_type:
		begin
			if(funct_i==6'b100000)//add
				ALUCtrl_o <= ADD;
			else if(funct_i==6'b100010)//sub
				ALUCtrl_o <= SUB;
			else if(funct_i==6'b100100)//and
				ALUCtrl_o <= AND;
			else if(funct_i==6'b100101)//or
				ALUCtrl_o <= OR;
			else if(funct_i==6'b101010)//slt
				ALUCtrl_o <= SLT;
			else if(funct_i==6'b000011)//sra
			begin
				ALUCtrl_o <= SHIFT;
				shamt_o <= 1;
			end
			else if(funct_i==6'b000111)//srav
				ALUCtrl_o <= SHIFT;
			else if(funct_i==6'b011000)//mul
				ALUCtrl_o <= MUL;
			else if(funct_i==6'b000000)//nop
				is_nop <= 1;
		end
		alu_addi:
			ALUCtrl_o <= ADD;
		alu_beq:
		begin
			ALUCtrl_o <= SUB;
			bne_beq_o = 1;
		end
		alu_bne:
		begin
			ALUCtrl_o <= SUB;
			bne_beq_o = 0;
		end
		//alu_lui:
			//ALUCtrl_o <= LUI;
		alu_ori:
			ALUCtrl_o <= OR;
		alu_sltiu:
			ALUCtrl_o <= SLTU;
		alu_lwsw:
			ALUCtrl_o <= ADD;
	endcase
		
	
end

endmodule     





                    
                    