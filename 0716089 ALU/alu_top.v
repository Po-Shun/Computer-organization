`timescale 1ns/1ps
// student ID:0716089
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:58:01 10/10/2013
// Design Name: 
// Module Name:    alu_top 
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

module alu_top(
               src1,       //1 bit source 1 (input)
               src2,       //1 bit source 2 (input)
               less,       //1 bit less     (input)
               A_invert,   //1 bit A_invert (input)
               B_invert,   //1 bit B_invert (input)
               cin,        //1 bit carry in (input)
               operation,  //operation      (input)
               result,     //1 bit result   (output)
               cout,       //1 bit carry out(output)
               );

input         src1;
input         src2;
input         less;
input         A_invert;
input         B_invert;
input         cin;
input [2-1:0] operation;

reg          a_out;
reg          b_out;
//reg used for full adder (a_xor_b_out_inadd)
reg          a_xor_b_out_inadd;
reg [1:0]    temp;          
reg           result;
reg           cout;

output        result;
output        cout;


always@( * )
begin
    // the case below is used for a and b multiplexer
    case ({A_invert,B_invert})
        // a positive and b positive 
        2'b00: 
            begin
                a_out = src1;
                b_out = src2;
            end
        // a positive and b negative
        2'b01: 
            begin
                a_out = src1;
                b_out = !src2;
            end
        // a negative and b positive 
        2'b10: 
            begin
                a_out = !src1;
                b_out = src2;
            end
        // both a and b are negative 
        2'b11:
            begin
                a_out = !src1;
                b_out = !src2;
            end
    endcase

    // the case below is used for operator multiplexer 
    case (operation)
        // and 00
        2'b00:begin
            result = a_out & b_out;
            cout = 1'b0;
        end
        // or 01
        2'b01:begin
            result = a_out | b_out;
            cout = 1'b0;
        end
        // addition 10
        2'b10:
            begin
            //   temp = a_out + b_out;
            //   cout = temp[1];
            //   result = temp[0];
               a_xor_b_out_inadd = a_out ^ b_out;
               result =   a_xor_b_out_inadd ^ cin;
               temp[0] = a_xor_b_out_inadd & cin;
               temp[1] = a_out & b_out;
               cout = |temp;
            end
        // slt 11
        2'b11:begin
            result = less;
            cout = 0;
        end

    endcase
end

endmodule