module MUX4x1 #(parameter N=32) ( input [N-1:0]a,
				input [N-1:0]b,
				input [N-1:0]c,
				input [N-1:0]d,
				input [1:0] s,
				output [N-1:0]out);
				
	assign out = s[1] ? (s[0] ? d : c) : (s[0] ? b : a);
	
endmodule
		