//------------------------------------------------------------------------
// Copyright (c) 2009, HHIC
// HHIC Confidential Proprietary
//------------------------------------------------------------------------
// FILE NAME :cen_wen.v
// TYPE : module
// DEPARTMENT : Design
// AUTHOR :  Shuang Li
// AUTHOR  S EMAIL : lishuang@hhic.com
//------------------------------------------------------------------------
// Release history
// VERSION | Date     | AUTHOR       |  DESCRIPTION
// 0.1     | 09/4/23  | Shuang Li    |  combination logic for ram/rom interface
//------------------------------------------------------------------------
// PURPOSE :
//------------------------------------------------------------------------
// PARAMETERS
// PARAM NAME RANGE : DESCRIPTION : DEFAULT : VA UNITS
// N.A.
//------------------------------------------------------------------------
// REUSE ISSUES : N.A.
// Reset Strategy : N.A.
// Clock Domains : N.A.
// Critical Timing : N.A.
// Test Features : N.A.
// Asynchronous I/F : N.A.
// Scan Methodology : N.A.
// Instantiations : N.A.
//
//------------------------------------------------------------------------

module cen_wen(
       sys_clk,
       sys_rst,
       wr     ,
       rd     ,
       cen    ,
       wen    ,
       memrd  ,
       memrd_s
       );

input wr;
input rd;

input sys_clk;
input sys_rst;

input  memrd;
output memrd_s;

output cen;
output wen;

assign cen = ~(wr | rd);
assign wen = ~wr       ;

//delay memrd       
reg    memrd_d; 
always @(posedge sys_clk or posedge sys_rst) begin
    if(sys_rst)
      memrd_d <= 1'b0;
    else
      memrd_d <= memrd;
end       

//memrd from 8051 is 2 sys_clk cycle
//output memrd_s as 1 sys_clk cycle for peripheral use
reg    memrd_s; //combinational logic
always @(*) begin
    if((memrd==1'b1) && (memrd_d==1'b0))
      memrd_s = 1'b1;
    else
      memrd_s = 1'b0;  
end
      
endmodule
