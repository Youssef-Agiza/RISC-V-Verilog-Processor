`include "defines.v"

module BranchControlUnit(
			input clk,
			input  wire zf,
			input wire cf,
			input wire sf,
			input wire vf,
			input [`IR_funct3] funct3,
			input branchSignal,
			output PCSrc);


always @(*) 
	begin
		result=1'b0;
		case (funct3)
			`BR_BEQ: if (zf) result=1'b1;
			`BR_BNE: if (!zf) result=1'b1;
			`BR_BLT: if (sf!=vf) result=1'b1;
			`BR_BGE: if (sf==vf) result=1'b1;
			`BR_BLTU: if (!cf) result=1'b1;
			`BR_BGEU: if (cf) result=1'b1;
			default: result=1'b0;
			endcase
	end
	
assign PCSrc = result & branchSignal;
endmodule