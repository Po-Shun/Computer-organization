// 0716089
//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Luke
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
`timescale 1ns/1ps
module branch_dection_unit(
        branch,
        zero,
        PCSrc_o
	);

//I/O ports
input [3-1:0] branch;
input [2-1:0] zero; 

output PCSrc_o;
//Internal Signals
reg PCSrc_o;

always @(*) begin
    // beq
    if (branch == 3'b001 && zero == 2'b01) PCSrc_o = 1;
    // bne
    else if ((branch == 3'b010 && zero == 2'b10) || (branch == 3'b010 && zero == 2'b00)) PCSrc_o = 1; 
    // bge
    else if ((branch == 3'b011 && zero == 2'b01) || (branch == 3'b011 && zero == 2'b10))  PCSrc_o = 1;
    // bgt 
    else if(branch == 3'b100 && zero == 2'b10) PCSrc_o = 1;
    else PCSrc_o = 0;
end



endmodule