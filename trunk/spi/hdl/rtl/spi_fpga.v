////////////////////////////////////////////////////
//module name:spi_fpga
//file name:  spi_fpga.v
//version:    0.1
//author:     chenzy
//date:       2009.12.01
//function:   demodulator spi only top module
///////////////////////////////////////////////////
//revision histor

`define FPGA

module spi_fpga(
      clk,
      reset_n,
      SS,
      SCK,
      MISO,
      MOSI,
      int0
);

input           clk      ;
input           reset_n  ;

// SPI bus
input           SS      ;
input           SCK     ;
input           MOSI    ;
output          MISO    ;
output          int0    ;

// Demo reg
wire   [6:0]     reg_addr;
wire   [7:0]     reg_data_i;
wire             reg_rd;
wire             reg_wr;
wire   [7:0]     reg_data_o;
wire             mem_rd_ena;
wire     [7:0]   mem_data_out;
wire             mem_ena_out;
wire             bydin_int;

SPIP08V100 u_SPI08V100(
                    .rstb_i    (reset_n),     //ip reset
                    .clk_i     (clk    ),     //system clock
                    .sfr_sel_i (8'h0    ),     //spi sfr seclect
                    .sfr_en_i  (1'b0    ),     //spi sfr enable
                    .sfr_wr_i  (1'b0    ),     //spi sfr read and write control signal
                    .sfr_wdata_i (8'h0  ),     //spi sfr write data
             //       spi_en_i,        //spi enable
                    .ss_i       ( SS   ),     //spi ss pin input data
                    .sck_i      ( SCK  ),     //spi sck pin input data
                    .mosi_i     ( MOSI ),     //spi mosi pin input data
                    .miso_i     ( 1'b0 ),          //spi miso pin input data
                    .sdr_not_full_o (),  //spi send fifo full flag
                    .rdr_not_empty_o(),  //spi receive fifo empty flag
                    .ss_o           (),  //spi ss pin output data
                    .sck_o          (),  //spi sck pin output data
                    .mosi_o         (),  //spi mosi pin output data
                    .miso_o     ( MISO  ),          //spi miso pin output data
                    .ss_oe_o        (),  //spi ss pin output enable
                    .sck_oe_o       (),  //spi sck pin output enable
                    .mosi_oe_o      (),  //spi mosi pin output enable
                    .miso_oe_o      (),  //spi miso pin output enable                    
                    .int_o          (),  //spi interrupt request
                    .sfr_rdata_o    (),  //sfr read data        
                    .reg_addr    (reg_addr  ),
                    .reg_data_i  (reg_data_i),
                    .reg_data_o  (reg_data_o),
                    .reg_rd      (reg_rd    ),
                    .reg_wr      (reg_wr    ),
                    .mem_rd_ena  (mem_rd_ena),
                    .mem_data_out(mem_data_out),
                    .mem_ena_out (mem_ena_out )
                 );

demo_reg u_reg(
    .clk         (clk       ),
    .reset_n     (reset_n   ),
    .reg_addr    (reg_addr  ),
    .reg_data_i  (reg_data_i),
    .reg_data_o  (reg_data_o),
    .reg_rd      (reg_rd    ),
    .reg_wr      (reg_wr    )
);

bydin_sim u_bydin(
    .clk         (clk       ),
    .reset_n     (reset_n   ),
    .mem_rd_ena  (mem_rd_ena),
    .mem_data_out(mem_data_out),
    .mem_ena_out (mem_ena_out ),
    .bydin_int   (bydin_int   )    
);

assign int0 = bydin_int;

endmodule
