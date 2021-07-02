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
module Simple_Single_CPU(
        clk_i,
		rst_i
		);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles
wire [32-1:0] plus4;
wire[32-1:0] pc_i,pc_o,pc_4;
wire[5-1:0] reg31;
wire [32-1:0] ins,write_data,read_data_1,read_data_2,ins_ex,temp_ALUSrc,temp_alu,temp_data,ins_shi,temp0,temp_beq,temp_jump,temp_jump2,temp_memtoreg;
wire RegDst,jal,zero,MemRead,MemWrite,branch,MemtoReg,jump,jr,jalwrite,ALUSrc,RegWrite;
wire [5-1:0] temp_regdst,write_reg;
wire [4-1:0] ALUCtrl;
wire [3-1:0] ALUOp;
assign reg31 = 31;
assign plus4 = 4;
always @(*) begin
    $display("%b,%b,%b,%d,%d,%d",ins[31:26],ins,ALUCtrl,branch,jump,jr);
end
//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(pc_i) ,   
	    .pc_out_o(pc_o) 
	    );
	
Adder Adder1(
        .src1_i(pc_o),     
	    .src2_i(plus4),     
	    .sum_o(pc_4)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(pc_o),  
	    .instr_o(ins)    
	    );

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(ins[20:16]),
        .data1_i(ins[15:11]),
        .select_i(RegDst),
        .data_o(temp_regdst)
        );

MUX_2to1 #(.size(5)) jal0(
        .data0_i(temp_regdst),
        .data1_i(reg31),
        .select_i(jal),
        .data_o(write_reg)
        );	
		
Reg_File Registers(
        .clk_i(clk_i),      
	    .rst_i(rst_i) ,     
        .RSaddr_i(ins[25:21]) ,  
        .RTaddr_i(ins[20:16]) ,  
        .RDaddr_i(write_reg) ,  
        .RDdata_i(write_data)  , 
        .RegWrite_i (RegWrite),
        .RSdata_o(read_data_1) ,  
        .RTdata_o(read_data_2)   
        );
	
Decoder Decoder(
    .instr_op_i(ins[31:26]),
	.ALU_op_o(ALUOp),
	.ALUSrc_o(ALUSrc),
	.RegDst_o(RegDst),
	.Branch_o(branch),
	.MemtoReg_o(MemtoReg),
	.MemRead_o(MemRead),
	.MemWrite_o(MemWrite),
	.Jump_o(jump),
	.Jal_o(jal),
	.JalWrite_o(jalwrite)
	);

ALU_Ctrl AC(
          .funct_i(ins[5:0]),
          .ALUOp_i(ALUOp),
          .ALUCtrl_o(ALUCtrl),
          .RegWrite_o(RegWrite),
          .jr_o(jr)
          );
	
Sign_Extend SE(
        .data_i(ins[15:0]),
        .data_o(ins_ex)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(read_data_2),
        .data1_i(ins_ex),
        .select_i(ALUSrc),
        .data_o(temp_ALUSrc)
        );	
		
ALU ALU(
        .src1_i(read_data_1),
	    .src2_i(temp_ALUSrc),
	    .ctrl_i(ALUCtrl),
	    .result_o(temp_alu),
		.zero_o(zero)
	    );
	
Data_Memory Data_Memory(
	.clk_i(clk_i),
	.addr_i(temp_alu),
	.data_i(read_data_2),
	.MemRead_i(MemRead),
	.MemWrite_i(MemWrite),
	.data_o(temp_data)
	);

MUX_2to1 #(.size(32)) MemtoReg0(
        .data0_i(temp_alu),
        .data1_i(temp_data),
        .select_i(MemtoReg),
        .data_o(temp_memtoreg)
        );

MUX_2to1 #(.size(32)) jalwrite0(
        .data0_i(temp_memtoreg),
        .data1_i(pc_4),
        .select_i(jalwrite),
        .data_o(write_data)
        );
	
Adder Adder2(
        .src1_i(pc_4),     
	    .src2_i(ins_shi),     
	    .sum_o(temp0)      
	    );
		
Shift_Left_Two_32 Shifter(
        .data_i(ins_ex),
        .data_o(ins_shi)
        ); 		
		
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(pc_4),
        .data1_i(temp0),
        .select_i(branch && zero),
        .data_o(temp_beq)
        );



MUX_2to1 #(.size(32)) jump_beq(
        .data0_i(temp_beq),
        .data1_i({pc_4[31:28],ins[25:0],2'b00}),
        .select_i(jump),
        .data_o(temp_jump2)
        );

MUX_2to1 #(.size(32)) jump_jr(
        .data0_i(temp_jump2),
        .data1_i(read_data_1),
        .select_i(jr),
        .data_o(pc_i)
        );
endmodule
		  


