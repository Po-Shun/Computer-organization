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

module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o,
          RegWrite_o,
          jr_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
output     RegWrite_o;
output     jr_o;     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;
reg RegWrite_o;
reg jr_o;
//Parameter
wire RegWrite;
wire jr;
wire c3;
wire c2;
wire c1;
wire c0;       
//Select exact operation
assign RegWrite = (!ALUOp_i[2] && ALUOp_i[1] && !ALUOp_i[0] && funct_i[5] ) ||
                       (!ALUOp_i[2] && ALUOp_i[1] && ALUOp_i[0]) ||
                       (ALUOp_i[2] && !ALUOp_i[1] && !ALUOp_i[0]) || 
                       (!ALUOp_i[2] && !ALUOp_i[1] && !ALUOp_i[0]) ||
                       (ALUOp_i[2] && ALUOp_i[1] && !ALUOp_i[0]);
assign jr = (!ALUOp_i[2] && ALUOp_i[1] && !ALUOp_i[0] && !funct_i[5] && !funct_i[4] && funct_i[3] && !funct_i[2] && !funct_i[1] && !funct_i[0]);
assign c3 = 0;
assign c2 = (!ALUOp_i[2] && ALUOp_i[1] && !ALUOp_i[0] && funct_i[5] && funct_i[1]) || (ALUOp_i[2] && !ALUOp_i[1] && !ALUOp_i[0]) || (!ALUOp_i[2] && !ALUOp_i[1] && ALUOp_i[0]);
assign c1 = (!funct_i[2] && funct_i[5]) || (!ALUOp_i[2] && ALUOp_i[1] && ALUOp_i[0]) || (ALUOp_i[2] && !ALUOp_i[1] && !ALUOp_i[0]) || 
            (!ALUOp_i[2] && !ALUOp_i[1] && ALUOp_i[0]) || (!ALUOp_i[2] && !ALUOp_i[1] && !ALUOp_i[0]) || (ALUOp_i[2] && ALUOp_i[1] && ALUOp_i[0]);
assign c0 = ((!ALUOp_i[2] && ALUOp_i[1] && !ALUOp_i[0] && funct_i[0] && funct_i[5]) || (!ALUOp_i[2] && ALUOp_i[1] && !ALUOp_i[0] && funct_i[3] && funct_i[5]) || (ALUOp_i[2] && !ALUOp_i[1] && !ALUOp_i[0]));

always @(*)begin
    ALUCtrl_o = {c3,c2,c1,c0};
    RegWrite_o = RegWrite;
    jr_o = jr;
end  
endmodule     





                    
                    