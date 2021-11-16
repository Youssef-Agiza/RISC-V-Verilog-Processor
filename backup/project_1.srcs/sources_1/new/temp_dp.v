module temp_d(
        input rclk,
        input rst,
        output  [31:0] PCOut,
        output [31:0] BranchTargetAddr,
        output  [31:0] PCIn,
        output [31:0] rs1Read,
        output [31:0] rs2Read,
        output [31:0] regFileIn,
        output [31:0] imm,
        output [31:0] shiftLeftOut,
        output [31:0] ALU2ndSrc,
        output [31:0] ALUOut,
        output [31:0] memoryOut,
        output [31:0] inst,
        output branch,
        output MemRead,
        output MemtoReg,
        output MemWrite,
        output ALUSrc,
        output RegWrite
    );
    
//    wire branch,MemRead,MemtoReg,MemWrite,ALUSrc,RegWrite;
    wire [1:0] ALUOp;
    wire [3:0]ALUSelection;
    wire zeroFlag;
    wire [31:0] PCPlus4;
   wire [4:0] MEM_WB_Rd;

wire [31:0] IF_ID_PC;
wire [31:0] IF_ID_Inst;
wire [31:0] ID_EX_Inst;

     RegisterNBit PCReg(rclk,rst,PCIn,1, PCOut );

          InstMem instMem(PCOut[7:2],inst);
        RCANBit RCA2(PCOut, 32'd4,PCPlus4);

         RegisterNBit #(.N(64)) IF_ID( .clk(rclk),.rst(rst), .D({PCOut,inst}), .load(1'b1),  .Q({IF_ID_PC,IF_ID_Inst})); 

       
   //------------------------   IF/ID  -----------------------------------------------------------    
        
    //2- RF


   //3- Control unit
       controlUnit CU( .inst(IF_ID_Inst[6:0]),  .branch(branch), .MemRead(MemRead),
                        .MemtoReg(MemtoReg), .ALUOp(ALUOp),.MemWrite(MemWrite), 
                         .ALUSrc(ALUSrc), .RegWrite(RegWrite));
     RegFile regFile(rclk, rst, IF_ID_Inst[19:15], IF_ID_Inst[24:20], MEM_WB_Rd, regFileIn,  MEM_WB_Ctrl[1], rs1Read, rs2Read ); //regWrite enables writing
     
     //4- IMM Gen
     ImmGen immGen(IF_ID_Inst,imm);
     
     
     wire [31:0] ID_EX_PC, ID_EX_RegR1, ID_EX_RegR2, ID_EX_Imm;
     wire [7:0] ID_EX_Ctrl;
     wire [3:0] ID_EX_Func;
     wire [4:0]  ID_EX_Rd, ID_EX_Rs1, ID_EX_Rs2;
    RegisterNBit #(.N(155)) ID_EX( .clk(rclk),.rst(rst),.load(1'b1), //145
                     .D({RegWrite,MemtoReg,branch,MemRead,MemWrite,ALUOp,ALUSrc,
                     IF_ID_PC,
                     IF_ID_Inst[19:15],IF_ID_Inst[24:20],
                      rs1Read , rs2Read, imm, IF_ID_Inst[14:12], IF_ID_Inst[30], IF_ID_Inst[11:7]}),
                     
                     .Q({ID_EX_Ctrl,ID_EX_PC,
                     ID_EX_Rs1,ID_EX_Rs2,
                     ID_EX_RegR1,ID_EX_RegR2,ID_EX_Imm,ID_EX_Func,ID_EX_Rd})); 
 
     
     
   //--------------------------ID/EX---------------------------------------------------------    
  

   
    
    // ALU MUX

    //5- ALU control
      ALUControlUnit ALUControl(ID_EX_Ctrl[2:1],ID_EX_Func[3:1],ID_EX_Func[0],ALUSelection);
    //6- ALU 
      //8-shift and adder
      ShiftLeftNBit shifter(ID_EX_Imm,shiftLeftOut);
      RCANBit RCA( ID_EX_PC,  shiftLeftOut,  BranchTargetAddr, x); 
      
   
    MUXNBit aluSrcMux(.A(ID_EX_RegR2),.B(ID_EX_Imm),.S(ID_EX_Ctrl[0]),.C(ALU2ndSrc));   
    ALUNBit ALU(ID_EX_RegR1,ALU2ndSrc,ALUSelection,zeroFlag, ALUOut);
    
    
    wire [31:0] EX_MEM_BranchAddOut, EX_MEM_ALU_out, EX_MEM_RegR2;
    wire EX_MEM_ZERO_FLAG;
    wire [4:0] EX_MEM_Ctrl;
    wire [4:0] EX_MEM_Rd;

     RegisterNBit #(.N(107)) EX_MEM( .clk(rclk),.rst(rst),.load(1'b1),//107
                        .D({ID_EX_Ctrl[7:3],BranchTargetAddr,zeroFlag,ALUOut,ID_EX_RegR2,ID_EX_Rd}),
                        .Q({EX_MEM_Ctrl,EX_MEM_BranchAddOut,EX_MEM_ZERO_FLAG,EX_MEM_ALU_out,EX_MEM_RegR2,EX_MEM_Rd})); 
    
        
    MUXNBit pcInMux(.A(PCPlus4),.B(EX_MEM_BranchAddOut),.S(EX_MEM_Ctrl[2]& EX_MEM_ZERO_FLAG),.C(PCIn));


    
     //--------------------------EX/MEM---------------------------------------------------------    

    //7- Data mem
    DataMem dataMem( rclk, rst,  EX_MEM_Ctrl[1],  EX_MEM_Ctrl[0], EX_MEM_ALU_out[7:2],  EX_MEM_RegR2, memoryOut);
    
    wire [31:0] MEM_WB_Mem_out, MEM_WB_ALU_out;
    wire [1:0] MEM_WB_Ctrl;
 

    RegisterNBit #(.N(71)) MEM_WB( .clk(rclk),.rst(rst),.load(1'b1),//71
                       .D({EX_MEM_Ctrl[4:3],memoryOut,EX_MEM_ALU_out,EX_MEM_Rd}),
                       .Q({MEM_WB_Ctrl,MEM_WB_Mem_out,MEM_WB_ALU_out,MEM_WB_Rd})); 
   
       
    
    //--------------------------MEM/WB---------------------------------------------------------    

    MUXNBit memToRegMux(.A(MEM_WB_ALU_out),.B(MEM_WB_Mem_out),.S(MEM_WB_Ctrl[0]),.C(regFileIn));

  

    
     
    

    

    
    // call on Test16BitOut here
endmodule
