`include "defines.v"

module Multiplier(
    input [31:0] a,
    input [31:0] b,
    input [2:0] type,
    output reg  [31:0] r
    );
    wire signed [31:0] signed_a=a;
    wire signed [31:0] signed_b=b;
    wire signed [63:0]r_mulr=$signed(a)*$signed(b);
    wire [63:0] r_mulhu=a*b;
    wire  [63:0] r_mulhsu=$signed(a)*$signed({1'b0,b});
    
    wire [31:0] r_div=$signed(a)/$signed(b);
    wire [31:0] r_divu=a/b;
    
    wire signed [31:0] rem= $signed(a)%$signed(b);
    wire [31:0] remu=(b==32'd0)?a:a%b;

    always @(*)begin
        case(type)
        `F3_MUL   :r=r_mulr[31:0];
        `F3_MULH  :r=r_mulr[63:32];
        `F3_MULHSU:r=r_mulhsu[63:32];
        `F3_MULHU :r=r_mulhu[63:32];
        `F3_DIV   :r=(signed_a==32'h80000000&&signed_b==32'hffffffff)?32'h80000000:(b==0)?-1:r_div;
        `F3_DIVU  :r=(b==32'd0)?32'hffffffff:r_divu;
        `F3_REM   :r= ($signed(a)==32'h80000000&&$signed(b)==32'hffffffff)?32'd0:(b==32'd0)?$signed(a):rem;
        `F3_REMU  :r=remu;
        endcase
    end
    
endmodule
