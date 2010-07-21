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
// File name            : ramsfrctrl.v
// File contents        : Module RAM_SFR_CONTROL
// Purpose              : 256B Data Memory Control Unit
//                        Special Function Registers Control Unit
//
// Destination library  : R80515_LIB
//
// Design Engineer      : D.K.
// Quality Engineer     : M.B.
// Version              : 1.10.V05
// Last modification    : 2002-01-08
//---------------------------------------------------------------------

//*******************************************************************--
// Modifications with respect to Version 1.01.E00 :
// 1.02.E00   :
// 2000-01-24 : removed databus port
//            : added sfrdatao, ramdatao, ramsfrdata ports
// 2000-01-29 : Added the ANL_ADDR_N, XRL_ADDR_N, XRL_ADDR_N
//            : to the sfr_oe driver
// 2000-02-04 : Modified sfrwe, ramwe driver in respect
//            : to the DJNZ instruction
// 1.04.E00   :
// 2000-04-27 : ram_we_write_proc, sfr_we_write_proc, 
//            : db_aluresult_write_proc JBC_BIT, DJNZ_ADDR moved 
//            : from cycle2 to cycle3
// 1.04.E06   :
// 2001-02-12 : modified: sp_dec_hand, sp_inc_hand and sp_write_proc
// 1.10.E00   :
// 2001-09-03 : Added dpl1, dph1, dps registers to the sfr_bus_hand
// 1.10.E01   :
// 2001-11-13 : Modified ram_sfr_addr, datareg reset value from 
//            : hard-coded value on constant
//*******************************************************************--

`timescale 1 ns / 1 ns // timescale for following modules

module RAM_SFR_CONTROL
   (
   clk,
   rst,
   mempsack,
   instr,
   cycle,
   codefetche,
   intreq,
   regsbank,
   accreg,
   aluresult,
   pclreg,
   pchreg,
   memdatai,
   ram2memaddr,
   ramsfrdata,
   ramsfraddr,
   ramdatai,
   ramdatao,
   ramwe,
   ramoe,
   sfrdataalu,
   sfrdataclk,
   sfrdataisr,
   sfrdatamdu,
   sfrdatamcu,
   sfrdataports,
   sfrdataser0,
   sfrdataser1,
   sfrdatatim,
   sfrdatatim2,
   sfrdatawdt,
   sfrdataext,
   sfrdatao,
   sfrwe,
   sfroe
   );

   
   //  Declarations
   `include "utility.v"
   
   //  Global control signals inputs
   input    clk;           // Global clock input
   input    rst;           // Global reset input
   
   //  External memory read/write acknowledge input
   input    mempsack;
   
   //  CPU input signals
   input    [7:0] instr; 
   input    [3:0] cycle; 
   input    codefetche; 
   
   //  ISR input signal
   input    intreq;        // interrupt request
   
   //  RAM and SFR input signals
   input    [1:0] regsbank; 
   input    [7:0] accreg; 
   input    [7:0] aluresult; 
   
   //  Memory Control input signals
   input    [7:0] pclreg; 
   input    [7:0] pchreg; 
   
   //  Memory interface
   input    [7:0] memdatai; 
   input    ram2memaddr;   // RAM to MemAddr write enable
   
   //  Internal SFR Bus
   output   [7:0] ramsfrdata; 
   wire     [7:0] ramsfrdata;
   
   //  RAM and SFR address bus
   output   [7:0] ramsfraddr; 
   wire     [7:0] ramsfraddr;
   
   //  Data file interface
   input    [7:0] ramdatai; 
   output   [7:0] ramdatao; 
   wire     [7:0] ramdatao;
   output   ramwe;         // Data file write enable
   wire     ramwe;
   output   ramoe;         // Data file output enable
   wire     ramoe;
   
   //  Special function register interface
   input    [7:0] sfrdataalu; 
   input    [7:0] sfrdataclk; 
   input    [7:0] sfrdataisr; 
   input    [7:0] sfrdatamdu; 
   input    [7:0] sfrdatamcu; 
   input    [7:0] sfrdataports; 
   input    [7:0] sfrdataser0; 
   input    [7:0] sfrdataser1; 
   input    [7:0] sfrdatatim; 
   input    [7:0] sfrdatatim2; 
   input    [7:0] sfrdatawdt; 
   input    [7:0] sfrdataext; 
   output   [7:0] sfrdatao; 
   wire     [7:0] sfrdatao;
   output   sfrwe;         // SFR write enable
   wire     sfrwe;
   output   sfroe; 
   wire     sfroe;


   //------------------------------------------------------------------


   // Stack Pointer Register
   reg      [7:0] sp; 
   wire     [7:0] sp_inc; 
   wire     [7:0] sp_dec; 
   wire     spince; 
   wire     spdece; 
   
   // RAM and SFR address drivers
   reg      [7:0] ram_sfr_address; 
   wire     [6:0] sfr_address; 
   wire     [7:0] sfr_bus; 
   
   // RAM and SFR data drivers
   reg      [7:0] datareg; 
   wire     [7:0] sfr_datao; 
   wire     [7:0] ram_datao; 
   wire     [7:0] ram_sfr_data; 
   
   // RAM and SFR control drivers
   reg      ram_oe; 
   reg      ram_we; 
   reg      sfr_oe; 
   reg      sfr_we; 
   
   // Data Bus access signals
   reg      db_accreg; 
   reg      db_aluresult; 
   reg      db_pclreg; 
   reg      db_pchreg; 

   //------------------------------------------------------------------
   // RAM and SFR address bus
   //------------------------------------------------------------------
   assign ramsfraddr = ram_sfr_address ; 
   
   //------------------------------------------------------------------
   // SFR data in bus
   //------------------------------------------------------------------
   assign ramsfrdata = ram_sfr_data ; 
   
   //------------------------------------------------------------------
   // SFR data out bus
   //------------------------------------------------------------------
   assign sfrdatao = sfr_datao ; 
   
   //------------------------------------------------------------------
   // RAM data out bus
   //------------------------------------------------------------------
   assign ramdatao = ram_datao ; 
   
   //------------------------------------------------------------------
   // Data file interface
   // Data file output enable
   //------------------------------------------------------------------
   assign ramoe = ram_oe ; 
   
   //------------------------------------------------------------------
   // Data file interface
   // Data file write enable
   //------------------------------------------------------------------
   assign ramwe = ram_we ; 
   
   //------------------------------------------------------------------
   // Special function register interface
   // SFR output enable
   //------------------------------------------------------------------
   assign sfroe = sfr_oe ; 
   
   //------------------------------------------------------------------
   // Special function register interface
   // SFR write enable
   //------------------------------------------------------------------
   assign sfrwe = sfr_we ; 
   
   //------------------------------------------------------------------
   // Stack Pointer increment enable
   //------------------------------------------------------------------
   assign spince =
      (
         mempsack &
         (
            (memdatai == ACALL_0 & codefetche) |
            (memdatai == ACALL_1 & codefetche) |
            (memdatai == ACALL_2 & codefetche) |
            (memdatai == ACALL_3 & codefetche) |
            (memdatai == ACALL_4 & codefetche) |
            (memdatai == ACALL_5 & codefetche) |
            (memdatai == ACALL_6 & codefetche) |
            (memdatai == ACALL_7 & codefetche) |
            (memdatai == LCALL & codefetche) |
            (intreq & codefetche) |    // LCALL
            (instr == PUSH & cycle == 1) |
            (instr == ACALL_0 & cycle == 1) |
            (instr == ACALL_1 & cycle == 1) |
            (instr == ACALL_2 & cycle == 1) |
            (instr == ACALL_3 & cycle == 1) |
            (instr == ACALL_4 & cycle == 1) |
            (instr == ACALL_5 & cycle == 1) |
            (instr == ACALL_6 & cycle == 1) |
            (instr == ACALL_7 & cycle == 1) |
            (instr == LCALL & cycle == 1)
         )
      ) ? 1'b1 :
      1'b0 ; 
   
   //------------------------------------------------------------------
   // Stack Pointer decrement enable
   //------------------------------------------------------------------
   assign spdece =
      (
         (mempsack &
            (
               (memdatai == RET & codefetche) |
               (memdatai == RETI & codefetche)
            )
         ) |
         (instr == RET & cycle == 1) |
         (instr == RETI & cycle == 1) |
         (instr == POP & cycle == 2)
      ) ? 1'b1 :
      1'b0 ; 
   
   //------------------------------------------------------------------
   // Stack Pointer increment vector
   //------------------------------------------------------------------
   assign sp_inc =
      (sfr_we & ram_sfr_address == {1'b1, SP_ID}) ? sfr_datao + 1'b1 :
      sp + 1'b1 ; 
   
   //------------------------------------------------------------------
   // Stack Pointer increment vector
   //------------------------------------------------------------------
   assign sp_dec =
      (sfr_we & ram_sfr_address == {1'b1, SP_ID}) ? sfr_datao - 1'b1 :
      sp - 1'b1 ; 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : sp_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      sp <= SP_RV ; 
      end
   else
      begin
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Special function register write
      //--------------------------------
      if (spince)
         begin
         sp <= sp_inc;
         end
      else
         begin
         if (spdece)
            begin
            sp <= sp_dec;
            end
         else
            begin
            if (sfr_we & ram_sfr_address[6:0]==SP_ID)
               begin
               sp <= sfr_datao;
               end
            end
         end
      end  
   end 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : ram_oe_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      ram_oe <= 1'b0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      begin
      if (mempsack)
         begin
         if (codefetche)
            begin
            case (memdatai)
            ADD_IR0, ADD_IR1,
            ADDC_IR0, ADDC_IR1,
            INC_IR0, INC_IR1,
            DEC_IR0, DEC_IR1,
            ANL_A_IR0, ANL_A_IR1,
            ORL_A_IR0, ORL_A_IR1,
            XRL_A_IR0, XRL_A_IR1,
            MOV_A_IR0, MOV_A_IR1,
            MOV_ADDR_IR0, MOV_ADDR_IR1,
            MOV_IR0_A, MOV_IR1_A,
            MOV_IR0_N, MOV_IR1_N,
            XCH_IR0, XCH_IR1,
            XCHD_IR0, XCHD_IR1,
            CJNE_IR0_N, CJNE_IR1_N,
            ADD_R0, ADD_R1,
            ADD_R2, ADD_R3,
            ADD_R4, ADD_R5,
            ADD_R6, ADD_R7,
            ADDC_R0, ADDC_R1,
            ADDC_R2, ADDC_R3,
            ADDC_R4, ADDC_R5,
            ADDC_R6, ADDC_R7,
            SUBB_IR0, SUBB_IR1,
            SUBB_R0, SUBB_R1,
            SUBB_R2, SUBB_R3,
            SUBB_R4, SUBB_R5,
            SUBB_R6, SUBB_R7,
            INC_R0, INC_R1,
            INC_R2, INC_R3,
            INC_R4, INC_R5,
            INC_R6, INC_R7,
            DEC_R0, DEC_R1,
            DEC_R2, DEC_R3,
            DEC_R4, DEC_R5,
            DEC_R6, DEC_R7,
            ANL_A_R0, ANL_A_R1,
            ANL_A_R2, ANL_A_R3,
            ANL_A_R4, ANL_A_R5,
            ANL_A_R6, ANL_A_R7,
            ORL_A_R0, ORL_A_R1,
            ORL_A_R2, ORL_A_R3,
            ORL_A_R4, ORL_A_R5,
            ORL_A_R6, ORL_A_R7,
            XRL_A_R0, XRL_A_R1,
            XRL_A_R2, XRL_A_R3,
            XRL_A_R4, XRL_A_R5,
            XRL_A_R6, XRL_A_R7,
            MOV_A_R0, MOV_A_R1,
            MOV_A_R2, MOV_A_R3,
            MOV_A_R4, MOV_A_R5,
            MOV_A_R6, MOV_A_R7,
            MOV_R0_A, MOV_R1_A,
            MOV_R2_A, MOV_R3_A,
            MOV_R4_A, MOV_R5_A,
            MOV_R6_A, MOV_R7_A,
            MOV_ADDR_R0, MOV_ADDR_R1,
            MOV_ADDR_R2, MOV_ADDR_R3,
            MOV_ADDR_R4, MOV_ADDR_R5,
            MOV_ADDR_R6, MOV_ADDR_R7,
            XCH_R0, XCH_R1,
            XCH_R2, XCH_R3,
            XCH_R4, XCH_R5,
            XCH_R6, XCH_R7,
            CJNE_R0_N, CJNE_R1_N,
            CJNE_R2_N, CJNE_R3_N,
            CJNE_R4_N, CJNE_R5_N,
            CJNE_R6_N, CJNE_R7_N,
            DJNZ_R0, DJNZ_R1,
            DJNZ_R2, DJNZ_R3,
            DJNZ_R4, DJNZ_R5,
            DJNZ_R6, DJNZ_R7,
            MOVX_A_IR0, MOVX_A_IR1,
            MOVX_IR0_A, MOVX_IR1_A,
            RET, RETI,
            POP :
               begin
               ram_oe <= 1'b1 ; 
               end
            
            default :
               begin
               ram_oe <= 1'b0 ; 
               end
            
            endcase 
            end
         else if (ram2memaddr)
            begin
            ram_oe <= 1'b1 ; 
            end
         else
            begin
            case (cycle)
            1 :
               begin
               case (instr)
               ADD_IR0, ADD_IR1,
               ADDC_IR0, ADDC_IR1,
               INC_IR0, INC_IR1,
               DEC_IR0, DEC_IR1,
               ORL_A_IR0, ORL_A_IR1,
               ANL_A_IR0, ANL_A_IR1,
               XRL_A_IR0, XRL_A_IR1,
               CJNE_IR0_N, CJNE_IR1_N,
               MOV_A_IR0, MOV_A_IR1,
               MOV_ADDR_IR0, MOV_ADDR_IR1,
               SUBB_IR0, SUBB_IR1,
               XCH_IR0, XCH_IR1,
               XCHD_IR0, XCHD_IR1,
               MOVX_A_IR0, MOVX_A_IR1,
               MOVX_IR0_A, MOVX_IR1_A,
               RET, RETI :
                  begin
                  ram_oe <= 1'b1 ; 
                  end
               ADD_ADDR, ADDC_ADDR,
               SUBB_ADDR, INC_ADDR,
               DEC_ADDR, ANL_A_ADDR,
               ORL_A_ADDR, XRL_A_ADDR,
               ANL_ADDR_A, ANL_ADDR_N,
               ORL_ADDR_A, ORL_ADDR_N,
               XRL_ADDR_A, XRL_ADDR_N,
               MOV_A_ADDR, MOV_R0_ADDR,
               MOV_R1_ADDR, MOV_R2_ADDR,
               MOV_R3_ADDR, MOV_R4_ADDR,
               MOV_R5_ADDR, MOV_R6_ADDR,
               MOV_R7_ADDR, MOV_ADDR_ADDR,
               MOV_IR0_ADDR, MOV_IR1_ADDR,
               CJNE_A_ADDR, DJNZ_ADDR,
               XCH_ADDR, PUSH, CLR_BIT,
               SETB_BIT, ANL_C_BIT,
               ANL_C_NBIT, ORL_C_BIT,
               ORL_C_NBIT, MOV_C_BIT,
               MOV_BIT_C, CPL_BIT,
               JBC_BIT, JB_BIT,
               JNB_BIT :
                  begin
                  if (!(memdatai[7]))
                     begin
                     ram_oe <= 1'b1 ; 
                     end
                  else
                     begin
                     ram_oe <= 1'b0 ; 
                     end 
                  end
               
               default :
                  begin
                  ram_oe <= 1'b0 ; 
                  end
               
               endcase 
               end
            
            2 :
               begin
               case (instr)
               MOV_IR0_ADDR, MOV_IR1_ADDR :
                  begin
                  ram_oe <= 1'b1 ; 
                  end
               
               default :
                  begin
                  ram_oe <= 1'b0 ; 
                  end
               
               endcase 
               end
            
            default :
               begin
               ram_oe <= 1'b0 ; 
               end
            
            endcase 
            end 
         end
      end
   end 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : ram_we_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      ram_we <= 1'b0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      begin
      if (mempsack)
         begin
         case (cycle)
         1 :
            begin
            case (instr)
            DJNZ_R0, DJNZ_R1,
            DJNZ_R2, DJNZ_R3,
            DJNZ_R4, DJNZ_R5,
            DJNZ_R6, DJNZ_R7,
            INC_R0, INC_R1,
            INC_R2, INC_R3,
            INC_R4, INC_R5,
            INC_R6, INC_R7,
            DEC_R0, DEC_R1,
            DEC_R2, DEC_R3,
            DEC_R4, DEC_R5,
            DEC_R6, DEC_R7,
            MOV_R0_A, MOV_R1_A,
            MOV_R2_A, MOV_R3_A,
            MOV_R4_A, MOV_R5_A,
            MOV_R6_A, MOV_R7_A,
            MOV_R0_N, MOV_R1_N,
            MOV_R2_N, MOV_R3_N,
            MOV_R4_N, MOV_R5_N,
            MOV_R6_N, MOV_R7_N,
            XCH_R0, XCH_R1,
            XCH_R2, XCH_R3,
            XCH_R4, XCH_R5,
            XCH_R6, XCH_R7 :
               begin
               ram_we <= 1'b1 ; 
               end
            
            default :
               begin
               ram_we <= 1'b0 ; 
               end
            
            endcase 
            end
         
         2 :
            begin
            case (instr)
            INC_IR0, INC_IR1,
            DEC_IR0, DEC_IR1,
            MOV_IR0_A, MOV_IR1_A,
            MOV_IR0_N, MOV_IR1_N,
            XCH_IR0, XCH_IR1,
            XCHD_IR0, XCHD_IR1,
            ACALL_0, ACALL_1,
            ACALL_2, ACALL_3,
            ACALL_4, ACALL_5,
            ACALL_6, ACALL_7,
            LCALL :
               begin
               ram_we <= 1'b1 ; 
               end
            INC_ADDR, DEC_ADDR,
            ANL_ADDR_A, ORL_ADDR_A,
            XRL_ADDR_A, MOV_ADDR_A,
            MOV_ADDR_N, MOV_ADDR_R0,
            MOV_ADDR_R1, MOV_ADDR_R2,
            MOV_ADDR_R3, MOV_ADDR_R4,
            MOV_ADDR_R5, MOV_ADDR_R6,
            MOV_ADDR_R7, POP,
            XCH_ADDR, CLR_BIT,
            SETB_BIT, CPL_BIT,
            MOV_BIT_C :
               begin
               if (!(ram_sfr_address[7]))
                  begin
                  ram_we <= 1'b1 ; 
                  end
               else
                  begin
                  ram_we <= 1'b0 ; 
                  end 
               end
            
            default :
               begin
               ram_we <= 1'b0 ; 
               end
            
            endcase 
            end
         
         3 :
            begin
            case (instr)
            MOV_R0_ADDR, MOV_R1_ADDR,
            MOV_R2_ADDR, MOV_R3_ADDR,
            MOV_R4_ADDR, MOV_R5_ADDR,
            MOV_R6_ADDR, MOV_R7_ADDR,
            MOV_R0_N, MOV_R1_N,
            MOV_R2_N, MOV_R3_N,
            MOV_R4_N, MOV_R5_N,
            MOV_R6_N, MOV_R7_N,
            PUSH :
               begin
               ram_we <= 1'b1 ; 
               end
            
            MOV_ADDR_ADDR, XRL_ADDR_N,
            ANL_ADDR_N, ORL_ADDR_N,
            MOV_ADDR_IR0, MOV_ADDR_IR1,
            JBC_BIT, DJNZ_ADDR :
               begin
               if (!(ram_sfr_address[7]))
                  begin
                  ram_we <= 1'b1 ; 
                  end
               else
                  begin
                  ram_we <= 1'b0 ; 
                  end 
               end
            
            default :
               begin
               ram_we <= 1'b0 ; 
               end
            
            endcase 
            end
         
         4 :
            begin
            case (instr)
            MOV_IR0_ADDR, MOV_IR1_ADDR,
            ACALL_0, ACALL_1,
            ACALL_2, ACALL_3,
            ACALL_4, ACALL_5,
            ACALL_6, ACALL_7,
            LCALL :
               begin
               ram_we <= 1'b1 ; 
               end
            
            default :
               begin
               ram_we <= 1'b0 ; 
               end
            
            endcase 
            end
         
         default :
            begin
            ram_we <= 1'b0 ; 
            end
         
         endcase 
         end  
      else
         begin
         ram_we <= 1'b0 ; 
         end
      end
   end 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : sfr_oe_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      sfr_oe <= 1'b0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      begin
      if (mempsack)
         begin
         case (cycle)
         1 :
            begin
            case (instr)
            ADD_ADDR, ADDC_ADDR,
            SUBB_ADDR, INC_ADDR,
            DEC_ADDR, ANL_ADDR_N,
            ORL_ADDR_N, XRL_ADDR_N,
            ANL_A_ADDR, ANL_ADDR_A,
            ORL_A_ADDR, ORL_ADDR_A,
            XRL_A_ADDR, XRL_ADDR_A,
            MOV_A_ADDR, MOV_R0_ADDR,
            MOV_R1_ADDR, MOV_R2_ADDR,
            MOV_R3_ADDR, MOV_R4_ADDR,
            MOV_R5_ADDR, MOV_R6_ADDR,
            MOV_R7_ADDR, MOV_ADDR_ADDR,
            MOV_IR0_ADDR, MOV_IR1_ADDR,
            PUSH, CJNE_A_ADDR,
            DJNZ_ADDR, XCH_ADDR,
            CLR_BIT, SETB_BIT,
            ANL_C_BIT, ANL_C_NBIT,
            ORL_C_BIT, ORL_C_NBIT,
            MOV_C_BIT, MOV_BIT_C,
            CPL_BIT, JBC_BIT,
            JB_BIT, JNB_BIT :
               begin
               if (memdatai[7])
                  begin
                  sfr_oe <= 1'b1 ; 
                  end
               else
                  begin
                  sfr_oe <= 1'b0 ; 
                  end 
               end
            
            default :
               begin
               sfr_oe <= 1'b0 ; 
               end
            
            endcase 
            end
         
         default :
            begin
            sfr_oe <= 1'b0 ; 
            end
         
         endcase 
         end  
      end
   end 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : sfr_we_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      sfr_we <= 1'b0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      begin
      if (mempsack)
         begin
         case (cycle)
         2 :
            begin
            case (instr)
            INC_ADDR, DEC_ADDR,
            ANL_ADDR_A, ORL_ADDR_A,
            XRL_ADDR_A, MOV_ADDR_A,
            MOV_ADDR_N, MOV_ADDR_R0,
            MOV_ADDR_R1, MOV_ADDR_R2,
            MOV_ADDR_R3, MOV_ADDR_R4,
            MOV_ADDR_R5, MOV_ADDR_R6,
            MOV_ADDR_R7, POP,
            XCH_ADDR, CLR_BIT,
            SETB_BIT, CPL_BIT,
            MOV_BIT_C :
               begin
               if (ram_sfr_address[7])
                  begin
                  sfr_we <= 1'b1 ; 
                  end
               else
                  begin
                  sfr_we <= 1'b0 ; 
                  end 
               end
            
            default :
               begin
               sfr_we <= 1'b0 ; 
               end
            
            endcase 
            end
         
         3 :
            begin
            case (instr)
            MOV_ADDR_ADDR, ORL_ADDR_N,
            ANL_ADDR_N, XRL_ADDR_N,
            MOV_ADDR_IR0, MOV_ADDR_IR1,
            JBC_BIT, DJNZ_ADDR :
               begin
               if (ram_sfr_address[7])
                  begin
                  sfr_we <= 1'b1 ; 
                  end
               else
                  begin
                  sfr_we <= 1'b0 ; 
                  end 
               end
            
            default :
               begin
               sfr_we <= 1'b0 ; 
               end
            
            endcase 
            end
         
         default :
            begin
            sfr_we <= 1'b0 ; 
            end
         
         endcase 
         end
      else
         begin
         sfr_we <= 1'b0 ; 
         end
      end
   end 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : ram_sfr_address_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      ram_sfr_address <= RAM_SFR_ADDR_RV;
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      begin
      if (codefetche)
         begin
         if (mempsack)
            begin
            case (memdatai)
            ADD_IR0, ADD_IR1,
            ADDC_IR0, ADDC_IR1,
            SUBB_IR0, SUBB_IR1,
            INC_IR0, INC_IR1,
            DEC_IR0, DEC_IR1,
            ORL_A_IR0, ORL_A_IR1,
            ANL_A_IR0, ANL_A_IR1,
            XRL_A_IR0, XRL_A_IR1,
            MOV_A_IR0, MOV_A_IR1,
            MOV_ADDR_IR0, MOV_ADDR_IR1,
            MOV_IR0_A, MOV_IR1_A,
            MOV_IR0_N, MOV_IR1_N,
            XCH_IR0, XCH_IR1,
            XCHD_IR0, XCHD_IR1,
            CJNE_IR0_N, CJNE_IR1_N,
            MOVX_A_IR0, MOVX_A_IR1,
            MOVX_IR0_A, MOVX_IR1_A :
               begin
               if (ram_sfr_address == {1'b1, PSW_ID} & sfr_we)
                  begin
                  ram_sfr_address <= {3'b000, sfr_datao[4:3],
                                     2'b00, memdatai[0]} ; // PSW write
                  end
               else
                  begin
                  ram_sfr_address <= {3'b000, regsbank, 2'b00,
                                     memdatai[0]} ; 
                  end 
               end
            
            ADD_R0, ADD_R1,
            ADD_R2, ADD_R3,
            ADD_R4, ADD_R5,
            ADD_R6, ADD_R7,
            ADDC_R0, ADDC_R1,
            ADDC_R2, ADDC_R3,
            ADDC_R4, ADDC_R5,
            ADDC_R6, ADDC_R7,
            SUBB_R0, SUBB_R1,
            SUBB_R2, SUBB_R3,
            SUBB_R4, SUBB_R5,
            SUBB_R6, SUBB_R7,
            INC_R0, INC_R1,
            INC_R2, INC_R3,
            INC_R4, INC_R5,
            INC_R6, INC_R7,
            DEC_R0, DEC_R1,
            DEC_R2, DEC_R3,
            DEC_R4, DEC_R5,
            DEC_R6, DEC_R7,
            ORL_A_R0, ORL_A_R1,
            ORL_A_R2, ORL_A_R3,
            ORL_A_R4, ORL_A_R5,
            ORL_A_R6, ORL_A_R7,
            ANL_A_R0, ANL_A_R1,
            ANL_A_R2, ANL_A_R3,
            ANL_A_R4, ANL_A_R5,
            ANL_A_R6, ANL_A_R7,
            XRL_A_R0, XRL_A_R1,
            XRL_A_R2, XRL_A_R3,
            XRL_A_R4, XRL_A_R5,
            XRL_A_R6, XRL_A_R7,
            MOV_A_R0, MOV_A_R1,
            MOV_A_R2, MOV_A_R3,
            MOV_A_R4, MOV_A_R5,
            MOV_A_R6, MOV_A_R7,
            MOV_R0_A, MOV_R1_A,
            MOV_R2_A, MOV_R3_A,
            MOV_R4_A, MOV_R5_A,
            MOV_R6_A, MOV_R7_A,
            MOV_R0_N, MOV_R1_N,
            MOV_R2_N, MOV_R3_N,
            MOV_R4_N, MOV_R5_N,
            MOV_R6_N, MOV_R7_N,
            MOV_ADDR_R0, MOV_ADDR_R1,
            MOV_ADDR_R2, MOV_ADDR_R3,
            MOV_ADDR_R4, MOV_ADDR_R5,
            MOV_ADDR_R6, MOV_ADDR_R7,
            XCH_R0, XCH_R1,
            XCH_R2, XCH_R3,
            XCH_R4, XCH_R5,
            XCH_R6, XCH_R7,
            CJNE_R0_N, CJNE_R1_N,
            CJNE_R2_N, CJNE_R3_N,
            CJNE_R4_N, CJNE_R5_N,
            CJNE_R6_N, CJNE_R7_N,
            DJNZ_R0, DJNZ_R1,
            DJNZ_R2, DJNZ_R3,
            DJNZ_R4, DJNZ_R5,
            DJNZ_R6, DJNZ_R7 :
               begin
               if (ram_sfr_address == {1'b1, PSW_ID} & sfr_we)
                  begin
                  ram_sfr_address <= {3'b000, sfr_datao[4:3],
                                     memdatai[2:0]} ; // PSW write
                  end
               else
                  begin
                  ram_sfr_address <= {3'b000, regsbank, memdatai[2:0]};
                  end 
               end
            
            POP, RET,
            RETI :
               begin
               if (ram_sfr_address == {1'b1, SP_ID} & sfr_we)
                  begin
                  ram_sfr_address <= sfr_datao ; // SP write
                  end
               else
                  begin
                  ram_sfr_address <= sp ; 
                  end 
               end
            
            endcase 
            end
         end
      else
         begin
         case (cycle)
         1 :
            begin
            case (instr)
            ADD_IR0, ADD_IR1,
            ADDC_IR0, ADDC_IR1,
            SUBB_IR0, SUBB_IR1,
            INC_IR0, INC_IR1,
            DEC_IR0, DEC_IR1,
            ORL_A_IR0, ORL_A_IR1,
            ANL_A_IR0, ANL_A_IR1,
            XRL_A_IR0, XRL_A_IR1,
            CJNE_IR0_N, CJNE_IR1_N,
            MOV_IR0_A, MOV_IR1_A,
            MOV_IR0_N, MOV_IR1_N,
            MOV_ADDR_IR0, MOV_ADDR_IR1,
            XCH_IR0, XCH_IR1,
            XCHD_IR0, XCHD_IR1,
            MOV_A_IR0, MOV_A_IR1 :
               begin
               if (mempsack)
                  begin
                  ram_sfr_address <= ramdatai ; 
                  end
               end
            
            ADD_ADDR, ADDC_ADDR,
            SUBB_ADDR, INC_ADDR,
            DEC_ADDR, ANL_ADDR_N,
            ORL_ADDR_N, XRL_ADDR_N,
            ANL_A_ADDR, ANL_ADDR_A,
            ORL_A_ADDR, ORL_ADDR_A,
            XRL_A_ADDR, XRL_ADDR_A,
            MOV_A_ADDR, MOV_ADDR_A,
            MOV_R0_ADDR, MOV_R1_ADDR,
            MOV_R2_ADDR, MOV_R3_ADDR,
            MOV_R4_ADDR, MOV_R5_ADDR,
            MOV_R6_ADDR, MOV_R7_ADDR,
            MOV_ADDR_R0, MOV_ADDR_R1,
            MOV_ADDR_R2, MOV_ADDR_R3,
            MOV_ADDR_R4, MOV_ADDR_R5,
            MOV_ADDR_R6, MOV_ADDR_R7,
            MOV_ADDR_N, MOV_ADDR_ADDR,
            MOV_IR0_ADDR, MOV_IR1_ADDR,
            PUSH, POP,
            CJNE_A_ADDR, DJNZ_ADDR,
            XCH_ADDR :
               begin
               if (mempsack)
                  begin
                  ram_sfr_address <= memdatai ; 
                  end
               end
            
            CLR_BIT,   SETB_BIT,
            ANL_C_BIT, ANL_C_NBIT,
            ORL_C_BIT, ORL_C_NBIT,
            MOV_C_BIT, MOV_BIT_C,
            CPL_BIT,   JBC_BIT,
            JB_BIT,    JNB_BIT :
               begin
               if (mempsack)
                  begin
                  if (!(memdatai[7]))
                     begin
                     ram_sfr_address <= {4'b0010, memdatai[6:3]} ; 
                     end
                  else
                     begin
                     ram_sfr_address <= {1'b1, memdatai[6:3], 3'b000} ; 
                     end
                  end
               end
            
            RET, RETI,
            ACALL_0, ACALL_1,
            ACALL_2, ACALL_3,
            ACALL_4, ACALL_5,
            ACALL_6, ACALL_7,
            LCALL :
               begin
               ram_sfr_address <= sp ; 
               end
            
            endcase 
            end
         
         2 :
            begin
            case (instr)
            MOV_IR0_ADDR, MOV_IR1_ADDR :
               begin
               ram_sfr_address <= {3'b000, regsbank, 2'b00, instr[0]};
               end
            
            MOV_R0_ADDR, MOV_R1_ADDR,
            MOV_R2_ADDR, MOV_R3_ADDR,
            MOV_R4_ADDR, MOV_R5_ADDR,
            MOV_R6_ADDR, MOV_R7_ADDR :
               begin
               ram_sfr_address <= {3'b000, regsbank, instr[2:0]} ; 
               end
            
            MOV_ADDR_ADDR :
               begin
               if (mempsack)
                  begin
                  ram_sfr_address <= memdatai ; 
                  end
               end
            
            PUSH :
               begin
               ram_sfr_address <= sp ; 
               end
            
            MOV_ADDR_IR0, MOV_ADDR_IR1 :
               begin
               ram_sfr_address <= datareg ; 
               end
            
            endcase 
            end
         
         3 :
            begin
            case (instr)
            MOV_IR0_ADDR, MOV_IR1_ADDR :
               begin
               ram_sfr_address <= ramdatai ; 
               end
            
            ACALL_0, ACALL_1,
            ACALL_2, ACALL_3,
            ACALL_4, ACALL_5,
            ACALL_6, ACALL_7,
            LCALL :
               begin
               ram_sfr_address <= sp ; 
               end
            
            endcase 
            end
         
         endcase 
         end 
      end  
   end 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : db_acc_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      db_accreg <= 1'b0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      begin
      case (cycle)
      1 :
         begin
         case (instr)
         MOV_R0_A, MOV_R1_A,
         MOV_R2_A, MOV_R3_A,
         MOV_R4_A, MOV_R5_A,
         MOV_R6_A, MOV_R7_A,
         XCH_R0, XCH_R1,
         XCH_R2, XCH_R3,
         XCH_R4, XCH_R5,
         XCH_R6, XCH_R7 :
            begin
            db_accreg <= 1'b1 ; 
            end
         
         default :
            begin
            db_accreg <= 1'b0 ; 
            end
         
         endcase 
         end
      
      2 :
         begin
         case (instr)
         MOV_ADDR_A, XCH_ADDR,
         MOV_IR0_A, MOV_IR1_A,
         XCH_IR0, XCH_IR1 :
            begin
            db_accreg <= 1'b1 ; 
            end
         
         default :
            begin
            db_accreg <= 1'b0 ; 
            end
         
         endcase 
         end
      
      default :
         begin
         db_accreg <= 1'b0 ; 
         end
      
      endcase 
      end  
   end 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : db_aluresult_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      db_aluresult <= 1'b0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      begin
      case (cycle)
      1 :
         begin
         case (instr)
         DJNZ_R0, DJNZ_R1,
         DJNZ_R2, DJNZ_R3,
         DJNZ_R4, DJNZ_R5,
         DJNZ_R6, DJNZ_R7,
         INC_R0, INC_R1,
         INC_R2, INC_R3,
         INC_R4, INC_R5,
         INC_R6, INC_R7,
         DEC_R0, DEC_R1,
         DEC_R2, DEC_R3,
         DEC_R4, DEC_R5,
         DEC_R6, DEC_R7 :
            begin
            db_aluresult <= 1'b1 ; 
            end
         
         default :
            begin
            db_aluresult <= 1'b0 ; 
            end
         
         endcase 
         end
      
      2 :
         begin
         case (instr)
         INC_ADDR, DEC_ADDR,
         INC_IR0, INC_IR1,
         DEC_IR0, DEC_IR1,
         ANL_ADDR_A, ORL_ADDR_A,
         XRL_ADDR_A, CLR_BIT,
         SETB_BIT, CPL_BIT,
         MOV_BIT_C :
            begin
            db_aluresult <= 1'b1 ; 
            end
   
         default :
            begin
            db_aluresult <= 1'b0 ; 
            end
         
         endcase 
         end
      
      3 :
         begin
         case (instr)
         ANL_ADDR_N, XRL_ADDR_N,
         ORL_ADDR_N, JBC_BIT,
         DJNZ_ADDR :
            begin
            db_aluresult <= 1'b1 ; 
            end
         
         default :
            begin
            db_aluresult <= 1'b0 ; 
            end
         
         endcase 
         end
      
      default :
         begin
         db_aluresult <= 1'b0 ; 
         end
      
      endcase 
      end  
   end 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : db_pclcreg_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      db_pclreg <= 1'b0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      begin
      case (cycle)
      2 :
         begin
         case (instr)
         ACALL_0, ACALL_1,
         ACALL_2, ACALL_3,
         ACALL_4, ACALL_5,
         ACALL_6, ACALL_7,
         LCALL :
            begin
            db_pclreg <= 1'b1 ; 
            end
         
         default :
            begin
            db_pclreg <= 1'b0 ; 
            end
         
         endcase 
         end
      
      default :
         begin
         db_pclreg <= 1'b0 ; 
         end
      
      endcase 
      end  
   end 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : db_pchcreg_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      db_pchreg <= 1'b0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      begin
      case (cycle)
      4 :
         begin
         case (instr)
         ACALL_0, ACALL_1,
         ACALL_2, ACALL_3,
         ACALL_4, ACALL_5,
         ACALL_6, ACALL_7,
         LCALL :
            begin
            db_pchreg <= 1'b1 ; 
            end
         
         default :
            begin
            db_pchreg <= 1'b0 ; 
            end
         
         endcase 
         end
      
      default :
         begin
         db_pchreg <= 1'b0 ; 
         end
      
      endcase 
      end  
   end 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : datareg_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      datareg <= DATAREG_RV;
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      begin
      case (cycle)
      1 :
         begin
         case (instr)
         MOV_R0_N, MOV_R1_N,
         MOV_R2_N, MOV_R3_N,
         MOV_R4_N, MOV_R5_N,
         MOV_R6_N, MOV_R7_N,
         MOV_ADDR_IR0, MOV_ADDR_IR1,
         MOV_IR0_N, MOV_IR1_N,
         MOV_A_N :
            begin
            datareg <= memdatai ; 
            end
         
         MOV_ADDR_R0, MOV_ADDR_R1,
         MOV_ADDR_R2, MOV_ADDR_R3,
         MOV_ADDR_R4, MOV_ADDR_R5,
         MOV_ADDR_R6, MOV_ADDR_R7,
         POP :
            begin
            datareg <= ramdatai ; 
            end
                    // data_bus -- ram(ma)->DR (Rn->DR)
         
         PUSH :
            begin
            datareg <= sp ; 
            end
         
         endcase 
         end
      
      2 :
         begin
         case (instr)
         MOV_ADDR_N :
            begin
            datareg <= memdatai ; 
            end
         
         MOV_R0_ADDR, MOV_R1_ADDR,
         MOV_R2_ADDR, MOV_R3_ADDR,
         MOV_R4_ADDR, MOV_R5_ADDR,
         MOV_R6_ADDR, MOV_R7_ADDR,
         MOV_ADDR_IR0, MOV_ADDR_IR1,
         MOV_IR0_ADDR, MOV_IR1_ADDR,
         MOV_ADDR_ADDR :
            begin
            datareg <= ram_sfr_data ; 
            end
         
         PUSH :
            begin
            if (~(ram_sfr_address == {1'b1, SP_ID}))
               begin
               datareg <= ram_sfr_data ; 
               end 
            end
         
         XCHD_IR0, XCHD_IR1 :
            begin
            datareg <= {ramdatai[7:4], accreg[3:0]} ; 
            end
         
         endcase 
         end
      
      endcase 
      end  
   end 
   
   //------------------------------------------------------------------
   // SFR Data Out Mux
   //------------------------------------------------------------------
   assign sfr_datao =
      (db_accreg)    ? accreg :
      (db_aluresult) ? aluresult :
      datareg ; 
   
   //------------------------------------------------------------------
   // SFR Data Out Mux
   //------------------------------------------------------------------
   assign ram_datao =
      (db_pclreg)    ? pclreg :
      (db_pchreg)    ? pchreg :
      sfr_datao ; 
   
   //------------------------------------------------------------------
   // RAM SFR Data In Mux
   //------------------------------------------------------------------
   assign ram_sfr_data =
      (ram_oe)    ? ramdatai :
      sfr_bus ; 

   //------------------------------------------------------------------
   // Special Function registers Address write
   //------------------------------------------------------------------
   assign sfr_address = ram_sfr_address[6:0] ; 
   
   //------------------------------------------------------------------
   // Special Function Registers Mux
   //------------------------------------------------------------------
   assign sfr_bus =
      (sfr_address == SP_ID)     ? sp :
      (sfr_address == ACC_ID |
       sfr_address == B_ID |
       sfr_address == PSW_ID)    ? sfrdataalu :
      (sfr_address == PCON_ID |
       sfr_address == CKCON_ID)  ? sfrdataclk :
      (sfr_address == IEN0_ID |
       sfr_address == IEN1_ID |
       sfr_address == IEN2_ID |
       sfr_address == IP0_ID |
       sfr_address == IP1_ID |
       sfr_address == IRCON_ID)  ? sfrdataisr :
      (sfr_address == ARCON_ID |
       sfr_address == MD0_ID |
       sfr_address == MD1_ID |
       sfr_address == MD2_ID |
       sfr_address == MD3_ID |
       sfr_address == MD4_ID |
       sfr_address == MD5_ID)    ? sfrdatamdu :
      (sfr_address == DPL_ID |
       sfr_address == DPH_ID |
       sfr_address == DPL1_ID |
       sfr_address == DPH1_ID |
       sfr_address == DPS_ID)    ? sfrdatamcu :
      (sfr_address == P0_ID |
       sfr_address == P1_ID |
       sfr_address == P2_ID |
       sfr_address == P3_ID)     ? sfrdataports :
      (sfr_address == S0CON_ID |
       sfr_address == S0BUF_ID |
       sfr_address == S0RELL_ID |
       sfr_address == S0RELH_ID |
       sfr_address == ADCON_ID)  ? sfrdataser0 :
      (sfr_address == S1CON_ID |
       sfr_address == S1BUF_ID |
       sfr_address == S1RELL_ID |
       sfr_address == S1RELH_ID) ? sfrdataser1 :
      (sfr_address == TL0_ID |
       sfr_address == TH0_ID |
       sfr_address == TL1_ID |
       sfr_address == TH1_ID |
       sfr_address == TCON_ID |
       sfr_address == TMOD_ID)   ? sfrdatatim :
      (sfr_address == TL2_ID |
       sfr_address == TH2_ID |
       sfr_address == T2CON_ID |
       sfr_address == CRCL_ID |
       sfr_address == CRCH_ID |
       sfr_address == CCEN_ID |
       sfr_address == CCL1_ID |
       sfr_address == CCH1_ID |
       sfr_address == CCL2_ID |
       sfr_address == CCH2_ID |
       sfr_address == CCL3_ID |
       sfr_address == CCH3_ID)   ? sfrdatatim2 :
      (sfr_address == WDTREL_ID) ? sfrdatawdt :
      sfrdataext ; 


endmodule // module RAM_SFR_CONTROL

//*******************************************************************--
