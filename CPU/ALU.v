//Subject:     CO project 2 - ALU
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
module ALU(
    src1_i,
	src2_i,
	ctrl_i,
	//immed_i,
	result_o,
	zero_o
	);
     
//I/O ports
input  [32-1:0]  src1_i;
input  [32-1:0]  src2_i;
input  [4-1:0]   ctrl_i;
//input   [15:0]		immed_i;

output [32-1:0]	 result_o;
output           zero_o;

//Internal signals
//reg [31:0]src1_i;
//reg [31:0]src2_i;
reg    [32-1:0]  result_o;
wire             zero_o;
wire signed [31:0]tmp1;
assign tmp1 = src2_i;
wire signed [31:0]tmp2;
assign tmp2 = src1_i;
reg [63:0]mul_result;
  
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
 
//Main function
assign zero_o = (result_o==32'b0)? 1:0;
always@(*)
begin            
	case(ctrl_i)
	AND: result_o <= src1_i & src2_i;
	OR: result_o <= src1_i | src2_i;
	ADD: result_o <= src1_i + src2_i;
	SUB: result_o <= src1_i - src2_i;
	SLT: result_o <= (tmp2 < tmp1)? 1 : 0;
	SLTU: result_o <= (tmp2 < src2_i)? 1 : 0;
	NOR: result_o <= ~(src1_i | src2_i);
	SHIFT: result_o <= tmp1 >>> src1_i;
	//LUI: result_o <= {immed_i,16'b0};
	MUL: 
	begin
		mul_result = src1_i * src2_i;
		result_o = mul_result[31:0];
	end
	default:
		result_o <= 0;
	endcase
end
endmodule





                    
                    