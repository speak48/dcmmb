module sram146880x6 (                             
	CLK,                                       
	A,                                         
	CEN,                                       
	WEN,                                       
	D,                                         
	Q                                          
);                                             

parameter  A_WID = 18,
           D_WID = 6;


input             CLK;                               
input [A_WID-1:0] A;                                 
input [D_WID-1:0] D;                                             
input             CEN;                                     
input             WEN;                                     
                                               
output [D_WID-1:0] Q;                                
reg    [D_WID-1:0] Q;                                   
/*********************************************/
/* this part should be replaced by ASIC sram */
reg    [D_WID-1:0] mem [0:146879];                         
always @ ( posedge CLK )                       
    if(~CEN && ~WEN)                      
        mem[A] <= #1 D;            
                                               
always @ ( posedge CLK )                       
    if(~CEN && WEN)                        
	Q <= #1 mem[A];            
/*********************************************/
				                               
endmodule                                      
			                                   
