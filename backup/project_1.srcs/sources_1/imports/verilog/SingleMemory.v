`include "defines.v"

module SingleMemory(
        input sclk,
        input clk,
        input rst,
        input [11:0] addr,
        input [31:0] data_in,  
        
        //data mem  
        input mem_read,
        input mem_write,
        input [2:0] F3,
        //output
       output reg [31:0] data_out
    );
    
    
    parameter  mem_size=256;   
    parameter  offset=mem_size/2;
    reg [7:0] mem [0:(mem_size-1)];

    
    /*
    assume inst mem  0:2047
    assume data mem  2048:4095
    */
    
    initial begin
    {mem[3],mem[2],mem[1],mem[0]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
     {mem[7],mem[6],mem[5],mem[4]}=32'b000000000000_00000_010_00001_0000011 ; //lw x1, 0(x0)
     {mem[11],mem[10],mem[9],mem[8]}=32'b000000000100_00000_010_00010_0000011 ; //lw x2, 4(x0)
     {mem[15],mem[14],mem[13],mem[12]}=32'b000000001000_00000_010_00011_0000011 ; //lw x3, 8(x0)
     {mem[19],mem[18],mem[17],mem[16]}=32'b0000000_00010_00001_110_00100_0110011 ; //or x4, x1, x2
     {mem[23],mem[22],mem[21],mem[20]}=32'b0_000000_00011_00100_000_0100_0_1100011; //beq x4, x3, 16
     {mem[27],mem[26],mem[25],mem[24]}=32'b0000000_00010_00001_000_00011_0110011 ; //add x3, x1, x2
     {mem[31],mem[30],mem[29],mem[28]}=32'b0000000_00010_00011_000_00101_0110011 ; //add x5, x3, x2
     {mem[35],mem[34],mem[33],mem[32]}=32'b0000000_00101_00000_010_01100_0100011; //sw x5, 12(x0)
     {mem[39],mem[38],mem[37],mem[36]}=32'b000000001100_00000_010_00110_0000011 ; //lw x6, 12(x0)
     {mem[43],mem[42],mem[41],mem[40]}=32'b0000000_00001_00110_111_00111_0110011 ; //and x7, x6, x1
    
     {mem[47],mem[46],mem[45],mem[44]}=32'b0100000_00010_00001_000_01000_0110011 ; //sub x8, x1, x2
  
     {mem[51],mem[50],mem[49],mem[48]}=32'b0000000_00010_00001_000_00000_0110011 ; //add x0, x1, x2
 
     {mem[55],mem[54],mem[53],mem[52]}=32'b0000000_00001_00000_000_01001_0110011 ; //add x9, x0, x1
     {mem[59],mem[58],mem[57],mem[56]}=32'h73 ; //add x9, x0, x1


        //data mem
   {mem[3 +offset ],mem[2+offset],mem[1+offset],mem[0+offset]}=32'd17;
   {mem[7 +offset ],mem[6+offset],mem[5+offset],mem[4+offset]}=32'd9;
   {mem[11 +offset],mem[10+offset],mem[9+offset],mem[8+offset]}=32'd25;
       end 
    
     
      
      integer i;
      always@(posedge clk) // for writing 
        begin 
          if (rst==1'b1)
            begin
            for (i=12+offset;i<mem_size;i=i+1)
              mem[i] = 8'd0;
            end      
          else if (mem_write)
              case (F3)
                `F3_LB: mem[addr+offset] =  data_in[7:0]; //SB
                `F3_LH: {mem[addr+offset+1], mem[addr+offset]} =  data_in[15:0];
                `F3_LW: {mem[addr+offset+3], mem[addr+offset+2],mem[addr+offset+1], mem[addr+offset]} = data_in; //SW
              endcase
        end
        
   
     always@(*) // for reading
             begin
                if(rst)data_out=32'd0;
                else if(sclk) //data memory
                begin
                 data_out ={mem[addr+3],mem[addr+2],mem[addr+1] ,mem[addr]};
                    end  
                    else   
                      begin 
                        if (mem_read == 1'b1)
                           case (F3)
                             `F3_LW: data_out =  { mem[addr+offset+3],mem[addr+offset+2],mem[addr+offset+1],  mem[addr+offset]}; 
                             `F3_LH: data_out =  {{16{mem[addr+offset+1][7]}},mem[addr+offset+1],  mem[addr+offset]}; 
                             `F3_LB: data_out =  {{24{mem[addr+offset][7]}},  mem[addr+offset]}; 
                                  
                   
                             `F3_LHU: data_out =  {{16{1'b0}},mem[addr+offset+1],  mem[addr+offset]}; 
                             `F3_LBU: data_out =  {{24{1'b0}},  mem[addr+offset]}; 
                              default: data_out = 32'd39;
                           endcase
                        else if (mem_read ==1'b0)
                             data_out = 32'd42; 
                    end  
                     
              
                 
                   
           end
             
     
    
endmodule
