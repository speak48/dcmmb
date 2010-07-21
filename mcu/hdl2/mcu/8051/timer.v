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
// File name            : timer.v
// File contents        : Module TIMER_0_1
// Purpose              : Timer/Counter 0
//                        Timer/Counter 1
//
// Destination library  : R80515_LIB
//
// Design Engineer      : M.B. A.B. D.K.
// Quality Engineer     : M.B.
// Version              : 1.10.V05
// Last modification    : 2002-04-04
//---------------------------------------------------------------------

`timescale 1 ns / 1 ns // timescale for following modules

//*******************************************************************--
// Modifications with respect to Version 1.01.E00 :
// 1.01.E01   :
// 2000-01-04 : Modified Timer 1 overflow in mode 2
// 1.04.E04   :
// 2000-09-25 : tcon_write_proc: modified setting int0, int1 ext. flags
// 1.04.E06   :
// 2001-05-10 : Added flip-flops for int0, int1, t0, t1 inputs
// 2001-05-16 : Added tl0, tl1, th0, th1 overflow flip-flops
// 2001-05-16 : Modified tcon_write_proc:   
// 1.10.E00   :
// 2001-09-03 : Added otput ports it0, it1
// 1.10.V03   :
// 2002-01-08 : Modified timer0_write_proc and timer1_write_proc
// 1.10.E05   :
// 2002-04-04 : Modified increment th1 
// 2002-04-04 : Modified write to tl0 and tl1 in mode 0
// 2002-04-04 : Modified counting timer1 (timer0 in mode3)
//*******************************************************************--
   
module TIMER_0_1
   (
   clk,
   rst,
   cycle,
   t0,
   t1,
   t0ack,
   t1ack,
   int0,
   int1,
   int0ack,
   int1ack,
   tf0,
   tf1,
   ie0,
   ie1,
   it0,
   it1,
   t1ov,
   sfrdatai,
   sfrdatatim,
   sfraddr,
   sfrwe
   );

   
   //  Declarations
   `include "utility.v"
   
   
   //  Control signals inputs
   input    clk;           // Global clock input
   input    rst;           // Global reset input
   
   //  CPU input signals
   input    [3:0] cycle; 
   
   //  Timers inputs
   input    t0;            // Timer 0 external input
   input    t1;            // Timer 1 external input
   input    t0ack;         // Timer 0 int. acknowledge
   input    t1ack;         // Timer 1 int. acknowledge
   input    int0;          // External interrupt 0 input
   input    int1;          // External interrupt 1 input
   input    int0ack;       // External int0 acknowledge
   input    int1ack;       // External int1 acknowledge
   
   //  Timer interrupt flags
   output   tf0;           // Timer 0 overflow flag
   wire     tf0;
   output   tf1;           // Timer 1 overflow flag
   wire     tf1;
   output   ie0;           // Interrupt 0 edge detect
   wire     ie0;
   output   ie1;           // Interrupt 1 edge detect
   wire     ie1;
   output   it0;           // Interrupt 0 edge/low sel.
   wire     it0;
   output   it1;           // Interrupt 1 edge/low sel.
   wire     it1;
   
   //  Timer outputs
   output   t1ov;          // Timer 1 overflow output
   wire     t1ov;
   
   //  Special function register interface
   input    [7:0] sfrdatai; 
   output   [7:0] sfrdatatim; 
   wire     [7:0] sfrdatatim;
   input    [6:0] sfraddr; 
   input    sfrwe; 

   //------------------------------------------------------------------
   
   // Timer/Counter registers
   reg      [7:0] tl0; 
   reg      [7:0] th0; 
   reg      [7:0] tl1; 
   reg      [7:0] th1; 
   
   // Control registers
   reg      [7:0] tcon; 
   reg      [7:0] tmod; 
   
   // Clock counter
   reg      [3:0] clk_count; 
   reg      clk_ov12;      // Clock divided by 12
   
   //---------------------------------------------------------------
   // Timer 0 control signals
   //---------------------------------------------------------------
   // External input t0 falling edge detector
   wire     t0_fall;       // t0 input fall edge detector
   reg      t0_ff0;        // t0 input flip-flop
   reg      t0_ff;         // t0 input flip-flop
   
   // External input int0 falling edge detector
   reg      int0_fall;     // int0 input fall edge detector
   reg      int0_ff0;      // int0 input flip-flop
   reg      int0_ff;       // int0 input flip-flop
   
   // Timer 0 mode
   wire     [1:0] t0_mode; 
   
   // Timer 0 signals
   wire     t0_clk;        // Timer 0 clock
   wire     t0_open;       // Timer 0 open
   wire     tl0_clk;       // Timer low 0 clock
   wire     th0_clk;       // Timer high 0 clock
   wire     tl0_ov;        // Timer low 0 overflow
   reg      tl0_ov_ff;
   wire     th0_ov;        // Timer high 0 overflow
   reg      th0_ov_ff;
   
   //---------------------------------------------------------------
   // Timer 1 control signals
   //---------------------------------------------------------------
   // External input t1 falling edge detector
   wire     t1_fall;       // t1 input fall edge detector
   reg      t1_ff0;        // t1 input flip-flop
   reg      t1_ff;         // t1 input flip-flop
   
   // External input int1 falling edge detector
   reg      int1_fall;     // int1 input fall edge detector
   reg      int1_ff0;      // INT1 input flip-flop
   reg      int1_ff;       // INT1 input flip-flop
   
   // Timer 1 mode
   wire     [1:0] t1_mode; 
   
   // Timer 1 signals
   wire     t1_clk;        // Timer 1 clock
   wire     t1_open;       // Timer 1 open
   wire     tl1_clk;       // Timer low 1 clock
   wire     th1_clk;       // Timer high 1 clock
   wire     tl1_ov;        // Timer low 1 overflow
   reg      tl1_ov_ff;
   wire     th1_ov;        // Timer high 1 overflow
   reg      th1_ov_ff;

   //------------------------------------------------------------------
   // Timer 0 overflow flag
   //   interrupt request flag
   //   high active output
   //   cleared by high on signal t0ack
   //------------------------------------------------------------------
   assign tf0 = tcon[5] ; 
   
   //------------------------------------------------------------------
   // Timer 1 overflow flag
   //   interrupt request flag
   //   high active output
   //   cleared by high on signal t1ack
   //------------------------------------------------------------------
   assign tf1 = tcon[7] ; 
   
   //------------------------------------------------------------------
   // Interrupt 0 edge detect
   //   interrupt request flag
   //   high active output
   //------------------------------------------------------------------
   assign ie0 = tcon[1] ; 
   
   //------------------------------------------------------------------
   // Interrupt 0 edge/low level selector
   //------------------------------------------------------------------
   assign it0 = tcon[0];
      
   //------------------------------------------------------------------
   // Interrupt 1 edge/low level selector
   //------------------------------------------------------------------
   assign it1 = tcon[2];

   //------------------------------------------------------------------
   // Interrupt 1 edge detect
   //   interrupt request flag
   //   high active output
   //------------------------------------------------------------------
   assign ie1 = tcon[3] ; 
   
   //------------------------------------------------------------------
   // Timer 0 overflow output
   //   output for serial interface
   //   high active output
   //   active during single clk period
   //------------------------------------------------------------------
   //   assign t0ov = th0_ov;
   
   //------------------------------------------------------------------
   // Timer 1 overflow output
   //   output for serial interface
   //   high active output
   //   active during single clk period
   //------------------------------------------------------------------
   assign t1ov = (t1_mode == 2'b10) ? tl1_ov : th1_ov ; 
   
   //------------------------------------------------------------------
   // Timer 0 mode
   //------------------------------------------------------------------
   assign t0_mode = tmod[1:0] ; 
   
   //------------------------------------------------------------------
   // Timer 1 mode
   //------------------------------------------------------------------
   assign t1_mode = tmod[5:4] ; 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : tcon_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      tcon <= TCON_RV ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Special function register write
      //--------------------------------
      begin
      if (sfrwe & sfraddr == TCON_ID)
         begin
         tcon <= sfrdatai ; 
         end
      else
         //--------------------------------
         // Interrupt 0 edge/level detect
         //-------------------------------- 
         begin
         if (!(tcon[0]))   // Low level detect
            begin
            tcon[1] <= ~int0 ; 
            end
         else
            begin
            if (int0ack)   // clear int. request
               begin
               tcon[1] <= 1'b0 ; 
               end
            else
               begin
               if (
                     int0_fall |
                     (!int0_ff0 & int0_ff)
                  ) //Falling edge
                  begin
                  tcon[1] <= 1'b1 ; 
                  end 
               end 
            end 
            
         //--------------------------------
         // Interrupt 1 edge/level detect
         //--------------------------------    
         if (!(tcon[2]))   // Low level detect
            begin
            tcon[3] <= ~int1 ; 
            end
         else
            begin
            if (int1ack)   // clear int. request
               begin
               tcon[3] <= 1'b0 ; 
               end
            else
               begin
               if (
                     int1_fall |
                     (!int1_ff0 & int1_ff)
                  )  //Falling edge
                  begin
                  tcon[3] <= 1'b1 ; 
                  end 
               end 
            end 
            
         //--------------------------------
         // Timer 0 interrupt acknoledge
         //--------------------------------
         if (t0ack)
            begin
            tcon[5] <= 1'b0 ; 
            end
         else
            //--------------------------------
            // Timer 0 overflow flag TF0
            //--------------------------------
            begin
            if (
                  (
                     (t0_mode == 2'b00 | t0_mode == 2'b01) &
                     (th0_ov | th0_ov_ff)
                  ) |
                  (
                     (t0_mode == 2'b10 | t0_mode == 2'b11) &
                     (tl0_ov | tl0_ov_ff)
                  )
               )
               begin
               tcon[5] <= 1'b1 ; 
               end 
            end 
            
         //--------------------------------
         // Timer 1 interrupt acknoledge
         //--------------------------------
         if (t1ack)
            begin
            tcon[7] <= 1'b0 ; 
            end
         else
            //--------------------------------
            // Timer 1 overflow flag TF1
            //--------------------------------
            begin
            if (
                  (
                     (t1_mode == 2'b00 | t1_mode == 2'b01) &
                     (th1_ov | th1_ov_ff)
                  ) |
                  (
                     (t1_mode == 2'b10) &
                     (tl1_ov | tl1_ov_ff)
                  ) |
                  (
                  (t0_mode == 2'b11) &
                  (th0_ov | th0_ov_ff)
                  )
               )
               begin
               tcon[7] <= 1'b1 ; 
               end 
            end 
         end 
      end  
   end 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : tmod_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      tmod <= TMOD_RV ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Special function register write
      //--------------------------------
      begin
      if (sfrwe & sfraddr == TMOD_ID)
         begin
         tmod <= sfrdatai ; 
         end 
      end  
   end 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : timer0_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      tl0 <= TL0_RV ; 
      th0 <= TH0_RV ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Special function register write
      //--------------------------------
      begin
      if (sfrwe & sfraddr == TL0_ID)
         begin
         if (t0_mode == 2'b00)
           begin
           tl0[7:5] <= 3'b000;
           tl0[4:0] <= sfrdatai[4:0];
           end
         else
           begin
           tl0 <= sfrdatai;
           end
         end 
      else if (t0_mode == 2'b10 & tl0_ov)
         begin
         tl0 <= th0 ; // Reload mode
         end
      else
         begin
         if (tl0_clk)
            begin
            if (t0_mode == 2'b00)
              begin
              tl0[4:0] <= tl0[4:0] + 1'b1;
              end
            else
              begin
              tl0 <= tl0 + 1'b1 ; 
              end
            end 
         end 

      if (sfrwe & sfraddr == TH0_ID)
         begin
         th0 <= sfrdatai ; 
         end 
      else if (th0_clk)
         begin
         th0 <= th0 + 1'b1 ; 
         end 
      
      end  
   end 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : timer1_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      tl1 <= TL1_RV ; 
      th1 <= TH1_RV ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      //--------------------------------
      // Special function register write
      //--------------------------------
      begin
      if (sfrwe & sfraddr == TL1_ID)
         begin
         if (t1_mode == 2'b00)
           begin
           tl1[7:5] <= 3'b000;
           tl1[4:0] <= sfrdatai[4:0];
           end
         else
           begin
           tl1 <= sfrdatai;
           end
         end 
      else if (t1_mode == 2'b10 & tl1_ov)
         begin
         tl1 <= th1 ; // Reload mode
         end
      else
         begin
         if (tl1_clk)
            begin
            if (t1_mode == 2'b00)
              begin
              tl1[4:0] <= tl1[4:0] + 1'b1;
              end
            else
              begin
              tl1 <= tl1 + 1'b1 ; 
              end
            end 
         end 
      
      if (sfrwe & sfraddr == TH1_ID)
         begin
         th1 <= sfrdatai ; 
         end 
      else if (th1_clk & ~(t1_mode == 2'b10))
         begin
         th1 <= th1 + 1'b1 ; 
         end 
      
      end  
   end 

   //------------------------------------------------------------------
   // Clock counter with overflow divided by 2 or 12
   // clk_ov2 is high active during single clk period
   // clk_ov12 is high active during single clk period
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : clk_count_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      clk_count <= 4'b0000 ; 
      clk_ov12 <= 1'b0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Clock counter
      //--------------------------------
      begin
      if (clk_count == 4'b1011)
         begin
         clk_count <= 4'b0000 ; 
         end
      else
         begin
         clk_count <= clk_count + 1'b1 ; 
         end 
         
      //--------------------------------
      // Clock divided by 12
      //--------------------------------
      if (clk_count == 4'b1011)
         begin
         clk_ov12 <= 1'b1 ; 
         end
      else
         begin
         clk_ov12 <= 1'b0 ; 
         end 
      
      end  
   end 
   
   //------------------------------------------------------------------
   // Timer 0 clock
   // t0_clk is high active during single clk period
   //------------------------------------------------------------------
   assign t0_clk = clk_ov12 ; 
   
   //------------------------------------------------------------------
   // Timer 1 clock
   // t1_clk is high active during single clk period
   //------------------------------------------------------------------
   assign t1_clk = clk_ov12 ; 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : t0_ff_proc
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      if (rst)
      begin
         t0_ff0 <= 1'b0 ; 
         t0_ff <= 1'b0 ; 
      end
      else
      begin
         //-----------------------------------
         // Synchronous write
         //-----------------------------------
         // t0 input flip-flop
         //--------------------------------
         t0_ff0 <= t0 ; 
         t0_ff <= t0_ff0 ; 
      end  
   end 
   
   //------------------------------------------------------------------
   // Falling edge detection on the external input t0
   // t0_fall is high active during single clk period
   //------------------------------------------------------------------
   assign t0_fall = t0_ff & ~t0_ff0 ; 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : t1_fall_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      t1_ff0 <= 1'b0 ; 
      t1_ff <= 1'b0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // t1 input flip-flop
      //--------------------------------
      begin
      t1_ff0 <= t1 ; 
      t1_ff <= t1_ff0 ; 
      end  
   end 
   
   //------------------------------------------------------------------
   // Falling edge detection on the external input t1
   // t1_fall is high active during single clk period
   //------------------------------------------------------------------
   assign t1_fall = t1_ff & ~t1_ff0 ; 

   //------------------------------------------------------------------
   // Falling edge or low level detection on the external input int0
   // int0_fall is high active during single clk period
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : int0_fall_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      int0_fall <= 1'b0 ; 
      int0_ff <= 1'b0 ; 
      int0_ff0  <= 1'b0;
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      //--------------------------------
      // Falling edge detection
      //--------------------------------
      begin
      if (cycle == 1)
         begin
         int0_fall <= 1'b0 ; 
         end
      else if (!int0_ff0 & int0_ff)
         begin
         int0_fall <= 1'b1 ; 
         end 
      
      //--------------------------------
      // int0 input flip-flop
      //--------------------------------
      int0_ff0 <= int0;
      int0_ff  <= int0_ff0;
      
      end  
   end 

   //------------------------------------------------------------------
   // Falling edge or low level detection on the external input int1
   // int1_fall is high active
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : int1_fall_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      int1_fall <= 1'b0 ; 
      int1_ff <= 1'b0 ; 
      int1_ff0  <= 1'b0;
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Falling edge detection
      //--------------------------------
      begin
      if (cycle == 1)
         begin
         int1_fall <= 1'b0 ; 
         end
      else if (!int1_ff0 & int1_ff)
         begin
         int1_fall <= 1'b1 ; 
         end 
      
      //--------------------------------
      // int1 input flip-flop
      //--------------------------------
      int1_ff0 <= int1;
      int1_ff  <= int1_ff0;
      
      end  
   end 
   
   //------------------------------------------------------------------
   // Timer 0 open gate control
   //------------------------------------------------------------------
   assign t0_open = tcon[4] & (int0_ff0 | ~tmod[3]) ; 
   
   //------------------------------------------------------------------
   // Timer 1 open gate control
   //------------------------------------------------------------------
   assign t1_open = tcon[6] & (int1_ff0 | ~tmod[7]) ; 
   
   //------------------------------------------------------------------
   // Timer 0 low ordered byte clock
   // tl0_clk is high active during single clk period
   //------------------------------------------------------------------
   assign tl0_clk =
      (t0_open & !(tmod[2])) ? t0_clk :
      (t0_open & (tmod[2])) ? t0_fall :
      1'b0 ; 
   
   //------------------------------------------------------------------
   // Timer 1 low ordered byte clock
   // tl0_clk is high active during single clk period
   //------------------------------------------------------------------
   assign tl1_clk =
      //(t1_open & !(tmod[6]) & ~(t0_mode == 2'b11)) ? t1_clk :   //changed by ls, 09/07/31
      //(t1_open &  (tmod[6]) & ~(t0_mode == 2'b11)) ? t1_fall :
      //1'b0 ;
      (t1_open & !(tmod[6]) & ~(t1_mode == 2'b11)) ? t1_clk :
      (t1_open &  (tmod[6]) & ~(t1_mode == 2'b11)) ? t1_fall :
      1'b0 ;
       
   
   //------------------------------------------------------------------
   // Timer 0 high ordered byte clock
   // th0_clk is high active during single clk period
   //------------------------------------------------------------------
   assign th0_clk =
      (t0_mode == 2'b00 | t0_mode == 2'b01) ? tl0_ov : // Modes 0 or 1
      ((tcon[6]) & t0_mode == 2'b11) ? t0_clk :        // Mode 3
      1'b0 ; 
   
   //------------------------------------------------------------------
   // Timer 1 high ordered byte clock
   // th1_clk is high active during single clk period
   //------------------------------------------------------------------
   assign th1_clk =
      //(t0_mode == 2'b00 | t0_mode == 2'b01) ? tl1_ov : // Modes 0 or 1, changed by ls, 09/07/31
      //1'b0 ;
      (t1_mode == 2'b00 | t1_mode == 2'b01) ? tl1_ov : // Modes 0 or 1
      1'b0 ; 

   //------------------------------------------------------------------
   // Timer low 0 overflow
   // tl0_ov is high active during single clk period
   //------------------------------------------------------------------
   assign tl0_ov =
      (
         (tl0[4:0] == 5'b11111 & t0_mode == 2'b00) |
         (tl0[7:0] == 8'b11111111)
      ) ? tl0_clk :
      1'b0 ; 
   
   //------------------------------------------------------------------
   // Timer low 0 overflow flip-flop
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : tl0_ov_ff_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      tl0_ov_ff<= 1'b0;
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      begin
      if (tl0_ov)
         begin
         tl0_ov_ff <= 1'b1;
         end
      else if (cycle == 1)
         begin
         tl0_ov_ff <= 1'b0;
         end
      end
   end

   //------------------------------------------------------------------
   // Timer low 1 overflow
   // tl1_ov is high active during single clk period
   //------------------------------------------------------------------
   assign tl1_ov =
      (
         (tl1[4:0] == 5'b11111 & t1_mode == 2'b00) |
         (tl1[7:0] == 8'b11111111)
      ) ? tl1_clk :
      1'b0 ; 
   
   //------------------------------------------------------------------
   // Timer low 1 overflow flip-flop
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : tl1_ov_ff_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      tl1_ov_ff <= 1'b0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      begin
      if (tl1_ov)
         begin
         tl1_ov_ff <= 1'b1 ; 
         end
      else if (cycle == 1)
         begin
         tl1_ov_ff <= 1'b0 ; 
         end 
      end  
   end 
   
   //------------------------------------------------------------------
   // Timer high 0 overflow
   // th0_ov is high active during single clk period
   //------------------------------------------------------------------
   assign th0_ov =
      (th0[7:0] == 8'b11111111) ? th0_clk :
      1'b0 ; 
   
   //------------------------------------------------------------------
   // Timer high 0 overflow flip-flop
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : th0_ov_ff_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      th0_ov_ff <= 1'b0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      begin
      if (th0_ov)
         begin
         th0_ov_ff <= 1'b1 ; 
         end
      else if (cycle == 1)
         begin
         th0_ov_ff <= 1'b0 ; 
         end 
      end  
   end 
   
   //------------------------------------------------------------------
   // Timer high 0 overflow
   // th1_ov is high active during single clk period
   //------------------------------------------------------------------
   assign th1_ov =
      (th1[7:0] == 8'b11111111) ? th1_clk :
      1'b0 ; 
   
   //------------------------------------------------------------------
   // Timer high 1 overflow flip-flop
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : th1_ov_ff_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      th1_ov_ff <= 1'b0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      begin
      if (th1_ov)
         begin
         th1_ov_ff <= 1'b1 ; 
         end
      else if (cycle == 1)
         begin
         th1_ov_ff <= 1'b0 ; 
         end 
      end  
   end 
   
   //------------------------------------------------------------------
   // Special Function registers read
   //------------------------------------------------------------------
   assign sfrdatatim =
      (sfraddr == TL0_ID) ? tl0 :
      (sfraddr == TH0_ID) ? th0 :
      (sfraddr == TL1_ID) ? tl1 :
      (sfraddr == TH1_ID) ? th1 :
      (sfraddr == TMOD_ID) ? tmod :
      (sfraddr == TCON_ID) ? tcon :
      "--------" ; 


endmodule  //  module TIMER_0_1

//*******************************************************************--
