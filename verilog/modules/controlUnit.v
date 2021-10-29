// file: controlUnit.v
// author: @youssefagiza

`timescale 1ns/1ns

module controlUnit(
input [6:0] inst,
output reg branch,
output reg MemRead,
output reg MemtoReg,
output reg [1:0] ALUOp,
output reg MemWrite,
output reg ALUSrc,
output reg RegWrite
);

always @(*)
  begin
    case(inst)
    7'b0110011: //R-Format
    begin
      branch = 1'b0;
      MemRead = 1'b0;
      MemtoReg = 1'b0;
      ALUOp = 2'b10;
      MemWrite = 1'b0;
      ALUSrc = 1'b0;
      RegWrite = 1'b1;
    end
    7'b0000011://LW
    begin
      branch = 1'b0;
      MemRead = 1'b1;
      MemtoReg = 1'b1;
      ALUOp = 2'b00;
      MemWrite = 1'b0;
      ALUSrc = 1'b1;
      RegWrite = 1'b1;
    end
    7'b0100011: //SW
    begin
      branch = 1'b0;
      MemRead = 1'b0;
      ALUOp = 2'b00;
      MemWrite = 1'b1;
      ALUSrc = 1'b1;
      RegWrite = 1'b0;
      MemtoReg=1'b0;
    end
    7'b1100011: //BEQ
    begin
      branch = 1'b1;
      MemRead = 1'b0;
      ALUOp = 2'b01;
      MemWrite = 1'b0;
      ALUSrc = 1'b0;
      RegWrite = 1'b0;
     MemtoReg=1'b0;

    end
    default: 
    begin 
     branch = 1'b0;
         MemRead = 1'b0;
         ALUOp = 2'b00;
         MemWrite = 1'b0;
         ALUSrc = 1'b0;
         RegWrite = 1'b0;
        MemtoReg=1'b0;
    end
    endcase
  end
endmodule