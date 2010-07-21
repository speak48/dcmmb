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
// File name            : mdu.v
// File contents        : Module MDU
// Purpose              : Multiplication Division Unit
//
// Destination library  : R80515_LIB
//
// Design Engineer      : D.K. M.B.
// Quality Engineer     : M.B.
// Version              : 1.10.V05
// Last modification    : 2002-01-08
//---------------------------------------------------------------------

`timescale 1 ns / 1 ns // timescale for following modules

//*******************************************************************--
// Modifications with respect to Version 1.01.E00 :
// 1.01.E01   :
// 1999-11-25 : Removed not used ST15 from FSM_TYPE
// 1.04.E00   :
// 2000-04-10 : The arcon_write_proc: arcon(4 downto 0) counts number
//            : of shifts in modes SHL, SHR
// 1.04.E02   :
// 2000-06-23 : Removed "when MDU_DIV16" condition in md4_write_proc
// 1.04.E03   : 
// 2000-09-04 : oper_sync_proc:, oper_comb_proc:, lmdx_comb_proc: 
//            : modified
//*******************************************************************--

module MDU
   (
   clk,
   rst,
   sfrdatai,
   sfrdatamdu,
   sfraddr,
   sfrwe,
   sfroe
   );

   
   // Declarations
   `include "utility.v"


   //  Control signals inputs
   input       clk;        // Global clock input
   input       rst;        // Global reset input   
   
   //  Special function register interface
   input       [7:0] sfrdatai; 
   output      [7:0] sfrdatamdu; 
   wire        [7:0] sfrdatamdu;
   input       [6:0] sfraddr; 
   input       sfrwe; 
   input       sfroe; 

   
   //---------------------------------------------------------------
   // FSM states enumeration type
   //---------------------------------------------------------------
   parameter   [3:0] ST14 = 0; 
   parameter   [3:0] ST13 = 1; 
   parameter   [3:0] ST12 = 2; 
   parameter   [3:0] ST11 = 3; 
   parameter   [3:0] ST10 = 4; 
   parameter   [3:0] ST9 = 5; 
   parameter   [3:0] ST8 = 6; 
   parameter   [3:0] ST7 = 7; 
   parameter   [3:0] ST6 = 8; 
   parameter   [3:0] ST5 = 9; 
   parameter   [3:0] ST4 = 10; 
   parameter   [3:0] ST3 = 11; 
   parameter   [3:0] ST2 = 12; 
   parameter   [3:0] ST1 = 13; 
   parameter   [3:0] ST0 = 14; 
   
   //---------------------------------------------------------------
   // Operation select enumeration type
   //---------------------------------------------------------------
   parameter   [3:0] MUL = 0; 
   parameter   [3:0] DIV32 = 1; 
   parameter   [3:0] LDRES = 2; 
   parameter   [3:0] DIV16 = 3; 
   parameter   [3:0] SHR = 4; 
   parameter   [3:0] SHL = 5; 
   parameter   [3:0] NORM = 6; 
   parameter   [3:0] NOP_ = 7; 
   parameter   [3:0] MD32RST = 8; 
   
   //---------------------------------------------------------------
   // MDU operation select enumeration type
   //---------------------------------------------------------------
   parameter   [2:0] MDU_RST = 0; 
   parameter   [2:0] MDU_MUL = 1; 
   parameter   [2:0] MDU_DIV16 = 2; 
   parameter   [2:0] MDU_DIV32 = 3; 
   parameter   [2:0] MDU_SHIFT = 4; 
   parameter   [2:0] MDU_NOP = 5; 
   
   //---------------------------------------------------------------
   // Special Function Registers
   //---------------------------------------------------------------
   // Arithmetic Control Register
   reg         [7:0] arcon; 
   
   // Multiplication/Division Registers
   reg         [7:0] md0; 
   reg         [7:0] md1; 
   reg         [7:0] md2; 
   reg         [7:0] md3; 
   reg         [7:0] md4; 
   reg         [7:0] md5; 
   
   //---------------------------------------------------------------
   // Utility registers
   //---------------------------------------------------------------
   reg         [15:0] norm_reg; 
   reg         [4:0] counter_st; 
   reg         [4:0] counter_nxt; 
   
   // Combinational adder
   reg         [17:0] sum; 
   reg         [17:0] sum1; 
   
   // FSM registers and signals
   reg         [3:0] lmdx_reg;   // load mdx register sequence detect
   reg         [3:0] lmdx_nxt; 
   reg         [3:0] oper_reg;   // arithmetic operation FSM
   reg         [3:0] oper_nxt; 
   
   // Control signals
   reg         [3:0] md30_sel;   // md3 ... md0 mux addr
   reg         [1:0] counter_sel;//count select
   reg ld_sc;                    // load sc (in arcon register)
   reg         [2:0] mdu_op;     // mdu operation
   reg opend;                    // mdu operation end
   reg setmdef;                  // set mdef flag
   reg setmdov;                  // set mdov flag

   //------------------------------------------------------------------
   // SFR arcon register write
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : arcon_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      arcon <= ARCON_RV ; 
      end
   else
      begin
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Special function register write
      //--------------------------------
      if (sfrwe & sfraddr == ARCON_ID) // arcon(7 downto 6) is read only
         begin
         arcon[5:0] <= sfrdatai[5:0] ; 
         end
      else
         begin
         //--------------------------------
         // load sc
         //--------------------------------
         if (ld_sc)
            begin
            arcon[4:0] <= ~(counter_st - 1'b1) ; 
            end
         else if (oper_reg == ST5 | oper_reg == ST6)
            begin
            arcon[4:0] <= counter_nxt ; 
            end 
         end 
         
      if (sfroe & (sfraddr == ARCON_ID))
         begin
         arcon[7] <= 1'b0 ; 
         end
      else
         begin
         //--------------------------------
         // mdef flag
         //--------------------------------
         if (setmdef)
            begin
            arcon[7] <= 1'b1 ; 
            end 
         end 
         
      if (sfrwe & sfraddr == MD0_ID)
         begin
         arcon[6] <= 1'b0 ; 
         end
      else
         begin
         //--------------------------------
         // mdov flag
         //--------------------------------
         if (setmdov)
            begin
            arcon[6] <= 1'b1 ; 
            end 
         end 
      end  
   end 

   //------------------------------------------------------------------
   // SFR md0 register write
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : md0_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      md0 <= MD0_RV ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Special function register write
      //--------------------------------
      begin
      if (sfrwe & sfraddr == MD0_ID)
         begin
         md0 <= sfrdatai ; 
         end
      else
         begin
         case (md30_sel)
         SHL :
            begin
            if (counter_st[4] | counter_st[3] |
                counter_st[2] | counter_st[1])
               begin
               md0 <= {md0[5:0], 2'b00} ; 
               end
            else
               begin
               md0 <= {md0[6:0], 1'b0} ; 
               end 
            end
         
         SHR :
            begin
            if (counter_st[4] | counter_st[3] |
                counter_st[2] | counter_st[1])
               begin
               md0 <= {md1[1:0], md0[7:2]} ; 
               end
            else
               begin
               md0 <= {md1[0], md0[7:1]} ; 
               end 
            end
         
         NORM :
            begin
            if (md3[6])
               begin
               md0 <= {md0[6:0], 1'b0} ; 
               end
            else
               begin
               md0 <= {md0[5:0], 2'b00} ; 
               end 
            end
         
         DIV32, DIV16, LDRES :
            begin
            md0 <= {md0[5:0], sum1[17], sum[17]} ; 
            end
         
         MUL :
            begin
            md0 <= {md1[1:0], md0[7:2]} ; 
            end
         
         endcase 
         end 
      end  
   end 

   //------------------------------------------------------------------
   // SFR md1 register write
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : md1_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      md1 <= MD1_RV ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Special function register write
      //--------------------------------
      begin
      if (sfrwe & sfraddr == MD1_ID)
         begin
         md1 <= sfrdatai ; 
         end
      else
         begin
         case (md30_sel)
         SHL :
            begin
            if (counter_st[4] | counter_st[3] |
                counter_st[2] | counter_st[1])
               begin
               md1 <= {md1[5:0], md0[7:6]} ; 
               end
            else
               begin
               md1 <= {md1[6:0], md0[7]} ; 
               end 
            end
         
         SHR :
            begin
            if (counter_st[4] | counter_st[3] |
                 counter_st[2] | counter_st[1])
               begin
               md1 <= {md2[1:0], md1[7:2]} ; 
               end
            else
               begin
               md1 <= {md2[0], md1[7:1]} ; 
               end 
            end
         
         NORM :
            begin
            if (md3[6])
               begin
               md1 <= {md1[6:0], md0[7]} ; 
               end
            else
               begin
               md1 <= {md1[5:0], md0[7:6]} ; 
               end 
            end
         
         DIV32, DIV16, LDRES :
            begin
            md1 <= {md1[5:0], md0[7:6]} ; 
            end
         
         MUL :
            begin
            md1 <= {sum[1], sum1[1], md1[7:2]} ; 
            end
         
         endcase 
         end 
      end  
   end 

   //------------------------------------------------------------------
   // SFR md2 register write
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : md2_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      md2 <= MD2_RV ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Special function register write
      //--------------------------------
      begin
      if (sfrwe & sfraddr == MD2_ID)
         begin
         md2 <= sfrdatai ; 
         end
      else
         begin
         case (md30_sel)
         SHL :
            begin
            if (counter_st[4] | counter_st[3] |
                counter_st[2] | counter_st[1])
               begin
               md2 <= {md2[5:0], md1[7:6]} ; 
               end
            else
               begin
               md2 <= {md2[6:0], md1[7]} ; 
               end 
            end
         
         SHR :
            begin
            if (counter_st[4] | counter_st[3] |
                counter_st[2] | counter_st[1])
               begin
               md2 <= {md3[1:0], md2[7:2]} ; 
               end
            else
               begin
               md2 <= {md3[0], md2[7:1]} ; 
               end 
            end
         
         NORM :
            begin
            if (md3[6])
               begin
               md2 <= {md2[6:0], md1[7]} ; 
               end
            else
               begin
               md2 <= {md2[5:0], md1[7:6]} ; 
               end 
            end
         
         DIV32, LDRES :
            begin
            md2 <= {md2[5:0], md1[7:6]} ; 
            end
         
         MUL :
            begin
            md2 <= sum[9:2] ; 
            end
         
         MD32RST :
            begin
            md2 <= 8'b00000000 ; 
            end
         
         endcase 
         end 
      end  
   end 

   //------------------------------------------------------------------
   // SFR md3 register write
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : md3_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      md3 <= MD3_RV ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Special function register write
      //--------------------------------
      begin
      if (sfrwe & sfraddr == MD3_ID)
         begin
         md3 <= sfrdatai ; 
         end
      else
         begin
         case (md30_sel)
         SHL :
            begin
            if (counter_st[4] | counter_st[3] |
                counter_st[2] | counter_st[1])
               begin
               md3 <= {md3[5:0], md2[7:6]} ; 
               end
            else
               begin
               md3 <= {md3[6:0], md2[7]} ; 
               end 
            end
         
         SHR :
            begin
            if (counter_st[4] | counter_st[3] |
                counter_st[2] | counter_st[1])
               begin
               md3 <= {2'b00, md3[7:2]} ; 
               end
            else
               begin
               md3 <= {1'b0, md3[7:1]} ; 
               end 
            end
         
         NORM :
            begin
            if (md3[6])
               begin
               md3 <= {md3[6:0], md2[7]} ; 
               end
            else
               begin
               md3 <= {md3[5:0], md2[7:6]} ; 
               end 
            end
         
         DIV32, LDRES :
            begin
            md3 <= {md3[5:0], md2[7:6]} ; 
            end
         
         MUL :
            begin
            md3 <= sum[17:10] ; 
            end
         
         MD32RST :
            begin
            md3 <= 8'b00000000 ; 
            end
         
         endcase 
         end 
      end  
   end 

   //------------------------------------------------------------------
   // SFR md4 register write
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : md4_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      md4 <= MD4_RV ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Special function register write
      //--------------------------------
      begin
      if (sfrwe & sfraddr == MD4_ID)
         begin
         md4 <= sfrdatai ; 
         end
      else
         begin
         case (md30_sel)
         LDRES :
            begin
            case (mdu_op)
               MDU_DIV32 :
                  begin
                  if (sum[17])
                     begin
                     md4 <= sum[8:1] ; 
                     end
                  else
                     begin
                     if (sum1[17])
                        begin
                        md4 <= {sum1[7:1], md3[6]} ; 
                        end
                     else
                        begin
                        md4 <= {norm_reg         [5:0], md3[7:6]} ; 
                        end 
                     end 
                  end
               
               default : // MDU_DIV16
                  begin
                  if (sum[17])
                     begin
                     md4 <= sum[8:1] ; 
                     end
                  else
                     begin
                     if (sum1[17])
                        begin
                        md4 <= {sum1[7:1], md1[6]} ; 
                        end
                     else
                        begin
                        md4 <= {norm_reg         [5:0], md1[7:6]} ; 
                        end 
                     end 
                  end
                  
            endcase 
            end
            
         endcase 
         end 
      end  
   end 

   //------------------------------------------------------------------
   // SFR md5 register write
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : md5_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      md5 <= MD5_RV ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Special function register write
      //--------------------------------
      begin
      if (sfrwe & sfraddr == MD5_ID)
         begin
         md5 <= sfrdatai ; 
         end
      else
         begin
         case (md30_sel)
         LDRES :
            begin
            if (sum[17])
               begin
               md5 <= sum[16:9] ; 
               end
            else
               begin
               if (sum1[17])
                  begin
                  md5 <= sum1[15:8] ; 
                  end
               else
                  begin
                  md5 <= norm_reg[13:6] ; 
                  end 
               end 
            end
         
         endcase 
         end 
      end  
   end 

   //------------------------------------------------------------------
   // norm_reg register
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : norm_reg_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      norm_reg <= 16'b0000000000000000 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      begin
      case (md30_sel)
      DIV32 :
         begin
         if (sum[17])
            begin
            norm_reg <= sum[16:1] ; 
            end
         else
            begin
            if (sum1[17])
               begin
               norm_reg <= {sum1[15:1], md3[6]} ; 
               end
            else
               begin
               norm_reg <= {norm_reg[13:0], md3[7:6]} ; 
               end 
            end 
         end
      
      DIV16 :
         begin
         if (sum[17])
            begin
            norm_reg <= sum[16:1] ; 
            end
         else
            begin
            if (sum1[17])
               begin
               norm_reg <= {sum1[15:1], md1[6]} ; 
               end
            else
               begin
               norm_reg <= {norm_reg[13:0], md1[7:6]} ; 
               end 
            end 
         end
      
      default :
         begin
         norm_reg <= 16'b0000000000000000 ; 
         end
      
      endcase 
      end  
   end 

   //------------------------------------------------------------------
   // counter
   //------------------------------------------------------------------
   always @(counter_sel or counter_st or arcon or md3 or md30_sel)
   begin : counter_comb_proc
   //------------------------------------------------------------------
   case (counter_sel)
   2'b11 :   //dec
      begin
      case (md30_sel)
      DIV16, DIV32, MUL :
         begin
         counter_nxt = counter_st - 2'b10 ; 
         end
      
      SHR :
         begin
         if (
               counter_st[4] |
               counter_st[3] |
               counter_st[2] |
               counter_st[1]
            )
            begin
            counter_nxt = counter_st - 2'b10 ; 
            end
         else
            begin
            counter_nxt = counter_st - 1'b1 ; 
            end 
         end
      
      SHL :
         begin
         if (
               counter_st[4] |
               counter_st[3] |
               counter_st[2] |
               counter_st[1]
            )
            begin
            counter_nxt = counter_st - 2'b10 ; 
            end
         else
            begin
            counter_nxt = counter_st - 1'b1 ; 
            end 
         end
      
      default :
         begin
         if (md3[6])
            begin
            counter_nxt = counter_st - 1'b1 ; 
            end
         else
            begin
            counter_nxt = counter_st - 2'b10 ; 
            end 
         end
      
      endcase 
      end
   
   2'b01 :   //load
      begin
      counter_nxt = arcon[4:0] ; 
      end
   
   default : // reset
      begin
      counter_nxt = 5'b00000 ; 
      end
   
   endcase 
   end 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : counter_sync_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      counter_st <= 5'b00000 ; 
      end
   else
      begin
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      counter_st <= counter_nxt ; 
      end  
   end 

   //------------------------------------------------------------------
   // adder
   //------------------------------------------------------------------
   always @(md0 or md1 or md2 or md3 or md4 or md5 or mdu_op or
      norm_reg)
   begin : sum1_comb_proc
   //------------------------------------------------------------------
   reg         [17:0] arg_a; 
   reg         [17:0] arg_b; 
   //-------------------------------
   //           arg_a             --
   //-------------------------------
   case (mdu_op)
   MDU_DIV16 :
      begin
      arg_a = {norm_reg, md1[7], 1'b1}; 
      end
   
   MDU_DIV32 :
      begin
      arg_a = {norm_reg, md3[7], 1'b1}; 
      end
   
   default :
      begin
      arg_a = {1'b0, md3, md2, 1'b0}; 
      end
   
   endcase 
      
   //-------------------------------
   //           arg_b             --
   //-------------------------------
   case (mdu_op)
   MDU_MUL :
      begin
      if (md0[0])
         begin
         arg_b = {1'b0, md5, md4, 1'b0}; 
         end
      else
         begin
         arg_b = {18{1'b0}}; 
         end 
      end
   
   default :
      begin
      arg_b = {1'b0, ~md5, ~md4, 1'b1}; 
      end
   
   endcase 
   
   sum1 = arg_a + arg_b ; 
   
   end 

   //------------------------------------------------------------------
   always @(md0 or md1 or md3 or md4 or md5 or mdu_op or norm_reg or
      sum1)
   begin : sum_comb_proc
   //------------------------------------------------------------------
   reg         [17:0] arg_c; 
   reg         [17:0] arg_d; 
   //-------------------------------
   //           arg_c             --
   //-------------------------------
   case (mdu_op)
   MDU_DIV16 :
      begin
      if (sum1[17])  //CY=1
         begin
         arg_c = {sum1[16:1], md1[6], 1'b1}; 
         end
      else
         begin
         arg_c = {norm_reg [14:0], md1[7:6], 1'b1}; 
         end 
      end
   
   MDU_DIV32 :
      begin
      if (sum1[17])  //CY=1
         begin
         arg_c = {sum1[16:1], md3[6], 1'b1}; 
         end
      else
         begin
         arg_c = {norm_reg [14:0], md3[7:6], 1'b1}; 
         end 
      end
   
   default :
      begin
      arg_c = {1'b0, sum1[17:2], 1'b0}; 
      end
   
   endcase 
      
   //-------------------------------
   //           arg_d             --
   //-------------------------------
   case (mdu_op)
   MDU_MUL :
      begin
      if (md0[1])
         begin
         arg_d = {1'b0, md5, md4, 1'b0}; 
         end
      else
         begin
         arg_d = {18{1'b0}}; 
         end 
      end
   
   default :
      begin
      arg_d = {1'b0, ~md5, ~md4, 1'b1}; 
      end
   
   endcase 
   
   sum = arg_c + arg_d ; 
   
   end 

   //------------------------------------------------------------------
   // load mdx FSM
   //------------------------------------------------------------------
   always @(lmdx_reg or sfrwe or sfraddr or opend or sfroe)
   begin : lmdx_comb_proc
   //------------------------------------------------------------------
   case (lmdx_reg)
   ST0 :
      begin
      mdu_op = MDU_NOP ; 
      setmdef = 1'b0 ; 
      if (sfrwe)
         begin
         case (sfraddr)
         MD0_ID :
            begin
            lmdx_nxt = ST1 ; 
            end
         
         ARCON_ID :
            begin
            lmdx_nxt = ST7 ; 
            end
         
         default :
            begin
            lmdx_nxt = ST0 ; 
            end
         
         endcase 
         end
      else
         begin
         lmdx_nxt = ST0 ; 
         end 
      end
   
   ST1 :
      begin
      mdu_op = MDU_RST ; 
      setmdef = 1'b0 ; 
      if (sfrwe)
         begin
         case (sfraddr)
         MD0_ID :
            begin
            lmdx_nxt = ST13 ; 
            end
         
         MD1_ID :
            begin
            lmdx_nxt = ST2 ; 
            end
         
         MD4_ID :
            begin
            lmdx_nxt = ST10 ; 
            end
         
         ARCON_ID :
            begin
            lmdx_nxt = ST7 ; 
            end
         
         default :
            begin
            lmdx_nxt = ST1 ; 
            end
         
         endcase 
         end
      else
         begin
         lmdx_nxt = ST1 ; 
         end 
      end
   
   ST2 :
      begin
         mdu_op = MDU_NOP ; 
         setmdef = 1'b0 ; 
         if (sfrwe)
         begin
            case (sfraddr)
            MD0_ID :
               begin
               lmdx_nxt = ST13 ; 
               end
            
            MD2_ID :
               begin
               lmdx_nxt = ST3 ; 
               end
            
            MD4_ID :
               begin
               lmdx_nxt = ST8 ; 
               end
            
            ARCON_ID :
               begin
               lmdx_nxt = ST7 ; 
               end
            
            default :
               begin
               lmdx_nxt = ST2 ; 
               end
            
            endcase 
         end
      else
         begin
         lmdx_nxt = ST2 ; 
         end 
      end
   
   ST3 :
      begin
      mdu_op = MDU_NOP ; 
      setmdef = 1'b0 ; 
      if (sfrwe)
         begin
         case (sfraddr)
         MD0_ID :
            begin
            lmdx_nxt = ST13 ; 
            end
         MD3_ID :
            begin
            lmdx_nxt = ST4 ; 
            end
         
         ARCON_ID :
            begin
            lmdx_nxt = ST7 ; 
            end
         
         default :
            begin
            lmdx_nxt = ST3 ; 
            end
         endcase 
         end
      else
         begin
         lmdx_nxt = ST3 ; 
         end 
      end
   
   ST4 :
      begin
      mdu_op = MDU_NOP ; 
      setmdef = 1'b0 ; 
      if (sfrwe)
         begin
         case (sfraddr)
         MD0_ID :
            begin
            lmdx_nxt = ST13 ; 
            end
         
         MD4_ID :
            begin
            lmdx_nxt = ST5 ; 
            end
         
         ARCON_ID :
            begin
            lmdx_nxt = ST7 ; 
            end
         
         default :
            begin
            lmdx_nxt = ST4 ; 
            end
         
         endcase 
         end
      else
         begin
         lmdx_nxt = ST4 ; 
         end 
      end
   
   ST5 :
      begin
      mdu_op = MDU_NOP ; 
      setmdef = 1'b0 ; 
      if (sfrwe)
         begin
         case (sfraddr)
         MD0_ID :
            begin
            lmdx_nxt = ST13 ; 
            end
         
         MD5_ID :
            begin
            lmdx_nxt = ST6 ; 
            end
         
         ARCON_ID :
            begin
            lmdx_nxt = ST7 ; 
            end
         
         default :
            begin
            lmdx_nxt = ST5 ; 
            end
         endcase 
         end
      else
         begin
         lmdx_nxt = ST5 ; 
         end 
      end
   
   ST6 :
      begin
      mdu_op = MDU_DIV32 ; 
      setmdef = 1'b0 ; 
      if (sfrwe)
         begin
         case (sfraddr)
         MD0_ID :
            begin
            lmdx_nxt = ST13 ; 
            end
         
         MD1_ID, MD2_ID, MD3_ID,
         MD4_ID, MD5_ID :
            begin
            lmdx_nxt = ST14 ; 
            end
         
         default :
            begin
            lmdx_nxt = ST6 ; 
            end
         endcase 
         end
      else
         begin
         if (opend & sfraddr == MD5_ID & sfroe)
            begin
            lmdx_nxt = ST0 ; 
            end
         else
            begin
            lmdx_nxt = ST6 ; 
            end 
         end 
      end
   ST7 :
      begin
      mdu_op = MDU_SHIFT ; 
      setmdef = 1'b0 ; 
      if (sfrwe)
         begin
         case (sfraddr)
         MD0_ID :
            begin
            lmdx_nxt = ST13 ; 
            end
         
         MD1_ID, MD2_ID, MD3_ID,
         MD4_ID, MD5_ID :
            begin
            lmdx_nxt = ST14 ; 
            end
         
         default :
            begin
            lmdx_nxt = ST7 ; 
            end
         
         endcase 
         end
      else
         begin
         if (opend & sfraddr == MD3_ID & sfroe)
            begin
            lmdx_nxt = ST0 ; 
            end
         else
            begin
            lmdx_nxt = ST7 ; 
            end 
         end 
      end
   
   ST8 :
      begin
      mdu_op = MDU_NOP ; 
      setmdef = 1'b0 ; 
      if (sfrwe)
         begin
         case (sfraddr)
         MD0_ID :
            begin
            lmdx_nxt = ST13 ; 
            end
         
         MD5_ID :
            begin
            lmdx_nxt = ST9 ; 
            end
         
         ARCON_ID :
            begin
            lmdx_nxt = ST7 ; 
            end
         
         default :
            begin
            lmdx_nxt = ST8 ; 
            end
         
         endcase 
         end
      else
         begin
         lmdx_nxt = ST8 ; 
         end 
      end
   
   ST9 :
      begin
      mdu_op = MDU_DIV16 ; 
      setmdef = 1'b0 ; 
      if (sfrwe)
         begin
         case (sfraddr)
         MD0_ID :
            begin
            lmdx_nxt = ST13 ; 
            end
         MD1_ID, MD2_ID, MD3_ID,
         MD4_ID, MD5_ID :
            begin
            lmdx_nxt = ST14 ; 
            end
         default :
            begin
            lmdx_nxt = ST9 ; 
            end
         endcase 
         end
      else
         begin
         if (opend & sfraddr == MD5_ID & sfroe)
            begin
            lmdx_nxt = ST0 ; 
            end
         else
            begin
            lmdx_nxt = ST9 ; 
            end 
         end 
      end
   
   ST10 :
      begin
      mdu_op = MDU_NOP ; 
      setmdef = 1'b0 ; 
      if (sfrwe)
         begin
         case (sfraddr)
         MD0_ID :
            begin
            lmdx_nxt = ST13 ; 
            end
         
         MD1_ID :
            begin
            lmdx_nxt = ST11 ; 
            end
         
         ARCON_ID :
            begin
            lmdx_nxt = ST7 ; 
            end
         
         default :
            begin
            lmdx_nxt = ST10 ; 
            end
         
         endcase 
         end
      else
         begin
         lmdx_nxt = ST10 ; 
         end 
      end
   
   ST11 :
      begin
      mdu_op = MDU_NOP ; 
      setmdef = 1'b0 ; 
      if (sfrwe)
         begin
         case (sfraddr)
         MD0_ID :
            begin
            lmdx_nxt = ST13 ; 
            end
         
         MD5_ID :
            begin
            lmdx_nxt = ST12 ; 
            end
         
         ARCON_ID :
            begin
            lmdx_nxt = ST7 ; 
            end
         
         default :
            begin
            lmdx_nxt = ST11 ; 
            end
         
         endcase 
         end
      else
         begin
         lmdx_nxt = ST11 ; 
         end 
      end
   
   ST12 :
      begin
      mdu_op = MDU_MUL ; 
      setmdef = 1'b0 ; 
      if (sfrwe)
         begin
         case (sfraddr)
         MD0_ID :
            begin
            lmdx_nxt = ST13 ; 
            end
         MD1_ID, MD2_ID, MD3_ID,
         MD4_ID, MD5_ID :
            begin
            lmdx_nxt = ST14 ; 
            end
         default :
            begin
            lmdx_nxt = ST12 ; 
            end
         endcase 
         end
      else
         begin
         if (opend & sfraddr == MD3_ID & sfroe)
            begin
            lmdx_nxt = ST0 ; 
            end
         else
            begin
            lmdx_nxt = ST12 ; 
            end 
         end 
      end
   
   ST13 :
      begin
      mdu_op = MDU_RST ; 
      setmdef = 1'b1 ; 
      lmdx_nxt = ST1 ; 
      end
   
   default : // ST14
      begin
      mdu_op = MDU_RST ; 
      setmdef = 1'b1 ; 
      lmdx_nxt = ST0 ; 
      end
   
   endcase 
   end 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : lmdx_sync_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      lmdx_reg <= ST0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      begin
         lmdx_reg <= lmdx_nxt ; 
      end  
   end 

   //------------------------------------------------------------------
   // arithmetic operation FSM 
   //------------------------------------------------------------------
   always @(oper_reg or md2 or md3 or md4 or md5 or counter_st or
      mdu_op or arcon)
   begin : oper_comb_proc
   //------------------------------------------------------------------
   case (oper_reg)
   ST1 :
      begin
      md30_sel = NOP_ ; 
      counter_sel = 2'b01 ;  //load(count<-sc)
      ld_sc = 1'b0 ;         //nop
      opend = 1'b0 ;         //operation end
      setmdov = 1'b0 ;       //set mdov flag
      if (arcon[4:0] == 5'b00000)
         begin
         if (md3[7])
            begin
            oper_nxt = ST8 ; 
            end
         else
            begin
            oper_nxt = ST7 ; 
            end 
         end
      else
         begin
         if (arcon[5])
            begin
            oper_nxt = ST5 ; 
            end
         else
            begin
            oper_nxt = ST6 ; 
            end 
         end 
      end
   
   ST2 :
      begin
      md30_sel = MUL ; 
      counter_sel = 2'b11 ;  //dec
      ld_sc = 1'b0 ;         //nop
      opend = 1'b0 ;         //operation end
      setmdov = 1'b0 ;       //set mdov flag
      if (counter_st == 5'b10010)
         begin
         oper_nxt = ST9 ; 
         end
      else
         begin
         oper_nxt = ST2 ; 
         end 
      end
   
   ST3 :
      begin
      md30_sel = DIV16 ; 
      counter_sel = 2'b11 ;  //dec
      ld_sc = 1'b0 ;         //nop
      opend = 1'b0 ;         //operation end
      setmdov = 1'b0 ;       //set mdov flag
      if (counter_st == 5'b10100)
         begin
         oper_nxt = ST10 ; 
         end
      else
         begin
         oper_nxt = ST3 ; 
         end 
      end
   
   ST4 :
      begin
      md30_sel = DIV32 ; 
      counter_sel = 2'b11 ;  //dec
      ld_sc = 1'b0 ;         //nop
      opend = 1'b0 ;         //operation end
      setmdov = 1'b0 ;       //set mdov flag
      if (counter_st == 5'b00100)
         begin
         oper_nxt = ST10 ; 
         end
      else
         begin
         oper_nxt = ST4 ; 
         end 
      end
   
   ST5 :
      begin
      md30_sel = SHR ; 
      counter_sel = 2'b11 ;  //dec
      ld_sc = 1'b0 ;         //nop
      opend = 1'b0 ;         //operation end
      setmdov = 1'b0 ;       //set mdov flag
      if (counter_st == 5'b00001 |
         counter_st == 5'b00010 |
         counter_st == 5'b00000)
         begin
         oper_nxt = ST0 ; 
         end
      else
         begin
         oper_nxt = ST5 ; 
         end 
      end
   
   ST6 :
      begin
      md30_sel = SHL ; 
      counter_sel = 2'b11 ;  //dec
      ld_sc = 1'b0 ;         //nop
      opend = 1'b0 ;         //operation end
      setmdov = 1'b0 ;       //set mdov flag
      if (counter_st == 5'b00001 |
         counter_st == 5'b00010 |
         counter_st == 5'b00000)
         begin
         oper_nxt = ST0 ; 
         end
      else
         begin
         oper_nxt = ST6 ; 
         end 
      end
   
   ST7 :
      begin
      md30_sel = NORM ; 
      counter_sel = 2'b11 ;  //dec
      ld_sc = 1'b0 ;         //nop
      opend = 1'b0 ;         //operation end
      setmdov = 1'b0 ;       //set mdov flag
      if ((md3[6]) | (md3[5]) | counter_st == 5'b00010)
         begin
         oper_nxt = ST11 ; 
         end
      else
         begin
         oper_nxt = ST7 ; 
         end 
      end
   
   ST8 :
      begin
      md30_sel = NOP_ ; 
      counter_sel = 2'b10 ;  //reset
      ld_sc = 1'b0 ;         //nop
      opend = 1'b0 ;         //operation end
      setmdov = 1'b1 ;       //set mdov flag
      oper_nxt = ST0 ; 
      end
   
   ST9 :
      begin
      md30_sel = NOP_ ; 
      counter_sel = 2'b10 ;  //reset
      ld_sc = 1'b0 ;         //nop
      opend = 1'b0 ;         //operation end
      setmdov = (md3[7] | md3[6] | md3[5] | md3[4] |
                  md3[3] | md3[2] | md3[1] | md3[0] |
                  md2[7] | md2[6] | md2[5] | md2[4] |
                  md2[3] | md2[2] | md2[1] | md2[0]) ; 
      oper_nxt = ST0 ; 
      end
   
   ST10 :
      begin
      md30_sel = LDRES ; 
      counter_sel = 2'b10 ;  //reset
      ld_sc = 1'b0 ;         //nop
      opend = 1'b0 ;         //operation end
      if (md4 == 8'b00000000 & md5 == 8'b00000000)
         begin
         setmdov = 1'b1 ;    //set mdov flag
         end
      else
         begin
         setmdov = 1'b0 ; 
         end 
      
      oper_nxt = ST0 ; 
      end
   
   ST11 :
      begin
      md30_sel = NOP_ ; 
      counter_sel = 2'b10 ;  //reset
      ld_sc = 1'b1 ;         //load sc
      opend = 1'b0 ;         //operation end
      setmdov = 1'b0 ;       //set mdov flag
      oper_nxt = ST0 ; 
      end
   
   ST12 :
      begin
      md30_sel = NOP_ ; 
      counter_sel = 2'b10 ;  //reset
      ld_sc = 1'b0 ;         //nop
      opend = 1'b0 ;         //operation end
      setmdov = 1'b0 ;       //set mdov flag
      case (mdu_op)
      MDU_SHIFT :
         begin
         oper_nxt = ST1 ; 
         end
      
      MDU_MUL :
         begin
         oper_nxt = ST13 ; 
         end
      
      MDU_DIV16 :
         begin
         oper_nxt = ST3 ; 
         end
      
      MDU_DIV32 :
         begin
         oper_nxt = ST4 ; 
         end
      
      default :
         begin
         oper_nxt = ST12 ; 
         end
      
      endcase 
      end
   
   ST13 :
      begin
      md30_sel = MD32RST ; 
      counter_sel = 2'b10 ;  //reset
      ld_sc = 1'b0 ;         //nop
      opend = 1'b0 ;         //operation end
      setmdov = 1'b0 ;       //set mdov flag     
      oper_nxt = ST2 ; 
      end
   
   default : // ST0
      begin
      md30_sel = NOP_ ; 
      counter_sel = 2'b10 ;  //reset
      ld_sc = 1'b0 ;         //nop
      opend = 1'b1 ;         //operation end
      setmdov = 1'b0 ;       //set mdov flag
      oper_nxt = ST0 ; 
      end
   
   endcase 
   end 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : oper_sync_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      oper_reg <= ST0 ; 
      end
   else
      begin
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      if (mdu_op == MDU_RST)
         begin
         oper_reg <= ST12 ; 
         end
      else
         begin
         oper_reg <= oper_nxt ; 
         end 
      end  
   end 
   
   //------------------------------------------------------------------
   // Special Function Registers read
   //------------------------------------------------------------------
   assign sfrdatamdu =
      (sfraddr == ARCON_ID) ? arcon :
      (sfraddr == MD0_ID) ? md0 :
      (sfraddr == MD1_ID) ? md1 :
      (sfraddr == MD2_ID) ? md2 :
      (sfraddr == MD3_ID) ? md3 :
      (sfraddr == MD4_ID) ? md4 :
      (sfraddr == MD5_ID) ? md5 :
      "--------" ; 
      
      
endmodule // module MDU

//*******************************************************************--
