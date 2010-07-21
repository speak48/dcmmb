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
// File name            : ccuport.v
// File contents        : Module CCU_PORT
// Purpose              : CCU Input/Output port registers
//
// Destination library  : R80515_LIB
//
// Design Engineer      : A.B.
// Quality Engineer     : M.B.
// Version              : 1.10.V05
// Last modification    : 2002-01-08
//---------------------------------------------------------------------

`timescale 1 ns / 1 ns // timescale for following modules

//*******************************************************************--
// Modifications with respect to Version 1.01.E00 :
//*******************************************************************--

module CCU_PORT (
   clk,
   rst,
   compare,
   ov,
   cocahl,
   t2cm,
   pout,
   sfrdatai,
   sfraddr,
   sfrwe
   );

   //  Declarations
   `include "utility.v"

   // Control signals inputs
   input    clk;                       // Global clock input
   input    rst;                       // Global reset input
   
   // Port inputs
   input    compare;                   //
   input    ov;                        //
   input    [1:0] cocahl;              // 
   input    t2cm;                      //
   
   // Port outputs
   output   pout;                      // port output
   reg      pout;
   
   // Special function register interface
   input    sfrdatai;                  // SFR data bus
   input    [6:0] sfraddr;             // SFR address bus
   input    sfrwe;                     // SFR write enable

   // CCU Port registers
   reg      com_set;                   //
   reg      ov_reset;                  //
   reg      sh_data_out;               //
   reg      port_oe;                   //
   reg      port_data_in;              //
   reg      mux_port_in;               //
   reg      mux_oe;                    //
   reg      oe_tmp;                    //

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : ports_write_proc
   //------------------------------------------------------------------
   //-----------------------------------
   // Synchronous reset
   //-----------------------------------
   if (rst)
      begin
      pout <= P0_RV[1] ; 
      sh_data_out <= 1'b0 ; 
      end
   else
      begin
      //------------------------------------
      // Compare mode 0 - set or reset port  
      //------------------------------------
      if (com_set)
         begin
         pout <= 1'b1 ; 
         end
      else if (ov_reset)
         begin
         pout <= 1'b0 ; 
         end
      else if (port_oe)
         begin
         pout <= port_data_in ; 
         end 
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Special function register write
      //--------------------------------
      if (sfrwe & sfraddr == P1_ID)
         begin
         sh_data_out <= sfrdatai ; 
         end 
      end  
   end 

   //------------------------------------------------------------------
   always @(sfrwe or sfraddr)
   begin : oe_comb_proc
   //------------------------------------------------------------------
   //-----------------------------------
   // Intial value
   //-----------------------------------
   oe_tmp = 1'b0 ;

   //-----------------------------------
   // Combinational value
   //-----------------------------------
   if (sfrwe & sfraddr == P1_ID)
      begin
      oe_tmp = 1'b1 ; 
      end
   else
      begin
      oe_tmp = 1'b0 ; 
      end 
   end 

   //------------------------------------------------------------------
   always @(cocahl or sh_data_out or compare or sfrdatai or oe_tmp)
   begin : mux_comb_proc
   //------------------------------------------------------------------
   //-----------------------------------
   // Intial value
   //-----------------------------------
   mux_port_in = sfrdatai ; 
   mux_oe = oe_tmp ; 
   
   //-----------------------------------
   // Combinational value
   //-----------------------------------
   case (cocahl[1:0])
   2'b10 :
      begin
      mux_port_in = sh_data_out ; 
      mux_oe = compare ; 
      end
      
   default :
      begin
      mux_port_in = sfrdatai ; 
      mux_oe = oe_tmp ; 
      end
      
   endcase 
   end 

   //------------------------------------------------------------------
   always @(cocahl or t2cm or compare or ov or mux_port_in or mux_oe)
   begin : ports_comb_proc
   //------------------------------------------------------------------
   //-----------------------------------
   // Intial value
   //-----------------------------------
   port_data_in = mux_port_in ; 
   port_oe = mux_oe ; 
   com_set = 1'b0 ; 
   ov_reset = 1'b0 ; 
   
   //-----------------------------------
   // Combinational value
   //-----------------------------------
   if (cocahl[1:0] == 2'b10 & !t2cm)
      begin
      port_data_in = 1'b0 ; 
      port_oe = 1'b0 ; 
      com_set = compare ; 
      ov_reset = ov ; 
      end
   else
      begin
      port_data_in = mux_port_in ; 
      port_oe = mux_oe ; 
      com_set = 1'b0 ; 
      ov_reset = 1'b0 ; 
      end 
   end 
   
endmodule // Module CCU_PORT

//*******************************************************************--
