// file: MUXNBit.v
// author: @youssefagiza

`timescale 1ns/1ns

module MUXNBit #(parameter N=32) (A,B,S,C);
input [N-1:0]A;
input [N-1:0]B;
input S;
output [N-1:0]C;

genvar i;

for(i=0;i<N;i=i+1)begin:f 
  MUX2x1 mux2x1(.A(A[i]), .B(B[i]), .S(S),.C(C[i]));
end




endmodule