//------------------------------------------------------------------------
// Copyright (c) 2009, HHIC
// HHIC Confidential Proprietary
//------------------------------------------------------------------------
// FILE NAME :arbiter.v
// TYPE : module
// DEPARTMENT : Design
// AUTHOR :  Shuang Li
// AUTHOR¡¯S EMAIL : lishuang@hhic.com
//------------------------------------------------------------------------
// Release history
// VERSION | Date     | AUTHOR       |  DESCRIPTION
// 0.1     | 09/4/15  | Shuang Li    |  I2CS and MCU access arbiter
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

module arbiter(
          sys_clk,
          sys_rst,

          mcu_rab_write,
          mcu_rab_read,
          mcu_rab_addr,
          mcu_rab_wdata,
          mcu_rab_ack,
          mcu_rab_rdata,

          i2cs_rab_write,
          i2cs_rab_read,
          i2cs_rab_addr,
          i2cs_rab_wdata,
          i2cs_rab_ack,
          i2cs_rab_rdata,

          rab_write,
          rab_read,
          rab_addr,
          rab_wdata,
          rab_ack,
          rab_rdata

          );

///////////////////////////////////////////////////////////////////////////////
// parameters
///////////////////////////////////////////////////////////////////////////////
`include "hq_global_parameter.v"

///////////////////////////////////////////////////////////////////////////////
// Input and outputs
///////////////////////////////////////////////////////////////////////////////

input sys_clk;
input sys_rst;

//MCU access signals
input  mcu_rab_write;
input  mcu_rab_read;
input  [RAB_ADDR_WIDTH-1:0] mcu_rab_addr;
input  [RAB_DATA_WIDTH-1:0] mcu_rab_wdata;
output                      mcu_rab_ack;
output [RAB_DATA_WIDTH-1:0] mcu_rab_rdata;

//I2CS access signals
input  i2cs_rab_write;
input  i2cs_rab_read;
input  [RAB_ADDR_WIDTH-1:0] i2cs_rab_addr;
input  [RAB_DATA_WIDTH-1:0] i2cs_rab_wdata;
output i2cs_rab_ack;
output [RAB_DATA_WIDTH-1:0] i2cs_rab_rdata;

//RAB bus signals, to every module
output rab_write;
output rab_read;
output [RAB_ADDR_WIDTH-1:0] rab_addr;
output [RAB_DATA_WIDTH-1:0] rab_wdata;
input rab_ack;
input [RAB_DATA_WIDTH-1:0] rab_rdata;



///////////////////////////////////////////////////////////////////////////////
// Descriptions
///////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////
// delay I2CS access requirement if it conflicts with MCU requirement
///////////////////////////////////////////////////////////////////////////////

reg i2c_access_d_valid;     //i2c access signal delayed by one cycle is valid flag
reg i2cs_rab_write_d;       //one cycle delay of i2cs_rab_write
reg i2cs_rab_read_d;        //one cycle delay of i2cs_rab_read
reg [RAB_ADDR_WIDTH-1:0] i2cs_rab_addr_d;   //one cycle delay of i2cs_rab_addr
reg [RAB_DATA_WIDTH-1:0] i2cs_rab_wdata_d;  //one cycle delay of i2cs_rab_wdata
always @(posedge sys_clk or posedge sys_rst)
begin
  if(sys_rst)
  begin
    i2c_access_d_valid <=1'b0;

    i2cs_rab_write_d <= 1'b0;
    i2cs_rab_read_d  <= 1'b0;
    i2cs_rab_addr_d  <= {RAB_ADDR_WIDTH{1'b0}};
    i2cs_rab_wdata_d <= {RAB_DATA_WIDTH{1'b0}};
  end
  else
  begin
    //if I2CS write conflict with MCU access (read or write)
    //I2CS write should delay one cycle
    if(i2cs_rab_write && (mcu_rab_write || mcu_rab_read) )
    begin
      i2c_access_d_valid <= 1'b1;

      i2cs_rab_write_d <= i2cs_rab_write;
      i2cs_rab_addr_d <= i2cs_rab_addr;
      i2cs_rab_wdata_d <= i2cs_rab_wdata;
    end
    //if I2CS read conflict with MCU access (read or write)
    //I2CS read should delay one cycle
    else if(i2cs_rab_read && (mcu_rab_write || mcu_rab_read) )
    begin
      i2c_access_d_valid <= 1'b1;

      i2cs_rab_read_d <= i2cs_rab_read;
      i2cs_rab_addr_d <= i2cs_rab_addr;
    end
    else
    begin
      i2c_access_d_valid <=1'b0;

      i2cs_rab_write_d <= 1'b0;
      i2cs_rab_read_d  <= 1'b0;
      i2cs_rab_addr_d  <= {RAB_ADDR_WIDTH{1'b0}};
      i2cs_rab_wdata_d <= {RAB_DATA_WIDTH{1'b0}};
    end
  end
end


///////////////////////////////////////////////////////////////////////////////
//final arbiter result
//it is combinational logic
///////////////////////////////////////////////////////////////////////////////

reg  rab_write;
reg  rab_read;
reg  [RAB_ADDR_WIDTH-1:0] rab_addr;
reg [RAB_DATA_WIDTH-1:0] rab_wdata;

//rab_write, rab_wdata generation
always @(*)
begin
  //MCU has higher priority
  if(mcu_rab_write)
  begin
    rab_write = mcu_rab_write;
    rab_wdata = mcu_rab_wdata;
  end
  else if(i2cs_rab_write && (!mcu_rab_read) )
  begin
    rab_write = i2cs_rab_write;
    rab_wdata = i2cs_rab_wdata;
  end
  else if(i2c_access_d_valid)
  begin
    rab_write = i2cs_rab_write_d;
    rab_wdata = i2cs_rab_wdata_d;
  end
  else
  begin
    rab_write = 1'b0;
    rab_wdata = {RAB_DATA_WIDTH{1'b0}};
  end
end

//rab_read generation
always @(*)
begin
  //MCU has higher priority
  if(mcu_rab_read)
  begin
    rab_read = mcu_rab_read;
  end
  else if(i2cs_rab_read && (!mcu_rab_write) )
  begin
    rab_read = i2cs_rab_read;
  end
  else if(i2c_access_d_valid)
  begin
    rab_read = i2cs_rab_read_d;
  end
  else
  begin
    rab_read = 1'b0;
  end
end

//rab_addr generation
always @(*)
begin
  //MCU has higher priority
  if(mcu_rab_write || mcu_rab_read)
  begin
    rab_addr = mcu_rab_addr;
  end
  else if(i2cs_rab_write || i2cs_rab_read)
  begin
    rab_addr = i2cs_rab_addr;
  end
  else if(i2c_access_d_valid)
  begin
    rab_addr = i2cs_rab_addr_d;
  end
  else
  begin
    rab_addr = {RAB_ADDR_WIDTH{1'b0}};
  end
end

//read data generation
wire [RAB_DATA_WIDTH-1:0] mcu_rab_rdata;
assign mcu_rab_rdata = rab_rdata;

reg mcu_rab_ack;    //to mask the acknowledge generated by MCU accessing
always @(posedge sys_clk or posedge sys_rst)
begin
  if(sys_rst)
  begin
    mcu_rab_ack <= 1'b0;
  end
  else
  begin
    if(mcu_rab_write || mcu_rab_read)
    begin
      mcu_rab_ack <= 1'b1;
    end
    else
    begin
      mcu_rab_ack <= 1'b0;
    end
  end
end


wire i2cs_rab_ack;
assign i2cs_rab_ack = rab_ack & (!mcu_rab_ack);

wire [RAB_DATA_WIDTH-1:0] i2cs_rab_rdata;
assign i2cs_rab_rdata = rab_rdata;

endmodule
