module Datapath(
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
// PC MUX
// Write Data MUX


     RegisterNBit PCReg(rclk,rst,PCIn,1, PCOut );

    

    //1- inst mem
        InstMem instMem(PCOut[7:2],inst);
        
    //2- RF
     RegFile regFile(rclk, rst, inst[19:15], inst[24:20], inst[11:7], regFileIn,  RegWrite, rs1Read, rs2Read ); //regWrite enables writing
     
    //3- Control unit
        controlUnit CU( inst[6:0],  branch, MemRead,MemtoReg, ALUOp,MemWrite,  ALUSrc, RegWrite);

    
    //4- IMM Gen
    ImmGen immGen(inst,imm);
    
    
    // ALU MUX
    assign ALU2ndSrc=(ALUSrc)?imm:rs2Read;

    //5- ALU control
      ALUControlUnit ALUControl(ALUOp,inst[14:12],inst[30],ALUSelection);
    
    //6- ALU 
    ALUNBit ALU(rs1Read,ALU2ndSrc,ALUSelection,zeroFlag, ALUOut);
    
    //7- Data mem
    DataMem dataMem( rclk, rst,  MemRead,  MemWrite, ALUOut [7:2],  rs2Read, memoryOut);
    assign regFileIn= (MemtoReg)?memoryOut:ALUOut;
    
    //8-shift and adder
    ShiftLeftNBit shifter(imm,shiftLeftOut);
    RCANBit RCA( PCOut,  shiftLeftOut,  BranchTargetAddr);    
    
    //9- pc adder 
    RCANBit RCA2(PCOut, 32'd4,PCPlus4);
    assign PCIn= (branch&zeroFlag)?BranchTargetAddr:PCPlus4;
    

    
    // call on Test16BitOut here
endmodule
