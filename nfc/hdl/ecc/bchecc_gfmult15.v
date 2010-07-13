//+File Header//////////////////////////////////////////////////////////////////
//Copyright 2009, shhic. All rights reserved
//Filename    : bchecc_gfmult15.v
//Module name : bchecc_gfmult15
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
module  bchecc_gfmult15(
                data_a1_i,
                data_a2_i,
                data_a3_i,
                data_a4_i,
                data_a5_i,
                data_a6_i,
                data_a7_i,
                data_a8_i,
                data_a9_i,
                data_a10_i,
                data_a11_i,
                data_a12_i,
                data_a13_i,
                data_a14_i,
                data_a15_i,
                data_b1_i,
                data_b2_i,
                data_b3_i,
                data_b4_i,
                data_b5_i,
                data_b6_i,
                data_b7_i,
                data_b8_i,
                data_b9_i,
                data_b10_i,
                data_b11_i,
                data_b12_i,
                data_b13_i,
                data_b14_i,
                data_b15_i,
                data_s1_o,
                data_s2_o,
                data_s3_o,
                data_s4_o,
                data_s5_o,
                data_s6_o,
                data_s7_o,
                data_s8_o,
                data_s9_o,
                data_s10_o,
                data_s11_o,
                data_s12_o,
                data_s13_o,
                data_s14_o,
                data_s15_o
                );
////////////////input port
input   [12:0]  data_a1_i;
input   [12:0]  data_a2_i;
input   [12:0]  data_a3_i;
input   [12:0]  data_a4_i;
input   [12:0]  data_a5_i;
input   [12:0]  data_a6_i;
input   [12:0]  data_a7_i;
input   [12:0]  data_a8_i;
input   [12:0]  data_a9_i;
input   [12:0]  data_a10_i;
input   [12:0]  data_a11_i;
input   [12:0]  data_a12_i;
input   [12:0]  data_a13_i;
input   [12:0]  data_a14_i;
input   [12:0]  data_a15_i;
input   [12:0]  data_b1_i;
input   [12:0]  data_b2_i;
input   [12:0]  data_b3_i;
input   [12:0]  data_b4_i;
input   [12:0]  data_b5_i;
input   [12:0]  data_b6_i;
input   [12:0]  data_b7_i;
input   [12:0]  data_b8_i;
input   [12:0]  data_b9_i;
input   [12:0]  data_b10_i;
input   [12:0]  data_b11_i;
input   [12:0]  data_b12_i;
input   [12:0]  data_b13_i;
input   [12:0]  data_b14_i;
input   [12:0]  data_b15_i;

////////////////output port
output  [12:0]  data_s1_o;
output  [12:0]  data_s2_o;
output  [12:0]  data_s3_o;
output  [12:0]  data_s4_o;
output  [12:0]  data_s5_o;
output  [12:0]  data_s6_o;
output  [12:0]  data_s7_o;
output  [12:0]  data_s8_o;
output  [12:0]  data_s9_o;
output  [12:0]  data_s10_o;
output  [12:0]  data_s11_o;
output  [12:0]  data_s12_o;
output  [12:0]  data_s13_o;
output  [12:0]  data_s14_o;
output  [12:0]  data_s15_o;

////////////////mult calculate
bchecc_gfmult u1_gfmult(
                .a_i        (data_a1_i),
                .b_i        (data_b1_i),
                .s_o        (data_s1_o)
                );
                
bchecc_gfmult u2_gfmult(
                .a_i        (data_a2_i),
                .b_i        (data_b2_i),
                .s_o        (data_s2_o)
                );
                
bchecc_gfmult u3_gfmult(
                .a_i        (data_a3_i),
                .b_i        (data_b3_i),
                .s_o        (data_s3_o)
                );
                
bchecc_gfmult u4_gfmult(
                .a_i        (data_a4_i),
                .b_i        (data_b4_i),
                .s_o        (data_s4_o)
                );
                
bchecc_gfmult u5_gfmult(
                .a_i        (data_a5_i),
                .b_i        (data_b5_i),
                .s_o        (data_s5_o)
                );
                
bchecc_gfmult u6_gfmult(
                .a_i        (data_a6_i),
                .b_i        (data_b6_i),
                .s_o        (data_s6_o)
                );
                
bchecc_gfmult u7_gfmult(
                .a_i        (data_a7_i),
                .b_i        (data_b7_i),
                .s_o        (data_s7_o)
                );
                
bchecc_gfmult u8_gfmult(
                .a_i        (data_a8_i),
                .b_i        (data_b8_i),
                .s_o        (data_s8_o)
                );
                
bchecc_gfmult u9_gfmult(
                .a_i        (data_a9_i),
                .b_i        (data_b9_i),
                .s_o        (data_s9_o)
                );
                
bchecc_gfmult u10_gfmult(
                .a_i        (data_a10_i),
                .b_i        (data_b10_i),
                .s_o        (data_s10_o)
                );
                
bchecc_gfmult u11_gfmult(
                .a_i        (data_a11_i),
                .b_i        (data_b11_i),
                .s_o        (data_s11_o)
                );
                
bchecc_gfmult u12_gfmult(
                .a_i        (data_a12_i),
                .b_i        (data_b12_i),
                .s_o        (data_s12_o)
                );
                
bchecc_gfmult u13_gfmult(
                .a_i        (data_a13_i),
                .b_i        (data_b13_i),
                .s_o        (data_s13_o)
                );
                
bchecc_gfmult u14_gfmult(
                .a_i        (data_a14_i),
                .b_i        (data_b14_i),
                .s_o        (data_s14_o)
                );
                
bchecc_gfmult u15_gfmult(
                .a_i        (data_a15_i),
                .b_i        (data_b15_i),
                .s_o        (data_s15_o)
                );

endmodule
                