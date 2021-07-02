`timescale 1ns/1ps
// student ID:0716089
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    15:15:11 08/18/2013
// Design Name:
// Module Name:    alu
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module alu(
           clk,           // system clock              (input)
           rst_n,         // negative reset            (input)
           src1,          // 32 bits source 1          (input)
           src2,          // 32 bits source 2          (input)
           ALU_control,   // 4 bits ALU control input  (input)
           result,        // 32 bits result            (output)
           zero,          // 1 bit when the output is 0, zero must be set (output)
           cout,          // 1 bit carry out           (output)
           overflow       // 1 bit overflow            (output)
           );
wire [31:0]    temp_result;
input           clk;
input           rst_n;
input  [32-1:0] src1;
input  [32-1:0] src2;
input   [4-1:0] ALU_control;

output [32-1:0] result;
output          zero;
output          cout;
output          overflow;

reg [32-1:0]    result;
reg             zero;
reg             cout;
reg             overflow;
reg             src1_invert;
reg             src2_invert;
reg             cin;
wire[30:0]       top_out;
wire             temp_out;
// top_operation : is the option for alu_top module
//                 top_operation --> and 00 
//                 top_operation --> or 01 
//                 top_operation --> addition 10 
//                 top_operation --> slt 11
reg[1:0]        top_operation;

// alu_top module(src1,src2,less,a_invert,B_invert,cin,operation,result,cout)
// alu_top 0(src1[0],src2[0],0,a_invert,b_invert,cin,operation,result[0],top_out)

// the generate is used for generate all 32 bit alu 
genvar idx;
generate
    alu_top bit1_alu(src1[0],src2[0],result[31],src1_invert,src2_invert,cin,top_operation,temp_result[0],top_out[0]);
    for(idx=1;idx<31;idx=idx+1) begin
            alu_top bit_alu(src1[idx],src2[idx],1'b0,src1_invert,src2_invert,top_out[idx-1],top_operation,temp_result[idx],top_out[idx]);
    end
    alu_top bit31_alu(src1[31],src2[31],1'b0,src1_invert,src2_invert,top_out[30],top_operation,temp_result[31],temp_out);
endgenerate

// operation
// and     0000
// or      0001
// add     0010
// sub     0110
// nor     1100
// slt     0111

always@( posedge clk,ALU_control ) 
begin
	if(!rst_n) begin

	end
	else begin
        case (ALU_control)
            4'b0000: begin
                src1_invert <= 1'b0;
                src2_invert <= 1'b0;
                cin <= 1'b0;
                top_operation <= 2'b00;
                // zero detection
                result = temp_result;
                if(result==0) zero = 1'b1;
                else zero = 1'b0;
                cout = temp_out;
                overflow = 1'b0;
            end
            4'b0001: begin
                src1_invert <= 1'b0;
                src2_invert <= 1'b0;
                cin <= 1'b0;
                top_operation <= 2'b01;
                // zero dection 
                result = temp_result;
                if(result==0) zero = 1'b1;
                else zero = 1'b0;
                cout = temp_out;
                overflow = 1'b0;
            end
            4'b0010: begin
                src1_invert <= 1'b0;
                src2_invert <= 1'b0;
                cin <= 1'b0;
                top_operation <= 2'b10;
                result = temp_result;
                // zero detection
                if(result==0) zero = 1'b1;
                else zero = 1'b0;
                // overflow for pos+pos neg+neg
                if( ((~src1[31])&(~src2[31])&result[31]) ||
                    ((src1[31])&(src2[31])&~result[31]) )
                    overflow = 1'b1;
                else overflow = 1'b0;
                cout = temp_out;
            end
            4'b0110: begin
                src1_invert <= 1'b0;
                src2_invert <= 1'b1;
                cin <= 1'b1;
                top_operation <= 2'b10;
                cout = temp_out;
                result = temp_result;
                // zero detection
                if(result==0) zero = 1'b1;
                else zero = 1'b0;
                // overflow for pos+pos neg+neg
                if( ((src1[31])&(~src2[31])&(~result[31])) ||
                    ((~src1[31])&(src2[31])&result[31]) )
                    overflow = 1'b1;
                else overflow = 1'b0;
            end
            4'b1100: begin
                src1_invert <= 1'b1;
                src2_invert <= 1'b1;
                cin <= 1'b0;
                top_operation <= 2'b00;
                result = temp_result;
                // zero detection
                if(result==0) zero = 1'b1;
                else zero = 1'b0;
                cout = temp_out;
                overflow = 1'b0;
            end
            4'b0111: begin
                src1_invert <= 1'b0;
                src2_invert <= 1'b1;
                cin <= 1'b1;
                top_operation <= 2'b10;
                top_operation = 2'b11;
                result = temp_result;
                // zero detection
                if(result==0) zero = 1'b1;
                else zero = 1'b0;
                cout = temp_out;
                overflow = 1'b0;
            end
        endcase
	end
end

endmodule
