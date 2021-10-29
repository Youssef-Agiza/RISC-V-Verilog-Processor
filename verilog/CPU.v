

module CPU(input rclk,
         input ssdclk,
         input rst,
         input [1:0]ledSel,
          input [3:0]ssdSel,
          output[3:0] AN,
           output [6:0] segOut ,
           output [15:0] LED);
         
  wire [31:0] PCOut; 
  wire [31:0] BranchTargetAddr;
  wire [31:0] PCIn;
  wire [31:0] rs1Read;
  wire [31:0] rs2Read;
  wire [31:0] regFileIn;
  wire [31:0] imm;
  wire [31:0] shiftLeftOut;
  wire [31:0] ALU2ndSrc;
  wire [31:0] ALUOut;
  wire [31:0] memoryOut;     
  wire [31:0] instruction;      
  wire branch,MemRead,MemtoReg,MemWrite,ALUSrc,RegWrite;
    wire [12:0] test13BitOut;

  Datapath dp(rclk,
                rst,
                 PCOut,
                 BranchTargetAddr,
                 PCIn,
                 rs1Read,
                 rs2Read,
                 regFileIn,
                 imm,
                 shiftLeftOut,
                 ALU2ndSrc,
                 ALUOut,
                 memoryOut,
                 instruction,
                  branch,
                   MemRead,
                  MemtoReg,
                  MemWrite,
                  ALUSrc,
                  RegWrite
                 );
                 
        LEDsPort leds( instruction, {5'd0, branch,MemRead,MemtoReg,MemWrite,ALUSrc,RegWrite}, ledSel,  LED);
        Test13BitOut test13Bit(
                      PCOut,
                 BranchTargetAddr,
                   PCIn,
                 rs1Read,
                 rs2Read,
                regFileIn,
                 imm,
                shiftLeftOut,
                ALU2ndSrc,
                 ALUOut,
                memoryOut,
                 ssdSel,
                test13BitOut);
                 
        Four_Digit_Seven_Segment_Driver_Optimized FDSSD(ssdclk, test13BitOut,AN,segOut);
        
      
endmodule
