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
// File name            : serial0.v
// File contents        : Module SERIAL_0
// Purpose              : Serial Unit 0
//
// Destination library  : R80515_LIB
//
// Design Engineer      : D.L. M.B.
// Quality Engineer     : M.B.
// Version              : 1.10.V05
// Last modification    : 2002-04-04
//---------------------------------------------------------------------

`timescale 1 ns / 1 ns // timescale for following modules

//*******************************************************************--
// Modifications with respect to Version 1.00.E00 :
// 1.01.E01   :
// 1999-12-17 : Added the reset of serial interface after
//            : wrong start bit received
// 1.01.E01   :
// 1999-12-23 : Rising edge detect on t1ov added  
// 1.01.E01   :
// 2000-01-03 : Mode 0 corrected
// 1.01.E01   :
// 2000-01-03 : Mode 1,2,3 reception corrected
// 1.01.E01   :
// 2000-01-06 : Removed s0buf_t, r_baud_clk r_baud_ov
//            : do not used signals
// 1.04.E04   :
// 2000-09-28 : Added rxd0_inff flip-flop on rxd0i input
// 1.04.E06   :
// 2001-05-16 : Added cycle port
// 2001-05-16 : Changed seting of ri, ti and rb80 flag
// 1.10.V05   :
// 2002-04-04 : Modified transmit_proc.
//*******************************************************************--

module SERIAL_0
   (
   clk,
   rst,
   cycle,
   rxd0i,
   t1ov,
   smod,
   ri0,
   ti0,
   rxd0o,
   txd0,
   sfrdatai,
   sfrdataser0,
   sfraddr,
   sfrwe);


   //  Declarations
   `include "utility.v"
   
   //  Control signals inputs
   input    clk;           // Global clock input
   input    rst;           // Global reset input           
   
   input    [3:0] cycle;
   
   input    rxd0i;         // Serial 0 receive data 
   input    t1ov;          // Timer 1 overflow output
   input    smod;          // Baud rate Doubler
   
   //  Serial interrupt flags
   output   ri0;           // Serial 0 receive flag
   wire     ri0;
   output   ti0;           // Serial 0 transmit flag
   wire     ti0;
   
   //  Serial outputs
   output   rxd0o;         // Serial 0 receive clock
   reg      rxd0o;
   output   txd0;          // Serial 0 transmit data
   reg      txd0;
   
   //  Special function register interface
   input    [7:0] sfrdatai; 
   output   [7:0] sfrdataser0; 
   wire     [7:0] sfrdataser0;
   input    [6:0] sfraddr; 
   input    sfrwe; 

   //------------------------------------------------------------------

   // Serial Port 0 Control register
   reg      [7:0] s0con; 
   
   // Serial Data Buffer 0
   reg      [7:0] s0buf_r; 
   
   // rxd0i input falling edge detector
   reg      rxd0_fall; 
   reg      rxd0_ff; 
   reg      rxd0_inff; 
   reg      rxd0_val; 
   reg      [2:0] rxd0_vec; 
   
   // Clock counter
   reg      [3:0] clk_count; 
   reg      clk_ov2; 
   reg      clk_ov4; 
   reg      clk_ov12; 
   
   // Serial 0 clocks
   reg      b_clk; 
   
   // Timer 1 overflow counter
   reg      t1ov_rise; 
   reg      t1ov_ff; 
   
   // Transmit baud counter
   reg      [3:0] t_baud_count; 
   reg      t_baud_ov; 
   wire     t_baud_clk;    // baud clock for transmit
   
   // Transmit shift register
   reg      [10:0] t_shift_reg; 
   wire     t_shift_clk; 
   
   // Transmit shift counter
   reg      [3:0] t_shift_count; 
   
   // Transmit control signals
   reg      t_start; 
   
   // Receive baud counter
   reg      [3:0] r_baud_count; 
   
   // Receive shift register
   
   reg      [10:0] r_shift_reg; 
   // Receive shift counter
   reg      [3:0] r_shift_count; 
   
   // Receive control signal
   reg      r_start; 
   reg      r_start_rise; 
   reg      r_start_fall; 
   reg      r_start_ff; 
   reg      ri0_fall; 
   reg      ri0_ff; 
   reg      receive; 
   reg      r_shift_temp; 
   reg      r_start_ok; 
   
   // Baud Rate Generator Reload register
   reg      [7:0] s0rell; 
   reg      [7:0] s0relh; 
   
   // Baud Rate Timer
   reg      [9:0] tim_baud; 
   
   // Baud Rate Generator control signals
   reg      baud_rate_ov; 
   reg      [7:0] adcon; 
   reg      baud_r_count; 
   wire     baud_rate_clk; 
   wire     baud_r_clk; 
   reg      baud_r2_clk; 

   //  RI and TI temporary registers      
   reg      ri_tmp;
   reg      ri_spec_tmp;
   wire     ri_spec;
   reg      ti_tmp;
   reg      ti_spec_tmp;
   wire     ti_spec;
   reg      s0con2_tmp;
   reg      s0con2_spec_tmp;
   wire     s0con2_spec;
   reg      s0con2_val;

   
   //------------------------------------------------------------------
   // Serial 0 receive flag
   //   interrupt request flag
   //   high active output
   //------------------------------------------------------------------
   assign ri0 = s0con[0] ; 
   
   //------------------------------------------------------------------
   // Serial 0 transmit flag
   //   interrupt request flag
   //   high active output
   //------------------------------------------------------------------
   assign ti0 = s0con[1] ; 

   //------------------------------------------------------------------
   // Serial 0 temporary receive flag  
   //------------------------------------------------------------------
   assign ri_spec = ri_spec_tmp | ri_tmp ; 
   
   //------------------------------------------------------------------
   // Serial 0 temporary transmit flag
   //------------------------------------------------------------------
   assign ti_spec = ti_spec_tmp | ti_tmp ; 
   
   //------------------------------------------------------------------
   // Serial 0 temporary rb80 bit
   //------------------------------------------------------------------
   assign s0con2_spec = s0con2_spec_tmp | s0con2_tmp ; 

   //------------------------------------------------------------------
   // s0con(0) and s0con(1) interrupt flip-flops 
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : spec_regs_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      ri_spec_tmp <= 1'b0 ; 
      ti_spec_tmp <= 1'b0 ; 
      s0con2_spec_tmp <= 1'b0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Rising edge detection
      //--------------------------------
      begin
      if (ri_tmp)
         begin
         ri_spec_tmp <= 1'b1 ; 
         end
      else if (cycle == 1)
         begin
         ri_spec_tmp <= 1'b0 ; 
         end 
      if (ti_tmp)
         begin
         ti_spec_tmp <= 1'b1 ; 
         end
      else if (cycle == 1)
         begin
         ti_spec_tmp <= 1'b0 ; 
         end 
      if (s0con2_tmp)
         begin
         s0con2_spec_tmp <= 1'b1 ; 
         end
      else if (cycle == 1)
         begin
         s0con2_spec_tmp <= 1'b0 ; 
         end 
      end  
   end 

   //------------------------------------------------------------------
   // Rising edge detection on the t1ov 
   // t1ov_rise is high active during single clk period
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : t1ov_rise_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      t1ov_rise <= 1'b0 ; 
      t1ov_ff <= 1'b0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Rising edge detection
      //--------------------------------
      begin
      if (t1ov & !t1ov_ff)
         begin
         t1ov_rise <= 1'b1 ; 
         end
      else
         begin
         t1ov_rise <= 1'b0 ; 
         end 
      //--------------------------------
      // t1ov_rise flip-flop
      //--------------------------------
      t1ov_ff <= t1ov ; 
      end  
   end 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : s0con_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      s0con      <= S0CON_RV ; 
      ri_tmp     <= 1'b0 ; 
      ti_tmp     <= 1'b0 ; 
      s0con2_val <= 1'b0 ; 
      s0con2_tmp <= 1'b0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Special function register write
      //--------------------------------
      begin
      case (s0con[7:6])
      //----------------------------------
      // Mode 0
      //----------------------------------
      2'b00 :
         begin
         if (clk_count == 4'b1011 &
            receive &
            r_shift_count == 4'b0001)
            begin
            ri_tmp <= 1'b1 ; 
            end
         else
            begin
            ri_tmp <= 1'b0 ; 
            end 
         end
         
      //----------------------------------
      // Modes 1, 2, 3
      //----------------------------------
      default :
         begin
         if (r_start_fall & r_start_ok)
            begin
            s0con2_val <= rxd0_val ; 
            s0con2_tmp <= 1'b1 ; 
            if (s0con[5])
               begin
               ri_tmp <= rxd0_val ; // rec. int. flag 
               end
            else
               begin
               ri_tmp <= 1'b1 ; // rec. int. flag                   
               end 
            end
         else
            begin
            ri_tmp <= 1'b0 ; 
            end 
         end
         
      endcase 
      
      if (t_shift_clk & t_shift_count == 4'b0001)
         begin
         ti_tmp <= 1'b1 ; 
         end
      else
         begin
         ti_tmp <= 1'b0 ; 
         end 
         
      if (sfrwe & sfraddr == S0CON_ID)
         begin
         s0con <= sfrdatai ; 
         end
      else
         begin
         if (ri_spec)
            begin
            s0con[0] <= 1'b1 ; 
            end 
         if (ti_spec)
            begin
            s0con[1] <= 1'b1 ; 
            end 
         if (s0con2_spec)
            begin
            s0con[2] <= s0con2_val ; 
            end 
         end 
      end  
   end 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : s0rell_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      s0rell <= S0RELL_RV ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Special function register write
      //--------------------------------
      begin
      if (sfrwe & sfraddr == S0RELL_ID)
         begin
         s0rell <= sfrdatai ; 
         end 
      end  
   end 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : s0relh_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      s0relh <= S0RELH_RV ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Special function register write
      //--------------------------------
      begin
      if (sfrwe & sfraddr == S0RELH_ID)
         begin
         s0relh <= sfrdatai ; 
         end 
      end  
   end 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : adcon_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      adcon <= ADCON_RV ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Special function register write
      //--------------------------------
      begin
      if (sfrwe & sfraddr == ADCON_ID)
         begin
         adcon <= sfrdatai ; 
         end 
      end  
   end 

   //------------------------------------------------------------------
   // Timer Baud Rate overflow
   // baud_rate_ov is high active during single clk period
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : baud_rate_overflow
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      baud_rate_ov <= 1'b0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      begin
      if (clk_ov2 & tim_baud[9:0] == 10'b1111111111)
         begin
         baud_rate_ov <= 1'b1 ; 
         end
      else
         begin
         baud_rate_ov <= 1'b0 ; 
         end 
      end  
   end 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : tim_baud_reload
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      tim_baud <= 10'b1111110011 ;  // this value is not specified
                                    // in instruction of SAB80C517   
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      begin
      if (baud_rate_ov)
         begin
         tim_baud[7:0] <= s0rell ; 
         tim_baud[9:8] <= s0relh[1:0] ; 
         end
      else if (!clk_ov2)
         begin
         tim_baud <= tim_baud + 1'b1 ; 
         end 
      end  
   end 

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
      clk_ov2 <= 1'b0 ; 
      clk_ov12 <= 1'b0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // clk counter
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
      // clk divide by 2
      //--------------------------------
      if (clk_count[0])
         begin
         clk_ov2 <= 1'b1 ; 
         end
      else
         begin
         clk_ov2 <= 1'b0 ; 
         end 
      
      //--------------------------------
      // clk divide by 4
      //--------------------------------
      if (clk_count[1:0] == 2'b11)
         begin
         clk_ov4 <= 1'b1 ; 
         end
      else
         begin
         clk_ov4 <= 1'b0 ; 
         end 
      
      //--------------------------------
      // clk divide by 12
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
   always @(s0con or smod or clk_ov2 or clk_ov4 or baud_rate_clk)
   begin : baud_clk_sel
   //------------------------------------------------------------------
   case (s0con[7:6])
   //-----------------------------------
   // Modes 1 or 3
   //-----------------------------------
   2'b01, 2'b11 :
      begin
      b_clk = baud_rate_clk ; 
      end
   
   //-----------------------------------
   // Mode 2
   //-----------------------------------
   2'b10 :
      begin
      if (smod)
         begin
         b_clk = clk_ov2 ; 
         end
      else
         begin
         b_clk = clk_ov4 ; 
         end 
      end
   
   //-----------------------------------
   // Mode 0
   //-----------------------------------
   default :
      begin
      b_clk = 1'b0 ; 
      end
   
   endcase 
   end 
   
   //------------------------------------------------------------------
   assign baud_r_clk =
      (
         (s0con[7:6] == 2'b01 | s0con[7:6] == 2'b11)
         &
         (!(adcon[7]))
      ) ? t1ov_rise :
      (
         (s0con[7:6] == 2'b01 | s0con[7:6] == 2'b11)
         &
         ((adcon[7]))
      ) ? baud_rate_ov :
      clk_ov2 ; 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : baud_div_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      baud_r_count <= 1'b0 ; 
      baud_r2_clk <= 1'b0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // baud_r_clk overflow count
      //--------------------------------
      begin
      if (baud_r_clk)
         begin
         baud_r_count <= ~(baud_r_count) ; 
         end 
         
      //--------------------------------
      // Overflow divide by 2
      //--------------------------------
      if (baud_r_clk & baud_r_count)
         begin
         baud_r2_clk <= 1'b1 ; 
         end
      else
         begin
         baud_r2_clk <= 1'b0 ; 
         end 
      end  
   end 
   
   //------------------------------------------------------------------
   assign baud_rate_clk =
      (smod) ? baud_r_clk :
      baud_r2_clk ; 
   
   //------------------------------------------------------------------
   assign t_baud_clk =
      (s0con[7:6] == 2'b00) ? clk_ov12 :  // mode=0
      t_baud_ov ;                         // mode=1,2,3
   
   //------------------------------------------------------------------
   assign t_shift_clk =
      (t_start) ? t_baud_clk :
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
      t_start <= 1'b0 ; 
      t_baud_count <= 4'b0000 ; 
      t_baud_ov <= 1'b0 ; 
      t_shift_reg <= 11'b11111111111 ; 
      t_shift_count <= 4'b0000 ; 
      txd0 <= 1'b1 ; 
      rxd0o <= 1'b1 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Transmit clk divide by 16
      //--------------------------------
      begin
      if (b_clk)
         begin
         t_baud_count <= t_baud_count + 1'b1 ; 
         end 

      if (b_clk & t_baud_count == 4'b1111)
         begin
         t_baud_ov <= 1'b1 ; 
         end
      else
         begin
         t_baud_ov <= 1'b0 ; 
         end 
         
      //--------------------------------
      // Transmit shift enable
      //--------------------------------
      
      //--------------------------------
      if (t_shift_count == 4'b0000 &
         ~(sfrwe & sfraddr == S0BUF_ID))
         begin
         t_start <= 1'b0 ; 
         end
      else if (sfrwe & sfraddr == S0BUF_ID)
         begin
         t_start <= 1'b1 ; 
         end 
         
      //--------------------------------
      // Transmit registers load
      //--------------------------------
      if (sfrwe & sfraddr == S0BUF_ID)
         begin
         case (s0con[7:6])
         //-----------------------------
         // Mode 0
         //-----------------------------
         2'b00 :
            begin
            if (clk_count == 4'b1010 | clk_count == 4'b1011)
              begin
              t_shift_reg[7:0] <= sfrdatai;
              t_shift_reg[8]   <= 1'b1;
              t_shift_count    <= 4'b1001; 
              end
            else
              begin
              t_shift_reg[8:1] <= sfrdatai;
              t_shift_reg[0]   <= 1'b1;
              t_shift_count    <= 4'b1001; 
              end
            end
         
         //-----------------------------
         // Mode 1
         //-----------------------------
         2'b01 :
            begin
            t_shift_reg[10] <= 1'b1 ; 
            t_shift_reg[9:2] <= sfrdatai ; 
            t_shift_reg[1] <= 1'b0 ; 
            t_shift_reg[0] <= 1'b1 ; 
            t_shift_count <= 4'b1010 ; 
            end
         
         //-----------------------------
         // Mode 2, 3
         //-----------------------------
         default :
            begin
            t_shift_reg[10] <= s0con[3] ; 
            t_shift_reg[9:2] <= sfrdatai ; 
            t_shift_reg[1] <= 1'b0 ; 
            t_shift_reg[0] <= 1'b1 ; 
            t_shift_count <= 4'b1011 ; 
            end
         
         endcase 
         end
      else
         //--------------------------------
         // Transmit register shift
         //--------------------------------
         begin
         if (s0con[7:6] == 2'b00)
            begin
            if (clk_count == 4'b1010)
               begin
               t_shift_reg[9:0] <= t_shift_reg[10:1] ; 
               end 
            end
         else
            begin
            if (t_shift_clk)
               begin
               t_shift_reg[9:0] <= t_shift_reg[10:1] ; 
               end 
            end 
            
         //--------------------------------
         // Transmit data count
         //--------------------------------
         if (t_shift_clk)
            begin
            t_shift_count <= t_shift_count - 1'b1 ; 
            end 
         end 
         
      //--------------------------------
      // Transmit output
      //--------------------------------
      if (t_start | r_start)
         begin
         case (s0con[7:6])
         2'b00 :  // mode 0
            begin
            if (receive | t_start)
               begin
               if (clk_count > 4'b0010 & clk_count < 4'b1001)
                  begin
                  if (~(t_shift_count == 4'b1001))
                     begin
                     txd0 <= 1'b0 ; 
                     end 
                  end
               else
                  begin
                  txd0 <= 1'b1 ; 
                  end 
               end 
            rxd0o <= t_shift_reg[0] ; 
            end
         
         default :  // mode 1,2,3
            begin
            txd0 <= t_shift_reg[0] ; 
            rxd0o <= 1'b1 ; 
            end
         
         endcase 
         end
      else
         begin
         txd0 <= 1'b1 ; 
         rxd0o <= 1'b1 ; 
         end 
      end  
   end 

   //------------------------------------------------------------------
   // Flip-flop on rxd0i input
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : rxd0_inff_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      rxd0_inff <= 1'b1 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      begin
      if (!rxd0i)
         begin
         rxd0_inff <= 1'b0 ; 
         end
      else
         begin
         rxd0_inff <= 1'b1 ; 
         end 
      end  
   end 

   //------------------------------------------------------------------
   // Falling edge detection on the external input rxd0i
   // rxd0_fall is high active during single clk period
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : rxd0_fall_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      rxd0_fall <= 1'b0 ; 
      rxd0_ff <= 1'b0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      //--------------------------------
      // Falling edge detection
      //--------------------------------
      begin
      if (!rxd0_inff & rxd0_ff)
         begin
         rxd0_fall <= 1'b1 ; 
         end
      else
         begin
         rxd0_fall <= 1'b0 ; 
         end 
      
      //--------------------------------
      // t0 input flip-flop
      //--------------------------------
      rxd0_ff <= rxd0_inff ; 
      
      end  
   end 

   //------------------------------------------------------------------
   // rxd0i input pin falling edge detector
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : rxd0_vec_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      rxd0_vec <= 3'b111 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // RXD vector write
      //--------------------------------
      begin
      if (b_clk)
         begin
         rxd0_vec <= {rxd0_vec[1:0], rxd0_inff} ; 
         end 
         
      //--------------------------------
      // rxd0i pin value
      //--------------------------------
      case (s0con[7:6])
      2'b00 :  // mode 0
         begin
         if (s0con[5])
            begin
            if (clk_count[0]) // bit 0 - osc/2
                              // bit 1 - osc/4
               begin
               rxd0_val <= rxd0_inff ; 
               end 
            end
         else
            begin
            if (clk_count[2])
               begin
               rxd0_val <= rxd0_inff ; 
               end 
            end 
         end
      
      default :  // mode 1,2,3
         begin
         if (rxd0_vec == 3'b001 |
             rxd0_vec == 3'b010 |
             rxd0_vec == 3'b100 |
             rxd0_vec == 3'b000)
            begin
            rxd0_val <= 1'b0 ; 
            end
         else
            begin
            rxd0_val <= 1'b1 ; 
            end 
         end
      
      endcase 
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
      r_start_rise <= 1'b0 ; 
      r_start_ff <= 1'b0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Falling edge detection
      //--------------------------------
      begin
      if (r_start & !r_start_ff)
         begin
         r_start_rise <= 1'b1 ; 
         end
      else
         begin
         r_start_rise <= 1'b0 ; 
         end 
      
      //--------------------------------
      // r_start flip-flop
      //--------------------------------
      r_start_ff <= r_start ; 
      
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
      r_start_fall <= 1'b0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Falling edge detection
      //--------------------------------
      begin
      if (!r_start & r_start_ff)
         begin
         r_start_fall <= 1'b1 ; 
         end
      else
         begin
         r_start_fall <= 1'b0 ; 
         end 
      end  
   end 

   //------------------------------------------------------------------
   // Falling edge detection on the ri0
   // ri0_fall is high active during single clk period
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : ri0_fall_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      ri0_fall <= 1'b0 ; 
      ri0_ff <= 1'b0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Falling edge detection
      //--------------------------------
      begin
      if (!(s0con[0]) & ri0_ff)
         begin
         ri0_fall <= 1'b1 ; 
         end
      else
         begin
         ri0_fall <= 1'b0 ; 
         end 
      
      //--------------------------------
      // t0 input flip-flop
      //--------------------------------
      ri0_ff <= s0con[0] ; 
      
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
      s0buf_r <= S0BUF_RV ; 
      r_baud_count <= 4'b0000 ; 
      receive <= 1'b0 ; 
      r_shift_reg <= 11'b11111111111 ; 
      r_shift_count <= 4'b0000 ; 
      r_start <= 1'b0 ; 
      r_start_ok <= 1'b0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // receive clk divide by 16
      //--------------------------------
      begin
      if (rxd0_fall & !r_start)
         begin
         r_baud_count <= 4'b0000 ; 
         end
      else if (b_clk)
         begin
         r_baud_count <= r_baud_count + 1'b1 ; 
         end 
      //--------------------------------
      // Receive register shift
      //--------------------------------
      case (s0con[7:6])
      //-----------------------------
      // Mode 0
      //-----------------------------
      2'b00 :
         begin
         if (receive & clk_count == 4'b1011)
            begin
            r_shift_reg[9:0] <= r_shift_reg[10:1] ; 
            r_shift_reg[10] <= r_shift_temp ; 
            r_shift_count <= r_shift_count - 1'b1 ; 
            if (r_shift_count == 4'b0001)
               begin
               r_start <= 1'b0 ; 
               receive <= 1'b0 ; 
               end 
            end
         else if (receive & clk_count == 4'b1001)
            begin
            r_shift_temp <= rxd0_inff ; 
            end 
         end
      
      //-----------------------------
      // Mode 1
      //-----------------------------
      2'b01 :
         begin
         if (r_baud_count == 4'b1001 &
             b_clk &
             r_start &
             ~(r_shift_count == 4'b0000)
             )
            begin
            r_shift_reg[9:0] <= r_shift_reg[10:1] ; 
            r_shift_reg[10] <= rxd0_val ; 
            r_shift_count <= r_shift_count - 1'b1 ; 
            if (r_shift_count == 4'b0001)
               begin
               r_start <= 1'b0 ; 
               receive <= 1'b0 ; 
               end 
            
            if (r_shift_count == 4'b1010)
               begin
               if (!rxd0_val)
                  begin
                  r_start_ok <= 1'b1 ; 
                  end
               else
                  begin
                  r_start <= 1'b0 ; 
                  receive <= 1'b0 ; 
                  r_shift_count <= 4'b0000 ; 
                  end 
               end 
            end 
            
         if (r_start_fall & r_start_ok)
            begin
            r_start_ok <= 1'b0 ; 
            end 
         
         end
      
      //-----------------------------
      // Mode 2, 3
      //-----------------------------
      default :
         begin
         if (r_baud_count == 4'b1001 &
             b_clk &
             receive &
             ~(r_shift_count == 4'b0000)
             )
            begin
            r_shift_reg[9:0] <= r_shift_reg[10:1] ; 
            r_shift_reg[10] <= rxd0_val ; 
            r_shift_count <= r_shift_count - 1'b1 ; 
            if (r_shift_count == 4'b0010)
               begin
               r_start <= 1'b0 ; 
               end 
            
            if (r_shift_count == 4'b0001)
               begin
               receive <= 1'b0 ; 
               end 
            
            if (r_shift_count == 4'b1011)
               begin
               if (!rxd0_val)
                  begin
                  r_start_ok <= 1'b1 ; 
                  end
               else
                  begin
                  r_start <= 1'b0 ; 
                  receive <= 1'b0 ; 
                  r_shift_count <= 4'b0000 ; 
                  end 
               end 
            end 
            
         if (r_start_fall & r_start_ok)
            begin
            r_start_ok <= 1'b0 ; 
            end 
         
         end
      endcase 
      
      if (clk_count == 4'b1011 & r_start)
         begin
         if (!receive)
            begin
            receive <= 1'b1 ; 
            end 
         end 
         
      //--------------------------------
      // Receive shift enable
      //--------------------------------
      if (
            (
               rxd0_fall &
               (~(s0con[7:6] == 2'b00) &
               (s0con[4]) &
               r_shift_count == 4'b0000)
            )
            |
            (
               ri0_fall &
               s0con[7:6] == 2'b00 &
               (s0con[4])
            )
         )
         begin
         r_start <= 1'b1 ; 
         end 
      
      //--------------------------------
      // Receive count load
      //--------------------------------
      // Mode 0
      //--------------------------------
      if (s0con[7:6] == 2'b00)
         begin
         if (ri0_fall & (s0con[4]))
            begin
            r_shift_count <= 4'b1000 ; 
            end 
         end
         
      //--------------------------------
      // Mode 1, 2, 3
      //--------------------------------
      else if (r_start_rise & r_shift_count == 4'b0000)
         begin
         if (s0con[7:6] == 2'b01)
            begin
            r_shift_count <= 4'b1010 ; 
            end
         else
            begin
            r_shift_count <= 4'b1011 ; 
            end 
         end 
      
      if (r_start_fall)
         begin
         if (s0con[7:6] == 2'b00)
            begin
            s0buf_r <= r_shift_reg[10:3] ; 
            end
         else
            begin
            if (r_start_ok & !(s0con[0]))
               begin
               if (s0con[5])
                  begin
                  if (r_shift_reg[10])
                     begin
                     s0buf_r <= r_shift_reg[9:2] ; 
                     end 
                  end
               else
                  begin
                  s0buf_r <= r_shift_reg[9:2] ; 
                  end 
               end 
            end 
         end 
      end  
   end 
   
   //------------------------------------------------------------------
   // Special Function registers read
   //------------------------------------------------------------------
   assign sfrdataser0 =
      (sfraddr == S0CON_ID) ? s0con :
      (sfraddr == S0BUF_ID) ? s0buf_r :
      (sfraddr == S0RELL_ID) ? s0rell :
      (sfraddr == S0RELH_ID) ? s0relh :
      adcon ;


endmodule  //  module SERIAL_0

//*******************************************************************--
