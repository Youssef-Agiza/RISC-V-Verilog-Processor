module FullAdder(A,B,Cin,Sum,Cout);
input A,B,Cin;
output Sum,Cout;

assign {Cout,Sum}=A+B+Cin;

endmodule