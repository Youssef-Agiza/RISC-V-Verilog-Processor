`include "defines.v"

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
		output [31:0] ALU1stSrc,
        output [31:0] ALU2ndSrc,
        output [31:0] ALUOut,
        output [31:0] memoryOut,
        output [31:0] IR,
        output branch,
        output MemRead,
        output MemtoReg,
        output MemWrite,
		output ALUSrc1, // this is the selection line for ALU 1st input
        output ALUSrc2,
        output RegWrite
    );
    
    wire [2:0] ALUOp;
    wire [3:0]ALUSelection;
    wire zf,cf,sf,vf;
    wire [31:0] PCPlus4;
	wire jump;
    wire [31:0] rdSrc;
    wire BCUOut;
    wire pcLoad;


//******************** IF_ID *********************///
    wire [31:0] IF_ID_PC;
    wire [31:0] IF_ID_PC_PLUS4;
    wire [31:0] IF_ID_INST;

	 
 //******************** ID_EX *********************/// 
        
    
     wire [31:0] ID_EX_PC;
    wire [31:0] ID_EX_PC_PLUS4;
    wire [31:0] ID_EX_READ_DATA1;
    wire [31:0] ID_EX_READ_DATA2;
    wire [31:0] ID_EX_IMM;
    wire [2:0] ID_EX_F3;
    wire  [6:0] ID_EX_F7;
    wire [4:0] ID_EX_RD;
    
    
     //******************** EX_MEM *********************///
    wire ID_EX_BRANCH,ID_EX_MEM_READ, ID_EX_MEM_TO_REG,
         ID_EX_MEM_WRITE,ID_EX_ALU_SRC1, ID_EX_ALU_SRC2,
         ID_EX_REG_WRITE,ID_EX_JUMP;
    wire [2:0] ID_EX_ALU_OP;
    
    
        
      wire [31:0] EX_MEM_PC ;                                  
    wire [31:0] EX_MEM_PC_PLUS4;                             
    wire  [31:0] EX_MEM_BRANCH_TARGET_ADDRESS;               
    wire [2:0]  EX_MEM_F3;                                   
    wire [31:0]EX_MEM_READ_DATA2;                            
    wire  EX_MEM_BRANCH,   EX_MEM_MEM_READ,EX_MEM_MEM_TO_REG,
          EX_MEM_MEM_WRITE, EX_MEM_REG_WRITE,EX_MEM_JUMP;    
    wire EX_MEM_CF,EX_MEM_ZF,EX_MEM_VF,EX_MEM_SF;            
    wire[31:0] EX_MEM_ALU_OUT;                               
                                                             
     //******************** MEM_WB *********************///                                                      
    wire [31:0] MEM_WB_PC_PLUS4;                             
       wire [31:0] MEM_WB_ALU_OUT;                           
       wire [31:0] MEM_WB_MEMORY_OUT;                        
       wire MEM_WB_MEM_TO_REG, MEM_WB_REG_WRITE, MEM_WB_JUMP;
	 
	  wire [4:0] EX_MEM_RD;
	  wire [4:0]MEM_WB_RD ;
	 
	 //*****************Forwarding*******************//
	  wire stall;
	  wire [1:0] forwardA;
	  wire [1:0] forwardB;
      wire [32:0] RS2_forwarded;

	 
	 
	 RCANBit RCA2(PCOut, 32'd4,PCPlus4,x);
	 
	 
    RegisterNBit PCReg(clk,rst,PCIn,pcLoad, PCOut );
     //1- IR mem
       InstMem instMem(PCOut[13:2],IR);
        assign pcLoad=(~(`OPCODE==`OPCODE_FENCE)&&~(`OPCODE==`OPCODE_SYSTEM));
      
     
        RegisterNBit #(.N(96)) IF_ID( .clk(~clk),.rst(rst),
                              .D({PCOut,PCPlus4,IR}), .load(1'b1), 
                               .Q({IF_ID_PC,IF_ID_PC_PLUS4,IF_ID_INST})); 
         
   //******************** ID_EX *********************///
   
   
   
      
    
    
   
    //3- Control unit
    controlUnit CU(IF_ID_INST[6:0], branch, MemRead,MemtoReg, ALUOp,MemWrite,  ALUSrc1, ALUSrc2, RegWrite, jump);

    //4- IMM Gen
    rv32_ImmGen immGen(IF_ID_INST,imm); 
  //2- RF
     RegFile regFile(~clk, rst, IF_ID_INST[`IR_rs1], IF_ID_INST[`IR_rs2], MEM_WB_RD, 
                                regFileIn,  MEM_WB_REG_WRITE, rs1, rs2 ); //regWrite enables writing
           //////////////////////////////////////////////////////////////////////////////////
           //////////////////////////////////// Change  RefFileIn  //////////////////////////////////////////////
           //////////////////////////////////////////////////////////////////////////////////
           //////////////////////////////////////////////////////////////////////////////////
           
           
           
         
              RegisterNBit #(.N(186)) ID_EX( .clk(clk),.rst(rst), //should be .N(179)
                                    
                                    .D({
                                    //PC's
                                    IF_ID_PC,IF_ID_PC_PLUS4,
                                       //read data 1, read data 2
                                       rs1, rs2,
                                     //funcs
                                     IF_ID_INST[`IR_funct3],IF_ID_INST[`IR_funct7],
                                       //imm/rd
                                       imm, IF_ID_INST[`IR_rd],
                                       //ctrls
                                     branch, MemRead,MemtoReg,
                                     MemWrite,ALUSrc1, ALUSrc2,
                                     RegWrite, jump,
                                      ALUOp
                                    }),
                                    
                                    .Q({
                                         //PC's
                                       ID_EX_PC, ID_EX_PC_PLUS4,
                                        //read data 1, read data 2
                                      ID_EX_READ_DATA1,  ID_EX_READ_DATA2,
                                      //funcs
                                      ID_EX_F3,ID_EX_F7,
                                      //imm/rd
                                       ID_EX_IMM,ID_EX_RD, 
                                       
                                       //ctrls
                                       ID_EX_BRANCH,ID_EX_MEM_READ, ID_EX_MEM_TO_REG,
                                       ID_EX_MEM_WRITE,ID_EX_ALU_SRC1, ID_EX_ALU_SRC2,
                                       ID_EX_REG_WRITE,ID_EX_JUMP,
                                        ID_EX_ALU_OP
                                       }), .load(1'b1) 
                                     );   
  //******************** EX_MEM start*********************///

 
	// MUX for ALU srcs input
	assign ALU1stSrc = (ID_EX_ALU_SRC1)? ID_EX_PC:ID_EX_READ_DATA1;
    assign ALU2ndSrc=(ID_EX_ALU_SRC2)?ID_EX_IMM:ID_EX_READ_DATA2;

    //5- ALU control
    ALUControlUnit ALUControl(ID_EX_ALU_OP,  ID_EX_F3, ID_EX_F7 ,ALUSelection);
    
    //6- ALU 
    prv32_ALU ALU(.a(ALU1stSrc), .b(ALU2ndSrc), .shamt(ALU2ndSrc[4:0]),
                  .cf(cf), .zf(zf), .vf(vf), .sf(sf)
                 , .alufn(ALUSelection), .r(ALUOut));
 //8- shift and adder
  RCANBit RCA( ID_EX_PC,  ID_EX_IMM,  BranchTargetAddr, y); 
  
 
 
 
 
 
 
 
 
 
 
 
 
 

 
      
  
   RegisterNBit #(.N(178)) EX_MEM( .clk(~clk),.rst(rst), .load(1'b1),
                          
                          .D({
                          //PC's
                          ID_EX_RD,
                           ID_EX_PC, IF_ID_PC_PLUS4,
                           
                           BranchTargetAddr,
                           
                           //Ctrls
                            ID_EX_BRANCH,    ID_EX_MEM_READ,   ID_EX_MEM_TO_REG,
                            ID_EX_MEM_WRITE, ID_EX_REG_WRITE,  ID_EX_JUMP,
                            
                            
                            ID_EX_F3,
                            ID_EX_READ_DATA2,
                            //ALU Flags
                             cf, zf, vf, sf,
                             //alu output
                              ALUOut
                           }),    
                          .Q({EX_MEM_RD,
                          EX_MEM_PC,EX_MEM_PC_PLUS4,
                            
                            EX_MEM_BRANCH_TARGET_ADDRESS,
                                
                             EX_MEM_BRANCH,    EX_MEM_MEM_READ,   EX_MEM_MEM_TO_REG, 
                             EX_MEM_MEM_WRITE, EX_MEM_REG_WRITE,  EX_MEM_JUMP,

                             EX_MEM_F3,
                             EX_MEM_READ_DATA2,
                             
                             EX_MEM_CF, EX_MEM_ZF, EX_MEM_VF, EX_MEM_SF,
                             EX_MEM_ALU_OUT }) ); 
     

//******************** EX_MEM end *********************///

    
    //7- Data mem
    DataMem dataMem( .clk(clk), .rst(rst), .F3(EX_MEM_F3),
                     .mem_read(EX_MEM_MEM_READ),  .mem_write(EX_MEM_MEM_WRITE),
                     .addr(EX_MEM_ALU_OUT[11:0]),  
                     .data_in(EX_MEM_READ_DATA2), .data_out(memoryOut));

   
    
   	MUX4x1 PCInMux (PCPlus4,EX_MEM_BRANCH_TARGET_ADDRESS,
   	                EX_MEM_ALU_OUT,EX_MEM_ALU_OUT, 
   	                {EX_MEM_JUMP,EX_MEM_BRANCH}, PCIn);
//          assign PCIn=BCUOut?EX_MEM_ALU_OUT:(jump)?ALUOut:PCPlus4;


	//9- Branch Control Unit
	BCU bcu(.zf(EX_MEM_ZF), .cf(EX_MEM_CF),.sf(EX_MEM_SF), .vf(EX_MEM_VF),
	       .funct3(EX_MEM_F3) ,.branchSignal(EX_MEM_BRANCH) , .PCSrc(BCUOut));
    // BCUOut is now S0
	
//       assign PCIn= (branch&zf)?BranchTargetAddr:PCPlus4;

    assign rdSrc=(jump)?ALUOut:PCPlus4; // mux between auipc/ALU and Jal rd(pc +4)
  
  
   
 RegisterNBit #(.N(300)) MEM_WB(.clk(clk),.rst(rst), .load(1'b1),
                                 .D({EX_MEM_RD,
                                 EX_MEM_PC_PLUS4,
                                 //flags
                                 EX_MEM_MEM_TO_REG,EX_MEM_REG_WRITE,  EX_MEM_JUMP,     

                                 //alu
                                 EX_MEM_ALU_OUT,
                                 
                                 //mem
                                 memoryOut
                                  }),    
                                  .Q({MEM_WB_RD,
                                    MEM_WB_PC_PLUS4,
                                  
                                   MEM_WB_MEM_TO_REG, MEM_WB_REG_WRITE,MEM_WB_JUMP,
                                   
                                   MEM_WB_ALU_OUT,
                                   
                                   MEM_WB_MEMORY_OUT
                                  
                                  }) );  
  	
  	MUX4x1 RegFileInMux (MEM_WB_ALU_OUT,MEM_WB_MEMORY_OUT,
                         MEM_WB_PC_PLUS4,MEM_WB_PC_PLUS4,
                        {MEM_WB_JUMP,MEM_WB_MEM_TO_REG}, regFileIn);
//  assign regFileIn= (jump)?PCPlus4:(MemtoReg)?memoryOut:ALUOut;

    
endmodule
