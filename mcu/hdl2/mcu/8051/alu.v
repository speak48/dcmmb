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
// File name            : alu.v
// File contents        : Module ALU
// Purpose              : Aritmetic Logic Unit
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
// 2000-01-24 : removed databus port
//            : added ramsfrdata, sfrdatai ports
//            : changed combinational_alu_proc: added 
//            : combinational_b1_alu_proc and
//            : combinational_b2_alu_proc
// 1.04.E01   : 
// 2000-05-18 : b1_write_proc: write to b1 modified for DJNZ_ADDR 
// 1.04.E02   : 
// 2000-06-22 : removed redundand construction in bitvalue_proc:
// 1.04.E03   :
// 2000-08-17 : Modified multiplication and division instructions
//            : from 8 to 5 cycles because invalid loading arguments
// 1.10.V03   :
// 2002-01-08 : Added mempsack port and modified mempsack related logic
//*******************************************************************--

module ALU
   (clk,
   rst,
   mempsack,
   instr,
   cycle,
   memdatai,
   mem2acc,
   ramsfrdata,
   accreg,
   aluresult,
   regsbank,
   bitvalue,
   cdjump,
   cyflag,
   sfrdatai,
   sfrdataalu,
   sfraddr,
   sfrwe);

   parameter DATAWIDTH    = 8; // Data bus width
   parameter SFRADDRWIDTH = 7; // SFR address bus width
   parameter BANKWIDTH    = 2; // Data bus width

   //  Declarations
   `include  "utility.v"


   //  Global control signals inputs
   input    clk;              // Global clock input
   input    rst;              // Global reset input
   
   //  External memory read/write acknowledge input
   input    mempsack;
   
   //  CPU input signals
   input    [7:0] instr;      // Instruction
   input    [3:0] cycle;      // Current cycle
   
   //  Memory interface
   input    [7:0] memdatai;   // Memory data bus
   input    mem2acc;          // Memory to ACC write enable
   
   //  RAM Data Bus
   input    [7:0] ramsfrdata; // Peripheral data bus
   
   //  ALU output signals
   output   [7:0] accreg;     // Accumulator output
   wire     [7:0] accreg;
   output   [7:0] aluresult;  // ALU result
   wire     [7:0] aluresult;
   output   [1:0] regsbank;   // Current bank
   wire     [1:0] regsbank;
   output   bitvalue;         // Selected bit value
   reg      bitvalue;
   output   cdjump;           // Condition of jump
   reg      cdjump;
   output   cyflag;           // Carry flag
   wire     cyflag;
   
   //  Special function register interface
   input    [7:0] sfrdatai;   // SFR data bus
   output   [7:0] sfrdataalu; // ALU data bus
   wire     [7:0] sfrdataalu;
   input    [6:0] sfraddr;    // SFR address bus
   input    sfrwe;            // SFR write enable

   
   //------------------------------------------------------------------

   // Main registers
   reg      [7:0] acc;        // Accumulator
   reg      [7:0] b;          // B register
   reg      [7:0] psw;        // PSW register
   
   // ALU operand registers
   reg      [7:0] a1;         // A1 register
   reg      [7:0] a2;         // A2 register
   wire     [7:0] op_a;       // Operand A
   wire     [7:0] op_b;       // Operand B
   wire     op_c;             // Operand C (carry)
   wire     [7:0] bool_op;    // Boolean operand
   
   reg      [2:0] bit_nr;     // bit number
   
   // ALU result registers
   reg      [7:0] b1;         // B1 register
   reg      [7:0] b2;         // B2 register
   reg      [7:0] b3;         // B3 register
   
   // PSW flags
   reg      ac_bit;           // A carry flag
   reg      ov_bit;           // Overflow flag
   wire     parity_bit;       // Parity flag
   
   // Arithmetic result vector
   reg      [8:0] result_b1;  // B1 result
   reg      [8:0] result_b2;  // B2 result
   
   // Boolean result vector
   reg      [7:0] bool_res;   // Boolean result
   
   // Multiplication / division registers
   reg      [7:0] mda;        // MDA register
   reg      [7:0] mdb;        // MDB register
   reg      [8:0] sum;        // result register
   reg      [8:0] sum1;       // result register

   // Variables
   reg      [4:0] b1_res_3_0; 
   reg      [3:0] b1_res_6_4; 
   reg      [1:0] b1_res_8_7; 
   reg      [4:0] b2_res_3_0; 
   reg      [3:0] b2_res_6_4; 
   reg      [1:0] b2_res_8_7; 
   
   //------------------------------------------------------------------
   // ACC register output
   //------------------------------------------------------------------
   assign accreg = acc ; 

   //------------------------------------------------------------------
   // Carry flag output
   //------------------------------------------------------------------
   assign cyflag = psw[7] ; 
   
   //------------------------------------------------------------------
   // Register select bank output
   //------------------------------------------------------------------
   assign regsbank = psw[4:3] ; 

   //------------------------------------------------------------------
   // Accumulator register
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : acc_write_proc
   //------------------------------------------------------------------
   if (rst)
      begin
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      acc <= ACC_RV ; 
      end
   else
      begin
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Special function register write
      //-----------------------------------
      if (sfrwe & sfraddr == ACC_ID)
         begin
         acc <= sfrdatai ; 
         end
      //-----------------------------------
      // ALU operation write
      //-----------------------------------
      else if (mem2acc)
         begin
         if (mempsack)
            begin
            acc <= memdatai ; 
            end
         end
      else
         begin
         case (cycle)
         4'b 0001 :
            begin
            case (instr[7:0])
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
            INC_A, DEC_A :
               begin
               if (mempsack)
                  begin
                  acc <= result_b1[7:0] ; 
                  end
               end
            
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
            DA_A, CLR_A, CPL_A,
            RL_A, RR_A, RLC_A,
            RRC_A, SWAP_A :
               begin
               if (mempsack)
                  begin
                  acc <= result_b2[7:0] ; 
                  end
               end
            
            MOV_A_R0, MOV_A_R1,
            MOV_A_R2, MOV_A_R3,
            MOV_A_R4, MOV_A_R5,
            MOV_A_R6, MOV_A_R7 :
               begin
               if (mempsack)
                  begin
                  acc <= ramsfrdata[7:0] ; 
                  end
               end
            endcase 
            end
         4'b 0010 :
            begin
            case (instr[7:0])
            ADD_N, ADD_ADDR,
            ADD_IR0, ADD_IR1,
            ADDC_N, ADDC_ADDR,
            ADDC_IR0, ADDC_IR1,
            SUBB_N, SUBB_ADDR,
            SUBB_IR0, SUBB_IR1 :
               begin
               if (mempsack)
                  begin
                  acc <= result_b1[7:0] ; 
                  end
               end
            
            ANL_A_N, ANL_A_ADDR,
            ANL_A_IR0, ANL_A_IR1,
            ORL_A_N, ORL_A_ADDR,
            ORL_A_IR0, ORL_A_IR1,
            XRL_A_N, XRL_A_ADDR,
            XRL_A_IR0, XRL_A_IR1 :
               begin
               if (mempsack)
                  begin
                  acc <= result_b2[7:0] ; 
                  end
               end
            
            MOV_A_N :
               begin
               if (mempsack)
                  begin
                  acc <= sfrdatai[7:0] ; 
                  end
               end
               // DR (SFR write)
            
            MOV_A_ADDR, MOV_A_IR0,
            MOV_A_IR1 :
               begin
               if (mempsack)
                  begin
                  acc <= ramsfrdata ; 
                  end
               end
               // RAM,SFR read
            
            XCH_R0, XCH_R1,
            XCH_R2, XCH_R3,
            XCH_R4, XCH_R5,
            XCH_R6, XCH_R7 :
               begin
               acc <= a1 ; 
               end
            
            XCHD_IR0, XCHD_IR1 :
               begin
               acc[3:0] <= ramsfrdata[3:0] ; 
               end
               // databus -- RAM read
            endcase 
            end
         4'b 0011 :
            begin
            case (instr[7:0])
            XCH_ADDR, XCH_IR0,
            XCH_IR1 :
               begin
               acc <= a1 ; 
               end
            endcase 
            end
         4'b 0101 :
            begin
            case (instr[7:0])
            MUL_AB :
               begin
               if (mempsack)
                  begin
                  acc <= {sum1[0], sum[0], mda[7:2]} ; 
                  end
               end
            DIV_AB :
               begin
               if (mempsack)
                  begin
                  acc <= {mda[5:0], sum[8], sum1[8]} ; 
                  end
               end
            endcase 
            end
         endcase 
         end 
      end  
   end 

   //------------------------------------------------------------------
   // B register
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : b_write_proc
   //------------------------------------------------------------------
   if (rst)
      begin
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      b <= B_RV ; 
      end
   else
      begin
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Special function register write
      //-----------------------------------
      if (sfrwe & sfraddr == B_ID)
         begin
         b <= sfrdatai ; 
         end
      else
         //--------------------------------
         // b register operation write
         //--------------------------------
         begin
         case (cycle)
         4'b 0101 :
            begin
            case (instr[7:0])
            MUL_AB :
               begin
               if (mempsack)
                  begin
                  b <= sum1[8:1] ; 
                  end
               end
            DIV_AB :
               begin
               if (mempsack)
                  begin
                  if (sum1[8])
                     begin
                     b <= sum1[7:0] ; 
                     end
                  else if (sum[8])
                     begin
                     b <= {sum[6:0], mda[7]} ; 
                     end
                  else
                     begin
                     b <= {mdb[6:0], mda[7]} ; 
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
   // PSW register
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : psw_write_proc
   //------------------------------------------------------------------
   if (rst)
      begin
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      psw <= PSW_RV ; 
      end
   else
      begin
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      // Special function register write
      //-----------------------------------
      if (sfrwe & sfraddr == PSW_ID)
         begin
         psw <= sfrdatai ; 
         end
      else
         //-----------------------------
         // PSW(7) CY FLAG WRITE
         //-----------------------------
         begin
         case (instr[7:0])
         ADD_N, ADD_IR0,
         ADD_IR1, ADD_R0,
         ADD_R1, ADD_R2,
         ADD_R3, ADD_R4,
         ADD_R5, ADD_R6,
         ADD_R7, ADDC_R0,
         ADDC_R1, ADDC_R2,
         ADDC_R3, ADDC_R4,
         ADDC_R5, ADDC_R6,
         ADDC_R7, SUBB_R0,
         SUBB_R1, SUBB_R2,
         SUBB_R3, SUBB_R4,
         SUBB_R5, SUBB_R6,
         SUBB_R7, CJNE_R0_N,
         CJNE_R1_N, CJNE_R2_N,
         CJNE_R3_N, CJNE_R4_N,
         CJNE_R5_N, CJNE_R6_N,
         CJNE_R7_N, CJNE_A_N :
            begin
            if (mempsack)
               begin
               psw[7] <= result_b1[8] ; 
               end
            end
         
         RLC_A, RRC_A :
            begin
            if (mempsack)
               begin
               psw[7] <= result_b2[8] ; 
               end
            end
         
         ADD_ADDR, ADDC_ADDR,
         ADDC_IR0, ADDC_IR1,
         ADDC_N, SUBB_N,
         SUBB_ADDR, CJNE_A_ADDR,
         CJNE_IR0_N, CJNE_IR1_N,
         SUBB_IR0, SUBB_IR1 :
            begin
            if (cycle == 4'b 0010 & mempsack)
               begin
               psw[7] <= result_b1[8] ; 
               end 
            end
         
         DA_A :
            begin
               if (result_b2[8] & mempsack)
               begin
               psw[7] <= 1'b1 ; 
               end 
            end
         
         MUL_AB, DIV_AB,
         CLR_C :
            begin
            psw[7] <= 1'b0 ; 
            end
         
         SETB_C :
            begin
            psw[7] <= 1'b1 ; 
            end
         
         CPL_C :
            begin
            if (mempsack)
               begin
               psw[7] <= ~psw[7] ; 
               end
            end
         
         ANL_C_BIT :
            begin
            if (cycle == 4'b 0010 & mempsack)
               begin
               case (bit_nr)
               3'b000 :
                  begin
                  psw[7] <= psw[7] & ramsfrdata[0] ; 
                  end
               
               3'b001 :
                  begin
                  psw[7] <= psw[7] & ramsfrdata[1] ; 
                  end
               
               3'b010 :
                  begin
                  psw[7] <= psw[7] & ramsfrdata[2] ; 
                  end

               3'b011 :
                  begin
                  psw[7] <= psw[7] & ramsfrdata[3] ; 
                  end
               
               3'b100 :
                  begin
                  psw[7] <= psw[7] & ramsfrdata[4] ; 
                  end
               
               3'b101 :
                  begin
                  psw[7] <= psw[7] & ramsfrdata[5] ; 
                  end
               
               3'b110 :
                  begin
                  psw[7] <= psw[7] & ramsfrdata[6] ; 
                  end
               
               default :  // 3'b111
                  begin
                  psw[7] <= psw[7] & ramsfrdata[7] ; 
                  end
            
               endcase 
               end 
            end
         
         ANL_C_NBIT :
            begin
            if (cycle == 4'b 0010 & mempsack)
               begin
               case (bit_nr)
               3'b000 :
                  begin
                  psw[7] <= psw[7] & ~ramsfrdata[0] ; 
                  end
               
               3'b001 :
                  begin
                  psw[7] <= psw[7] & ~ramsfrdata[1] ; 
                  end
               
               3'b010 :
                  begin
                  psw[7] <= psw[7] & ~ramsfrdata[2] ; 
                  end
               
               3'b011 :
                  begin
                  psw[7] <= psw[7] & ~ramsfrdata[3] ; 
                  end
               
               3'b100 :
                  begin
                  psw[7] <= psw[7] & ~ramsfrdata[4] ; 
                  end
               
               3'b101 :
                  begin
                  psw[7] <= psw[7] & ~ramsfrdata[5] ; 
                  end
               
               3'b110 :
                  begin
                  psw[7] <= psw[7] & ~ramsfrdata[6] ; 
                  end
               
               default :  // 3'b111
                  begin
                  psw[7] <= psw[7] & ~ramsfrdata[7] ; 
                  end
               
               endcase 
               end 
            end
         
         ORL_C_BIT :
            begin
            if (cycle == 4'b 0010 & mempsack)
               begin
               case (bit_nr)
               3'b000 :
                  begin
                  psw[7] <= psw[7] | ramsfrdata[0] ; 
                  end
               
               3'b001 :
                  begin
                  psw[7] <= psw[7] | ramsfrdata[1] ; 
                  end
               
               3'b010 :
                  begin
                  psw[7] <= psw[7] | ramsfrdata[2] ; 
                  end
               
               3'b011 :
                  begin
                  psw[7] <= psw[7] | ramsfrdata[3] ; 
                  end
               
               3'b100 :
                  begin
                  psw[7] <= psw[7] | ramsfrdata[4] ; 
                  end
               
               3'b101 :
                  begin
                  psw[7] <= psw[7] | ramsfrdata[5] ; 
                  end
               
               3'b110 :
                  begin
                  psw[7] <= psw[7] | ramsfrdata[6] ; 
                  end
               
               default :  // 3'b111
                  begin
                  psw[7] <= psw[7] | ramsfrdata[7] ; 
                  end
               
               endcase 
               end 
            end
         
         ORL_C_NBIT :
            begin
            if (cycle == 4'b 0010 & mempsack)
               begin
               case (bit_nr)
               3'b000 :
                  begin
                  psw[7] <= psw[7] | ~ramsfrdata[0] ; 
                  end
               
               3'b001 :
                  begin
                  psw[7] <= psw[7] | ~ramsfrdata[1] ; 
                  end
               
               3'b010 :
                  begin
                  psw[7] <= psw[7] | ~ramsfrdata[2] ; 
                  end
               
               3'b011 :
                  begin
                  psw[7] <= psw[7] | ~ramsfrdata[3] ; 
                  end
               
               3'b100 :
                  begin
                  psw[7] <= psw[7] | ~ramsfrdata[4] ; 
                  end
               
               3'b101 :
                  begin
                  psw[7] <= psw[7] | ~ramsfrdata[5] ; 
                  end
               
               3'b110 :
                  begin
                  psw[7] <= psw[7] | ~ramsfrdata[6] ; 
                  end
               
               default :  // 3'b111
                  begin
                  psw[7] <= psw[7] | ~ramsfrdata[7] ; 
                  end
               
               endcase 
               end 
            end
         
         MOV_C_BIT :
            begin
            if (cycle == 4'b 0010 & mempsack)
               begin
               case (bit_nr)
               3'b000 :
                  begin
                  psw[7] <= ramsfrdata[0] ; 
                  end
               
               3'b001 :
                  begin
                  psw[7] <= ramsfrdata[1] ; 
                  end
               
               3'b010 :
                  begin
                  psw[7] <= ramsfrdata[2] ; 
                  end
               
               3'b011 :
                  begin
                  psw[7] <= ramsfrdata[3] ; 
                  end
               
               3'b100 :
                  begin
                  psw[7] <= ramsfrdata[4] ; 
                  end
               
               3'b101 :
                  begin
                  psw[7] <= ramsfrdata[5] ; 
                  end
               
               3'b110 :
                  begin
                  psw[7] <= ramsfrdata[6] ; 
                  end
               
               default :  // 3'b111
                  begin
                  psw[7] <= ramsfrdata[7] ; 
                  end
               
               endcase 
               end 
            end
         
         endcase 
         //-----------------------------
         // PSW(6) AC FLAG WRITE
         //-----------------------------
         case (instr[7:0])
         ADD_N, ADD_IR0,
         ADD_IR1, ADD_R0,
         ADD_R1, ADD_R2,
         ADD_R3, ADD_R4,
         ADD_R5, ADD_R6,
         ADD_R7, ADDC_N,
         ADDC_IR0, ADDC_IR1,
         ADDC_R0, ADDC_R1,
         ADDC_R2, ADDC_R3,
         ADDC_R4, ADDC_R5,
         ADDC_R6, ADDC_R7,
         SUBB_N, SUBB_IR0,
         SUBB_IR1, SUBB_R0,
         SUBB_R1, SUBB_R2,
         SUBB_R3, SUBB_R4,
         SUBB_R5, SUBB_R6,
         SUBB_R7 :
            begin
            psw[6] <= ac_bit ; 
            end

         ADD_ADDR, ADDC_ADDR,
         SUBB_ADDR :
            begin
            if (cycle == 4'b 0010 & mempsack)
               begin
               psw[6] <= ac_bit ; 
               end 
            end
         
         endcase 
         
         //-----------------------------
         // PSW(2) OV FLAG WRITE
         //-----------------------------
         case (instr[7:0])
         ADD_N, ADD_IR0,
         ADD_IR1, ADD_R0,
         ADD_R1, ADD_R2,
         ADD_R3, ADD_R4,
         ADD_R5, ADD_R6,
         ADD_R7, ADDC_N,
         ADDC_IR0, ADDC_IR1,
         ADDC_R0, ADDC_R1,
         ADDC_R2, ADDC_R3,
         ADDC_R4, ADDC_R5,
         ADDC_R6, ADDC_R7,
         SUBB_N, SUBB_IR0,
         SUBB_IR1, SUBB_R0,
         SUBB_R1, SUBB_R2,
         SUBB_R3, SUBB_R4,
         SUBB_R5, SUBB_R6,
         SUBB_R7 :
            begin
            psw[2] <= ov_bit ; 
            end
         
         ADD_ADDR, ADDC_ADDR,
         SUBB_ADDR :
            begin
            if (cycle == 4'b 0010 & mempsack)
               begin
               psw[2] <= ov_bit ; 
               end 
            end
               
         MUL_AB :
            begin
            if (sum1[8:1] == 8'b00000000)
               begin
               psw[2] <= 1'b0 ; 
               end
            else
               begin
               psw[2] <= 1'b1 ; 
               end 
            end
               
         DIV_AB :
            begin
            if (b == 8'b00000000)
               begin
               psw[2] <= 1'b1 ; 
               end
            else
               begin
               psw[2] <= 1'b0 ; 
               end 
            end
         
         endcase 
            
         //-----------------------------
         // PSW(0) P FLAG WRITE
         //-----------------------------
         psw[0] <= parity_bit ; 
         
         end 
      end  
   end 
   
   //------------------------------------------------------------------
   // Parity bit driver
   //------------------------------------------------------------------
   assign parity_bit = (acc[0] ^ acc[1] ^ acc[2] ^ acc[3] ^
      acc[4] ^ acc[5] ^ acc[6] ^ acc[7]) ; 

   //------------------------------------------------------------------
   // Arithmetic-logic machine
   // Operand 1 register
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : a1_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      a1 <= 8'b00000000 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      begin
      case (cycle)
      4'b 0001 :
         begin
         case (instr[7:0])
         CJNE_R0_N, CJNE_R1_N,
         CJNE_R2_N, CJNE_R3_N,
         CJNE_R4_N, CJNE_R5_N,
         CJNE_R6_N, CJNE_R7_N,
         XCH_R0, XCH_R1,
         XCH_R2, XCH_R3,
         XCH_R4, XCH_R5,
         XCH_R6, XCH_R7 :
            begin
            a1 <= ramsfrdata ; 
            end
         
         CJNE_IR0_N, CJNE_IR1_N :
            begin
            a1 <= memdatai ; 
            end
         
         endcase 
         end
      4'b 0010 :
         begin
         case (instr[7:0])
         CLR_BIT, SETB_BIT,
         ANL_C_BIT, ANL_C_NBIT,
         ORL_C_BIT, ORL_C_NBIT,
         MOV_C_BIT, MOV_BIT_C,
         CPL_BIT, JBC_BIT,
         JB_BIT, JNB_BIT,
         ANL_ADDR_N, ORL_ADDR_N,
         XRL_ADDR_N, XCH_ADDR,
         XCH_IR0, XCH_IR1 :
            begin
            a1 <= ramsfrdata ; 
            end
         
         endcase 
         end
      endcase 
      end  
   end 

   //------------------------------------------------------------------
   // Arithmetic-logic machine
   // Operand 2 register
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : a2_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      a2 <= 8'b00000000 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      begin
      case (cycle)
      4'b 0001 :
         begin
         case (instr[7:0])
         ADD_N, ADDC_N,
         SUBB_N, ANL_A_N,
         ORL_A_N, XRL_A_N,
         CJNE_A_N, CJNE_R0_N,
         CJNE_R1_N, CJNE_R2_N,
         CJNE_R3_N, CJNE_R4_N,
         CJNE_R5_N, CJNE_R6_N,
         CJNE_R7_N :
            begin
            a2 <= memdatai ; 
            end
         
         endcase 
         end
      4'b 0010 :
         begin
         case (instr[7:0])
         ANL_ADDR_N, ORL_ADDR_N,
         XRL_ADDR_N :
            begin
            a2 <= memdatai ; 
            end
         
         ANL_ADDR_A, ORL_ADDR_A,
         XRL_ADDR_A, CJNE_A_ADDR :
            begin
            a2 <= ramsfrdata ; 
            end
         
         endcase 
         end
      
      endcase 
      end  
   end 
   
   //------------------------------------------------------------------
   // Arithmetic-logic machine
   // ALU Operand 1 input
   //------------------------------------------------------------------
   assign op_a = (instr == ANL_ADDR_N | instr == ORL_ADDR_N |
                  instr == XRL_ADDR_N | instr == CJNE_R0_N |
                  instr == CJNE_R1_N | instr == CJNE_R2_N |
                  instr == CJNE_R3_N | instr == CJNE_R4_N |
                  instr == CJNE_R5_N | instr == CJNE_R6_N |
                  instr == CJNE_R7_N | instr == CJNE_IR0_N |
                  instr == CJNE_IR1_N) ? a1 : acc ; 
   
   //------------------------------------------------------------------
   // Arithmetic-logic machine
   // ALU Operand 2 input
   //------------------------------------------------------------------
   assign op_b = (instr == ADD_N | instr == ADDC_N |
                  instr == SUBB_N | instr == ANL_A_N |
                  instr == ORL_A_N | instr == XRL_A_N |
                  instr == ANL_ADDR_N | instr == ORL_ADDR_N |
                  instr == XRL_ADDR_N | instr == CJNE_A_N |
                  instr == CJNE_R0_N | instr == CJNE_R1_N |
                  instr == CJNE_R2_N | instr == CJNE_R3_N |
                  instr == CJNE_R4_N | instr == CJNE_R5_N |
                  instr == CJNE_R6_N | instr == CJNE_R7_N) ? a2
                  : ramsfrdata ; 
   
   //------------------------------------------------------------------
   // Arithmetic-logic machine
   // ALU Carry input
   //------------------------------------------------------------------
   assign op_c = psw[7] ; 

   //------------------------------------------------------------------
   always @(instr or op_a or op_b or op_c)
   begin : combinational_b1_alu_proc
   //------------------------------------------------------------------
   // ---------------------------
   // Initial value
   // ---------------------------
   result_b1 = 9'bXXXXXXXXX;
   ac_bit    = 1'bX;
   ov_bit    = 1'bX;

   // ---------------------------
   // Combinational value
   // ---------------------------
   case (instr[7:0])
   ADD_N,   ADD_ADDR,
   ADD_IR0, ADD_IR1,
   ADD_R0,  ADD_R1,
   ADD_R2,  ADD_R3,
   ADD_R4,  ADD_R5,
   ADD_R6,  ADD_R7 :
      begin
      b1_res_3_0 = {1'b0, op_a[3:0]} + op_b[3:0]; 
      b1_res_6_4 = {1'b0, op_a[6:4]} + op_b[6:4] + b1_res_3_0[4]; 
      b1_res_8_7 = {1'b0, op_a[7]} + op_b[7] + b1_res_6_4[3]; 
      result_b1 = {b1_res_8_7, b1_res_6_4[2:0], b1_res_3_0[3:0]} ; 
      end
         
   ADDC_N,  ADDC_ADDR,
   ADDC_IR0,ADDC_IR1,
   ADDC_R0, ADDC_R1,
   ADDC_R2, ADDC_R3,
   ADDC_R4, ADDC_R5,
   ADDC_R6, ADDC_R7 :
      begin
      b1_res_3_0 = {1'b0, op_a[3:0]} + op_b[3:0] + op_c; 
      b1_res_6_4 = {1'b0, op_a[6:4]} + op_b[6:4] + b1_res_3_0[4]; 
      b1_res_8_7 = {1'b0, op_a[7]} + op_b[7] + b1_res_6_4[3]; 
      result_b1 = {b1_res_8_7, b1_res_6_4[2:0], b1_res_3_0[3:0]} ; 
      end
   
   SUBB_N,  SUBB_ADDR,
   SUBB_IR0,SUBB_IR1,
   SUBB_R0, SUBB_R1,
   SUBB_R2, SUBB_R3,
   SUBB_R4, SUBB_R5,
   SUBB_R6, SUBB_R7 :
      begin
      b1_res_3_0 = {1'b0, op_a[3:0]} - op_b[3:0] - op_c; 
      b1_res_6_4 = {1'b0, op_a[6:4]} - op_b[6:4] - b1_res_3_0[4]; 
      b1_res_8_7 = {1'b0, op_a[7]} - op_b[7] - b1_res_6_4[3]; 
      result_b1 = {b1_res_8_7, b1_res_6_4[2:0], b1_res_3_0[3:0]} ; 
      end
         
   CJNE_A_N,   CJNE_A_ADDR,
   CJNE_R0_N,  CJNE_R1_N,
   CJNE_R2_N,  CJNE_R3_N,
   CJNE_R4_N,  CJNE_R5_N,
   CJNE_R6_N,  CJNE_R7_N :
      begin
      b1_res_3_0 = {1'b0, op_a[3:0]} - op_b[3:0]; 
      b1_res_6_4 = {1'b0, op_a[6:4]} - op_b[6:4] - b1_res_3_0[4]; 
      b1_res_8_7 = {1'b0, op_a[7]} - op_b[7] - b1_res_6_4[3]; 
      result_b1 = {b1_res_8_7, b1_res_6_4[2:0], b1_res_3_0[3:0]} ; 
      end
         
   CJNE_IR0_N, CJNE_IR1_N :
      begin
      b1_res_3_0 = {1'b0, op_b[3:0]} - op_a[3:0]; 
      b1_res_6_4 = {1'b0, op_b[6:4]} - op_a[6:4] - b1_res_3_0[4]; 
      b1_res_8_7 = {1'b0, op_b[7]} - op_a[7] - b1_res_6_4[3]; 
      result_b1 = {b1_res_8_7, b1_res_6_4[2:0], b1_res_3_0[3:0]} ; 
      end
   
   INC_ADDR,INC_IR0,
   INC_IR1, INC_R0,
   INC_R1,  INC_R2,
   INC_R3,  INC_R4,
   INC_R5,  INC_R6,
   INC_R7 :
      begin
      b1_res_3_0 = 5'bXXXXX; 
      b1_res_6_4 = 4'bXXXX; 
      b1_res_8_7 = 2'bXX; 
      result_b1 = {1'b0, op_b} + 1'b1 ; 
      end
   
   INC_A :
      begin
      b1_res_3_0 = 5'bXXXXX; 
      b1_res_6_4 = 4'bXXXX; 
      b1_res_8_7 = 2'bXX; 
      result_b1 = {1'b0, op_a} + 1'b1 ; 
      end
   
   DEC_ADDR,DEC_IR0,
   DEC_IR1, DEC_R0,
   DEC_R1,  DEC_R2,
   DEC_R3,  DEC_R4,
   DEC_R5,  DEC_R6,
   DEC_R7,  DJNZ_R0,
   DJNZ_R1, DJNZ_R2,
   DJNZ_R3, DJNZ_R4,
   DJNZ_R5, DJNZ_R6,
   DJNZ_R7, DJNZ_ADDR :
      begin
      b1_res_3_0 = 5'bXXXXX; 
      b1_res_6_4 = 4'bXXXX; 
      b1_res_8_7 = 2'bXX; 
      result_b1 = {1'b0, op_b} - 1'b1 ; 
      end
   
   DEC_A :
      begin
      b1_res_3_0 = 5'bXXXXX; 
      b1_res_6_4 = 4'bXXXX; 
      b1_res_8_7 = 2'bXX; 
      result_b1 = {1'b0, op_a} - 1'b1 ; 
      end
   
   default :
      begin
      b1_res_3_0 = 5'bXXXXX; 
      b1_res_6_4 = 4'bXXXX; 
      b1_res_8_7 = 2'bXX; 
      result_b1 = 9'bXXXXXXXXX; 
      end
   
   endcase 
   
   ac_bit = b1_res_3_0[4] ; 
   ov_bit = (b1_res_6_4[3] ^ b1_res_8_7[1]) ; 
   end 

   //------------------------------------------------------------------
   always @(instr or op_a or op_b or op_c or psw)
   begin : combinational_b2_alu_proc
   //------------------------------------------------------------------
   // ---------------------------
   // Initial value
   // ---------------------------
   result_b2 = 9'bXXXXXXXXX;
   
   // ---------------------------
   // Combinational value
   // ---------------------------
   case (instr[7:0])
      ORL_ADDR_A, ORL_ADDR_N,
      ORL_A_N, ORL_A_ADDR,
      ORL_A_IR0, ORL_A_IR1,
      ORL_A_R0, ORL_A_R1,
      ORL_A_R2, ORL_A_R3,
      ORL_A_R4, ORL_A_R5,
      ORL_A_R6, ORL_A_R7 :
         begin
         b2_res_3_0 = 5'bXXXXX; 
         b2_res_6_4 = 4'bXXXX; 
         b2_res_8_7 = 2'bXX; 
         result_b2 = {1'b0, (op_a | op_b)} ; 
         end
      
      XRL_ADDR_A, XRL_ADDR_N,
      XRL_A_N, XRL_A_ADDR,
      XRL_A_IR0, XRL_A_IR1,
      XRL_A_R0, XRL_A_R1,
      XRL_A_R2, XRL_A_R3,
      XRL_A_R4, XRL_A_R5,
      XRL_A_R6, XRL_A_R7 :
         begin
         b2_res_3_0 = 5'bXXXXX; 
         b2_res_6_4 = 4'bXXXX; 
         b2_res_8_7 = 2'bXX; 
         result_b2 = {1'b0, (op_a ^ op_b)} ; 
         end
      
      ANL_ADDR_A, ANL_ADDR_N,
      ANL_A_N, ANL_A_ADDR,
      ANL_A_IR0, ANL_A_IR1,
      ANL_A_R0, ANL_A_R1,
      ANL_A_R2, ANL_A_R3,
      ANL_A_R4, ANL_A_R5,
      ANL_A_R6, ANL_A_R7 :
         begin
         b2_res_3_0 = 5'bXXXXX; 
         b2_res_6_4 = 4'bXXXX; 
         b2_res_8_7 = 2'bXX; 
         result_b2 = {1'b0, (op_a & op_b)} ; 
         end
      
      DA_A :
         begin
         if (op_a[3:0] > 4'b1001 | (psw[6]))
            begin
            b2_res_3_0 = {1'b0, op_a[3:0]} + 4'b0110; 
            end
         else
            begin
            b2_res_3_0 = {1'b0, op_a[3:0]}; 
            end 
            
         if (((b2_res_3_0[4]) & op_a[7:4] > 4'b1000) |
            (op_a[7:4] > 4'b1001) |
            (op_c))
            begin
            b2_res_6_4 = {1'b0, op_a[6:4]} + b2_res_3_0[4] + 3'b110; 
            end
         else
            begin
            b2_res_6_4 = {1'b0, op_a[6:4]} + b2_res_3_0[4]; 
            end 
            
         b2_res_8_7 = {1'b0, op_a[7]} + b2_res_6_4[3]; 
         result_b2 = {b2_res_8_7, b2_res_6_4[2:0], b2_res_3_0[3:0]} ; 
         end
      
      CLR_A :
         begin
         b2_res_3_0 = 5'bXXXXX; 
         b2_res_6_4 = 4'bXXXX; 
         b2_res_8_7 = 2'bXX; 
         result_b2 = 9'b000000000 ; 
         end
      
      CPL_A :
         begin
         b2_res_3_0 = 5'bXXXXX; 
         b2_res_6_4 = 4'bXXXX; 
         b2_res_8_7 = 2'bXX; 
         result_b2 = {1'bX, (~op_a)} ; 
         end
      
      RL_A :
         begin
         b2_res_3_0 = 5'bXXXXX; 
         b2_res_6_4 = 4'bXXXX; 
         b2_res_8_7 = 2'bXX; 
         result_b2 = {1'bX, op_a[6:0], op_a[7]} ; 
         end
      
      RR_A :
         begin
         b2_res_3_0 = 5'bXXXXX; 
         b2_res_6_4 = 4'bXXXX; 
         b2_res_8_7 = 2'bXX; 
         result_b2 = {1'bX, op_a[0], op_a[7:1]} ; 
         end
      
      RLC_A :
         begin
         b2_res_3_0 = 5'bXXXXX; 
         b2_res_6_4 = 4'bXXXX; 
         b2_res_8_7 = 2'bXX; 
         result_b2 = {op_a[7:0], psw[7]} ; 
         end
      
      RRC_A :
         begin
         b2_res_3_0 = 5'bXXXXX; 
         b2_res_6_4 = 4'bXXXX; 
         b2_res_8_7 = 2'bXX; 
         result_b2 = {op_a[0], psw[7], op_a[7:1]} ; 
         end
      
      SWAP_A :
         begin
         b2_res_3_0 = 5'bXXXXX; 
         b2_res_6_4 = 4'bXXXX; 
         b2_res_8_7 = 2'bXX; 
         result_b2 = {1'bX, op_a[3:0], op_a[7:4]} ; 
         end
      
      default :
         begin
         b2_res_3_0 = 5'bXXXXX; 
         b2_res_6_4 = 4'bXXXX; 
         b2_res_8_7 = 2'bXX; 
         result_b2 = 9'bXXXXXXXXX; 
         end
      
      endcase 
   end 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : b1_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      b1 <= 8'b00000000 ; 
      end
   else
      begin
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      if (~(instr == DJNZ_ADDR & cycle == 4'b 0011))
         begin
         b1 <= result_b1[7:0] ; 
         end 
      end  
   end 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : b2_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      b2 <= 8'b00000000 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      begin
         b2 <= result_b2[7:0] ; 
      end  
   end 

   //------------------------------------------------------------------
   always @(posedge clk)
   begin : bit_nr_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      bit_nr <= 3'b000 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      begin
      case (cycle)
         4'b 0001 :
            begin
            case (instr[7:0])
            CLR_BIT, SETB_BIT,
            ANL_C_BIT, ANL_C_NBIT,
            ORL_C_BIT, ORL_C_NBIT,
            MOV_C_BIT, MOV_BIT_C,
            CPL_BIT, JBC_BIT,
            JB_BIT, JNB_BIT :
               begin
               bit_nr <= memdatai[2:0] ; 
               end
            
            endcase 
            end
         
         endcase 
      end  
   end 
   
   //------------------------------------------------------------------
   // Boolean machine
   // Operand multiplexer
   //------------------------------------------------------------------
   assign bool_op = (instr == CLR_BIT | instr == SETB_BIT |
                     instr == CPL_BIT | instr == MOV_BIT_C)
                     ? ramsfrdata : a1 ; 

   //------------------------------------------------------------------
   // Boolean machine
   // Combinational part
   //------------------------------------------------------------------
   always @(instr or bool_op or psw or bit_nr)
   begin : combinational_boolean_unit_proc
   //------------------------------------------------------------------
   //----------------------------
   // Initial value
   //----------------------------
   bool_res = bool_op[7:0];
   
   //----------------------------
   // Combinational value
   //----------------------------
   case (instr[7:0])
   SETB_BIT :
      begin
      case (bit_nr)
      3'b000 :
         begin
         bool_res = {bool_op[7:1], 1'b1} ; 
         end
      
      3'b001 :
         begin
         bool_res = {bool_op[7:2], 1'b1, bool_op[0]} ; 
         end
      
      3'b010 :
         begin
         bool_res = {bool_op[7:3], 1'b1, bool_op[1:0]} ; 
         end
      
      3'b011 :
         begin
         bool_res = {bool_op[7:4], 1'b1, bool_op[2:0]} ; 
         end
      
      3'b100 :
         begin
         bool_res = {bool_op[7:5], 1'b1, bool_op[3:0]} ; 
         end
      
      3'b101 :
         begin
         bool_res = {bool_op[7:6], 1'b1, bool_op[4:0]} ; 
         end
      
      3'b110 :
         begin
         bool_res = {bool_op[7], 1'b1, bool_op[5:0]} ; 
         end
      
      default :  // 3'b111
         begin
         bool_res = {1'b1, bool_op[6:0]} ; 
         end
      
      endcase 
      end
   
   CLR_BIT, JBC_BIT :
      begin
      case (bit_nr)
      3'b000 :
         begin
         bool_res = {bool_op[7:1], 1'b0} ; 
         end
      
      3'b001 :
         begin
         bool_res = {bool_op[7:2], 1'b0, bool_op[0]} ; 
         end
      
      3'b010 :
         begin
         bool_res = {bool_op[7:3], 1'b0, bool_op[1:0]} ; 
         end
      
      3'b011 :
         begin
         bool_res = {bool_op[7:4], 1'b0, bool_op[2:0]} ; 
         end
      
      3'b100 :
         begin
         bool_res = {bool_op[7:5], 1'b0, bool_op[3:0]} ; 
         end
      
      3'b101 :
         begin
         bool_res = {bool_op[7:6], 1'b0, bool_op[4:0]} ; 
         end
      
      3'b110 :
         begin
         bool_res = {bool_op[7], 1'b0, bool_op[5:0]} ; 
         end
      
      default :  // 3'b111
         begin
         bool_res = {1'b0, bool_op[6:0]} ; 
         end
      
      endcase 
      end
   
   CPL_BIT :
      begin
      case (bit_nr)
      3'b000 :
         begin
         bool_res = {bool_op[7:1], ~bool_op[0]} ; 
         end
      
      3'b001 :
         begin
         bool_res = {bool_op[7:2], ~bool_op[1], bool_op[0]} ; 
         end
      
      3'b010 :
         begin
         bool_res = {bool_op[7:3], ~bool_op[2], bool_op[1:0]} ; 
         end
      
      3'b011 :
         begin
         bool_res = {bool_op[7:4], ~bool_op[3], bool_op[2:0]} ; 
         end
      
      3'b100 :
         begin
         bool_res = {bool_op[7:5], ~bool_op[4], bool_op[3:0]} ; 
         end
      
      3'b101 :
         begin
         bool_res = {bool_op[7:6], ~bool_op[5], bool_op[4:0]} ; 
         end
      
      3'b110 :
         begin
         bool_res = {bool_op[7], ~bool_op[6], bool_op[5:0]} ; 
         end
      
      default :  // 3'b111
         begin
         bool_res = {~bool_op[7], bool_op[6:0]} ; 
         end
      
      endcase 
      end
   
   MOV_BIT_C :
      begin
      case (bit_nr)
      3'b000 :
         begin
         bool_res = {bool_op[7:1], psw[7]} ; 
         end
      
      3'b001 :
         begin
         bool_res = {bool_op[7:2], psw[7], bool_op[0]} ; 
         end
      
      3'b010 :
         begin
         bool_res = {bool_op[7:3], psw[7], bool_op[1:0]} ; 
         end
      
      3'b011 :
         begin
         bool_res = {bool_op[7:4], psw[7], bool_op[2:0]} ; 
         end
      
      3'b100 :
         begin
         bool_res = {bool_op[7:5], psw[7], bool_op[3:0]} ; 
         end
      
      3'b101 :
         begin
         bool_res = {bool_op[7:6], psw[7], bool_op[4:0]} ; 
         end
      
      3'b110 :
         begin
         bool_res = {bool_op[7], psw[7], bool_op[5:0]} ; 
         end
      
      default :  // 3'b111
         begin
         bool_res = {psw[7], bool_op[6:0]} ; 
         end
      
      endcase 
      end
   
   default :  // instr
      begin
      bool_res = 8'bXXXXXXXX ; 
      end
      
   endcase 
   end 

   //------------------------------------------------------------------
   // Boolean machine
   // Result register
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : b3_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      b3 <= 8'b00000000 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------  
      begin
      b3 <= bool_res ; 
      end  
   end 

   //------------------------------------------------------------------
   // Bit value of bit addressable register
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : bitvalue_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      bitvalue <= 1'b0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      begin
      case (cycle)
      4'b 0010 :
         begin
         case (bit_nr)
         3'b000 :
            begin
            bitvalue <= ramsfrdata[0] ; 
            end
         
         3'b001 :
            begin
            bitvalue <= ramsfrdata[1] ; 
            end
         
         3'b010 :
            begin
            bitvalue <= ramsfrdata[2] ; 
            end
         
         3'b011 :
            begin
            bitvalue <= ramsfrdata[3] ; 
            end
         
         3'b100 :
            begin
            bitvalue <= ramsfrdata[4] ; 
            end
         
         3'b101 :
            begin
            bitvalue <= ramsfrdata[5] ; 
            end
         
         3'b110 :
            begin
            bitvalue <= ramsfrdata[6] ; 
            end
         
         default :
            begin
            bitvalue <= ramsfrdata[7] ; 
            end
         
         endcase 
         end
      
      endcase 
      end  
   end 

   //------------------------------------------------------------------
   // Conditional jump control
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : cdjump_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      cdjump <= 1'b0 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      begin
      if (result_b1[7:0] == 8'b00000000)
         begin
         cdjump <= 1'b0 ; 
         end
      else
         begin
         cdjump <= 1'b1 ; 
         end 
      end  
   end 
   
   //-------------------------------------------------------------------
   // ALU Result Multiplexer
   //-------------------------------------------------------------------
   assign aluresult = (instr == CLR_BIT | instr == SETB_BIT |
                       instr == MOV_BIT_C | instr == CPL_BIT |
                       instr == JBC_BIT) ? b3 :
                       (instr == ANL_ADDR_A | instr == ANL_ADDR_N |
                       instr == ORL_ADDR_A | instr == ORL_ADDR_N |
                       instr == XRL_ADDR_A | instr == XRL_ADDR_N)
                       ? b2 : b1 ; 

   //------------------------------------------------------------------
   // Multilication and Division
   // Register A
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : mda_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
      mda <= 8'b00000000 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      begin
      if (cycle == 4'b 0001)
         begin
         case (instr[7:0])
         MUL_AB :
            begin
            mda <= acc ; 
            end
         
         DIV_AB :
            begin
            mda <= {acc[6:0], 1'b0} ; 
            end
         
         endcase 
         end
      
      else
         begin
         case (cycle)
         4'b 0010,
         4'b 0011,
         4'b 0100,
         4'b 0101 :
            begin
            case (instr[7:0])
            MUL_AB :
                     begin
                        mda <= {sum1[0], sum[0], mda[7:2]} ; 
                     end
            
            DIV_AB :
                     begin
                        mda <= {mda[5:0], sum[8], sum1[8]} ; 
                     end
            
            endcase 
            end
         
         endcase 
         end 
      end  
   end 

   //------------------------------------------------------------------
   // Multilication and Division
   // Register B
   //------------------------------------------------------------------
   always @(posedge clk)
   begin : mdb_write_proc
   //------------------------------------------------------------------
   if (rst)
      //-----------------------------------
      // Synchronous reset
      //-----------------------------------
      begin
         mdb <= 8'b00000000 ; 
      end
   else
      //-----------------------------------
      // Synchronous write
      //-----------------------------------
      begin
      if (cycle == 4'b 0001)
         begin
         case (instr[7:0])
         MUL_AB :
            begin
            mdb <= 8'b00000000 ; 
            end
         
         DIV_AB :
            begin
            mdb <= {7'b0000000, acc[7]} ; 
            end
         
         endcase 
         end
      else
         begin
         case (cycle)
         4'b 0010,
         4'b 0011,
         4'b 0100,
         4'b 0101 :
            begin
            case (instr[7:0])
            MUL_AB :
               begin
               mdb <= sum1[8:1] ; 
               end
            
            DIV_AB :
               begin
               if (sum1[8])  // borrow = 0
                  begin
                  mdb <= {sum1[6:0], mda[6]} ; 
                  end
               else if (sum[8])  // borrow = 0 
                  begin
                  mdb <= {sum[5:0], mda[7:6]} ; 
                  end
               else
                  begin
                  mdb <= {mdb[5:0], mda[7:6]} ; 
                  end 
               end
            
            endcase 
            end
         
         endcase 
         end 
      end  
   end 

   //------------------------------------------------------------------
   // Multilication and Division
   // Combinational machine
   //------------------------------------------------------------------
   always @(b or mda or mdb or instr)
   begin : combinational_sum_proc
   //------------------------------------------------------------------
   //-----------------------------------
   // Initial value
   //-----------------------------------
   sum = 9'bXXXXXXXXX;
   
   //-----------------------------------
   // Combinational value
   //-----------------------------------
   case (instr[7:0])
   MUL_AB :
      begin
      if (mda[0])
         begin
         sum = ({1'b0, mdb}) + ({1'b0, b}) ; 
         end
      else
         begin
         sum = {1'b0, mdb} ; 
         end 
      end
   
   DIV_AB :
      begin
      sum = ({1'b0, mdb}) + ({1'b0, (~b)}) + 1'b1 ; 
      end
   
   default :
      begin
      sum = 9'bXXXXXXXXX ; 
      end
   
   endcase 
   end 

   //------------------------------------------------------------------
   always @(b or mda or mdb or sum or instr)
   begin : combinational_sum1_proc
   //------------------------------------------------------------------
   //-----------------------------------
   // Initial value
   //-----------------------------------
   sum1 = 9'bXXXXXXXXX;
   
   //-----------------------------------
   // Combinational value
   //-----------------------------------
   case (instr[7:0])
   MUL_AB :
      begin
      if (mda[1])
         begin
         sum1 = ({1'b0, sum[8:1]}) + ({1'b0, b}) ; 
         end
      else
         begin
         sum1 = {1'b0, sum[8:1]} ; 
         end 
      end
   
   DIV_AB :
      begin
      if (sum[8])  // borrow = 0
         begin
         sum1 = ({1'b0, sum[6:0], mda[7]}) + ({1'b0, (~b)}) + 1'b1 ; 
         end
      else
         begin
         sum1 = ({1'b0, mdb[6:0], mda[7]}) + ({1'b0, (~b)}) + 1'b1 ; 
         end 
      end
   
   default :
      begin
      sum1 = 9'bXXXXXXXXX ; 
      end
   
   endcase 
   end 
   
   //-------------------------------------------------------------------
   // Special Function registers read
   //-------------------------------------------------------------------
   assign sfrdataalu =
         (sfraddr == ACC_ID)  ? acc :
         (sfraddr == B_ID)    ? b :
         (sfraddr == PSW_ID)  ? psw :
         8'bXXXXXXXX ; 
         
         
         
endmodule  // module ALU

//*******************************************************************//
