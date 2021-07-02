// 0716089
//Subject:     CO project 2 - ALU
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
module ALU(
    src1_i,
	src2_i,
	ctrl_i,
	result_o,
	zero_o
	);
     
//I/O ports
input signed [32-1:0]  src1_i;
input signed [32-1:0]  src2_i;
input  [4-1:0]   ctrl_i;

output [32-1:0]	 result_o;
output           zero_o;

//Internal signals
reg    [32-1:0]  result_o;
wire             zero_o;

//Parameter
reg [32-1:0] t_result;
reg zero;
//Main function
	// add 0010 sub 0110 and 0000 or 0001 slt 0111
always @(*) begin
	case(ctrl_i) 
		4'b0010: begin
			result_o = src1_i + src2_i;
			zero =0;
		end
		4'b0110: begin
			result_o = src1_i - src2_i;
			if(result_o == 0) zero = 1;
			else zero = 0;
		end
		4'b0000: begin
			result_o = src1_i & src2_i;
			zero =0;
		end
		4'b0001: begin
			result_o = src1_i | src2_i;
			zero =0;
		end
		4'b0111: begin
			// result_o = src1_i - src2_i;
			// if(result_o == 0) result_o = 32'b1;
			// else result_o = 32'b0;
			result_o = (src1_i<src2_i)? 32'b1 : 32'b0; 
			zero =0;
		end
        4'b1000: begin
            result_o = src1_i * src2_i;
            zero = 0;
        end
	endcase
end
assign zero_o = zero;
endmodule





                    
                    