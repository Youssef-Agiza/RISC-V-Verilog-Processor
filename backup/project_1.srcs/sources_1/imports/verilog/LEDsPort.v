`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/19/2021 12:00:28 PM
// Design Name: 
// Module Name: LEDsPort
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module LEDsPort(input [31:0]instruction, input [13:0] controlSignals,input [1:0]ledSel, output reg[15:0] LEDs);
        
    always @(*)begin
        case (ledSel) 
            2'b00: LEDs= instruction[15:0];
            2'b01: LEDs= instruction[31:16];
            2'b10: LEDs= {2'b00,controlSignals};
            2'b11: LEDs= 16'b0;
        endcase
             
    end
   endmodule
