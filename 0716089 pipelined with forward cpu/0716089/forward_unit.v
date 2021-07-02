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
module forward_unit(
    ID_EX_rs,
    ID_EX_rt,
    EX_MEM_rd,
    MEM_WB_rd,
    EX_MEM_RegWrite,
    MEM_WB_RegWrite,
    forward_A,
    forward_B,
);
input [5-1:0] ID_EX_rs;
input [5-1:0] ID_EX_rt;
input [5-1:0] EX_MEM_rd;
input [5-1:0] MEM_WB_rd;
input EX_MEM_RegWrite;
input MEM_WB_RegWrite;
output [1:0] forward_A;
output [1:0] forward_B;

reg [1:0] forward_A;
reg [1:0] forward_B;


always@(*) begin
    // EX hazard
     if(EX_MEM_RegWrite && (EX_MEM_rd != 0) && EX_MEM_rd == ID_EX_rs) forward_A = 2'b01;
     else if(MEM_WB_RegWrite && (MEM_WB_rd != 0) && !(EX_MEM_RegWrite && (EX_MEM_rd != 0) && EX_MEM_rd == ID_EX_rs) && MEM_WB_rd == ID_EX_rs) forward_A = 2'b10;
     else forward_A = 2'b00;
     
     if(EX_MEM_RegWrite && (EX_MEM_rd != 0) && EX_MEM_rd == ID_EX_rt) forward_B = 2'b01;
     else if(MEM_WB_RegWrite && (MEM_WB_rd != 0) && !(EX_MEM_RegWrite && (EX_MEM_rd != 0) && EX_MEM_rd == ID_EX_rt) && MEM_WB_rd == ID_EX_rt) forward_B = 2'b10;
     else forward_B = 2'b00;
end

endmodule