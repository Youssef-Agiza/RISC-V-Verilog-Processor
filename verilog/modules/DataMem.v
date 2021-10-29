module DataMem
 (input clk, input rst, input MemRead, input MemWrite,
 input [5:0] addr, input  [31:0] data_in, output reg [31:0] data_out); // reseting is asynchronous
 reg [31:0] mem [0:63];

 

  always@(*) // for reading
  begin
  
    if (MemRead == 1'b1)
       data_out = mem[addr];
  end
  
  
  integer i;
  always@(posedge clk or posedge rst) // for writing
  begin 
    if (rst==1'b1)
      begin
      for (i=3;i<64;i=i+1)
         mem[i] = 32'b0;
      end
    else if (MemWrite)
      mem[addr] = data_in;
  
  end

   initial begin
         mem[0]=32'd17;
         mem[1]=32'd9; 
         mem[2]=32'd25;
     end 

endmodule