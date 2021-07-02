//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Luke
//----------------------------------------------
//Date:        2010/8/16
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
	MemtoReg_o,
	MemRead_o,
	MemWrite_o,
	Jump_o,
	Jal_o,
	JalWrite_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
output         MemtoReg_o;
output         MemRead_o;
output         MemWrite_o;
output         Jump_o;
output         Jal_o;
output         JalWrite_o; 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegDst_o;
reg            Branch_o;
reg            MemtoReg_o;
reg            MemRead_o;
reg            MemWrite_o;
reg            Jump_o;
reg            Jal_o;
reg            JalWrite_o;




//Parameter
wire r,addi,slti,beq,lw,sw,jump,jal,jr;

//Main function
assign r = !instr_op_i[0] && !instr_op_i[1] && !instr_op_i[2] && !instr_op_i[3] && !instr_op_i[4] && !instr_op_i[5];
assign addi = !instr_op_i[0] && !instr_op_i[1] && !instr_op_i[2] && instr_op_i[3] && !instr_op_i[4] && !instr_op_i[5];
assign slti = !instr_op_i[0] && instr_op_i[1] && !instr_op_i[2] && instr_op_i[3] && !instr_op_i[4] && !instr_op_i[5];
assign beq = !instr_op_i[0] && !instr_op_i[1] && instr_op_i[2] && !instr_op_i[3] && !instr_op_i[4] && !instr_op_i[5];
assign lw = instr_op_i[0] && instr_op_i[1] && !instr_op_i[2] && !instr_op_i[3] && !instr_op_i[4] && instr_op_i[5];
assign sw = instr_op_i[0] && instr_op_i[1] && !instr_op_i[2] && instr_op_i[3] && !instr_op_i[4] && instr_op_i[5];
assign jump = !instr_op_i[0] && instr_op_i[1] && !instr_op_i[2] && !instr_op_i[3] && !instr_op_i[4] && !instr_op_i[5];
assign jal = instr_op_i[0] && instr_op_i[1] && !instr_op_i[2] && !instr_op_i[3] && !instr_op_i[4] && !instr_op_i[5];
assign jr = !instr_op_i[0] && !instr_op_i[1] && !instr_op_i[2] && !instr_op_i[3] && !instr_op_i[4] && !instr_op_i[5];

always @(*)begin
	RegDst_o = r;
	ALUSrc_o = addi || slti || lw || sw ;
	MemtoReg_o = lw;
	MemRead_o = lw;
	MemWrite_o = sw;
	Branch_o = beq;
	ALU_op_o[0] = addi || beq || jump || sw;
	ALU_op_o[1] = r || jr || addi || jal || sw;
	ALU_op_o[2] = slti || jump || jal || sw;
	Jump_o = jump || jal;
	Jal_o = jal;
	JalWrite_o = jal;
end
endmodule





                    
                    