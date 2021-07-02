// 0716089
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
`timescale 1ns/1ps
module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter
wire c0,c1,c2,c3;
assign c0 = (!ALUOp_i[2] && ALUOp_i[1] && !ALUOp_i[0] && funct_i[0]) || (!ALUOp_i[2] && ALUOp_i[1] && !ALUOp_i[0] && funct_i[3] && funct_i[1]) || (!ALUOp_i[2] && ALUOp_i[1] && ALUOp_i[0]);
assign c1 = (!ALUOp_i[2] && !ALUOp_i[1] && !ALUOp_i[0]) || (!ALUOp_i[2] && !ALUOp_i[1] && ALUOp_i[0]) || (!ALUOp_i[2] && ALUOp_i[1] && !ALUOp_i[0] && !funct_i[4] && !funct_i[2]) || (ALUOp_i[2] && !ALUOp_i[1] && !ALUOp_i[0]) || (!ALUOp_i[2] && ALUOp_i[1] && ALUOp_i[0]);
assign c2 = (!ALUOp_i[2] && !ALUOp_i[1] && ALUOp_i[0]) || (!ALUOp_i[2] && ALUOp_i[1] && !ALUOp_i[0] && funct_i[1]) || (!ALUOp_i[2] && ALUOp_i[1] && ALUOp_i[0]);
assign c3 = !ALUOp_i[2] && ALUOp_i[1] && !ALUOp_i[0] && !funct_i[5] && funct_i[4] && funct_i[3] && !funct_i[2] && !funct_i[1] && !funct_i[0];
always @(*) begin
    ALUCtrl_o = {c3,c2,c1,c0};
end

endmodule     






                    
                    