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
// assign c0 = (ALUOp_i[1]&&ALUOp_i[0]) || (ALUOp_i[1] && funct_i[0]) || (ALUOp_i[1] && funct_i[3]);
// assign c1 = (!ALUOp_i[1]&& !ALUOp_i[0]) || (ALUOp_i[1]&&ALUOp_i[0]) || (!ALUOp_i[1]&&ALUOp_i[0]) || !funct_i[2];
// assign c2 = (ALUOp_i[1]&&ALUOp_i[0]) || (!ALUOp_i[1]&&ALUOp_i[0]) || (ALUOp_i[1]&&funct_i[1]);
// assign c3 = 0;
// always @(*) begin
//     ALUCtrl_o = {c3,c2,c1,c0};
// end
//assign check = {ALUOp_i,funct_i};
always @(*) begin
$display(" ALUOP = %b ctrl = %b",{ALUOp_i,funct_i},ALUCtrl_o); end
// Select exact operation
always @(*) begin
   case(ALUOp_i)
        3'b010:begin
            case(funct_i)
                6'b100000: ALUCtrl_o <=4'b0010;
                6'b100010: ALUCtrl_o <=4'b0110;
                6'b100100: ALUCtrl_o <=4'b0000;
                6'b100101: ALUCtrl_o <=4'b0001;
                6'b101010: ALUCtrl_o <=4'b0111;
            endcase
        end
        3'b000:ALUCtrl_o <=4'b0010;
        3'b011:ALUCtrl_o <=4'b0111;
        3'b001:ALUCtrl_o <=4'b0110;
       // r-type
       // add 0010 sub 0110 and 0000 or 0001 slt 0111 
    //    9'b010100000: ALUCtrl_o <=4'b0010;
    //    9'b010100010: ALUCtrl_o <=4'b0110;
    //    9'b010100100: ALUCtrl_o <=4'b0000;
    //    9'b010100101: ALUCtrl_o <=4'b0001;
    //    9'b010101010: ALUCtrl_o <=4'b0111;

    //    // i-type
    //    // addi 0010 slit 0111
    //    9'b000xxxxxx: ALUCtrl_o <=4'b0010;
    //    9'b011xxxxxx: ALUCtrl_o <=4'b0111;

    //    // beq
    //    9'b001xxxxxx: ALUCtrl_o <=4'b0110;
   endcase
end


endmodule     





                    
                    