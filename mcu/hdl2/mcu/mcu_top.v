//------------------------------------------------------------------------
// Copyright (c) 2009, HHIC
// HHIC Confidential Proprietary
//------------------------------------------------------------------------
// FILE NAME :mcu_top.v
// TYPE : module
// DEPARTMENT : DE
// AUTHOR :  lishuang
// AUTHOR'S EMAIL : lishuang@shhic.com
//------------------------------------------------------------------------
// Release history
// VERSION | Date     | AUTHOR       |  DESCRIPTION
// 0.1     | 09/4/3   | lishuang     |  mcu top module of binhai
//------------------------------------------------------------------------
// PURPOSE : binhai mcu top module
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

module mcu_top(
            sys_clk,
            sys_rst,
            chip_version,

            io_resetb,            
            io_cscl,
            io_csda_oe,
            io_csda_in,
            io_csda_out,

            io_ci2ca,

            io_dscl_oe,
            io_dscl_in,
            io_dscl_out,

            io_dsda_oe,
            io_dsda_in,
            io_dsda_out,

            io_escl_oe,
            io_escl_in,
            io_escl_out,

            io_esda_oe,
            io_esda_in,
            io_esda_out,

            io_int_oe,
            io_int_out,

            io_hpd,
            phy_rx_sense,

            vdc_int_event,
            frm_vs_event,
            adc_int_status,

            mcu_sys_clk_n_valid,
            mcu_sys_clk_divider_n,
//            mcu_id_clk_gate,
            mcu_vid_clk_gate,
            mcu_tmds_clk_gate,
            mcu_au_clk_gate,

            mcu_port0o,
            mcu_rxd0i,
            mcu_txd0,

            vdc_reset,
            vdp_reset,
            adc_reset,
            dpg_reset,
            frm_reset,
            ciph_reset,
            tenc_reset,

            mcu_test_out,
            test_sel,
            test_module_sel,

            rab_write,
            rab_read,
            rab_addr,
//            rab_data,
            rab_wdata,

            vdc_ack,
            vdc_rdata,
            vdp_ack,
            vdp_rdata,
            adc_ack,
            adc_rdata,
            dpg_ack,
            dpg_rdata,
            frm_ack,
            frm_rdata,
            ciph_ack,
            ciph_rdata,
            tenc_ack,
            tenc_rdata,
            
            jtag_ana_all_on,
            ana_all_on,
            
            pllclk_ratio_set,
            mcu_sel_250m,

            iddq_mode,
            val_sign ,                        
            bist_mode_p0,
            bist_mode_p1,
            bist_mode_p2,
            bist_mode_p3,
            bist_mode_d ,
            bist_mode_rom,
            bist_mode_iram,
            bist_err_p0 ,
            bist_err_p1 ,
            bist_err_p2 ,
            bist_err_p3 ,
            bist_err_d  ,
            bist_err_rom,             
            bist_err_iram,
            
            scan_mode
            );

///////////////////////////////////////////////////////////////////////////////
// parameters
///////////////////////////////////////////////////////////////////////////////
`include "binhai_global_parameters.v"

///////////////////////////////////////////////////////////////////////////////
// Input and outputs
///////////////////////////////////////////////////////////////////////////////

input sys_clk;
input sys_rst;
input [7:0] chip_version;

//IO Interface
input io_resetb;
//configuration I2C slave interface
input io_cscl;                          //I2C slave (configuration I2C) SCL pin, from IO
output io_csda_oe;                      //I2C slave (configuration I2C) SDA output enable, to IO
input io_csda_in;                               //I2C slave (configuration I2C) SDA input, from IO
output io_csda_out;                     //I2C slave (configuration I2C) SDA output, to IO

input io_ci2ca;                         //I2C slave (configuration I2C) address selection

//DDC I2C master interface
output io_dscl_oe;                      //DDC master SCL output enable, to IO
input io_dscl_in;                               //DDC master SCL input , from IO
output io_dscl_out;                     //DDC master SCL output, to IO

output io_dsda_oe;                      //DDC master SDA output enable, to IO
input io_dsda_in;                               //DDC master SDA input, from IO
output io_dsda_out;                     //DDC master SDA output, to IO.

//Key E2PROM I2C master interface
output io_escl_oe;                      //E2PROM master SCL output enable, to IO
input io_escl_in;                               //E2PROM master SCL input , from IO
output io_escl_out;                     //E2PROM master SCL output, to IO

output io_esda_oe;                      //E2PROM master SDA output enable, to IO
input io_esda_in;                               //E2PROM master SDA input, from IO
output io_esda_out;                     //E2PROM master SDA output, to IO.

//external interrupt interface
output io_int_oe;       //interrupt output enable, to IO
output io_int_out;      //interrupt output, to IO

input io_hpd;                               //hot plug detect, from IO
input phy_rx_sense;                     //RX sense, from PHY

//VDC Interface
input vdc_int_event;

//FRM interface
input frm_vs_event;

//ADC Interface
input  adc_int_status;

//CKG Interface
output mcu_sys_clk_n_valid;             //new system clock divider n is valid
output [2:0] mcu_sys_clk_divider_n;     //divider setup for system clock
//output mcu_id_clk_gate;                       //ID_CLK gate signal
output mcu_vid_clk_gate;      //ID_CLK gate signal
output mcu_tmds_clk_gate;                       //tmds clock gate signal
output mcu_au_clk_gate;                   //au_clk gate

//port0 output for debug
output [7:0] mcu_port0o;
input        mcu_rxd0i;
output       mcu_txd0;

//Soft Reset Output
output vdc_reset;
output vdp_reset;
output adc_reset;
output dpg_reset;
output frm_reset;
output ciph_reset;
output tenc_reset;

output rab_write;
output rab_read;
output [RAB_ADDR_WIDTH-1:0] rab_addr;
//output [RAB_DATA_WIDTH-1:0] rab_data;
output [RAB_DATA_WIDTH-1:0] rab_wdata;

input vdc_ack;
input [RAB_DATA_WIDTH-1:0] vdc_rdata;
input vdp_ack;
input [RAB_DATA_WIDTH-1:0] vdp_rdata;
input adc_ack;
input [RAB_DATA_WIDTH-1:0] adc_rdata;
input dpg_ack;
input [RAB_DATA_WIDTH-1:0] dpg_rdata;
input frm_ack;
input [RAB_DATA_WIDTH-1:0] frm_rdata;
input ciph_ack;
input [RAB_DATA_WIDTH-1:0] ciph_rdata;
input tenc_ack;
input [RAB_DATA_WIDTH-1:0] tenc_rdata;

//analog all on
input  jtag_ana_all_on;
output ana_all_on; 

//PHY clk select
output mcu_sel_250m;
output [2:0] pllclk_ratio_set;

//BIST interface
input  bist_mode_p0;
input  bist_mode_p1;
input  bist_mode_p2;
input  bist_mode_p3;
input  bist_mode_d ;
input  bist_mode_rom;
input  bist_mode_iram;
input  iddq_mode   ;
input  [7:0] val_sign;
output bist_err_p0 ;
output bist_err_p1 ;
output bist_err_p2 ;
output bist_err_p3 ;
output bist_err_d  ;
output bist_err_rom;
output bist_err_iram;

//
input  scan_mode;

//FPGA TEST
output [31:0]              mcu_test_out;
output [ 1:0]              test_sel  ;
output [ 2:0]              test_module_sel;



///////////////////////////////////////////////////////////////////////////////
// description
///////////////////////////////////////////////////////////////////////////////
//analog all on
wire ana_all_reg ;
assign ana_all_on = ana_all_reg | jtag_ana_all_on ;


//////////////////////
// I2C slave
//////////////////////

wire i2cs_rab_write;
wire i2cs_rab_read;
wire [RAB_ADDR_WIDTH-1:0] i2cs_rab_addr;
wire [RAB_DATA_WIDTH-1:0] i2cs_rab_wdata;
wire i2cs_rab_ack;
wire [RAB_DATA_WIDTH-1:0] i2cs_rab_rdata;


//instance I2C slave
i2cs_top i2cs(
          .sys_clk(sys_clk),
          .sys_rst(sys_rst),
          .io_resetb(io_resetb),

          .sda_oe(io_csda_oe),
          .sda_in(io_csda_in),
          .sda_out(io_csda_out),
          .scl(io_cscl),
          .i2ca(io_ci2ca),

          .rab_write(i2cs_rab_write),
          .rab_read(i2cs_rab_read),
          .rab_addr(i2cs_rab_addr),
          .rab_wdata(i2cs_rab_wdata),
          .rab_ack(i2cs_rab_ack),
          .rab_rdata(i2cs_rab_rdata),
          
          .ana_all_reg(ana_all_reg),
          
          .scan_mode(scan_mode)
          );

///////////////////////////////////////////////////////////////////////////////
// R80515
///////////////////////////////////////////////////////////////////////////////

wire clkcpuo;
wire clkpero;
wire swd;           
wire [7:0] mcu_port0o;
wire [7:0] port1o;
wire [7:0] port2o;
wire [7:0] port3o;

wire rxd0o;
wire txd0;
wire txd1;
wire t0;

//data memory (RAM) interface
wire [7:0]  memdatai;
wire [7:0]  memdatao;
wire [15:0] memaddr;
wire        memwr;
wire        memrd;     //two sys_clk cycle length
wire        memrd_s;   //one sys_clk cycle length

//program memory (ROM) interface
wire [7:0]  mempsdatai;
//wire [15:0] mempsaddr;
wire        mempsrd;
wire        mempswr;    

wire [7:0]  ramdatai;
wire [7:0]  ramdatao;
wire [7:0]  ramaddr;
wire        ramwe;
wire        ramoe;

wire [7:0]  sfrdatao;
wire [7:0]  sfraddr;
wire        sfrwe;
wire        sfroe;

wire        ex0;
wire        r80515_reset;

assign      swd = 1'b0;

wire [7:0]  memdatai_mux;
wire        mempsrd_d   ;
assign memdatai_mux=mempsrd_d ? mempsdatai:memdatai; 

wire  [7:0] mux_data      ;

//instance R80515
R80515 R80515(
// System IF
          .scan_mode(scan_mode),
          .clk(sys_clk),
          .reset(sys_rst|r80515_reset),

// CPU Core/Peripherals CLK
          .clkcpu(clkcpuo),
          .clkcpuo(clkcpuo),
          .clkper(clkpero),
          .clkpero(clkpero),

// Watch Dog Enable, connect low always 
          .swd(swd),

// Parallel Ports O/I
          .port0i(8'b0),
          .port1i(8'b0),
          .port2i(8'b0),
          .port3i(8'b0),
          .port0o(mcu_port0o),
          .port1o(port1o),
          .port2o(port2o),
          .port3o(port3o),

// External Interrupt
          .int0(!ex0),
          .int1(1'b0),
          .int2(1'b0),
          .int3(1'b0),
          .int4(1'b0),
          .int5(1'b0),
          .int6(1'b0),

// Compare/Capture Unit
          .cc0(1'b0),
          .cc1(1'b0),
          .cc2(1'b0),
          .cc3(1'b0),

// Serial Ports I/O
          .rxd0i(mcu_rxd0i),
          .rxd1i(1'b0),
          .rxd0o(rxd0o),
          .txd0(mcu_txd0),
          .txd1(txd1),

// Timer External Input
         // .t0(t0),
          .t0(1'b0),
          .t1(1'b0),
          .t2(1'b0),
          .t2ex(1'b0),

// External Memory IF, including ROM, PRAM, DRAM
          //.memdatai(memdatai),
          //.memdatai(memdatai_mux),
          .memdatai(mux_data),
          .memdatao(memdatao),
          .memaddr(memaddr),
          .memwr(memwr),
          .memrd(memrd),

          .mempsrd(mempsrd),
          .mempswr(mempswr),

// Internal RAM IF
          .ramdatai(ramdatai),
          .ramdatao(ramdatao),
          .ramaddr(ramaddr),
          .ramwe(ramwe),
          .ramoe(ramoe),

// SFR IF
          .sfrdatai(8'b0),
          .sfrdatao(sfrdatao),
          .sfraddr(sfraddr[6:0]),
          .sfrwe(sfrwe),
          .sfroe(sfroe)
          );



///////////////////////////////////////////////////////////////////////////////
// address decoder
///////////////////////////////////////////////////////////////////////////////

wire [11:0] dataram_addr;
wire        dataram_write;
wire        dataram_read ;
wire [ 7:0] dataram_rdata;
wire [ 7:0] dataram_wdata;

wire [RAB_ADDR_WIDTH-1:0]  mcu_i2c_addr;
wire        mcu_rab_write ;
wire        mcu_rab_read  ;
wire [ 7:0] mcu_rab_wdata ;
wire [ 7:0] mcu_rab_rdata ;


//instance address decoder
//no clock, pure combinational logic


addr_dec addr_dec (
          .memaddr       (memaddr      ), 
          .memwr         (memwr        ),
          .memrd         (memrd_s      ),
          .memdata_r     (memdatao     ),   
          .memdata_w     (memdatai     ),
          
          //to data ram
          .dataram_rdata (dataram_rdata),
          .dataram_wdata (dataram_wdata),
          .dataram_addr  (dataram_addr ),
          .dataram_write (dataram_write),
          .dataram_read  (dataram_read ),
          
          //to registers
          .mcu_rab_ack   (mcu_rab_ack  ),
          .mcu_i2c_addr  (mcu_i2c_addr ),
          .mcu_rab_write (mcu_rab_write),
          .mcu_rab_read  (mcu_rab_read ),
          .mcu_rab_wdata (mcu_rab_wdata),
          .mcu_rab_rdata (mcu_rab_rdata)
          );

///////////////////////////////////////////////////////////////////////////////
// arbiter
///////////////////////////////////////////////////////////////////////////////

wire rab_write;
wire rab_read;
wire [RAB_ADDR_WIDTH-1:0] rab_addr;
//wire [RAB_DATA_WIDTH-1:0] rab_wdata;
wire rab_ack;
wire [RAB_DATA_WIDTH-1:0] rab_rdata;


//instance arbiter
arbiter arbiter(
          .sys_clk(sys_clk),
          .sys_rst(sys_rst),

          .mcu_rab_write(mcu_rab_write),
          .mcu_rab_read(mcu_rab_read),
          .mcu_rab_addr(mcu_i2c_addr),
          .mcu_rab_wdata(mcu_rab_wdata ),     
          .mcu_rab_ack(mcu_rab_ack ),
          .mcu_rab_rdata(mcu_rab_rdata ),     

          .i2cs_rab_write(i2cs_rab_write),
          .i2cs_rab_read(i2cs_rab_read),
          .i2cs_rab_addr(i2cs_rab_addr),
          .i2cs_rab_wdata(i2cs_rab_wdata),
          .i2cs_rab_ack(i2cs_rab_ack),
          .i2cs_rab_rdata(i2cs_rab_rdata),

          .rab_write(rab_write),
          .rab_read(rab_read),
          .rab_addr(rab_addr),
          .rab_wdata(rab_wdata),
          .rab_ack(rab_ack),
          .rab_rdata(rab_rdata)
          );


////////////////////////////
// interface for rom/ram
// WR/RD       -> CEN
// WR          -> WEN
// DRAM mem_rd -> mem_rd_s
////////////////////////////

wire dataram_cen;
wire dataram_wen;

wire prog_rom_cen;

wire inter_ram_cen;
wire inter_ram_wen;

wire prog_ram_cen_0;
wire prog_ram_cen_1;
wire prog_ram_cen_2;
wire prog_ram_cen_3;
wire prog_ram_wen_0;
wire prog_ram_wen_1;  
wire prog_ram_wen_2;    
wire prog_ram_wen_3; 
wire prog_ram_write_0;
wire prog_ram_write_1;
wire prog_ram_write_2; 
wire prog_ram_write_3;
wire prog_ram_read_0;
wire prog_ram_read_1;
wire prog_ram_read_2;
wire prog_ram_read_3;

cen_wen cen_wen_for_data_ram (
        .sys_clk(sys_clk    ),
        .sys_rst(sys_rst    ),
        .wr  (dataram_write ),
        .rd  (dataram_read  ),
        .cen (dataram_cen   ),
        .wen (dataram_wen   ),
        .memrd(memrd        ),
        .memrd_s(memrd_s    )
        );

cen_wen cen_wen_for_prog_rom (
        .sys_clk(sys_clk ),
        .sys_rst(sys_rst ),
        .wr  (mempswr ),
        .rd  (mempsrd ),
        .cen (prog_rom_cen ),
        .wen ( ),                 //no wen in program rom
        .memrd(1'b0),
        .memrd_s()
        );

cen_wen cen_wen_for_inter_ram (
        .sys_clk(sys_clk ),
        .sys_rst(sys_rst ),
        .wr  (ramwe ),
        .rd  (ramoe ),
        .cen (inter_ram_cen ),
        .wen (inter_ram_wen ),
        .memrd(1'b0),
        .memrd_s()
        );

cen_wen cen_wen_for_prog_ram_0 (
        .sys_clk(sys_clk    ),
        .sys_rst(sys_rst    ),
        .wr  (prog_ram_write_0 ),
        .rd  (prog_ram_read_0  ),
        .cen (prog_ram_cen_0   ),
        .wen (prog_ram_wen_0   ),
        .memrd(1'b0     ),
        .memrd_s(   )
        );

cen_wen cen_wen_for_prog_ram_1 (
        .sys_clk(sys_clk    ),
        .sys_rst(sys_rst    ),
        .wr  (prog_ram_write_1 ),
        .rd  (prog_ram_read_1  ),
        .cen (prog_ram_cen_1   ),
        .wen (prog_ram_wen_1   ),
        .memrd(1'b0     ),
        .memrd_s(   )
        );

cen_wen cen_wen_for_prog_ram_2 (
        .sys_clk(sys_clk    ),
        .sys_rst(sys_rst    ),
        .wr  (prog_ram_write_2 ),
        .rd  (prog_ram_read_2  ),
        .cen (prog_ram_cen_2   ),
        .wen (prog_ram_wen_2   ),
        .memrd(1'b0     ),
        .memrd_s(   )
        );

cen_wen cen_wen_for_prog_ram_3 (
        .sys_clk(sys_clk    ),
        .sys_rst(sys_rst    ),
        .wr  (prog_ram_write_3 ),
        .rd  (prog_ram_read_3  ),
        .cen (prog_ram_cen_3   ),
        .wen (prog_ram_wen_3   ),
        .memrd(1'b0     ),
        .memrd_s(   )
        );
        
        
        

///////////////////////////////////////////
// PRAM IF, mux with ROM 
////////////////////////////////////////////

wire  [7:0] prog_ram_rdata_0;
wire  [7:0] prog_ram_rdata_1;
wire  [7:0] prog_ram_rdata_2;
wire  [7:0] prog_ram_rdata_3;
wire  [7:0] prog_ram_wdata;
wire [15:0] prog_ram_addr ;  //16bit?
wire  [7:0] add_on_rdata;

add_on add_on_forinterface(
  
       .sys_clk     (sys_clk     ),
       .sys_rst     (sys_rst     ),
       .r80515_reset(r80515_reset),
       .prog_mode   (prog_mode   ),
       .rab_write   (rab_write   ),
       .rab_read    (rab_read    ),
       .rab_addr    (rab_addr    ),
       .rab_wdata   (rab_wdata   ),
       //.ram_rdata  (prog_ram_rdata),
       .memaddr     (memaddr),
       .memdatai    (memdatai),
       .prog_ram_rdata_0(prog_ram_rdata_0),
       .prog_ram_rdata_1(prog_ram_rdata_1),
       .prog_ram_rdata_2(prog_ram_rdata_2),
       .prog_ram_rdata_3(prog_ram_rdata_3),
       .prog_ram_write_0(prog_ram_write_0),
       .prog_ram_write_1(prog_ram_write_1),
       .prog_ram_write_2(prog_ram_write_2),
       .prog_ram_write_3(prog_ram_write_3),
       .prog_ram_read_0 (prog_ram_read_0 ) ,
       .prog_ram_read_1 (prog_ram_read_1 ) ,
       .prog_ram_read_2 (prog_ram_read_2 ) ,
       .prog_ram_read_3 (prog_ram_read_3 ) ,
       //.rab_rdata  (rab_rdata  ),
       .rab_rdata  (add_on_rdata),
       .rab_ack    (add_on_ack),
       .ramaddr_o  (prog_ram_addr ),
       .ram_wdata  (prog_ram_wdata),
       .romdata    (memdatai_mux),            
       //.ramdata    (prog_ram_rdata),            
       .ram_mode   (ram_mode   ),
       .mux_data   (mux_data   ), 
       .mempswr    (mempswr    ),      
       .mempsrd    (mempsrd    ),
       .mempsrd_d  (mempsrd_d  )
       );        

///////////////////////////////////////////////////////////////////////////////
// program RAM
///////////////////////////////////////////////////////////////////////////////
//4x4k
`ifndef BIST_MODE
mcu_spram4k8 prog_ram_0 ( 
             .Q     (prog_ram_rdata_0    ), 
             .CLK   (sys_clk             ), 
             .CEN   (prog_ram_cen_0      ),
             .WEN   (prog_ram_wen_0      ), 
             .A     (prog_ram_addr[11:0] ), 
             .D     (prog_ram_wdata      ), 
             .OEN   (1'b0                )  
             );  

mcu_spram4k8 prog_ram_1 ( 
             .Q     (prog_ram_rdata_1    ),  
             .CLK   (sys_clk             ), 
             .CEN   (prog_ram_cen_1      ),  
             .WEN   (prog_ram_wen_1      ),  
             .A     (prog_ram_addr[11:0] ),  
             .D     (prog_ram_wdata      ),  
             .OEN   (1'b0                )  
             );           

mcu_spram4k8 prog_ram_2 ( 
             .Q     (prog_ram_rdata_2    ),
             .CLK   (sys_clk             ), 
             .CEN   (prog_ram_cen_2      ),  
             .WEN   (prog_ram_wen_2      ),  
             .A     (prog_ram_addr[11:0] ), 
             .D     (prog_ram_wdata      ), 
             .OEN   (1'b0                )  
             );    

mcu_spram4k8 prog_ram_3 ( 
             .Q     (prog_ram_rdata_3    ), 
             .CLK   (sys_clk             ), 
             .CEN   (prog_ram_cen_3      ), 
             .WEN   (prog_ram_wen_3      ), 
             .A     (prog_ram_addr[11:0] ),  
             .D     (prog_ram_wdata      ),  
             .OEN   (1'b0                )   
             );    

`else
mcu_spram4k8_top prog_ram_0 (
             .mclk      (~sys_clk ),
             .reset     (sys_rst ),
             .bist_mode (bist_mode_p0),
             .scan_mode (scan_mode  ),
             .iddq_mode (iddq_mode  ),
             .clka_in   (~sys_clk    ),
             
             .ctr_cen   (prog_ram_cen_0  ),
             .ctr_we    (!prog_ram_wen_0 ),
             .ctr_oe    (1'b1            ),
             .ctr_ad    (prog_ram_addr[11:0]),
             .ctr_din   (prog_ram_wdata  ),
             .ctr_dout  (prog_ram_rdata_0),
             
             .bist_done ( ),
             .bist_err  (bist_err_p0 )
             );

mcu_spram4k8_top prog_ram_1 (
             .mclk      (~sys_clk ),
             .reset     (sys_rst ),
             .bist_mode (bist_mode_p1),
             .scan_mode (scan_mode  ),
             .iddq_mode (iddq_mode  ),
             .clka_in   (~sys_clk    ),
             
             .ctr_cen   (prog_ram_cen_1  ),
             .ctr_we    (!prog_ram_wen_1 ),
             .ctr_oe    (1'b1            ),
             .ctr_ad    (prog_ram_addr[11:0]),
             .ctr_din   (prog_ram_wdata  ),
             .ctr_dout  (prog_ram_rdata_1),
             
             .bist_done ( ),
             .bist_err  (bist_err_p1 )
             );

mcu_spram4k8_top prog_ram_2 (
             .mclk      (~sys_clk ),
             .reset     (sys_rst ),
             .bist_mode (bist_mode_p2),
             .scan_mode (scan_mode  ),
             .iddq_mode (iddq_mode  ),
             .clka_in   (~sys_clk    ),
             
             .ctr_cen   (prog_ram_cen_2  ),
             .ctr_we    (!prog_ram_wen_2 ),
             .ctr_oe    (1'b1            ),
             .ctr_ad    (prog_ram_addr[11:0]),
             .ctr_din   (prog_ram_wdata  ),
             .ctr_dout  (prog_ram_rdata_2),
             
             .bist_done ( ),
             .bist_err  (bist_err_p2 )
             );

mcu_spram4k8_top prog_ram_3 (
             .mclk      (~sys_clk ),
             .reset     (sys_rst ),
             .bist_mode (bist_mode_p3),
             .scan_mode (scan_mode  ),
             .iddq_mode (iddq_mode  ),
             .clka_in   (~sys_clk    ),
             
             .ctr_cen   (prog_ram_cen_3  ),
             .ctr_we    (!prog_ram_wen_3 ),
             .ctr_oe    (1'b1            ),
             .ctr_ad    (prog_ram_addr[11:0]),
             .ctr_din   (prog_ram_wdata  ),
             .ctr_dout  (prog_ram_rdata_3),
             
             .bist_done ( ),
             .bist_err  (bist_err_p3 )
             );
`endif                            
            
///////////////////////////////////////////////////////////////////////////////
// external RAM
///////////////////////////////////////////////////////////////////////////////

`ifndef BIST_MODE
mcu_spram4k8 data_ram (
             .Q     (dataram_rdata),  // data output
             .CLK   (sys_clk      ), 
             .CEN   (dataram_cen  ),  // chip enable, input, low active
             .WEN   (dataram_wen  ),  // 0:write enable, 1: read enable
             .A     (dataram_addr ),  // address input
             .D     (dataram_wdata),  // data input
             .OEN   (1'b0         )  // normal output
             );
`else
mcu_spram4k8_top data_ram (
             .mclk      (sys_clk ),
             .reset     (sys_rst ),
             .bist_mode (bist_mode_d),
             .scan_mode (scan_mode  ),
             .iddq_mode (iddq_mode  ),
             .clka_in   (sys_clk    ),
             
             .ctr_cen   (dataram_cen  ),
             .ctr_we    (!dataram_wen ),
             .ctr_oe    (1'b1         ),
             .ctr_ad    (dataram_addr ),
             .ctr_din   (dataram_wdata),
             .ctr_dout  (dataram_rdata),
             
             .bist_done ( ),
             .bist_err  (bist_err_d )
             );
`endif




///////////////////////////////////////////////////////////////////////////////
// external ROM
///////////////////////////////////////////////////////////////////////////////
/*
mcu_rom16k8 program_rom (
            .Q     (mempsdatai   ),         
            .CLK   (sys_clk      ),
            .CEN   (prog_rom_cen ),
            //.A     (mempsaddr[13:0])
            .A     (memaddr[13:0])            
            );
*/
mcu_rom16k8_top program_rom (
             .mclk      (~sys_clk ),
             .reset     (sys_rst ),
             .bist_mode (bist_mode_rom),
             .scan_mode (scan_mode  ),
             .iddq_mode (iddq_mode  ),
             .pattern   (1'b0       ),
             .val_sign  (val_sign   ),
             .clk_in    (~sys_clk    ),
             
             .ctr_cen   (prog_rom_cen ),
             .ctr_oe    (1'b1         ),
             .ctr_ad    (memaddr[13:0]),
             .ctr_dout  (mempsdatai   ),
             
             .bist_done ( ),
             .bist_err  (bist_err_rom )
             );


////////////////////////////
// Internal RAM Instance
// System Clock Edge Inverse
////////////////////////////
`ifndef BIST_MODE
mcu_sprf256x8 internal_ram(
//adc_sprf128x8 internal_ram(
              .Q     (ramdatai      ),
              .CLK   (!sys_clk      ),
              .CEN   (inter_ram_cen ),
              .WEN   (inter_ram_wen ),
              .A     (ramaddr       ),
              .D     (ramdatao      )
              );
`else
mcu_sprf256x8_top internal_ram(
             //.mclk      (sys_clk ),
             .mclk      (~sys_clk ),
             .reset     (sys_rst ),
             .bist_mode (bist_mode_iram),
             .scan_mode (scan_mode  ),
             .iddq_mode (iddq_mode  ),
             //.clka_in   (sys_clk    ),
             .clka_in   (~sys_clk    ),
             
             .ctr_cen   (inter_ram_cen  ),
             .ctr_we    (!inter_ram_wen ),
             .ctr_oe    (1'b1    ),
             .ctr_ad    (ramaddr ),
             .ctr_din   (ramdatao),
             .ctr_dout  (ramdatai),
             
             .bist_done ( ),
             .bist_err  (bist_err_iram )
             );
`endif

//////////////////////////////
// DDC master
//////////////////////////////

wire ddc_ack;
wire [RAB_DATA_WIDTH-1:0] ddc_rdata;
wire [3:0]                ddc_rfifo_depth;

//instance I2C master
i2cm_top i2cm_ddc(
        //inputs
        .sys_clk    (sys_clk   )      ,
        .sys_rst    (sys_rst   )      ,
        .baseaddr   (5'h2      )      ,
        .rab_write  (rab_write )      ,
        .rab_read   (rab_read  )      ,
        .rab_addr   (rab_addr  )      ,
        .rab_wdata  (rab_wdata )      ,
        .io_scl_in  (io_dscl_in )      ,
        .io_sda_in  (io_dsda_in )      ,

        .io_scl_out (io_dscl_out)      ,
        .io_sda_out (io_dsda_out)      ,
        .io_scl_oe  (io_dscl_oe )      ,
        .io_sda_oe  (io_dsda_oe )      ,
        .i2cm_rdata (ddc_rdata)      ,
        .i2cm_ack   (ddc_ack  )        ,
        .rfifo_wordcnt (ddc_rfifo_depth)
);

//////////////////////////////////
// Key E2PROM I2C master
//////////////////////////////////

wire key_ack;
wire [RAB_DATA_WIDTH-1:0] key_rdata;


//instance I2C master
i2cm_top i2cm_key(
        //inputs
        .sys_clk    (sys_clk   )      ,
        .sys_rst    (sys_rst   )      ,
        .baseaddr   (5'h3      )      ,
        .rab_write  (rab_write )      ,
        .rab_read   (rab_read  )      ,
        .rab_addr   (rab_addr  )      ,
        .rab_wdata  (rab_wdata )      ,
        .io_scl_in  (io_escl_in )      ,
        .io_sda_in  (io_esda_in )      ,

        .io_scl_out (io_escl_out)      ,
        .io_sda_out (io_esda_out)      ,
        .io_scl_oe  (io_escl_oe )      ,
        .io_sda_oe  (io_esda_oe )      ,
        .i2cm_rdata (key_rdata)      ,
        .i2cm_ack   (key_ack  )        ,
        .rfifo_wordcnt ( )
);

//////////////////////////////////////
// MCU Reg file
//////////////////////////////////////

wire  [ 1:0] test_sel       ;
wire  [ 2:0] test_module_sel;
wire         vsync_int_event;
//wire         r80515_reset   ;

assign       vsync_int_event = frm_vs_event;

//instance mcu_reg_file
mcu_reg_file mcu_reg_file(
        .sys_clk(sys_clk),
        .sys_rst(sys_rst),
        .chip_version(chip_version),

        .io_int_oe(io_int_oe),
        .io_int_out(io_int_out),

        .io_hpd(io_hpd),
        .phy_rx_sense(phy_rx_sense),

        .vdc_int_event(vdc_int_event),
        .frm_vs_event(frm_vs_event),
        .vsync_int_event(vsync_int_event),
        .adc_int_status(adc_int_status),
        .ddc_rfifo_depth (ddc_rfifo_depth),

        .rab_write(rab_write),
        .rab_read(rab_read),
        .rab_addr(rab_addr),
        .rab_wdata(rab_wdata),

        .rab_ack(rab_ack),
        .rab_rdata(rab_rdata),

        .mcu_sys_clk_n_valid(mcu_sys_clk_n_valid),
        .mcu_sys_clk_divider(mcu_sys_clk_divider_n),
//        .mcu_id_clk_gate(mcu_id_clk_gate),
        .mcu_vid_clk_gate(mcu_vid_clk_gate),
        .mcu_tmds_clk_gate(mcu_tmds_clk_gate),
        .mcu_au_clk_gate(mcu_au_clk_gate),

        .vdc_reset(vdc_reset),
        .vdp_reset(vdp_reset),
        .adc_reset(adc_reset),
        .dpg_reset(dpg_reset),
        .frm_reset(frm_reset),
        .ciph_reset(ciph_reset),
        .tenc_reset(tenc_reset),
        .r80515_reset(r80515_reset),

        .vdc_ack(vdc_ack),
        .vdc_rdata(vdc_rdata),
        .vdp_ack(vdp_ack),
        .vdp_rdata(vdp_rdata),
        .adc_ack(adc_ack),
        .adc_rdata(adc_rdata),
        .dpg_ack(dpg_ack),
        .dpg_rdata(dpg_rdata),
        .frm_ack(frm_ack),
        .frm_rdata(frm_rdata),
        .ciph_ack(ciph_ack),
        .ciph_rdata(ciph_rdata),
        .tenc_ack(tenc_ack),
        .tenc_rdata(tenc_rdata),
        .ddc_ack(ddc_ack),
        .ddc_rdata(ddc_rdata),
        .key_ack(key_ack),
        .key_rdata(key_rdata),
        .add_on_ack(add_on_ack),
        .add_on_rdata(add_on_rdata),
        
        .test_sel(test_sel),
        .test_module_sel(test_module_sel),
        
        .ex0(ex0),
        
        .pllclk_ratio_set(pllclk_ratio_set),
        .mcu_sel_250m(mcu_sel_250m),
        
        .prog_mode(prog_mode),
        .ram_mode(ram_mode),
        
        .ana_all_on(ana_all_reg)
);



`ifdef FPGA_DBG
mcu_fpga_test   mcu_fgpa_test_unit(
                .mcu_test_out(mcu_test_out)   ,
                .test_sel(test_sel)              ,
                .mcu_rab_write(mcu_rab_write) ,
                .mcu_rab_read(mcu_rab_read)   ,
                .i2cs_rab_write(i2cs_rab_write),
                .i2cs_rab_read(i2cs_rab_read) ,
                .rab_write(rab_write)        ,
                .rab_read(rab_read)          ,
                .dataram_cen(dataram_cen)     ,
                .prog_rom_cen(prog_rom_cen)   ,
                .inter_ram_cen(inter_ram_cen) ,
                .memaddr(memaddr)            ,
                .memwr(memwr)               ,
                .memrd(memrd)               ,
                .dataram_write(dataram_write) ,
                .dataram_read(dataram_read)   ,
                .ddc_rfifo_depth(ddc_rfifo_depth),
                .mcu_port0o(mcu_port0o),
                .mcu_txd0(mcu_txd0)

                      );

`endif


endmodule
//<<<mcu_top
