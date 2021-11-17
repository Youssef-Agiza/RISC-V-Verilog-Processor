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
    
    
    parameter  mem_size=256*4;   
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
{mem[3], mem[2], mem[1], mem[0]} = 32'h13;
{mem[7], mem[6], mem[5], mem[4]} = 32'h00000093;
{mem[11], mem[10], mem[9], mem[8]} = 32'h00000113;
{mem[15], mem[14], mem[13], mem[12]} = 32'h00208f33;
{mem[19], mem[18], mem[17], mem[16]} = 32'h00000e93;
{mem[23], mem[22], mem[21], mem[20]} = 32'h00200193;
{mem[27], mem[26], mem[25], mem[24]} = 32'h1fdf1e63;
{mem[31], mem[30], mem[29], mem[28]} = 32'h00100093;
{mem[35], mem[34], mem[33], mem[32]} = 32'h00100113;
{mem[39], mem[38], mem[37], mem[36]} = 32'h00208f33;
{mem[43], mem[42], mem[41], mem[40]} = 32'h00200e93;
{mem[47], mem[46], mem[45], mem[44]} = 32'h00300193;
{mem[51], mem[50], mem[49], mem[48]} = 32'h1fdf1263;
{mem[55], mem[54], mem[53], mem[52]} = 32'h00300093;
{mem[59], mem[58], mem[57], mem[56]} = 32'h00700113;
{mem[63], mem[62], mem[61], mem[60]} = 32'h00208f33;
{mem[67], mem[66], mem[65], mem[64]} = 32'h00a00e93;
{mem[71], mem[70], mem[69], mem[68]} = 32'h00400193;
{mem[75], mem[74], mem[73], mem[72]} = 32'h1ddf1663;
{mem[79], mem[78], mem[77], mem[76]} = 32'h00000093;
{mem[83], mem[82], mem[81], mem[80]} = 32'hffff8137;
{mem[87], mem[86], mem[85], mem[84]} = 32'h00010113;
{mem[91], mem[90], mem[89], mem[88]} = 32'h00208f33;
{mem[95], mem[94], mem[93], mem[92]} = 32'hffff8eb7;
{mem[99], mem[98], mem[97], mem[96]} = 32'h000e8e93;
{mem[103], mem[102], mem[101], mem[100]} = 32'h00500193;
{mem[107], mem[106], mem[105], mem[104]} = 32'h1bdf1663;
{mem[111], mem[110], mem[109], mem[108]} = 32'h800000b7;
{mem[115], mem[114], mem[113], mem[112]} = 32'h00008093;
{mem[119], mem[118], mem[117], mem[116]} = 32'h00000113;
{mem[123], mem[122], mem[121], mem[120]} = 32'h00208f33;
{mem[127], mem[126], mem[125], mem[124]} = 32'h80000eb7;
{mem[131], mem[130], mem[129], mem[128]} = 32'h000e8e93;
{mem[135], mem[134], mem[133], mem[132]} = 32'h00600193;
{mem[139], mem[138], mem[137], mem[136]} = 32'h19df1663;
{mem[143], mem[142], mem[141], mem[140]} = 32'h800000b7;
{mem[147], mem[146], mem[145], mem[144]} = 32'h00008093;
{mem[151], mem[150], mem[149], mem[148]} = 32'hffff8137;
{mem[155], mem[154], mem[153], mem[152]} = 32'h00010113;
{mem[159], mem[158], mem[157], mem[156]} = 32'h00208f33;
{mem[163], mem[162], mem[161], mem[160]} = 32'h7fff8eb7;
{mem[167], mem[166], mem[165], mem[164]} = 32'h000e8e93;
{mem[171], mem[170], mem[169], mem[168]} = 32'h00700193;
{mem[175], mem[174], mem[173], mem[172]} = 32'h17df1463;
{mem[179], mem[178], mem[177], mem[176]} = 32'h00000093;
{mem[183], mem[182], mem[181], mem[180]} = 32'h00008137;
{mem[187], mem[186], mem[185], mem[184]} = 32'hfff10113;
{mem[191], mem[190], mem[189], mem[188]} = 32'h00208f33;
{mem[195], mem[194], mem[193], mem[192]} = 32'h00008eb7;
{mem[199], mem[198], mem[197], mem[196]} = 32'hfffe8e93;
{mem[203], mem[202], mem[201], mem[200]} = 32'h00800193;
{mem[207], mem[206], mem[205], mem[204]} = 32'h15df1463;
{mem[211], mem[210], mem[209], mem[208]} = 32'h800000b7;
{mem[215], mem[214], mem[213], mem[212]} = 32'hfff08093;
{mem[219], mem[218], mem[217], mem[216]} = 32'h00000113;
{mem[223], mem[222], mem[221], mem[220]} = 32'h00208f33;
{mem[227], mem[226], mem[225], mem[224]} = 32'h80000eb7;
{mem[231], mem[230], mem[229], mem[228]} = 32'hfffe8e93;
{mem[235], mem[234], mem[233], mem[232]} = 32'h00900193;
{mem[239], mem[238], mem[237], mem[236]} = 32'h13df1463;
{mem[243], mem[242], mem[241], mem[240]} = 32'h800000b7;
{mem[247], mem[246], mem[245], mem[244]} = 32'hfff08093;
{mem[251], mem[250], mem[249], mem[248]} = 32'h00008137;
{mem[255], mem[254], mem[253], mem[252]} = 32'hfff10113;
{mem[259], mem[258], mem[257], mem[256]} = 32'h00208f33;
{mem[263], mem[262], mem[261], mem[260]} = 32'h80008eb7;
{mem[267], mem[266], mem[265], mem[264]} = 32'hffee8e93;
{mem[271], mem[270], mem[269], mem[268]} = 32'h00a00193;
{mem[275], mem[274], mem[273], mem[272]} = 32'h11df1263;
{mem[279], mem[278], mem[277], mem[276]} = 32'h800000b7;
{mem[283], mem[282], mem[281], mem[280]} = 32'h00008093;
{mem[287], mem[286], mem[285], mem[284]} = 32'h00008137;
{mem[291], mem[290], mem[289], mem[288]} = 32'hfff10113;
{mem[295], mem[294], mem[293], mem[292]} = 32'h00208f33;
{mem[299], mem[298], mem[297], mem[296]} = 32'h80008eb7;
{mem[303], mem[302], mem[301], mem[300]} = 32'hfffe8e93;
{mem[307], mem[306], mem[305], mem[304]} = 32'h00b00193;
{mem[311], mem[310], mem[309], mem[308]} = 32'h0fdf1063;
{mem[315], mem[314], mem[313], mem[312]} = 32'h800000b7;
{mem[319], mem[318], mem[317], mem[316]} = 32'hfff08093;
{mem[323], mem[322], mem[321], mem[320]} = 32'hffff8137;
{mem[327], mem[326], mem[325], mem[324]} = 32'h00010113;
{mem[331], mem[330], mem[329], mem[328]} = 32'h00208f33;
{mem[335], mem[334], mem[333], mem[332]} = 32'h7fff8eb7;
{mem[339], mem[338], mem[337], mem[336]} = 32'hfffe8e93;
{mem[343], mem[342], mem[341], mem[340]} = 32'h00c00193;
{mem[347], mem[346], mem[345], mem[344]} = 32'h0bdf1e63;
{mem[351], mem[350], mem[349], mem[348]} = 32'h00000093;
{mem[355], mem[354], mem[353], mem[352]} = 32'hfff00113;
{mem[359], mem[358], mem[357], mem[356]} = 32'h00208f33;
{mem[363], mem[362], mem[361], mem[360]} = 32'hfff00e93;
{mem[367], mem[366], mem[365], mem[364]} = 32'h00d00193;
{mem[371], mem[370], mem[369], mem[368]} = 32'h0bdf1263;
{mem[375], mem[374], mem[373], mem[372]} = 32'hfff00093;
{mem[379], mem[378], mem[377], mem[376]} = 32'h00100113;
{mem[383], mem[382], mem[381], mem[380]} = 32'h00208f33;
{mem[387], mem[386], mem[385], mem[384]} = 32'h00000e93;
{mem[391], mem[390], mem[389], mem[388]} = 32'h00e00193;
{mem[395], mem[394], mem[393], mem[392]} = 32'h09df1663;
{mem[399], mem[398], mem[397], mem[396]} = 32'hfff00093;
{mem[403], mem[402], mem[401], mem[400]} = 32'hfff00113;
{mem[407], mem[406], mem[405], mem[404]} = 32'h00208f33;
{mem[411], mem[410], mem[409], mem[408]} = 32'hffe00e93;
{mem[415], mem[414], mem[413], mem[412]} = 32'h00f00193;
{mem[419], mem[418], mem[417], mem[416]} = 32'h07df1a63;
{mem[423], mem[422], mem[421], mem[420]} = 32'h00100093;
{mem[427], mem[426], mem[425], mem[424]} = 32'h80000137;
{mem[431], mem[430], mem[429], mem[428]} = 32'hfff10113;
{mem[435], mem[434], mem[433], mem[432]} = 32'h00208f33;
{mem[439], mem[438], mem[437], mem[436]} = 32'h80000eb7;
{mem[443], mem[442], mem[441], mem[440]} = 32'h000e8e93;
{mem[447], mem[446], mem[445], mem[444]} = 32'h01000193;
{mem[451], mem[450], mem[449], mem[448]} = 32'h05df1a63;
{mem[455], mem[454], mem[453], mem[452]} = 32'h00d00093;
{mem[459], mem[458], mem[457], mem[456]} = 32'h00b00113;
{mem[463], mem[462], mem[461], mem[460]} = 32'h002080b3;
{mem[467], mem[466], mem[465], mem[464]} = 32'h01800e93;
{mem[471], mem[470], mem[469], mem[468]} = 32'h01100193;
{mem[475], mem[474], mem[473], mem[472]} = 32'h03d09e63;
{mem[479], mem[478], mem[477], mem[476]} = 32'h00e00093;
{mem[483], mem[482], mem[481], mem[480]} = 32'h00b00113;
{mem[487], mem[486], mem[485], mem[484]} = 32'h00208133;
{mem[491], mem[490], mem[489], mem[488]} = 32'h01900e93;
{mem[495], mem[494], mem[493], mem[492]} = 32'h01200193;
{mem[499], mem[498], mem[497], mem[496]} = 32'h03d11263;
{mem[503], mem[502], mem[501], mem[500]} = 32'h00d00093;
{mem[507], mem[506], mem[505], mem[504]} = 32'h001080b3;
{mem[511], mem[510], mem[509], mem[508]} = 32'h01a00e93;
{mem[515], mem[514], mem[513], mem[512]} = 32'h01300193;
{mem[519], mem[518], mem[517], mem[516]} = 32'h01d09863;
{mem[523], mem[522], mem[521], mem[520]} = 32'h02a00513;
{mem[527], mem[526], mem[525], mem[524]} = 32'h05d00893;
{mem[531], mem[530], mem[529], mem[528]} = 32'h00000073;
{mem[535], mem[534], mem[533], mem[532]} = 32'h00000513;
{mem[539], mem[538], mem[537], mem[536]} = 32'h05d00893;
{mem[543], mem[542], mem[541], mem[540]} = 32'h00000073;

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
                              default: data_out = 32'd39;
                           endcase
                        else if (mem_read ==1'b0)
                             data_out = 32'd42; 
                    end  
                     
              
                 
                   
           end
             
     
    
endmodule
