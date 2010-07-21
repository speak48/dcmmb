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
// File name            : clkctrl.v
// File contents        : Module CLOCK_CONTROL
// Purpose              : Clock Control Unit
//                        Internal reset control unit
//
// Destination library  : R80515_LIB
//
// Design Engineer      : M.B.
// Quality Engineer     : M.B.
// Version              : 1.10.V05
// Last modification    : 2002-01-08
//---------------------------------------------------------------------

`timescale 1 ns / 1 ns // timescale for following modules

//*******************************************************************--
// Modifications with respect to Version 1.01.E00 :
// 1.10.E00   :
// 2001-09-03 : Removed reset and wdts inputs
//            : Removed reset detector
//            : Removed rsto output
//            : The pcon.1-0 always read as zero
// 1.10.V03   :
// 2002-01-08 : Added mempsack, mempsrd ports
// 2002-01-08 : Added waitcount_proc
//*******************************************************************--
   
module CLOCK_CONTROL (
   clk,
   rst,
   mempsrd,
   smod,
   stretch,
   mempsack,
   sfrdatai,
   sfrdataclk,
   sfraddr,
   sfrwe,
   ckcon      //add by lishuang, 09/07/29
   );
   
   
   //  Declarations
   `include "utility.v"
   
   //  Control signals inputs
   input       clk;     // Global clock input
   input       rst;     // Internal reset input

   //  Program memory read
   input       mempsrd;
   
   //  Clock Control outputs
   output      smod;    // Baud rate Doubler
   wire        smod;
   output      [2:0] stretch; 
   wire        [2:0] stretch;

   //  Program memory waitstates
   output      mempsack;
   wire        mempsack;
   
   //  Special function register interface
   input       [7:0] sfrdatai; 
   output      [7:0] sfrdataclk; 
   wire        [7:0] sfrdataclk;
   input       [6:0] sfraddr; 
   input       sfrwe; 
   
   //  Clock control register output, add by lishuang, 09/07/29
   output      [7:0] ckcon;

   //------------------------------------------------------------------
   
   // Power Control register
   reg         [7:2] pcon; 
   
   // Clock Control register
   reg         [7:0] ckcon; 
   
   // Wait states counter
   reg         [2:0] waitcount;
   
   //------------------------------------------------------------------
   // Baud rate Doubler
   //------------------------------------------------------------------
   assign smod = pcon[7] ; 
   
   //------------------------------------------------------------------
   // Data Memory cycle stretch control
   //------------------------------------------------------------------
   assign stretch = ckcon[2:0] ; 

   //------------------------------------------------------------------
   // pcon register
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : pcon_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      pcon <= PCON_RV[7:2] ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Special function register write
      //--------------------------------
      begin
      if (sfrwe & sfraddr == PCON_ID)
         begin
         pcon <= sfrdatai[7:2] ; 
         end 
      end  
   end 

   //------------------------------------------------------------------
   // ckcon register
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : ckcon_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      ckcon <= CKCON_RV ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Special function register write
      //--------------------------------
      begin
      if (sfrwe & sfraddr == CKCON_ID)
         begin
         ckcon <= sfrdatai ; 
         end 
      end  
   end 

   //------------------------------------------------------------------
   // Wait states counter
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : waitcount_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      waitcount <= CKCON_RV[6:4];
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Current cycle count
      //--------------------------------
      begin
      if (mempsrd)
         begin
         if (waitcount == 3'b000)
            begin
            waitcount <= ckcon[6:4];
            end
         else
            begin
            waitcount <= waitcount - 3'b001;
            end
         end
      else
         begin
         waitcount <= ckcon[6:4];
         end
      end
   end
      
   //------------------------------------------------------------------
   // Program memory acknowledge
   //------------------------------------------------------------------
   assign mempsack = (waitcount == 3'b000 | !mempsrd) ? 1'b1 :
                     1'b0;
   
   //------------------------------------------------------------------
   // Special Function registers read
   //------------------------------------------------------------------
   assign sfrdataclk = (sfraddr == PCON_ID) ? {pcon, 2'b00} :
                       (sfraddr == CKCON_ID) ? ckcon :
                       "--------" ; 

endmodule  // module CLOCK_CONTROL

//*******************************************************************--
