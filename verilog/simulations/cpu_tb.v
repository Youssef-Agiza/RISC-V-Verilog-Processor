module datapath_tb();
      reg rclk;
      reg rst;
      wire [31:0] PCOut;
      wire [31:0] BranchTargetAddr;
      wire [31:0] PCIn;
      wire [31:0] rs1Read;
      wire [31:0] rs2Read;
      wire [31:0] regFileIn;
      wire [31:0] imm;
      wire [31:0] shiftLeftOut;
      wire [31:0] ALU2ndSrc;
      wire [31:0] ALU1stSrc;
      wire [31:0] ALUOut;
      wire [31:0] memoryOut;
      wire [31:0] instruction;
      wire branch;
      wire MemRead;
      wire MemtoReg;
      wire MemWrite;
      wire  ALUSrc1;
      wire  ALUSrc2; 
      wire RegWrite;
     Datapath dp(
              rclk, rst, PCOut, BranchTargetAddr, PCIn,
              rs1Read,rs2Read, regFileIn, imm,shiftLeftOut,
              ALU1stSrc, ALU2ndSrc, ALUOut,memoryOut,
              instruction, branch, MemRead, MemtoReg,
              MemWrite, ALUSrc1, ALUSrc2, RegWrite);
     
     initial rclk=1'b0;
    always #10 rclk=~rclk;
  initial begin
    rst=1'b1;
    #10
    rst=1'b0;
  end
        
endmodule
