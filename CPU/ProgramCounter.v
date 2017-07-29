//Subject:     CO project 2 - PC
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
module ProgramCounter(
    clk_i,
	rst_i,
	pc_in_i,
	pc_out_o,
	PCWrite
	);
     
//I/O ports
input           clk_i;
input	        rst_i;
input  [32-1:0] pc_in_i;
input            PCWrite;
output [32-1:0] pc_out_o;
 
//Internal Signals
reg    [32-1:0] pc_out_o;
reg    [32-1:0] pc_stall;
//Parameter

    
//Main function
always @(posedge clk_i) begin
   if(~rst_i)begin
	    pc_out_o <= 0;
		 pc_stall <= 0;
	end
	else if(PCWrite)begin
	    pc_out_o <= pc_in_i;
		 pc_stall <= pc_in_i;
	end
	else	
	begin
		 pc_out_o <= pc_stall;
		 pc_stall <= pc_stall;
	end
	end

endmodule



                    
                    