`include "defines.v"

module prv32_ALU(
	input   wire [31:0] a, b,
	input   wire [4:0]  shamt,
	output  reg  [31:0] r,
	output  wire        cf, zf, vf, sf,
	input   wire [4:0]  alufn
);

    wire [31:0] add, sub, op_b;
    wire cfa, cfs;
    
    assign op_b = (~b);
    
    assign {cf, add} = alufn[0] ? (a + op_b + 1'b1) : (a + b);
    
   
    
    
    assign zf = (add == 0);
    assign sf = add[31];
    assign vf = (a[31] ^ (op_b[31]) ^ add[31] ^ cf);
    
    wire signed[31:0] sh;
    wire signed [31:0]mul;
    shifter shifter0(.a(a), .shamt(shamt), .type(alufn[1:0]),  .r(sh));
    Multiplier multiplier0(.a(a),.b(b),.type(alufn[2:0]),.r(mul));
    /*
    module shifter (input [31:0] a, input [4:0] shamt, input [1:0] type, output reg [31:0] r);

    */
    always @ * begin
        r = 0;
        (* parallel_case *)
        case (alufn)
            // arithmetic
            `ALU_ADD : r = add;
            `ALU_SUB : r = add;
            `ALU_PASS : r = b;
            // logic
            `ALU_OR:  r = a | b;
            `ALU_AND:  r = a & b;
            `ALU_XOR:  r = a ^ b;
            // shift
            `ALU_SRL:  r=sh;
            `ALU_SRA:  r=sh;
            `ALU_SLL:  r=sh;
            // slt & sltu
            `ALU_SLT:  r = {31'b0,(sf != vf)}; 
            `ALU_SLTU:  r = {31'b0,(~cf)};     
            
//            mul/div
            `ALU_MUL: r=mul;   
            `ALU_MULH: r=mul;
            `ALU_MULHSU: r=mul;
            `ALU_MULHU: r=mul;
            `ALU_DIV : r=mul;  
            `ALU_DIVU: r=mul;  
            `ALU_REM : r=mul;  
            `ALU_REMU: r=mul;  
        endcase
    end
endmodule