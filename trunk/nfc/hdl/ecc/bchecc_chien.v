`timescale 1ns/100ps
module  bchecc_chien(
                rst_n,
                clk,
                chien_load_i,
                chien_en_i,
                chien_out_i,
                chien_first_i,
                over_cnt_i,
                bma_ex0_i,
                bma_ex1_i,
                bma_ex2_i,
                bma_ex3_i,
                bma_ex4_i,
                bma_ex5_i,
                bma_ex6_i,
                bma_ex7_i,
                bma_ex8_i,
                bma_ex9_i,
                bma_ex10_i,
                bma_ex11_i,
                bma_ex12_i,
                bma_ex13_i,
                bma_ex14_i,
                bma_ex15_i,
                detect_error_o,
                error_data_o
                );
////////////////input
input           rst_n;
input           clk;
input           chien_load_i;
input           chien_en_i;
input           chien_out_i;
input           chien_first_i;
input   [1:0]   over_cnt_i;
input   [12:0]  bma_ex0_i;
input   [12:0]  bma_ex1_i;
input   [12:0]  bma_ex2_i;
input   [12:0]  bma_ex3_i;
input   [12:0]  bma_ex4_i;
input   [12:0]  bma_ex5_i;
input   [12:0]  bma_ex6_i;
input   [12:0]  bma_ex7_i;
input   [12:0]  bma_ex8_i;
input   [12:0]  bma_ex9_i;
input   [12:0]  bma_ex10_i;
input   [12:0]  bma_ex11_i;
input   [12:0]  bma_ex12_i;
input   [12:0]  bma_ex13_i;
input   [12:0]  bma_ex14_i;
input   [12:0]  bma_ex15_i;

////////////////output
output          detect_error_o;
output  [5:0]   error_data_o;

parameter       ALPHA8101 = 13'h13aa;
parameter       ALPHA8107 = 13'h09a1;
parameter       ALPHA8113 = 13'h09dd;
parameter       ALPHA8116 = 13'h0ede;
parameter       ALPHA8119 = 13'h16dd;
parameter       ALPHA8121 = 13'h1b42;
parameter       ALPHA8125 = 13'h148f;
parameter       ALPHA8126 = 13'h0905;
parameter       ALPHA8131 = 13'h0063;
parameter       ALPHA8135 = 13'h0630;
parameter       ALPHA8136 = 13'h0c60;
parameter       ALPHA8137 = 13'h18c0;
parameter       ALPHA8139 = 13'h032d;
parameter       ALPHA8141 = 13'h0cb4;
parameter       ALPHA8143 = 13'h12cb;
parameter       ALPHA8146 = 13'h1634;
parameter       ALPHA8147 = 13'h0c73;
parameter       ALPHA8149 = 13'h11d7;
parameter       ALPHA8151 = 13'h076a;
parameter       ALPHA8152 = 13'h0ed4;
parameter       ALPHA8155 = 13'h168d;
parameter       ALPHA8156 = 13'h0d01;
parameter       ALPHA8158 = 13'h141f;
parameter       ALPHA8159 = 13'h0825;
parameter       ALPHA8161 = 13'h008f;
parameter       ALPHA8163 = 13'h023c;
parameter       ALPHA8164 = 13'h0478;
parameter       ALPHA8165 = 13'h08f0;
parameter       ALPHA8166 = 13'h11e0;
parameter       ALPHA8167 = 13'h03db;
parameter       ALPHA8169 = 13'h0f6c;
parameter       ALPHA8170 = 13'h1ed8;
parameter       ALPHA8171 = 13'h1dab;
parameter       ALPHA8173 = 13'h1681;
parameter       ALPHA8175 = 13'h1a32;
parameter       ALPHA8176 = 13'h147f;
parameter       ALPHA8177 = 13'h08e5;
parameter       ALPHA8178 = 13'h11ca;
parameter       ALPHA8179 = 13'h038f;
parameter       ALPHA8180 = 13'h071e;
parameter       ALPHA8181 = 13'h0e3c;
parameter       ALPHA8182 = 13'h1c78;
parameter       ALPHA8183 = 13'h18eb;
parameter       ALPHA8184 = 13'h11cd;
parameter       ALPHA8185 = 13'h0381;
parameter       ALPHA8186 = 13'h0702;
parameter       ALPHA8187 = 13'h0e04;
parameter       ALPHA8188 = 13'h1c08;
parameter       ALPHA8189 = 13'h180b;
parameter       ALPHA8190 = 13'h100d;

////////////////register
reg     [12:0]  chien_ex0;
reg     [12:0]  chien_ex1;
reg     [12:0]  chien_ex2;
reg     [12:0]  chien_ex3;
reg     [12:0]  chien_ex4;
reg     [12:0]  chien_ex5;
reg     [12:0]  chien_ex6;
reg     [12:0]  chien_ex7;
reg     [12:0]  chien_ex8;
reg     [12:0]  chien_ex9;
reg     [12:0]  chien_ex10;
reg     [12:0]  chien_ex11;
reg     [12:0]  chien_ex12;
reg     [12:0]  chien_ex13;
reg     [12:0]  chien_ex14;
reg     [12:0]  chien_ex15;

wire            detect_error;
reg     [2:0]   current_err_cnt;
reg     [5:0]   error_data;

////////////////logic signals
wire    [5:0]   errdata;
reg     [5:0]   error_data_tmp;

wire    [12:0]  mult1_s;
wire    [12:0]  mult2_s;
wire    [12:0]  mult3_s;
wire    [12:0]  mult4_s;
wire    [12:0]  mult5_s;
wire    [12:0]  mult6_s;
wire    [12:0]  mult7_s;
wire    [12:0]  mult8_s;
wire    [12:0]  mult9_s;
wire    [12:0]  mult10_s;
wire    [12:0]  mult11_s;
wire    [12:0]  mult12_s;
wire    [12:0]  mult13_s;
wire    [12:0]  mult14_s;
wire    [12:0]  mult15_s;
wire    [12:0]  mult16_s;
wire    [12:0]  mult17_s;
wire    [12:0]  mult18_s;
wire    [12:0]  mult19_s;
wire    [12:0]  mult20_s;
wire    [12:0]  mult21_s;
wire    [12:0]  mult22_s;
wire    [12:0]  mult23_s;
wire    [12:0]  mult24_s;
wire    [12:0]  mult25_s;
wire    [12:0]  mult26_s;
wire    [12:0]  mult27_s;
wire    [12:0]  mult28_s;
wire    [12:0]  mult29_s;
wire    [12:0]  mult30_s;

wire    [12:0]  mult31_s;
wire    [12:0]  mult32_s;
wire    [12:0]  mult33_s;
wire    [12:0]  mult34_s;
wire    [12:0]  mult35_s;
wire    [12:0]  mult36_s;
wire    [12:0]  mult37_s;
wire    [12:0]  mult38_s;
wire    [12:0]  mult39_s;
wire    [12:0]  mult40_s;
wire    [12:0]  mult41_s;
wire    [12:0]  mult42_s;
wire    [12:0]  mult43_s;
wire    [12:0]  mult44_s;
wire    [12:0]  mult45_s;
wire    [12:0]  mult46_s;
wire    [12:0]  mult47_s;
wire    [12:0]  mult48_s;
wire    [12:0]  mult49_s;
wire    [12:0]  mult50_s;
wire    [12:0]  mult51_s;
wire    [12:0]  mult52_s;
wire    [12:0]  mult53_s;
wire    [12:0]  mult54_s;
wire    [12:0]  mult55_s;
wire    [12:0]  mult56_s;
wire    [12:0]  mult57_s;
wire    [12:0]  mult58_s;
wire    [12:0]  mult59_s;
wire    [12:0]  mult60_s;

wire    [12:0]  mult61_s;
wire    [12:0]  mult62_s;
wire    [12:0]  mult63_s;
wire    [12:0]  mult64_s;
wire    [12:0]  mult65_s;
wire    [12:0]  mult66_s;
wire    [12:0]  mult67_s;
wire    [12:0]  mult68_s;
wire    [12:0]  mult69_s;
wire    [12:0]  mult70_s;
wire    [12:0]  mult71_s;
wire    [12:0]  mult72_s;
wire    [12:0]  mult73_s;
wire    [12:0]  mult74_s;
wire    [12:0]  mult75_s;
wire    [12:0]  mult76_s;
wire    [12:0]  mult77_s;
wire    [12:0]  mult78_s;
wire    [12:0]  mult79_s;
wire    [12:0]  mult80_s;
wire    [12:0]  mult81_s;
wire    [12:0]  mult82_s;
wire    [12:0]  mult83_s;
wire    [12:0]  mult84_s;
wire    [12:0]  mult85_s;
wire    [12:0]  mult86_s;
wire    [12:0]  mult87_s;
wire    [12:0]  mult88_s;
wire    [12:0]  mult89_s;
wire    [12:0]  mult90_s;

reg     [12:0]  chien_ex1_tmp;
reg     [12:0]  chien_ex2_tmp;
reg     [12:0]  chien_ex3_tmp;
reg     [12:0]  chien_ex4_tmp;
reg     [12:0]  chien_ex5_tmp;
reg     [12:0]  chien_ex6_tmp;
reg     [12:0]  chien_ex7_tmp;
reg     [12:0]  chien_ex8_tmp;
reg     [12:0]  chien_ex9_tmp;
reg     [12:0]  chien_ex10_tmp;
reg     [12:0]  chien_ex11_tmp;
reg     [12:0]  chien_ex12_tmp;
reg     [12:0]  chien_ex13_tmp;
reg     [12:0]  chien_ex14_tmp;
reg     [12:0]  chien_ex15_tmp;

////////////////load and calculate
always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            chien_ex0  <= 13'h0000;
            chien_ex1  <= 13'h0000;
            chien_ex2  <= 13'h0000;
            chien_ex3  <= 13'h0000;
            chien_ex4  <= 13'h0000;
            chien_ex5  <= 13'h0000;
            chien_ex6  <= 13'h0000;
            chien_ex7  <= 13'h0000;
            chien_ex8  <= 13'h0000;
            chien_ex9  <= 13'h0000;
            chien_ex10 <= 13'h0000;
            chien_ex11 <= 13'h0000;
            chien_ex12 <= 13'h0000;
            chien_ex13 <= 13'h0000;
            chien_ex14 <= 13'h0000;
            chien_ex15 <= 13'h0000;
        end
    else if(chien_load_i)
        begin
            chien_ex0  <= bma_ex0_i;
            chien_ex1  <= bma_ex1_i;
            chien_ex2  <= bma_ex2_i;
            chien_ex3  <= bma_ex3_i;
            chien_ex4  <= bma_ex4_i;
            chien_ex5  <= bma_ex5_i;
            chien_ex6  <= bma_ex6_i;
            chien_ex7  <= bma_ex7_i;
            chien_ex8  <= bma_ex8_i;
            chien_ex9  <= bma_ex9_i;
            chien_ex10 <= bma_ex10_i;
            chien_ex11 <= bma_ex11_i;
            chien_ex12 <= bma_ex12_i;
            chien_ex13 <= bma_ex13_i;
            chien_ex14 <= bma_ex14_i;
            chien_ex15 <= bma_ex15_i;
        end
    else if(chien_en_i)
        begin
            chien_ex1  <= chien_ex1_tmp;
            chien_ex2  <= chien_ex2_tmp;
            chien_ex3  <= chien_ex3_tmp;
            chien_ex4  <= chien_ex4_tmp;
            chien_ex5  <= chien_ex5_tmp;
            chien_ex6  <= chien_ex6_tmp;
            chien_ex7  <= chien_ex7_tmp;
            chien_ex8  <= chien_ex8_tmp;
            chien_ex9  <= chien_ex9_tmp;
            chien_ex10 <= chien_ex10_tmp;
            chien_ex11 <= chien_ex11_tmp;
            chien_ex12 <= chien_ex12_tmp;
            chien_ex13 <= chien_ex13_tmp;
            chien_ex14 <= chien_ex14_tmp;
            chien_ex15 <= chien_ex15_tmp;
        end
end

always  @(*)
begin
    if(chien_first_i)
        begin
            if(over_cnt_i==2'b01)
                begin
                    error_data_tmp = {errdata[1:0],4'b0000};
                end
            else if(over_cnt_i==2'b10)
                begin
                    error_data_tmp = {errdata[3:0],2'b00};
                end
            else
                begin
                    error_data_tmp = errdata;
                end
        end
    else
        begin
            error_data_tmp = errdata;
        end
end
    

always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            current_err_cnt <= 3'b000;
        end
    else if(chien_load_i)
        begin
            current_err_cnt <= 3'b000;
        end
    else if(chien_en_i)
        begin
            current_err_cnt <= ({2'b00,error_data_tmp[0]} + {2'b00,error_data_tmp[1]} + {2'b00,error_data_tmp[2]})
                             + ({2'b00,error_data_tmp[3]} + {2'b00,error_data_tmp[4]} + {2'b00,error_data_tmp[5]});
        end
    else if(chien_out_i)
        begin
            current_err_cnt <= current_err_cnt - 3'b001;
        end
end

always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            error_data <= 6'h00;
        end
    else if(chien_load_i)
        begin
            error_data <= 6'h00;
        end
    else if(chien_en_i)
        begin
            error_data <= error_data_tmp;
        end
    else if(chien_out_i)
        begin
            if(error_data[0])
                begin
                    error_data[0] <= 1'b0;
                end
            else if(error_data[1])
                begin
                    error_data[1] <= 1'b0;
                end
            else if(error_data[2])
                begin
                    error_data[2] <= 1'b0;
                end
            else if(error_data[3])
                begin
                    error_data[3] <= 1'b0;
                end
            else if(error_data[4])
                begin
                    error_data[4] <= 1'b0;
                end
            else if(error_data[5])
                begin
                    error_data[5] <= 1'b0;
                end
        end
end

assign  detect_error = chien_en_i ? (|error_data_tmp) : (current_err_cnt > 3'b001);

////////////////logic 
assign  errdata[0] = ~(|((chien_ex0  ^ chien_ex1  ^ chien_ex2  ^ chien_ex3 ) 
                       ^ (chien_ex4  ^ chien_ex5  ^ chien_ex6  ^ chien_ex7 )
                       ^ (chien_ex8  ^ chien_ex9  ^ chien_ex10 ^ chien_ex11) 
                       ^ (chien_ex12 ^ chien_ex13 ^ chien_ex14 ^ chien_ex15)));
                       
assign  errdata[1] = ~(|((chien_ex0 ^ mult1_s  ^ mult2_s  ^ mult3_s ) 
                        ^ (mult4_s  ^ mult5_s  ^ mult6_s  ^ mult7_s )
                        ^ (mult8_s  ^ mult9_s  ^ mult10_s ^ mult11_s) 
                        ^ (mult12_s ^ mult13_s ^ mult14_s ^ mult15_s)));
                       
assign  errdata[2] = ~(|((((chien_ex0 ^ mult16_s) ^ (mult17_s ^ mult18_s)) 
                         ^ ((mult19_s ^ mult20_s) ^ (mult21_s ^ mult22_s)))
                         ^(((mult23_s ^ mult24_s) ^ (mult25_s ^ mult26_s)) 
                         ^ ((mult27_s ^ mult28_s) ^ (mult29_s ^ mult30_s)))));
                       
assign  errdata[3] = ~(|((((chien_ex0 ^ mult31_s) ^ (mult32_s ^ mult33_s)) 
                         ^ ((mult34_s ^ mult35_s) ^ (mult36_s ^ mult37_s)))
                         ^(((mult38_s ^ mult39_s) ^ (mult40_s ^ mult41_s)) 
                         ^ ((mult42_s ^ mult43_s) ^ (mult44_s ^ mult45_s)))));
                       
assign  errdata[4] = ~(|((((chien_ex0 ^ mult46_s) ^ (mult47_s ^ mult48_s)) 
                         ^ ((mult49_s ^ mult50_s) ^ (mult51_s ^ mult52_s)))
                         ^(((mult53_s ^ mult54_s) ^ (mult55_s ^ mult56_s)) 
                         ^ ((mult57_s ^ mult58_s) ^ (mult59_s ^ mult60_s)))));
                       
assign  errdata[5] = ~(|((((chien_ex0 ^ mult61_s) ^ (mult62_s ^ mult63_s)) 
                         ^ ((mult64_s ^ mult65_s) ^ (mult66_s ^ mult67_s)))
                         ^(((mult68_s ^ mult69_s) ^ (mult70_s ^ mult71_s)) 
                         ^ ((mult72_s ^ mult73_s) ^ (mult74_s ^ mult75_s)))));
                         
bchecc_gfmult15 u0_gfmult15(
                .data_a1_i      (chien_ex1),
                .data_a2_i      (chien_ex2),
                .data_a3_i      (chien_ex3),
                .data_a4_i      (chien_ex4),
                .data_a5_i      (chien_ex5),
                .data_a6_i      (chien_ex6),
                .data_a7_i      (chien_ex7),
                .data_a8_i      (chien_ex8),
                .data_a9_i      (chien_ex9),
                .data_a10_i     (chien_ex10),
                .data_a11_i     (chien_ex11),
                .data_a12_i     (chien_ex12),
                .data_a13_i     (chien_ex13),
                .data_a14_i     (chien_ex14),
                .data_a15_i     (chien_ex15),
                .data_b1_i      (ALPHA8190),
                .data_b2_i      (ALPHA8189),
                .data_b3_i      (ALPHA8188),
                .data_b4_i      (ALPHA8187),
                .data_b5_i      (ALPHA8186),
                .data_b6_i      (ALPHA8185),
                .data_b7_i      (ALPHA8184),
                .data_b8_i      (ALPHA8183),
                .data_b9_i      (ALPHA8182),
                .data_b10_i     (ALPHA8181),
                .data_b11_i     (ALPHA8180),
                .data_b12_i     (ALPHA8179),
                .data_b13_i     (ALPHA8178),
                .data_b14_i     (ALPHA8177),
                .data_b15_i     (ALPHA8176),
                .data_s1_o      (mult1_s),
                .data_s2_o      (mult2_s),
                .data_s3_o      (mult3_s),
                .data_s4_o      (mult4_s),
                .data_s5_o      (mult5_s),
                .data_s6_o      (mult6_s),
                .data_s7_o      (mult7_s),
                .data_s8_o      (mult8_s),
                .data_s9_o      (mult9_s),
                .data_s10_o     (mult10_s),
                .data_s11_o     (mult11_s),
                .data_s12_o     (mult12_s),
                .data_s13_o     (mult13_s),
                .data_s14_o     (mult14_s),
                .data_s15_o     (mult15_s)
                );
                
bchecc_gfmult15 u1_gfmult15(
                .data_a1_i      (chien_ex1),
                .data_a2_i      (chien_ex2),
                .data_a3_i      (chien_ex3),
                .data_a4_i      (chien_ex4),
                .data_a5_i      (chien_ex5),
                .data_a6_i      (chien_ex6),
                .data_a7_i      (chien_ex7),
                .data_a8_i      (chien_ex8),
                .data_a9_i      (chien_ex9),
                .data_a10_i     (chien_ex10),
                .data_a11_i     (chien_ex11),
                .data_a12_i     (chien_ex12),
                .data_a13_i     (chien_ex13),
                .data_a14_i     (chien_ex14),
                .data_a15_i     (chien_ex15),
                .data_b1_i      (ALPHA8189),
                .data_b2_i      (ALPHA8187),
                .data_b3_i      (ALPHA8185),
                .data_b4_i      (ALPHA8183),
                .data_b5_i      (ALPHA8181),
                .data_b6_i      (ALPHA8179),
                .data_b7_i      (ALPHA8177),
                .data_b8_i      (ALPHA8175),
                .data_b9_i      (ALPHA8173),
                .data_b10_i     (ALPHA8171),
                .data_b11_i     (ALPHA8169),
                .data_b12_i     (ALPHA8167),
                .data_b13_i     (ALPHA8165),
                .data_b14_i     (ALPHA8163),
                .data_b15_i     (ALPHA8161),
                .data_s1_o      (mult16_s),
                .data_s2_o      (mult17_s),
                .data_s3_o      (mult18_s),
                .data_s4_o      (mult19_s),
                .data_s5_o      (mult20_s),
                .data_s6_o      (mult21_s),
                .data_s7_o      (mult22_s),
                .data_s8_o      (mult23_s),
                .data_s9_o      (mult24_s),
                .data_s10_o     (mult25_s),
                .data_s11_o     (mult26_s),
                .data_s12_o     (mult27_s),
                .data_s13_o     (mult28_s),
                .data_s14_o     (mult29_s),
                .data_s15_o     (mult30_s)
                );

               
bchecc_gfmult15 u2_gfmult15(
                .data_a1_i      (chien_ex1),
                .data_a2_i      (chien_ex2),
                .data_a3_i      (chien_ex3),
                .data_a4_i      (chien_ex4),
                .data_a5_i      (chien_ex5),
                .data_a6_i      (chien_ex6),
                .data_a7_i      (chien_ex7),
                .data_a8_i      (chien_ex8),
                .data_a9_i      (chien_ex9),
                .data_a10_i     (chien_ex10),
                .data_a11_i     (chien_ex11),
                .data_a12_i     (chien_ex12),
                .data_a13_i     (chien_ex13),
                .data_a14_i     (chien_ex14),
                .data_a15_i     (chien_ex15),
                .data_b1_i      (ALPHA8188),
                .data_b2_i      (ALPHA8185),
                .data_b3_i      (ALPHA8182),
                .data_b4_i      (ALPHA8179),
                .data_b5_i      (ALPHA8176),
                .data_b6_i      (ALPHA8173),
                .data_b7_i      (ALPHA8170),
                .data_b8_i      (ALPHA8167),
                .data_b9_i      (ALPHA8164),
                .data_b10_i     (ALPHA8161),
                .data_b11_i     (ALPHA8158),
                .data_b12_i     (ALPHA8155),
                .data_b13_i     (ALPHA8152),
                .data_b14_i     (ALPHA8149),
                .data_b15_i     (ALPHA8146),
                .data_s1_o      (mult31_s),
                .data_s2_o      (mult32_s),
                .data_s3_o      (mult33_s),
                .data_s4_o      (mult34_s),
                .data_s5_o      (mult35_s),
                .data_s6_o      (mult36_s),
                .data_s7_o      (mult37_s),
                .data_s8_o      (mult38_s),
                .data_s9_o      (mult39_s),
                .data_s10_o     (mult40_s),
                .data_s11_o     (mult41_s),
                .data_s12_o     (mult42_s),
                .data_s13_o     (mult43_s),
                .data_s14_o     (mult44_s),
                .data_s15_o     (mult45_s)
                );
                
bchecc_gfmult15 u3_gfmult15(
                .data_a1_i      (chien_ex1),
                .data_a2_i      (chien_ex2),
                .data_a3_i      (chien_ex3),
                .data_a4_i      (chien_ex4),
                .data_a5_i      (chien_ex5),
                .data_a6_i      (chien_ex6),
                .data_a7_i      (chien_ex7),
                .data_a8_i      (chien_ex8),
                .data_a9_i      (chien_ex9),
                .data_a10_i     (chien_ex10),
                .data_a11_i     (chien_ex11),
                .data_a12_i     (chien_ex12),
                .data_a13_i     (chien_ex13),
                .data_a14_i     (chien_ex14),
                .data_a15_i     (chien_ex15),
                .data_b1_i      (ALPHA8187),
                .data_b2_i      (ALPHA8183),
                .data_b3_i      (ALPHA8179),
                .data_b4_i      (ALPHA8175),
                .data_b5_i      (ALPHA8171),
                .data_b6_i      (ALPHA8167),
                .data_b7_i      (ALPHA8163),
                .data_b8_i      (ALPHA8159),
                .data_b9_i      (ALPHA8155),
                .data_b10_i     (ALPHA8151),
                .data_b11_i     (ALPHA8147),
                .data_b12_i     (ALPHA8143),
                .data_b13_i     (ALPHA8139),
                .data_b14_i     (ALPHA8135),
                .data_b15_i     (ALPHA8131),
                .data_s1_o      (mult46_s),
                .data_s2_o      (mult47_s),
                .data_s3_o      (mult48_s),
                .data_s4_o      (mult49_s),
                .data_s5_o      (mult50_s),
                .data_s6_o      (mult51_s),
                .data_s7_o      (mult52_s),
                .data_s8_o      (mult53_s),
                .data_s9_o      (mult54_s),
                .data_s10_o     (mult55_s),
                .data_s11_o     (mult56_s),
                .data_s12_o     (mult57_s),
                .data_s13_o     (mult58_s),
                .data_s14_o     (mult59_s),
                .data_s15_o     (mult60_s)
                );
                
bchecc_gfmult15 u4_gfmult15(
                .data_a1_i      (chien_ex1),
                .data_a2_i      (chien_ex2),
                .data_a3_i      (chien_ex3),
                .data_a4_i      (chien_ex4),
                .data_a5_i      (chien_ex5),
                .data_a6_i      (chien_ex6),
                .data_a7_i      (chien_ex7),
                .data_a8_i      (chien_ex8),
                .data_a9_i      (chien_ex9),
                .data_a10_i     (chien_ex10),
                .data_a11_i     (chien_ex11),
                .data_a12_i     (chien_ex12),
                .data_a13_i     (chien_ex13),
                .data_a14_i     (chien_ex14),
                .data_a15_i     (chien_ex15),
                .data_b1_i      (ALPHA8186),
                .data_b2_i      (ALPHA8181),
                .data_b3_i      (ALPHA8176),
                .data_b4_i      (ALPHA8171),
                .data_b5_i      (ALPHA8166),
                .data_b6_i      (ALPHA8161),
                .data_b7_i      (ALPHA8156),
                .data_b8_i      (ALPHA8151),
                .data_b9_i      (ALPHA8146),
                .data_b10_i     (ALPHA8141),
                .data_b11_i     (ALPHA8136),
                .data_b12_i     (ALPHA8131),
                .data_b13_i     (ALPHA8126),
                .data_b14_i     (ALPHA8121),
                .data_b15_i     (ALPHA8116),
                .data_s1_o      (mult61_s),
                .data_s2_o      (mult62_s),
                .data_s3_o      (mult63_s),
                .data_s4_o      (mult64_s),
                .data_s5_o      (mult65_s),
                .data_s6_o      (mult66_s),
                .data_s7_o      (mult67_s),
                .data_s8_o      (mult68_s),
                .data_s9_o      (mult69_s),
                .data_s10_o     (mult70_s),
                .data_s11_o     (mult71_s),
                .data_s12_o     (mult72_s),
                .data_s13_o     (mult73_s),
                .data_s14_o     (mult74_s),
                .data_s15_o     (mult75_s)
                );
                
bchecc_gfmult15 u5_gfmult15(
                .data_a1_i      (chien_ex1),
                .data_a2_i      (chien_ex2),
                .data_a3_i      (chien_ex3),
                .data_a4_i      (chien_ex4),
                .data_a5_i      (chien_ex5),
                .data_a6_i      (chien_ex6),
                .data_a7_i      (chien_ex7),
                .data_a8_i      (chien_ex8),
                .data_a9_i      (chien_ex9),
                .data_a10_i     (chien_ex10),
                .data_a11_i     (chien_ex11),
                .data_a12_i     (chien_ex12),
                .data_a13_i     (chien_ex13),
                .data_a14_i     (chien_ex14),
                .data_a15_i     (chien_ex15),
                .data_b1_i      (ALPHA8185),
                .data_b2_i      (ALPHA8179),
                .data_b3_i      (ALPHA8173),
                .data_b4_i      (ALPHA8167),
                .data_b5_i      (ALPHA8161),
                .data_b6_i      (ALPHA8155),
                .data_b7_i      (ALPHA8149),
                .data_b8_i      (ALPHA8143),
                .data_b9_i      (ALPHA8137),
                .data_b10_i     (ALPHA8131),
                .data_b11_i     (ALPHA8125),
                .data_b12_i     (ALPHA8119),
                .data_b13_i     (ALPHA8113),
                .data_b14_i     (ALPHA8107),
                .data_b15_i     (ALPHA8101),
                .data_s1_o      (mult76_s),
                .data_s2_o      (mult77_s),
                .data_s3_o      (mult78_s),
                .data_s4_o      (mult79_s),
                .data_s5_o      (mult80_s),
                .data_s6_o      (mult81_s),
                .data_s7_o      (mult82_s),
                .data_s8_o      (mult83_s),
                .data_s9_o      (mult84_s),
                .data_s10_o     (mult85_s),
                .data_s11_o     (mult86_s),
                .data_s12_o     (mult87_s),
                .data_s13_o     (mult88_s),
                .data_s14_o     (mult89_s),
                .data_s15_o     (mult90_s)
                );

always  @(*)
begin
    if(chien_first_i)
        begin
            if(over_cnt_i==2'b01)
                begin
                    chien_ex1_tmp  = mult16_s;
                    chien_ex2_tmp  = mult17_s;
                    chien_ex3_tmp  = mult18_s;
                    chien_ex4_tmp  = mult19_s;
                    chien_ex5_tmp  = mult20_s;
                    chien_ex6_tmp  = mult21_s;
                    chien_ex7_tmp  = mult22_s;
                    chien_ex8_tmp  = mult23_s;
                    chien_ex9_tmp  = mult24_s;
                    chien_ex10_tmp = mult25_s;
                    chien_ex11_tmp = mult26_s;
                    chien_ex12_tmp = mult27_s;
                    chien_ex13_tmp = mult28_s;
                    chien_ex14_tmp = mult29_s;
                    chien_ex15_tmp = mult30_s;
                end
            else if(over_cnt_i==2'b10)
                begin
                    chien_ex1_tmp  = mult46_s;
                    chien_ex2_tmp  = mult47_s;
                    chien_ex3_tmp  = mult48_s;
                    chien_ex4_tmp  = mult49_s;
                    chien_ex5_tmp  = mult50_s;
                    chien_ex6_tmp  = mult51_s;
                    chien_ex7_tmp  = mult52_s;
                    chien_ex8_tmp  = mult53_s;
                    chien_ex9_tmp  = mult54_s;
                    chien_ex10_tmp = mult55_s;
                    chien_ex11_tmp = mult56_s;
                    chien_ex12_tmp = mult57_s;
                    chien_ex13_tmp = mult58_s;
                    chien_ex14_tmp = mult59_s;
                    chien_ex15_tmp = mult60_s;
                end
            else
                begin
                    chien_ex1_tmp  = mult76_s;
                    chien_ex2_tmp  = mult77_s;
                    chien_ex3_tmp  = mult78_s;
                    chien_ex4_tmp  = mult79_s;
                    chien_ex5_tmp  = mult80_s;
                    chien_ex6_tmp  = mult81_s;
                    chien_ex7_tmp  = mult82_s;
                    chien_ex8_tmp  = mult83_s;
                    chien_ex9_tmp  = mult84_s;
                    chien_ex10_tmp = mult85_s;
                    chien_ex11_tmp = mult86_s;
                    chien_ex12_tmp = mult87_s;
                    chien_ex13_tmp = mult88_s;
                    chien_ex14_tmp = mult89_s;
                    chien_ex15_tmp = mult90_s;
                end
        end
    else
        begin
            chien_ex1_tmp  = mult76_s;
            chien_ex2_tmp  = mult77_s;
            chien_ex3_tmp  = mult78_s;
            chien_ex4_tmp  = mult79_s;
            chien_ex5_tmp  = mult80_s;
            chien_ex6_tmp  = mult81_s;
            chien_ex7_tmp  = mult82_s;
            chien_ex8_tmp  = mult83_s;
            chien_ex9_tmp  = mult84_s;
            chien_ex10_tmp = mult85_s;
            chien_ex11_tmp = mult86_s;
            chien_ex12_tmp = mult87_s;
            chien_ex13_tmp = mult88_s;
            chien_ex14_tmp = mult89_s;
            chien_ex15_tmp = mult90_s;
        end
end

////////////////output
assign  detect_error_o = detect_error;
assign  error_data_o   = error_data;

endmodule
