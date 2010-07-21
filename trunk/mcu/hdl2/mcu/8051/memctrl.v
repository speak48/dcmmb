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
// File name            : memctrl.v
// File contents        : Module MEMORY_CONTROL
// Purpose              : External data memory control
//                        External program memory control
//                        External I/O devices control
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
// 1.02.E00   :
// 2000-02-02 : Modified addrbuf driver in respect to the
//            : intcall input
// 1.02.E00   : 
// 2000-02-04 : Modified pcince driver in respect to the
//            : inerrupt LCALL
// 1.10.E00   :
// 2001-09-03 : Added dptr1 and dps registers
//            : Modified dptr depend logic
//            : Added mempsrdrst from PMU
// 1.10.E01   :
// 2001-11-13 : Modified pc, memaddr reset value from 
//            : hard-coded value on constant
// 2001-11-13 : igh ordered half of address during indirect addressing
//            : from hard-coded value on constant
// 1.10.V03   :
// 2002-01-04 : Added mempsack port and modified mempsack related logic
//*******************************************************************--

module MEMORY_CONTROL (
   clk,
   rst,
   mempsack,
   instr,
   cycle,
   codefetche,
   datafetche,
   accreg,
   bitvalue,
   cdjump,
   cyflag,
   stretch,
   intreq,
   intcall,
   intvect,
   ramdatai,
   mempsrdrst,
   mem2acc,
   pclreg,
   pchreg,
   ram2memaddr,
   memdatai,
   memdatao,
   memaddr,
   mempswr,
   mempsrd,
   memwr,
   memrd,
   sfrdatai,
   sfrdatamcu,
   sfraddr,
   sfrwe
   );
   
   
   //  Declarations
   `include "utility.v"
   
   
   //  Control signals inputs
   input    clk;           // Global clock input
   input    rst;           // Global reset input
   
   //  External memory read/write acknowledge input
   input    mempsack;
   
   //  CPU input signals
   input    [7:0] instr; 
   input    [3:0] cycle; 
   input    codefetche;    // Opcode fetch enable
   input    datafetche;    // Data fertch enable
   
   //  ALU input signals
   input    [7:0] accreg; 
   input    bitvalue; 
   input    cdjump; 
   input    cyflag; 
   
   //  Clock Control input signals
   input    [2:0] stretch; 
   
   //  ISR input signals
   input    intreq;        // Interrupt request
   input    intcall;       // Interrupt call
   input    [4:0] intvect; 
   
   //  Internal Data Memory input
   input    [7:0] ramdatai; 
   
   //  Power Management Unit input signals
   input    mempsrdrst;    // memory read signal reset
   
   // ALU control output
   output   mem2acc;       // Memory to ACC write enable
   reg      mem2acc;
   
   //  RAM_SFR control outputs
   output   [7:0] pclreg; 
   wire     [7:0] pclreg;
   output   [7:0] pchreg; 
   wire     [7:0] pchreg;
   output   ram2memaddr;   // RAM to MemAddr write enable
   reg      ram2memaddr;
   
   //  Memory interface
   input    [7:0] memdatai; 
   output   [7:0] memdatao; 
   wire     [7:0] memdatao;
   output   [15:0] memaddr; 
   reg      [15:0] memaddr;
   output   mempswr;       // Program store write enable
   reg      mempswr;
   output   mempsrd;       // Program store read enable
   reg      mempsrd;
   output   memwr;         // Memory write enable
   reg      memwr;
   output   memrd;         // Memory read enable
   reg      memrd;
   
   //  Special function register interface
   input    [7:0] sfrdatai; 
   output   [7:0] sfrdatamcu; 
   wire     [7:0] sfrdatamcu;
   input    [6:0] sfraddr; 
   input    sfrwe; 

   //---------------------------------------------------------------
   // Registers
   //---------------------------------------------------------------
   // Program Counter register
   reg      [15:0] pc; 
   reg      [15:0] pc_inc; 
   reg      [15:0] pc_add; 
   reg      [15:0] pc_rel; 
   
   // Data Pointer registers
   reg      [15:0] dptr; 
   reg      [15:0] dp_inc; 
   reg      [15:0] dp_add; 
   
   // Data Pointer 1 registers
   reg      [15:0] dptr1;
   reg      [15:0] dp1_inc;
   reg      [15:0] dp1_add;
   
   // Data Pointer select register
   reg      [7:0] dps;
   
   // Address Buffer register
   reg      [15:0] addrbuff; 
   
   // Realtive address register
   reg      [7:0] rel; 
   
   //---------------------------------------------------------------
   // Control signals
   //---------------------------------------------------------------
   // Program Counter control signals
   reg      pcince; // PC increment enable
   wire     pcrele; // PC + REL count enable
   
   // Data Pointer control signals
   wire     dpince; // DPTR increment enable
   wire     dpadde; // DPTR + A count enable
   wire     dplwe; // DPTR low byte write enable
   wire     dphwe; // DPTR high byte write enable
   
   // Address Buffer control signals
   wire     membufflwe; // Memory to Buffer low write en.
   wire     membuffhwe; // Memory to Buffer high write en.
   wire     rambufflwe; // RAM to Buffer low write en.
   wire     rambuffhwe; // RAM to Buffer high write en.
   wire     instrbuffwe; // Instr. to Buffer high write en.
   
   // Memory Address control signals
   wire     pcaddsel; // PC + A count enable
   wire     dpaddsel; // DPTR + A count enable
   wire     dpsel; // DPTR select
   wire     risel; // Ri select
   wire     buffsel; // Buffer select
   
   // Relative Address control signals
   wire     relwe; // Rel register write enable
   
   // Opcode fetch enable for MOVC instructions
   reg      storefetche; 

   //------------------------------------------------------------------
   // Program counter low byte output
   //------------------------------------------------------------------
   assign pclreg = pc[7:0] ; 
   
   //------------------------------------------------------------------
   // Program counter low byte output
   //------------------------------------------------------------------
   assign pchreg = pc[15:8] ; 

   //------------------------------------------------------------------
   // PC increment enable
   // PC=PC+1
   //------------------------------------------------------------------
   always @(codefetche or datafetche or intreq or intcall or mempsack)
   begin : pcince_hand
   //------------------------------------------------------------------
   if (
         mempsack &
         (
            (codefetche & ~intreq) |
            (datafetche & ~intcall)
         )
      )
      begin
      pcince = 1'b1 ; 
      end
   else
      begin
      pcince = 1'b0 ; 
      end 
   end 
   
   //------------------------------------------------------------------
   // PC + REL count enable
   // PC=PC+REL
   // MEMADDR=PC+REL
   //------------------------------------------------------------------
   assign pcrele = 
      ((instr == SJMP & cycle == 2) |
      (instr == JZ & cycle == 2 & accreg == 8'b00000000) |
      (instr == JNZ & cycle == 2 & ~(accreg == 8'b00000000)) |
      (instr == JC & cycle == 2 & cyflag) |
      (instr == JNC & cycle == 2 & !cyflag) |
      (instr == JB_BIT & cycle == 3 & bitvalue) |
      (instr == JNB_BIT & cycle == 3 & !bitvalue) |
      (instr == JBC_BIT & cycle == 3 & bitvalue) |
      (instr == CJNE_A_ADDR & cycle == 3 & cdjump) |
      (instr == CJNE_A_N & cycle == 3 & cdjump) |
      (instr == CJNE_R0_N & cycle == 3 & cdjump) |
      (instr == CJNE_R1_N & cycle == 3 & cdjump) |
      (instr == CJNE_R2_N & cycle == 3 & cdjump) |
      (instr == CJNE_R3_N & cycle == 3 & cdjump) |
      (instr == CJNE_R4_N & cycle == 3 & cdjump) |
      (instr == CJNE_R5_N & cycle == 3 & cdjump) |
      (instr == CJNE_R6_N & cycle == 3 & cdjump) |
      (instr == CJNE_R7_N & cycle == 3 & cdjump) |
      (instr == CJNE_IR0_N & cycle == 3 & cdjump) |
      (instr == CJNE_IR1_N & cycle == 3 & cdjump) |
      (instr == DJNZ_R0 & cycle == 2 & cdjump) |
      (instr == DJNZ_R1 & cycle == 2 & cdjump) |
      (instr == DJNZ_R2 & cycle == 2 & cdjump) |
      (instr == DJNZ_R3 & cycle == 2 & cdjump) |
      (instr == DJNZ_R4 & cycle == 2 & cdjump) |
      (instr == DJNZ_R5 & cycle == 2 & cdjump) |
      (instr == DJNZ_R6 & cycle == 2 & cdjump) |
      (instr == DJNZ_R7 & cycle == 2 & cdjump) |
      (instr == DJNZ_ADDR & cycle == 3 & cdjump)) ? 1'b1
      : 1'b0 ; 
   
   //------------------------------------------------------------------
   // DPTR increment enable
   // DPTR=DPTR+1
   //------------------------------------------------------------------
   assign dpince = (mempsack & instr == INC_DPTR & cycle == 1)
      ? 1'b1 : 1'b0 ; 
   
   //------------------------------------------------------------------
   // DPTR + A count enable
   // PC=DPTR+A
   //------------------------------------------------------------------
   assign dpadde = (instr == JMP_A_DPTR & cycle == 1)
      ? 1'b1 : 1'b0 ; 
   
   //------------------------------------------------------------------
   // DPTR low byte write enable
   //------------------------------------------------------------------
   assign dplwe = (mempsack & instr == MOV_DPTR_N & cycle == 2)
      ? 1'b1 : 1'b0 ; 
   
   //------------------------------------------------------------------
   // DPTR high byte write enable
   //------------------------------------------------------------------
   assign dphwe = (mempsack & instr == MOV_DPTR_N & cycle == 1)
      ? 1'b1 : 1'b0 ; 
   
   //------------------------------------------------------------------
   // Memory to Buffer low write enable
   //------------------------------------------------------------------
   assign membufflwe =
      ((instr == ACALL_0 & cycle == 1) |
      (instr == ACALL_1 & cycle == 1) |
      (instr == ACALL_2 & cycle == 1) |
      (instr == ACALL_3 & cycle == 1) |
      (instr == ACALL_4 & cycle == 1) |
      (instr == ACALL_5 & cycle == 1) |
      (instr == ACALL_6 & cycle == 1) |
      (instr == ACALL_7 & cycle == 1) |
      (instr == LCALL & cycle == 2) |
      (instr == AJMP_0 & cycle == 1) |
      (instr == AJMP_1 & cycle == 1) |
      (instr == AJMP_2 & cycle == 1) |
      (instr == AJMP_3 & cycle == 1) |
      (instr == AJMP_4 & cycle == 1) |
      (instr == AJMP_5 & cycle == 1) |
      (instr == AJMP_6 & cycle == 1) |
      (instr == AJMP_7 & cycle == 1) |
      (instr == LJMP & cycle == 2)) ? 1'b1
      : 1'b0 ; 
   
   //------------------------------------------------------------------
   // Memory to Buffer high write enable
   //------------------------------------------------------------------
   assign membuffhwe =
      ((instr == LCALL & cycle == 1) |
      (instr == LJMP & cycle == 1)) ? 1'b1
      : 1'b0 ; 
   
   //------------------------------------------------------------------
   // RAM to Buffer low write enable
   //------------------------------------------------------------------
   assign rambufflwe =
      ((instr == RET & cycle == 2) |
      (instr == RETI & cycle == 2)) ? 1'b1
      : 1'b0 ; 
   
   //------------------------------------------------------------------
   // RAM to Buffer high write enable
   //------------------------------------------------------------------
   assign rambuffhwe =
      ((instr == RET & cycle == 1) |
      (instr == RETI & cycle == 1)) ? 1'b1
      : 1'b0 ; 
   
   //------------------------------------------------------------------
   // Instruction opcode to Buffer high write enable
   //------------------------------------------------------------------
   assign instrbuffwe =
      ((instr == ACALL_0 & cycle == 1) |
      (instr == ACALL_1 & cycle == 1) |
      (instr == ACALL_2 & cycle == 1) |
      (instr == ACALL_3 & cycle == 1) |
      (instr == ACALL_4 & cycle == 1) |
      (instr == ACALL_5 & cycle == 1) |
      (instr == ACALL_6 & cycle == 1) |
      (instr == ACALL_7 & cycle == 1) |
      (instr == AJMP_0 & cycle == 1) |
      (instr == AJMP_1 & cycle == 1) |
      (instr == AJMP_2 & cycle == 1) |
      (instr == AJMP_3 & cycle == 1) |
      (instr == AJMP_4 & cycle == 1) |
      (instr == AJMP_5 & cycle == 1) |
      (instr == AJMP_6 & cycle == 1) |
      (instr == AJMP_7 & cycle == 1)) ? 1'b1
      : 1'b0 ; 
   
   //------------------------------------------------------------------
   // PC + A count enable
   //------------------------------------------------------------------
   assign pcaddsel =
      (instr == MOVC_A_PC &
         (
            cycle == 1 |
            (cycle == 2 & !mempsack)
         )
      ) ? 1'b1
      : 1'b0 ; 
   
   //------------------------------------------------------------------
   // DPTR + A count enable
   // MEMADDR=DPTR+A
   //------------------------------------------------------------------
   assign dpaddsel =
      (
         (instr == JMP_A_DPTR & cycle == 1) |
         (
            instr == MOVC_A_DPTR &
            (
               cycle == 1 |
               (cycle == 2 & !mempsack)
            )
         )
      ) ? 1'b1 : 1'b0 ; 
   
   //------------------------------------------------------------------
   // DPTR select
   // MEMADDR=DPTR
   //------------------------------------------------------------------
   assign dpsel =
      (
         (instr == MOVX_A_IDPTR) &
         (
            ((stretch == 3'b000) & (cycle == 1)) |
            ((stretch == 3'b001) & (cycle == 1 | cycle == 2)) |
            ((stretch == 3'b010) & (cycle == 1 | cycle == 2 |
                                                 cycle == 3)) |
            ((stretch == 3'b011) & (cycle == 1 | cycle == 2 |
                                                 cycle == 3 |
                                                 cycle == 4)) |
            ((stretch == 3'b100) & (cycle == 1 | cycle == 2 |
                                                 cycle == 3 |
                                                 cycle == 4 |
                                                 cycle == 5)) |
            ((stretch == 3'b101) & (cycle == 1 | cycle == 2 |
                                                 cycle == 3 |
                                                 cycle == 4 |
                                                 cycle == 5 |
                                                 cycle == 6)) |
            ((stretch == 3'b110) & (cycle == 1 | cycle == 2 |
                                                 cycle == 3 |
                                                 cycle == 4 |
                                                 cycle == 5 |
                                                 cycle == 6 |
                                                 cycle == 7)) |
            ((stretch == 3'b111) & (cycle == 1 | cycle == 2 |
                                                 cycle == 3 |
                                                 cycle == 4 |
                                                 cycle == 5 |
                                                 cycle == 6 |
                                                 cycle == 7 |
                                                 cycle == 8))
            )
      ) ? 1'b1
      :(
         (instr == MOVX_IDPTR_A) &
         (
            ((stretch == 3'b000) & (cycle == 1 | cycle == 2)) |
            ((stretch == 3'b001) & (cycle == 1 | cycle == 2 |
                                                 cycle == 3)) |
            ((stretch == 3'b010) & (cycle == 1 | cycle == 2 |
                                                 cycle == 3 |
                                                 cycle == 4)) |
            ((stretch == 3'b011) & (cycle == 1 | cycle == 2 |
                                                 cycle == 3 |
                                                 cycle == 4 |
                                                 cycle == 5)) |
            ((stretch == 3'b100) & (cycle == 1 | cycle == 2 |
                                                 cycle == 3 |
                                                 cycle == 4 |
                                                 cycle == 5 |
                                                 cycle == 6)) |
            ((stretch == 3'b101) & (cycle == 1 | cycle == 2 |
                                                 cycle == 3 |
                                                 cycle == 4 |
                                                 cycle == 5 |
                                                 cycle == 6 |
                                                 cycle == 7)) |
            ((stretch == 3'b110) & (cycle == 1 | cycle == 2 |
                                                 cycle == 3 |
                                                 cycle == 4 |
                                                 cycle == 5 |
                                                 cycle == 6 |
                                                 cycle == 7 |
                                                 cycle == 8)) |
            ((stretch == 3'b111) & (cycle == 1 | cycle == 2 |
                                                 cycle == 3 |
                                                 cycle == 4 |
                                                 cycle == 5 |
                                                 cycle == 6 |
                                                 cycle == 7 |
                                                 cycle == 8 |
                                                 cycle == 9))
         )
      ) ? 1'b1
      : 1'b0 ; 
   
   //------------------------------------------------------------------
   // Ri select
   // MEMADDR low = Ri
   //------------------------------------------------------------------
   assign risel =
      (
         (instr == MOVX_A_IR0 | instr == MOVX_A_IR1) &
         (
            ((stretch == 3'b000) & (cycle == 1)) |
            ((stretch == 3'b001) & (cycle == 1 | cycle == 2)) |
            ((stretch == 3'b010) & (cycle == 1 | cycle == 2 |
                                                 cycle == 3)) |
            ((stretch == 3'b011) & (cycle == 1 | cycle == 2 |
                                                 cycle == 3 |
                                                 cycle == 4)) |
            ((stretch == 3'b100) & (cycle == 1 | cycle == 2 |
                                                 cycle == 3 |
                                                 cycle == 4 |
                                                 cycle == 5)) |
            ((stretch == 3'b101) & (cycle == 1 | cycle == 2 |
                                                 cycle == 3 |
                                                 cycle == 4 |
                                                 cycle == 5 |
                                                 cycle == 6)) |
            ((stretch == 3'b110) & (cycle == 1 | cycle == 2 |
                                                 cycle == 3 |
                                                 cycle == 4 |
                                                 cycle == 5 |
                                                 cycle == 6 |
                                                 cycle == 7)) |
            ((stretch == 3'b111) & (cycle == 1 | cycle == 2 |
                                                 cycle == 3 |
                                                 cycle == 4 |
                                                 cycle == 5 |
                                                 cycle == 6 |
                                                 cycle == 7 |
                                                 cycle == 8))
         )
      ) ? 1'b1
      : (
         (instr == MOVX_IR0_A | instr == MOVX_IR1_A) & 
         (
            ((stretch == 3'b000) & (cycle == 1 | cycle == 2)) |
            ((stretch == 3'b001) & (cycle == 1 | cycle == 2 |
                                                 cycle == 3)) |
            ((stretch == 3'b010) & (cycle == 1 | cycle == 2 |
                                                 cycle == 3 |
                                                 cycle == 4)) |
            ((stretch == 3'b011) & (cycle == 1 | cycle == 2 |
                                                 cycle == 3 |
                                                 cycle == 4 |
                                                 cycle == 5)) |
            ((stretch == 3'b100) & (cycle == 1 | cycle == 2 |
                                                 cycle == 3 |
                                                 cycle == 4 |
                                                 cycle == 5 |
                                                 cycle == 6)) |
            ((stretch == 3'b101) & (cycle == 1 | cycle == 2 |
                                                 cycle == 3 |
                                                 cycle == 4 |
                                                 cycle == 5 |
                                                 cycle == 6 |
                                                 cycle == 7)) |
            ((stretch == 3'b110) & (cycle == 1 | cycle == 2 |
                                                 cycle == 3 |
                                                 cycle == 4 |
                                                 cycle == 5 |
                                                 cycle == 6 |
                                                 cycle == 7 |
                                                 cycle == 8)) |
            ((stretch == 3'b111) & (cycle == 1 | cycle == 2 |
                                                 cycle == 3 |
                                                 cycle == 4 |
                                                 cycle == 5 |
                                                 cycle == 6 |
                                                 cycle == 7 |
                                                 cycle == 8 |
                                                 cycle == 9))
         )
      ) ? 1'b1
      : 1'b0 ; 
   
   //------------------------------------------------------------------
   // Buffer to PC write enable
   // Buffer to Memory Address write enable
   //------------------------------------------------------------------
   assign buffsel =
      ((instr == ACALL_0 & cycle == 5) |
      (instr == ACALL_1 & cycle == 5) |
      (instr == ACALL_2 & cycle == 5) |
      (instr == ACALL_3 & cycle == 5) |
      (instr == ACALL_4 & cycle == 5) |
      (instr == ACALL_5 & cycle == 5) |
      (instr == ACALL_6 & cycle == 5) |
      (instr == ACALL_7 & cycle == 5) |
      (instr == LCALL & cycle == 5) |
      (instr == RET & cycle == 3) |
      (instr == RETI & cycle == 3) |
      (instr == AJMP_0 & cycle == 2) |
      (instr == AJMP_1 & cycle == 2) |
      (instr == AJMP_2 & cycle == 2) |
      (instr == AJMP_3 & cycle == 2) |
      (instr == AJMP_4 & cycle == 2) |
      (instr == AJMP_5 & cycle == 2) |
      (instr == AJMP_6 & cycle == 2) |
      (instr == AJMP_7 & cycle == 2) |
      (instr == LJMP & cycle == 3)) ? 1'b1
      : 1'b0 ; 
   
   //------------------------------------------------------------------
   // Rel register write enable
   //------------------------------------------------------------------
   assign relwe =
      ((instr == SJMP & cycle == 1) |
      (instr == JZ & cycle == 1) |
      (instr == JNZ & cycle == 1) |
      (instr == JC & cycle == 1) |
      (instr == JNC & cycle == 1) |
      (instr == JB_BIT & cycle == 2) |
      (instr == JNB_BIT & cycle == 2) |
      (instr == CJNE_A_ADDR & cycle == 2) |
      (instr == CJNE_A_N & cycle == 2) |
      (instr == CJNE_R0_N & cycle == 2) |
      (instr == CJNE_R1_N & cycle == 2) |
      (instr == CJNE_R2_N & cycle == 2) |
      (instr == CJNE_R3_N & cycle == 2) |
      (instr == CJNE_R4_N & cycle == 2) |
      (instr == CJNE_R5_N & cycle == 2) |
      (instr == CJNE_R6_N & cycle == 2) |
      (instr == CJNE_R7_N & cycle == 2) |
      (instr == CJNE_IR0_N & cycle == 2) |
      (instr == CJNE_IR1_N & cycle == 2) |
      (instr == DJNZ_R0 & cycle == 1) |
      (instr == DJNZ_R1 & cycle == 1) |
      (instr == DJNZ_R2 & cycle == 1) |
      (instr == DJNZ_R3 & cycle == 1) |
      (instr == DJNZ_R4 & cycle == 1) |
      (instr == DJNZ_R5 & cycle == 1) |
      (instr == DJNZ_R6 & cycle == 1) |
      (instr == DJNZ_R7 & cycle == 1) |
      (instr == DJNZ_ADDR & cycle == 2) |
      (instr == JBC_BIT & cycle == 2)) ? 1'b1
      : 1'b0 ; 

   //------------------------------------------------------------------
   // Program Counter incremented buffer
   //------------------------------------------------------------------
   always @(pc)
   begin : pc_inc_proc
   //------------------------------------------------------------------
   pc_inc = pc + 1'b1 ; 
   end 

   //------------------------------------------------------------------
   // Program Counter added buffer
   //------------------------------------------------------------------
   always @(pc or accreg)
   begin : pc_add_hand
   //------------------------------------------------------------------
   pc_add = pc + accreg ; 
   end 

   //------------------------------------------------------------------
   // Program Counter Relative added buffer
   //------------------------------------------------------------------
   always @(pc or rel)
   begin : pc_rel_hand
   //------------------------------------------------------------------
   pc_rel = pc + {rel[7], rel[7], rel[7], rel[7],
                  rel[7], rel[7], rel[7], rel[7], rel}; 
   end 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : pc_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      pc <= ADDR_RV;
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Special function register write
      //--------------------------------
      begin
      if (pcince)       // PC=PC+1
         begin
         pc <= pc_inc ; 
         end
      else if (pcrele)  // PC=PC+rel
         begin
         pc <= pc_rel ; 
         end
      else if (dpadde)  // PC=DPTR+A
         begin
         if (~dps[0])
            begin
            pc <= dp_add;
            end
         else
            begin
            pc <= dp1_add;
            end
         end
      else if (buffsel) // PC=Buffer
         begin
         pc <= addrbuff ; 
         end 
      end  
   end 

   //------------------------------------------------------------------
   // Data Pointer incremented buffer
   //------------------------------------------------------------------
   always @(dptr)
   begin : dp_inc_proc
   //------------------------------------------------------------------
   dp_inc = dptr + 1'b1 ; 
   end 

   //------------------------------------------------------------------
   // Data Pointer 1 incremented buffer
   //------------------------------------------------------------------
   always @(dptr1)
   begin : dp1inc_proc
   //------------------------------------------------------------------
   dp1_inc = dptr1 + 1'b1;
   end

   //------------------------------------------------------------------
   // Data Pointer added buffer
   //------------------------------------------------------------------
   always @(dptr or accreg)
   begin : dp_add_hand
   //------------------------------------------------------------------
   dp_add = dptr + accreg ; 
   end 

   //------------------------------------------------------------------
   // Data Pointer 1 added buffer
   //------------------------------------------------------------------
   always @(dptr1 or accreg)
   begin : dp1_add_hand
   //------------------------------------------------------------------
   dp1_add = dptr1 + accreg;
   end

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : dp_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      dptr[7:0]  <= DPL_RV ; 
      dptr[15:8] <= DPH_RV ; 
      dptr1[7:0]  <= DPL1_RV;
      dptr1[15:8] <= DPH1_RV;
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Data Pointer increment or load
      //--------------------------------
      begin
      if (dpince)    // DPTR=DPTR+1
         begin
         if (~dps[0])   // DPTR select
            begin
            dptr <= dp_inc ; 
            end
         else
            begin
            dptr1 <= dp1_inc ; 
            end
         end
      else if (dplwe)
         begin
         if (~dps[0])   // DPTR select
            begin
            dptr[7:0] <= memdatai ; 
            end
         else
            begin
            dptr1[7:0] <= memdatai ; 
            end
         end
      else if (dphwe)
         begin
         if (~dps[0])   // DPTR select
            begin
            dptr[15:8] <= memdatai ; 
            end
         else
            begin
            dptr1[15:8] <= memdatai ; 
            end
         end
      else
         //--------------------------------
         // Special function register write
         //--------------------------------
         begin
         if (sfrwe & sfraddr == DPL_ID)
            begin
            dptr[7:0] <= sfrdatai ; 
            end 
         
         if (sfrwe & sfraddr == DPH_ID)
            begin
            dptr[15:8] <= sfrdatai ; 
            end 
            
         if (sfrwe & sfraddr == DPL1_ID)
            begin
            dptr1[7:0] <= sfrdatai ; 
            end 
         
         if (sfrwe & sfraddr == DPH1_ID)
            begin
            dptr1[15:8] <= sfrdatai ; 
            end 
         end 
      end  
   end 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : dps_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      dps[7:0] <= DPS_RV;
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Special function register write
      //--------------------------------
      begin
      if (sfrwe & sfraddr==DPS_ID)
         begin
         dps[7:0] <= sfrdatai;
         end
      end
   end

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : memaddr_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      memaddr <= ADDR_RV;
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Special function register write
      //--------------------------------
      begin
      if (pcince)          // ADDR=PC+1
         begin
         memaddr <= pc_inc ; 
         end
      else if (pcrele)     // ADDR=PC+rel
         begin
         memaddr <= pc_rel ; 
         end
      else if (pcaddsel)   // ADDR=PC+A
         begin
         memaddr <= pc_add ; 
         end
      else if (dpaddsel)   // ADDR=DPTR+A
         begin
         if (~dps[0])
            begin
            memaddr <= dp_add;
            end
         else
            begin
            memaddr <= dp1_add;
            end
         end
      else if (dpsel)      // ADDR=DPTR
         begin
         if (~dps[0])
            begin
            memaddr <= dptr ; 
            end
         else
            begin
            memaddr <= dptr1 ; 
            end
         end
      else if (risel)      // ADDR(low)=Ri
         begin
         memaddr[15:8] <= ADDR_HIGH_RI;
         memaddr[7:0] <= ramdatai ; 
         end
      else if (buffsel)    // ADDR=Buffer
         begin
         memaddr <= addrbuff ; 
         end
      else                 // ADDR=PC
         begin
         memaddr <= pc ; 
         end 
      end  
   end 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : rel_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      rel <= 8'b00000000 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Relative address register write
      //--------------------------------
      begin
      if (relwe)
         begin
         rel <= memdatai ; 
         end 
      end  
   end 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : buff_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      addrbuff <= 16'b0000000000000000 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Address buffer register write
      //--------------------------------
      begin
      if (intcall)      // Interrupt call
         begin
         addrbuff[7:0] <= {intvect, 3'b011} ; 
         end
      else if (membufflwe)
         begin
         addrbuff[7:0] <= memdatai ; 
         end
      else if (rambufflwe)
         begin
         addrbuff[7:0] <= ramdatai ; 
         end 
      if (intcall)      // Interrupt call
         begin
         addrbuff[15:8] <= 8'b00000000 ; 
         end
      else if (membuffhwe)
         begin
         addrbuff[15:8] <= memdatai ; 
         end
      else if (rambuffhwe)
         begin
         addrbuff[15:8] <= ramdatai ; 
         end
      else if (instrbuffwe)
         begin
         addrbuff[10:8] <= instr[7:5] ; 
         addrbuff[15:11] <= pc_inc[15:11] ; 
         end 
      end  
   end 

   //------------------------------------------------------------------
   // Memory to ACC write enable
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : mem2acc_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      mem2acc <= 1'b0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      begin
      if (
            (
               (instr == MOVX_A_IR0 |
               instr == MOVX_A_IR1 |
               instr == MOVX_A_IDPTR)
               &
               (
                  (stretch == 3'b000 & cycle == 1) |
                  (stretch == 3'b001 & cycle == 2) |
                  (stretch == 3'b010 & cycle == 3) |
                  (stretch == 3'b011 & cycle == 4) |
                  (stretch == 3'b100 & cycle == 5) |
                  (stretch == 3'b101 & cycle == 6) |
                  (stretch == 3'b110 & cycle == 7) |
                  (stretch == 3'b111 & cycle == 8)
               )
            
            )
            |
            (
               (instr == MOVC_A_PC |
               instr == MOVC_A_DPTR)
               &
               (
                  (cycle == 1) |
                  (cycle == 2 & !mempsack)
               )
            )
         )
         begin
         mem2acc <= 1'b1 ; 
         end
      else
         begin
         mem2acc <= 1'b0 ; 
         end 
      end  
   end 

   //------------------------------------------------------------------
   // RAM to MemAddr write enable
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : ram2memaddr_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      ram2memaddr <= 1'b0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      begin
      if (
            (
               (instr == MOVX_A_IR0) |
               (instr == MOVX_A_IR1)
            )
            &
            (
               ((stretch == 3'b010) & (cycle == 1)) |
               ((stretch == 3'b011) & (cycle == 1 | cycle == 2)) |
               ((stretch == 3'b100) & (cycle == 1 | cycle == 2 |
                                                    cycle == 3)) |
               ((stretch == 3'b101) & (cycle == 1 | cycle == 2 |
                                                    cycle == 3 |
                                                    cycle == 4)) |
               ((stretch == 3'b110) & (cycle == 1 | cycle == 2 |
                                                    cycle == 3 |
                                                    cycle == 4 |
                                                    cycle == 5)) |
               ((stretch == 3'b111) & (cycle == 1 | cycle == 2 |
                                                    cycle == 3 |
                                                    cycle == 4 |
                                                    cycle == 5 |
                                                    cycle == 6))
            )
         )
         begin
         ram2memaddr <= 1'b1 ; 
         end
      else if
         (
            (
               (instr == MOVX_IR0_A) |
               (instr == MOVX_IR1_A)
            )
            &
            (
               ((stretch == 3'b001) & (cycle == 1)) |
               ((stretch == 3'b010) & (cycle == 1 | cycle == 2)) |
               ((stretch == 3'b011) & (cycle == 1 | cycle == 2 |
                                                    cycle == 3)) |
               ((stretch == 3'b100) & (cycle == 1 | cycle == 2 |
                                                    cycle == 3 |
                                                    cycle == 4)) |
               ((stretch == 3'b101) & (cycle == 1 | cycle == 2 |
                                                    cycle == 3 |
                                                    cycle == 4 |
                                                    cycle == 5)) |
               ((stretch == 3'b110) & (cycle == 1 | cycle == 2 |
                                                    cycle == 3 |
                                                    cycle == 4 |
                                                    cycle == 5 |
                                                    cycle == 6)) |
               ((stretch == 3'b111) & (cycle == 1 | cycle == 2 |
                                                    cycle == 3 |
                                                    cycle == 4 |
                                                    cycle == 5 |
                                                    cycle == 6 |
                                                    cycle == 7))
            )
         )
         begin
         ram2memaddr <= 1'b1 ; 
         end
      else
         begin
         ram2memaddr <= 1'b0 ; 
         end 
      end  
   end 

   //------------------------------------------------------------------
   // Program store write enable
   //  still inactive (optional feature)
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : mempswr_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      mempswr <= 1'b0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------  
      begin
      end
   end 

   //------------------------------------------------------------------
   // Program store read enable for MOVC instructions only
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : storefetche_hand_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      storefetche <= 1'b0 ; 
      end
   else
      begin
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      if (
            (
               (cycle == 1) |
               (cycle == 2 & !mempsack)
            ) &
            (
               instr == MOVC_A_PC |
               instr == MOVC_A_DPTR
            )
         )
         begin
         storefetche <= 1'b1 ; 
         end
      else
         begin
         storefetche <= 1'b0 ; 
         end 
      end  
   end 

   //------------------------------------------------------------------
   // Program store read enable
   //  combinational output
   //  high active
   //------------------------------------------------------------------
   always @(mempsrdrst or codefetche or datafetche or storefetche)
   begin : mempsrd_proc
   //------------------------------------------------------------------
   if (mempsrdrst)
      //-----------------------------------
      // Combinational reset
      //-----------------------------------
      begin
      mempsrd = 1'b0 ; 
      end
   else
      begin
      //-----------------------------------
      // Combinational write
      //-----------------------------------
      if (codefetche | datafetche | storefetche)
         begin
         mempsrd = 1'b1 ; 
         end
      else
         begin
         mempsrd = 1'b0 ; 
         end 
      end 
   end 

   //------------------------------------------------------------------
   // Memory write enable
   //  registered output
   //  high active
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : memwr_drv
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      memwr <= 1'b0 ; 
      end
      else
      begin
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      if (
            (
               (instr == MOVX_IR0_A) |
               (instr == MOVX_IR1_A) |
               (instr == MOVX_IDPTR_A)
            )
            &
            (
               ((stretch == 3'b000) & (cycle == 2)) |
               ((stretch == 3'b001) & (cycle == 2)) |
               ((stretch == 3'b010) & (cycle == 2 | cycle == 3)) |
               ((stretch == 3'b011) & (cycle == 2 | cycle == 3 |
                                                    cycle == 4)) |
               ((stretch == 3'b100) & (cycle == 2 | cycle == 3 |
                                                    cycle == 4 |
                                                    cycle == 5)) |
               ((stretch == 3'b101) & (cycle == 2 | cycle == 3 |
                                                    cycle == 4 |
                                                    cycle == 5 |
                                                    cycle == 6)) |
               ((stretch == 3'b110) & (cycle == 2 | cycle == 3 |
                                                    cycle == 4 |
                                                    cycle == 5 |
                                                    cycle == 6 |
                                                    cycle == 7)) |
               ((stretch == 3'b111) & (cycle == 2 | cycle == 3 |
                                                    cycle == 4 |
                                                    cycle == 5 |
                                                    cycle == 6 |
                                                    cycle == 7 |
                                                    cycle == 8))
            )
         )
         begin
         memwr <= 1'b1 ; 
         end
      else
         begin
         memwr <= 1'b0 ; 
         end 
      end  
   end 

   //------------------------------------------------------------------
   // Memory read enable
   //  registered output
   //  high active
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : memrd_drv
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      memrd <= 1'b0 ; 
      end
   else
      begin
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      if (
            (
               (instr == MOVX_A_IR0) |
               (instr == MOVX_A_IR1) |
               (instr == MOVX_A_IDPTR)
            )
            &
            (
               ((stretch == 3'b000) & (cycle == 1)) |
               ((stretch == 3'b001) & (cycle == 1 | cycle == 2)) |
               ((stretch == 3'b010) & (cycle == 1 | cycle == 2 |
                                                    cycle == 3)) |
               ((stretch == 3'b011) & (cycle == 1 | cycle == 2 |
                                                    cycle == 3 |
                                                    cycle == 4)) |
               ((stretch == 3'b100) & (cycle == 1 | cycle == 2 |
                                                    cycle == 3 |
                                                    cycle == 4 |
                                                    cycle == 5)) |
               ((stretch == 3'b101) & (cycle == 1 | cycle == 2 |
                                                    cycle == 3 |
                                                    cycle == 4 |
                                                    cycle == 5 |
                                                    cycle == 6)) |
               ((stretch == 3'b110) & (cycle == 1 | cycle == 2 |
                                                    cycle == 3 |
                                                    cycle == 4 |
                                                    cycle == 5 |
                                                    cycle == 6 |
                                                    cycle == 7)) |
               ((stretch == 3'b111) & (cycle == 1 | cycle == 2 |
                                                    cycle == 3 |
                                                    cycle == 4 |
                                                    cycle == 5 |
                                                    cycle == 6 |
                                                    cycle == 7 |
                                                    cycle == 8))
            )
         )
         begin
         memrd <= 1'b1 ; 
         end
      else
         begin
         memrd <= 1'b0 ; 
         end 
      end  
   end 
   
   //------------------------------------------------------------------
   // Memory Data Bus output
   //------------------------------------------------------------------
   assign memdatao = accreg ; 
   
   //------------------------------------------------------------------
   // Special Function registers read
   //------------------------------------------------------------------
   assign sfrdatamcu =
      (sfraddr == DPL_ID)  ? dptr[7:0] :
      (sfraddr == DPH_ID)  ? dptr[15:8] :
      (sfraddr == DPL1_ID) ? dptr1[7:0] :
      (sfraddr == DPH1_ID) ? dptr1[15:8] :
      (sfraddr == DPS_ID)  ? dps :
      "--------" ; 


endmodule // module MEMORY_CONTROL

//*******************************************************************--

