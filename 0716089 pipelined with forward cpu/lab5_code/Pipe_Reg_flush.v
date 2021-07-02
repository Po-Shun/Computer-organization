`timescale 1ns / 1ps
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
module Pipe_Reg_Flush(
    clk_i,
    rst_i,
    flush,
    regwrite,
    data_i,
    data_o
    );
					
parameter size = 0;
input   flush;
input   clk_i;		  
input   rst_i;
input regwrite;
input   [size-1:0] data_i;
output reg  [size-1:0] data_o;
	  
always@(posedge clk_i) begin
    if (~rst_i || flush) begin
        data_o <= 0;
        end 
    else begin
        if (regwrite) 
            data_o <= data_i;
        else
            data_o <= data_o;
        end
end

endmodule	