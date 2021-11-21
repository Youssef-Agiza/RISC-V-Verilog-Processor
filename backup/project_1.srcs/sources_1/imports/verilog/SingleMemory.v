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
    
    
    parameter  mem_size=2048;   
    parameter  offset=mem_size/2;
    reg [7:0] mem [0:(mem_size-1)];

    
    /*
    assume inst mem  0:2047
    assume data mem  2048:4095
    */
    
    initial begin
//    {mem[3],mem[2],mem[1],mem[0]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//     {mem[7],mem[6],mem[5],mem[4]}=32'b000000000000_00000_010_00001_0000011 ; //lw x1, 0(x0)
//     {mem[11],mem[10],mem[9],mem[8]}=32'b000000000100_00000_010_00010_0000011 ; //lw x2, 4(x0)
//     {mem[15],mem[14],mem[13],mem[12]}=32'b000000001000_00000_010_00011_0000011 ; //lw x3, 8(x0)
//     {mem[19],mem[18],mem[17],mem[16]}=32'b0000000_00010_00001_110_00100_0110011 ; //or x4, x1, x2
//     {mem[23],mem[22],mem[21],mem[20]}=32'b0_000000_00011_00100_000_0100_0_1100011; //beq x4, x3, 16
//     {mem[27],mem[26],mem[25],mem[24]}=32'b0000000_00010_00001_000_00011_0110011 ; //add x3, x1, x2
//     {mem[31],mem[30],mem[29],mem[28]}=32'b0000000_00010_00011_000_00101_0110011 ; //add x5, x3, x2
//     {mem[35],mem[34],mem[33],mem[32]}=32'b0000000_00101_00000_010_01100_0100011; //sw x5, 12(x0)
//     {mem[39],mem[38],mem[37],mem[36]}=32'b000000001100_00000_010_00110_0000011 ; //lw x6, 12(x0)
//     {mem[43],mem[42],mem[41],mem[40]}=32'b0000000_00001_00110_111_00111_0110011 ; //and x7, x6, x1
    
//     {mem[47],mem[46],mem[45],mem[44]}=32'b0100000_00010_00001_000_01000_0110011 ; //sub x8, x1, x2
  
//     {mem[51],mem[50],mem[49],mem[48]}=32'b0000000_00010_00001_000_00000_0110011 ; //add x0, x1, x2
 
//     {mem[55],mem[54],mem[53],mem[52]}=32'b0000000_00001_00000_000_01001_0110011 ; //add x9, x0, x1
//     {mem[59],mem[58],mem[57],mem[56]}=32'h73 ; //add x9, x0, x1
///////////////////////////////////////////////////////////////////////////
//{mem[3], mem[2], mem[1], mem[0]} =     32'h13; /
//{mem[7], mem[6], mem[5], mem[4]} =     32'h00200113;
////{mem[11], mem[10], mem[9], mem[8]} = 32'h1000067 ;
//{mem[11], mem[10], mem[9], mem[8]} =   32'h008000ef;
//{mem[15], mem[14], mem[13], mem[12]} = 32'h00000073;
//{mem[19], mem[18], mem[17], mem[16]} = 32'h00300193;
//{mem[23], mem[22], mem[21], mem[20]} = 32'h40218133;
//{mem[27], mem[26], mem[25], mem[24]} = 32'h00310233;
//{mem[31], mem[30], mem[29], mem[28]} = 32'h002242b3;
//{mem[35], mem[34], mem[33], mem[32]} = 32'h00008367;

//{mem[3], mem[2], mem[1], mem[0]} = 32'h13;//addi x0,x0,0
//{mem[7], mem[6], mem[5], mem[4]} =32'h00c000ef;//jal func
//{mem[11], mem[10], mem[9], mem[8]} = 32'h00000073;//ecall
//{mem[15], mem[14], mem[13], mem[12]} =32'h00200113;//addi x2,x0,2
//{mem[19], mem[18], mem[17], mem[16]} = 32'h00300193;//addi x3,x0,3 #x3 =3
//{mem[23], mem[22], mem[21], mem[20]} =32'h00008367;//jalr x6, x1, 0
{mem[3], mem[2], mem[1], mem[0]} = 32'h13;
{mem[7], mem[6], mem[5], mem[4]} = 32'h01400093;
{mem[11], mem[10], mem[9], mem[8]} = 32'h00600113;
{mem[15], mem[14], mem[13], mem[12]} = 32'h0220ff33;
{mem[19], mem[18], mem[17], mem[16]} = 32'h00200e93;
{mem[23], mem[22], mem[21], mem[20]} = 32'h00200193;
{mem[27], mem[26], mem[25], mem[24]} = 32'h0ddf1e63;
{mem[31], mem[30], mem[29], mem[28]} = 32'hfec00093;
{mem[35], mem[34], mem[33], mem[32]} = 32'h00600113;
{mem[39], mem[38], mem[37], mem[36]} = 32'h0220ff33;
{mem[43], mem[42], mem[41], mem[40]} = 32'h00200e93;
{mem[47], mem[46], mem[45], mem[44]} = 32'h00300193;
{mem[51], mem[50], mem[49], mem[48]} = 32'h0ddf1263;
{mem[55], mem[54], mem[53], mem[52]} = 32'h01400093;
{mem[59], mem[58], mem[57], mem[56]} = 32'hffa00113;
{mem[63], mem[62], mem[61], mem[60]} = 32'h0220ff33;
{mem[67], mem[66], mem[65], mem[64]} = 32'h01400e93;
{mem[71], mem[70], mem[69], mem[68]} = 32'h00400193;
{mem[75], mem[74], mem[73], mem[72]} = 32'h0bdf1663;
{mem[79], mem[78], mem[77], mem[76]} = 32'hfec00093;
{mem[83], mem[82], mem[81], mem[80]} = 32'hffa00113;
{mem[87], mem[86], mem[85], mem[84]} = 32'h0220ff33;
{mem[91], mem[90], mem[89], mem[88]} = 32'hfec00e93;
{mem[95], mem[94], mem[93], mem[92]} = 32'h00500193;
{mem[99], mem[98], mem[97], mem[96]} = 32'h09df1a63;
{mem[103], mem[102], mem[101], mem[100]} = 32'h800000b7;
{mem[107], mem[106], mem[105], mem[104]} = 32'h00008093;
{mem[111], mem[110], mem[109], mem[108]} = 32'h00100113;
{mem[115], mem[114], mem[113], mem[112]} = 32'h0220ff33;
{mem[119], mem[118], mem[117], mem[116]} = 32'h00000e93;
{mem[123], mem[122], mem[121], mem[120]} = 32'h00600193;
{mem[127], mem[126], mem[125], mem[124]} = 32'h07df1c63;
{mem[131], mem[130], mem[129], mem[128]} = 32'h800000b7;
{mem[135], mem[134], mem[133], mem[132]} = 32'h00008093;
{mem[139], mem[138], mem[137], mem[136]} = 32'hfff00113;
{mem[143], mem[142], mem[141], mem[140]} = 32'h0220ff33;
{mem[147], mem[146], mem[145], mem[144]} = 32'h80000eb7;
{mem[151], mem[150], mem[149], mem[148]} = 32'h000e8e93;
{mem[155], mem[154], mem[153], mem[152]} = 32'h00700193;
{mem[159], mem[158], mem[157], mem[156]} = 32'h05df1c63;
{mem[163], mem[162], mem[161], mem[160]} = 32'h800000b7;
{mem[167], mem[166], mem[165], mem[164]} = 32'h00008093;
{mem[171], mem[170], mem[169], mem[168]} = 32'h00000113;
{mem[175], mem[174], mem[173], mem[172]} = 32'h0220ff33;
{mem[179], mem[178], mem[177], mem[176]} = 32'h80000eb7;
{mem[183], mem[182], mem[181], mem[180]} = 32'h000e8e93;
{mem[187], mem[186], mem[185], mem[184]} = 32'h00800193;
{mem[191], mem[190], mem[189], mem[188]} = 32'h03df1c63;
{mem[195], mem[194], mem[193], mem[192]} = 32'h00100093;
{mem[199], mem[198], mem[197], mem[196]} = 32'h00000113;
{mem[203], mem[202], mem[201], mem[200]} = 32'h0220ff33;
{mem[207], mem[206], mem[205], mem[204]} = 32'h00100e93;
{mem[211], mem[210], mem[209], mem[208]} = 32'h00900193;
{mem[215], mem[214], mem[213], mem[212]} = 32'h03df1063;
{mem[219], mem[218], mem[217], mem[216]} = 32'h00000093;
{mem[223], mem[222], mem[221], mem[220]} = 32'h00000113;
{mem[227], mem[226], mem[225], mem[224]} = 32'h0220ff33;
{mem[231], mem[230], mem[229], mem[228]} = 32'h00000e93;
{mem[235], mem[234], mem[233], mem[232]} = 32'h00a00193;
{mem[239], mem[238], mem[237], mem[236]} = 32'h01df1463;
{mem[243], mem[242], mem[241], mem[240]} = 32'h00301863;
{mem[247], mem[246], mem[245], mem[244]} = 32'h00000513;
{mem[251], mem[250], mem[249], mem[248]} = 32'h05d00893;
{mem[255], mem[254], mem[253], mem[252]} = 32'h00000073;
{mem[259], mem[258], mem[257], mem[256]} = 32'h02a00513;
{mem[263], mem[262], mem[261], mem[260]} = 32'h05d00893;
{mem[267], mem[266], mem[265], mem[264]} = 32'h00000073;



//{mem[35], mem[34], mem[33], mem[32]} = 32'h
///////////////////////////////////////////////////////////////////////////
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
                              default: data_out = 32'd0;
                           endcase
                        else if (mem_read ==1'b0)
                             data_out = 32'd0; 
                    end  
                     
              
                 
                   
           end
             
     
    
endmodule
