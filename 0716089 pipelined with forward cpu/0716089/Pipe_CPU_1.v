`timescale 1ns / 1ps
//Subject:     CO project 4 - Pipe CPU 1
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_CPU_1(
    clk_i,
    rst_i
    );
    
/****************************************
I/O ports
****************************************/
input clk_i;
input rst_i;

/****************************************
Internal signal
****************************************/


/**** IF stage ****/
// after write mem_stage need to set up the signal
wire [32-1:0] IF_pc4;
wire [32-1:0] IF_pc_in;
wire [32-1:0] IF_pc_out;
wire [32-1:0] plus4 = 4;
wire [32-1:0] IF_ins;
wire [64-1:0] IF_ID_reg;


wire [32-1:0] ID_ins;
wire [32-1:0] ID_pc;
assign ID_ins = IF_ID_reg[32-1:0];
assign ID_pc = IF_ID_reg[64-1:32];
wire [32-1:0] ID_data1;
wire [32-1:0] ID_data2;
wire [32-1:0] ID_extend;
wire ID_RegWrite;
wire [3-1:0] ID_ALUOp;
wire ID_ALUSrc;
wire ID_RegDst;
wire [3-1:0] ID_Branch;
wire ID_MemRead;
wire ID_MemtoReg;
wire ID_MemWrite;
wire EX_flush;
wire ID_flush;
wire IF_ID_write;
wire IF_flush;
wire [2-1:0] ID_WB;
assign ID_WB = {ID_MemtoReg,ID_RegWrite};
wire [5-1:0] ID_M;
assign ID_M = {ID_Branch,ID_MemWrite,ID_MemRead};
wire [5-1:0] ID_E;
assign ID_E = {ID_ALUSrc,ID_RegDst,ID_ALUOp};
wire [12-1:0] ID_control;
wire[155-1:0] ID_EX_reg;
wire ID_pc_write;


wire [32-1:0] EX_pc;
wire [32-1:0] EX_data1;
wire [32-1:0] EX_data2;
wire [32-1:0] EX_extend;
wire [5-1:0] EX_rs;
wire [5-1:0] EX_rt;
wire [5-1:0] EX_rd;
wire EX_RegDst;
wire EX_ALUSrc;
wire [3-1:0] EX_ALUOp;
wire [5-1:0] EX_M;
wire [2-1:0] EX_WB;
wire [32-1:0] EX_shift;
wire [2-1:0] EX_WB_select;
wire [5-1:0] EX_M_select;
wire [32-1:0] EX_beq_addr;
wire [2-1:0] forward_A;
wire [2-1:0] forward_B;
wire [32-1:0] EX_alu1;
wire [32-1:0] EX_alusrc0;
wire [32-1:0] EX_alu2;
wire [4-1:0] EX_ALUCtrl;
wire [32-1:0] EX_result;
wire [2-1:0] EX_zero;
wire [5-1:0] EX_write_address;
wire [110-1:0] EX_MEM_reg;
assign EX_rd = ID_EX_reg[5-1:0];
assign EX_rt = ID_EX_reg[10-1:5];
assign EX_rs = ID_EX_reg[15-1:10];
assign EX_extend = ID_EX_reg[47-1:15];
assign EX_data2 = ID_EX_reg[79-1:47];
assign EX_data1 = ID_EX_reg[111-1:79];
assign EX_pc = ID_EX_reg[143-1:111];
assign EX_ALUOp = ID_EX_reg[146-1:143];
assign EX_RegDst = ID_EX_reg[147-1:146];
assign EX_ALUSrc = ID_EX_reg[148-1:147];
assign EX_M = ID_EX_reg[153-1:148];
assign EX_WB = ID_EX_reg[155-1:153];


wire [2-1:0] MEM_WB;
wire [3-1:0] MEM_branch;
wire MEM_MemRead;
wire MEM_MemWrite;
wire [2-1:0] MEM_zero;
wire [32-1:0] MEM_result;
wire [32-1:0] MEM_mem_addr;
wire [5-1:0] MEM_write_address;
wire [32-1:0] MEM_pc;
wire [32-1:0] MEM_data;
wire [98-1:0] MEM_WB_reg;
assign MEM_write_address = EX_MEM_reg[5-1:0];
assign MEM_result = EX_MEM_reg[37-1:5];
assign MEM_mem_addr = EX_MEM_reg[69-1:37];
assign MEM_zero = EX_MEM_reg[71-1:69];
assign MEM_pc = EX_MEM_reg[103-1:71];
assign MEM_MemRead = EX_MEM_reg[104-1:103];
assign MEM_MemWrite = EX_MEM_reg[105-1:104];
assign MEM_branch = EX_MEM_reg[108-1:105];
assign MEM_WB = EX_MEM_reg[110-1:108];




wire WB_MemtoReg;
wire WB_RegWrite;
wire [32-1:0] WB_data;
wire [32-1:0] WB_result;
wire [5-1:0] WB_write_address;
wire [32-1:0] WB_write_data;
assign WB_write_address = MEM_WB_reg[5-1:0];
assign WB_result = MEM_WB_reg[37-1:5];
assign WB_data = MEM_WB_reg[69-1:37];
assign WB_RegWrite = MEM_WB_reg[70-1:69];
assign WB_MemtoReg = MEM_WB_reg[71-1:70];

MUX_2to1 #(.size(32)) M0(
    .data0_i(IF_pc4),
    .data1_i(MEM_pc),
    .select_i(MEM_PCSrc),
    .data_o(IF_pc_in)
);

ProgramCounter pc(
    .clk_i(clk_i),
	.rst_i(rst_i),
	.pc_write(ID_pc_write),
	.pc_in_i(IF_pc_in),
	.pc_out_o(IF_pc_out)
);

Adder IFADD(
    .src1_i(IF_pc_out),
	.src2_i(plus4),
	.sum_o(IF_pc4)
);

Instruction_Memory IM(
    .addr_i(IF_pc_out),
    .instr_o(IF_ins)
);

Pipe_Reg_Flush #(.size(64)) IFID(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .flush(IF_flush),
    .regwrite(IF_ID_write),
    .data_i({IF_pc4,IF_ins}),
    .data_o(IF_ID_reg)
    );




/**** ID stage ****/




Reg_File RF(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .RSaddr_i(ID_ins[25:21]),
    .RTaddr_i(ID_ins[20:16]),
    .RDaddr_i(WB_write_address),
    .RDdata_i(WB_write_data),
    .RegWrite_i(WB_RegWrite),
    .RSdata_o(ID_data1),
    .RTdata_o(ID_data2)
);

Sign_Extend SE0(
    .data_i(ID_ins[15:0]),
    .data_o(ID_extend)
);
always @(*) begin
    $display("%b",ID_ins);
    $display("%b",MEM_write_address);
    $display("%b",ID_control);
    $display("%b %b",forward_A,forward_B);
end
Decoder Decoder(
    .instr_op_i(ID_ins[31:26]),
	.RegWrite_o(ID_RegWrite),
	.ALU_op_o(ID_ALUOp),
	.ALUSrc_o(ID_ALUSrc),
	.RegDst_o(ID_RegDst),
	.Branch_o(ID_Branch),
    .MemRead_o(ID_MemRead),
    .MemtoReg_o(ID_MemtoReg),
    .MemWrite_o(ID_MemWrite)
);


hazard_dection_unit HD(
   .ID_EX_rt(EX_rt),
   .IF_ID_rs(ID_ins[25:21]),
   .IF_ID_rt(ID_ins[20:16]),
   .ID_EX_MemRead(EX_M[0]),
   .EX_MEM_branch(MEM_PCSrc),
   .EX_flush(EX_flush),
   .ID_flush(ID_flush),
   .pc_write(ID_pc_write),
   .IF_ID_write(IF_ID_write),
   .IF_flush(IF_flush)
);

MUX_2to1 #(.size(12)) M1(
    .data0_i({ID_WB,ID_M,ID_E}),
    .data1_i(12'b0),
    .select_i(ID_flush),
    .data_o(ID_control)
);

Pipe_Reg #(.size(155)) ID_EX(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .data_i({ID_control,ID_pc,ID_data1,ID_data2,ID_extend,ID_ins[25:21],ID_ins[20:16],ID_ins[15:11]}),
    .data_o(ID_EX_reg)
);


/**** EX stage ****/


Shift_Left_Two_32 sh(
    .data_i(EX_extend),
    .data_o(EX_shift)
);

MUX_2to1 #(.size(2)) EX_WB_FLUSH(
    .data0_i(EX_WB),
    .data1_i(2'b0),
    .select_i(EX_flush),
    .data_o(EX_WB_select)
);

MUX_2to1 #(.size(5)) EX_MFLUSH(
    .data0_i(EX_M),
    .data1_i(5'b0),
    .select_i(EX_flush),
    .data_o(EX_M_select)
);

Adder EXADD(
    .src1_i(EX_shift),
	.src2_i(EX_pc),
	.sum_o(EX_beq_addr)
);

// 00 original 10 EX 01 WB
MUX_3to1 #(.size(32)) forA(
    .data0_i(EX_data1),
    .data1_i(MEM_mem_addr),
    .data2_i(WB_write_data),
    .select_i(forward_A),
    .data_o(EX_alu1)
);

MUX_3to1 #(.size(32)) forB(
    .data0_i(EX_data2),
    .data1_i(MEM_mem_addr),
    .data2_i(WB_write_data),
    .select_i(forward_B),
    .data_o(EX_alusrc0)
);

MUX_2to1 #(.size(32)) ALUSRC(
    .data0_i(EX_alusrc0),
    .data1_i(EX_extend),
    .select_i(EX_ALUSrc),
    .data_o(EX_alu2)
);

ALU_Ctrl CLUCTRL(
    .funct_i(EX_extend[5:0]),
    .ALUOp_i(EX_ALUOp),
    .ALUCtrl_o(EX_ALUCtrl)
);

ALU EXALU(
    .src1_i(EX_alu1),
	.src2_i(EX_alu2),
	.ctrl_i(EX_ALUCtrl),
	.result_o(EX_result),
	.zero_o(EX_zero)
);


MUX_2to1 #(.size(5)) REGDST(
    .data0_i(EX_rt),
    .data1_i(EX_rd),
    .select_i(EX_RegDst),
    .data_o(EX_write_address)
);

forward_unit funit(
    .ID_EX_rs(EX_rs),
    .ID_EX_rt(EX_rt),
    .EX_MEM_rd(MEM_write_address),
    .MEM_WB_rd(WB_write_address),
    .EX_MEM_RegWrite(MEM_WB[0]),
    .MEM_WB_RegWrite(WB_RegWrite),
    .forward_A(forward_A),
    .forward_B(forward_B)
);

Pipe_Reg #(.size(110)) EXMEM(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .data_i({EX_WB_select,EX_M_select,EX_beq_addr,EX_zero,EX_result,EX_alusrc0,EX_write_address}),
    .data_o(EX_MEM_reg)
    );



/**** MEM stage ****/


branch_dection_unit BDU(
    .branch(MEM_branch),
    .zero(MEM_zero),
    .PCSrc_o(MEM_PCSrc)
);

Data_Memory DM(
    .clk_i(clk_i),
    .addr_i(MEM_mem_addr),
    .data_i(MEM_result),
    .MemRead_i(MEM_MemRead),
    .MemWrite_i(MEM_MemWrite),
    .data_o(MEM_data)
);

Pipe_Reg #(.size(98)) MEMWB(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .data_i({MEM_WB,MEM_data,MEM_mem_addr,MEM_write_address}),
    .data_o(MEM_WB_reg)
    );


/**** WB stage ****/


MUX_2to1 #(.size(32)) MEMTOREG(
    .data0_i(WB_result),
    .data1_i(WB_data),
    .select_i(WB_MemtoReg),
    .data_o(WB_write_data)
);



endmodule

