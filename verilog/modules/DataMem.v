`include "defines.v"
module DataMem
 (input                     clk,
  input                     rst,
  input                     mem_read,
  input                     mem_write,
  input      [`IR_funct3]   F3,
  input      [5:0]          addr,
  input      [31:0]         data_in,
  output reg [31:0]         data_out); // reseting is asynchronous
  
  reg [31:0] mem [0:63];

 

  always@(*) // for reading
  begin
  
    if (mem_read == 1'b1)
        case (F3)
          `F3_LB: data_out =  { {25{mem[addr][7]}},  mem[addr][6:0]}; 
          `F3_LH: data_out =  { {25{mem[addr][15]}}, mem[addr][14:0]};

          `F3_LHU: data_out = {{25{1'b0}}, {mem[addr][14:0]}}; 
          `F3_LBU: data_out = {{25{1'b0}}, {mem[addr][6:0]}}; 

          default: data_out = mem[addr]; //LW
        endcase
  end
  
  
  integer i;
  always@(posedge clk or posedge rst) // for writing
    begin 
      if (rst==1'b1)
        begin
        for (i=3;i<64;i=i+1)
          mem[i] = 32'b0;
        end
      
      else if (mem_write)
          case (F3)
            `F3_LB: mem[addr][7:0] =  data_in[7:0]; 
            `F3_LH: mem[addr][15:0] =  data_in[15:0];


            default: mem[addr] = data_in; //SW
          endcase
    
    end

   initial begin
         mem[0]=32'd17;
         mem[1]=32'd9; 
         mem[2]=32'd25;
     end 

endmodule