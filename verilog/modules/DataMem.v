`include "defines.v"
module DataMem
 (input                     clk,
  input                     rst,
  input                     mem_read,
  input                     mem_write,
  input      [2:0]   F3,
  input      [5:0]          addr,
  input      [31:0]         data_in,
  output reg [31:0]         data_out); // reseting is asynchronous
  
  reg [7:0] mem [0:63];

 

  always@(*) // for reading
  begin
  
    if (mem_read == 1'b1)
        case (F3)
          `F3_LW: data_out =  { mem[addr+3],mem[addr+2],mem[addr+1],  mem[addr]}; 
          `F3_LH: data_out =  {{16{mem[addr+1][7]}},mem[addr+1],  mem[addr]}; 
          `F3_LB: data_out =  {{24{mem[addr][7]}},  mem[addr]}; 
               

          `F3_LHU: data_out =  {{16{1'b0}},mem[addr+1],  mem[addr]}; 
          `F3_LBU: data_out =  {{24{1'b0}},  mem[addr]}; 

        endcase
  end
  
  
  integer i;
  always@(posedge clk or posedge rst) // for writing
    begin 
      if (rst==1'b1)
        begin
        for (i=3;i<64;i=i+1)
          mem[i] = 8'b0;
        end
      
      else if (mem_write)
          case (F3)
            `F3_LB: mem[addr] =  data_in[7:0]; //SB
            `F3_LH: {mem[addr+1], mem[addr]} =  data_in[15:0];
            `F3_LW: {mem[addr+3], mem[addr+2],mem[addr+1], mem[addr]} = data_in; //SW
          endcase
    
    end

//   initial begin
//         mem[0]=8'd17;
//         mem[1]=8'd9; 
//         mem[2]=8'd25;
//     end 

endmodule