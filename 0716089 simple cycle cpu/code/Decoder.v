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
	Branch_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
 
//Internal Signals
 reg    [3-1:0] ALU_op_o;
 reg            ALUSrc_o;
 reg            RegWrite_o;
 reg            RegDst_o;
 reg            Branch_o;

// wire r,addi,slti,beq;
// assign r = !instr_op_i[0] && !instr_op_i[1] && !instr_op_i[2] && !instr_op_i[3] && !instr_op_i[4] && !instr_op_i[5];
// assign addi = !instr_op_i[0] && !instr_op_i[1] && !instr_op_i[2] && instr_op_i[3] && !instr_op_i[4] && !instr_op_i[5];
// assign slti = !instr_op_i[0] && instr_op_i[1] && !instr_op_i[2] && instr_op_i[3] && !instr_op_i[4] && !instr_op_i[5];
// assign beq = !instr_op_i[0] && !instr_op_i[1] && instr_op_i[2] && !instr_op_i[3] && !instr_op_i[4] && !instr_op_i[5];
// always @(*) begin
//     ALU_op_o[0] = slti || beq;
//     ALU_op_o[1] = r || slti ;
//     ALU_op_o[2] = 0;
//     ALUSrc_o = addi || slti;
// 	RegWrite_o = r || addi || slti;
// 	RegDst_o = r;
// 	Branch_o = beq;
// end
//Parameter
//always @(*) begin
//$display("instr_op_i:%b   op: %b", instr_op_i,ALU_op_o); end
//Main function
always @(instr_op_i) begin
	case(instr_op_i) 
		6'b000000: begin
			ALU_op_o <= 3'b010;
			ALUSrc_o <= 0;
			RegWrite_o <= 1;
			RegDst_o <= 1;
			Branch_o <= 0;
		end
		6'b001000:  begin
			ALU_op_o <= 3'b000;
			ALUSrc_o <= 1;
			RegWrite_o <= 1;
			RegDst_o <= 0;
			Branch_o <= 0;
		end
		6'b001010:  begin
			ALU_op_o <= 3'b011;
			ALUSrc_o <= 1;
			RegWrite_o <= 1;
			RegDst_o <= 0;
			Branch_o <= 0;
		end
		6'b000100: begin
			ALU_op_o <= 3'b001;
			ALUSrc_o <= 0;
			RegWrite_o <= 0;
			RegDst_o <= 1'bx;
			Branch_o <= 1;
		end
		default : begin
		    ALU_op_o <= 3'b010;
			ALUSrc_o <= 0;
			RegWrite_o <= 1;
			RegDst_o <= 1;
			Branch_o <= 0;
		end
	endcase
end

endmodule





                    
                    