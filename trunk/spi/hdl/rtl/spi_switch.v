////////////////////////////////////////////////////
//module name:spi_switch
//file name:  spi_switch.v
//version:    1.0
//author:     zxc
//date:       2008.09.08
//function:   spi switch control
///////////////////////////////////////////////////
//revision history

`timescale 1ns/1ns
module spi_switch (
                    rstb_i,               //reset
                    clk_i,                //system clock
                    spi_en_i,             //spi enable
                    master_i,             //master slave switch signal
                    send_data_i,          //send data
                    master_load_end_i,    //master load end
                    slave_load_end_i,     //slave load end
                    master_convey_end_i,  //master convey end
                    slave_convey_end_i,   //slave convey end
                    master_frame_end_i,   //master frame end
                    slave_frame_end_i,    //slave frame end                    
                    master_rcv_data_i,    //master receive data
                    slave_rcv_data_i,     //slave receive data
                    rstb_general_o,       //general reset
                    rstb_master_o,        //master reset
                    rstb_slave_o,         //slave reset  
                    master_send_data_o,   //master send data
                    slave_send_data_o,    //slave send data
                    load_end_o,           //load end signal
                    convey_end_o,         //convey end signal
                    frame_end_o,          //frame end                      
                    rcv_data_o,           //received data  
                    ss_oe_o,              //ss pad output enable
                    sck_oe_o,             //sck pad output enable
                    mosi_oe_o,            //mosi pad output enable
                    miso_oe_o             //miso pad output enable
                  );

input rstb_i;
input clk_i;
input spi_en_i;
input master_i;
input [7:0]send_data_i;
input master_load_end_i;
input slave_load_end_i;
input master_convey_end_i;
input slave_convey_end_i;
input master_frame_end_i;
input slave_frame_end_i;
input [7:0]master_rcv_data_i;
input [7:0]slave_rcv_data_i;

output rstb_general_o;
output rstb_master_o;
output rstb_slave_o;
output [7:0]master_send_data_o;
output [7:0]slave_send_data_o;
output load_end_o;
output convey_end_o;
output frame_end_o;
output [7:0]rcv_data_o;
output ss_oe_o;
output sck_oe_o;
output mosi_oe_o;
output miso_oe_o;

reg ss_oe_o;
reg sck_oe_o;
reg mosi_oe_o;
reg miso_oe_o;



//reset
assign rstb_general_o = rstb_i & spi_en_i;
assign rstb_master_o  = rstb_i & spi_en_i & master_i;
assign rstb_slave_o   = rstb_i & spi_en_i & (~master_i);

//send_data
assign master_send_data_o = master_i ? send_data_i : 8'h00;
assign slave_send_data_o  = master_i ? 8'h00 : send_data_i;

//load_end_o
assign load_end_o = master_i ? master_load_end_i : slave_load_end_i;

//convey_end_o
assign convey_end_o = master_i ? master_convey_end_i : slave_convey_end_i;

//frame_end_o
assign frame_end_o = master_i ? master_frame_end_i : slave_frame_end_i;

//rcv_data_o
assign rcv_data_o = master_i ? master_rcv_data_i : slave_rcv_data_i;

//ss_oe_o
always @(posedge clk_i or negedge rstb_i)
  begin
    if(!rstb_i)
      ss_oe_o <= 1'b0;
    else
      ss_oe_o <= master_i;
  end
  
//sck_oe_o
always @(posedge clk_i or negedge rstb_i)
  begin
    if(!rstb_i)
      sck_oe_o <= 1'b0;
    else
      sck_oe_o <= master_i;
  end

//mosi_oe_o
always @(posedge clk_i or negedge rstb_i)
  begin
    if(!rstb_i)
      mosi_oe_o <= 1'b0;
    else
      mosi_oe_o <= master_i;
  end

//miso_oe_o
always @(posedge clk_i or negedge rstb_i)
  begin
    if(!rstb_i)
      miso_oe_o <= 1'b0;
    else
      miso_oe_o <= ~master_i;
  end

endmodule