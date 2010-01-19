////////////////////////////////////////////////////
//module name:spi
//file name:  SPIP08V100.v
//version:    1.0
//author:     zxc
//date:       2008.07.01
//function:   spi top block
///////////////////////////////////////////////////
//revision history

`timescale 1ns/1ns
module SPIP08V100 (
                    rstb_i,          //ip reset
                    clk_i,           //system clock
                    sfr_sel_i,       //spi sfr seclect
                    sfr_en_i,        //spi sfr enable
                    sfr_wr_i,        //spi sfr read and write control signal
                    sfr_wdata_i,     //spi sfr write data
             //       spi_en_i,        //spi enable
                    ss_i,            //spi ss pin input data
                    sck_i,           //spi sck pin input data
                    mosi_i,          //spi mosi pin input data
                    miso_i,          //spi miso pin input data
                    sdr_not_full_o,  //spi send fifo full flag
                    rdr_not_empty_o, //spi receive fifo empty flag
                    ss_o,            //spi ss pin output data
                    sck_o,           //spi sck pin output data
                    mosi_o,          //spi mosi pin output data
                    miso_o,          //spi miso pin output data
                    ss_oe_o,         //spi ss pin output enable
                    sck_oe_o,        //spi sck pin output enable
                    mosi_oe_o,       //spi mosi pin output enable
                    miso_oe_o,       //spi miso pin output enable                    
                    int_o,           //spi interrupt request
                    sfr_rdata_o,     //sfr read data        
	                reg_addr,
                    reg_data_i,
                    reg_data_o,
                    reg_rd,
                    reg_wr,
		            mem_rd_ena,
                    mem_data_out,
                    mem_ena_out
 );

input rstb_i;
input clk_i;
input [7:0] sfr_sel_i;
input sfr_en_i;
input sfr_wr_i;
input [7:0] sfr_wdata_i;
//input spi_en_i;
input ss_i;
input sck_i;
input mosi_i;
input miso_i;

output sdr_not_full_o;
output rdr_not_empty_o;
output ss_o;
output sck_o;
output mosi_o;
output miso_o;
output ss_oe_o;
output sck_oe_o;
output mosi_oe_o;
output miso_oe_o;
output int_o;
output [7:0] sfr_rdata_o;

output  [6:0]     reg_addr;
output  [7:0]     reg_data_i;
output            reg_rd;
output            reg_wr;
input   [7:0]     reg_data_o;

output            mem_rd_ena;
input   [7:0]     mem_data_out;
input             mem_ena_out;

//-------------------------------------------------------------
//---------------- internal signal declaration ----------------
//-------------------------------------------------------------
wire rstb_general;
wire rstb_master;
wire rstb_slave;
wire lsbf;
wire cpol;
wire cpha;
wire rx_ready;
wire tx_ready;
wire query_cmd_err;
wire app_cmd_err_clr;
wire rcv_ov;
wire send_ov;
wire master;
wire status_writing;
wire [1:0]opr_mode;
wire [2:0]frame_len;
wire [8:0]rcv_num;
wire [8:0]rcv_cnt; 
wire [7:0]master_send_data;
wire [7:0]slave_send_data;
wire [7:0]send_data;
wire [7:0]master_rcv_data;
wire [7:0]slave_rcv_data;
wire [7:0]rcv_data;
wire [7:0]baud;
wire [5:0]slave_status;
wire [7:0]status_query_cmd_reg;
wire master_load_end;
wire slave_load_end;
wire load_end;
wire master_convey_end;
wire slave_convey_end;
wire master_frame_end;
wire slave_frame_end;
wire send_end;
wire rcv_end;
wire sdr_empty;
wire rdr_full;
wire frame_end;
wire convey_end; 


//-------------------------------------------------------------
//-------------------- module instantiation -------------------
//------------------------------------------------------------- 
spi_master_ctrl u_spi_master_ctrl(
                                  .rstb_i                   (rstb_master),
                                  .clk_i                    (clk_i),  
                                  .bit_i                    (miso_i),
                                  .lsbf_i                   (lsbf),
                                  .cpol_i                   (cpol),
                                  .cpha_i                   (cpha),   
                                  .opr_mode_i               (opr_mode),                             
                                  .frame_len_i              (frame_len), 
                                  .rcv_num_i                (rcv_num), 
                                  .send_data_i              (master_send_data),
                                  .baud_i                   (baud),
                                  .send_end_i               (send_end),
                                  .rcv_end_i                (rcv_end),
                                  .sdr_empty_i              (sdr_empty), 
                                  .rdr_full_i               (rdr_full),                                  
                                  .load_end_o               (master_load_end),
                                  .convey_end_o             (master_convey_end),
                                  .frame_end_o              (master_frame_end),
                                  .rcv_data_o               (master_rcv_data),
                                  .rcv_cnt_o                (rcv_cnt),
                                  .ss_o                     (ss_o),
                                  .sck_o                    (sck_o),
                                  .bit_o                    (mosi_o)
             		                 );                         
       		                                                  
                                                            
spi_slave_ctrl u_spi_slave_ctrl(                            
                                  .rstb_i                   (rstb_slave),
                                  .clk_i                    (clk_i),
                                  .ss_i                     (ss_i),
                                  .sck_i                    (sck_i),       
                                  .bit_i                    (mosi_i),
                                  .lsbf_i                   (lsbf),
                                  .cpol_i                   (cpol),
                                  .cpha_i                   (cpha),
                                  .rx_ready_i               (rx_ready),
                                  .tx_ready_i               (tx_ready),
                                  .send_data_i              (slave_send_data),
                                  .sdr_empty_i              (sdr_empty),
                                  .rdr_full_i               (rdr_full),
                                  .stauts_reg_i             (slave_status),
                                  .status_writing_i         (status_writing),
                                  .status_query_cmd_reg_i   (status_query_cmd_reg),
                                  .load_end_o               (slave_load_end),
                                  .convey_end_o             (slave_convey_end),
                                  .frame_end_o              (slave_frame_end),
                                  .rcv_data_o               (slave_rcv_data),
                                  .bit_o                    (miso_o),
                                  .query_cmd_err_o          (query_cmd_err),
                                  .app_cmd_err_clr_o        (app_cmd_err_clr),
                                  .rcv_ov_o                 (rcv_ov),
                                  .send_ov_o                (send_ov),
// added for reg access				  
                    .reg_addr    (reg_addr  ),
                    .reg_data_i  (reg_data_i),
                    .reg_data_o  (reg_data_o),
                    .reg_rd      (reg_rd    ),
                    .reg_wr      (reg_wr    ),
	            .mem_rd_ena  (mem_rd_ena),
                    .mem_data_out(mem_data_out),
                    .mem_ena_out (mem_ena_out )	    
	    );                           
                                                            
spi_switch u_spi_switch (                                   
                                  .rstb_i                   (rstb_i),
                                  .clk_i                    (clk_i),
                                  .spi_en_i                 (1'b1), // SPI is always enable
                                  .master_i                 (master),
                                  .send_data_i              (send_data),
                                  .master_load_end_i        (master_load_end),
                                  .slave_load_end_i         (slave_load_end),
                                  .master_convey_end_i      (master_convey_end),
                                  .slave_convey_end_i       (slave_convey_end),
                                  .master_frame_end_i       (master_frame_end),
                                  .slave_frame_end_i        (slave_frame_end),
                                  .master_rcv_data_i        (master_rcv_data),
                                  .slave_rcv_data_i         (slave_rcv_data),
                                  .rstb_general_o           (rstb_general),
                                  .rstb_master_o            (rstb_master),
                                  .rstb_slave_o             (rstb_slave),
                                  .master_send_data_o       (master_send_data),
                                  .slave_send_data_o        (slave_send_data),
                                  .load_end_o               (load_end),
                                  .convey_end_o             (convey_end),
                                  .frame_end_o              (frame_end),
                                  .rcv_data_o               (rcv_data),
                                  .ss_oe_o                  (ss_oe_o),
                                  .sck_oe_o                 (sck_oe_o),
                                  .mosi_oe_o                (mosi_oe_o),
                                  .miso_oe_o                (miso_oe_o)
                        );                                  
                                                            
spi_sfr u_spi_sfr(                                          
                                  .rstb_general_i           (rstb_general),
                                  .rstb_master_i            (rstb_master),
                                  .rstb_slave_i             (rstb_slave),
                                  .rst_local_i              (rstb_i),
                                  .clk_i                    (clk_i),
                                  .sfr_en_i                 (sfr_en_i),		
                                  .sfr_wr_i                 (sfr_wr_i),
                                  .sfr_sel_i                (sfr_sel_i),
                                  .sfr_wdata_i              (sfr_wdata_i),
                                  .rcv_data_i               (rcv_data),
                                  .load_end_i               (load_end),
                                  .convey_end_i             (convey_end),
                                  .frame_end_i              (frame_end),
                                  .rcv_cnt_i                (rcv_cnt),
                                  .query_cmd_err_i          (query_cmd_err),
                                  .app_cmd_err_clr_i        (app_cmd_err_clr),
                                  .rcv_ov_i                 (rcv_ov),
                                  .send_ov_i                (send_ov),
                                  .master_o                 (master),
                                  .send_data_o              (send_data),
                                  .sfr_rdata_o              (sfr_rdata_o),
                                  .opr_mode_o               (opr_mode),
                                  .lsbf_o                   (lsbf),
                                  .cpol_o                   (cpol),
                                  .cpha_o                   (cpha),
                                  .frame_len_o              (frame_len),
                                  .rcv_num_o                (rcv_num),
                                  .baud_o                   (baud),
                                  .slave_status_o           (slave_status),
                                  .send_end_o               (send_end),
                                  .rcv_end_o                (rcv_end),
                                  .sdr_not_full_o           (sdr_not_full_o),
                                  .sdr_empty_o              (sdr_empty),
                                  .rdr_full_o               (rdr_full),
                                  .rdr_not_empty_o          (rdr_not_empty_o),
                                  .rx_ready_o               (rx_ready),
                                  .tx_ready_o               (tx_ready),
                                  .status_2_writing_o       (status_writing),
                                  .status_query_cmd_reg_o   (status_query_cmd_reg),
                                  .spi_int_o                (int_o)
                 );


endmodule