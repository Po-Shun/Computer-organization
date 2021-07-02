//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
`timescale 1ns/1ps
module hazard_dection_unit(
   ID_EX_rt,
   IF_ID_rs,
   IF_ID_rt,
   ID_EX_MemRead,
   EX_MEM_branch,
   EX_flush,
   ID_flush,
   pc_write,
   IF_ID_write,
   IF_flush
);
input [5-1:0] ID_EX_rt;
input [5-1:0] IF_ID_rs;
input [5-1:0] IF_ID_rt;
input ID_EX_MemRead;
input EX_MEM_branch;
output EX_flush;
output ID_flush;
output pc_write;
output IF_ID_write;
output IF_flush;

reg EX_flush;
reg ID_flush;
reg pc_write;
reg IF_ID_write;
reg IF_flush;

always @(*) begin
    if(EX_MEM_branch) begin
        ID_flush = 1;
        pc_write = 1;
        IF_ID_write = 1;
        IF_flush = 1;
        EX_flush = 1;
    end
    else if (ID_EX_MemRead && ((ID_EX_rt == IF_ID_rs) || (ID_EX_rt == IF_ID_rt))) begin
        ID_flush = 1;
        pc_write = 0;
        IF_ID_write = 0;
        IF_flush = 0;
        EX_flush = 0;
    end
    else begin
        ID_flush = 0;
        pc_write = 1;
        IF_ID_write = 1;
        IF_flush = 0;
        EX_flush = 0;
    end
end


endmodule