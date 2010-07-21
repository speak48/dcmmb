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
// File name            : cpu.v
// File contents        : Module CONTROL_UNIT
// Purpose              : Control Processor Unit
//
// Destination library  : R80515_LIB
//
// Design Engineer      : M.B. D.K.
// Quality Engineer     : M.B.
// Version              : 1.10.V05
// Last modification    : 2002-01-08
//---------------------------------------------------------------------

`timescale 1 ns / 1 ns // timescale for following modules

//*******************************************************************--
// Modifications with respect to Version 1.01.E00 :
// 1.02.E00   :
// 2000-01-31 : Modified intack driver in respect to the
//            : no interrupt LCALL
// 1.02.E00   :
// 2000-02-02 : Added intcall output
// 1.04.E03   :
// 2000-08-17 : Reduced number of cycles for mul and div instructions
//            : from 8 to 5 cycles because invalid loading arguments
// 1.10.E00   :
// 2001-09-03 : Added stoppmu input port
//            : Implemented pmu stop mode to the nr_decodr_proc and
//            : codefetch_proc
// 1.10.V02   :
// 2002-01-03 : Integer type of curcycle, nr_cycles, nr_bytes,
//            : nr_cycles_a, nr_bytes_a changed into a vector.
// 1.10.V03   :
// 2002-01-08 : Added mempsack port and modified mempsack related logic
//*******************************************************************--

module CONTROL_UNIT (
   clk,
   rst,
   mempsack,
   intreq,
   stretch,
   stoppmu,
   instr,
   cycle,
   codefetche,
   datafetche,
   rmwinstr,
   intack,
   intret,
   intcall,
   memdatai
   );


   //  Declarations
   `include "utility.v"

   
   //  Control signal inputs
   input       clk;        // Global clock input
   input       rst;        // Global reset input
   
   //  External memory read/write acknowledge input
   input       mempsack;
   
   //  ISR input signals
   input       intreq;     // Interrupt request
   
   //  Clock Control inputs
   input       [2:0] stretch; 
   
   //  Power Management Unit input
   input       stoppmu;    // Stop mode
           
   //  Instruction register output
   output      [7:0] instr; 
   wire        [7:0] instr;
   
   //  Cycle counter output
   output      [3:0] cycle; 
   wire        [3:0] cycle;
   
   //  Instruction decoder output
   output      codefetche; // Opcode fetch enable
   wire        codefetche;
   output      datafetche; // Data fetch enable
   wire        datafetche;
   output      rmwinstr;   // Read-Modify-Write Instr.
   reg         rmwinstr;
   output      intack;     // Interrupt acknowledge flag
   
   //  ISR control outputs
   reg         intack;
   output      intret;     // Interrupt return flag
   reg         intret;
   output      intcall;    // Interrupt call
   wire        intcall;
   
   //  Program bus input
   input       [7:0] memdatai; 

   //------------------------------------------------------------------

   // Instruction register
   reg         [7:0] instrreg; 
   
   // Fetch enable signals
   wire        code_fetch_e; 
   wire        data_fetch_e; 
   
   // Current machine cycle register
   reg         [3:0] curcycle; 
   
   // Number of bytes and cycles signals
   reg         [3:0] nr_cycles_a; 
   reg         [1:0] nr_bytes_a;  
   
   // Number of bytes and cycles registers
   reg         [3:0] nr_cycles; 
   reg         [1:0] nr_bytes; 
   
   // Read-Modify-Write Instruction signal
   wire        rmwinstr_a; 
   
   // Interrupt call routine flag
   reg         int_call; 

   //------------------------------------------------------------------
   // Instruction opcode
   //------------------------------------------------------------------
   assign instr = instrreg ; 
   
   //------------------------------------------------------------------
   // Current machine cycle
   //------------------------------------------------------------------
   assign cycle = curcycle ; 
   
   //------------------------------------------------------------------
   // Opcode fetch enable signals
   //------------------------------------------------------------------
   assign codefetche = code_fetch_e ; 
   
   //------------------------------------------------------------------
   // Data fetch enable signals
   //------------------------------------------------------------------
   assign datafetche = data_fetch_e ; 
   
   //------------------------------------------------------------------
   // Interrupt call
   //------------------------------------------------------------------
   assign intcall = int_call ; 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : interrupt_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      intack <= 1'b0 ; 
      intret <= 1'b0 ; 
      int_call <= 1'b0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Interrupt call flag
      //--------------------------------
      begin
      if (code_fetch_e & mempsack)
         begin
         if (intreq)
            begin
            int_call <= 1'b1 ; 
            end
         else
            begin
            int_call <= 1'b0 ; 
            end 
         end 
      
      //--------------------------------
      // Interrupt acknowledge flag
      //--------------------------------
      if (int_call & curcycle == 4'b 0011) // active cycle=4
         begin
         intack <= 1'b1 ; 
         end
      else
         begin
         intack <= 1'b0 ; 
         end 
      
      //--------------------------------
      // Interrupt return flag
      //--------------------------------
      if (instrreg == RETI & curcycle == 4'b 0011) // active cycle=4
         begin
         intret <= 1'b1 ; 
         end
      else
         begin
         intret <= 1'b0 ; 
         end 
      
      end  
   end 
   
   //------------------------------------------------------------------
   // Instruction code fetch enable
   //------------------------------------------------------------------
   assign code_fetch_e = (curcycle == nr_cycles & ~stoppmu) ? 1'b1
      : 1'b0 ; 

   //------------------------------------------------------------------
   // Instruction data fetch enable
   //------------------------------------------------------------------
   assign data_fetch_e = (curcycle < nr_bytes) ? 1'b1 : 1'b0 ; 

   //------------------------------------------------------------------
   // Instruction register
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : codefetch_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      instrreg <= NOP ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Instruction register write
      //--------------------------------
      begin
      if (stoppmu)
         begin
         instrreg <= NOP;
         end
      else if (code_fetch_e & mempsack)
         begin
         if (intreq)
            begin
            // Interrupt request
            instrreg <= LCALL ; 
            end
         else
            begin
            instrreg <= memdatai ; 
            end 
         end 
      end  
   end 

   //------------------------------------------------------------------
   // Current cycle counter
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : curcycle_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      curcycle <= 4'b 0001 ; 
      end
   else
      begin
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Current cycle count
      //--------------------------------
      if (mempsack)
         begin
         if (curcycle < nr_cycles)
            begin
            curcycle <= curcycle + 4'b 0001 ; 
            end
         else
            begin
            curcycle <= 4'b 0001 ; 
            end
         end
      end
   end 
   
   //------------------------------------------------------------------
   // Read-Modify-Write instruction decoder
   // Combinational part
   //------------------------------------------------------------------
   assign rmwinstr_a =
      (memdatai == ANL_ADDR_A | memdatai == ANL_ADDR_N |
      memdatai == ORL_ADDR_A | memdatai == ORL_ADDR_N |
      memdatai == XRL_ADDR_A | memdatai == XRL_ADDR_N |
      memdatai == JBC_BIT | memdatai == CPL_BIT |
      memdatai == INC_ADDR | memdatai == DEC_ADDR |
      memdatai == DJNZ_ADDR | memdatai == MOV_BIT_C |
      memdatai == CLR_BIT | memdatai == SETB_BIT) ? 1'b1
      : 1'b0 ; 

   //------------------------------------------------------------------
   // Read-Modify-Write instruction decoder
   // Sequential part
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : rmwinstr_decoder_proc
   //------------------------------------------------------------------ 
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      rmwinstr <= 1'b0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Read-Modify-Write flip-flop
      //--------------------------------
      begin
      if (mempsack)
         begin
         if (code_fetch_e)
            begin
            rmwinstr <= rmwinstr_a ; 
            end 
         end
      end  
   end 

   //------------------------------------------------------------------
   // Instruction decoder
   // Combinational part
   //------------------------------------------------------------------
   always @(memdatai or stretch)
   begin : nr_decoder_hand
   //------------------------------------------------------------------ 
   case (memdatai)
   //-----------------------------------
   // 00h
   //-----------------------------------
   NOP :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   AJMP_0 :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   LJMP :
      begin
      nr_bytes_a = 2'b11 ; 
      nr_cycles_a = 4'b0100 ; 
      end
   RR_A :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   INC_A :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   INC_ADDR :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   INC_IR0 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   INC_IR1 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   INC_R0 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   INC_R1 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   INC_R2 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   INC_R3 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   INC_R4 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   INC_R5 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   INC_R6 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   INC_R7 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   
   //-----------------------------------
   // 10h
   //-----------------------------------
   JBC_BIT :
      begin
      nr_bytes_a = 2'b11 ; 
      nr_cycles_a = 4'b0100 ; 
      end
   ACALL_0 :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0110 ; 
      end
   LCALL :
      begin
      nr_bytes_a = 2'b11 ; 
      nr_cycles_a = 4'b0110 ; 
      end
   RRC_A :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   DEC_A :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   DEC_ADDR :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   DEC_IR0 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   DEC_IR1 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   DEC_R0 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   DEC_R1 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   DEC_R2 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   DEC_R3 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   DEC_R4 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   DEC_R5 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   DEC_R6 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   DEC_R7 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   
   //-----------------------------------
   // 20h
   //-----------------------------------
   JB_BIT :
      begin
      nr_bytes_a = 2'b11 ; 
      nr_cycles_a = 4'b0100 ; 
      end
   AJMP_1 :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   RET :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0100 ; 
      end
   RL_A :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   ADD_N :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   ADD_ADDR :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   ADD_IR0 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   ADD_IR1 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   ADD_R0 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   ADD_R1 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   ADD_R2 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   ADD_R3 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   ADD_R4 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   ADD_R5 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   ADD_R6 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   ADD_R7 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   
   //-----------------------------------
   // 30h
   //-----------------------------------
   JNB_BIT :
      begin
      nr_bytes_a = 2'b11 ; 
      nr_cycles_a = 4'b0100 ; 
      end
   ACALL_1 :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0110 ; 
      end
   RETI :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0100 ; 
      end
   RLC_A :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   ADDC_N :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   ADDC_ADDR :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   ADDC_IR0 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   ADDC_IR1 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   ADDC_R0 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   ADDC_R1 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   ADDC_R2 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   ADDC_R3 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   ADDC_R4 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   ADDC_R5 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   ADDC_R6 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   ADDC_R7 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   
   //-----------------------------------
   // 40h
   //-----------------------------------
   JC :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   AJMP_2 :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   ORL_ADDR_A :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   ORL_ADDR_N :
      begin
      nr_bytes_a = 2'b11 ; 
      nr_cycles_a = 4'b0100 ; 
      end
   ORL_A_N :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   ORL_A_ADDR :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   ORL_A_IR0 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   ORL_A_IR1 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   ORL_A_R0 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   ORL_A_R1 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   ORL_A_R2 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   ORL_A_R3 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   ORL_A_R4 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   ORL_A_R5 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   ORL_A_R6 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   ORL_A_R7 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   
   //-----------------------------------
   // 50h
   //-----------------------------------
   JNC :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   ACALL_2 :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0110 ; 
      end
   ANL_ADDR_A :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   ANL_ADDR_N :
      begin
      nr_bytes_a = 2'b11 ; 
      nr_cycles_a = 4'b0100 ; 
      end
   ANL_A_N :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   ANL_A_ADDR :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   ANL_A_IR0 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   ANL_A_IR1 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   ANL_A_R0 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   ANL_A_R1 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   ANL_A_R2 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   ANL_A_R3 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   ANL_A_R4 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   ANL_A_R5 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   ANL_A_R6 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   ANL_A_R7 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   
   //-----------------------------------
   // 60h
   //-----------------------------------
   JZ :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   AJMP_3 :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   XRL_ADDR_A :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   XRL_ADDR_N :
      begin
      nr_bytes_a = 2'b11 ; 
      nr_cycles_a = 4'b0100 ; 
      end
   XRL_A_N :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   XRL_A_ADDR :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   XRL_A_IR0 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   XRL_A_IR1 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   XRL_A_R0 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   XRL_A_R1 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   XRL_A_R2 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   XRL_A_R3 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   XRL_A_R4 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   XRL_A_R5 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   XRL_A_R6 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   XRL_A_R7 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   
   //-----------------------------------
   // 70h
   //-----------------------------------
   JNZ :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   ACALL_3 :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0110 ; 
      end
   ORL_C_BIT :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   JMP_A_DPTR :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   MOV_A_N :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   MOV_ADDR_N :
      begin
      nr_bytes_a = 2'b11 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   MOV_IR0_N :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   MOV_IR1_N :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   MOV_R0_N :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   MOV_R1_N :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   MOV_R2_N :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   MOV_R3_N :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   MOV_R4_N :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   MOV_R5_N :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   MOV_R6_N :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   MOV_R7_N :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   
   //-----------------------------------
   // 80h
   //-----------------------------------
   SJMP :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   AJMP_4 :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   ANL_C_BIT :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   MOVC_A_PC :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   DIV_AB :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0101 ; 
      end
   MOV_ADDR_ADDR :
      begin
      nr_bytes_a = 2'b11 ; 
      nr_cycles_a = 4'b0100 ; 
      end
   MOV_ADDR_IR0 :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0100 ; 
      end
   MOV_ADDR_IR1 :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0100 ; 
      end
   MOV_ADDR_R0 :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   MOV_ADDR_R1 :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   MOV_ADDR_R2 :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   MOV_ADDR_R3 :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   MOV_ADDR_R4 :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   MOV_ADDR_R5 :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   MOV_ADDR_R6 :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   MOV_ADDR_R7 :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   
   //-----------------------------------
   // 90h
   //-----------------------------------
   MOV_DPTR_N :
      begin
      nr_bytes_a = 2'b11 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   ACALL_4 :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0110 ; 
      end
   MOV_BIT_C :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   MOVC_A_DPTR :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   SUBB_N :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   SUBB_ADDR :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   SUBB_IR0 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   SUBB_IR1 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   SUBB_R0 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   SUBB_R1 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   SUBB_R2 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   SUBB_R3 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   SUBB_R4 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   SUBB_R5 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   SUBB_R6 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   SUBB_R7 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   
   //-----------------------------------
   // A0h
   //-----------------------------------
   ORL_C_NBIT :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   AJMP_5 :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   MOV_C_BIT :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   INC_DPTR :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   MUL_AB :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0101 ; 
      end
   MOV_IR0_ADDR :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0101 ; 
      end
   MOV_IR1_ADDR :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0101 ; 
      end
   MOV_R0_ADDR :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0100 ; 
      end
   MOV_R1_ADDR :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0100 ; 
      end
   MOV_R2_ADDR :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0100 ; 
      end
   MOV_R3_ADDR :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0100 ; 
      end
   MOV_R4_ADDR :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0100 ; 
      end
   MOV_R5_ADDR :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0100 ; 
      end
   MOV_R6_ADDR :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0100 ; 
      end
   MOV_R7_ADDR :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0100 ; 
      end
   
   //-----------------------------------
   // B0h
   //-----------------------------------
   ANL_C_NBIT :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   ACALL_5 :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0110 ; 
      end
   CPL_BIT :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   CPL_C :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   CJNE_A_N :
      begin
      nr_bytes_a = 2'b11 ; 
      nr_cycles_a = 4'b0100 ; 
      end
   CJNE_A_ADDR :
      begin
      nr_bytes_a = 2'b11 ; 
      nr_cycles_a = 4'b0100 ; 
      end
   CJNE_IR0_N :
      begin
      nr_bytes_a = 2'b11 ; 
      nr_cycles_a = 4'b0100 ; 
      end
   CJNE_IR1_N :
      begin
      nr_bytes_a = 2'b11 ; 
      nr_cycles_a = 4'b0100 ; 
      end
   CJNE_R0_N :
      begin
      nr_bytes_a = 2'b11 ; 
      nr_cycles_a = 4'b0100 ; 
      end
   CJNE_R1_N :
      begin
      nr_bytes_a = 2'b11 ; 
      nr_cycles_a = 4'b0100 ; 
      end
   CJNE_R2_N :
      begin
      nr_bytes_a = 2'b11 ; 
      nr_cycles_a = 4'b0100 ; 
      end
   CJNE_R3_N :
      begin
      nr_bytes_a = 2'b11 ; 
      nr_cycles_a = 4'b0100 ; 
      end
   CJNE_R4_N :
      begin
      nr_bytes_a = 2'b11 ; 
      nr_cycles_a = 4'b0100 ; 
      end
   CJNE_R5_N :
      begin
      nr_bytes_a = 2'b11 ; 
      nr_cycles_a = 4'b0100 ; 
      end
   CJNE_R6_N :
      begin
      nr_bytes_a = 2'b11 ; 
      nr_cycles_a = 4'b0100 ; 
      end
   CJNE_R7_N :
      begin
      nr_bytes_a = 2'b11 ; 
      nr_cycles_a = 4'b0100 ; 
      end
   
   //-----------------------------------
   // C0h
   //-----------------------------------
   PUSH :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0100 ; 
      end
   AJMP_6 :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   CLR_BIT :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   CLR_C :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   SWAP_A :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   XCH_ADDR :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   XCH_IR0 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   XCH_IR1 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   XCH_R0 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   XCH_R1 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   XCH_R2 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   XCH_R3 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   XCH_R4 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   XCH_R5 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   XCH_R6 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   XCH_R7 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   
   //-----------------------------------
   // D0h
   //-----------------------------------
   POP :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   ACALL_6 :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0110 ; 
      end
   SETB_BIT :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   SETB_C :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   DA_A :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   DJNZ_ADDR :
      begin
      nr_bytes_a = 2'b11 ; 
      nr_cycles_a = 4'b0100 ; 
      end
   XCHD_IR0 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   XCHD_IR1 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   DJNZ_R0 :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   DJNZ_R1 :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   DJNZ_R2 :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   DJNZ_R3 :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   DJNZ_R4 :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   DJNZ_R5 :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   DJNZ_R6 :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   DJNZ_R7 :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   
   //-----------------------------------
   // E0h
   //-----------------------------------
   MOVX_A_IDPTR :
      begin
      nr_bytes_a = 2'b01 ; 
      case (stretch)
      3'b000 :
         begin
         nr_cycles_a = 4'b0011 ; 
         end
      3'b001 :
         begin
         nr_cycles_a = 4'b0100 ; 
         end
      3'b010 :
         begin
         nr_cycles_a = 4'b0101 ; 
         end
      3'b011 :
         begin
         nr_cycles_a = 4'b0110 ; 
         end
      3'b100 :
         begin
         nr_cycles_a = 4'b0111 ; 
         end
      3'b101 :
         begin
         nr_cycles_a = 4'b1000 ; 
         end
      3'b110 :
         begin
         nr_cycles_a = 4'b1001 ; 
         end
      default :
         begin
         nr_cycles_a = 4'b1010 ; 
         end
      endcase 
      end
   AJMP_7 :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   MOVX_A_IR0 :
      begin
      nr_bytes_a = 2'b01 ; 
      case (stretch)
      3'b000 :
         begin
         nr_cycles_a = 4'b0011 ; 
         end
      3'b001 :
         begin
         nr_cycles_a = 4'b0100 ; 
         end
      3'b010 :
         begin
         nr_cycles_a = 4'b0101 ; 
         end
      3'b011 :
         begin
         nr_cycles_a = 4'b0110 ; 
         end
      3'b100 :
         begin
         nr_cycles_a = 4'b0111 ; 
         end
      3'b101 :
         begin
         nr_cycles_a = 4'b1000 ; 
         end
      3'b110 :
         begin
         nr_cycles_a = 4'b1001 ; 
         end
      default :
         begin
         nr_cycles_a = 4'b1010 ; 
         end
      endcase 
      end
   MOVX_A_IR1 :
      begin
      nr_bytes_a = 2'b01 ; 
      case (stretch)
      3'b000 :
         begin
         nr_cycles_a = 4'b0011 ; 
         end
      3'b001 :
         begin
         nr_cycles_a = 4'b0100 ; 
         end
      3'b010 :
         begin
         nr_cycles_a = 4'b0101 ; 
         end
      3'b011 :
         begin
         nr_cycles_a = 4'b0110 ; 
         end
      3'b100 :
         begin
         nr_cycles_a = 4'b0111 ; 
         end
      3'b101 :
         begin
         nr_cycles_a = 4'b1000 ; 
         end
      3'b110 :
         begin
         nr_cycles_a = 4'b1001 ; 
         end
      default :
         begin
         nr_cycles_a = 4'b1010 ; 
         end
      endcase 
      end
   CLR_A :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   MOV_A_ADDR :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   MOV_A_IR0 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   MOV_A_IR1 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   MOV_A_R0 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   MOV_A_R1 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   MOV_A_R2 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   MOV_A_R3 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   MOV_A_R4 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   MOV_A_R5 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   MOV_A_R6 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   MOV_A_R7 :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   
   //-----------------------------------
   // F0h
   //-----------------------------------
   MOVX_IDPTR_A :
      begin
      nr_bytes_a = 2'b01 ; 
      case (stretch)
      3'b000 :
         begin
         nr_cycles_a = 4'b0100 ; 
         end
      3'b001 :
         begin
         nr_cycles_a = 4'b0101 ; 
         end
      3'b010 :
         begin
         nr_cycles_a = 4'b0110 ; 
         end
      3'b011 :
         begin
         nr_cycles_a = 4'b0111 ; 
         end
      3'b100 :
         begin
         nr_cycles_a = 4'b1000 ; 
         end
      3'b101 :
         begin
         nr_cycles_a = 4'b1001 ; 
         end
      3'b110 :
         begin
         nr_cycles_a = 4'b1010 ; 
         end
      default :
         begin
         nr_cycles_a = 4'b1011 ; 
         end
      endcase 
      end
   ACALL_7 :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0110 ; 
      end
   MOVX_IR0_A :
      begin
      nr_bytes_a = 2'b01 ; 
      case (stretch)
      3'b000 :
         begin
         nr_cycles_a = 4'b0100 ; 
         end
      3'b001 :
         begin
         nr_cycles_a = 4'b0101 ; 
         end
      3'b010 :
         begin
         nr_cycles_a = 4'b0110 ; 
         end
      3'b011 :
         begin
         nr_cycles_a = 4'b0111 ; 
         end
      3'b100 :
         begin
         nr_cycles_a = 4'b1000 ; 
         end
      3'b101 :
         begin
         nr_cycles_a = 4'b1001 ; 
         end
      3'b110 :
         begin
         nr_cycles_a = 4'b1010 ; 
         end
      default :
         begin
         nr_cycles_a = 4'b1011 ; 
         end
      endcase 
      end
   MOVX_IR1_A :
      begin
      nr_bytes_a = 2'b01 ; 
      case (stretch)
      3'b000 :
         begin
         nr_cycles_a = 4'b0100 ; 
         end
      3'b001 :
         begin
         nr_cycles_a = 4'b0101 ; 
         end
      3'b010 :
         begin
         nr_cycles_a = 4'b0110 ; 
         end
      3'b011 :
         begin
         nr_cycles_a = 4'b0111 ; 
         end
      3'b100 :
         begin
         nr_cycles_a = 4'b1000 ; 
         end
      3'b101 :
         begin
         nr_cycles_a = 4'b1001 ; 
         end
      3'b110 :
         begin
         nr_cycles_a = 4'b1010 ; 
         end
      default :
         begin
         nr_cycles_a = 4'b1011 ; 
         end
      endcase 
      end
   CPL_A :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   MOV_ADDR_A :
      begin
      nr_bytes_a = 2'b10 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   MOV_IR0_A :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   MOV_IR1_A :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0011 ; 
      end
   MOV_R0_A :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   MOV_R1_A :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   MOV_R2_A :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   MOV_R3_A :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   MOV_R4_A :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   MOV_R5_A :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   MOV_R6_A :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   MOV_R7_A :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0010 ; 
      end
   default :
      begin
      nr_bytes_a = 2'b01 ; 
      nr_cycles_a = 4'b0001 ; 
      end
   endcase 
   end 

   //------------------------------------------------------------------
   // Instruction decoder
   // Sequential part
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : nr_decoder_proc
   //------------------------------------------------------------------ 
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      nr_bytes <= 2'b01 ; 
      nr_cycles <= 4'b0001 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // nr_bytes and nr_cycles flip-flops
      //--------------------------------
      begin
      if (stoppmu)
         begin
         nr_bytes <= 2'b01;  // NOP
         nr_cycles <= 4'b0001; // NOP
         end
      if (code_fetch_e & mempsack)
         begin
         if (intreq) // Interrupt request
            begin
            nr_bytes <= 2'b11 ; 
            nr_cycles <= 4'b0110 ; 
            end
         else
            begin
            nr_bytes <= nr_bytes_a ; 
            nr_cycles <= nr_cycles_a ; 
            end 
         end 
      end  
   end 
   
   
endmodule

//*******************************************************************--
