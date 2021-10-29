module ALUControlUnit(input [1:0] ALUOp, input [14:12] Inst, input Inst1, output reg [3:0] ALUSelection );

always@(*)
case(ALUOp)
  2'b00:  ALUSelection =4'b0010 ;
  2'b01:  ALUSelection =4'b0110 ;
  2'b10: 
  begin 
  if (Inst == 3'b110)
  ALUSelection =4'b0001 ;
  else if (Inst == 3'b111)
  ALUSelection =4'b0000 ;
  else if (Inst == 3'b000)
  begin
    if (Inst1==1'b0)
    ALUSelection =4'b0010 ;
    else if (Inst1==1'b1)
    ALUSelection =4'b0110 ;
  end
  end
  default: ALUSelection =4'b0000; 



endcase
endmodule