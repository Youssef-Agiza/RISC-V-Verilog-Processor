module RCANBit  #(parameter N=32) (input wire [N-1:0] a, input wire [N-1:0] b, output [N-1:0] sum, output wire [N-1:0]  Cout);


FullAdder fa(.A(a[0]),.B(b[0]),.Cin(1'b0),.Sum(sum[0]),.Cout(Cout[0]));


genvar i;
generate
for (i=1; i<N; i = i+1 )  begin:f1

FullAdder fa1(.A(a[i]),.B(b[i]),.Cin(Cout[i-1]),.Sum(sum[i]),.Cout(Cout[i]));

end
endgenerate







endmodule


