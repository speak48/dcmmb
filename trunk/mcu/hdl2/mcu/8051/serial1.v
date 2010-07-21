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
// File name            : serial1.v
// File contents        : Module SERIAL_1
// Purpose              : Serial Unit 1
//
// Destination library  : R80515_LIB
//
// Design Engineer      : D.L. M.B.
// Quality Engineer     : M.B.
// Version              : 1.10.V05
// Last modification    : 2002-01-08
//---------------------------------------------------------------------

`timescale 1 ns / 1 ns // timescale for following modules

//*******************************************************************--
// Modifications with respect to Version 1.00.E00 :
// 1.01.E01   :
// 1999-11-25 : Removed output rxd1o
// 1.01.E01   :
// 1999-12-17 : Added the reset of serial interface after
//            : wrong start bit received
// 1.01.E01   :
// 2000-01-03 : Reception corrected
// 1.01.E01   :
// 2000-01-06 : Removed s1buf_t, r1_baud_ov, ri1_ff
//            : do not used signals
// 1.04.E04   :
// 2000-09-28 : Added rxd1_inff flip-flop on rxd1i input
//*******************************************************************--
   
module SERIAL_1
   (clk,
   rst,
   rxd1i,
   txd1,
   ri1,
   ti1,
   sfrdatai,
   sfrdataser1,
   sfraddr,
   sfrwe);

   
   //  Declarations
   `include "utility.v"
   
   
   //  Control signals inputs
   input    clk;           // Global clock input
   input    rst;           // Global reset input
   
   //  Serial inputs
   input    rxd1i;         // Serial 1 receive data
   
   //  Serial outputs
   output   txd1;          // Serial 1 transmit data
   reg      txd1;
   
   //  Serial interrupt flags
   output   ri1;           // Serial 1 receive flag
   wire     ri1;
   output   ti1;           // Serial 1 transmit flag
   wire     ti1;
   
   //  Special function register interface
   input    [7:0] sfrdatai; 
   output   [7:0] sfrdataser1; 
   wire     [7:0] sfrdataser1;
   input    [6:0] sfraddr; 
   input    sfrwe; 

   //------------------------------------------------------------------

   // Serial Port 1 Control register
   reg      [7:0] s1con; 
   
   // Serial Data Buffer 1
   reg      [7:0] s1buf_r; 
   
   // rxd1i input falling edge detector
   reg      rxd1_fall; 
   reg      rxd1_ff; 
   reg      rxd1_inff; 
   reg      rxd1_val; 
   reg      [2:0] rxd1_vec; 
   
   // Clock counter
   reg      [3:0] clk1_count; 
   reg      clk1_ov2; 
   
   // Serial 1 clocks
   reg      b1_clk; 
   
   // Transmit baud counter
   reg      [3:0] t1_baud_count; 
   reg      t1_baud_ov; 
   
   // Transmit shift register
   reg      [10:0] t1_shift_reg; 
   wire     t1_shift_clk; 
   
   // Transmit shift counter
   reg      [3:0] t1_shift_count; 
   
   // Transmit control signals
   reg      t1_start; 
   
   // Receive baud counter
   reg      [3:0] r1_baud_count; 
   
   // Receive shift register
   reg      [10:0] r1_shift_reg; 
   
   // Receive shift counter
   reg      [3:0] r1_shift_count; 
   
   // Receive control signal
   reg      r1_start; 
   reg      r1_start_rise; 
   reg      r1_start_fall; 
   reg      r1_start_ff; 
   reg      receive1; 
   reg      r1_start_ok; 
   
   // Baud Rate Generator Reload register
   reg      [7:0] s1rell; 
   reg      [7:0] s1relh; 
   
   // Baud Rate Timer
   reg      [9:0] tim1_baud; 

   //------------------------------------------------------------------
   // Serial 1 receive flag
   //   interrupt request flag
   //   high active output
   //------------------------------------------------------------------
   assign ri1 = s1con[0] ; 
   
   //------------------------------------------------------------------
   // Serial 1 transmit flag
   //   interrupt request flag
   //   high active output
   //------------------------------------------------------------------
   assign ti1 = s1con[1] ; 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : s1con_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      s1con <= S1CON_RV ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Special function register write
      //--------------------------------
      begin
      if (sfrwe & sfraddr == S1CON_ID)
         begin
         s1con <= sfrdatai ; 
         end
      else
         begin
         if (t1_shift_clk & t1_shift_count == 4'b0001)
            begin
            s1con[1] <= 1'b1 ; // transmit interrupt flag              
            end 
         
         if (r1_start_fall & r1_start_ok)
            begin
            s1con[2] <= rxd1_val ; 
            if (s1con[5])
               begin
               s1con[0] <= rxd1_val ; // rec. int. flag 
               end
            else
               begin
               s1con[0] <= 1'b1 ;     // rec. int. flag                   
               end 
            end 
         
         end 
      end  
   end 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : s1rell_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      s1rell <= S1RELL_RV ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Special function register write
      //--------------------------------
      begin
      if (sfrwe & sfraddr == S1RELL_ID)
         begin
         s1rell <= sfrdatai ; 
         end 
      end  
   end 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : s1relh_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      s1relh <= S1RELH_RV ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Special function register write
      //--------------------------------
      begin
      if (sfrwe & sfraddr == S1RELH_ID)
         begin
         s1relh <= sfrdatai ; 
         end 
      end  
   end 

   //------------------------------------------------------------------
   // Timer Baud Rate overflow
   // baud_rate_ov is high active during single clk period
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : baud1_rate_overflow
   //------------------------------------------------------------------
   //-----------------------------------
   // Synchronous write
   //-----------------------------------
   if (clk1_ov2 & tim1_baud[9:0] == 10'b1111111111)
      begin
      b1_clk <= 1'b1 ; 
      end
   else
      begin
      b1_clk <= 1'b0 ; 
      end  
   end 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : tim1_baud_reload
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      tim1_baud <= 10'b1111101111 ; // this value is not specified
                                    // in instruction SAB80C517
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      begin
      if (b1_clk)
         begin
         tim1_baud[7:0] <= s1rell ; 
         tim1_baud[9:8] <= s1relh[1:0] ; 
         end
      else if (!clk1_ov2)
         begin
         tim1_baud <= tim1_baud + 1'b1 ; 
         end 
      end  
   end 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : clk1_count_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      clk1_count <= 4'b0000 ; 
      clk1_ov2 <= 1'b0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // clk counter
      //--------------------------------
      begin
      if (clk1_count == 4'b1011)
         begin
         clk1_count <= 4'b0000 ; 
         end
      else
         begin
         clk1_count <= clk1_count + 1'b1 ; 
         end 
      
      //--------------------------------
      // clk divide by 2
      //--------------------------------
      if (clk1_count[0])
         begin
         clk1_ov2 <= 1'b1 ; 
         end
      else
         begin
         clk1_ov2 <= 1'b0 ; 
         end 
      end  
   end 
   
   //------------------------------------------------------------------
   assign t1_shift_clk =
      (t1_start) ? t1_baud_ov :
      1'b0 ; 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : transmit_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      t1_start <= 1'b0 ; 
      t1_baud_count <= 4'b0000 ; 
      t1_baud_ov <= 1'b0 ; 
      t1_shift_reg <= 11'b11111111111 ; 
      t1_shift_count <= 4'b0000 ; 
      txd1 <= 1'b1 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Transmit clk divide by 16
      //--------------------------------
      begin
      if (b1_clk)
         begin
         t1_baud_count <= t1_baud_count + 1'b1 ; 
         end 
      
      if (b1_clk & t1_baud_count == 4'b1111)
         begin
         t1_baud_ov <= 1'b1 ; 
         end
      else
         begin
         t1_baud_ov <= 1'b0 ; 
         end 
      
      //--------------------------------
      // Transmit shift enable
      //--------------------------------
      if (t1_shift_count == 4'b0000 &
         ~(sfrwe & sfraddr == S1BUF_ID))
         begin
         t1_start <= 1'b0 ; 
         end
      else if (sfrwe & sfraddr == S1BUF_ID)
         begin
         t1_start <= 1'b1 ; 
         end 
      
      //--------------------------------
      // Transmit registers load
      //--------------------------------
      if (sfrwe & sfraddr == S1BUF_ID)
         begin
         case (s1con[7])
         //-------------------------------
         // Mode B
         //-------------------------------
         1'b1 :
            begin
            t1_shift_reg[10] <= 1'b1 ; 
            t1_shift_reg[9:2] <= sfrdatai ; 
            t1_shift_reg[1] <= 1'b0 ; 
            t1_shift_reg[0] <= 1'b1 ; 
            t1_shift_count <= 4'b1010 ; 
            end
         
         //-------------------------------
         // Mode A
         //-------------------------------
         default :
            begin
            t1_shift_reg[10] <= s1con[3] ; 
            t1_shift_reg[9:2] <= sfrdatai ; 
            t1_shift_reg[1] <= 1'b0 ; 
            t1_shift_reg[0] <= 1'b1 ; 
            t1_shift_count <= 4'b1011 ; 
            end
         
         endcase 
         end
      else
         //--------------------------------
         // Transmit register shift
         //--------------------------------
         begin
         if (t1_shift_clk)
            begin
            t1_shift_reg[9:0] <= t1_shift_reg[10:1] ; 
            end 
         
         //--------------------------------
         // Transmit data count
         //--------------------------------
         if (t1_shift_clk)
            begin
            t1_shift_count <= t1_shift_count - 1'b1 ; 
            end 
         end 
         
      //--------------------------------
      // Transmit output
      //--------------------------------
      if (t1_start | r1_start)
         begin
         txd1 <= t1_shift_reg[0] ; 
         end
      else
         begin
         txd1 <= 1'b1 ; 
         end 
      
      end  
   end 

   //------------------------------------------------------------------
   // Flip-flop on rxd1i input
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : rxd1_inff_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      rxd1_inff <= 1'b1 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      begin
      if (!rxd1i)
         begin
         rxd1_inff <= 1'b0 ; 
         end
      else
         begin
         rxd1_inff <= 1'b1 ; 
         end 
      end  
   end 

   //------------------------------------------------------------------
   // Falling edge detection on the external input rxd0i
   // rxd1_fall is high active during single clk period
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : rxd1_fall_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      rxd1_fall <= 1'b0 ; 
      rxd1_ff <= 1'b0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Falling edge detection
      //--------------------------------
      begin
      if (!rxd1_inff & rxd1_ff)
         begin
         rxd1_fall <= 1'b1 ; 
         end
      else
         begin
         rxd1_fall <= 1'b0 ; 
         end 
      
      //--------------------------------
      // t0 input flip-flop
      //--------------------------------
      rxd1_ff <= rxd1_inff ; 
      
      end  
   end 

   //------------------------------------------------------------------
   // rxd1i input pin falling edge detector
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : rxd1_vec_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      rxd1_vec <= 3'b111 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // RXD vector write
      //--------------------------------
      begin
      if (b1_clk)
         begin
         rxd1_vec <= {rxd1_vec[1:0], rxd1_inff} ; 
         end 
      
      //--------------------------------
      // rxd0i pin value
      //--------------------------------
      if (rxd1_vec == 3'b001 |
          rxd1_vec == 3'b010 |
          rxd1_vec == 3'b100 |
          rxd1_vec == 3'b000)
         begin
         rxd1_val <= 1'b0 ; 
         end
      else
         begin
         rxd1_val <= 1'b1 ; 
         end 
      end  
   end 

   //------------------------------------------------------------------
   // Rising edge detection on the r_start 
   // r_start_rise is high active during single clk period
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : r_start_rise_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      r1_start_rise <= 1'b0 ; 
      r1_start_ff <= 1'b0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      //--------------------------------
      // Falling edge detection
      //--------------------------------
      begin
      if (r1_start & !r1_start_ff)
         begin
         r1_start_rise <= 1'b1 ; 
         end
      else
         begin
         r1_start_rise <= 1'b0 ; 
         end 
      
      //--------------------------------
      // r_start flip-flop
      //--------------------------------
      r1_start_ff <= r1_start ; 
      
      end  
   end 

   //------------------------------------------------------------------
   // Falling edge detection on the r_start 
   // r_start_fall is high active during single clk period
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : r_start_fall_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      r1_start_fall <= 1'b0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Falling edge detection
      //--------------------------------
      begin
      if (!r1_start & r1_start_ff)
         begin
         r1_start_fall <= 1'b1 ; 
         end
      else
         begin
         r1_start_fall <= 1'b0 ; 
         end 
      end  
   end 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : receive_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      s1buf_r <= S1BUF_RV ; 
      r1_baud_count <= 4'b0000 ; 
      receive1 <= 1'b0 ; 
      r1_shift_reg <= 11'b11111111111 ; 
      r1_shift_count <= 4'b0000 ; 
      r1_start <= 1'b0 ; 
      r1_start_ok <= 1'b0 ; 
      end
   else
      begin
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Receive clk divide by 16
      //--------------------------------
      if (rxd1_fall & !r1_start)
         begin
         r1_baud_count <= 4'b0000 ; 
         end
      else if (b1_clk)
         begin
         r1_baud_count <= r1_baud_count + 1'b1 ; 
         end 
      
      //--------------------------------
      // Receive register shift
      //--------------------------------
      if (s1con[7])  //Mode A 
         begin
         if (r1_baud_count == 4'b1001 &
             b1_clk &
             r1_start &
             ~(r1_shift_count == 4'b0000))
            begin
            r1_shift_reg[9:0] <= r1_shift_reg[10:1] ; 
            r1_shift_reg[10] <= rxd1_val ; 
            r1_shift_count <= r1_shift_count - 1'b1 ; 
            if (r1_shift_count == 4'b0001)
               begin
               r1_start <= 1'b0 ; 
               receive1 <= 1'b0 ; 
               end 
            
            if (r1_shift_count == 4'b1010)
               begin
               if (!rxd1_val)
                  begin
                  r1_start_ok <= 1'b1 ; 
                  end
               else
                  begin
                  r1_start <= 1'b0 ; 
                  receive1 <= 1'b0 ; 
                  r1_shift_count <= 4'b0000 ; 
                  end 
               end 
            
            end 
            
         if (r1_start_fall & r1_start_ok)
            begin
            r1_start_ok <= 1'b0 ; 
            end 
         
         end
         
      else  //Mode B
         begin
         if (r1_baud_count == 4'b1001 &
             b1_clk &
             receive1 &
             ~(r1_shift_count == 4'b0000))
            begin
            r1_shift_reg[9:0] <= r1_shift_reg[10:1] ; 
            r1_shift_reg[10] <= rxd1_val ; 
            r1_shift_count <= r1_shift_count - 1'b1 ; 
            if (r1_shift_count == 4'b0010)
               begin
               r1_start <= 1'b0 ; 
               end 
            
            if (r1_shift_count == 4'b0001)
               begin
               receive1 <= 1'b0 ; 
               end 
            
            if (r1_shift_count == 4'b1011)
               begin
               if (!rxd1_val)
                  begin
                  r1_start_ok <= 1'b1 ; 
                  end
               else
                  begin
                  r1_start <= 1'b0 ; 
                  receive1 <= 1'b0 ; 
                  r1_shift_count <= 4'b0000 ; 
                  end 
               end 
            end 
         
         if (r1_start_fall & r1_start_ok)
            begin
               r1_start_ok <= 1'b0 ; 
            end 
         end 
         
      if (clk1_count == 4'b1011 & r1_start)
         begin
         if (!receive1)
            begin
            receive1 <= 1'b1 ; 
            end 
         end 
      
      //--------------------------------
      // Receive shift enable
      //--------------------------------
      if (rxd1_fall &
         (s1con[4]) &
         r1_shift_count == 4'b0000)
         begin
         r1_start <= 1'b1 ; 
         end 
      
      if (r1_start_rise & r1_shift_count == 4'b0000)
         begin
         //--------------------------------
         // Receive count load
         //--------------------------------
         if ((s1con[7]))
            begin
            r1_shift_count <= 4'b1010 ; 
            end
         else
            begin
            r1_shift_count <= 4'b1011 ; 
            end 
         end 
   
      if (r1_start_fall)
         begin
         if (r1_start_ok & !(s1con[0]))
            begin
            if (s1con[5])
               begin
               if (r1_shift_reg[10])
                  begin
                  s1buf_r <= r1_shift_reg[9:2] ; 
                  end 
               end
            else
               begin
               s1buf_r <= r1_shift_reg[9:2] ; 
               end 
            end 
         end 
      end  
   end 
   //------------------------------------------------------------------
   // Special Function registers read
   //------------------------------------------------------------------
   assign sfrdataser1 =
      (sfraddr == S1CON_ID) ? s1con :
      (sfraddr == S1BUF_ID) ? s1buf_r :
      (sfraddr == S1RELL_ID) ? s1rell :
      (sfraddr == S1RELH_ID) ? s1relh :
      "--------" ; 


endmodule  //  module SERIAL_1

//*******************************************************************--
