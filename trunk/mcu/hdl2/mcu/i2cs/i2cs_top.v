//+FHDR-------------------------------------------------------------------
// Copyright (c) 2007, HHIC
// HHIC Confidential Proprietary
//------------------------------------------------------------------------
// FILE NAME : i2cm_top
// TYPE : module
// DEPARTMENT : design
// AUTHOR : Shuang Li
// AUTHOR  S EMAIL : lishuang@hhic.com
//------------------------------------------------------------------------
// Release history
// VERSION   Date   AUTHOR    DESCRIPTION
// 1.0     Aug.14  lishuang  initial version
//------------------------------------------------------------------------
// PURPOSE : top module of i2c slave
//------------------------------------------------------------------------
// PARAMETERS
// PARAM NAME RANGE : DESCRIPTION : DEFAULT : VA UNITS
//------------------------------------------------------------------------
// REUSE ISSUES
// reset Strategy :
// Clock Domains :
// Critical Timing :
// Test Features :
// Asynchronous I/F :
// Scan Methodology :
// Instantiations :
// Other :
//-FHDR-------------------------------------------------------------------



module i2cs_top (
  sys_clk,
  sys_rst,
  io_resetb,

  sda_oe,
  sda_in,
  sda_out,
  scl,
  i2ca,

  rab_write,
  rab_read,
  rab_addr,
  rab_wdata,
  rab_ack,
  rab_rdata,
  
  ana_all_reg,
  scan_mode

);

parameter DEVADDR0_CI2CA_HIGH = 8'h76;
parameter DEVADDR1_CI2CA_HIGH = 8'h7e;
parameter DEVADDR0_CI2CA_LOW  = 8'h72;
parameter DEVADDR1_CI2CA_LOW  = 8'h7a;

parameter ANA_ALL_ON_ADDR     = 9'h012;

input  sys_clk;
input  sys_rst;
input  io_resetb;

input  scl;
input  sda_in;
output sda_out;
output sda_oe;
input  i2ca;

output rab_write;
output rab_read;
output [8:0] rab_addr;
output [7:0] rab_wdata;
input        rab_ack;
input  [7:0] rab_rdata;

output       ana_all_reg;

input        scan_mode;

reg    [7:0] devAddr0;
reg    [7:0] devAddr1;

reg          wr_d0;
reg          wr_d1;
reg          wr_d2;
reg          rd_d0;
reg          rd_d1;
reg          rd_d2;
reg    [7:0] rdata_store;

reg    [7:0] rab_wdata;
reg    [7:0] wdata_d  ;

reg    [8:0] rab_addr ;
reg    [8:0] addr_d   ;

reg          rab_write;
reg          rab_read ;

reg          ana_all_reg;

wire         wrStrobe;
wire         rdStrobe;
wire   [7:0] data_o  ;
wire   [8:0] addr_o  ;
wire         sda_out ;
wire         sda_oe  ;
wire         sda_oen ;

//assign sda_out = 1'b0;
assign sda_out = sda_oen;
assign sda_oe  = ~sda_oen;

always @(posedge scl or negedge io_resetb) begin
  if(!io_resetb) 
    ana_all_reg <= 1'b0;
  else begin
    if((addr_o==ANA_ALL_ON_ADDR) && (wrStrobe&(~wr_d0)))
      ana_all_reg <= data_o[0];
  end 
end


//select device address
always @(*)
  if(i2ca)  begin
    devAddr1 = DEVADDR1_CI2CA_HIGH;
    devAddr0 = DEVADDR0_CI2CA_HIGH;
  end
  else  begin
    devAddr1 = DEVADDR1_CI2CA_LOW ;
    devAddr0 = DEVADDR0_CI2CA_LOW ;
  end

//sync wrStrobe to sys_clk
always @(posedge sys_clk or posedge sys_rst) begin
    if(sys_rst) begin
        wr_d0 <= 1'b0;
        wr_d1 <= 1'b0;
        wr_d2 <= 1'b0;
    end
    else    begin
        wr_d0 <= wrStrobe;
        wr_d1 <= wr_d0;
        wr_d2 <= wr_d1;
    end
end

always @(posedge sys_clk or posedge sys_rst) begin
    if(sys_rst) begin
        rab_write <= 1'b0;
    end
    else begin
        rab_write <= wr_d1 & (~wr_d2);
    end
end
    
        

//sync rdStrobe to sys_clk
always @(posedge sys_clk or posedge sys_rst) begin
    if(sys_rst) begin
        rd_d0 <= 1'b0;
        rd_d1 <= 1'b0;
        rd_d2 <= 1'b0;
    end
    else    begin
        rd_d0 <= rdStrobe;
        rd_d1 <= rd_d0;
        rd_d2 <= rd_d1;
    end
end

always @(posedge sys_clk or posedge sys_rst) begin
    if(sys_rst) begin
        rab_read <= 1'b0;
    end
    else begin
        rab_read <= rd_d1 & (~rd_d2);
    end
end


//delay data_o
always @(posedge sys_clk or posedge sys_rst) begin
    if(sys_rst) begin
        rab_wdata <= 8'h0;
        wdata_d   <= 8'h0;
    end
    else    begin
        wdata_d   <= data_o;
        rab_wdata <= wdata_d;
    end
end

//delay addr_o
always @(posedge sys_clk or posedge sys_rst) begin
    if(sys_rst) begin
        rab_addr <= 9'h0;
        addr_d   <= 9'h0;
    end
    else    begin
        addr_d   <= addr_o;
        rab_addr <= addr_d;
    end
end

//store rab_rdata
always @(posedge sys_clk or posedge sys_rst) begin
    if(sys_rst) begin
        rdata_store <= 8'h0;
    end
    else if(rab_ack) begin
        rdata_store <= rab_rdata;
    end
end


i2cs_serial u_i2cs_serial(
          .porb         (io_resetb  )     ,
          .sys_clk      (sys_clk) ,
          //.rst          (sys_rst   )     ,
          .scl_tmp          (scl       )     ,
          .sdaclkin_tmp     (sda_in    )     ,
          .sdain        (sda_in    )     ,
          .sdaout       (sda_oen   )     ,
          .devAddr0     (devAddr0[7:1]  )     ,
          .devAddr1     (devAddr1[7:1]  )     ,
          .regAddr_o    (addr_o    )     ,
          .data_i       (rdata_store)    ,
          .data_o       (data_o    )     ,
          .data_oe      ()     ,
          .wrStrobe     (wrStrobe  )     ,
          .wrStrobe_st  ()     ,
          .rdStrobe     (rdStrobe  )     ,
          .rdClk        ()     ,
          .scanMode     (scan_mode )


          );





endmodule
