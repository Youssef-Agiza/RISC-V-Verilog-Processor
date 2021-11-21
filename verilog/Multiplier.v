`include "defines.v"

module Multiplier(
    input [31:0] a,
    input [31:0] b,
    input [2:0] type,
    output reg signed [31:0] r
    );
    
    wire signed [63:0]r_mulr=$signed(a)*$signed(b);
    wire [63:0] r_mulhu=a*b;
    wire signed [63:0] r_mulhsu=$signed(a)*b;
    
    wire signed [31:0] r_div=$signed(a)/$signed(b);
    wire [31:0] r_divu=a/b;
    
    wire signed [31:0] rem= $signed(a)%$signed(b);
    wire [31:0] remu=a%b;

    always @(*)begin
        case(type)
        `F3_MUL   :r=r_mulr[31:0];
        `F3_MULH  :r=r_mulr[63:32];
        `F3_MULHSU:r=r_mulhsu;
        `F3_MULHU :r=r_mulhu;
        `F3_DIV   :r=r_div;
        `F3_DIVU  :r=r_divu;
        `F3_REM   :r=rem;
        `F3_REMU  :r=remu;
        endcase
    end
    
endmodule
