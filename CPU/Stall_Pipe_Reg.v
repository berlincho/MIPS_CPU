//Subject:     CO project 4 - Pipe Register
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
module Stall_Pipe_Reg(
    clk_i,
	rst_i,
	data_i,
	data_o,
	ifid_Write,
	if_flush
	);

parameter size = 0;

input					clk_i;		  
input					rst_i;
input		[size-1: 0]	data_i;
input					ifid_Write;
input					if_flush;
output reg	[size-1: 0]	data_o;

reg [size-1: 0] stall;
always @(posedge clk_i) begin
   if(~rst_i || if_flush)begin
      data_o <= 0;
		stall <= 0;
	end
   else if(ifid_Write)begin
      data_o <= data_i;
		stall <= data_i;
	end
	else
		data_o <= stall;
end

endmodule	