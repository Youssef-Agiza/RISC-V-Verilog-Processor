
module ALUNBit  #(parameter N=32) (input [N-1:0] A, input [N-1:0]B, input [3:0] Sel,output zeroFlag, output reg [N-1:0] ALUOutput);

wire [N-1:0]BOut; 
wire [N-1:0]Sum;
wire [N-1:0] AndOut;
wire [N-1:0] OrOut;


wire [N-1:0]BComp= (~B) +1'b1; 


MUXNBit mux(.A(B),.B(BComp),.S(Sel[2]),.C(BOut));
RCANBit rca(.a(A),.b(BOut),.sum(Sum),.Cout());

assign AndOut= A & B;
assign OrOut= A | B;
assign zeroFlag= ALUOutput==32'b0;
always @(*)begin 



if(Sel==4'b0010|| (Sel==4'b0110))//addition
  ALUOutput = Sum;
  
else if(Sel==4'b0000)//and
  ALUOutput = AndOut;

else if(Sel==4'b0001)//or
  ALUOutput = OrOut;

else 
  ALUOutput = 32'b0;

end

   
   
      
      

endmodule