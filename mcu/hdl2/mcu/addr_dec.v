//------------------------------------------------------------------------
// Copyright (c) 2009, HHIC
// HHIC Confidential Proprietary
//------------------------------------------------------------------------
// FILE NAME :addr_dec.v
// TYPE : module
// DEPARTMENT : Design
// AUTHOR :  Shuang Li
// AUTHOR  S EMAIL : lishuang@hhic.com
//------------------------------------------------------------------------
// Release history
// VERSION | Date     | AUTHOR       |  DESCRIPTION
// 0.1     | 09/4/21  | Shuang Li    |  MCU address decoder
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

module addr_dec (
       memaddr       ,
       memwr         ,
       memrd         ,
       memdata_r     ,
       memdata_w     ,
       dataram_rdata ,
       dataram_wdata ,
       dataram_addr  ,
       dataram_write ,
       dataram_read  ,
       mcu_rab_ack   ,
       mcu_rab_rdata ,
       mcu_rab_wdata ,
       mcu_i2c_addr  ,
       mcu_rab_write ,
       mcu_rab_read   
       );
       
///////////////////////////////////////////////////////////////////////////////
// parameters
///////////////////////////////////////////////////////////////////////////////
`include "binhai_global_parameters.v"

///////////////////////////////////////////////////////////////////////////////
// Input and outputs
///////////////////////////////////////////////////////////////////////////////

//input         clk          ;
//input         rst          ;

input  [15:0] memaddr      ;                    // memory address
input         memwr        ;                    // memory write
input         memrd        ;                    // memory read
input  [ 7:0] memdata_r    ;                    // data read from memory
output [ 7:0] memdata_w    ;                    // data write to memory  

input  [ 7:0] dataram_rdata;                  // data from ram
output [ 7:0] dataram_wdata;                  // data to ram
output [11:0] dataram_addr ;                    // ram address

output        dataram_write;                    // ram write
output        dataram_read ;                    // ram read

input         mcu_rab_ack  ;
input  [ 7:0] mcu_rab_rdata;
output [ 7:0] mcu_rab_wdata;
output [RAB_ADDR_WIDTH-1:0]  mcu_i2c_addr ;     // address of registers accessed by i2c
output                       mcu_rab_write;     // i2c write, access register, through arbiter
output                       mcu_rab_read ;     // i2c read, access register, through arbiter


//combination logics
reg        mcu_rab_write;
reg        mcu_rab_read ;
reg        dataram_write;
reg        dataram_read ;
reg [ 7:0] memdata_w    ;



//address 
assign mcu_i2c_addr = memaddr[RAB_ADDR_WIDTH-1:0];
assign dataram_addr = memaddr[11:0]              ; 

   
//write/read
always @(memaddr or memwr or memrd)
  if(memwr | memrd) begin
//    if(memaddr[15:12] == 4'b0)
//    begin
//      if(memaddr[11:9]==3'h7) begin             // memaddr==13'h0E00~13'h0Fff
      if(memaddr[15:9]==7'h7f) begin             // memaddr==16'hfe00~16'hffff
         mcu_rab_write = memwr;
         mcu_rab_read  = memrd;
         dataram_write = 1'b0 ;
         dataram_read  = 1'b0 ;
         
      end
      else if(memaddr[15:12]==4'h0)  begin        // memaddr==16'h000~16'h0fff   
         dataram_write = memwr; 
         dataram_read  = memrd;
         mcu_rab_write = 1'b0 ;
         mcu_rab_read  = 1'b0 ;
      end     
//    end
      else
      begin
        mcu_rab_write = 1'b0;
        mcu_rab_read  = 1'b0;
        dataram_write = 1'b0;
        dataram_read  = 1'b0;
      end
  end
  else
  begin
    mcu_rab_write = 1'b0;
    mcu_rab_read  = 1'b0;
    dataram_write = 1'b0;
    dataram_read  = 1'b0;
  end


//data

//wdata
assign dataram_wdata = memdata_r;
assign mcu_rab_wdata = memdata_r;
      
//rdata
always @(mcu_rab_ack or mcu_rab_rdata or dataram_rdata )
  if(mcu_rab_ack ) 
      memdata_w = mcu_rab_rdata ;
  else 
      memdata_w = dataram_rdata ; 
        
       
endmodule
