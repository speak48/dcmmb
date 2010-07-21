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
// File name            : utility.v
// Purpose              : Special Function Register description
//                        Special Function Register locations
//                        Special Function Register reset values
//                        Interrupt Vector locations
//
// Design Engineer      : M.B. D.K.
// Quality Engineer     : M.B.
// Version              : 1.10.V05
// Last modification    : 2002-01-08
//---------------------------------------------------------------------


   //------------------------------------------------------------------
   // Special Function Register description
   //------------------------------------------------------------------
   // Register : ID  : RV  : Description
   // p0       : 80h : FFh : Port 0
   // sp       : 81h : 07h : Stack Pointer
   // dpl      : 82h : 00h : Data Pointer Low 0
   // dph      : 83h : 00h : Data Pointer High 0
   // dpl1     : 84h : 00h : Data Pointer Low 1
   // dph1     : 85h : 00h : Data Pointer High 1
   // wdtrel   : 86h : 00h : Watchdog Timer Reload register
   // pcon     : 87h : 00h : Power Control
   // tcon     : 88h : 00h : Timer/Counter Control
   // tmod     : 89h : 00h : Timer Mode Control
   // tl0      : 8Ah : 00h : Timer 0, low byte
   // tl1      : 8Bh : 00h : Timer 1, high byte
   // th0      : 8Ch : 00h : Timer 0, low byte
   // th1      : 8Dh : 00h : Timer 1, high byte
   // ckcon    : 8Eh : 01h : Clock Control (Stretch=1)
   // p1       : 90h : FFh : Port 1
   // exif     :           : External Interrupt Flag (optional)
   // dps      : 92h : 00h : Data Pointer select Register
   // s0con    : 98h : 00h : Serial Port 0, Control Register
   // s0buf    : 99h : 00h : Serial Port 0, Data Buffer
   // ien2     : 9Ah : 00h : Interrupt Enable Register 2
   // s1con    : 9Bh : 00h : Serial Port 1, Control Register
   // s1buf    : 9Ch : 00h : Serial Port 1, Data Buffer
   // s1rell   : 9Dh : 00h : Serial Port 1, Reload Register, low byte
   // p2       : A0h : 00h : Port 2
   // ien0     : A8h : 00h : Interrupt Enable Register 0
   // ip0      : A9h : 00h : Interrupt Priority Register 0
   // s0rell   : AAh : D9h : Serial Port 0, Reload Register, low byte
   // saddr0   :           : Slave Address Register 0 (optional)
   // saddr1   :           : Slave Address Register 1 (optional)
   // p3       : B0h : FFh : Port 3
   // ien1     : B8h : 00h : Interrupt Enable Register 1
   // ip1      : B9h : 00h : Interrupt Priority Register 1
   // s0relh   : BAh : 03h : Serial Port 0, Reload Register, high byte
   // s1relh   : BBh : 03h : Serial Port 1, Reload Register, high byte
   // ircon    : C0h : 00h : Interrupt Request Control Register
   // ccen     : C1h : 00h : Compare/Capture Enable Register
   // ccl1     : C2h : 00h : Compare/Capture Register 1, low byte
   // cch1     : C3h : 00h : Compare/Capture Register 1, high byte
   // ccl2     : C4h : 00h : Compare/Capture Register 2, low byte
   // cch2     : C5h : 00h : Compare/Capture Register 2, high byte
   // ccl3     : C6h : 00h : Compare/Capture Register 3, low byte
   // cch3     : C7h : 00h : Compare/Capture Register 3, high byte
   // saden0   :           : Slave Addr Mask En. Register 0 (optional)
   // saden1   :           : Slave Addr Mask En. Register 1 (optional)
   // t2con    : C8h : 00h : Timer 2 Control
   // crcl     : CAh : 00h : Compare/Reload/Capture Register, low byte
   // crch     : CBh : 00h : Compare/Reload/Capture Register, high byte
   // t2mod    :           : Timer 2 Mode (optional)
   // rcap2l   :           : Timer 2 Capture LSB (optional)
   // rcap2h   :           : Timer 2 Capture MSB (optional)
   // tl2      : CCh : 00h : Timer 2, low byte
   // th2      : CDh : 00h : Timer 2, high byte
   // psw      : D0h : 00h : Program Status Word
   // adcon    : D8h : 00h : A/D Converter Register (only BD bit used)
   // acc      : E0h : 00h : Accumulator
   // md0      : E9h : 00h : Multiplication/Division Register 0
   // md1      : EAh : 00h : Multiplication/Division Register 1
   // md2      : EBh : 00h : Multiplication/Division Register 2
   // md3      : ECh : 00h : Multiplication/Division Register 3
   // md4      : EDh : 00h : Multiplication/Division Register 4
   // md5      : EEh : 00h : Multiplication/Division Register 5
   // arcon    : EFh : 00h : Arithmetic Control Register
   // b        : F0h : 00h : B Register
   // eip      :           : Extended Interrupt Priority (optional)
   //------------------------------------------------------------------
   
   //---------------------------------------------------------------
   // Special Function Register locations
   //---------------------------------------------------------------
   // 80h - 87h
   parameter[6:0] P0_ID          = 7'b0000000; 
   parameter[6:0] SP_ID          = 7'b0000001; 
   parameter[6:0] DPL_ID         = 7'b0000010; 
   parameter[6:0] DPH_ID         = 7'b0000011; 
   parameter[6:0] DPL1_ID        = 7'b0000100;
   parameter[6:0] DPH1_ID        = 7'b0000101;
   parameter[6:0] PCON_ID        = 7'b0000111; 
   parameter[6:0] WDTREL_ID      = 7'b0000110; 
   
   // 88h - 8Fh
   parameter[6:0] TCON_ID        = 7'b0001000; 
   parameter[6:0] TMOD_ID        = 7'b0001001; 
   parameter[6:0] TL0_ID         = 7'b0001010; 
   parameter[6:0] TL1_ID         = 7'b0001011; 
   parameter[6:0] TH0_ID         = 7'b0001100; 
   parameter[6:0] TH1_ID         = 7'b0001101; 
   parameter[6:0] CKCON_ID       = 7'b0001110; 
   
   // 90h - 97h
   parameter[6:0] P1_ID          = 7'b0010000; 
   parameter[6:0] DPS_ID         = 7'b0010010;
   
   // 98h - 9Fh
   parameter[6:0] S0CON_ID       = 7'b0011000; 
   parameter[6:0] S0BUF_ID       = 7'b0011001; 
   parameter[6:0] IEN2_ID        = 7'b0011010; 
   parameter[6:0] S1CON_ID       = 7'b0011011; 
   parameter[6:0] S1BUF_ID       = 7'b0011100; 
   parameter[6:0] S1RELL_ID      = 7'b0011101; 
   
   // A0h - A7h
   parameter[6:0] P2_ID          = 7'b0100000; 
   
   // A8h - AFh
   parameter[6:0] IEN0_ID        = 7'b0101000; 
   parameter[6:0] IP0_ID         = 7'b0101001; 
   parameter[6:0] S0RELL_ID      = 7'b0101010; 
   
   // B0h - B7h
   parameter[6:0] P3_ID          = 7'b0110000; 
   
   // B8h - BFh
   parameter[6:0] IEN1_ID        = 7'b0111000; 
   parameter[6:0] IP1_ID         = 7'b0111001; 
   parameter[6:0] S0RELH_ID      = 7'b0111010; 
   parameter[6:0] S1RELH_ID      = 7'b0111011; 
   
   // C0h - C7h
   parameter[6:0] IRCON_ID       = 7'b1000000; 
   parameter[6:0] CCEN_ID        = 7'b1000001; 
   parameter[6:0] CCL1_ID        = 7'b1000010; 
   parameter[6:0] CCH1_ID        = 7'b1000011; 
   parameter[6:0] CCL2_ID        = 7'b1000100; 
   parameter[6:0] CCH2_ID        = 7'b1000101; 
   parameter[6:0] CCL3_ID        = 7'b1000110; 
   parameter[6:0] CCH3_ID        = 7'b1000111; 
   
   // C8h - CFh
   parameter[6:0] T2CON_ID       = 7'b1001000; 
   parameter[6:0] T2MOD_ID       = 7'b1001001; 
   parameter[6:0] CRCL_ID        = 7'b1001010; 
   parameter[6:0] CRCH_ID        = 7'b1001011; 
   parameter[6:0] TL2_ID         = 7'b1001100; 
   parameter[6:0] TH2_ID         = 7'b1001101; 
   
   // D0h - D7h
   parameter[6:0] PSW_ID         = 7'b1010000; 
   
   // D8h - DFh
   parameter[6:0] ADCON_ID       = 7'b1011000; 
   
   // E0h - E7h
   parameter[6:0] ACC_ID         = 7'b1100000; 
   
   // E8h - EFh
   parameter[6:0] MD0_ID         = 7'b1101001; 
   parameter[6:0] MD1_ID         = 7'b1101010; 
   parameter[6:0] MD2_ID         = 7'b1101011; 
   parameter[6:0] MD3_ID         = 7'b1101100; 
   parameter[6:0] MD4_ID         = 7'b1101101; 
   parameter[6:0] MD5_ID         = 7'b1101110; 
   parameter[6:0] ARCON_ID       = 7'b1101111; 
   
   // F0h - F7h
   parameter[6:0] B_ID           = 7'b1110000; 
   parameter[6:0] EIP_ID         = 7'b1110101; 
   
   //---------------------------------------------------------------
   // Special Function Register reset values
   //---------------------------------------------------------------
   // 80h - 87h
   parameter[7:0] P0_RV          = 8'b11111111; 
   parameter[7:0] SP_RV          = 8'b00000111; 
   parameter[7:0] DPL_RV         = 8'b00000000; 
   parameter[7:0] DPH_RV         = 8'b00000000; 
   parameter[7:0] DPL1_RV        = 8'b00000000;
   parameter[7:0] DPH1_RV        = 8'b00000000;
   parameter[7:0] PCON_RV        = 8'b00000000; 
   parameter[7:0] WDTREL_RV      = 8'b00000000; 
   
   // 88h - 8Fh
   parameter[7:0] TCON_RV        = 8'b00000000; 
   parameter[7:0] TMOD_RV        = 8'b00000000; 
   parameter[7:0] TL0_RV         = 8'b00000000; 
   parameter[7:0] TL1_RV         = 8'b00000000; 
   parameter[7:0] TH0_RV         = 8'b00000000; 
   parameter[7:0] TH1_RV         = 8'b00000000; 
//   parameter[7:0] CKCON_RV       = 8'b00010001; 
   parameter[7:0] CKCON_RV       = 8'b00000001; 
   
   // 90h - 97h
   parameter[7:0] P1_RV          = 8'b11111111; 
   parameter[7:0] DPS_RV         = 8'b00000000;
   
   // 98h - 9Fh
   parameter[7:0] S0CON_RV       = 8'b00000000; 
   parameter[7:0] S0BUF_RV       = 8'b00000000; 
   parameter[7:0] IEN2_RV        = 8'b00000000; 
   parameter[7:0] S1CON_RV       = 8'b00000000; 
   parameter[7:0] S1BUF_RV       = 8'b00000000; 
   parameter[7:0] S1RELL_RV      = 8'b00000000; 
   
   // A0h - A7h
   parameter[7:0] P2_RV          = 8'b11111111; 
   
   // A8h - AFh
   parameter[7:0] IEN0_RV        = 8'b00000000; 
   parameter[7:0] IP0_RV         = 8'b00000000; 
   parameter[7:0] IP0_RW         = 8'b01000000; // Watchdog reset
   parameter[7:0] S0RELL_RV      = 8'b11011001; 
   
   // B0h - B7h
   parameter[7:0] P3_RV          = 8'b11111111; 
   
   // B8h - BFh
   parameter[7:0] IEN1_RV        = 8'b00000000; 
   parameter[7:0] IP1_RV         = 8'b00000000; 
   parameter[7:0] S0RELH_RV      = 8'b00000011; 
   parameter[7:0] S1RELH_RV      = 8'b00000000; 
   
   // C0h - C7h
   parameter[7:0] IRCON_RV       = 8'b00000000; 
   parameter[7:0] CCEN_RV        = 8'b00000000; 
   parameter[7:0] CCL1_RV        = 8'b00000000; 
   parameter[7:0] CCH1_RV        = 8'b00000000; 
   parameter[7:0] CCL2_RV        = 8'b00000000; 
   parameter[7:0] CCH2_RV        = 8'b00000000; 
   parameter[7:0] CCL3_RV        = 8'b00000000; 
   parameter[7:0] CCH3_RV        = 8'b00000000; 
   
   // C8h - CFh
   parameter[7:0] T2CON_RV       = 8'b00000000; 
   parameter[7:0] T2MOD_RV       = 8'b00000000; 
   parameter[7:0] CRCL_RV        = 8'b00000000; 
   parameter[7:0] CRCH_RV        = 8'b00000000; 
   parameter[7:0] TL2_RV         = 8'b00000000; 
   parameter[7:0] TH2_RV         = 8'b00000000; 
   
   // D0h - D7h
   parameter[7:0] PSW_RV         = 8'b00000000; 
   
   // D8h - DFh
   parameter[7:0] ADCON_RV       = 8'b00000000; 
   
   // E0h - E7h
   parameter[7:0] ACC_RV         = 8'b00000000; 
   
   // E8h - EFh
   parameter[7:0] MD0_RV         = 8'b00000000; 
   parameter[7:0] MD1_RV         = 8'b00000000; 
   parameter[7:0] MD2_RV         = 8'b00000000; 
   parameter[7:0] MD3_RV         = 8'b00000000; 
   parameter[7:0] MD4_RV         = 8'b00000000; 
   parameter[7:0] MD5_RV         = 8'b00000000; 
   parameter[7:0] ARCON_RV       = 8'b00000000; 
   
   // F0h - F7h
   parameter[7:0] B_RV           = 8'b00000000; 
   parameter[7:0] EIP_RV         = 8'b00000000; 
   
   //-----------------------------------------------------------------
   // Instruction Mnemonics
   //-----------------------------------------------------------------
   // 00H - 0Fh
   parameter[7:0] NOP            = 8'b00000000; 
   parameter[7:0] AJMP_0         = 8'b00000001; 
   parameter[7:0] LJMP           = 8'b00000010; 
   parameter[7:0] RR_A           = 8'b00000011; 
   parameter[7:0] INC_A          = 8'b00000100; 
   parameter[7:0] INC_ADDR       = 8'b00000101; 
   parameter[7:0] INC_IR0        = 8'b00000110; 
   parameter[7:0] INC_IR1        = 8'b00000111; 
   parameter[7:0] INC_R0         = 8'b00001000; 
   parameter[7:0] INC_R1         = 8'b00001001; 
   parameter[7:0] INC_R2         = 8'b00001010; 
   parameter[7:0] INC_R3         = 8'b00001011; 
   parameter[7:0] INC_R4         = 8'b00001100; 
   parameter[7:0] INC_R5         = 8'b00001101; 
   parameter[7:0] INC_R6         = 8'b00001110; 
   parameter[7:0] INC_R7         = 8'b00001111; 
   
   // 10H - 1Fh
   parameter[7:0] JBC_BIT        = 8'b00010000; 
   parameter[7:0] ACALL_0        = 8'b00010001; 
   parameter[7:0] LCALL          = 8'b00010010; 
   parameter[7:0] RRC_A          = 8'b00010011; 
   parameter[7:0] DEC_A          = 8'b00010100; 
   parameter[7:0] DEC_ADDR       = 8'b00010101; 
   parameter[7:0] DEC_IR0        = 8'b00010110; 
   parameter[7:0] DEC_IR1        = 8'b00010111; 
   parameter[7:0] DEC_R0         = 8'b00011000; 
   parameter[7:0] DEC_R1         = 8'b00011001; 
   parameter[7:0] DEC_R2         = 8'b00011010; 
   parameter[7:0] DEC_R3         = 8'b00011011; 
   parameter[7:0] DEC_R4         = 8'b00011100; 
   parameter[7:0] DEC_R5         = 8'b00011101; 
   parameter[7:0] DEC_R6         = 8'b00011110; 
   parameter[7:0] DEC_R7         = 8'b00011111; 
   
   // 20H - 2Fh
   parameter[7:0] JB_BIT         = 8'b00100000; 
   parameter[7:0] AJMP_1         = 8'b00100001; 
   parameter[7:0] RET            = 8'b00100010; 
   parameter[7:0] RL_A           = 8'b00100011; 
   parameter[7:0] ADD_N          = 8'b00100100; 
   parameter[7:0] ADD_ADDR       = 8'b00100101; 
   parameter[7:0] ADD_IR0        = 8'b00100110; 
   parameter[7:0] ADD_IR1        = 8'b00100111; 
   parameter[7:0] ADD_R0         = 8'b00101000; 
   parameter[7:0] ADD_R1         = 8'b00101001; 
   parameter[7:0] ADD_R2         = 8'b00101010; 
   parameter[7:0] ADD_R3         = 8'b00101011; 
   parameter[7:0] ADD_R4         = 8'b00101100; 
   parameter[7:0] ADD_R5         = 8'b00101101; 
   parameter[7:0] ADD_R6         = 8'b00101110; 
   parameter[7:0] ADD_R7         = 8'b00101111; 
   
   // 30H - 3Fh
   parameter[7:0] JNB_BIT        = 8'b00110000; 
   parameter[7:0] ACALL_1        = 8'b00110001; 
   parameter[7:0] RETI           = 8'b00110010; 
   parameter[7:0] RLC_A          = 8'b00110011; 
   parameter[7:0] ADDC_N         = 8'b00110100; 
   parameter[7:0] ADDC_ADDR      = 8'b00110101; 
   parameter[7:0] ADDC_IR0       = 8'b00110110; 
   parameter[7:0] ADDC_IR1       = 8'b00110111; 
   parameter[7:0] ADDC_R0        = 8'b00111000; 
   parameter[7:0] ADDC_R1        = 8'b00111001; 
   parameter[7:0] ADDC_R2        = 8'b00111010; 
   parameter[7:0] ADDC_R3        = 8'b00111011; 
   parameter[7:0] ADDC_R4        = 8'b00111100; 
   parameter[7:0] ADDC_R5        = 8'b00111101; 
   parameter[7:0] ADDC_R6        = 8'b00111110; 
   parameter[7:0] ADDC_R7        = 8'b00111111; 
   
   // 40H - 4Fh
   parameter[7:0] JC             = 8'b01000000; 
   parameter[7:0] AJMP_2         = 8'b01000001; 
   parameter[7:0] ORL_ADDR_A     = 8'b01000010; 
   parameter[7:0] ORL_ADDR_N     = 8'b01000011; 
   parameter[7:0] ORL_A_N        = 8'b01000100; 
   parameter[7:0] ORL_A_ADDR     = 8'b01000101; 
   parameter[7:0] ORL_A_IR0      = 8'b01000110; 
   parameter[7:0] ORL_A_IR1      = 8'b01000111; 
   parameter[7:0] ORL_A_R0       = 8'b01001000; 
   parameter[7:0] ORL_A_R1       = 8'b01001001; 
   parameter[7:0] ORL_A_R2       = 8'b01001010; 
   parameter[7:0] ORL_A_R3       = 8'b01001011; 
   parameter[7:0] ORL_A_R4       = 8'b01001100; 
   parameter[7:0] ORL_A_R5       = 8'b01001101; 
   parameter[7:0] ORL_A_R6       = 8'b01001110; 
   parameter[7:0] ORL_A_R7       = 8'b01001111; 
   
   // 50H - 5Fh
   parameter[7:0] JNC            = 8'b01010000; 
   parameter[7:0] ACALL_2        = 8'b01010001; 
   parameter[7:0] ANL_ADDR_A     = 8'b01010010; 
   parameter[7:0] ANL_ADDR_N     = 8'b01010011; 
   parameter[7:0] ANL_A_N        = 8'b01010100; 
   parameter[7:0] ANL_A_ADDR     = 8'b01010101; 
   parameter[7:0] ANL_A_IR0      = 8'b01010110; 
   parameter[7:0] ANL_A_IR1      = 8'b01010111; 
   parameter[7:0] ANL_A_R0       = 8'b01011000; 
   parameter[7:0] ANL_A_R1       = 8'b01011001; 
   parameter[7:0] ANL_A_R2       = 8'b01011010; 
   parameter[7:0] ANL_A_R3       = 8'b01011011; 
   parameter[7:0] ANL_A_R4       = 8'b01011100; 
   parameter[7:0] ANL_A_R5       = 8'b01011101; 
   parameter[7:0] ANL_A_R6       = 8'b01011110; 
   parameter[7:0] ANL_A_R7       = 8'b01011111; 
   
   // 60H - 6Fh
   parameter[7:0] JZ             = 8'b01100000; 
   parameter[7:0] AJMP_3         = 8'b01100001; 
   parameter[7:0] XRL_ADDR_A     = 8'b01100010; 
   parameter[7:0] XRL_ADDR_N     = 8'b01100011; 
   parameter[7:0] XRL_A_N        = 8'b01100100; 
   parameter[7:0] XRL_A_ADDR     = 8'b01100101; 
   parameter[7:0] XRL_A_IR0      = 8'b01100110; 
   parameter[7:0] XRL_A_IR1      = 8'b01100111; 
   parameter[7:0] XRL_A_R0       = 8'b01101000; 
   parameter[7:0] XRL_A_R1       = 8'b01101001; 
   parameter[7:0] XRL_A_R2       = 8'b01101010; 
   parameter[7:0] XRL_A_R3       = 8'b01101011; 
   parameter[7:0] XRL_A_R4       = 8'b01101100; 
   parameter[7:0] XRL_A_R5       = 8'b01101101; 
   parameter[7:0] XRL_A_R6       = 8'b01101110; 
   parameter[7:0] XRL_A_R7       = 8'b01101111; 
   
   // 70H - 7Fh
   parameter[7:0] JNZ            = 8'b01110000; 
   parameter[7:0] ACALL_3        = 8'b01110001; 
   parameter[7:0] ORL_C_BIT      = 8'b01110010; 
   parameter[7:0] JMP_A_DPTR     = 8'b01110011; 
   parameter[7:0] MOV_A_N        = 8'b01110100; 
   parameter[7:0] MOV_ADDR_N     = 8'b01110101; 
   parameter[7:0] MOV_IR0_N      = 8'b01110110; 
   parameter[7:0] MOV_IR1_N      = 8'b01110111; 
   parameter[7:0] MOV_R0_N       = 8'b01111000; 
   parameter[7:0] MOV_R1_N       = 8'b01111001; 
   parameter[7:0] MOV_R2_N       = 8'b01111010; 
   parameter[7:0] MOV_R3_N       = 8'b01111011; 
   parameter[7:0] MOV_R4_N       = 8'b01111100; 
   parameter[7:0] MOV_R5_N       = 8'b01111101; 
   parameter[7:0] MOV_R6_N       = 8'b01111110; 
   parameter[7:0] MOV_R7_N       = 8'b01111111; 
   
   // 80H - 8Fh
   parameter[7:0] SJMP           = 8'b10000000; 
   parameter[7:0] AJMP_4         = 8'b10000001; 
   parameter[7:0] ANL_C_BIT      = 8'b10000010; 
   parameter[7:0] MOVC_A_PC      = 8'b10000011; 
   parameter[7:0] DIV_AB         = 8'b10000100; 
   parameter[7:0] MOV_ADDR_ADDR  = 8'b10000101; 
   parameter[7:0] MOV_ADDR_IR0   = 8'b10000110; 
   parameter[7:0] MOV_ADDR_IR1   = 8'b10000111; 
   parameter[7:0] MOV_ADDR_R0    = 8'b10001000; 
   parameter[7:0] MOV_ADDR_R1    = 8'b10001001; 
   parameter[7:0] MOV_ADDR_R2    = 8'b10001010; 
   parameter[7:0] MOV_ADDR_R3    = 8'b10001011; 
   parameter[7:0] MOV_ADDR_R4    = 8'b10001100; 
   parameter[7:0] MOV_ADDR_R5    = 8'b10001101; 
   parameter[7:0] MOV_ADDR_R6    = 8'b10001110; 
   parameter[7:0] MOV_ADDR_R7    = 8'b10001111; 
   
   // 90H - 9Fh
   parameter[7:0] MOV_DPTR_N     = 8'b10010000; 
   parameter[7:0] ACALL_4        = 8'b10010001; 
   parameter[7:0] MOV_BIT_C      = 8'b10010010; 
   parameter[7:0] MOVC_A_DPTR    = 8'b10010011; 
   parameter[7:0] SUBB_N         = 8'b10010100; 
   parameter[7:0] SUBB_ADDR      = 8'b10010101; 
   parameter[7:0] SUBB_IR0       = 8'b10010110; 
   parameter[7:0] SUBB_IR1       = 8'b10010111; 
   parameter[7:0] SUBB_R0        = 8'b10011000; 
   parameter[7:0] SUBB_R1        = 8'b10011001; 
   parameter[7:0] SUBB_R2        = 8'b10011010; 
   parameter[7:0] SUBB_R3        = 8'b10011011; 
   parameter[7:0] SUBB_R4        = 8'b10011100; 
   parameter[7:0] SUBB_R5        = 8'b10011101; 
   parameter[7:0] SUBB_R6        = 8'b10011110; 
   parameter[7:0] SUBB_R7        = 8'b10011111; 
   
   // A0H - AFh
   parameter[7:0] ORL_C_NBIT     = 8'b10100000; 
   parameter[7:0] AJMP_5         = 8'b10100001; 
   parameter[7:0] MOV_C_BIT      = 8'b10100010; 
   parameter[7:0] INC_DPTR       = 8'b10100011; 
   parameter[7:0] MUL_AB         = 8'b10100100; 
   parameter[7:0] UNKNOWN        = 8'b10100101; 
   parameter[7:0] MOV_IR0_ADDR   = 8'b10100110; 
   parameter[7:0] MOV_IR1_ADDR   = 8'b10100111; 
   parameter[7:0] MOV_R0_ADDR    = 8'b10101000; 
   parameter[7:0] MOV_R1_ADDR    = 8'b10101001; 
   parameter[7:0] MOV_R2_ADDR    = 8'b10101010; 
   parameter[7:0] MOV_R3_ADDR    = 8'b10101011; 
   parameter[7:0] MOV_R4_ADDR    = 8'b10101100; 
   parameter[7:0] MOV_R5_ADDR    = 8'b10101101; 
   parameter[7:0] MOV_R6_ADDR    = 8'b10101110; 
   parameter[7:0] MOV_R7_ADDR    = 8'b10101111; 
   
   // B0H - BFh
   parameter[7:0] ANL_C_NBIT     = 8'b10110000; 
   parameter[7:0] ACALL_5        = 8'b10110001; 
   parameter[7:0] CPL_BIT        = 8'b10110010; 
   parameter[7:0] CPL_C          = 8'b10110011; 
   parameter[7:0] CJNE_A_N       = 8'b10110100; 
   parameter[7:0] CJNE_A_ADDR    = 8'b10110101; 
   parameter[7:0] CJNE_IR0_N     = 8'b10110110; 
   parameter[7:0] CJNE_IR1_N     = 8'b10110111; 
   parameter[7:0] CJNE_R0_N      = 8'b10111000; 
   parameter[7:0] CJNE_R1_N      = 8'b10111001; 
   parameter[7:0] CJNE_R2_N      = 8'b10111010; 
   parameter[7:0] CJNE_R3_N      = 8'b10111011; 
   parameter[7:0] CJNE_R4_N      = 8'b10111100; 
   parameter[7:0] CJNE_R5_N      = 8'b10111101; 
   parameter[7:0] CJNE_R6_N      = 8'b10111110; 
   parameter[7:0] CJNE_R7_N      = 8'b10111111; 
   
   // C0H - CFh
   parameter[7:0] PUSH           = 8'b11000000; 
   parameter[7:0] AJMP_6         = 8'b11000001; 
   parameter[7:0] CLR_BIT        = 8'b11000010; 
   parameter[7:0] CLR_C          = 8'b11000011; 
   parameter[7:0] SWAP_A         = 8'b11000100; 
   parameter[7:0] XCH_ADDR       = 8'b11000101; 
   parameter[7:0] XCH_IR0        = 8'b11000110; 
   parameter[7:0] XCH_IR1        = 8'b11000111; 
   parameter[7:0] XCH_R0         = 8'b11001000; 
   parameter[7:0] XCH_R1         = 8'b11001001; 
   parameter[7:0] XCH_R2         = 8'b11001010; 
   parameter[7:0] XCH_R3         = 8'b11001011; 
   parameter[7:0] XCH_R4         = 8'b11001100; 
   parameter[7:0] XCH_R5         = 8'b11001101; 
   parameter[7:0] XCH_R6         = 8'b11001110; 
   parameter[7:0] XCH_R7         = 8'b11001111; 
   
   // D0H - DFh
   parameter[7:0] POP            = 8'b11010000; 
   parameter[7:0] ACALL_6        = 8'b11010001; 
   parameter[7:0] SETB_BIT       = 8'b11010010; 
   parameter[7:0] SETB_C         = 8'b11010011; 
   parameter[7:0] DA_A           = 8'b11010100; 
   parameter[7:0] DJNZ_ADDR      = 8'b11010101; 
   parameter[7:0] XCHD_IR0       = 8'b11010110; 
   parameter[7:0] XCHD_IR1       = 8'b11010111; 
   parameter[7:0] DJNZ_R0        = 8'b11011000; 
   parameter[7:0] DJNZ_R1        = 8'b11011001; 
   parameter[7:0] DJNZ_R2        = 8'b11011010; 
   parameter[7:0] DJNZ_R3        = 8'b11011011; 
   parameter[7:0] DJNZ_R4        = 8'b11011100; 
   parameter[7:0] DJNZ_R5        = 8'b11011101; 
   parameter[7:0] DJNZ_R6        = 8'b11011110; 
   parameter[7:0] DJNZ_R7        = 8'b11011111; 
   
   // E0H - EFh
   parameter[7:0] MOVX_A_IDPTR   = 8'b11100000; 
   parameter[7:0] AJMP_7         = 8'b11100001; 
   parameter[7:0] MOVX_A_IR0     = 8'b11100010; 
   parameter[7:0] MOVX_A_IR1     = 8'b11100011; 
   parameter[7:0] CLR_A          = 8'b11100100; 
   parameter[7:0] MOV_A_ADDR     = 8'b11100101; 
   parameter[7:0] MOV_A_IR0      = 8'b11100110; 
   parameter[7:0] MOV_A_IR1      = 8'b11100111; 
   parameter[7:0] MOV_A_R0       = 8'b11101000; 
   parameter[7:0] MOV_A_R1       = 8'b11101001; 
   parameter[7:0] MOV_A_R2       = 8'b11101010; 
   parameter[7:0] MOV_A_R3       = 8'b11101011; 
   parameter[7:0] MOV_A_R4       = 8'b11101100; 
   parameter[7:0] MOV_A_R5       = 8'b11101101; 
   parameter[7:0] MOV_A_R6       = 8'b11101110; 
   parameter[7:0] MOV_A_R7       = 8'b11101111; 
   
   // F0H - FFh
   parameter[7:0] MOVX_IDPTR_A   = 8'b11110000; 
   parameter[7:0] ACALL_7        = 8'b11110001; 
   parameter[7:0] MOVX_IR0_A     = 8'b11110010; 
   parameter[7:0] MOVX_IR1_A     = 8'b11110011; 
   parameter[7:0] CPL_A          = 8'b11110100; 
   parameter[7:0] MOV_ADDR_A     = 8'b11110101; 
   parameter[7:0] MOV_IR0_A      = 8'b11110110; 
   parameter[7:0] MOV_IR1_A      = 8'b11110111; 
   parameter[7:0] MOV_R0_A       = 8'b11111000; 
   parameter[7:0] MOV_R1_A       = 8'b11111001; 
   parameter[7:0] MOV_R2_A       = 8'b11111010; 
   parameter[7:0] MOV_R3_A       = 8'b11111011; 
   parameter[7:0] MOV_R4_A       = 8'b11111100; 
   parameter[7:0] MOV_R5_A       = 8'b11111101; 
   parameter[7:0] MOV_R6_A       = 8'b11111110; 
   parameter[7:0] MOV_R7_A       = 8'b11111111; 
   
   //-----------------------------------------------------------------
   // Interrupt reset values
   //-----------------------------------------------------------------
   parameter[4:0] VECT_RV        = 5'b00000; // Interrupt Vector reset value
   parameter[3:0] IS_REG_RV      = 4'b0000;  // In Service Register reset value

   //-----------------------------------------------------------------
   // Interrupt Vector locations
   //-----------------------------------------------------------------
   // external interrupt 0
   parameter[4:0] VECT_E0        = 5'b00000; 
   
   // timer 0 overflow
   parameter[4:0] VECT_TF0       = 5'b00001; 
   
   // external interrupt 1
   parameter[4:0] VECT_E1        = 5'b00010; 
   
   // timer 1 overflow
   parameter[4:0] VECT_TF1       = 5'b00011; 
   
   // serial channel 0
   parameter[4:0] VECT_SER0      = 5'b00100; 
   
   // timer 2 overflow/ext. reload
   parameter[4:0] VECT_TF2       = 5'b00101; 
   
   // A/D converter 
   parameter[4:0] VECT_ADC       = 5'b01000; 
   
   // external interrupt 2
   parameter[4:0] VECT_EX2       = 5'b01001; 
   
   // external interrupt 3
   parameter[4:0] VECT_EX3       = 5'b01010; 
   
   // external interrupt 4
   parameter[4:0] VECT_EX4       = 5'b01011; 
   
   // external interrupt 5
   parameter[4:0] VECT_EX5       = 5'b01100; 
   
   // external interrupt 6
   parameter[4:0] VECT_EX6       = 5'b01101; 
   
   // serial channel 1
   parameter[4:0] VECT_SER1      = 5'b10000; 

   //-----------------------------------------------------------------
   // Start address location
   //-----------------------------------------------------------------
   parameter[15:0] ADDR_RV       = 16'b0000000000000000; //


   //-----------------------------------------------------------------
   // RAM & SFR address reset value
   //-----------------------------------------------------------------
   parameter[7:0] RAM_SFR_ADDR_RV= 8'b00000000; //


   //-----------------------------------------------------------------
   // Data register reset value
   //-----------------------------------------------------------------
   parameter[7:0] DATAREG_RV     = 8'b00000000; //


   //-----------------------------------------------------------------
   // High ordered half of address during indirect addressing
   //-----------------------------------------------------------------
   parameter[7:0] ADDR_HIGH_RI   = 8'b00000000; //


   //-----------------------------------------------------------------
   // Watchdog Timer reset value
   //-----------------------------------------------------------------
   parameter[6:0] WDTH_RV        = 7'b0000000;  // High ordered WDT
   parameter[7:0] WDTL_RV        = 8'b00000000; // Low ordered WDT


   //-----------------------------------------------------------------
   // Watchdog Timer reset state
   //-----------------------------------------------------------------
   parameter[14:0] WDT_RS        = 15'b111111111111100; // X"7FFC"



//*******************************************************************--
