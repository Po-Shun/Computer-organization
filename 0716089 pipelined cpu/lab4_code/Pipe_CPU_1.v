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
wire[32-1:0] IF_add_4 = 4;
wire[32-1:0] IF_pc_in;
wire[32-1:0] IF_pc_out;
wire[32-1:0] IF_instruction;
wire[32-1:0] IF_pc_plus_4;
wire[64-1:0] IF_ID_pipreg;
/**** ID stage ****/

//control signal
wire[32-1:0] ID_instruction;
wire[32-1:0] ID_pc;
wire[32-1:0] ID_read_data1;
wire[32-1:0] ID_read_data2;
wire ID_RegWrite;
wire[3-1:0] ID_ALU_op;
wire ID_ALUSrc;
wire ID_RegDst;
wire ID_Branch;
wire ID_MemRead;
wire ID_MemtoReg;
wire ID_MemWrite;
wire[32-1:0] ID_extend;
wire[148-1:0] ID_EX_pipreg;
assign ID_instruction = IF_ID_pipreg[32-1:0];
assign ID_pc = IF_ID_pipreg[64-1:32];

/**** EX stage ****/

//control signal
wire[2-1:0] EX_WB;
wire[3-1:0] EX_M;
wire EX_RegDst;
wire [3-1:0] EX_ALUOp;
wire EX_ALUSrc;
wire[32-1:0] EX_pc;
wire[32-1:0] EX_data1;
wire[32-1:0] EX_data2;
wire[32-1:0] EX_extend;
wire[5-1:0] EX_instruction20_16;
wire[5-1:0] EX_instruction15_11;
wire[32-1:0] EX_shift;
wire[32-1:0] EX_alu2_i;
wire[5-1:0] EX_write_reg;
wire[32-1:0] EX_result;
wire EX_zero;
wire[4-1:0] EX_ALUControl;
wire[32-1:0] EX_beq_addr;
wire[107-1:0] EX_MEM_pipreg;
assign EX_instruction15_11 = ID_EX_pipreg[5-1:0];
assign EX_instruction20_16 = ID_EX_pipreg[10-1:5];
assign EX_extend = ID_EX_pipreg[42-1:10];
assign EX_data2 = ID_EX_pipreg[74-1:42];
assign EX_data1 = ID_EX_pipreg[106-1:74];
assign EX_pc = ID_EX_pipreg[138-1:106];
assign EX_ALUSrc = ID_EX_pipreg[139-1:138];
assign EX_ALUOp = ID_EX_pipreg[142-1:139];
assign EX_RegDst = ID_EX_pipreg[143-1:142];
assign EX_M = ID_EX_pipreg[146-1:143];
assign EX_WB = ID_EX_pipreg[148-1:146];
/**** MEM stage ****/

//control signal
wire[2-1:0] MEM_WB;
wire MEM_Branch;
wire MEM_MemWrite;
wire MEM_MemRead;
wire MEM_zero;
wire[32-1:0] MEM_beq_addr;
wire[32-1:0] MEM_result;
wire[32-1:0] MEM_data2;
wire[5-1:0] MEM_write_reg;
wire[32-1:0] MEM_data;
wire[71-1:0] MEM_WB_pipreg;
assign MEM_write_reg = EX_MEM_pipreg[5-1:0];
assign MEM_data2 = EX_MEM_pipreg[37-1:5];
assign MEM_zero = EX_MEM_pipreg[38-1:37];
assign MEM_result = EX_MEM_pipreg[70-1:38];
assign MEM_beq_addr = EX_MEM_pipreg[102-1:70];
assign MEM_MemWrite = EX_MEM_pipreg[103-1:102];
assign MEM_MemRead = EX_MEM_pipreg[104-1:103];
assign MEM_Branch = EX_MEM_pipreg[105-1:104];
assign MEM_WB = EX_MEM_pipreg[107-1:105];


/**** WB stage ****/

//control signal
wire WB_RegWrite;
wire WB_MemtoReg;
wire[32-1:0] WB_data;
wire[32-1:0] WB_data2;
wire[5-1:0] WB_write_reg;
wire[32-1:0] WB_write_data;
assign WB_write_reg = MEM_WB_pipreg[5-1:0];
assign WB_data2 = MEM_WB_pipreg[37-1:5];
assign WB_data = MEM_WB_pipreg[69-1:37];
assign WB_MemtoReg = MEM_WB_pipreg[70-1:69];
assign WB_RegWrite = MEM_WB_pipreg[71-1:70];



/****************************************
Instantiate modules
****************************************/
//Instantiate the components in IF stage
//always @(*) begin
//    $display("instruction: %b  %b  %b",ID_instruction,EX_data1,EX_alu2_i);
//end
MUX_2to1 #(.size(32)) Mux0(
    .data0_i(IF_pc_plus_4),
        .data1_i(MEM_beq_addr),
        .select_i(MEM_Branch && MEM_zero),
        .data_o(IF_pc_in)
);

ProgramCounter PC(
    .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(IF_pc_in) ,   
	    .pc_out_o(IF_pc_out) 
);

Instruction_Memory IM(
    .addr_i(IF_pc_out),  
	    .instr_o(IF_instruction)
);
			
Adder Add_pc(
    .src1_i(IF_add_4),     
	    .src2_i(IF_pc_out),     
	    .sum_o(IF_pc_plus_4)
);

		
Pipe_Reg #(.size(64)) IFID(       //N is the total length of input/output
    .clk_i(clk_i),
    .rst_i(rst_i),
    .data_i({IF_pc_plus_4,IF_instruction}),
    .data_o(IF_ID_pipreg)
);


//Instantiate the components in ID stage
Reg_File RF(
    .clk_i(clk_i),      
	    .rst_i(rst_i) ,     
        .RSaddr_i(ID_instruction[25:21]) ,  
        .RTaddr_i(ID_instruction[20:16]) ,  
        .RDaddr_i(WB_write_reg) ,  
        .RDdata_i(WB_write_data)  , 
        .RegWrite_i (WB_RegWrite),
        .RSdata_o(ID_read_data1) ,  
        .RTdata_o(ID_read_data2)
);

Decoder Control(
    .instr_op_i(ID_instruction[31:26]),
	.RegWrite_o(ID_RegWrite),
	.ALU_op_o(ID_ALU_op),
	.ALUSrc_o(ID_ALUSrc),
	.RegDst_o(ID_RegDst),
	.Branch_o(ID_Branch),
    .MemRead_o(ID_MemRead),
    .MemtoReg_o(ID_MemtoReg),
    .MemWrite_o(ID_MemWrite)
);

Sign_Extend Sign_Extend(
    .data_i(ID_instruction[15:0]),
        .data_o(ID_extend)
);	

Pipe_Reg #(.size(148)) IDEX(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .data_i({ID_RegWrite,ID_MemtoReg,ID_Branch,ID_MemRead,ID_MemWrite,ID_RegDst,ID_ALU_op,ID_ALUSrc,ID_pc,ID_read_data1,ID_read_data2,ID_extend,ID_instruction[20:16],ID_instruction[15:11]}),
    .data_o(ID_EX_pipreg)
);


//Instantiate the components in EX stage	   
Shift_Left_Two_32 Shifter(
    .data_i(EX_extend),
        .data_o(EX_shift)
);

ALU ALU(
    .src1_i(EX_data1),
	    .src2_i(EX_alu2_i),
	    .ctrl_i(EX_ALUControl),
	    .result_o(EX_result),
		.zero_o(EX_zero)
);
		
ALU_Ctrl ALU_Control(
    .funct_i(EX_extend[5:0]),   
        .ALUOp_i(EX_ALUOp),   
        .ALUCtrl_o(EX_ALUControl)
);

MUX_2to1 #(.size(32)) Mux1(
    .data0_i(EX_data2),
        .data1_i(EX_extend),
        .select_i(EX_ALUSrc),
        .data_o(EX_alu2_i)
);
		
MUX_2to1 #(.size(5)) Mux2(
    .data0_i(EX_instruction20_16),
        .data1_i(EX_instruction15_11),
        .select_i(EX_RegDst),
        .data_o(EX_write_reg)
);

Adder Add_pc_branch(
   .src1_i(EX_pc),     
	    .src2_i(EX_shift),     
	    .sum_o(EX_beq_addr)
);

  
Pipe_Reg #(.size(107)) EXMEM(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .data_i({EX_WB,EX_M,EX_beq_addr,EX_result,EX_zero,EX_data2,EX_write_reg}),
    .data_o(EX_MEM_pipreg)
);


//Instantiate the components in MEM stage
Data_Memory DM(
    .clk_i(clk_i),
	.addr_i(MEM_result),
	.data_i(MEM_data2),
	.MemRead_i(MEM_MemRead),
	.MemWrite_i(MEM_MemWrite),
	.data_o(MEM_data)
);

Pipe_Reg #(.size(71)) MEMWB(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .data_i({MEM_WB,MEM_data,MEM_result,MEM_write_reg}),
    .data_o(MEM_WB_pipreg)
);


//Instantiate the components in WB stage
MUX_2to1 #(.size(32)) Mux3(
    .data0_i(WB_data2),
        .data1_i(WB_data),
        .select_i(WB_MemtoReg),
        .data_o(WB_write_data)
);

/****************************************
signal assignment
****************************************/

endmodule

