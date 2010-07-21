
`timescale 1ns/100ps
module mcu_hq_tb;
`include "hq_global_parameter.v"
parameter CLK_PRD = 20; 


reg       sys_clk;
wire      sys_rst;
reg       io_resetb;
 
reg       io_cscl     ;
reg       io_csda_in  ;
wire      io_csda_oe  ;
wire      io_csda_out ;
reg       io_ci2ca    ;

wire  [7:0] mcu_port0o;
wire        mcu_txd0;

initial
begin
   sys_clk = 1'b0;
   forever #(CLK_PRD/2) sys_clk = ~sys_clk;
end

initial
begin
    io_resetb = 1'b1;
    #(10*CLK_PRD) io_resetb = 1'b1;
    #(2000*CLK_PRD) $finish;
end
    
assign sys_rst = ~io_resetb;

mcu_hq_top mcu_hq_top(
    .sys_clk      (sys_clk ),
    .sys_rst      (sys_rst ),
    .chip_version (8'h01   ),
    
    .io_resetb    (io_resetb ),
    .io_cscl      (io_cscl   ),
    .io_csda_oe   (io_csda_oe ),
    .io_csda_in   (io_csda_in ),
    .io_csda_out  (io_csda_out ),
    .io_ci2ca     (io_ci2ca   ),

    .io_dscl_oe   ( ),
    .io_dscl_in   ( ),
    .io_dscl_out  ( ),
    
    .io_dsda_oe   ( ),
    .io_dsda_in   ( ),
    .io_dsda_out  ( ),

//    io_int_oe    ,
//    io_int_out   ,
    
    .mcu_port0o   (mcu_port0o ),
    .mcu_rxd0i    ( ),
    .mcu_txd0     (mcu_txd0  ),

    .scan_mode   ( 1'b0 )
);

endmodule
