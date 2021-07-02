`timescale 1ns / 1ps

module Full_Adder(
    In_A, In_B, Carry_in, Sum, Carry_out
    );
    input In_A, In_B, Carry_in;
    output Sum, Carry_out;
    wire temp[0:2];
	// implement full adder circuit, your code starts from here.
	// use half adder in this module, fulfill I/O ports connection.
    Half_Adder HAD (.In_A(In_A),.In_B(In_B),.Sum(temp[0]),.Carry_out(temp[1]));
    Half_Adder HAD1 (.In_A(temp[0]),.In_B(Carry_in),.Sum(Sum),.Carry_out(temp[2]));
    or(Carry_out,temp[2],temp[1]);
    
    
endmodule
