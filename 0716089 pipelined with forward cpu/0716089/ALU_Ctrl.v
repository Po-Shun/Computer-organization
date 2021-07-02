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
// wire c0,c1,c2,c3;
// assign c0 = (!ALUOp_i[2] && ALUOp_i[1] && !ALUOp_i[0] && funct_i[0]) || (!ALUOp_i[2] && ALUOp_i[1] && !ALUOp_i[0] && funct_i[3] && funct_i[1]) || (!ALUOp_i[2] && ALUOp_i[1] && ALUOp_i[0]);
// assign c1 = (!ALUOp_i[2] && !ALUOp_i[1] && !ALUOp_i[0]) || (!ALUOp_i[2] && !ALUOp_i[1] && ALUOp_i[0]) || (!ALUOp_i[2] && ALUOp_i[1] && !ALUOp_i[0] && !funct_i[4] && !funct_i[2]) || (ALUOp_i[2] && !ALUOp_i[1] && !ALUOp_i[0]) || (!ALUOp_i[2] && ALUOp_i[1] && ALUOp_i[0]);
// assign c2 = (!ALUOp_i[2] && !ALUOp_i[1] && ALUOp_i[0]) || (!ALUOp_i[2] && ALUOp_i[1] && !ALUOp_i[0] && funct_i[1]) || (!ALUOp_i[2] && ALUOp_i[1] && ALUOp_i[0]);
// assign c3 = !ALUOp_i[2] && ALUOp_i[1] && !ALUOp_i[0] && !funct_i[5] && funct_i[4] && funct_i[3] && !funct_i[2] && !funct_i[1] && !funct_i[0];
// always @(*) begin
//     ALUCtrl_o = {c3,c2,c1,c0};
// end
always @(*) begin
   case(ALUOp_i)
        3'b010:begin
            case(funct_i)
                6'b100000: ALUCtrl_o <=4'b0010;
                6'b100010: ALUCtrl_o <=4'b0110;
                6'b100100: ALUCtrl_o <=4'b0000;
                6'b100101: ALUCtrl_o <=4'b0001;
                6'b101010: ALUCtrl_o <=4'b0111;
                6'b011000: ALUCtrl_o <=4'b1000;
            endcase
        end
        3'b100:ALUCtrl_o <=4'b0010;
        3'b011:ALUCtrl_o <=4'b0111;
        3'b001:ALUCtrl_o <=4'b0110;
        2'b000:ALUCtrl_o <=4'b0010;
   endcase
end

endmodule     






                    
                    