// FILE NAME :mcu_top.v
// TYPE : module
// DEPARTMENT : DE
// AUTHOR :  Chen Zhengyi
// AUTHOR'S EMAIL : chenzhengyi@shhic.com
//------------------------------------------------------------------------
// Release history
// VERSION | Date     | AUTHOR       |  DESCRIPTION
// 0.1     | 09/4/3   | chenzy       |  mcu top module of hongqiao
//------------------------------------------------------------------------
// PURPOSE : hongqiao mcu top module
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
`define FPGA
module mcu_hq_top(
    sys_clk      ,
    sys_rst      ,
    chip_version ,
    
    io_resetb    ,
    io_cscl      ,
    io_csda_oe   ,
    io_csda_in   ,
    io_csda_out  ,
    io_ci2ca     ,

    io_dscl_oe   ,
    io_dscl_in   ,
    io_dscl_out  ,
    
    io_dsda_oe   ,
    io_dsda_in   ,
    io_dsda_out  ,

//    io_int_oe    ,
//    io_int_out   ,
    
    mcu_port0o   ,
    mcu_rxd0i    ,
    mcu_txd0     ,

    scan_mode   
);

// Parameter Definition
`include "hq_global_parameter.v"
// Input and Output
input               sys_clk      ;
input               sys_rst      ;
input   [7:0]       chip_version ;
input               io_resetb    ;

input               io_cscl      ;
input               io_csda_in   ;
output              io_csda_oe   ;
output              io_csda_out  ;
input               io_ci2ca     ;

input               io_dscl_in   ;
output              io_dscl_oe   ;
output              io_dscl_out  ;
input               io_dsda_in   ;
output              io_dsda_oe   ;
output              io_dsda_out  ;

//input               io_int_oe    ;
//output              io_int_out   ;

output    [7:0]     mcu_port0o    ;

input               mcu_rxd0i     ;
output              mcu_txd0      ;

input               scan_mode     ;

// analog all on
// reserver for future use from i2c slave
wire ana_all_reg ;
// assign ana_all_on = ana_all_reg | jtag_ana_all_on ;

// i2c main if
wire                i2cs_rab_write;
wire                i2cs_rab_read ;
wire                i2cs_rab_ack;
wire [RAB_ADDR_WIDTH-1:0] i2cs_rab_addr;
wire [RAB_DATA_WIDTH-1:0] i2cs_rab_wdata;
wire [RAB_DATA_WIDTH-1:0] i2cs_rab_rdata;

// i2c master
wire                i2cm_ack      ;
wire [RAB_DATA_WIDTH-1:0] i2cm_rdata;

// mcu wire
// mcu clock
wire                clkcpuo       ;
wire                clkpero       ;
// mcu per
wire                swd           ;           
wire     [7:0]      mcu_port0o    ;
wire     [7:0]      port1o        ;
wire     [7:0]      port2o        ;
wire     [7:0]      port3o        ;
wire                rxd0o         ;
wire                txd0          ;
wire                txd1          ;
wire                t0            ;
// mcu data ram
wire     [7:0]      memdatai      ;
wire     [7:0]      memdatao      ;
wire    [15:0]      memaddr       ;
wire                memwr         ;
wire                memrd         ;  //two sys_clk cycle length
wire                memrd_s       ;  //one sys_clk cycle length
// mcu program memory (ROM) interface
wire     [7:0]      mempsdatai    ;
wire                mempsrd       ;
wire                mempsrd_d     ;
wire                mempswr       ;    
// mcu internal ram
//wire     [7:0]      ramdatai      ;
//wire     [7:0]      ramdatao      ;
//wire     [7:0]      ramaddr       ;
wire                iram_we       ;
wire                iram_oe       ;
// mcu sfr
wire     [7:0]      sfrdatao      ;
wire     [6:0]      sfraddr       ;
wire                sfrwe         ;
wire                sfroe         ;
wire                ex0           ;
wire                r80515_reset  ;
wire     [7:0]      mem_wdata     ;
wire     [7:0]      mem_rdata     ;

// pram if
wire    [15:0]      pram_addr     ;
wire                pram_cen      ;
wire                pram_wen      ;
wire     [7:0]      pram_wdata    ;
wire     [7:0]      pram_rdata    ;
// dram if
wire    [11:0]      dram_addr     ;
wire                dram_cen      ;
wire                dram_wen      ;
wire                dram_wr       ;
wire                dram_rd       ;
wire     [7:0]      dram_wdata    ;
wire     [7:0]      dram_rdata    ;
// iram if
wire     [7:0]      iram_addr     ;
wire                iram_cen      ;
wire                iram_wen      ;
wire     [7:0]      iram_wdata    ;
wire     [7:0]      iram_rdata    ;

wire     [7:0]      rab_pram_rdata;
wire                rab_pram_ack  ;

wire                mcu_rab_write;
wire                mcu_rab_read ;
wire                mcu_rab_ack;
wire [RAB_ADDR_WIDTH-1:0] mcu_rab_addr;
wire [RAB_DATA_WIDTH-1:0] mcu_rab_wdata;
wire [RAB_DATA_WIDTH-1:0] mcu_rab_rdata;
wire                rab_write;
wire                rab_read ;
wire                rab_ack;
wire [RAB_ADDR_WIDTH-1:0] rab_addr;
wire [RAB_DATA_WIDTH-1:0] rab_wdata;
wire [RAB_DATA_WIDTH-1:0] rab_rdata;

wire     [7:0]     romdata   ;
wire     [7:0]     xram_rdata ;
wire     [7:0]     xram_wdata ;

assign  swd = 1'b0;
assign  mem_rdata = mempsrd_d ? romdata : xram_rdata;
assign  xram_wdata =  mem_wdata ;

// instance I2C slave
i2cs_top i2cs(
          .sys_clk  (sys_clk    ),
          .sys_rst  (sys_rst    ),
          .io_resetb(io_resetb  ),

          .sda_oe   (io_csda_oe ),
          .sda_in   (io_csda_in ),
          .sda_out  (io_csda_out),
          .scl      (io_cscl    ),
          .i2ca     (io_ci2ca   ),

          .rab_write  (i2cs_rab_write),
          .rab_read   (i2cs_rab_read ),
          .rab_addr   (i2cs_rab_addr ),
          .rab_wdata  (i2cs_rab_wdata),
          .rab_ack    (i2cs_rab_ack  ),
          .rab_rdata  (i2cs_rab_rdata),
          
          .ana_all_reg(ana_all_reg),
          
          .scan_mode(scan_mode)
);

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
          .memdatai(mem_rdata ),
          .memdatao(mem_wdata ),
          .memaddr (memaddr   ),
          .memwr   (memwr     ),
          .memrd   (memrd     ),
          .mempsrd (mempsrd   ),
          .mempswr (mempswr   ),

// Internal RAM IF
          .ramdatai(iram_rdata),
          .ramdatao(iram_wdata),
          .ramaddr (iram_addr),
          .ramwe   (iram_we),
          .ramoe   (iram_oe),

// SFR IF
          .sfrdatai(8'b0),
          .sfrdatao(sfrdatao),
          .sfraddr(sfraddr[6:0]),
          .sfrwe(sfrwe),
          .sfroe(sfroe)
);


//instance I2C master
i2cm_top i2cm(
        //inputs
        .sys_clk    (sys_clk   )   ,
        .sys_rst    (sys_rst   )   ,
        .baseaddr   (5'h2      )   ,
        .rab_write  (rab_write )   ,
        .rab_read   (rab_read  )   ,
        .rab_addr   (rab_addr  )   ,
        .rab_wdata  (rab_wdata )   ,

        .io_scl_in  (io_dscl_in )  ,
        .io_sda_in  (io_dsda_in )  ,

        .io_scl_out (io_dscl_out)  ,
        .io_sda_out (io_dsda_out)  ,
        .io_scl_oe  (io_dscl_oe )  ,
        .io_sda_oe  (io_dsda_oe )  ,

        .i2cm_rdata (i2cm_rdata )  ,
        .i2cm_ack   (i2cm_ack   )  ,
        .rfifo_wordcnt (    )
);

// Memory Area
`ifdef FPGA
mcu_pram16k8 program_ram(
         .douta     (pram_rdata )  ,
         .clka      (sys_clk    )  ,
         .ena       (~pram_cen   )  ,
         .wea       (~pram_wen   )  ,
         .addra     (pram_addr[13:0]  )  ,
         .dina      (pram_wdata )  
);

mcu_sram4k8 data_ram(
         .douta     (dram_rdata )  ,
         .clka      (sys_clk    )  ,
         .ena       (~dram_cen  )  ,
         .wea       (~dram_wen  )  ,
         .addra     (dram_addr  )  ,
         .dina      (dram_wdata )  
);

mcu_sprf256x8 internal_ram(
         .douta    (iram_rdata ),
         .clka     (!sys_clk   ),
         .ena      (~iram_cen   ),
         .wea      (~iram_wen   ),
         .addra    (iram_addr  ),
         .dina     (iram_wdata )
);


`else
mcu_pram16k8 program_ram(
         .Q         (pram_rdata )  ,
         .CLK       (sys_clk    )  ,
         .CEN       (pram_cen   )  ,
         .WEN       (pram_wen   )  ,
         .A         (pram_addr[13:0]  )  ,
         .D         (pram_wdata )  ,
         .OEN       (1'b0       ) 
);

mcu_sram4k8 data_ram(
         .Q         (dram_rdata )  ,
         .CLK       (sys_clk    )  ,
         .CEN       (dram_cen   )  ,
         .WEN       (dram_wen   )  ,
         .A         (dram_addr  )  ,
         .D         (dram_wdata )  ,
         .OEN       (1'b0       )  
);

mcu_sprf256x8 internal_ram(
         .Q        (iram_rdata ),
         .CLK      (!sys_clk   ),
         .CEN      (iram_cen   ),
         .WEN      (iram_wen   ),
         .A        (iram_addr  ),
         .D        (iram_wdata )
);
`endif
// instance pram_if
pram_if pram_if(
         .sys_clk   ( sys_clk   ),
         .sys_rst   ( sys_rst   ),
         .r80515_reset( r80515_reset),
         .prog_mode ( prog_mode ),
         .rab_write ( rab_write ),
         .rab_read  ( rab_read  ),
         .rab_addr  ( rab_addr  ),
         .rab_wdata ( rab_wdata ),
         .rab_rdata ( rab_pram_rdata ),
         .rab_ack   ( rab_pram_ack   ),

         .pram_rdata( pram_rdata),
         .pram_wen  ( pram_wen  ),
         .pram_cen  ( pram_cen  ),
         .pram_addr ( pram_addr ),
         .pram_wdata( pram_wdata),

         .memaddr   ( memaddr   ),
         .romdata   ( romdata   ),
         .mempsrd   ( mempsrd   ),
         .mempsrd_d ( mempsrd_d )
 );

//instance arbiter
arbiter arbiter(
          .sys_clk(sys_clk),
          .sys_rst(sys_rst),

          .mcu_rab_write  (mcu_rab_write ),
          .mcu_rab_read   (mcu_rab_read  ),
          .mcu_rab_addr   (mcu_rab_addr  ),
          .mcu_rab_wdata  (mcu_rab_wdata ),     
          .mcu_rab_ack    (mcu_rab_ack   ),
          .mcu_rab_rdata  (mcu_rab_rdata ),     

          .i2cs_rab_write (i2cs_rab_write),
          .i2cs_rab_read  (i2cs_rab_read ),
          .i2cs_rab_addr  (i2cs_rab_addr ),
          .i2cs_rab_wdata (i2cs_rab_wdata),
          .i2cs_rab_ack   (i2cs_rab_ack  ),
          .i2cs_rab_rdata (i2cs_rab_rdata),

          .rab_write      (rab_write   ),
          .rab_read       (rab_read    ),
          .rab_addr       (rab_addr    ),
          .rab_wdata      (rab_wdata   ),
          .rab_ack        (rab_ack     ),
          .rab_rdata      (rab_rdata   )
          );

//instance dram_if
 dram_if dram_if(
       .memaddr       ( memaddr    ),
       .memwr         ( memwr      ),
       .memrd         ( memrd_s    ),
       .xram_wdata    ( xram_wdata ),
       .xram_rdata    ( xram_rdata ),

       .dram_rdata    ( dram_rdata ),
       .dram_rd       ( dram_rd    ),
       .dram_wr       ( dram_wr    ),
       .dram_addr     ( dram_addr  ),
       .dram_wdata    ( dram_wdata ),

       .mcu_rab_ack   ( mcu_rab_ack),
       .mcu_rab_rdata ( mcu_rab_rdata ),
       .mcu_rab_wdata ( mcu_rab_wdata ),
       .mcu_rab_write ( mcu_rab_write ),
       .mcu_rab_read  ( mcu_rab_read  ),
       .mcu_rab_addr  ( mcu_rab_addr  )
);

cen_wen cwen_dram (
        .sys_clk(sys_clk    ),
        .sys_rst(sys_rst    ),
        .wr     (dram_wr    ),
        .rd     (dram_rd    ),
        .cen    (dram_cen   ),
        .wen    (dram_wen   ),
        .memrd  (memrd      ),
        .memrd_s(memrd_s    )
        );

hq_reg_file hq_reg_file(
        .sys_clk  (sys_clk  ),
        .sys_rst  (sys_rst  ),
        .chip_version( chip_version   ),

        .rab_write ( rab_write ),
        .rab_read  ( rab_read  ),
        .rab_addr  ( rab_addr  ),
        .rab_wdata ( rab_wdata ),

        .rab_ack   ( rab_ack   ),
        .rab_rdata ( rab_rdata ),

        .pram_rdata ( rab_pram_rdata ),
        .pram_ack   ( rab_pram_ack   ),

        .r80515_reset ( r80515_reset ),
        .prog_mode    ( prog_mode    )
);



endmodule


