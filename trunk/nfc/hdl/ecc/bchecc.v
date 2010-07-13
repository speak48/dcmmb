//+File Header//////////////////////////////////////////////////////////////////
//Copyright 2009, shhic. All rights reserved
//Filename    : bchecc.v
//Module name : bchecc
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
module  bchecc(
                rst_n,
                clk,
                sfr_en_i,
                sfr_rd_i,
                sfr_wr_i,
                sfr_size_i,
                sfr_addr_i,
                sfr_wdata_i,
                ecc_wr_i,
                ecc_data_i,
                sfr_rdata_o,
                ecc_wr_o,
                enc_data_o,
                dec_addr_o,
                ecc_done_o
                );
////////////////input
input           rst_n;
input           clk;
input           sfr_en_i;
input           sfr_rd_i;
input           sfr_wr_i;
input   [1:0]   sfr_size_i;
input   [3:0]   sfr_addr_i;
input   [31:0]  sfr_wdata_i;
input           ecc_wr_i;
input   [7:0]   ecc_data_i;

////////////////output
output  [31:0]  sfr_rdata_o;
output          ecc_wr_o;
output  [7:0]   enc_data_o;
output  [12:0]  dec_addr_o;
output          ecc_done_o;

////////////////internal signals
wire    [3:0]   ecc_ctrl;
wire    [9:0]   ecc_cfg;

wire            init_en;
wire    [7:0]   ecc_data;
wire            change_stat;
wire            ecc_busy;
wire            ecc_block;
wire            ecc_error;
wire            correct_fail;

wire            enc_data_avail;
wire            dec_data_avail;
wire            enc_last;
wire            enc_out_en;
wire            enc_out_first;

wire            bma_opt;
wire            bma_load;
wire            syndm_en;
wire            delta_en;
wire            bma_en;
wire            bma_end;

wire    [4:0]   bma_cnt;
wire    [3:0]   delta_cnt;
wire    [3:0]   bma_sel_cnt;

wire            chien_load;
wire            chien_en;
wire            chien_out;
wire            chien_first;
wire    [1:0]   over_cnt;
wire    [3:0]   error_cnt;

wire    [12:0]  syndm1; 
wire    [12:0]  syndm3; 
wire    [12:0]  syndm5; 
wire    [12:0]  syndm7; 
wire    [12:0]  syndm9; 
wire    [12:0]  syndm11;
wire    [12:0]  syndm13;
wire    [12:0]  syndm15;
wire    [12:0]  syndm17;
wire    [12:0]  syndm19;
wire    [12:0]  syndm21;
wire    [12:0]  syndm23;
wire    [12:0]  syndm25;
wire    [12:0]  syndm27;
wire    [12:0]  syndm29;

wire    [4:0]   bma_expt;
wire            bma_error;
wire    [12:0]  bma_ex0;
wire    [12:0]  bma_ex1;
wire    [12:0]  bma_ex2;
wire    [12:0]  bma_ex3;
wire    [12:0]  bma_ex4;
wire    [12:0]  bma_ex5;
wire    [12:0]  bma_ex6;
wire    [12:0]  bma_ex7;
wire    [12:0]  bma_ex8;
wire    [12:0]  bma_ex9;
wire    [12:0]  bma_ex10;
wire    [12:0]  bma_ex11;
wire    [12:0]  bma_ex12;
wire    [12:0]  bma_ex13;
wire    [12:0]  bma_ex14;
wire    [12:0]  bma_ex15;

wire            detect_error;
wire    [5:0]   error_data;

bchecc_reg  u0_reg(
                .rst_n          (rst_n),
                .clk            (clk),
                .sfr_en_i       (sfr_en_i),
                .sfr_rd_i       (sfr_rd_i),
                .sfr_wr_i       (sfr_wr_i),
                .sfr_size_i     (sfr_size_i),
                .sfr_addr_i     (sfr_addr_i),
                .sfr_wdata_i    (sfr_wdata_i),
                .change_stat_i  (change_stat),
                .ecc_busy_i     (ecc_busy),
                .ecc_block_i    (ecc_block),
                .ecc_error_i    (ecc_error),
                .correct_fail_i (correct_fail),
                .error_cnt_i    (error_cnt),
                .sfr_rdata_o    (sfr_rdata_o),
                .ecc_ctrl_o     (ecc_ctrl),
                .ecc_cfg_o      (ecc_cfg)
                );

bchecc_fsm  u0_fsm(
                .rst_n            (rst_n),
                .clk              (clk),
                .ecc_ctrl_i       (ecc_ctrl),
                .ecc_cfg_i        (ecc_cfg),
                .ecc_wr_i         (ecc_wr_i),
                .ecc_data_i       (ecc_data_i),
                .bma_error_i      (bma_error),
                .bma_expt_i       (bma_expt),
                .detect_error_i   (detect_error),
                .error_data_i     (error_data),
                
                .init_en_o        (init_en),
                .ecc_data_o       (ecc_data),
                .ecc_wr_o         (ecc_wr_o),
                .ecc_done_o       (ecc_done_o),
                .error_addr_o     (dec_addr_o),
                .change_stat_o    (change_stat),
                .ecc_busy_o       (ecc_busy),
                .ecc_block_o      (ecc_block),
                .ecc_error_o      (ecc_error),
                .correct_fail_o   (correct_fail),
               
                .enc_data_avail_o (enc_data_avail),
                .dec_data_avail_o (dec_data_avail),
                .enc_last_o       (enc_last),
                .enc_out_en_o     (enc_out_en),
                .enc_out_first_o  (enc_out_first),
               
                .bma_opt_o        (bma_opt),
                .bma_load_o       (bma_load),
                .syndm_en_o       (syndm_en),
                .delta_en_o       (delta_en),
                .bma_en_o         (bma_en),
                .bma_end_o        (bma_end),
               
                .bma_cnt_o        (bma_cnt),
                .delta_cnt_o      (delta_cnt),
                .bma_sel_cnt_o    (bma_sel_cnt),
               
                .chien_load_o     (chien_load),
                .chien_en_o       (chien_en),
                .chien_out_o      (chien_out),
                .chien_first_o    (chien_first),
                .over_cnt_o       (over_cnt),
                .error_cnt_o      (error_cnt)
                );

bchecc_enc u0_enc(
                .rst_n            (rst_n),
                .clk              (clk),
                .init_en_i        (init_en),
                .ecc_opt_i        (ecc_ctrl[1]),
                .ecc_data_i       (ecc_data),
                .enc_data_avail_i (enc_data_avail),
                .enc_last_i       (enc_last),
                .enc_out_en_i     (enc_out_en),
                .enc_out_first_i  (enc_out_first),
                .enc_data_o       (enc_data_o)
                );

bchecc_syndm  u0_syndm(
                .rst_n            (rst_n),
                .clk              (clk),
                .ecc_opt_i        (ecc_ctrl[1]),
                .init_en_i        (init_en),
                .dec_data_i       (ecc_data),
                .dec_data_avail_i (dec_data_avail),
                .syndm1_o         (syndm1), 
                .syndm3_o         (syndm3), 
                .syndm5_o         (syndm5), 
                .syndm7_o         (syndm7), 
                .syndm9_o         (syndm9), 
                .syndm11_o        (syndm11),
                .syndm13_o        (syndm13),
                .syndm15_o        (syndm15),
                .syndm17_o        (syndm17),
                .syndm19_o        (syndm19),
                .syndm21_o        (syndm21),
                .syndm23_o        (syndm23),
                .syndm25_o        (syndm25),
                .syndm27_o        (syndm27),
                .syndm29_o        (syndm29)
                );

bchecc_bma  u0_bma(
                .rst_n         (rst_n),
                .clk           (clk),
                .bma_opt_i     (bma_opt),
                .bma_load_i    (bma_load),
                .syndm_en_i    (syndm_en),
                .delta_en_i    (delta_en),
                .bma_en_i      (bma_en),
                .bma_end_i     (bma_end),
                .bma_cnt_i     (bma_cnt),
                .delta_cnt_i   (delta_cnt),
                .bma_sel_cnt_i (bma_sel_cnt),
                .syndm1_i      (syndm1), 
                .syndm3_i      (syndm3), 
                .syndm5_i      (syndm5), 
                .syndm7_i      (syndm7), 
                .syndm9_i      (syndm9), 
                .syndm11_i     (syndm11),
                .syndm13_i     (syndm13),
                .syndm15_i     (syndm15),
                .syndm17_i     (syndm17),
                .syndm19_i     (syndm19),
                .syndm21_i     (syndm21),
                .syndm23_i     (syndm23),
                .syndm25_i     (syndm25),
                .syndm27_i     (syndm27),
                .syndm29_i     (syndm29),
                .bma_expt_o    (bma_expt),
                .bma_error_o   (bma_error),
                .bma_ex0_o     (bma_ex0),
                .bma_ex1_o     (bma_ex1),
                .bma_ex2_o     (bma_ex2),
                .bma_ex3_o     (bma_ex3),
                .bma_ex4_o     (bma_ex4),
                .bma_ex5_o     (bma_ex5),
                .bma_ex6_o     (bma_ex6),
                .bma_ex7_o     (bma_ex7),
                .bma_ex8_o     (bma_ex8),
                .bma_ex9_o     (bma_ex9),
                .bma_ex10_o    (bma_ex10),
                .bma_ex11_o    (bma_ex11),
                .bma_ex12_o    (bma_ex12),
                .bma_ex13_o    (bma_ex13),
                .bma_ex14_o    (bma_ex14),
                .bma_ex15_o    (bma_ex15)
                );

bchecc_chien  u0_chien(
                .rst_n          (rst_n),
                .clk            (clk),
                .chien_load_i   (chien_load),
                .chien_en_i     (chien_en),
                .chien_out_i    (chien_out),
                .chien_first_i  (chien_first),
                .over_cnt_i     (over_cnt),
                .bma_ex0_i      (bma_ex0),
                .bma_ex1_i      (bma_ex1),
                .bma_ex2_i      (bma_ex2),
                .bma_ex3_i      (bma_ex3),
                .bma_ex4_i      (bma_ex4),
                .bma_ex5_i      (bma_ex5),
                .bma_ex6_i      (bma_ex6),
                .bma_ex7_i      (bma_ex7),
                .bma_ex8_i      (bma_ex8),
                .bma_ex9_i      (bma_ex9),
                .bma_ex10_i     (bma_ex10),
                .bma_ex11_i     (bma_ex11),
                .bma_ex12_i     (bma_ex12),
                .bma_ex13_i     (bma_ex13),
                .bma_ex14_i     (bma_ex14),
                .bma_ex15_i     (bma_ex15),
                .detect_error_o (detect_error),
                .error_data_o   (error_data)
                );

endmodule