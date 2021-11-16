module ShiftLeftNBit #(parameter N=32)(input [N-1:0] A, output [N-1:0] B );

assign B = {A[N-2:0],1'b0};

endmodule