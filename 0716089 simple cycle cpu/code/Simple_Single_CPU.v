// 0716089
//Subject:     CO project 2 - Simple Single CPU
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
module Simple_Single_CPU(
        clk_i,
		rst_i
		);
		
//I/O port
input         clk_i;
input         rst_i;
//Internal Signles
wire[32-1:0] add_4 = 4;
wire[32-1:0] pc_in;
wire[32-1:0] pc_out;
wire[32-1:0] pc_puls_4;
wire[32-1:0] instruction;
wire[5-1:0] write_reg1;
wire[32-1:0] read_data1;
wire[32-1:0] read_data2;
wire RegWrite;
wire[3-1:0] ALUOp;
wire ALUSrc;
wire RegDst;
wire branch;
wire[4-1:0] ALU_Control;
wire[32-1:0] after_extend;
wire[32-1:0] read_data2_after_mux;
wire zero;
wire[32-1:0] result;
wire[32-1:0] after_shift;
wire[32-1:0] b_addr;
//Greate componentes
//always @(negedge clk_i) begin
//$display("alu_control = %b   instruction =  %b  ALUOp = %b",ALU_Control,instruction,ALUOp); end
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(pc_in) ,   
	    .pc_out_o(pc_out) 
	    );
	
Adder Adder1(
        .src1_i(add_4),     
	    .src2_i(pc_out),     
	    .sum_o(pc_puls_4)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(pc_out),  
	    .instr_o(instruction)    
	    );

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instruction[20:16]),
        .data1_i(instruction[15:11]),
        .select_i(RegDst),
        .data_o(write_reg1)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_i(rst_i) ,     
        .RSaddr_i(instruction[25:21]) ,  
        .RTaddr_i(instruction[20:16]) ,  
        .RDaddr_i(write_reg1) ,  
        .RDdata_i(result)  , 
        .RegWrite_i (RegWrite),
        .RSdata_o(read_data1) ,  
        .RTdata_o(read_data2)   
        );
	
Decoder Decoder(
        .instr_op_i(instruction[31:26]), 
	    .RegWrite_o(RegWrite), 
	    .ALU_op_o(ALUOp),   
	    .ALUSrc_o(ALUSrc),   
	    .RegDst_o(RegDst),   
		.Branch_o(branch)   
	    );

ALU_Ctrl AC(
        .funct_i(instruction[5:0]),   
        .ALUOp_i(ALUOp),   
        .ALUCtrl_o(ALU_Control) 
        );
	
Sign_Extend SE(
        .data_i(instruction[15:0]),
        .data_o(after_extend)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(read_data2),
        .data1_i(after_extend),
        .select_i(ALUSrc),
        .data_o(read_data2_after_mux)
        );	
		
ALU ALU(
        .src1_i(read_data1),
	    .src2_i(read_data2_after_mux),
	    .ctrl_i(ALU_Control),
	    .result_o(result),
		.zero_o(zero)
	    );
		
Adder Adder2(
        .src1_i(pc_puls_4),     
	    .src2_i(after_shift),     
	    .sum_o(b_addr)      
	    );
		
Shift_Left_Two_32 Shifter(
        .data_i(after_extend),
        .data_o(after_shift)
        ); 		
		
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(pc_puls_4),
        .data1_i(b_addr),
        .select_i(branch&&zero),
        .data_o(pc_in)
        );	

endmodule
		  


