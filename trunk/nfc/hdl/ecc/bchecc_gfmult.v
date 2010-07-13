//+File Header//////////////////////////////////////////////////////////////////
//Copyright 2009, shhic. All rights reserved
//Filename    : bchecc_gfmult.v
//Module name : bchecc_gfmult
//Department  : security
//Author      : Xu Yunxiu
//Author's mail : xuyx@shhic.com
//------------------------------------------------------------------------ 
// Release history 
// VERSION  Date       AUTHOR       DESCRIPTION 
// 1.0      2010-6-1   Xun Yunxiu   Initial version
//------------------------------------------------------------------------ 
// Other: The IP is based on ECC_V100.
//-File Header//////////////////////////////////////////////////////////////////

`timescale 1ns/100ps
module  bchecc_gfmult(
                a_i,
                b_i,
                s_o
                );
input   [12:0]  a_i;
input   [12:0]  b_i;
output  [12:0]  s_o;

parameter       s13 = 13'b0000000011011;
parameter       s14 = 13'b0000000110110;
parameter       s15 = 13'b0000001101100;
parameter       s16 = 13'b0000011011000;
parameter       s17 = 13'b0000110110000;
parameter       s18 = 13'b0001101100000;
parameter       s19 = 13'b0011011000000;
parameter       s20 = 13'b0110110000000;
parameter       s21 = 13'b1101100000000;
parameter       s22 = 13'b1011000011011;
parameter       s23 = 13'b0110000101101;
parameter       s24 = 13'b1100001011010;

wire    [12:0]  s0_tmp0,s0_tmp1,s0_tmp2,s0_tmp3,s0_tmp4,s0_tmp5,s0_tmp6;
wire    [12:0]  s0_tmp7,s0_tmp8,s0_tmp9,s0_tmp10,s0_tmp11,s0_tmp12;
wire    [24:0]  s0_tmp;
wire    [12:0]  s1_tmp0,s1_tmp1,s1_tmp2,s1_tmp3,s1_tmp4,s1_tmp5;
wire    [12:0]  s1_tmp6,s1_tmp7,s1_tmp8,s1_tmp9,s1_tmp10,s1_tmp11;


assign  s0_tmp0  = a_i & {13{b_i[0]}};
assign  s0_tmp1  = a_i & {13{b_i[1]}};
assign  s0_tmp2  = a_i & {13{b_i[2]}};
assign  s0_tmp3  = a_i & {13{b_i[3]}};
assign  s0_tmp4  = a_i & {13{b_i[4]}};
assign  s0_tmp5  = a_i & {13{b_i[5]}};
assign  s0_tmp6  = a_i & {13{b_i[6]}};
assign  s0_tmp7  = a_i & {13{b_i[7]}};
assign  s0_tmp8  = a_i & {13{b_i[8]}};
assign  s0_tmp9  = a_i & {13{b_i[9]}};
assign  s0_tmp10 = a_i & {13{b_i[10]}};
assign  s0_tmp11 = a_i & {13{b_i[11]}};
assign  s0_tmp12 = a_i & {13{b_i[12]}};

assign  s0_tmp[0]  = s0_tmp0[0];
assign  s0_tmp[1]  = s0_tmp0[1] ^ s0_tmp1[0];
assign  s0_tmp[2]  = s0_tmp0[2] ^ s0_tmp1[1] ^ s0_tmp2[0];
assign  s0_tmp[3]  = s0_tmp0[3] ^ s0_tmp1[2] ^ s0_tmp2[1] ^ s0_tmp3[0];
assign  s0_tmp[4]  = s0_tmp0[4] ^ s0_tmp1[3] ^ s0_tmp2[2] ^ s0_tmp3[1] ^ s0_tmp4[0];
assign  s0_tmp[5]  = s0_tmp0[5] ^ s0_tmp1[4] ^ s0_tmp2[3] ^ s0_tmp3[2] ^ s0_tmp4[1] ^ s0_tmp5[0];
assign  s0_tmp[6]  = s0_tmp0[6] ^ s0_tmp1[5] ^ s0_tmp2[4] ^ s0_tmp3[3] ^ s0_tmp4[2] ^ s0_tmp5[1] ^ s0_tmp6[0];
assign  s0_tmp[7]  = s0_tmp0[7] ^ s0_tmp1[6] ^ s0_tmp2[5] ^ s0_tmp3[4] ^ s0_tmp4[3] ^ s0_tmp5[2] ^ s0_tmp6[1] ^ s0_tmp7[0];
assign  s0_tmp[8]  = s0_tmp0[8] ^ s0_tmp1[7] ^ s0_tmp2[6] ^ s0_tmp3[5] ^ s0_tmp4[4] ^ s0_tmp5[3] ^ s0_tmp6[2] ^ s0_tmp7[1] ^ s0_tmp8[0];
assign  s0_tmp[9]  = s0_tmp0[9] ^ s0_tmp1[8] ^ s0_tmp2[7] ^ s0_tmp3[6] ^ s0_tmp4[5] ^ s0_tmp5[4] ^ s0_tmp6[3] ^ s0_tmp7[2] ^ s0_tmp8[1] ^ s0_tmp9[0];
assign  s0_tmp[10] = s0_tmp0[10] ^ s0_tmp1[9] ^ s0_tmp2[8] ^ s0_tmp3[7] ^ s0_tmp4[6] ^ s0_tmp5[5] ^ s0_tmp6[4] ^ s0_tmp7[3] ^ s0_tmp8[2] ^ s0_tmp9[1] ^ s0_tmp10[0];
assign  s0_tmp[11] = s0_tmp0[11] ^ s0_tmp1[10] ^ s0_tmp2[9] ^ s0_tmp3[8] ^ s0_tmp4[7] ^ s0_tmp5[6] ^ s0_tmp6[5] ^ s0_tmp7[4] ^ s0_tmp8[3] ^ s0_tmp9[2] ^ s0_tmp10[1] ^ s0_tmp11[0];
assign  s0_tmp[12] = s0_tmp0[12] ^ s0_tmp1[11] ^ s0_tmp2[10] ^ s0_tmp3[9] ^ s0_tmp4[8] ^ s0_tmp5[7] ^ s0_tmp6[6] ^ s0_tmp7[5] ^ s0_tmp8[4] ^ s0_tmp9[3] ^ s0_tmp10[2] ^ s0_tmp11[1] ^ s0_tmp12[0];
assign  s0_tmp[13] = s0_tmp1[12] ^ s0_tmp2[11] ^ s0_tmp3[10] ^ s0_tmp4[9] ^ s0_tmp5[8] ^ s0_tmp6[7] ^ s0_tmp7[6] ^ s0_tmp8[5] ^ s0_tmp9[4] ^ s0_tmp10[3] ^ s0_tmp11[2] ^ s0_tmp12[1];
assign  s0_tmp[14] = s0_tmp2[12] ^ s0_tmp3[11] ^ s0_tmp4[10] ^ s0_tmp5[9] ^ s0_tmp6[8] ^ s0_tmp7[7] ^ s0_tmp8[6] ^ s0_tmp9[5] ^ s0_tmp10[4] ^ s0_tmp11[3] ^ s0_tmp12[2];
assign  s0_tmp[15] = s0_tmp3[12] ^ s0_tmp4[11] ^ s0_tmp5[10] ^ s0_tmp6[9] ^ s0_tmp7[8] ^ s0_tmp8[7] ^ s0_tmp9[6] ^ s0_tmp10[5] ^ s0_tmp11[4] ^ s0_tmp12[3];
assign  s0_tmp[16] = s0_tmp4[12] ^ s0_tmp5[11] ^ s0_tmp6[10] ^ s0_tmp7[9] ^ s0_tmp8[8] ^ s0_tmp9[7] ^ s0_tmp10[6] ^ s0_tmp11[5] ^ s0_tmp12[4];
assign  s0_tmp[17] = s0_tmp5[12] ^ s0_tmp6[11] ^ s0_tmp7[10] ^ s0_tmp8[9] ^ s0_tmp9[8] ^ s0_tmp10[7] ^ s0_tmp11[6] ^ s0_tmp12[5];
assign  s0_tmp[18] = s0_tmp6[12] ^ s0_tmp7[11] ^ s0_tmp8[10] ^ s0_tmp9[9] ^ s0_tmp10[8] ^ s0_tmp11[7] ^ s0_tmp12[6];
assign  s0_tmp[19] = s0_tmp7[12] ^ s0_tmp8[11] ^ s0_tmp9[10] ^ s0_tmp10[9] ^ s0_tmp11[8] ^ s0_tmp12[7];
assign  s0_tmp[20] = s0_tmp8[12] ^ s0_tmp9[11] ^ s0_tmp10[10] ^ s0_tmp11[9] ^ s0_tmp12[8];
assign  s0_tmp[21] = s0_tmp9[12] ^ s0_tmp10[11] ^ s0_tmp11[10] ^ s0_tmp12[9];
assign  s0_tmp[22] = s0_tmp10[12] ^ s0_tmp11[11] ^ s0_tmp12[10];
assign  s0_tmp[23] = s0_tmp11[12] ^ s0_tmp12[11];
assign  s0_tmp[24] = s0_tmp12[12];

assign  s1_tmp11 = s24 & {13{s0_tmp[24]}};
assign  s1_tmp10 = s23 & {13{s0_tmp[23]}};
assign  s1_tmp9  = s22 & {13{s0_tmp[22]}};
assign  s1_tmp8  = s21 & {13{s0_tmp[21]}};
assign  s1_tmp7  = s20 & {13{s0_tmp[20]}};
assign  s1_tmp6  = s19 & {13{s0_tmp[19]}};
assign  s1_tmp5  = s18 & {13{s0_tmp[18]}};
assign  s1_tmp4  = s17 & {13{s0_tmp[17]}};
assign  s1_tmp3  = s16 & {13{s0_tmp[16]}};
assign  s1_tmp2  = s15 & {13{s0_tmp[15]}};
assign  s1_tmp1  = s14 & {13{s0_tmp[14]}};
assign  s1_tmp0  = s13 & {13{s0_tmp[13]}};

assign  s_o = s0_tmp[12:0] ^ s1_tmp0 ^ s1_tmp1 ^ s1_tmp2 ^ s1_tmp3 ^ s1_tmp4 ^ s1_tmp5 ^ s1_tmp6 ^ s1_tmp7 ^ s1_tmp8 ^ s1_tmp9 ^ s1_tmp10 ^ s1_tmp11;

endmodule
                
