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
// File name            : isr.v
// File contents        : Module ISR
// Purpose              : Interrupt service routine unit
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
// Modifications with respect to Version 1.01.E00 :
// 1.01.E01   :
// 1999-11-24 : Removed l0 signal from sensitivity list of 
//            : is_reg_comb_proc:
// 1.04.E00   :
// 2000-04-10 : Multiplexed external interrupt and CCU interrupt 
//            : Added inputs ccenreg, codefetche
//            : Removed input wdtclr
//            : Modified ien1_write proc: ien1(6) - stuck at zero
//            : Modified ien0_write proc: ien0(6)
//            : Modified sfr_read: ien0(6) - always read zero
// 2000-04-26 : Added instr and codefetche ports
//            : Removed flip_flop from Interrupt Request Comparator
//            : Interrupt Req. Comp. disabled during ISR register access
//            : int_vect_sync_proc: int_vect sampled at codefetche
// 2000-04-27 : The t0ack_sync_proc: t1ack_sync_proc: modified to avoid
//            : clearing the tf0, tf1 flags in case the intreq is
//            : active and interrupt with higher priority comes
// 1.04.E04   :
// 2000-09-25 : Added cycle port
// 2000-09-25 : ircon_write_proc: modified setting ext. int. flags
// 1.04.E05   :
// 2001-01-06 : Removed hardcoded values from  ircon_write_proc
// 1.04.E06   :
// 2001-05-10 : Added flip-flips int2_p0-int6_p0 between inputs
//            : int2-int6 and flip-flops int2_p2-int6_p2
// 2001-05-10 : Added registers for current priority level signals 
//            : l0-l3
// 1.10.E00   :
// 2001-09-03 : Added output ports: intprior0, intprior1, eal, eint0, 
//            : eint1, isreg
//            : Added timer 2 overflow flip-flop
// 1.10.E01   :
// 2001-11-13 : Modified ip0, int_vect, is_reg reset value from 
//            : hard-coded value on constant
//*******************************************************************--

module ISR
   (clk,
   rst,
   cycle,
   instr,
   codefetche,
   tf0,
   ie0,
   tf1,
   ie1,
   tf2,
   exf2,
   int2,
   int3,
   int4,
   int5,
   int6,
   com0,
   com1,
   com2,
   com3,
   ccenreg,
   ri0,
   ti0,
   ri1,
   ti1,
   iadc,
   i2fr,
   i3fr,
   wdts,
   intret,
   intack,
   intprior0,
   intprior1,
   eal,
   eint0,
   eint1,
   t0ack,
   t1ack,
   int0ack,
   int1ack,
   wdt,
   intvect,
   intreq,
   isreg,
   sfrdatai,
   sfrdataisr,
   sfraddr,
   sfrwe,
   ckcon,      //add by lishuang, 09/07/29ACK
   mempsack    //add by lishuang, 09/07/29ACK
   );

   
   // Declarations
   `include "utility.v"
   
   
   //  Control signals inputs
   input    clk;           // Global clock input
   input    rst;           // Global reset input
   
   //  CPU input signal - instruction register
   input    [3:0] cycle; 
   input    [7:0] instr; 
   input    codefetche;    // code fetch enable
   
   //  Timer 0 interrupt flags
   input    tf0;           // Timer 0 overflow flag
   input    ie0;           // Interrupt 0 edge detect
   
   //  Timer 1 interrupt flags
   input    tf1;           // Timer 1 overflow flag
   input    ie1;           // Interrupt 1 edge detect
   
   //  Timer 2/CCU interrupt flags
   input    tf2;           // Timer 2 overflow flag
   input    exf2;          // Timer 2 external flag
   
   //  External interrupt pins
   input    int2;          // External Interrupt 2 pin
   input    int3;          // External Interrupt 3 pin
   input    int4;          // External Interrupt 4 pin
   input    int5;          // External Interrupt 5 pin
   input    int6;          // External Interrupt 6 pin
   
   //  CCU outputs
   input    com0;          // compare output 0
   input    com1;          // compare output 1
   input    com2;          // compare output 2
   input    com3;          // compare output 3
   input    [7:0] ccenreg; //ccen reg.
   
   //  Serial 0 interrupt flags 
   input    ri0;           // Serial 0 receive flag
   input    ti0;           // Serial 0 transmit flag
   
   //  Serial 1 interrupt flags 
   input    ri1;           // Serial 1 receive flag
   input    ti1;           // Serial 1 transmit flag
   
   //  ADC interrupt flag
   input    iadc; 
   
   //  External interrupt falling/rising edge flag
   input    i2fr;          // Ext int 2 f/r edge flag
   input    i3fr;          // Ext int 3 f/r edge flag
   
   //  wdt status flag
   input    wdts; 
   
   //  Interrupt return signal
   input    intret; 
   
   //  Interrupt acknowledge signal
   input    intack; 
   
   //  From clock_control, add by lishuang, 09/07/29
   input    [7:0] ckcon;
   input    mempsack;
   
   //  Interrupt priority registers
   output   [1:0]intprior0;
   wire     [1:0]intprior0;
   output   [1:0]intprior1;
   wire     [1:0]intprior1;
   
   //  Interrupt mask
   output   eal;           // Enable all interrupts
   wire     eal;
   output   eint0;         // external interrupt 0 mask
   wire     eint0;
   output   eint1;         // external interrupt 1 mask
   wire     eint1;
           
   //  Timer 0,1 acknowledge output
   output   t0ack;         // Timer 0 int. acknowledge
   reg      t0ack;
   output   t1ack;         // Timer 1 int. acknowledge  
   reg      t1ack;
   
   //  External 0,1 acknowledge output
   output   int0ack;       // External int0 acknowledge
   reg      int0ack;
   output   int1ack;       // External int1 acknowledge
   reg      int1ack;
   
   //  Watchdog Timer control signals
   output   wdt;           // WDT refresh flag
   wire     wdt;
   
   //  Interrupt Service location
   output   [4:0] intvect; 
   wire     [4:0] intvect;
   
   //  Interrupt request signal
   output   intreq; 
   wire     intreq;
   
   //  In Service register
   output   [3:0]isreg;
   wire     [3:0]isreg;

   //  Special function register interface
   input    [7:0] sfrdatai; 
   output   [7:0] sfrdataisr; 
   wire     [7:0] sfrdataisr;
   input    [6:0] sfraddr; 
   input    sfrwe; 

   //------------------------------------------------------------------
   
   // Interrupt Enable registers 
   reg      [7:0] ien0; 
   reg      [7:0] ien1; 
   reg      [7:0] ien2; 
   
   // Interrupt Priority registers
   reg      [7:0] ip0; 
   reg      [7:0] ip1; 
   
   // Interrupt Request Control register
   reg      [7:0] ircon; 
   
   // In Service register
   reg      [3:0] is_reg; 
   reg      [3:0] is_nxt; 
   
   // External Interrupt flags 
   wire     iex2;          // int2 edge detect comb. output
   wire     iex3;          // int3 edge detect comb. output
   wire     iex4;          // int4 edge detect comb. output
   wire     iex5;          // int5 edge detect comb. output
   wire     iex6;          // int6 edge detect comb. output
   
   // External Interrupt flip-flops
   reg      tf2_ff;        // timer 2 overflow interrupt ff
   reg      exf2_ff;       // timer 2 external interrupt ff

   reg      int2_p2;       // last state int2 F/F
   reg      int3_p2;       // last state int3 F/F
   reg      int4_p2;       // last state int4 F/F
   reg      int5_p2;       // last state int5 F/F
   reg      int6_p2;       // last state int6 F/F
   
   wire     int3_p1;       // current state int3
   wire     int4_p1;       // current state int4
   wire     int5_p1;       // current state int5
   wire     int6_p1;       // current state int6
   
   reg      int2_p0;       // current state int2
   reg      int3_p0;       // current state int3
   reg      int4_p0;       // current state int4
   reg      int5_p0;       // current state int5
   reg      int6_p0;       // current state int6

   reg      iex2_ff;       // iex flip-flop
   reg      iex3_ff;       // iex flip-flop
   reg      iex4_ff;       // iex flip-flop
   reg      iex5_ff;       // iex flip-flop
   reg      iex6_ff;       // iex flip-flop
   
   // Interrupt levels
   reg      ie0_l3; 
   reg      ie0_l2; 
   reg      ie0_l1; 
   reg      ie0_l0; 
   reg      riti1_l3; 
   reg      riti1_l2; 
   reg      riti1_l1; 
   reg      riti1_l0; 
   reg      iadc_l3; 
   reg      iadc_l2; 
   reg      iadc_l1; 
   reg      iadc_l0; 
   reg      tf0_l3; 
   reg      tf0_l2; 
   reg      tf0_l1; 
   reg      tf0_l0; 
   reg      iex2_l3; 
   reg      iex2_l2; 
   reg      iex2_l1; 
   reg      iex2_l0; 
   reg      ie1_l3; 
   reg      ie1_l2; 
   reg      ie1_l1; 
   reg      ie1_l0; 
   reg      iex3_l3; 
   reg      iex3_l2; 
   reg      iex3_l1; 
   reg      iex3_l0; 
   reg      tf1_l3; 
   reg      tf1_l2; 
   reg      tf1_l1; 
   reg      tf1_l0; 
   reg      iex4_l3; 
   reg      iex4_l2; 
   reg      iex4_l1; 
   reg      iex4_l0; 
   reg      riti0_l3; 
   reg      riti0_l2; 
   reg      riti0_l1; 
   reg      riti0_l0; 
   reg      iex5_l3; 
   reg      iex5_l2; 
   reg      iex5_l1; 
   reg      iex5_l0; 
   reg      tfexf2_l3; 
   reg      tfexf2_l2; 
   reg      tfexf2_l1; 
   reg      tfexf2_l0; 
   reg      iex6_l3; 
   reg      iex6_l2; 
   reg      iex6_l1; 
   reg      iex6_l0; 
   wire     l3; 
   wire     l2; 
   wire     l1; 
   wire     l0; 
   reg      l3_reg;
   reg      l2_reg;
   reg      l1_reg;
   
   // Interrupt enable
   reg      ie0_en; 
   reg      riti1_en; 
   reg      iadc_en; 
   reg      tf0_en; 
   reg      iex2_en; 
   reg      ie1_en; 
   reg      iex3_en; 
   reg      tf1_en; 
   reg      iex4_en; 
   reg      riti0_en; 
   reg      iex5_en; 
   reg      tfexf2_en; 
   reg      iex6_en; 
   
   // Interrupt vector
   wire     ie0_p1; 
   wire     riti1_p1; 
   wire     iadc_p1; 
   wire     tf0_p1; 
   wire     iex2_p1; 
   wire     ie1_p1; 
   wire     iex3_p1; 
   wire     tf1_p1; 
   wire     iex4_p1; 
   wire     riti0_p1; 
   wire     iex5_p1; 
   wire     tfexf2_p1; 
   wire     iex6_p1; 
   
   // Compare Capture Enable register 
   wire     ccen76; 
   wire     ccen54; 
   wire     ccen32; 
   wire     ccen10; 
   reg      ccen76_ff; 
   reg      ccen54_ff; 
   reg      ccen32_ff; 
   reg      ccen10_ff; 
   
   // Combinational Interrupt Service location
   reg      [4:0] vect; 
   
   // Registered Interrupt Service location      
   reg      [4:0] int_vect; 
   
   //------------------------------------------------------------------
   // Watchdog Timer control signals
   //------------------------------------------------------------------
   assign wdt = ien0[6] ;  // WDT refresh flag

   //------------------------------------------------------------------
   // In Service register
   //------------------------------------------------------------------
   assign isreg = is_reg;
    
   //------------------------------------------------------------------
   // Interrupt Priority registers
   //------------------------------------------------------------------
   assign intprior0 = {ip0[2], ip0[0]};
   
   //------------------------------------------------------------------
   // Interrupt Priority registers
   //------------------------------------------------------------------
   assign intprior1 = {ip1[2], ip1[0]};
   
   //------------------------------------------------------------------
   // All interrupts enable register
   //------------------------------------------------------------------
   assign eal = ien0[7];
   
   //------------------------------------------------------------------
   // INT0 enable register
   //------------------------------------------------------------------
   assign eint0 = ien0[0];
   
   //------------------------------------------------------------------
   // INT1 enable register
   //------------------------------------------------------------------
   assign eint1 = ien0[2];

   //------------------------------------------------------------------
   // Interrupt Enable register 0
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : ien0_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      ien0 <= IEN0_RV ; 
      end
   else
      begin
      if (sfrwe & sfraddr == IEN0_ID)
         begin
         ien0 <= sfrdatai ; 
         end
      else
         begin
         //-----------------------------------
         // Synchronous write
         //-----------------------------------
         // Special function register write
         //--------------------------------
         //if (codefetche) 07/29
         if (codefetche & ((!mempsack & ckcon!=0) | (ckcon==0)))
            begin
            ien0[6] <= 1'b0 ; 
            end 
         end 
      end  
   end 

   //------------------------------------------------------------------
   // Interrupt Enable register 1
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : ien1_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      ien1 <= IEN1_RV ; 
      end
   else
      begin
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Special function register write
      //--------------------------------
      if (sfrwe & sfraddr == IEN1_ID)
         begin
         ien1[7] <= sfrdatai[7] ; 
         ien1[6] <= 1'b0 ; 
         ien1[5:0] <= sfrdatai[5:0] ; 
         end 
      end  
   end 

   //------------------------------------------------------------------
   // Interrupt Enable register 2
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : ien2_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      ien2 <= IEN0_RV ; 
      end
   else
      begin
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Special function register write
      //--------------------------------
      if (sfrwe & sfraddr == IEN2_ID)
         begin
         ien2 <= sfrdatai ; 
         end 
      end  
   end 

   //------------------------------------------------------------------
   // Interrupt Priority register 0
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : ip0_write_proc
   //------------------------------------------------------------------
   if (wdts)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      ip0 <= IP0_RW ; //set wdts flag (ip0(6))
      end
   else
      begin
      if (rst)
         begin
         ip0 <= IP0_RV ; 
         end
      else
         begin
         //-----------------------------------
         // Synchronous write
         //-----------------------------------
         // Special function register write
         //--------------------------------
         if (sfrwe & sfraddr == IP0_ID)
            begin
            ip0 <= sfrdatai ; 
            end 
         end 
      end  
   end 

   //------------------------------------------------------------------
   // Interrupt Priority register 1
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : ip1_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      ip1 <= IP1_RV ; 
      end
   else
      begin
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Special function register write
      //--------------------------------
      if (sfrwe & sfraddr == IP1_ID)
         begin
         ip1 <= sfrdatai ; 
         end 
      end  
   end 

   //------------------------------------------------------------------
   // Interrupt Request Control register
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : ircon_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      ircon <= IRCON_RV ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Special function register write
      //--------------------------------
      begin
      if (sfrwe & sfraddr == IRCON_ID)
         begin
         ircon <= sfrdatai ; 
         end
      else
         begin
         ircon[7] <= ircon[7] |  
                     (
                        (exf2 | exf2_ff) & ien1[7]
                     );
         ircon[6] <= ircon[6] | tf2 | tf2_ff;
         ircon[0] <= ircon[0] | iadc;
         if (intack)
            begin
            case (int_vect)
            VECT_EX6 : //iex6
               begin
               ircon[5] <= 1'b0 ; 
               end
            
            VECT_EX5 : //iex5
               begin
               ircon[4] <= 1'b0 ; 
               end
            
            VECT_EX4 : //iex4
               begin
               ircon[3] <= 1'b0 ; 
               end
            
            VECT_EX3 : //iex3
               begin
               ircon[2] <= 1'b0 ; 
               end
            
            VECT_EX2 : //iex2
               begin
               ircon[1] <= 1'b0 ; 
               end
            
            endcase 
            end
         else
            begin
            ircon[5:1] <= ({iex6, iex5, iex4, iex3, iex2}) |
               ircon[5:1] ; 
            end 
         end 
      end  
   end 

   //------------------------------------------------------------------
   // timer 2 overflow flip-flop
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : exf2_tf2_ff_proc
   //------------------------------------------------------------------
   //-----------------------------------
   // Synchronous reset
   //-----------------------------------
   if (rst)
      begin
      exf2_ff <= 1'b0;
      tf2_ff  <= 1'b0;
      end
   else
   //-----------------------------------
   // Synchronous write
   //-----------------------------------
      begin
      if (exf2)
         begin
         exf2_ff <= 1'b1;
         end
      else if (cycle == 1)
         begin
         exf2_ff <= 1'b0;
         end
      
      if (tf2)
         begin
         tf2_ff <= 1'b1;
         end
      else if (cycle == 1)
         begin
         tf2_ff <= 1'b0;
         end
      end
   end

   //------------------------------------------------------------------
   // External interrupt edge detect F/F
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : last_state_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      int2_p2 <= 1'b0 ; 
      int3_p2 <= 1'b0 ; 
      int4_p2 <= 1'b1 ; 
      int5_p2 <= 1'b1 ; 
      int6_p2 <= 1'b1 ; 
      
      int2_p0 <= 1'b0;
      int3_p0 <= 1'b0;
      int4_p0 <= 1'b1;
      int5_p0 <= 1'b1;
      int6_p0 <= 1'b1;
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      begin
      int2_p0 <= int2;
      int3_p0 <= int3;
      int4_p0 <= int4;
      int5_p0 <= int5;
      int6_p0 <= int6;

      int2_p2 <= int2_p0;
      int3_p2 <= int3_p1;
      int4_p2 <= int4_p1;
      int5_p2 <= int5_p1;
      int6_p2 <= int6_p1;
      end  
   end 
   
   //------------------------------------------------------------------
   assign int3_p1 = (ccen10) ? com0 : int3_p0 ; 
   
   //------------------------------------------------------------------
   assign int4_p1 = (ccen32) ? com1 : int4_p0 ; 
   
   //------------------------------------------------------------------
   assign int5_p1 = (ccen54) ? com2 : int5_p0 ; 
   
   //------------------------------------------------------------------
   assign int6_p1 = (ccen76) ? com3 : int6_p0 ; 

   //------------------------------------------------------------------
   // External interrupt edge detect
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : iex2_ff_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      iex2_ff <= 1'b0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      begin
      if (cycle == 1)
         begin
         iex2_ff <= 1'b0 ; 
         end
      else if ((int2_p0 & !int2_p2 & i2fr) | // positive edge
              (!int2_p0 & int2_p2 & !i2fr))  // negative edge
         begin
         iex2_ff <= 1'b1 ; 
         end 
      end  
   end 
   
   //------------------------------------------------------------------
   // External interrupt edge detect
   //------------------------------------------------------------------
   
   assign iex2 = (i2fr) ? (int2_p0 & ~int2_p2) | iex2_ff // positive edge
      : (int2_p2 & ~int2_p0) | iex2_ff ;                 // negative edge

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : iex3_ff_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      iex3_ff <= 1'b0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      begin
      if (~(ccen10_ff == ccen10) | cycle == 1)// compare <-> int3 switch
         begin
         iex3_ff <= 1'b0 ; 
         end
      else if ((int3_p1 & !int3_p2 & i3fr) | // positive edge
              (!int3_p1 & int3_p2 & !i3fr))  // negative edge
         begin
         iex3_ff <= 1'b1 ; 
         end 
      end  
   end 
   
   //------------------------------------------------------------------
   
   
   assign iex3 = (~(ccen10_ff == ccen10)) ? 1'b0 // compare <-> int3 switch
      : (i3fr) ? (int3_p1 & ~int3_p2) | iex3_ff :// positive edge
      (~int3_p1 & int3_p2) | iex3_ff ;           // negative edge

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : iex4_ff_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
         iex4_ff <= 1'b0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      begin
      if (cycle == 1 | ~(ccen32_ff == ccen32)) // compare <-> int4 switch
         begin
         iex4_ff <= 1'b0 ; 
         end
      else if (int4_p1 & !int4_p2) // positive edge
         begin
         iex4_ff <= 1'b1 ; 
         end 
      end  
   end 
   
   //------------------------------------------------------------------
   assign iex4 = (~(ccen32_ff == ccen32)) ? 1'b0 // compare <-> int4 switch
      : (int4_p1 & ~int4_p2) | iex4_ff ;         // positive edge

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : iex5_ff_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      iex5_ff <= 1'b0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      begin
      if (cycle == 1 | ~(ccen54_ff == ccen54)) // compare <-> int5 switch
         begin
         iex5_ff <= 1'b0 ; 
         end
      else if (int5_p1 & !int5_p2) // positive edge
         begin
         iex5_ff <= 1'b1 ; 
         end 
      end  
   end 
   
   //------------------------------------------------------------------
   assign iex5 = (~(ccen54_ff == ccen54)) ? 1'b0 // compare <-> int4 switch
      : (int5_p1 & ~int5_p2) | iex5_ff ;         // positive edge

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : iex6_ff_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      iex6_ff <= 1'b0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      begin
      if (cycle == 1 | ~(ccen76_ff == ccen76)) // compare <-> int6 switch
         begin
         iex6_ff <= 1'b0 ; 
         end
      else if (int6_p1 & !int6_p2)             // positive edge
         begin
         iex6_ff <= 1'b1 ; 
         end 
      end  
   end 
   
   //------------------------------------------------------------------
   assign iex6 = (~(ccen76_ff == ccen76)) ? 1'b0 // compare <-> int4 switch
      : (int6_p1 & ~int6_p2) | iex6_ff ;         // positive edge

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : ccen_ff_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      ccen76_ff <= 1'b0 ; 
      ccen54_ff <= 1'b0 ; 
      ccen32_ff <= 1'b0 ; 
      ccen10_ff <= 1'b0 ; 
      end
   else
      begin
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      ccen76_ff <= ccen76 ; 
      ccen54_ff <= ccen54 ; 
      ccen32_ff <= ccen32 ; 
      ccen10_ff <= ccen10 ; 
      end  
   end 
   
   //------------------------------------------------------------------      
   assign ccen76 = (ccenreg[7:6] == 2'b10) ? 1'b1 : 1'b0 ; 
   
   //------------------------------------------------------------------
   assign ccen54 = (ccenreg[5:4] == 2'b10) ? 1'b1 : 1'b0 ; 
   
   //------------------------------------------------------------------      
   assign ccen32 = (ccenreg[3:2] == 2'b10) ? 1'b1 : 1'b0 ; 
   
   //------------------------------------------------------------------      
   assign ccen10 = (ccenreg[1:0] == 2'b10) ? 1'b1 : 1'b0 ; 

   //------------------------------------------------------------------
   // Mask and priority encode
   // level0 - low priority
   // level3 - high priority
   //------------------------------------------------------------------
   always @(ip0 or ip1 or ie0_en or riti1_en or iadc_en or tf0_en or
      iex2_en or ie1_en or iex3_en or tf1_en or iex4_en or riti0_en or
      iex5_en or tfexf2_en or iex6_en)
   begin : mask_proc
   //------------------------------------------------------------------
   //-----------------------------------
   // External interrupt 0
   //-----------------------------------
   ie0_l3 = ie0_en & ip1[0] & ip0[0] ;         // level3
   ie0_l2 = ie0_en & ip1[0] & ~ip0[0] ;        // level2
   ie0_l1 = ie0_en & ~ip1[0] & ip0[0] ;        // level1
   ie0_l0 = ie0_en & ~ip1[0] & ~ip0[0] ;       // level0
   //-----------------------------------
   // Serial port 1 interrupt
   //-----------------------------------
   riti1_l3 = riti1_en & ip1[0] & ip0[0] ;     // level3
   riti1_l2 = riti1_en & ip1[0] & ~ip0[0] ;    // level2
   riti1_l1 = riti1_en & ~ip1[0] & ip0[0] ;    // level1
   riti1_l0 = riti1_en & ~ip1[0] & ~ip0[0] ;   // level0
   //-----------------------------------
   // Aanalog - Digital converter interrupt
   //-----------------------------------
   iadc_l3 = iadc_en & ip1[0] & ip0[0] ;       // level3
   iadc_l2 = iadc_en & ip1[0] & ~ip0[0] ;      // level2
   iadc_l1 = iadc_en & ~ip1[0] & ip0[0] ;      // level1
   iadc_l0 = iadc_en & ~ip1[0] & ~ip0[0] ;     // level0
   //-----------------------------------
   // Timer 0 overflow interrupt
   //-----------------------------------
   tf0_l3 = tf0_en & ip1[1] & ip0[1] ;         // level3
   tf0_l2 = tf0_en & ip1[1] & ~ip0[1] ;        // level2
   tf0_l1 = tf0_en & ~ip1[1] & ip0[1] ;        // level1
   tf0_l0 = tf0_en & ~ip1[1] & ~ip0[1] ;       // level0
   //-----------------------------------
   // External interrupt 2
   //-----------------------------------
   iex2_l3 = iex2_en & ip1[1] & ip0[1] ;       // level3
   iex2_l2 = iex2_en & ip1[1] & ~ip0[1] ;      // level2
   iex2_l1 = iex2_en & ~ip1[1] & ip0[1] ;      // level1
   iex2_l0 = iex2_en & ~ip1[1] & ~ip0[1] ;     // level0
   //-----------------------------------
   // External interrupt 1
   //-----------------------------------
   ie1_l3 = ie1_en & ip1[2] & ip0[2] ;         // level3
   ie1_l2 = ie1_en & ip1[2] & ~ip0[2] ;        // level2
   ie1_l1 = ie1_en & ~ip1[2] & ip0[2] ;        // level1
   ie1_l0 = ie1_en & ~ip1[2] & ~ip0[2] ;       // level0
   //-----------------------------------
   // External interrupt 3
   //-----------------------------------
   iex3_l3 = iex3_en & ip1[2] & ip0[2] ;       // level3
   iex3_l2 = iex3_en & ip1[2] & ~ip0[2] ;      // level2
   iex3_l1 = iex3_en & ~ip1[2] & ip0[2] ;      // level1
   iex3_l0 = iex3_en & ~ip1[2] & ~ip0[2] ;     // level0
   //-----------------------------------
   // Timer 1 overflow interrupt
   //-----------------------------------
   tf1_l3 = tf1_en & ip1[3] & ip0[3] ;         // level3
   tf1_l2 = tf1_en & ip1[3] & ~ip0[3] ;        // level2
   tf1_l1 = tf1_en & ~ip1[3] & ip0[3] ;        // level1
   tf1_l0 = tf1_en & ~ip1[3] & ~ip0[3] ;       // level0
   //-----------------------------------
   // External interrupt 4
   //-----------------------------------
   iex4_l3 = iex4_en & ip1[3] & ip0[3] ;       // level3
   iex4_l2 = iex4_en & ip1[3] & ~ip0[3] ;      // level2
   iex4_l1 = iex4_en & ~ip1[3] & ip0[3] ;      // level1
   iex4_l0 = iex4_en & ~ip1[3] & ~ip0[3] ;     // level0
   //-----------------------------------
   // Serial port 0 interrupt
   //-----------------------------------
   riti0_l3 = riti0_en & ip1[4] & ip0[4] ;     // level3
   riti0_l2 = riti0_en & ip1[4] & ~ip0[4] ;    // level2
   riti0_l1 = riti0_en & ~ip1[4] & ip0[4] ;    // level1
   riti0_l0 = riti0_en & ~ip1[4] & ~ip0[4] ;   // level0
   //-----------------------------------
   // External interrupt 5
   //-----------------------------------
   iex5_l3 = iex5_en & ip1[4] & ip0[4] ;       // level3
   iex5_l2 = iex5_en & ip1[4] & ~ip0[4] ;      // level2
   iex5_l1 = iex5_en & ~ip1[4] & ip0[4] ;      // level1
   iex5_l0 = iex5_en & ~ip1[4] & ~ip0[4] ;     // level0
   //-----------------------------------
   // Timer 2 interrupt
   //-----------------------------------
   tfexf2_l3 = tfexf2_en & ip1[5] & ip0[5] ;   //level3
   tfexf2_l2 = tfexf2_en & ip1[5] & ~ip0[5] ;  //level2
   tfexf2_l1 = tfexf2_en & ~ip1[5] & ip0[5] ;  //level1
   tfexf2_l0 = tfexf2_en & ~ip1[5] & ~ip0[5] ; //level0
   //-----------------------------------
   // External interrupt 6
   //-----------------------------------
   iex6_l3 = iex6_en & ip1[5] & ip0[5] ;       // level3
   iex6_l2 = iex6_en & ip1[5] & ~ip0[5] ;      // level2
   iex6_l1 = iex6_en & ~ip1[5] & ip0[5] ;      // level1
   iex6_l0 = iex6_en & ~ip1[5] & ~ip0[5] ;     // level0
   end 

   //------------------------------------------------------------------   
   always @(ien0 or ien1 or ien2 or ircon or ri0 or ti0 or ri1 or
      ti1 or ie0 or tf0 or ie1 or tf1)
   //------------------------------------------------------------------
   begin : priority_encode_proc
   //-----------------------------------
   // External interrupt 0
   //-----------------------------------
   ie0_en = ie0 & ien0[7] & ien0[0] ; // interrupt enable
   
   //-----------------------------------
   // Serial port 1 interrupt
   //-----------------------------------
   riti1_en = (ri1 | ti1) & ien0[7] & ien2[0] ; // i.enable
   
   //-----------------------------------
   // Aanalog - Digital converter interrupt
   //-----------------------------------
   iadc_en = ircon[0] & ien0[7] & ien1[0] ; // i. enable         
   
   //-----------------------------------
   // Timer 0 overflow interrupt
   //-----------------------------------
   tf0_en = tf0 & ien0[7] & ien0[1] ; // interrupt enable
   
   //-----------------------------------
   // External interrupt 2
   //-----------------------------------
   iex2_en = ircon[1] & ien0[7] & ien1[1] ; // i. enable
   
   //-----------------------------------
   // External interrupt 1
   //-----------------------------------
   ie1_en = ie1 & ien0[7] & ien0[2] ; // interrupt enable
   
   //-----------------------------------
   // External interrupt 3
   //-----------------------------------
   iex3_en = ircon[2] & ien0[7] & ien1[2] ; // i. enable
   
   //-----------------------------------
   // Timer 1 overflow interrupt
   //-----------------------------------
   tf1_en = tf1 & ien0[7] & ien0[3] ; // interrupt enable
   
   //-----------------------------------
   // External interrupt 4
   //-----------------------------------
   iex4_en = ircon[3] & ien0[7] & ien1[3] ; // i. enable
   
   //-----------------------------------
   // Serial port 0 interrupt
   //-----------------------------------
   riti0_en = (ri0 | ti0) & ien0[7] & ien0[4] ; // i.enable
   
   //-----------------------------------
   // External interrupt 5
   //-----------------------------------
   iex5_en = ircon[4] & ien0[7] & ien1[4] ; // i. enable
   
   //-----------------------------------
   // Timer 2 interrupt
   //-----------------------------------
   tfexf2_en = (ircon[7] | ircon[6]) & ien0[7] & ien0[5] ; 
   
   //-----------------------------------
   // External interrupt 6
   //-----------------------------------
   iex6_en = ircon[5] & ien0[7] & ien1[5] ; // i. enable
   
   end 
   
   //------------------------------------------------------------------
   // Interrupt levels
   //------------------------------------------------------------------
   assign l3 = (ie0_l3 | riti1_l3 | iadc_l3 | tf0_l3 |
               iex2_l3 | ie1_l3 | iex3_l3 | tf1_l3 |
               iex4_l3 | riti0_l3 | iex5_l3 | tfexf2_l3 |
               iex6_l3) ; 
   
   //------------------------------------------------------------------
   assign l2 = (ie0_l2 | riti1_l2 | iadc_l2 | tf0_l2 |
               iex2_l2 | ie1_l2 | iex3_l2 | tf1_l2 |
               iex4_l2 | riti0_l2 | iex5_l2 | tfexf2_l2 |
               iex6_l2) ; 
   
   //------------------------------------------------------------------
   assign l1 = (ie0_l1 | riti1_l1 | iadc_l1 | tf0_l1 |
               iex2_l1 | ie1_l1 | iex3_l1 | tf1_l1 |
               iex4_l1 | riti0_l1 | iex5_l1 | tfexf2_l1 |
               iex6_l1) ; 
   
   //------------------------------------------------------------------
   assign l0 = (ie0_l0 | riti1_l0 | iadc_l0 | tf0_l0 |
               iex2_l0 | ie1_l0 | iex3_l0 | tf1_l0 |
               iex4_l0 | riti0_l0 | iex5_l0 | tfexf2_l0 |
               iex6_l0) ; 
   
   //-------------------------------------------------------------------
   // Interrupt vector
   //-------------------------------------------------------------------
   assign ie0_p1 =
      ((ie0_l3) |
      (ie0_l2 & ~l3) |
      (ie0_l1 & ~l3 & ~l2) |
      (ie0_l0 & ~l3 & ~l2 & ~l1)) ; 
   
   //-------------------------------------------------------------------
   assign riti1_p1 =
      ((riti1_l3) |
      (riti1_l2 & ~l3) |
      (riti1_l1 & ~l3 & ~l2) |
      (riti1_l0 & ~l3 & ~l2 & ~l1)) ; 
   
   //-------------------------------------------------------------------
   assign iadc_p1 =
      ((iadc_l3) |
      (iadc_l2 & ~l3) |
      (iadc_l1 & ~l3 & ~l2) |
      (iadc_l0 & ~l3 & ~l2 & ~l1)) ; 
   
   //-------------------------------------------------------------------
   assign tf0_p1 =
      ((tf0_l3) |
      (tf0_l2 & ~l3) |
      (tf0_l1 & ~l3 & ~l2) |
      (tf0_l0 & ~l3 & ~l2 & ~l1)) ; 
   
   //-------------------------------------------------------------------
   assign iex2_p1 =
      ((iex2_l3) |
      (iex2_l2 & ~l3) |
      (iex2_l1 & ~l3 & ~l2) |
      (iex2_l0 & ~l3 & ~l2 & ~l1)) ; 
   
   //-------------------------------------------------------------------
   assign ie1_p1 =
      ((ie1_l3) |
      (ie1_l2 & ~l3) |
      (ie1_l1 & ~l3 & ~l2) |
      (ie1_l0 & ~l3 & ~l2 & ~l1)) ; 
   
   //-------------------------------------------------------------------
   assign iex3_p1 =
      ((iex3_l3) |
      (iex3_l2 & ~l3) |
      (iex3_l1 & ~l3 & ~l2) |
      (iex3_l0 & ~l3 & ~l2 & ~l1)) ; 
   
   //-------------------------------------------------------------------
   assign tf1_p1 =
      ((tf1_l3) |
      (tf1_l2 & ~l3) |
      (tf1_l1 & ~l3 & ~l2) |
      (tf1_l0 & ~l3 & ~l2 & ~l1)) ; 
   
   //-------------------------------------------------------------------
   assign iex4_p1 =
      ((iex4_l3) |
      (iex4_l2 & ~l3) |
      (iex4_l1 & ~l3 & ~l2) |
      (iex4_l0 & ~l3 & ~l2 & ~l1)) ; 
   
   //-------------------------------------------------------------------
   assign riti0_p1 =
      ((riti0_l3) |
      (riti0_l2 & ~l3) |
      (riti0_l1 & ~l3 & ~l2) |
      (riti0_l0 & ~l3 & ~l2 & ~l1)) ; 
   
   //-------------------------------------------------------------------
   assign iex5_p1 =
      ((iex5_l3) |
      (iex5_l2 & ~l3) |
      (iex5_l1 & ~l3 & ~l2) |
      (iex5_l0 & ~l3 & ~l2 & ~l1)) ; 
   
   //-------------------------------------------------------------------
   assign tfexf2_p1 =
      ((tfexf2_l3) |
      (tfexf2_l2 & ~l3) |
      (tfexf2_l1 & ~l3 & ~l2) |
      (tfexf2_l0 & ~l3 & ~l2 & ~l1)) ; 
   
   //-------------------------------------------------------------------
   assign iex6_p1 =
      ((iex6_l3) |
      (iex6_l2 & ~l3) |
      (iex6_l1 & ~l3 & ~l2) |
      (iex6_l0 & ~l3 & ~l2 & ~l1)) ; 

   //------------------------------------------------------------------
   // Vector locations
   // Combinational section
   //------------------------------------------------------------------
   always @(ie0_p1 or riti1_p1 or iadc_p1 or tf0_p1 or iex2_p1 or
      ie1_p1 or iex3_p1 or tf1_p1 or iex4_p1 or riti0_p1 or iex5_p1 or
      tfexf2_p1 or iex6_p1)
   begin : intvect_comb_proc
   //------------------------------------------------------------------
   if (ie0_p1)
      begin
      vect = VECT_E0 ; //0003
      end
   else
      begin
      if (riti1_p1)
         begin
         vect = VECT_SER1 ; //0083
         end
      else
         begin
         if (iadc_p1)
            begin
            vect = VECT_ADC ; //0043
            end
         else
            begin
            if (tf0_p1)
               begin
               vect = VECT_TF0 ; //000B
               end
            else
               begin
               if (iex2_p1)
                  begin
                  vect = VECT_EX2 ; //004B
                  end
               else
                  begin
                  if (ie1_p1)
                     begin
                     vect = VECT_E1 ; //0013
                     end
                  else
                     begin
                     if (iex3_p1)
                        begin
                        vect = VECT_EX3 ; //0053
                        end
                     else
                        begin
                        if (tf1_p1)
                           begin
                           vect = VECT_TF1 ; //001B
                           end
                        else
                           begin
                           if (iex4_p1)
                              begin
                              vect = VECT_EX4 ; //005B
                              end
                           else
                              begin
                              if (riti0_p1)
                                 begin
                                 vect = VECT_SER0 ; //0023
                                 end
                              else
                                 begin
                                 if (iex5_p1)
                                    begin
                                    vect = VECT_EX5 ; //0063
                                    end
                                 else
                                    begin
                                    if (tfexf2_p1)
                                       begin
                                       vect = VECT_TF2 ; //002B
                                       end
                                    else
                                       begin
                                       if (iex6_p1)
                                          begin
                                          vect = VECT_EX6 ; //006B
                                          end
                                       else
                                          begin
                                             vect = "-----" ; 
                                          end 
                                       end 
                                    end 
                                 end 
                              end 
                           end 
                        end 
                     end 
                  end 
               end 
            end 
         end 
      end 
   end 

   //------------------------------------------------------------------
   // Vector locations
   // Registered section
   //-------------------------------------------------------------------
   always @(posedge clk)
   begin : int_vect_sync_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      int_vect <= VECT_RV;
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      begin
      if (codefetche)
         begin
         int_vect <= vect ; 
         end 
      end  
   end 
   
   //------------------------------------------------------------------
   // Vector locations
   //------------------------------------------------------------------
   assign intvect = int_vect ; 
   
   //------------------------------------------------------------------
   // Interrupt Request Comparator
   //------------------------------------------------------------------
   assign intreq =
      (
         (
            (l3 & !(is_reg[3]))
            |
            (l2 & ~((is_reg[2]) | (is_reg[3])))
            |
            (l1 & ~((is_reg[1]) | (is_reg[2]) | (is_reg[3])))
            |
            (l0 & ~((is_reg[0]) | (is_reg[1]) | (is_reg[2]) | (is_reg[3])))
         )
         &
         ~(
            (instr == RETI)
            |
            (
               (instr == INC_ADDR | instr == DEC_ADDR |
               instr == ANL_ADDR_A | instr == ANL_ADDR_N |
               instr == ORL_ADDR_A | instr == ORL_ADDR_N |
               instr == XRL_ADDR_A | instr == XRL_ADDR_N |
               instr == MOV_ADDR_A | instr == MOV_ADDR_R0 |
               instr == MOV_ADDR_R1 | instr == MOV_ADDR_R2 |
               instr == MOV_ADDR_R3 | instr == MOV_ADDR_R4 |
               instr == MOV_ADDR_R5 | instr == MOV_ADDR_R6 |
               instr == MOV_ADDR_R7 | instr == MOV_ADDR_ADDR |
               instr == MOV_ADDR_IR0 | instr == MOV_ADDR_IR1 |
               instr == MOV_ADDR_N | instr == POP |
               instr == CLR_BIT | instr == SETB_BIT |
               instr == CPL_BIT | instr == MOV_BIT_C |
               instr == JBC_BIT | instr == DJNZ_ADDR)
               &
               (sfraddr == IEN0_ID | sfraddr == IP0_ID |
               sfraddr == IP1_ID)
               &
               sfrwe
            )
         )
      ) ? 1'b1 : 1'b0 ; 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : level_reg_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      l3_reg <= 1'b0;
      l2_reg <= 1'b0;
      l1_reg <= 1'b0;
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      begin
      if (codefetche)
         begin
         l3_reg <= l3;
         l2_reg <= l2;
         l1_reg <= l1;
         end
      end
   end

   //------------------------------------------------------------------
   // In Service Register
   // Combinational section
   //------------------------------------------------------------------
   always @(is_reg or l3_reg or l2_reg or l1_reg or intret)
   begin : is_reg_comb_proc
   //------------------------------------------------------------------
   if (intret)
      begin
      if (is_reg[3])
         begin
         is_nxt = {1'b0, is_reg[2:0]} ; 
         end
      else
         begin
         if (is_reg[2])
            begin
            is_nxt = {2'b00, is_reg[1:0]} ; 
            end
         else
            begin
            if (is_reg[1])
               begin
               is_nxt = {3'b000, is_reg[0]} ; 
               end
            else
               begin
               is_nxt = 4'b0000 ; 
               end 
            end 
         end 
      end
   else
      begin
      if (l3_reg)
         begin
         is_nxt = {1'b1, is_reg[2:0]} ; 
         end
      else
         begin
         if (l2_reg)
            begin
            is_nxt = {2'b01, is_reg[1:0]} ; 
            end
         else
            begin
            if (l1_reg)
               begin
               is_nxt = {3'b001, is_reg[0]} ; 
               end
            else
               begin
               is_nxt = 4'b0001 ; 
               end 
            end 
         end 
      end 
   end 

   //------------------------------------------------------------------
   // In Service Register
   // Registered section
   //-------------------------------------------------------------------
   always @(posedge clk)
   begin : is_reg_sync_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      is_reg <= IS_REG_RV;
      end
   else
      begin
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // In Service Register write
      //--------------------------------
      if (intack | intret)
         begin
         is_reg <= is_nxt ; 
         end 
      end  
   end 

   //------------------------------------------------------------------
   // Timer 0 acknowledge output
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : t0ack_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      t0ack <= 1'b0 ; 
      end
   else
      begin
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      if ((intack) & (int_vect == VECT_TF0))
         begin
         t0ack <= 1'b1 ; 
         end
      else
         begin
         t0ack <= 1'b0 ; 
         end 
      end  
   end 

   //------------------------------------------------------------------
   // Timer 1 acknowledge output
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : t1ack_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      t1ack <= 1'b0 ; 
      end
   else
      begin
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      if ((intack) & (int_vect == VECT_TF1))
         begin
         t1ack <= 1'b1 ; 
         end
      else
         begin
         t1ack <= 1'b0 ; 
         end 
      end  
   end 

   //------------------------------------------------------------------
   // External interrupt 0 acknowledge output
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : int0ack_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      int0ack <= 1'b0 ; 
      end
   else
      begin
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      if ((intack) & (int_vect == VECT_E0))
         begin
         int0ack <= 1'b1 ; 
         end
      else
         begin
         int0ack <= 1'b0 ; 
         end 
      end  
   end 

   //------------------------------------------------------------------
   // External interrupt 1 acknowledge output
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : int1ack_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      int1ack <= 1'b0 ; 
      end
   else
      begin
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      if ((intack) & (int_vect == VECT_E1))
         begin
         int1ack <= 1'b1 ; 
         end
      else
         begin
         int1ack <= 1'b0 ; 
         end 
      end  
   end 
   
   //------------------------------------------------------------------
   // Special Function registers read
   //------------------------------------------------------------------
   assign sfrdataisr =
      (sfraddr == IEN0_ID) ? {ien0[7], 1'b0, ien0[5:0]} :
      (sfraddr == IEN1_ID) ? ien1 :
      (sfraddr == IEN2_ID) ? ien2 :
      (sfraddr == IP0_ID) ? ip0 :
      (sfraddr == IP1_ID) ? ip1 :
      (sfraddr == IRCON_ID) ? ircon :
      "--------" ; 
      
      
      
endmodule // module ISR

//*******************************************************************--
