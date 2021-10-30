module MUX4x1 ( input [31:0]a,
				input [31:0]b,
				input [31:0]c,
				input [31:0]d,
				input s0,
				input s1, 
				output [31:0]out);
				
	assign out = s1 ? (s0 ? d : c) : (s0 ? b : a);
	
endmodule
		