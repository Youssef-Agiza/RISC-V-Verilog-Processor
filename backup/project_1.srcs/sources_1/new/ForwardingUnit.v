module ForwardingUnit (input [4:0] ID_EX_rs1,
                        input [4:0] ID_EX_rs2,
                        input [4:0] EX_MEM_rd,
                        input [4:0] MEM_WB_rd,
                        input EX_MEM_regwrite,
                        input MEM_WB_regwrite,
                        output reg [1:0] forwardA,
                        output reg [1:0] forwardB);


//MEM HAZARD
//if (MEM/WB.RegWrite and (MEM/WB.RegisterRd ? 0)?  
//	and (MEM/WB.RegisterRd = ID/EX.RegisterRs1))  
//   		and not (EX/MEM.RegWrite and (EX/MEM.RegisterRd ? 0)?                    
//            		and (EX/MEM.RegisterRd = ID/EX.RegisterRs1))?    
//   ?  	forwardA = 01
//if (MEM/WB.RegWrite and (MEM/WB.RegisterRd ? 0)?    
//	and (MEM/WB.RegisterRd = ID/EX.RegisterRs2))?
//   		and not (EX/MEM.RegWrite and (EX/MEM.RegisterRd ? 0)?                 
//            		and (EX/MEM.RegisterRd = ID/EX.RegisterRs2))?    
//     	forwardB = 01



//if (EX/MEM.RegWrite and (EX/MEM.RegisterRd ? 0)?    
//   		and (EX/MEM.RegisterRd = ID/EX.RegisterRs1))?  
//	forwardA = 10
//if (EX/MEM.RegWrite and (EX/MEM.RegisterRd ? 0)?    
//  		 and (EX/MEM.RegisterRd = ID/EX.RegisterRs2))?  
//	forwardB = 10



always @(*)
begin
forwardA=2'b00;
forwardB=2'b00;


//alu
//if (EX_MEM_regwrite & (EX_MEM_rd !=0)
//    & (EX_MEM_rd == ID_EX_rs1))
//    forwardA=2'b10;
//else
 if ((MEM_WB_regwrite & (MEM_WB_rd !=0)) 
         & (MEM_WB_rd == ID_EX_rs1) )
//         &!(EX_MEM_regwrite & (EX_MEM_rd !=0))
//         & (EX_MEM_rd == ID_EX_rs1))
     forwardA=2'b01;
        
else forwardA=2'b00;
        
         
         
//if (EX_MEM_regwrite & (EX_MEM_rd !=0)
//        & (EX_MEM_rd == ID_EX_rs2))
//     forwardB=2'b10;
//else 
if ((MEM_WB_regwrite & (MEM_WB_rd !=0)) 
          & (MEM_WB_rd == ID_EX_rs2) )
//          &!(EX_MEM_regwrite & (EX_MEM_rd !=0))
//          & (EX_MEM_rd == ID_EX_rs2))
          forwardB=2'b01;
else  forwardB=2'b00;



end









endmodule 