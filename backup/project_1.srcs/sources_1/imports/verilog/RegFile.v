module RegFile #(parameter N=32)
                (input clk, input reset, input [4:0] rs1, input [4:0] rs2, input [4:0] rd, 
                input [31:0] Data, input regWrite,
                output [31:0] readData1, output [31:0] readData2
                ); //regWrite enables writing



wire [N-1:0]Q[31:0];
reg [N-1:0]load;


genvar i;


generate
for (i=1; i<N; i=i+1) begin:f
RegisterNBit#(N) regnbit (clk,reset,Data,load[i], Q[i]);
end
endgenerate

assign readData1=Q[rs1];
assign readData2=Q[rs2];

assign Q[0]=32'd0;

always @(posedge clk or posedge reset)
begin

if (regWrite==1'b1) // write
  begin
  load= 32'd0;
  load [rd] =1'b1;
  end
else //read
  begin
load= 32'd0;
  end
end


endmodule