module ImmGen(input [31:0] inst, output reg [31:0] gen_out);

always@(*)
begin
if (inst[6]==1'b1)begin //BEQ
 gen_out = {{20{inst[31]}},inst[31],inst[7],inst[30:25],inst[11:8]};
end
else if (inst[6]==1'b0) begin // LW or SW

  if (inst[5]==1'b0)begin //LW
   gen_out = {{20{inst[31]}},inst[31],inst[30:25],inst[24:21],inst[20]};
  end
  else if (inst[5]==1'b1)begin //SW
   gen_out = {{20{inst[31]}},inst[31],inst[30:25],inst[11:8],inst[7]};
  end


end
end



endmodule