//------------------------------------------------------------------------
// Copyright (c) 2009, HHIC
// HHIC Confidential Proprietary
//------------------------------------------------------------------------
// FILE NAME : e2prom.v
// TYPE : module
// DEPARTMENT : MM
// AUTHOR :  John Guan
// AUTHOR'S EMAIL : zhiyong.guan@shhic.com
//------------------------------------------------------------------------
// Release history
// VERSION | Date     | AUTHOR       |  DESCRIPTION
// 0.1     | 09/6/16  | John Guan    |
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

module e2prom(
          sys_clk,
          sys_rst,

          scl,
          sda


          );

///////////////////////////////////////////////////////////////////////////////
// parameters
///////////////////////////////////////////////////////////////////////////////
//`include "binhai_global_parameters.v"

///////////////////////////////////////////////////////////////////////////////
// Input and outputs
///////////////////////////////////////////////////////////////////////////////

input sys_clk;
input sys_rst;

input scl;
inout sda;


///////////////////////////////////////////////////////////////////////////////
// Descriptions
///////////////////////////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////////////////////////
// instance I2CS
///////////////////////////////////////////////////////////////////////////////

defparam i2cs_inst.DEVADDR0_CI2CA_LOW     = 8'ha0;
defparam i2cs_inst.DEVADDR1_CI2CA_LOW     = 8'ha2;

wire sda_out;
wire sda_oe;
wire sda_in;

assign sda_in = sda;
assign sda = sda_oe ? sda_out : 1'bz;

wire [8:0] rab_addr;
wire [7:0] rab_wdata;
wire rab_write;
wire rab_read;
reg rab_ack;
wire [7:0] rab_rdata;

i2cs_top i2cs_inst(
      .sys_clk    (sys_clk  ) ,
      .sys_rst    (sys_rst  ) ,
      .sda_in     (sda_in   ) ,
      .sda_out    (sda_out  ) ,
      .sda_oe     (sda_oe   ) ,
      .scl        (scl      ) ,
      .i2ca       (1'b0     ) ,

      .rab_addr   (rab_addr ) ,
      .rab_write  (rab_write) ,
      .rab_read   (rab_read ) ,
      .rab_wdata  (rab_wdata) ,
      .rab_rdata  (rab_rdata) ,
      .rab_ack    (rab_ack  )
      );

///////////////////////////////////////////////////////////////////////////////
// instance E2PROM ROM
///////////////////////////////////////////////////////////////////////////////
e2prom_rom e2prom_rom_inst(
      .Q    (rab_rdata) ,
      .CLK  (sys_clk)   ,
      .CEN  (!rab_read) ,
      .A    (rab_addr)
      );


///////////////////////////////////////////////////////////////////////////////
// ack generation
///////////////////////////////////////////////////////////////////////////////
always @(posedge sys_clk or posedge sys_rst)
begin
  if(sys_rst)
  begin
    rab_ack <= 1'b0;
  end
  else
  begin
    rab_ack <= rab_read;
  end
end


endmodule
