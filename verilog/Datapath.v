module Datapath(
        input clk,
        input rst,
        output [31:0] PCOut,
        output [31:0] BranchTargetAddr,
        output [31:0] PCIn,
        output [31:0] rs1,
        output [31:0] rs2,
        output [31:0] regFileIn,
        output [31:0] imm,
        output [31:0] shiftLeftOut,
		output [31:0] ALU1stSrc
        output [31:0] ALU2ndSrc,
        output [31:0] ALUOut,
        output [31:0] memoryOut,
        output [31:0] IR,
        output branch,
        output MemRead,
        output MemtoReg,
        output MemWrite,
		output ALUSrc1, // this is the selection line for ALU 1st input
        output ALUSrc,
        output RegWrite
    );
    
    wire [1:0] ALUOp;
    wire [3:0]ALUSelection;
    wire zf,cf,sf,vf;
    wire [31:0] PCPlus4;



    RegisterNBit PCReg(clk,rst,PCIn,1, PCOut );

    

    //1- IR mem
    InstMem instMem(PCOut[7:2],IR);
        
    //2- RF
    RegFile regFile(clk, rst, IR[`IR_rs1], IR[`IR_rs2], IR[`IR_rd], regFileIn,  RegWrite, rs1, rs2 ); //regWrite enables writing
     
    //3- Control unit
    controlUnit CU( `OPCODE, branch, MemRead,MemtoReg, ALUOp,MemWrite,  ALUSrc1, ALUSrc, RegWrite);

	// MUX for ALU 1st input
	assign ALU1stSrc = (ALUSrc1)?PCOut:rs1Read;
    
    //4- IMM Gen
    rv32_ImmGen immGen(IR,imm);    
    assign ALU2ndSrc=(ALUSrc)?imm:rs2;

    //5- ALU control
    ALUControlUnit ALUControl(ALUOp, IR[`IR_funct3],IR[`IR_funct7],ALUSelection);
    
    //6- ALU 
    prv32_ALU ALU(.a(ALU1stSrc), .b(ALU2ndSrc), .shamt(ALU2ndSrc[4:0]),
                  .cf(cf), .zf(zf), .vf(vf), .sf(sf)
                 , .alufn(ALUSelection), .r(ALUOut));

);

  
    
    //7- Data mem
    DataMem dataMem( .clk(clk), .rst(rst), .F3(IR[`IR_funct3]),
                     .mem_read(MemRead),  .mem_write(MemWrite),
                     .addr(ALUOut [7:2]),  
                     .data_in(rs2), .data_out(memoryOut));

    assign regFileIn= (MemtoReg)?memoryOut:ALUOut;
    
    //8- shift and adder
    ShiftLeftNBit shifter(imm,shiftLeftOut);
    RCANBit RCA( PCOut,  shiftLeftOut,  BranchTargetAddr);    
    
    //9- pc adder 
    RCANBit RCA2(PCOut, 32'd4,PCPlus4);
    assign PCIn= (branch&zf)?BranchTargetAddr:PCPlus4;
    

    
endmodule
