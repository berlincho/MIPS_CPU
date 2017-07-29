//Subject:     CO project 4 - Pipe CPU 1
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
module Pipe_CPU_1(
        clk_i,
		rst_i
		);
    
/****************************************
I/O ports
****************************************/
input clk_i;
input rst_i;

/****************************************
Internal signal
****************************************/
/**** IF stage ****/
wire [31:0] if_pc_in_i, if_pc_out_o, if_instr_o, if_Add_pc_sum_o;
wire check;
assign check = (~PCSrc && mem_Branch)? 1 : 0;
wire [31:0] if_pc_in_ii;
assign if_pc_in_ii = (check)? if_pc_in_i-32'd4 : if_pc_in_i;
/**** ID stage ****/
wire [31:0] id_instr_o, id_Add_pc_sum_o;
wire [31:0] id_rs_o, id_rt_o;
wire id_RegWrite, id_ALUSrc, id_RegDst, id_Branch, id_MemRead, id_MemWrite, id_MemtoReg;
wire [2:0] id_ALU_op;
wire [31:0] id_sign_extend_o;
wire PCWrite, ifid_Write, if_flush;

/**** EX stage ****/
wire [4:0] ex_rs, ex_rt, ex_rd;
wire [31:0] ex_Add_pc_sum_o, ex_branch_addr;
wire [31:0] ex_rs_o, ex_rt_o;
wire ex_RegWrite, ex_ALUSrc, ex_RegDst, ex_Branch, ex_MemRead, ex_MemWrite, ex_MemtoReg;
wire [2:0] ex_ALU_op;
wire [31:0] ex_sign_extend_o, ex_se_shift2;
wire [31:0] ex_sign_extend_oo;
assign ex_sign_extend_oo = (ex_ALU_op==3'b101)?(ex_sign_extend_o & 32'b00000000000000001111111111111111) : ex_sign_extend_o;
wire [31:0] ALUsrc1, ALU_Src2;
wire [4:0] ex_write_address;
wire [31:0] ex_ALU_result;
wire ex_zero;
wire [3:0] ex_ALUCtrl;
wire ex_shamt_o, ex_bne_beq_o, ex_is_nop;
wire [31:0] ex_shamt_to32;
assign ex_shamt_to32 = {27'b0,ex_sign_extend_o[10:6]};
wire zero;
assign zero = (ex_bne_beq_o)? ex_zero : ~ex_zero;
wire ex_RegWritee;
assign ex_RegWritee = (ex_is_nop)? 0 : ex_RegWrite;
wire [31:0] forwardA_data_o, forwardB_data_o;
wire [1:0] forwardA, forwardB;

/**** MEM stage ****/
wire mem_RegWrite, mem_Branch, mem_MemRead, mem_MemWrite, mem_MemtoReg;
wire [31:0] mem_branch_addr, mem_ALU_result, mem_rt_o;
wire [4:0] mem_write_address;
wire mem_zero;
wire [31:0] mem_DM_o;
wire PCSrc;
assign PCSrc = (mem_zero & mem_Branch);

/**** WB stage ****/
wire wb_MemtoReg, wb_RegWrite;
wire [31:0] wb_ALU_result, wb_DM_o;
wire [4:0] wb_write_address;
wire [31:0] wb_data_o;
/****************************************
Instnatiate modules
****************************************/
//Instantiate the components in IF stage
MUX_2to1 #(.size(32)) Mux1(
	.data0_i(if_Add_pc_sum_o),
   .data1_i(mem_branch_addr),
   .select_i(PCSrc),
   .data_o(if_pc_in_i)
        );

ProgramCounter PC(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.pc_in_i(if_pc_in_ii),
	.PCWrite(PCWrite),
	.pc_out_o(if_pc_out_o)
        );

Instr_Memory IM(
	.pc_addr_i(if_pc_out_o),
	.instr_o(if_instr_o)
	    );
			
Adder Add_pc(
	.src1_i(if_pc_out_o),     
	.src2_i(32'd4),     
	.sum_o(if_Add_pc_sum_o)
		);


Stall_Pipe_Reg #(.size(64)) IF_ID(       //N is the total length of input/output
	.clk_i(clk_i),  
	.rst_i(rst_i), 
	.ifid_Write(ifid_Write),
	.if_flush(if_flush),
	.data_i({if_Add_pc_sum_o, if_instr_o}),
	.data_o({id_Add_pc_sum_o, id_instr_o})
		);
		
//Instantiate the components in ID stage
Hazard_Detection_Unit Hazard(
	.idex_MemRead(ex_MemRead),
	.idex_rt(ex_rt),
	.ifid_rs(id_instr_o[25:21]),
	.ifid_rt(id_instr_o[20:16]),
	.PCWrite(PCWrite),
	.ifid_Write(ifid_Write),
	.ex_branch(ex_Branch),
	.id_branch(id_Branch),
	.if_flush(if_flush),
	.mem_branch(mem_Branch)
);

Reg_File RF(
	.clk_i(clk_i),      
	.rst_i(rst_i),     
   .RSaddr_i(id_instr_o[25:21]),  
   .RTaddr_i(id_instr_o[20:16]),  
   .RDaddr_i(wb_write_address),  
   .RDdata_i(wb_data_o), 
   .RegWrite_i(wb_RegWrite),
   .RSdata_o(id_rs_o),  
   .RTdata_o(id_rt_o)
		);

Decoder Control(
	.instr_op_i(id_instr_o[31:26]),
   .RegWrite_o(id_RegWrite),
   .ALU_op_o(id_ALU_op),
   .ALUSrc_o(id_ALUSrc),
   .RegDst_o(id_RegDst),
   .Branch_o(id_Branch),
   .MemRead_o(id_MemRead),
   .MemWrite_o(id_MemWrite),
   .MemToReg_o(id_MemtoReg)
		);

Sign_Extend Sign_Extend(
	.data_i(id_instr_o[15:0]),
   .data_o(id_sign_extend_o)
		);	

Pipe_Reg #(.size(153)) ID_EX(
	.clk_i(clk_i),  
	.rst_i(rst_i), 
	.data_i({id_RegWrite, id_ALU_op, id_ALUSrc, id_RegDst, id_Branch, id_MemRead, id_MemWrite, id_MemtoReg, 
	id_Add_pc_sum_o, id_rs_o, id_rt_o, id_sign_extend_o, id_instr_o[25:21], id_instr_o[20:16], id_instr_o[15:11]}),
	.data_o({ex_RegWrite, ex_ALU_op, ex_ALUSrc, ex_RegDst, ex_Branch, ex_MemRead, ex_MemWrite, ex_MemtoReg, 
	ex_Add_pc_sum_o, ex_rs_o, ex_rt_o, ex_sign_extend_o, ex_rs, ex_rt, ex_rd})
		);
		
//Instantiate the components in EX stage
Adder Add_branch_addr(
	.src1_i(ex_Add_pc_sum_o),     
	.src2_i(ex_se_shift2),     
	.sum_o(ex_branch_addr)
		);
Shift_Left_Two_32 shift2(
	.data_i(ex_sign_extend_o),
   .data_o(ex_se_shift2)
);

Forwarding_Unit Forwarding_Unit(
	.exmem_rd(mem_write_address),
	.idex_rs(ex_rs),
	.idex_rt(ex_rt),
	.memwb_rd(wb_write_address),
	.exmem_RegWrite(mem_RegWrite),
	.memwb_RegWrite(wb_RegWrite),
	.forwardA(forwardA),
	.forwardB(forwardB)
);
   
ALU ALU(
	.src1_i(ALUsrc1),
	.src2_i(ALU_Src2),
	.ctrl_i(ex_ALUCtrl),
	.result_o(ex_ALU_result),
	.zero_o(ex_zero)
		);
		
ALU_Ctrl ALU_Control(
	.funct_i(ex_sign_extend_o[5:0]),   
   .ALUOp_i(ex_ALU_op),
   .ALUCtrl_o(ex_ALUCtrl),
	.shamt_o(ex_shamt_o),
	.bne_beq_o(ex_bne_beq_o),
	.is_nop(ex_is_nop)
		);
MUX_2to1 #(.size(32)) MUX_ALU_Src1(
        .data0_i(forwardA_data_o),
        .data1_i(ex_shamt_to32),
        .select_i(ex_shamt_o),
        .data_o(ALUsrc1)
        );
		  
MUX_2to1 #(.size(32)) MUX_ALU_Src2(
	.data0_i(forwardB_data_o),
   .data1_i(ex_sign_extend_oo),
   .select_i(ex_ALUSrc),
   .data_o(ALU_Src2)
        );
		
MUX_2to1 #(.size(5)) RDRT_Mux(
	.data0_i(ex_rt),
   .data1_i(ex_rd),
   .select_i(ex_RegDst),
   .data_o(ex_write_address)
        );
		  
MUX_3to1 #(.size(32)) Forward_A(
	.data0_i(ex_rs_o),
   .data1_i(wb_data_o),
	.data2_i(mem_ALU_result),
   .select_i(forwardA),
   .data_o(forwardA_data_o)
        );
		  
MUX_3to1 #(.size(32)) Forward_B(
	.data0_i(ex_rt_o),
   .data1_i(wb_data_o),
	.data2_i(mem_ALU_result),
   .select_i(forwardB),
   .data_o(forwardB_data_o)
        );		  

Pipe_Reg #(.size(107)) EX_MEM(
	.clk_i(clk_i),  
	.rst_i(rst_i), 
	.data_i({ex_RegWritee, ex_Branch, ex_MemRead, ex_MemWrite, ex_MemtoReg, ex_branch_addr, ex_ALU_result, zero, forwardB_data_o, ex_write_address}),
	.data_o({mem_RegWrite, mem_Branch, mem_MemRead, mem_MemWrite, mem_MemtoReg, mem_branch_addr, mem_ALU_result, mem_zero, mem_rt_o, mem_write_address})
		);
			   
//Instantiate the components in MEM stage
Data_Memory DM(
	.clk_i(clk_i),
	.addr_i(mem_ALU_result),
	.data_i(mem_rt_o),
	.MemRead_i(mem_MemRead),
	.MemWrite_i(mem_MemWrite),
	.data_o(mem_DM_o)
	    );

Pipe_Reg #(.size(71)) MEM_WB(
	.clk_i(clk_i),  
	.rst_i(rst_i), 
	.data_i({mem_MemtoReg, mem_RegWrite, mem_DM_o, mem_ALU_result, mem_write_address}),
	.data_o({wb_MemtoReg, wb_RegWrite, wb_DM_o, wb_ALU_result, wb_write_address})
		);

//Instantiate the components in WB stage
MUX_2to1 #(.size(32)) Mux3(
	.data0_i(wb_ALU_result),
   .data1_i(wb_DM_o),
   .select_i(wb_MemtoReg),
   .data_o(wb_data_o)
        );

/****************************************
signal assignment
****************************************/	
endmodule

