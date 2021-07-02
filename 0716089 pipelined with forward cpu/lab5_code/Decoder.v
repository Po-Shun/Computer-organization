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
module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
    MemRead_o,
    MemtoReg_o,
    MemWrite_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output [2:0]   Branch_o;
output         MemRead_o;
output         MemtoReg_o;
output         MemWrite_o;
 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg    [2:0]   Branch_o;
reg            MemRead_o;
reg            MemtoReg_o;
reg            MemWrite_o;

wire r,addi,slti,beq,lw,sw,bne,bge,bgt;
assign lw = instr_op_i[0] && instr_op_i[1] && !instr_op_i[2] && !instr_op_i[3] && !instr_op_i[4] && instr_op_i[5];
assign sw = instr_op_i[0] && instr_op_i[1] && !instr_op_i[2] && instr_op_i[3] && !instr_op_i[4] && instr_op_i[5];
assign r = !instr_op_i[0] && !instr_op_i[1] && !instr_op_i[2] && !instr_op_i[3] && !instr_op_i[4] && !instr_op_i[5];
assign addi = !instr_op_i[0] && !instr_op_i[1] && !instr_op_i[2] && instr_op_i[3] && !instr_op_i[4] && !instr_op_i[5];
assign slti = !instr_op_i[0] && instr_op_i[1] && !instr_op_i[2] && instr_op_i[3] && !instr_op_i[4] && !instr_op_i[5];
assign beq = instr_op_i[0] && !instr_op_i[1] && instr_op_i[2] && !instr_op_i[3] && !instr_op_i[4] && !instr_op_i[5];
assign bne = !instr_op_i[0] && !instr_op_i[1] && instr_op_i[2] && !instr_op_i[3] && !instr_op_i[4] && !instr_op_i[5];
assign bge = instr_op_i[0] && !instr_op_i[1] && !instr_op_i[2] && !instr_op_i[3] && !instr_op_i[4] && !instr_op_i[5];
assign bgt = instr_op_i[0] && instr_op_i[1] && instr_op_i[2] && !instr_op_i[3] && !instr_op_i[4] && !instr_op_i[5];
always @(*) begin
    ALU_op_o[0] = slti || beq || bne || bge || bgt;
    ALU_op_o[1] = r || slti ;
    ALU_op_o[2] = addi;
    ALUSrc_o = addi || slti || lw || sw;
	RegWrite_o = r || addi || slti || lw;
	RegDst_o = r;
    // branch type -> 000 other 001 beq 010 bne 011 bge 100 bgt
    Branch_o[2] = bgt;
	Branch_o[1] = bne || bge;
    Branch_o[0] = beq || bge;
    MemRead_o = lw;
    MemtoReg_o = lw;
    MemWrite_o = sw;
end

endmodule





                    
                    