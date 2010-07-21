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
// File name            : pmu.v
// File contents        : Module PMU
// Purpose              : Power Management Unit
//
// Destination library  : R80515_LIB
//
// Design Engineer      : D.K.
// Quality Engineer     : M.B.
// Version              : 1.10.V05
// Last modification    : 2002-01-08
//---------------------------------------------------------------------

`timescale 1 ns / 1 ns // timescale for following modules

//*******************************************************************--
// Modifications with respect to Version 1.10.E00 :
// 1.10.E00   :
// 2001-09-03 : The PMU is added to this version
// 1.10.E01   :
// 2001-11-13 : Modified reset_synchro_proc. Removed rst loop.
//*******************************************************************--

module PMU (
   scan_mode,
   clk,
   rst,
   reset,
   wdts,
   intreq,
   int0,
   int1,
   it0,
   it1,
   isreg,
   intprior0,
   intprior1,
   eal,
   eint0,
   eint1,
   rsto,
   clkcpu,
   clkper,
   mempsrdrst,
   stoppmu,
   sfrdatai,
   sfraddr,
   sfrwe
   );

   //  Declarations
   `include "utility.v"
   
   //  Control signals inputs
   input    clk;              // Global clock input
   input    rst;              // Internal reset input
   input    reset;            // Hardware reset input
   
   //  Watchdog Timer reset request
   input    wdts;             // WDT status flag
   
   //  Interrupt requests
   input    intreq;           // from ISR
   input    int0;             // external interrupt 0
   input    int1;             // external interrupt 1
   
   //  External interrupt type select
   input    it0;              // interrupt 0 type select
   input    it1;              // interrupt 1 type select
   
   //  In service register
   input    [3:0] isreg; 
   
   //  Interrupt Priority registers
   input    [1:0] intprior0; 
   input    [1:0] intprior1; 
   
   //  Interrupt mask
   input    eal;              // Enable all interrupts 
   input    eint0;            // external interrupt 0 mask
   input    eint1;            // external interrupt 1 mask
   
   //  Power Management Unit outputs
   output   rsto;             // Internal reset driver
   //reg      rsto;
   wire     rsto;
   output   clkcpu;           // CPU Clock
   wire     clkcpu;
   output   clkper;           // Peripheral Clock
   wire     clkper;
   output   mempsrdrst;       // memory read signal reset
   wire     mempsrdrst;
   output   stoppmu;          // stop mode
   wire     stoppmu;
   
   //  Special function register interface
   input    [7:0] sfrdatai; 
   input    [6:0] sfraddr; 
   input    sfrwe; 

   // For DFT
   input    scan_mode;
   
   //*******************************************************************--
   wire     idle;             // Idle mode
   wire     stop;             // Stop mode
   wire     int_req_c;        // Interrupt request comb.
   reg      int_req;          // Interrupt request sync.
   reg      clkcpu_gate;      // CPU clock gate
   reg      clkper_gate;      // Peripherals clock gate
   reg      reset_ff;         // external reset flip-flop
   reg      rst_o;            // internal reset flip-flop
   
   // Watchdog Timer reset detector
   reg      wdts_ff; 
   reg      rsto_tmp;


   //------------------------------------------------------------------
   // Program memory read signal reset
   //------------------------------------------------------------------
   assign mempsrdrst = rst_o ; 
   
   //------------------------------------------------------------------
   // Stop mode driver
   //------------------------------------------------------------------
   assign stoppmu = stop ; 
   
   //------------------------------------------------------------------
   // IDLE mode detector
   //------------------------------------------------------------------
   assign idle =
      (
         (
            sfraddr == PCON_ID &
            sfrwe &
            (sfrdatai[0]
         )
      ) |
      !clkcpu_gate) ? 1'b1 : 1'b0 ; 
   
   //------------------------------------------------------------------
   // STOP mode detector
   //------------------------------------------------------------------
   assign stop =
      (
         (
            sfraddr == PCON_ID &
            sfrwe &
            (sfrdatai[1])
         ) |
         !clkper_gate
      ) ? 1'b1 : 1'b0 ; 
      
   //------------------------------------------------------------------
   // Combinational interrupt request
   // Low active 
   //------------------------------------------------------------------
   assign int_req_c =
   (
      (intreq) |                                         // ISR intreq
      (eal &
         (
            (!int0 & eint0 & !it0 &                      // ext. int. 0
               (
                  ((intprior0[0]) & (intprior1[0]) & !(isreg[3])) | //l3
                  (!(intprior0[0]) & (intprior1[0]) & !(isreg[3]) & //l2
                     !(isreg[2])) |
                  ((intprior0[0]) & !(intprior1[0]) & !(isreg[3]) & //l1
                     !(isreg[2]) & !(isreg[1])) |
                  (!(intprior0[0]) & !(intprior1[0]) & !(isreg[3])& //l0
                     !(isreg[2]) & !(isreg[1]) & !(isreg[0]))
               )
            ) |
            (!int1 & eint1 & !it1 &                      // ext. int. 1
               (
                  ((intprior0[1]) & (intprior1[1]) & !(isreg[3])) | //l3
                  (!(intprior0[1]) & (intprior1[1]) & !(isreg[3]) & //l2
                     !(isreg[2])) |
                  ((intprior0[1]) & !(intprior1[1]) & !(isreg[3]) & //l1
                     !(isreg[2]) & !(isreg[1])) |
                  (!(intprior0[1]) & !(intprior1[1]) & !(isreg[3])& //l0
                     !(isreg[2]) & !(isreg[1]) & !(isreg[0]))
               )
            )
         )
      )
   ) ? 1'b1 : 1'b0 ; 

   //------------------------------------------------------------------
   // Interrupt request
   // Synchronous section 
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : int_req_write_proc
   //------------------------------------------------------------------   
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      int_req <= 1'b0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      begin
      int_req <= int_req_c ; 
      end  
   end 

   //------------------------------------------------------------------
   // Gated clocks control
   // Active on falling edge of clock to avoid glitches on gate signals
   //------------------------------------------------------------------
   always @(negedge clk)
   begin : clk_gate_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      clkcpu_gate <= 1'b1 ; 
      clkper_gate <= 1'b1 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      begin
      clkcpu_gate <= int_req | ~(idle | stop) ; 
      clkper_gate <= int_req | ~stop ; 
      end  
   end 
   
   //------------------------------------------------------------------
   // CPU gate clock
   //------------------------------------------------------------------
   //assign clkcpu = clk & clkcpu_gate ; 
   assign clkcpu = clk & (clkcpu_gate | scan_mode) ;
   
   //------------------------------------------------------------------
   // Peripherals gated clock
   //------------------------------------------------------------------
   //assign clkper = clk & clkper_gate ; 
   assign clkper = clk & (clkper_gate | scan_mode) ; 

   //------------------------------------------------------------------
   // Reset synchronization
   // Active on falling edge to enable resetting registers clocked by
   // gated clocks
   //------------------------------------------------------------------
   always @(negedge clk)
   begin : reset_synchro_proc
   //------------------------------------------------------------------
/*   if (rst_o)
      begin
      rsto <= 1'b1 ; 
      end
   else
      begin
      rsto <= 1'b0 ; 
      end  
   end 
*/
   if (rst_o)
      begin
      rsto_tmp <= 1'b1 ;
      end
   else
      begin
      rsto_tmp <= 1'b0 ;
      end
   end
   assign rsto = scan_mode ? reset : rsto_tmp ;


   //------------------------------------------------------------------
   // Internal synchronous reset generator
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : reset_gen_proc
   //------------------------------------------------------------------
   //-----------------------------------
   // Synchronous write
   //-----------------------------------
   // internal reset flip-flop
   //-----------------------------------
   if ((reset & reset_ff) | (wdts & !wdts_ff))
      begin
      rst_o <= 1'b1 ; 
      end
   else
      begin
      rst_o <= 1'b0 ; 
      end 
      
   //-----------------------------------
   // reset input flip-flop
   //-----------------------------------
   reset_ff <= reset ;  
   
   end 

   //------------------------------------------------------------------
   // Watchdog timer status flag flip-flop
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : wdts_ff_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      wdts_ff <= 1'b0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      begin
      wdts_ff <= wdts ; 
      end  
   end 
   
endmodule // PMU

//*******************************************************************--
