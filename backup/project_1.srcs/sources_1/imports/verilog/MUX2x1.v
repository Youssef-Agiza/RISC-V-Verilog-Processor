

module MUX2x1(input A, input B,input S, output C);

assign C=(S)?B:A;

endmodule