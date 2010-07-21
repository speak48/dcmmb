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
// File name            : watchdog.v
// File contents        : Module WATCHDOG_TIMER
// Purpose              : Programmable Watchdog Timer
//
// Destination library  : R80515_LIB
//
// Design Engineer      : R.Z
// Quality Engineer     : M.B.
// Version              : 1.10.V05
// Last modification    : 2002-01-08
//---------------------------------------------------------------------

`timescale 1 ns / 1 ns // timescale for following modules

//*******************************************************************--
// Modifications with respect to Version 1.01.E00 :
// 1.04.E00   :
// 2000-04-10 : Removed outputs swdt, wdtclr
//            : Removed register counter_cl
//            : Modified timer_proc: for higher reload than count mode
//            : Modified wdt_act_proc: in case os watchdog start
// 1.10.E01   :
// 2001-11-13 : Modified wdtl, wdth, wdt_s reset value from 
//            : hard-coded value on constant
//*******************************************************************--
   
module WATCHDOG_TIMER
   (clk,
   rst,
   wdt,
   swd,
   wdts,
   sfrdatai,
   sfrdatawdt,
   sfraddr,
   sfrwe);
   
   
   //  Declarations
   `include "utility.v"
   
   //  Control input signals
   input    clk;           // Global clock input
   input    rst;           // Global reset input
   
   //  Watchdog Timer control signals
   input    wdt;           // WDT refresh flag
   input    swd;           // WDT start input
   
   //  Watchdog Timer output signals
   output   wdts;          // WDT status flag
   wire     wdts;
   
   //  Special function register interface
   input    [7:0] sfrdatai; 
   output   [7:0] sfrdatawdt; 
   wire     [7:0] sfrdatawdt;
   input    [6:0] sfraddr; 
   input    sfrwe; 

   //------------------------------------------------------------------

   // Watchdog Timer Reload Register
   reg      [7:0] wdtrel; 
   
   // Watchdog Timer Registers
   reg      [7:0] wdtl; 
   reg      [6:0] wdth; 
   
   // Watchdog Prescaler Registers    
   reg      pres_2; 
   reg      [3:0] pres_16; 
   
   // Watchdog counters of clk 
   reg      [3:0] cycles_reg; 
   
   // Watchdog activated register
   reg      wdt_act; 
   
   // wdt status flag
   wire     wdt_s; 

   //------------------------------------------------------------------
   // Watchdog Timer status flag
   //   reset request flag
   //   high active
   //------------------------------------------------------------------
   assign wdt_s =
      (({wdth, wdtl}) == WDT_RS) ? 1'b1 : // X\"7FFC\"
      1'b0 ; 
   
   //------------------------------------------------------------------
   // Watchdog Timer status flag
   //   reset request flag
   //   high active output
   //------------------------------------------------------------------
   assign wdts = wdt_s ; 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : wdrel_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      wdtrel <= WDTREL_RV ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Special function register write
      //--------------------------------
      begin
      if (sfrwe & sfraddr == WDTREL_ID)
         begin
         wdtrel <= sfrdatai ; 
         end 
      end  
   end 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : divider_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      cycles_reg <= 4'b0000 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      begin
      if (wdt_act)
         //--------------------------------
         // clk divider by 12
         //--------------------------------
         begin
         if (wdt &
            sfrwe &
            sfraddr == IEN1_ID &
            (sfrdatai[6]))
            begin
            cycles_reg <= 4'b0000 ; 
            end
         else
            begin
            if (cycles_reg == 4'b1011)
               begin
               cycles_reg <= 4'b0000 ; 
               end
            else
               begin
               cycles_reg <= cycles_reg + 1'b1 ; 
               end 
            end 
         end 
      end  
   end 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : prescaler_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      pres_2 <= 1'b0 ; 
      pres_16 <= 4'b0000 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      begin
      if (wdt_act)
         //--------------------------------
         // Prescalers :2, :16
         //--------------------------------
         begin
         if (wdt &
            sfrwe &
            sfraddr == IEN1_ID &
            (sfrdatai[6]))
            begin
            pres_2 <= 1'b0 ; 
            pres_16 <= 4'b0000 ; 
            end
         else
            begin
            if (cycles_reg == 4'b1011)
               begin
               pres_2 <= ~pres_2 ; 
               if (pres_2)
                  begin
                  if (pres_16 == 4'b1111)
                     begin
                     pres_16 <= 4'b0000 ; 
                     end
                  else
                     begin
                     pres_16 <= pres_16 + 1'b1 ; 
                     end 
                  end 
               end 
            end 
         end 
      end  
   end 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : timer_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      wdth <= WDTH_RV; // 7'b0000000
      wdtl <= WDTL_RV; // 8'b00000000
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------               
      // WDT Timer
      //--------------------------------
      begin
      if (wdt &
         sfrwe &
         sfraddr == IEN1_ID &
         (sfrdatai[6]))
         begin
         wdth <= wdtrel[6:0] ; 
         wdtl <= WDTL_RV; // 8'b00000000
         end
      else
         begin
         if (wdt_act)
            begin
            if (wdtrel[7])
               begin
               if (({pres_16, pres_2, cycles_reg}) == 9'b111111011)
                  begin
                     if (wdtl == 8'b11111111)
                     begin
                     wdtl <= WDTL_RV; // 8'h00
                     wdth <= wdth + 1'b1 ; 
                     end
                  else
                     begin
                     wdtl <= wdtl + 1'b1 ; 
                     end 
                  end 
               end
            else
               begin
               if (({pres_2, cycles_reg}) == 5'b11011)
                  begin
                  if (wdtl == 8'b11111111)
                     begin
                     wdtl <= WDTL_RV; // 8'h00
                     wdth <= wdth + 1'b1 ; 
                     end
                  else
                     begin
                     wdtl <= wdtl + 1'b1 ; 
                     end 
                  end 
               end 
            end 
         end 
      end  
   end 

   //------------------------------------------------------------------
   // Activate the Watchdog
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : wdt_act_proc
   //------------------------------------------------------------------
   //-----------------------------------
   // Synchronous reset
   //----------------------------------- 
   if (!wdt_s)  // HW reset
      begin
      if (rst)
         begin
         if (swd)
            begin
            wdt_act <= 1'b1 ; 
            end
         else
            begin
            wdt_act <= 1'b0 ; 
            end 
         end
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      else
         begin
         if (sfrwe & sfraddr == IEN1_ID & (sfrdatai[6]))
            begin
            wdt_act <= 1'b1 ; 
            end 
         end 
      end  
   end 
   
   //------------------------------------------------------------------
   // Special function registers read
   //------------------------------------------------------------------
   assign sfrdatawdt =
      (sfraddr == WDTREL_ID) ? wdtrel :
      "--------" ; 


endmodule  //  module WATCHDOG_TIMER

//*******************************************************************--
