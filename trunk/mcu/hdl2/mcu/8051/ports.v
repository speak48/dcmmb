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
// File name            : ports.v
// File contents        : Module PORTS
// Purpose              : Port registers unit
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
//*******************************************************************--

module PORTS
   (clk,
   rst,
   port0i,
   port1i,
   port2i,
   port3i,
   rmwinstr,
   ccubus,
   port0o,
   port1o,
   port2o,
   port3o,
   sfrdatai,
   sfrdataports,
   sfraddr,
   sfrwe);


   //  Declarations
   `include "utility.v"

   
   //  Control signals inputs
   input    clk;           // Global clock input
   input    rst;           // Global reset input
   
   //  Port inputs
   input    [7:0] port0i; 
   input    [7:0] port1i; 
   input    [7:0] port2i; 
   input    [7:0] port3i; 
   
   //  CPU control signals
   input    rmwinstr;      // Read-Modify-Write Instr.
   
   //  CCU bus input
   input    [3:0] ccubus; 
   
   //  Port outputs
   output   [7:0] port0o; 
   wire     [7:0] port0o;
   output   [7:0] port1o; 
   wire     [7:0] port1o;
   output   [7:0] port2o; 
   wire     [7:0] port2o;
   output   [7:0] port3o; 
   wire     [7:0] port3o;
   
   //  Special function register interface
   input    [7:0] sfrdatai; 
   output   [7:0] sfrdataports; 
   wire     [7:0] sfrdataports;
   input    [6:0] sfraddr; 
   input    sfrwe; 

   //------------------------------------------------------------------

   // Port registers
   reg      [7:0] p0; 
   reg      [7:0] p1; 
   reg      [7:0] p2; 
   reg      [7:0] p3; 

   //------------------------------------------------------------------
   // Port 0 ouput
   //------------------------------------------------------------------
   assign port0o = p0 ; 
   
   //------------------------------------------------------------------
   // Port 1 ouput
   //------------------------------------------------------------------
   assign port1o = {p1[7:4], ccubus} ; 
   
   //---------------------
   // Standard solution
   // port1o = p1;
   //---------------------
   
   //------------------------------------------------------------------
   // Port 2 ouput
   //------------------------------------------------------------------
   assign port2o = p2 ; 
   
   //------------------------------------------------------------------
   // Port 3 ouput
   //------------------------------------------------------------------
   assign port3o = p3 ; 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : ports_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      p0 <= P0_RV ; 
      p1 <= P1_RV ; 
      p2 <= P2_RV ; 
      p3 <= P3_RV ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Special function register write
      //--------------------------------
      begin
      if (sfrwe & sfraddr == P0_ID)
         begin
         p0 <= sfrdatai ; 
         end 
         
      if (sfrwe & sfraddr == P1_ID)
         begin
         p1 <= sfrdatai ; 
         end 
         
      if (sfrwe & sfraddr == P2_ID)
         begin
         p2 <= sfrdatai ; 
         end 
      
      if (sfrwe & sfraddr == P3_ID)
         begin
         p3 <= sfrdatai ; 
         end 
      
      end  
   end 
   
   //------------------------------------------------------------------
   // Special Function registers read
   //------------------------------------------------------------------
   assign sfrdataports =
      (sfraddr == P0_ID & rmwinstr) ? p0 :
      (sfraddr == P1_ID & rmwinstr) ? p1 :
      (sfraddr == P2_ID & rmwinstr) ? p2 :
      (sfraddr == P3_ID & rmwinstr) ? p3 :
      (sfraddr == P0_ID & !rmwinstr) ? port0i :
      (sfraddr == P1_ID & !rmwinstr) ? port1i :
      (sfraddr == P2_ID & !rmwinstr) ? port2i :
      (sfraddr == P3_ID & !rmwinstr) ? port3i :
      "--------" ; 


endmodule  //  module PORTS

//*******************************************************************--
