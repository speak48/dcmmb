//+File Header//////////////////////////////////////////////////////////////////
//Copyright 2009, shhic. All rights reserved
//Filename    : bchecc_bma.v
//Module name : bchecc_bma
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
module  bchecc_bma(
                rst_n,
                clk,
                bma_opt_i,
                bma_load_i,
                syndm_en_i,
                delta_en_i,
                bma_en_i,
                bma_end_i,
                bma_cnt_i,
                delta_cnt_i,
                bma_sel_cnt_i,
                syndm1_i, 
                syndm3_i, 
                syndm5_i, 
                syndm7_i, 
                syndm9_i, 
                syndm11_i,
                syndm13_i,
                syndm15_i,
                syndm17_i,
                syndm19_i,
                syndm21_i,
                syndm23_i,
                syndm25_i,
                syndm27_i,
                syndm29_i,
                bma_expt_o,
                bma_error_o,
                bma_ex0_o,
                bma_ex1_o,
                bma_ex2_o,
                bma_ex3_o,
                bma_ex4_o,
                bma_ex5_o,
                bma_ex6_o,
                bma_ex7_o,
                bma_ex8_o,
                bma_ex9_o,
                bma_ex10_o,
                bma_ex11_o,
                bma_ex12_o,
                bma_ex13_o,
                bma_ex14_o,
                bma_ex15_o
                );
////////////////input
input           rst_n;
input           clk;
input           bma_opt_i;

input           bma_load_i;
input           syndm_en_i;
input           delta_en_i;
input           bma_en_i;
input           bma_end_i;
input   [4:0]   bma_cnt_i;
input   [3:0]   delta_cnt_i;
input   [3:0]   bma_sel_cnt_i;

input   [12:0]  syndm1_i; 
input   [12:0]  syndm3_i; 
input   [12:0]  syndm5_i; 
input   [12:0]  syndm7_i; 
input   [12:0]  syndm9_i; 
input   [12:0]  syndm11_i;
input   [12:0]  syndm13_i;
input   [12:0]  syndm15_i;
input   [12:0]  syndm17_i;
input   [12:0]  syndm19_i;
input   [12:0]  syndm21_i;
input   [12:0]  syndm23_i;
input   [12:0]  syndm25_i;
input   [12:0]  syndm27_i;
input   [12:0]  syndm29_i;

////////////////output
output  [4:0]   bma_expt_o;
output          bma_error_o;
output  [12:0]  bma_ex0_o;
output  [12:0]  bma_ex1_o;
output  [12:0]  bma_ex2_o;
output  [12:0]  bma_ex3_o;
output  [12:0]  bma_ex4_o;
output  [12:0]  bma_ex5_o;
output  [12:0]  bma_ex6_o;
output  [12:0]  bma_ex7_o;
output  [12:0]  bma_ex8_o;
output  [12:0]  bma_ex9_o;
output  [12:0]  bma_ex10_o;
output  [12:0]  bma_ex11_o;
output  [12:0]  bma_ex12_o;
output  [12:0]  bma_ex13_o;
output  [12:0]  bma_ex14_o;
output  [12:0]  bma_ex15_o;

////////////////syndm
reg     [12:0]  syndm1; 
reg     [12:0]  syndm3; 
reg     [12:0]  syndm5; 
reg     [12:0]  syndm7; 
reg     [12:0]  syndm9; 
reg     [12:0]  syndm11;
reg     [12:0]  syndm13;
reg     [12:0]  syndm15;
reg     [12:0]  syndm17;
reg     [12:0]  syndm19;
reg     [12:0]  syndm21;
reg     [12:0]  syndm23;
reg     [12:0]  syndm25;
reg     [12:0]  syndm27;
reg     [12:0]  syndm29;

reg             bma_error;

reg     [12:0]  syndm2; 
reg     [12:0]  syndm4; 
reg     [12:0]  syndm6; 
reg     [12:0]  syndm8; 
reg     [12:0]  syndm10; 
reg     [12:0]  syndm12;
reg     [12:0]  syndm14;
reg     [12:0]  syndm16;
reg     [12:0]  syndm18;
reg     [12:0]  syndm20;
reg     [12:0]  syndm22;
reg     [12:0]  syndm24;
reg     [12:0]  syndm26;
reg     [12:0]  syndm28;

////////////////BMA
reg     [12:0]  delta;
reg     [12:0]  theta;
reg     [4:0]   bma_expt;
wire            delta_notzero;

reg     [12:0]  bma_ex0;
reg     [12:0]  bma_ex1;
reg     [12:0]  bma_ex2;
reg     [12:0]  bma_ex3;
reg     [12:0]  bma_ex4;
reg     [12:0]  bma_ex5;
reg     [12:0]  bma_ex6;
reg     [12:0]  bma_ex7;
reg     [12:0]  bma_ex8;
reg     [12:0]  bma_ex9;
reg     [12:0]  bma_ex10;
reg     [12:0]  bma_ex11;
reg     [12:0]  bma_ex12;
reg     [12:0]  bma_ex13;
reg     [12:0]  bma_ex14;
reg     [12:0]  bma_ex15;

reg     [12:0]  bma_dx0;
reg     [12:0]  bma_dx1;
reg     [12:0]  bma_dx2;
reg     [12:0]  bma_dx3;
reg     [12:0]  bma_dx4;
reg     [12:0]  bma_dx5;
reg     [12:0]  bma_dx6;
reg     [12:0]  bma_dx7;
reg     [12:0]  bma_dx8;
reg     [12:0]  bma_dx9;
reg     [12:0]  bma_dx10;
reg     [12:0]  bma_dx11;
reg     [12:0]  bma_dx12;
reg     [12:0]  bma_dx13;
reg     [12:0]  bma_dx14;

reg     [12:0]  bma_r1;
reg     [12:0]  bma_r2;
reg     [12:0]  bma_r3;
reg     [12:0]  bma_r4;
reg     [12:0]  bma_r5;
reg     [12:0]  bma_r6;
reg     [12:0]  bma_r7;
reg     [12:0]  bma_r8;
reg     [12:0]  bma_r9;
reg     [12:0]  bma_r10;
reg     [12:0]  bma_r11;
reg     [12:0]  bma_r12;
reg     [12:0]  bma_r13;
reg     [12:0]  bma_r14;

reg     [12:0]  mult1_a;
reg     [12:0]  mult1_b;
wire    [12:0]  mult1_s;

reg     [12:0]  mult2_a;
reg     [12:0]  mult2_b;
wire    [12:0]  mult2_s;

////////////////load and calculate syndm
always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            syndm1  <= 13'h0000;
            syndm3  <= 13'h0000;
            syndm5  <= 13'h0000;
            syndm7  <= 13'h0000;
            syndm9  <= 13'h0000;
            syndm11 <= 13'h0000;
            syndm13 <= 13'h0000;
            syndm15 <= 13'h0000;
            syndm17 <= 13'h0000;
            syndm19 <= 13'h0000;
            syndm21 <= 13'h0000;
            syndm23 <= 13'h0000;
            syndm25 <= 13'h0000;
            syndm27 <= 13'h0000;
            syndm29 <= 13'h0000;
        end
    else if(bma_load_i)
        begin
            syndm1  <= syndm1_i;
            syndm3  <= syndm3_i;
            syndm5  <= syndm5_i;
            syndm7  <= syndm7_i;
            syndm9  <= syndm9_i;
            syndm11 <= syndm11_i;
            syndm13 <= syndm13_i;
            syndm15 <= syndm15_i;
            syndm17 <= syndm17_i;
            syndm19 <= syndm19_i;
            syndm21 <= syndm21_i;
            syndm23 <= syndm23_i;
            syndm25 <= syndm25_i;
            syndm27 <= syndm27_i;
            syndm29 <= syndm29_i;
        end
end

always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            bma_error <= 1'b0;
        end
    else if(bma_load_i)
        begin
            bma_error <= |{syndm1_i,syndm3_i,syndm5_i,syndm7_i,syndm9_i,
                           syndm11_i,syndm13_i,syndm15_i,syndm17_i,syndm19_i,
                           syndm21_i,syndm23_i,syndm25_i,syndm27_i,syndm29_i};
        end
end

always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            syndm2  <= 13'h0000;
            syndm4  <= 13'h0000;
            syndm6  <= 13'h0000;
            syndm8  <= 13'h0000;
            syndm10 <= 13'h0000;
            syndm12 <= 13'h0000;
            syndm14 <= 13'h0000;
            syndm16 <= 13'h0000;
            syndm18 <= 13'h0000;
            syndm20 <= 13'h0000;
            syndm22 <= 13'h0000;
            syndm24 <= 13'h0000;
            syndm26 <= 13'h0000;
            syndm28 <= 13'h0000;
        end
    else if(bma_load_i)
        begin
            syndm2  <= 13'h0000;
            syndm4  <= 13'h0000;
            syndm6  <= 13'h0000;
            syndm8  <= 13'h0000;
            syndm10 <= 13'h0000;
            syndm12 <= 13'h0000;
            syndm14 <= 13'h0000;
            syndm16 <= 13'h0000;
            syndm18 <= 13'h0000;
            syndm20 <= 13'h0000;
            syndm22 <= 13'h0000;
            syndm24 <= 13'h0000;
            syndm26 <= 13'h0000;
            syndm28 <= 13'h0000;
        end
    else if(syndm_en_i)
        case(bma_cnt_i[3:0])
            4'h0:
                begin
                    syndm2  <= mult1_s;
                    syndm6  <= mult2_s;
                end
            4'h1:
                begin
                    syndm4  <= mult1_s;
                    syndm10 <= mult2_s;
                end
            4'h2:
                begin
                    syndm8  <= mult1_s;
                    syndm12 <= mult2_s;
                end
            4'h3:
                begin
                    syndm14 <= mult1_s;
                    syndm16 <= mult2_s;
                end
            4'h4:
                begin
                    syndm18 <= mult1_s;
                    syndm20 <= mult2_s;
                end
            4'h5:
                begin
                    syndm22 <= mult1_s;
                    syndm24 <= mult2_s;
                end
            4'h6:
                begin
                    syndm26 <= mult1_s;
                    syndm28 <= mult2_s;
                end
            default:
                begin
                    syndm2  <= 13'h0000;
                    syndm4  <= 13'h0000;
                    syndm6  <= 13'h0000;
                    syndm8  <= 13'h0000;
                    syndm10 <= 13'h0000;
                    syndm12 <= 13'h0000;
                    syndm14 <= 13'h0000;
                    syndm16 <= 13'h0000;
                    syndm18 <= 13'h0000;
                    syndm20 <= 13'h0000;
                    syndm22 <= 13'h0000;
                    syndm24 <= 13'h0000;
                    syndm26 <= 13'h0000;
                    syndm28 <= 13'h0000;
                end
        endcase
end

////////////////BMA
always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            delta <= 13'h0000;
        end
    else if(bma_load_i || bma_end_i)
        begin
            delta <= 13'h0000;
        end
    else if(delta_en_i)
        begin
            delta <= delta ^ mult1_s ^ mult2_s;
        end
end

assign  delta_notzero = (|delta) && ({bma_expt[3:0],1'b0} <= bma_cnt_i);

always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            theta <= 13'h0001;
        end
    else if(bma_load_i)
        begin
            theta <= 13'h0001;
        end
    else if(bma_en_i && bma_end_i && delta_notzero)
        begin
            theta <= delta;
        end
end

always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            bma_expt <= 5'h00;
        end
    else if(bma_load_i)
        begin
            bma_expt <= 5'h00;
        end
    else if(bma_en_i && bma_end_i && delta_notzero)
        begin
            bma_expt <= bma_cnt_i + 5'h01 - bma_expt;
        end
end

always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            bma_ex0  <= 13'h0000;
            bma_ex1  <= 13'h0000;
            bma_ex2  <= 13'h0000;
            bma_ex3  <= 13'h0000;
            bma_ex4  <= 13'h0000;
            bma_ex5  <= 13'h0000;
            bma_ex6  <= 13'h0000;
            bma_ex7  <= 13'h0000;
            bma_ex8  <= 13'h0000;
            bma_ex9  <= 13'h0000;
            bma_ex10 <= 13'h0000;
            bma_ex11 <= 13'h0000;
            bma_ex12 <= 13'h0000;
            bma_ex13 <= 13'h0000;
            bma_ex14 <= 13'h0000;
            bma_ex15 <= 13'h0000;
        end
    else if(bma_load_i)
        begin
            bma_ex0  <= 13'h0001;
            bma_ex1  <= 13'h0000;
            bma_ex2  <= 13'h0000;
            bma_ex3  <= 13'h0000;
            bma_ex4  <= 13'h0000;
            bma_ex5  <= 13'h0000;
            bma_ex6  <= 13'h0000;
            bma_ex7  <= 13'h0000;
            bma_ex8  <= 13'h0000;
            bma_ex9  <= 13'h0000;
            bma_ex10 <= 13'h0000;
            bma_ex11 <= 13'h0000;
            bma_ex12 <= 13'h0000;
            bma_ex13 <= 13'h0000;
            bma_ex14 <= 13'h0000;
            bma_ex15 <= 13'h0000;
        end
    else if(bma_en_i)
        begin
            case(delta_cnt_i[3:0])
                4'h0: bma_ex0  <= mult1_s ^ mult2_s;
                4'h1: bma_ex1  <= mult1_s ^ mult2_s;
                4'h2: bma_ex2  <= mult1_s ^ mult2_s;
                4'h3: bma_ex3  <= mult1_s ^ mult2_s;
                4'h4: bma_ex4  <= mult1_s ^ mult2_s;
                4'h5: bma_ex5  <= mult1_s ^ mult2_s;
                4'h6: bma_ex6  <= mult1_s ^ mult2_s;
                4'h7: bma_ex7  <= mult1_s ^ mult2_s;
                4'h8: bma_ex8  <= mult1_s ^ mult2_s;
                4'h9: bma_ex9  <= mult1_s ^ mult2_s;
                4'ha: bma_ex10 <= mult1_s ^ mult2_s;
                4'hb: bma_ex11 <= mult1_s ^ mult2_s;
                4'hc: bma_ex12 <= mult1_s ^ mult2_s;
                4'hd: bma_ex13 <= mult1_s ^ mult2_s;
                4'he: bma_ex14 <= mult1_s ^ mult2_s;
                4'hf: bma_ex15 <= mult1_s ^ mult2_s;
                default: 
                    begin
                        bma_ex0  <= 13'h0000;
                        bma_ex1  <= 13'h0000;
                        bma_ex2  <= 13'h0000;
                        bma_ex3  <= 13'h0000;
                        bma_ex4  <= 13'h0000;
                        bma_ex5  <= 13'h0000;
                        bma_ex6  <= 13'h0000;
                        bma_ex7  <= 13'h0000;
                        bma_ex8  <= 13'h0000;
                        bma_ex9  <= 13'h0000;
                        bma_ex10 <= 13'h0000;
                        bma_ex11 <= 13'h0000;
                        bma_ex12 <= 13'h0000;
                        bma_ex13 <= 13'h0000;
                        bma_ex14 <= 13'h0000;
                        bma_ex15 <= 13'h0000;
                    end
            endcase
        end
end


always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            bma_dx0  <= 13'h0000;
            bma_dx1  <= 13'h0000;
            bma_dx2  <= 13'h0000;
            bma_dx3  <= 13'h0000;
            bma_dx4  <= 13'h0000;
            bma_dx5  <= 13'h0000;
            bma_dx6  <= 13'h0000;
            bma_dx7  <= 13'h0000;
            bma_dx8  <= 13'h0000;
            bma_dx9  <= 13'h0000;
            bma_dx10 <= 13'h0000;
            bma_dx11 <= 13'h0000;
            bma_dx12 <= 13'h0000;
            bma_dx13 <= 13'h0000;
            bma_dx14 <= 13'h0000;
        end
    else if(bma_load_i)
        begin
            bma_dx0  <= 13'h0001;
            bma_dx1  <= 13'h0000;
            bma_dx2  <= 13'h0000;
            bma_dx3  <= 13'h0000;
            bma_dx4  <= 13'h0000;
            bma_dx5  <= 13'h0000;
            bma_dx6  <= 13'h0000;
            bma_dx7  <= 13'h0000;
            bma_dx8  <= 13'h0000;
            bma_dx9  <= 13'h0000;
            bma_dx10 <= 13'h0000;
            bma_dx11 <= 13'h0000;
            bma_dx12 <= 13'h0000;
            bma_dx13 <= 13'h0000;
            bma_dx14 <= 13'h0000;
        end
    else if(bma_en_i & bma_end_i)
        begin
            if(delta_notzero)
                begin
                    bma_dx0  <= 13'h0000;
                    bma_dx1  <= bma_r1;
                    bma_dx2  <= bma_r2;
                    bma_dx3  <= bma_r3;
                    bma_dx4  <= bma_r4;
                    bma_dx5  <= bma_r5;
                    bma_dx6  <= bma_r6;
                    bma_dx7  <= bma_r7;
                    bma_dx8  <= bma_r8;
                    bma_dx9  <= bma_r9;
                    bma_dx10 <= bma_r10;
                    bma_dx11 <= bma_r11;
                    bma_dx12 <= bma_r12;
                    bma_dx13 <= bma_r13;
                    bma_dx14 <= bma_r14;
                end
            else
                begin
                    bma_dx0  <= 13'h0000;
                    bma_dx1  <= 13'h0000;
                    bma_dx2  <= bma_dx0;
                    bma_dx3  <= bma_dx1;
                    bma_dx4  <= bma_dx2;
                    bma_dx5  <= bma_dx3;
                    bma_dx6  <= bma_dx4;
                    bma_dx7  <= bma_dx5;
                    bma_dx8  <= bma_dx6;
                    bma_dx9  <= bma_dx7;
                    bma_dx10 <= bma_dx8;
                    bma_dx11 <= bma_dx9;
                    bma_dx12 <= bma_dx10;
                    bma_dx13 <= bma_dx11;
                    bma_dx14 <= bma_dx12;
                end
        end
end

always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            bma_r1  <= 13'h0000;
            bma_r2  <= 13'h0000;
            bma_r3  <= 13'h0000;
            bma_r4  <= 13'h0000;
            bma_r5  <= 13'h0000;
            bma_r6  <= 13'h0000;
            bma_r7  <= 13'h0000;
            bma_r8  <= 13'h0000;
            bma_r9  <= 13'h0000;
            bma_r10 <= 13'h0000;
            bma_r11 <= 13'h0000;
            bma_r12 <= 13'h0000;
            bma_r13 <= 13'h0000;
            bma_r14 <= 13'h0000;
        end
    else if(bma_load_i)
        begin
            bma_r1  <= 13'h0000;
            bma_r2  <= 13'h0000;
            bma_r3  <= 13'h0000;
            bma_r4  <= 13'h0000;
            bma_r5  <= 13'h0000;
            bma_r6  <= 13'h0000;
            bma_r7  <= 13'h0000;
            bma_r8  <= 13'h0000;
            bma_r9  <= 13'h0000;
            bma_r10 <= 13'h0000;
            bma_r11 <= 13'h0000;
            bma_r12 <= 13'h0000;
            bma_r13 <= 13'h0000;
            bma_r14 <= 13'h0000;
        end
    else if(delta_en_i)
        begin
            bma_r1  <= bma_ex0;
            bma_r2  <= bma_ex1;
            bma_r3  <= bma_ex2;
            bma_r4  <= bma_ex3;
            bma_r5  <= bma_ex4;
            bma_r6  <= bma_ex5;
            bma_r7  <= bma_ex6;
            bma_r8  <= bma_ex7;
            bma_r9  <= bma_ex8;
            bma_r10 <= bma_ex9;
            bma_r11 <= bma_ex10;
            bma_r12 <= bma_ex11;
            bma_r13 <= bma_ex12;
            bma_r14 <= bma_ex13;
        end
end

always  @(*)
begin
    if(syndm_en_i)
        case(bma_cnt_i[3:0])
            4'h0: mult1_a = syndm1;
            4'h1: mult1_a = syndm2;
            4'h2: mult1_a = syndm4;
            4'h3: mult1_a = syndm7;
            4'h4: mult1_a = syndm9;
            4'h5: mult1_a = syndm11;
            4'h6: mult1_a = syndm13;
            default: mult1_a = 13'h0000;
        endcase
    else if(delta_en_i)
        case(delta_cnt_i)
            4'h0: mult1_a = bma_ex0;
            4'h1: mult1_a = bma_ex2;
            4'h2: mult1_a = bma_ex4;
            4'h3: mult1_a = bma_ex6;
            4'h4: mult1_a = bma_ex8;
            4'h5: mult1_a = bma_ex10;
            4'h6: mult1_a = bma_ex12;
            4'h7: mult1_a = bma_ex14;
            default: mult1_a = 13'h0000;
        endcase
    else
        case(delta_cnt_i)
            4'h0: mult1_a = bma_ex0;
            4'h1: mult1_a = bma_ex1;
            4'h2: mult1_a = bma_ex2;
            4'h3: mult1_a = bma_ex3;
            4'h4: mult1_a = bma_ex4;
            4'h5: mult1_a = bma_ex5;
            4'h6: mult1_a = bma_ex6;
            4'h7: mult1_a = bma_ex7;
            4'h8: mult1_a = bma_ex8;
            4'h9: mult1_a = bma_ex9;
            4'hA: mult1_a = bma_ex10;
            4'hB: mult1_a = bma_ex11;
            4'hC: mult1_a = bma_ex12;
            4'hD: mult1_a = bma_ex13;
            4'hE: mult1_a = bma_ex14;
            4'hF: mult1_a = bma_ex15;
            default:  mult1_a = 13'h0000;
        endcase
end

always  @(*)
begin
    if(syndm_en_i)
        case(bma_cnt_i[3:0])
            4'h0: mult2_a = syndm3;
            4'h1: mult2_a = syndm5;
            4'h2: mult2_a = syndm6;
            4'h3: mult2_a = syndm8;
            4'h4: mult2_a = syndm10;
            4'h5: mult2_a = syndm12;
            4'h6: mult2_a = syndm14;
            default: mult2_a = 13'h0000;
        endcase
    else if(delta_en_i)
        case(delta_cnt_i)
            4'h0: mult2_a = bma_ex1;
            4'h1: mult2_a = bma_ex3;
            4'h2: mult2_a = bma_ex5;
            4'h3: mult2_a = bma_ex7;
            4'h4: mult2_a = bma_ex9;
            4'h5: mult2_a = bma_ex11;
            4'h6: mult2_a = bma_ex13;
            4'h7: mult2_a = bma_ex15;
            default: mult2_a = 13'h0000;
        endcase
    else
        case(delta_cnt_i)
            4'h0: mult2_a = 13'h0000;
            4'h1: mult2_a = bma_dx0;
            4'h2: mult2_a = bma_dx1;
            4'h3: mult2_a = bma_dx2;
            4'h4: mult2_a = bma_dx3;
            4'h5: mult2_a = bma_dx4;
            4'h6: mult2_a = bma_dx5;
            4'h7: mult2_a = bma_dx6;
            4'h8: mult2_a = bma_dx7;
            4'h9: mult2_a = bma_dx8;
            4'hA: mult2_a = bma_dx9;
            4'hB: mult2_a = bma_dx10;
            4'hC: mult2_a = bma_dx11;
            4'hD: mult2_a = bma_dx12;
            4'hE: mult2_a = bma_dx13;
            4'hF: mult2_a = bma_dx14;
            default:  mult2_a = 13'h0000;
        endcase
end

always  @(*)
begin
    if(syndm_en_i)
        case(bma_cnt_i[3:0])
            4'h0: mult1_b = syndm1;
            4'h1: mult1_b = syndm2;
            4'h2: mult1_b = syndm4;
            4'h3: mult1_b = syndm7;
            4'h4: mult1_b = syndm9;
            4'h5: mult1_b = syndm11;
            4'h6: mult1_b = syndm13;
            default: mult1_b = 13'h0000;
        endcase
    else if(delta_en_i)
        case(bma_sel_cnt_i)
            4'h0: mult1_b = syndm1;
            4'h1: mult1_b = syndm3;
            4'h2: mult1_b = syndm5;
            4'h3: mult1_b = syndm7;
            4'h4: mult1_b = syndm9;
            4'h5: mult1_b = syndm11;
            4'h6: mult1_b = syndm13;
            4'h7: mult1_b = syndm15;
            4'h8: mult1_b = syndm17;
            4'h9: mult1_b = syndm19;
            4'hA: mult1_b = syndm21;
            4'hB: mult1_b = syndm23;
            4'hC: mult1_b = syndm25;
            4'hD: mult1_b = syndm27;
            4'hE: mult1_b = syndm29;
            default:  mult1_b = 13'h0000;
        endcase
    else
        begin
            mult1_b = theta;
        end
end

always  @(*)
begin
    if(syndm_en_i)
        case(bma_cnt_i[3:0])
            4'h0: mult2_b = syndm3;
            4'h1: mult2_b = syndm5;
            4'h2: mult2_b = syndm6;
            4'h3: mult2_b = syndm8;
            4'h4: mult2_b = syndm10;
            4'h5: mult2_b = syndm12;
            4'h6: mult2_b = syndm14;
            default: mult2_b = 13'h0000;
        endcase
    else if(delta_en_i)
        case(bma_sel_cnt_i)
            4'h0: mult2_b = 13'h0000;
            4'h1: mult2_b = syndm2;
            4'h2: mult2_b = syndm4;
            4'h3: mult2_b = syndm6;
            4'h4: mult2_b = syndm8;
            4'h5: mult2_b = syndm10;
            4'h6: mult2_b = syndm12;
            4'h7: mult2_b = syndm14;
            4'h8: mult2_b = syndm16;
            4'h9: mult2_b = syndm18;
            4'hA: mult2_b = syndm20;
            4'hB: mult2_b = syndm22;
            4'hC: mult2_b = syndm24;
            4'hD: mult2_b = syndm26;
            4'hE: mult2_b = syndm28;
            default:  mult2_b = 13'h0000;
        endcase
    else
        begin
            mult2_b = delta;
        end
end

bchecc_gfmult u1_gfmult(
                .a_i    (mult1_a),
                .b_i    (mult1_b),
                .s_o    (mult1_s)
                );
              
bchecc_gfmult u2_gfmult(
                .a_i    (mult2_a),
                .b_i    (mult2_b),
                .s_o    (mult2_s)
                );
                
////////////////output
assign  bma_error_o = bma_error;
assign  bma_expt_o  = bma_expt;
assign  bma_ex0_o   = bma_ex0;
assign  bma_ex1_o   = bma_ex1;
assign  bma_ex2_o   = bma_ex2;
assign  bma_ex3_o   = bma_ex3;
assign  bma_ex4_o   = bma_ex4;
assign  bma_ex5_o   = bma_ex5;
assign  bma_ex6_o   = bma_ex6;
assign  bma_ex7_o   = bma_ex7;
assign  bma_ex8_o   = bma_ex8;
assign  bma_ex9_o   = bma_ex9;
assign  bma_ex10_o  = bma_ex10;
assign  bma_ex11_o  = bma_ex11;
assign  bma_ex12_o  = bma_ex12;
assign  bma_ex13_o  = bma_ex13;
assign  bma_ex14_o  = bma_ex14;
assign  bma_ex15_o  = bma_ex15;

endmodule