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
// File name            : timer2.v
// File contents        : Module TIMER_2
// Purpose              : Timer/Counter 2
//                        Capture/Compare Unit
//
// Destination library  : R80515_LIB
//
// Design Engineer      : M.B. A.B.
// Quality Engineer     : M.B.
// Version              : 1.10.V05
// Last modification    : 2002-01-08
//---------------------------------------------------------------------

`timescale 1 ns / 1 ns // timescale for following modules

//*******************************************************************--
// Modifications with respect to Version 1.01.E00 :
// 1.04.E00   :
// 2000-04-10 : Added output ccenreg
// 1.04.E06   :
// 2001-05-10 : added flip-flops for t2, cc0, cc1, cc2 and cc3 inputs
//*******************************************************************--
   
module TIMER_2
   (
   clk,
   rst,
   t2,
   t2ex,
   cc0,
   cc1,
   cc2,
   cc3,
   com0,
   com1,
   com2,
   com3,
   ccenreg,
   i2fr,
   i3fr,
   tf2,
   exf2,
   ccubus,
   sfrdatai,
   sfrdatatim2,
   sfraddr,
   sfrwe
   );

   
   //  Declarations
   `include "utility.v"
   
   //  Control signals inputs
   input    clk;           // Global clock input
   input    rst;           // Global reset input
   
   //  Timer inputs
   input    t2;            // Timer 2 external input
   input    t2ex;          // Timer 2 capture trigger
   
   //  Compare Capture inputs
   input    cc0;           // Compare/Capture 0 input
   input    cc1;           // Compare/Capture 1 input
   input    cc2;           // Compare/Capture 2 input
   input    cc3;           // Compare/Capture 3 input
   
   //  Compare  outputs
   output   com0;          // Compare 0 output
   wire     com0;
   output   com1;          // Compare 1 output
   wire     com1;
   output   com2;          // Compare 2 output
   wire     com2;
   output   com3;          // Compare 3 output
   wire     com3;
   output   [7:0] ccenreg; //ccen reg.
   wire     [7:0] ccenreg;
   
   //  T2CON
   output   i2fr; 
   wire     i2fr;
   output   i3fr; 
   wire     i3fr;
   
   //  Timer interrupt flags
   output   tf2;           // Timer 2 overflow signal
   wire     tf2;
   output   exf2;          // Timer 2 external signal
   wire     exf2;
   
   //  Special function register interface
   output   [3:0] ccubus; 
   wire     [3:0] ccubus;
   input    [7:0] sfrdatai; 
   output   [7:0] sfrdatatim2; 
   wire     [7:0] sfrdatatim2;
   input    [6:0] sfraddr; 
   input    sfrwe; 

   //---------------------------------------------------------------------
   // t2cm    - compare mode bit -t2con(2) when 0 -mod 0
   //                                      when 1 -mod 1
   // cocahl  - enable compare function -ccen
   // compare - signal compare in compare mode 0 directly controled port
   // ov      - Timer 2 Overflow in compare mode 0 directly controled port
   // pout    - port output 
   //---------------------------------------------------------------------
   
   //---------------------------------------------------------------
   // Clock counter
   //---------------------------------------------------------------
   reg      [4:0] clk_count; 
   reg      clk_ov12;      // Clock divided by 12
   reg      clk_ov24;      // Clock divided by 24
   
   //---------------------------------------------------------------
   // Timer 2 registers
   //---------------------------------------------------------------
   // Timer/Counter registers
   reg      [7:0] tl2; 
   reg      [7:0] th2; 
   
   // Control registers
   reg      [7:0] t2con; 
   
   // Compare/capture enable register
   reg      [7:0] ccen; 
   
   //---------------------------------------------------------------
   // Compare/Reload/Capture registers
   //---------------------------------------------------------------
   // Compare/Reload registers
   reg      [7:0] crcl; 
   reg      [7:0] crch; 
   
   // Compare/Capture registers
   reg      [7:0] ccl1; 
   reg      [7:0] cch1; 
   reg      [7:0] ccl2; 
   reg      [7:0] cch2; 
   reg      [7:0] ccl3; 
   reg      [7:0] cch3; 
   
   //---------------------------------------------------------------
   // Timer 2 control signals
   //---------------------------------------------------------------
   // External input t2 falling edge detector
   reg      t2_fall;       // t2 input fall edge detector
   reg      t2_ff0;        // t2 input flip-flop
   reg      t2_ff;         // t2 input flip-flop
   
   // Capture input for CC register 1 rising edge detector 
   reg      cc1_rise; 
   reg      cc1_ff0;
   reg      cc1_ff; 
   
   // Capture input for CC register 2 rising edge detector
   reg      cc2_rise; 
   reg      cc2_ff0;
   reg      cc2_ff; 
   
   // Capture input for CC register 3 rising edge detector
   reg      cc3_rise; 
   reg      cc3_ff0;
   reg      cc3_ff; 
   
   // Capture input for CRC register falling or rising edge detector
   reg      cc0_fall_rise; 
   reg      cc0_ff0;
   reg      cc0_ff; 
   
   // External input t2ex falling edge detector
   reg      t2ex_fall;     // t2ex trigger fall edge detector
   reg      t2ex_ff0;      // t2ex trigger flip-flop
   reg      t2ex_ff;       // t2ex trigger flip-flop
   
   // Timer 0 signals
   wire     t2_clk;        // Timer 2 clock
   wire     tl2_clk;       // Timer low 2 clock
   wire     th2_clk;       // Timer high 2 clock
   wire     tl2_ov;        // Timer low 2 overflow
   wire     th2_ov;        // Timer high 2 overflow
   
   // Compare signal 
   reg      com_int0; 
   reg      com_int1; 
   reg      com_int2; 
   reg      com_int3; 
   
   // Internal ports outputs
   wire     cc0_out_int; 
   wire     cc1_out_int; 
   wire     cc2_out_int; 
   wire     cc3_out_int; 

   //---------------------------------------------------------------
   // Compare/Capture Bit Port 0 Control
   //---------------------------------------------------------------
   CCU_PORT CCU_PORT_0
      (
      .clk        (clk),
      .rst        (rst),
      .compare    (com_int0),
      .ov         (th2_ov),
      .cocahl     (ccen[1:0]),
      .t2cm       (t2con[2]),
      .pout       (cc0_out_int),
      .sfrdatai   (sfrdatai[0]),
      .sfraddr    (sfraddr),
      .sfrwe      (sfrwe)
      ); 
   
   //---------------------------------------------------------------
   // Compare/Capture Bit Port 1 Control
   //---------------------------------------------------------------
   CCU_PORT CCU_PORT_1
      (
      .clk        (clk),
      .rst        (rst),
      .compare    (com_int1),
      .ov         (th2_ov),
      .cocahl     (ccen[3:2]),
      .t2cm       (t2con[2]),
      .pout       (cc1_out_int),
      .sfrdatai   (sfrdatai[1]),
      .sfraddr    (sfraddr),
      .sfrwe      (sfrwe)
      ); 
   
   //---------------------------------------------------------------
   // Compare/Capture Bit Port 0 Control
   //---------------------------------------------------------------
   CCU_PORT CCU_PORT_2
      (
      .clk        (clk),
      .rst        (rst),
      .compare    (com_int2),
      .ov         (th2_ov),
      .cocahl     (ccen[5:4]),
      .t2cm       (t2con[2]),
      .pout       (cc2_out_int),
      .sfrdatai   (sfrdatai[2]),
      .sfraddr    (sfraddr),
      .sfrwe      (sfrwe)
      ); 
   
   //---------------------------------------------------------------
   // Compare/Capture Bit Port 0 Control
   //---------------------------------------------------------------
   CCU_PORT CCU_PORT_3
      (
      .clk        (clk),
      .rst        (rst),
      .compare    (com_int3),
      .ov         (th2_ov),
      .cocahl     (ccen[7:6]),
      .t2cm       (t2con[2]),
      .pout       (cc3_out_int),
      .sfrdatai   (sfrdatai[3]),
      .sfraddr    (sfraddr),
      .sfrwe      (sfrwe)
      ); 
   
   //------------------------------------------------------------------
   // Compare Capture Enable Register 
   //------------------------------------------------------------------
   assign ccenreg = ccen ; 
   
   //------------------------------------------------------------------
   // Timer 2 external flag
   //   interrupt request flag
   //   high active output
   //------------------------------------------------------------------
   assign exf2 = t2ex_fall ; 
   
   //------------------------------------------------------------------
   // Timer 2 overflow output
   //   output for serial interface
   //   high active output
   //   active during single clk period
   //------------------------------------------------------------------
   assign tf2 = th2_ov ; 
   
   //------------------------------------------------------------------
   // Timer 2 clock
   // t0_clk is high active during single clk period
   //------------------------------------------------------------------
   assign t2_clk =
      ((t2con[7])) ? clk_ov24 :
      clk_ov12 ; 
   
   //------------------------------------------------------------------
   // Timer 2 low ordered byte clock
   // tl2_clk is high active during single clk period
   //------------------------------------------------------------------
   assign tl2_clk =
      (t2con[1:0] == 2'b01) ? t2_clk :
      (t2con[1:0] == 2'b10) ? t2_fall :
      (t2con[1:0] == 2'b11) ? t2_ff0 & t2_clk :
      1'b0 ; 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : t2con_ccen_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      t2con <= T2CON_RV ; 
      ccen <= CCEN_RV ; 
      end
   else
      //--------------------------------
      // Special function register write
      //--------------------------------
      begin
      if (sfrwe & sfraddr == T2CON_ID)
         begin
         t2con <= sfrdatai ; 
         end 
      
      if (sfrwe & sfraddr == CCEN_ID)
         begin
         ccen <= sfrdatai ; 
         end 
      
      end  
   end 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : cc1_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      ccl1 <= CCL1_RV ; 
      cch1 <= CCH1_RV ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Timer 2 Capture
      //--------------------------------
      begin
      if (ccen[3:2] == 2'b01 & cc1_rise)
         begin
         ccl1 <= tl2 ; 
         cch1 <= th2 ; 
         end 
      
      //--------------------------------
      // Special function register write
      //--------------------------------
      if (sfrwe & sfraddr == CCL1_ID)
         begin
         if (ccen[3:2] == 2'b11)
            begin
            ccl1 <= tl2 ; 
            cch1 <= th2 ; 
            end
         else
            begin
            ccl1 <= sfrdatai ; 
            end 
         end 
         
      if (sfrwe & sfraddr == CCH1_ID)
         begin
         cch1 <= sfrdatai ; 
         end 
      
      end  
   end 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : cc2_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      ccl2 <= CCL2_RV ; 
      cch2 <= CCH2_RV ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Timer 2 Capture
      //--------------------------------
      begin
      if (ccen[5:4] == 2'b01 & cc2_rise)
         begin
         ccl2 <= tl2 ; 
         cch2 <= th2 ; 
         end 
      
      //--------------------------------
      // Special function register write
      //--------------------------------
      if (sfrwe & sfraddr == CCL2_ID)
         begin
         if (ccen[5:4] == 2'b11)
            begin
            ccl2 <= tl2 ; 
            cch2 <= th2 ; 
            end
         else
            begin
            ccl2 <= sfrdatai ; 
            end 
         end 
      
      if (sfrwe & sfraddr == CCH2_ID)
         begin
         cch2 <= sfrdatai ; 
         end 
      
      end  
   end 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : cc3_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      ccl3 <= CCL3_RV ; 
      cch3 <= CCH3_RV ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Timer 2 Capture
      //--------------------------------
      begin
      if (ccen[7:6] == 2'b01 & cc3_rise)
         begin
         ccl3 <= tl2 ; 
         cch3 <= th2 ; 
         end 
      
      //--------------------------------
      // Special function register write
      //--------------------------------
      if (sfrwe & sfraddr == CCL3_ID)
         begin
         if (ccen[7:6] == 2'b11)
            begin
            ccl3 <= tl2 ; 
            cch3 <= th2 ; 
            end
         else
            begin
            ccl3 <= sfrdatai ; 
            end 
         end 
         
      if (sfrwe & sfraddr == CCH3_ID)
         begin
         cch3 <= sfrdatai ; 
         end 
      
      end  
   end 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : crc_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      crcl <= CRCL_RV ; 
      crch <= CRCH_RV ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Timer 2 Capture
      //--------------------------------
      begin
      if (ccen[1:0] == 2'b01 & cc0_fall_rise)
         begin
         crcl <= tl2 ; 
         crch <= th2 ; 
         end 
      
      //--------------------------------
      // Special function register write
      //--------------------------------
      if (sfrwe & sfraddr == CRCL_ID)
         begin
         if (ccen[1:0] == 2'b11)
            begin
            crcl <= tl2 ; 
            crch <= th2 ; 
            end
         else
            begin
            crcl <= sfrdatai ; 
            end 
         end 
         
      if (sfrwe & sfraddr == CRCH_ID)
         begin
         crch <= sfrdatai ; 
         end 
      
      end  
   end 

   //------------------------------------------------------------------
   always @(tl2 or th2 or ccl1 or cch1 or ccl2 or cch2 or ccl3 or cch3 or 
            crcl or crch or ccen)
   //------------------------------------------------------------------
   begin : compare_proc
   //------------------------------------------------------------------
   case (ccen[1:0])
   2'b10 :
      begin
      if ((tl2 == crcl) & (th2 == crch))
         begin
         com_int0 = 1'b1 ; 
         end
      else
         begin
         com_int0 = 1'b0 ; 
         end 
      end
   
   default :
      begin
      com_int0 = 1'b0 ; 
      end
   
   endcase 
   
   case (ccen[3:2])
   2'b10 :
      begin
      if ((tl2 == ccl1) & (th2 == cch1))
         begin
         com_int1 = 1'b1 ; 
         end
      else
         begin
         com_int1 = 1'b0 ; 
         end 
      end
   
   default :
      begin
      com_int1 = 1'b0 ; 
      end
   
   endcase 
   
   case (ccen[5:4])
   2'b10 :
      begin
      if ((tl2 == ccl2) & (th2 == cch2))
         begin
         com_int2 = 1'b1 ; 
         end
      else
         begin
         com_int2 = 1'b0 ; 
         end 
      end
   
   default :
      begin
      com_int2 = 1'b0 ; 
      end
   
   endcase 
   
   case (ccen[7:6])
   2'b10 :
      begin
      if ((tl2 == ccl3) & (th2 == cch3))
         begin
         com_int3 = 1'b1 ; 
         end
      else
         begin
         com_int3 = 1'b0 ; 
         end 
      end
   
   default :
      begin
      com_int3 = 1'b0 ; 
      end
   
   endcase 
   end 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : timer2_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      tl2 <= TL2_RV ; 
      th2 <= TH2_RV ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Timer 2 Reload
      //--------------------------------
      // Mode 0
      //--------------------------------
      begin
      if ((((t2con[4]) & !(t2con[3])) & th2_ov) |
         //--------------------------------
         // Mode 1
         //--------------------------------
         (((t2con[4]) & (t2con[3])) & t2ex_fall))
         begin
         tl2 <= crcl ; 
         th2 <= crch ; 
         end
      else
         //--------------------------------
         // Timer 2 Count
         //--------------------------------
         begin
         if (tl2_clk)
            begin
            tl2 <= tl2 + 1'b1 ; 
            end 
         
         if (th2_clk)
            begin
            th2 <= th2 + 1'b1 ; 
            end 
         
         end 
         
      //--------------------------------
      // Special function register write
      //--------------------------------
      if (sfrwe & sfraddr == TL2_ID)
         begin
         tl2 <= sfrdatai ; 
         end 
      
      if (sfrwe & sfraddr == TH2_ID)
         begin
         th2 <= sfrdatai ; 
         end 
      
      end  
   end 

   //------------------------------------------------------------------
   // Clock counter with overflow divided by 12 or 24
   // clk_ov12 is high active during single clk period
   // clk_ov24 is high active during single clk period
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : clk_count_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      clk_count <= 5'b00000 ; 
      clk_ov12 <= 1'b0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Clock counter
      //--------------------------------
      begin
      if (clk_count == 5'b10111)
         begin
         clk_count <= 5'b00000 ; 
         end
      else
         begin
         clk_count <= clk_count + 1'b1 ; 
         end 
         
      //--------------------------------
      // Clock divided by 12
      //--------------------------------
      if (clk_count == 5'b01011)
         begin
         clk_ov12 <= 1'b1 ; 
         end
      else if (clk_count == 5'b10111)
         begin
         clk_ov12 <= 1'b1 ; 
         end
      else
         begin
         clk_ov12 <= 1'b0 ; 
         end 
      
      //--------------------------------
      // Clock divided by 24
      //--------------------------------
      if (clk_count == 5'b10111)
         begin
         clk_ov24 <= 1'b1 ; 
         end
      else
         begin
         clk_ov24 <= 1'b0 ; 
         end 
      
      end  
   end 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : det_ff_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      t2_ff    <= 1'b0 ; 
      t2_ff0   <= 1'b0 ; 
      cc1_ff   <= 1'b0 ; 
      cc1_ff0  <= 1'b0 ; 
      cc2_ff   <= 1'b0 ; 
      cc2_ff0  <= 1'b0 ; 
      cc3_ff   <= 1'b0 ; 
      cc3_ff0  <= 1'b0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // t2 input flip-flop
      //--------------------------------
      begin
      t2_ff0   <= t2 ; 
      cc1_ff0  <= cc1 ; 
      cc2_ff0  <= cc2 ; 
      cc3_ff0  <= cc3 ; 
      t2_ff    <= t2_ff0 ; 
      cc1_ff   <= cc1_ff0 ; 
      cc2_ff   <= cc2_ff0 ; 
      cc3_ff   <= cc3_ff0 ; 
      end  
   end 

   //------------------------------------------------------------------
   // Falling edge detection on the external input t2
   // t2_fall is high active during single clk period
   //------------------------------------------------------------------
   always @(t2_ff0 or t2_ff or cc1_ff0 or cc1_ff or cc2_ff0 or
      cc2_ff or cc3_ff0 or cc3_ff)
   begin : det_rise_fall_proc
   //------------------------------------------------------------------
   //--------------------------------
   // Falling edge detection
   //--------------------------------
   if (!t2_ff0 & t2_ff)
      begin
      t2_fall = 1'b1 ; 
      end
   else
      begin
      t2_fall = 1'b0 ; 
      end 
   //--------------------------------
   // Rising edge detection
   //--------------------------------
   if (cc1_ff0 & !cc1_ff)
      begin
      cc1_rise = 1'b1 ; 
      end
   else
      begin
      cc1_rise = 1'b0 ; 
      end 
   if (cc2_ff0 & !cc2_ff)
      begin
      cc2_rise = 1'b1 ; 
      end
   else
      begin
      cc2_rise = 1'b0 ; 
      end 
   if (cc3_ff0 & !cc3_ff)
      begin
      cc3_rise = 1'b1 ; 
      end
   else
      begin
      cc3_rise = 1'b0 ; 
      end 
   end 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : cc0_ff_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      cc0_ff <= 1'b0 ; 
      cc0_ff0 <= 1'b0 ; 
      end
   else
      begin
      cc0_ff0 <= cc0 ; 
      cc0_ff <= cc0_ff0 ; 
      end  
   end 

   //------------------------------------------------------------------
   always @(cc0_ff0 or cc0_ff or t2con)
   begin : cc0_fall_rise_proc
   //------------------------------------------------------------------
   if (t2con[6])
      //--------------------------------
      // Rising edge detection
      //--------------------------------
      begin
      if (cc0_ff0 & !cc0_ff)
         begin
         cc0_fall_rise = 1'b1 ; 
         end
      else
         begin
         cc0_fall_rise = 1'b0 ; 
         end 
      end
   else
      //--------------------------------
      // Falling edge detection
      //--------------------------------
      begin
      if (!cc0_ff0 & cc0_ff)
         begin
         cc0_fall_rise = 1'b1 ; 
         end
      else
         begin
         cc0_fall_rise = 1'b0 ; 
         end 
      end 
   end 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : t2ex_ff_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      t2ex_ff <= 1'b0 ; 
      t2ex_ff0 <= 1'b0 ; 
      end
   else
      //--------------------------------
      // t2ex trigger flip-flop
      //--------------------------------
      begin
      t2ex_ff0 <= t2ex ; 
      t2ex_ff <= t2ex_ff0 ; 
      end  
   end 

   //------------------------------------------------------------------
   // Falling edge detection on the external trigger t2ex
   // t2ex_fall is high active during single clk period
   //------------------------------------------------------------------
   always @(t2ex_ff0 or t2ex_ff)
   begin : t2ex_fall_proc
   //------------------------------------------------------------------
   //--------------------------------
   // Falling edge detection
   //--------------------------------
   if (!t2ex_ff0 & t2ex_ff)
      begin
      t2ex_fall = 1'b1 ; 
      end
   else
      begin
      t2ex_fall = 1'b0 ; 
      end 
   end 
   
   //------------------------------------------------------------------
   // Compare output signal
   //------------------------------------------------------------------
   assign com0 = com_int0 ; 
   assign com1 = com_int1 ; 
   assign com2 = com_int2 ; 
   assign com3 = com_int3 ; 
   
   //------------------------------------------------------------------
   // ISR control signals
   //------------------------------------------------------------------
   assign i2fr = t2con[5] ; 
   assign i3fr = t2con[6] ; 
   
   //------------------------------------------------------------------
   // CCU_bus output
   //------------------------------------------------------------------
   assign ccubus[0] = cc0_out_int ; 
   assign ccubus[1] = cc1_out_int ; 
   assign ccubus[2] = cc2_out_int ; 
   assign ccubus[3] = cc3_out_int ; 
   
   //------------------------------------------------------------------
   // Timer 2 high ordered byte clock
   // th2_clk is high active during single clk period
   //------------------------------------------------------------------
   assign th2_clk = tl2_ov ; 
   
   //------------------------------------------------------------------
   // Timer low 2 overflow
   // tl2_ov is high active during single clk period
   //------------------------------------------------------------------
   assign tl2_ov =
      (tl2[7:0] == 8'b11111111) ? tl2_clk :
      1'b0 ; 
   
   //------------------------------------------------------------------
   // Timer high 2 overflow
   // th0_ov is high active during single clk period
   //------------------------------------------------------------------
   assign th2_ov =
      (th2[7:0] == 8'b11111111) ? th2_clk :
      1'b0 ; 
   
   //------------------------------------------------------------------
   // Special Function registers read
   //------------------------------------------------------------------
   assign sfrdatatim2 =
      (sfraddr == TL2_ID) ? tl2 :
      (sfraddr == TH2_ID) ? th2 :
      (sfraddr == CRCL_ID) ? crcl :
      (sfraddr == CRCH_ID) ? crch :
      (sfraddr == T2CON_ID) ? t2con :
      (sfraddr == CCEN_ID) ? ccen :
      (sfraddr == CCL1_ID) ? ccl1 :
      (sfraddr == CCH1_ID) ? cch1 :
      (sfraddr == CCL2_ID) ? ccl2 :
      (sfraddr == CCH2_ID) ? cch2 :
      (sfraddr == CCL3_ID) ? ccl3 :
      (sfraddr == CCH3_ID) ? cch3 :
      "--------" ; 


endmodule  //  module TIMER_2

//*******************************************************************--
