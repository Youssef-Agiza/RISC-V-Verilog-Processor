module Test13BitOut( 
        input [31:0] PCOut,
        input [31:0] BranchTargetAddr,
        input [31:0] PCIn,
        input [31:0] rs1Read,
        input [31:0] rs2Read,
        input [31:0] regFileIn,
        input [31:0] imm,
        input [31:0] shiftLeftOut,
        input [31:0] ALU2ndSrc,
        input [31:0] ALUOut,
        input [31:0] memoryOut,
        input [3:0] ssdSel,
        output reg [12:0] out);



always @(*)begin
    case(ssdSel)  
        4'b0000:out=PCOut; 
        4'b0001:out=(PCOut + 3'b100);//PC +4
        4'b0010:out=BranchTargetAddr; 
        4'b0011:out=PCIn;
        4'b0100:out=rs1Read;
        4'b0101:out=rs2Read;
        4'b0110:out=regFileIn;
        4'b0111:out=imm;
        4'b1000:out=shiftLeftOut;
        4'b1001:out=ALU2ndSrc;
        4'b1010:out=ALUOut;
        4'b1011:out=memoryOut;
        default: out=13'b0;
    endcase

end
    
endmodule