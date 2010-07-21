//*******************************************************************--
// Copyright (c) 1999-2002  Evatronix SA                             --
//*******************************************************************--
// Please review the terms of the license agreement before using     --
// this file. If you are not an authorized user, please destroy this --
// source code file and notify Evatronix SA immediately that you     --
// inadvertently received an unauthorized copy.                      --
//*******************************************************************--
//---------------------------------------------------------------------
// Project name         : R80515
// Project description  : R80515 Microcontroller Unit
//
// File name            : r80515.v
// File contents        : Module R80515
// Purpose              : Top-level structure of R80515
//                        Synthesisable HDL Core specifically designed
//                        for reusability.
//
// Destination library  : R80515_LIB
//
// Design Engineer      : M.B.
// Co-design Engineer   : D.L D.K. A.B. R.Z.
// Quality Engineer     : M.B.
// Version              : 1.10.V05
// Last modification    : 2002-01-08
//---------------------------------------------------------------------

`timescale 1 ns / 1 ns // timescale for following modules

//*******************************************************************--
// Modifications with respect to Version 1.01.E00 :
// 1.01.E01   :
// 1999-11-25 : Removed output rxd1o
// 1.10.E00   :
// 2001-09-03 : Implemented PMU unit
//            : Added clkpero, clkcpuo outputs
//            : Added clkper, clkcpu inputs
//*******************************************************************--

module R80515
   (
   scan_mode,   
   clk,
   clkcpu,
   clkper,
   reset,
   swd,
   port0i,
   port1i,
   port2i,
   port3i,
   int0,
   int1,
   int2,
   int3,
   int4,
   int5,
   int6,
   cc0,
   cc1,
   cc2,
   cc3,
   rxd0i,
   rxd1i,
   t0,
   t1,
   t2,
   t2ex,
   clkcpuo,
   clkpero,
   port0o,
   port1o,
   port2o,
   port3o,
   rxd0o,
   txd0,
   txd1,
   memdatai,
   memdatao,
   memaddr,
   mempswr,
   mempsrd,
   memwr,
   memrd,
   ramdatai,
   ramdatao,
   ramaddr,
   ramwe,
   ramoe,
   sfrdatai,
   sfrdatao,
   sfraddr,
   sfrwe,
   sfroe
   );

   
   
   //  Control signal inputs
   input    clk;           // Global clock input
   input    clkcpu;        // CPU clock input
   input    clkper;        // Peripheral clock input
   input    reset;         // Hardware reset input
   input    swd;           // Start Watchdog Timer input
   
   //  Port inputs
   input    [7:0] port0i; 
   input    [7:0] port1i; 
   input    [7:0] port2i; 
   input    [7:0] port3i; 
   
   //  External interrupt/Port alternate signals
   input    int0;          // External interrupt 0
   input    int1;          // External interrupt 1
   input    int2;          // External interrupt 2
   input    int3;          // External interrupt 3
   input    int4;          // External interrupt 4
   input    int5;          // External interrupt 5
   input    int6;          // External interrupt 6
   
   //  Compare Capture/Port alternate signals
   input    cc0;           // Compare/Capture 0 input
   input    cc1;           // Compare/Capture 1 input
   input    cc2;           // Compare/Capture 2 input
   input    cc3;           // Compare/Capture 3 input
   
   //  Serial/Port alternate signals
   input    rxd0i;         // Serial 0 receive data
   input    rxd1i;         // Serial 1 receive data
   
   //  Timer/Port alternate signals
   input    t0;            // Timer 0 external input
   input    t1;            // Timer 1 external input
   input    t2;            // Timer 2 external input
   input    t2ex;          // Timer 2 capture trigger
   
   //  Control signal outputs
   output   clkcpuo;       // CPU clock input
   wire     clkcpuo;
   output   clkpero;       // Peripheral clock input
   wire     clkpero;
           
   //  Port outputs
   output   [7:0] port0o; 
   wire     [7:0] port0o;
   output   [7:0] port1o; 
   wire     [7:0] port1o;
   output   [7:0] port2o; 
   wire     [7:0] port2o;
   output   [7:0] port3o; 
   wire     [7:0] port3o;
   
   //  Serial/Port alternate signals
   output   rxd0o;         // Serial 0 receive clock
   wire     rxd0o;
   output   txd0;          // Serial 0 transmit data
   wire     txd0;
   output   txd1;          // Serial 1 transmit data
   wire     txd1;
   
   //  Memory interface
   input    [7:0] memdatai; 
   output   [7:0] memdatao; 
   wire     [7:0] memdatao;
   output   [15:0] memaddr; 
   wire     [15:0] memaddr;
   output   mempswr;       // Program store write enable
   wire     mempswr;
   output   mempsrd;       // Program store read enable
   wire     mempsrd;
   output   memwr;         // Memory write enable
   wire     memwr;
   output   memrd;         // Memory read enable
   wire     memrd;
   
   //  Data file interface
   input    [7:0] ramdatai; 
   output   [7:0] ramdatao; 
   wire     [7:0] ramdatao;
   output   [7:0] ramaddr; 
   wire     [7:0] ramaddr;
   output   ramwe;         // Data file write enable
   wire     ramwe;
   output   ramoe;         // Data file output enable
   wire     ramoe;
   
   //  Data file interface
   input    [7:0] sfrdatai; 
   output   [7:0] sfrdatao; 
   wire     [7:0] sfrdatao;
   output   [6:0] sfraddr; 
   wire     [6:0] sfraddr;
   output   sfrwe;         // SFR write enable
   wire     sfrwe;
   output   sfroe; 
   wire     sfroe;

   // For DFT
   input    scan_mode;

   //---------------------------------------------------------------

   //---------------------------------------------------------------
   // ADC interrupt flag
   //---------------------------------------------------------------
   wire     iadc; 
   
   //---------------------------------------------------------------
   // Special function register interface
   //---------------------------------------------------------------
   wire     int_sfrwe; 
   wire     int_sfroe; 
   
   //---------------------------------------------------------------
   // Aritmetic Logic Unit
   //---------------------------------------------------------------
   wire     [7:0] accreg; 
   wire     [7:0] aluresult; 
   wire     [1:0] regsbank; 
   wire     bitvalue; 
   wire     cdjump; 
   wire     cyflag; 
   wire     [7:0] sfrdataalu; 
   
   //---------------------------------------------------------------
   // Clock Control Unit signals
   //---------------------------------------------------------------
   wire     smod;          // Baud rate Doubler
   wire     [2:0] stretch;
   wire     [7:0] sfrdataclk;
   wire     mempsack;
   wire     [7:0] ckcon;        // Add by lishuang, 09/07/29

   
   //---------------------------------------------------------------
   // Control Processor Unit signals
   //---------------------------------------------------------------
   wire     [7:0] instr; 
   wire     [3:0] cycle;   // Current machine cycle
   wire     codefetche;    // Opcode fetch enable
   wire     datafetche;    // Data fetch enable
   wire     rmwinstr;      // Read-Modify-Write Instr.
   wire     intack;        // Interrupt acknowledge flag
   wire     intret;        // Interrupt return flag
   wire     intcall;       // Interrupt call
   
   //---------------------------------------------------------------
   // Interrupt Service Routine Unit signals
   //---------------------------------------------------------------
   wire     t0ack;         // Timer 0 int. acknowledge
   wire     t1ack;         // Timer 1 int. acknowledge 
   wire     int0ack;       // External int0 acknowledge
   wire     int1ack;       // External int1 acknowledge
   wire     wdt;           // WDT refresh flag
   wire     intreq;        // Interrupt request flag
   wire     [4:0] intvect;
   wire     [3:0] isreg;
   wire     [1:0] intprior0;
   wire     [1:0] intprior1;
   wire     eal;           // all enable
   wire     eint0;         // int0 enable
   wire     eint1;         // int1 enable
   wire     [7:0] sfrdataisr; 
   
   //---------------------------------------------------------------
   // Multiplication Division Unit signals
   //---------------------------------------------------------------
   wire     [7:0] sfrdatamdu; 
   
   //---------------------------------------------------------------
   // Power Management Unit
   //---------------------------------------------------------------
   wire     rst;           // reset
   wire     mempsrdrst;    // memory read signal reset
   wire     stoppmu;       // stop mode

   //---------------------------------------------------------------
   // Port registers unit signals
   //---------------------------------------------------------------
   wire     [7:0] sfrdataports; 
   
   //---------------------------------------------------------------
   // Memory Control Unit signals
   //---------------------------------------------------------------
   wire     mem2acc;       // Memory to ACC write enable
   wire     [7:0] pclreg; 
   wire     [7:0] pchreg; 
   wire     [7:0] sfrdatamcu; 
   wire     ram2memaddr;   // RAM to MemAddr write enable
   wire     memps_rd;

   
   //---------------------------------------------------------------
   // 256B Data Memory and Special Function Registers Control Unit
   //---------------------------------------------------------------
   wire     [7:0] ramsfrdata; 
   wire     [7:0] sfrdataout; 
   wire     [7:0] ramsfraddr; 
   wire     [7:0] ramdataout; 
   
   //---------------------------------------------------------------
   // Serial Interface Unit 0 signals
   //---------------------------------------------------------------
   wire     ri0;           // Serial 0 receive flag
   wire     ti0;           // Serial 0 transmit flag
   wire     [7:0] sfrdataser0; 
   
   //---------------------------------------------------------------
   // Serial Interface Unit 1 signals
   //---------------------------------------------------------------
   wire     ri1;           // Serial 1 receive flag
   wire     ti1;           // Serial 1 transmit flag
   wire     [7:0] sfrdataser1; 
   
   //---------------------------------------------------------------
   // Timer/Counter 0 and 1 signals
   //---------------------------------------------------------------
   wire     tf0;           // Timer 0 overflow flag
   wire     tf1;           // Timer 1 overflow flag
   wire     ie0;           // Interrupt 0 edge detect
   wire     ie1;           // Interrupt 1 edge detect
   wire     it0;           // Interrupt 0 edge/low sel.
   wire     it1;           // Interrupt 1 edge/low sel.
   wire     t1ov;          // Timer 1 overflow output
   wire     [7:0] sfrdatatim; 
   
   //---------------------------------------------------------------
   // Timer/Counter 2 and Capture/Compare Unit signals
   //---------------------------------------------------------------
   wire     com0;          // Compare 0 output
   wire     com1;          // Compare 1 output
   wire     com2;          // Compare 2 output
   wire     com3;          // Compare 3 output
   wire     i2fr; 
   wire     i3fr; 
   wire     tf2;           // Timer 2 overflow signal
   wire     exf2;          // Timer 2 external signal
   wire     [3:0] ccubus; 
   wire     [7:0] sfrdatatim2; 
   wire     [7:0] ccenreg; 
   
   //---------------------------------------------------------------
   // Programmable Watchdog Timer signals
   //---------------------------------------------------------------
   wire     wdts;             // WDT status flag
   wire     [7:0] sfrdatawdt; 

   //------------------------------------------------------------------
   // Program memory read
   //------------------------------------------------------------------
   assign mempsrd = memps_rd;
   
   //------------------------------------------------------------------
   // Data file interface
   // Data bus output
   //------------------------------------------------------------------
   assign ramdatao = ramdataout ; 
   
   //------------------------------------------------------------------
   // Data file interface
   // Address bus output
   //------------------------------------------------------------------
   assign ramaddr = ramsfraddr ; 
   
   //------------------------------------------------------------------
   // External Special function register interface
   // Data bus output
   //------------------------------------------------------------------
   assign sfrdatao = sfrdataout ; 
   
   //------------------------------------------------------------------
   // External Special function register interface
   // Address bus output
   //------------------------------------------------------------------
   assign sfraddr = ramsfraddr[6:0] ; 
   
   //------------------------------------------------------------------
   // External Special function register interface
   // Write enable output
   //------------------------------------------------------------------
   assign sfrwe = int_sfrwe ; 
   
   //------------------------------------------------------------------
   // External Special function register interface
   // Output enable output
   //------------------------------------------------------------------
   assign sfroe = int_sfroe ; 
   
   //------------------------------------------------------------------
   // ADC interrupt flag
   //------------------------------------------------------------------
   assign iadc = 1'b0 ; 
   
   //---------------------------------------------------------------
   // Aritmetic Logic Unit
   //---------------------------------------------------------------
   ALU U_ALU
      (
      .clk           (clkcpu),
      .rst           (rst),
      .mempsack      (mempsack),
      .instr         (instr),
      .cycle         (cycle),
      .memdatai      (memdatai),
      .mem2acc       (mem2acc),
      .ramsfrdata    (ramsfrdata),
      .accreg        (accreg),
      .aluresult     (aluresult),
      .regsbank      (regsbank),
      .bitvalue      (bitvalue),
      .cdjump        (cdjump),
      .cyflag        (cyflag),
      .sfrdatai      (sfrdataout),
      .sfrdataalu    (sfrdataalu),
      .sfraddr       (ramsfraddr[6:0]),
      .sfrwe         (int_sfrwe)
      ); 
      
   //---------------------------------------------------------------
   // Clock Control Unit
   //---------------------------------------------------------------
   CLOCK_CONTROL U_CLKCTRL
      (
      .clk           (clkper),
      .rst           (rst),
      .mempsrd       (memps_rd),
      .smod          (smod),
      .stretch       (stretch),
      .mempsack      (mempsack),
      .sfrdatai      (sfrdataout),
      .sfrdataclk    (sfrdataclk),
      .sfraddr       (ramsfraddr[6:0]),
      .sfrwe         (int_sfrwe),
      .ckcon         (ckcon)            //add by lishuang, 09/07/29
      );
      
   //---------------------------------------------------------------
   // Control Processor Unit
   //---------------------------------------------------------------
   CONTROL_UNIT U_CPU
      (
      .clk           (clkcpu),
      .rst           (rst),
      .mempsack      (mempsack),
      .intreq        (intreq),
      .stretch       (stretch),
      .stoppmu       (stoppmu),
      .instr         (instr),
      .cycle         (cycle),
      .codefetche    (codefetche),
      .datafetche    (datafetche),
      .rmwinstr      (rmwinstr),
      .intack        (intack),
      .intret        (intret),
      .intcall       (intcall),
      .memdatai      (memdatai)
      ); 
   
   //---------------------------------------------------------------
   // Interrupt Service Routine Unit
   //---------------------------------------------------------------
   ISR U_ISR
      (
      .clk           (clkper),
      .rst           (rst),
      .cycle         (cycle),
      .instr         (instr),
      .codefetche    (codefetche),
      .tf0           (tf0),
      .ie0           (ie0),
      .tf1           (tf1),
      .ie1           (ie1),
      .tf2           (tf2),
      .exf2          (exf2),
      .int2          (int2),
      .int3          (int3),
      .int4          (int4),
      .int5          (int5),
      .int6          (int6),
      .com0          (com0),
      .com1          (com1),
      .com2          (com2),
      .com3          (com3),
      .ccenreg       (ccenreg),
      .ri0           (ri0),
      .ti0           (ti0),
      .ri1           (ri1),
      .ti1           (ti1),
      .iadc          (iadc),
      .i2fr          (i2fr),
      .i3fr          (i3fr),
      .wdts          (wdts),
      .intret        (intret),
      .intack        (intack),
      .intprior0     (intprior0),
      .intprior1     (intprior1),
      .eal           (eal),
      .eint0         (eint0),
      .eint1         (eint1),
      .t0ack         (t0ack),
      .t1ack         (t1ack),
      .int0ack       (int0ack),
      .int1ack       (int1ack),
      .wdt           (wdt),
      .intvect       (intvect),
      .intreq        (intreq),
      .isreg         (isreg),
      .sfrdatai      (sfrdataout),
      .sfrdataisr    (sfrdataisr),
      .sfraddr       (ramsfraddr[6:0]),
      .sfrwe         (int_sfrwe),
      .ckcon         (ckcon),          //add by lishuang, 09/07/29
      .mempsack      (mempsack)        //add by lishuang, 09/07/29
      ); 
   
   //---------------------------------------------------------------
   // Multiplication Division Unit
   //---------------------------------------------------------------
   MDU U_MDU
      (
      .clk           (clkper),
      .rst           (rst),
      .sfrdatai      (sfrdataout),
      .sfrdatamdu    (sfrdatamdu),
      .sfraddr       (ramsfraddr[6:0]),
      .sfrwe         (int_sfrwe),
      .sfroe         (int_sfroe)
      ); 
   
   //---------------------------------------------------------------
   // External Memory Control Unit
   //---------------------------------------------------------------
   MEMORY_CONTROL U_MEMCTRL
      (
      .clk           (clkcpu),
      .rst           (rst),
      .mempsack      (mempsack),
      .instr         (instr),
      .cycle         (cycle),
      .codefetche    (codefetche),
      .datafetche    (datafetche),
      .accreg        (accreg),
      .bitvalue      (bitvalue),
      .cdjump        (cdjump),
      .cyflag        (cyflag),
      .stretch       (stretch),
      .intreq        (intreq),
      .intcall       (intcall),
      .intvect       (intvect),
      .ramdatai      (ramdatai),
      .mempsrdrst    (mempsrdrst),
      .mem2acc       (mem2acc),
      .pclreg        (pclreg),
      .pchreg        (pchreg),
      .ram2memaddr   (ram2memaddr),
      .memdatai      (memdatai),
      .memdatao      (memdatao),
      .memaddr       (memaddr),
      .mempswr       (mempswr),
      .mempsrd       (memps_rd),
      .memwr         (memwr),
      .memrd         (memrd),
      .sfrdatai      (sfrdataout),
      .sfrdatamcu    (sfrdatamcu),
      .sfraddr       (ramsfraddr[6:0]),
      .sfrwe         (int_sfrwe)
      ); 

   //---------------------------------------------------------------
   // Poower Management Unit
   //---------------------------------------------------------------
   PMU U_PMU
      (
      .scan_mode     (scan_mode),
      .clk           (clk),
      .rst           (rst),
      .reset         (reset),
      .wdts          (wdts),
      .intreq        (intreq),
      .int0          (int0),
      .int1          (int1),
      .it0           (it0),
      .it1           (it1),
      .isreg         (isreg),
      .intprior0     (intprior0),
      .intprior1     (intprior1),
      .eal           (eal),
      .eint0         (eint0),
      .eint1         (eint1),
      .rsto          (rst),
      .clkcpu        (clkcpuo),
      .clkper        (clkpero),
      .mempsrdrst    (mempsrdrst),
      .stoppmu       (stoppmu),
      .sfrdatai      (sfrdataout),
      .sfraddr       (ramsfraddr[6:0]),
      .sfrwe         (int_sfrwe)
      );
      
   //---------------------------------------------------------------
   // Port registers unit
   //---------------------------------------------------------------
   PORTS U_PORTS
      (
      .clk           (clkper),
      .rst           (rst),
      .port0i        (port0i),
      .port1i        (port1i),
      .port2i        (port2i),
      .port3i        (port3i),
      .rmwinstr      (rmwinstr),
      .ccubus        (ccubus),
      .port0o        (port0o),
      .port1o        (port1o),
      .port2o        (port2o),
      .port3o        (port3o),
      .sfrdatai      (sfrdataout),
      .sfrdataports  (sfrdataports),
      .sfraddr       (ramsfraddr[6:0]),
      .sfrwe         (int_sfrwe)
      ); 
   
   //---------------------------------------------------------------
   // 256B Data Memory and Special Function Registers Control Unit
   //---------------------------------------------------------------
   RAM_SFR_CONTROL U_RAMSFRCTRL
      (
      .clk           (clkcpu),
      .rst           (rst),
      .mempsack      (mempsack),
      .instr         (instr),
      .cycle         (cycle),
      .codefetche    (codefetche),
      .intreq        (intreq),
      .regsbank      (regsbank),
      .accreg        (accreg),
      .aluresult     (aluresult),
      .pclreg        (pclreg),
      .pchreg        (pchreg),
      .memdatai      (memdatai),
      .ram2memaddr   (ram2memaddr),
      .ramsfrdata    (ramsfrdata),
      .ramsfraddr    (ramsfraddr),
      .ramdatai      (ramdatai),
      .ramdatao      (ramdataout),
      .ramwe         (ramwe),
      .ramoe         (ramoe),
      .sfrdataalu    (sfrdataalu),
      .sfrdataclk    (sfrdataclk),
      .sfrdataisr    (sfrdataisr),
      .sfrdatamdu    (sfrdatamdu),
      .sfrdatamcu    (sfrdatamcu),
      .sfrdataports  (sfrdataports),
      .sfrdataser0   (sfrdataser0),
      .sfrdataser1   (sfrdataser1),
      .sfrdatatim    (sfrdatatim),
      .sfrdatatim2   (sfrdatatim2),
      .sfrdatawdt    (sfrdatawdt),
      .sfrdataext    (sfrdatai),
      .sfrdatao      (sfrdataout),
      .sfrwe         (int_sfrwe),
      .sfroe         (int_sfroe)
      ); 
   
   //---------------------------------------------------------------
   // Serial Interface Unit 0
   //---------------------------------------------------------------
   SERIAL_0 U_SERIAL0
      (
      .clk           (clkper),
      .rst           (rst),
      .cycle         (cycle),
      .rxd0i         (rxd0i),
      .t1ov          (t1ov),
      .smod          (smod),
      .ri0           (ri0),
      .ti0           (ti0),
      .rxd0o         (rxd0o),
      .txd0          (txd0),
      .sfrdatai      (sfrdataout),
      .sfrdataser0   (sfrdataser0),
      .sfraddr       (ramsfraddr[6:0]),
      .sfrwe         (int_sfrwe)
      ); 
   
   //---------------------------------------------------------------
   // Serial Interface Unit 1
   //---------------------------------------------------------------
   SERIAL_1 U_SERIAL1
      (
      .clk           (clkper),
      .rst           (rst),
      .rxd1i         (rxd1i),
      .txd1          (txd1),
      .ri1           (ri1),
      .ti1           (ti1),
      .sfrdatai      (sfrdataout),
      .sfrdataser1   (sfrdataser1),
      .sfraddr       (ramsfraddr[6:0]),
      .sfrwe         (int_sfrwe)
      ); 
   
   //---------------------------------------------------------------
   // Timer/Counter 0 and 1
   //---------------------------------------------------------------
   TIMER_0_1 U_TIMER
      (
      .clk           (clkper),
      .rst           (rst),
      .cycle         (cycle),
      .t0            (t0),
      .t1            (t1),
      .t0ack         (t0ack),
      .t1ack         (t1ack),
      .int0          (int0),
      .int1          (int1),
      .int0ack       (int0ack),
      .int1ack       (int1ack),
      .tf0           (tf0),
      .tf1           (tf1),
      .ie0           (ie0),
      .ie1           (ie1),
      .it0           (it0),
      .it1           (it1),
      .t1ov          (t1ov),
      .sfrdatai      (sfrdataout),
      .sfrdatatim    (sfrdatatim),
      .sfraddr       (ramsfraddr[6:0]),
      .sfrwe         (int_sfrwe)
      ); 
   
   //---------------------------------------------------------------
   // Timer/Counter 2 and Capture/Compare Unit
   //---------------------------------------------------------------
   TIMER_2 U_TIMER2
      (
      .clk           (clkper),
      .rst           (rst),
      .t2            (t2),
      .t2ex          (t2ex),
      .cc0           (cc0),
      .cc1           (cc1),
      .cc2           (cc2),
      .cc3           (cc3),
      .com0          (com0),
      .com1          (com1),
      .com2          (com2),
      .com3          (com3),
      .ccenreg       (ccenreg),
      .i2fr          (i2fr),
      .i3fr          (i3fr),
      .tf2           (tf2),
      .exf2          (exf2),
      .ccubus        (ccubus),
      .sfrdatai      (sfrdataout),
      .sfrdatatim2   (sfrdatatim2),
      .sfraddr       (ramsfraddr[6:0]),
      .sfrwe         (int_sfrwe)
      ); 
   
   //---------------------------------------------------------------
   // Programmable Watchdog Timer
   //---------------------------------------------------------------
   WATCHDOG_TIMER U_WDT
      (
      .clk           (clkper),
      .rst           (rst),
      .wdt           (wdt),
      .swd           (swd),
      .wdts          (wdts),
      .sfrdatai      (sfrdataout),
      .sfrdatawdt    (sfrdatawdt),
      .sfraddr       (ramsfraddr[6:0]),
      .sfrwe         (int_sfrwe)
      ); 


endmodule //  module R80515

//*******************************************************************--
