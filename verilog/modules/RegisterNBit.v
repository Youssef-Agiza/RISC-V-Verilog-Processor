module RegisterNBit
#(parameter N =32)
(
input clk,
input rst,
input [N-1:0]D,
input load, 
output wire[N-1:0]Q
);

wire [N-1:0]Y;
genvar i;
for(i=0; i<N; i=i+1) begin:f
    MUX2x1 mux2x1(.A(Q[i]),.B(D[i]),.S(load),.C(Y[i]));
    DFlipFlop dff(.clk(clk),.rst(rst),.D(Y[i]),.Q(Q[i]));
end


endmodule
