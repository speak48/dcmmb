`timescale 1ns/100ps
module  bchecc_syndm(
                rst_n,
                clk,
                ecc_opt_i,
                init_en_i,
                dec_data_i,
                dec_data_avail_i,
                syndm1_o, 
                syndm3_o, 
                syndm5_o, 
                syndm7_o, 
                syndm9_o, 
                syndm11_o,
                syndm13_o,
                syndm15_o,
                syndm17_o,
                syndm19_o,
                syndm21_o,
                syndm23_o,
                syndm25_o,
                syndm27_o,
                syndm29_o
                );
////////////////input
input           rst_n;
input           clk;
input           ecc_opt_i;
input           init_en_i;
input   [7:0]   dec_data_i;
input           dec_data_avail_i;

////////////////output
output  [12:0]  syndm1_o; 
output  [12:0]  syndm3_o; 
output  [12:0]  syndm5_o; 
output  [12:0]  syndm7_o; 
output  [12:0]  syndm9_o; 
output  [12:0]  syndm11_o;
output  [12:0]  syndm13_o;
output  [12:0]  syndm15_o;
output  [12:0]  syndm17_o;
output  [12:0]  syndm19_o;
output  [12:0]  syndm21_o;
output  [12:0]  syndm23_o;
output  [12:0]  syndm25_o;
output  [12:0]  syndm27_o;
output  [12:0]  syndm29_o;

////////////////define parameter
parameter       ALPHA1    = 13'h0002;
parameter       ALPHA2    = 13'h0004;
parameter       ALPHA3    = 13'h0008;
parameter       ALPHA4    = 13'h0010;
parameter       ALPHA5    = 13'h0020;
parameter       ALPHA6    = 13'h0040;
parameter       ALPHA7    = 13'h0080;
parameter       ALPHA8    = 13'h0100;
parameter       ALPHA9    = 13'h0200;
parameter       ALPHA10   = 13'h0400;
parameter       ALPHA11   = 13'h0800;
parameter       ALPHA12   = 13'h1000;
parameter       ALPHA13   = 13'h001B;
parameter       ALPHA14   = 13'h0036;
parameter       ALPHA15   = 13'h006C;
parameter       ALPHA17   = 13'h01B0;
parameter       ALPHA18   = 13'h0360;
parameter       ALPHA19   = 13'h06C0;
parameter       ALPHA20   = 13'h0D80;
parameter       ALPHA21   = 13'h1B00;
parameter       ALPHA22   = 13'h161B;
parameter       ALPHA23   = 13'h0C2D;//
parameter       ALPHA24   = 13'h185A;
parameter       ALPHA25   = 13'h10AF;
parameter       ALPHA26   = 13'h0145;
parameter       ALPHA27   = 13'h028A;
parameter       ALPHA28   = 13'h0514;
parameter       ALPHA29   = 13'h0A28;
parameter       ALPHA30   = 13'h1450;
parameter       ALPHA33   = 13'h02F7;
parameter       ALPHA34   = 13'h05EE;
parameter       ALPHA35   = 13'h0BDC;
parameter       ALPHA36   = 13'h17B8;
parameter       ALPHA38   = 13'h1ED6;
parameter       ALPHA39   = 13'h1DB7;
parameter       ALPHA40   = 13'h1B75;
parameter       ALPHA42   = 13'h0DF9;
parameter       ALPHA44   = 13'h17FF;
parameter       ALPHA45   = 13'h0FE5;
parameter       ALPHA46   = 13'h1FCA;
parameter       ALPHA49   = 13'h1E11;
parameter       ALPHA50   = 13'h1C39;
parameter       ALPHA51   = 13'h1869;
parameter       ALPHA52   = 13'h10C9;
parameter       ALPHA54   = 13'h0312;
parameter       ALPHA55   = 13'h0624;
parameter       ALPHA56   = 13'h0C48;
parameter       ALPHA57   = 13'h1890;
parameter       ALPHA58   = 13'h113B;
parameter       ALPHA60   = 13'h04DA;
parameter       ALPHA63   = 13'h06CB;
parameter       ALPHA65   = 13'h1B2C;
parameter       ALPHA66   = 13'h1643;
parameter       ALPHA68   = 13'h193A;
parameter       ALPHA69   = 13'h126F;
parameter       ALPHA72   = 13'h1314;
parameter       ALPHA75   = 13'h18CC;
parameter       ALPHA76   = 13'h1183;
parameter       ALPHA77   = 13'h031D;
parameter       ALPHA78   = 13'h063A;
parameter       ALPHA81   = 13'h11CB;
parameter       ALPHA84   = 13'h0E34;
parameter       ALPHA85   = 13'h1C68;
parameter       ALPHA87   = 13'h118D;
parameter       ALPHA88   = 13'h0301;
parameter       ALPHA90   = 13'h0C04;
parameter       ALPHA91   = 13'h1808;
parameter       ALPHA92   = 13'h100B;
parameter       ALPHA95   = 13'h0034;
parameter       ALPHA100  = 13'h0680;
parameter       ALPHA102  = 13'h1A00;
parameter       ALPHA104  = 13'h082D;
parameter       ALPHA105  = 13'h105A;
parameter       ALPHA108  = 13'h02BC;
parameter       ALPHA114  = 13'h0F77;
parameter       ALPHA115  = 13'h1EEE;
parameter       ALPHA116  = 13'h1DC7;
parameter       ALPHA119  = 13'h0E79;
parameter       ALPHA120  = 13'h1CF2;
parameter       ALPHA125  = 13'h1F44;
parameter       ALPHA126  = 13'h1E93;
parameter       ALPHA133  = 13'h0D7E;
parameter       ALPHA135  = 13'h15E3;
parameter       ALPHA136  = 13'h0BDD;

parameter       ALPHA138  = 13'h0F6F;
parameter       ALPHA145  = 13'h15FF;
parameter       ALPHA147  = 13'h17CA;
parameter       ALPHA150  = 13'h1E27;
parameter       ALPHA152  = 13'h18B1;
parameter       ALPHA161  = 13'h1475;
parameter       ALPHA162  = 13'h08F1;
parameter       ALPHA168  = 13'h1DEB;
parameter       ALPHA174  = 13'h18E5;
parameter       ALPHA175  = 13'h11D1;
parameter       ALPHA184  = 13'h181F;
parameter       ALPHA189  = 13'h0288;
parameter       ALPHA200  = 13'h0ED6;
parameter       ALPHA203  = 13'h169D;
parameter       ALPHA216  = 13'h0606;
parameter       ALPHA232  = 13'h133A;
                        
////////////////register
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

wire    [12:0]  syndm1_tmp; 
wire    [12:0]  syndm3_tmp; 
wire    [12:0]  syndm5_tmp; 
wire    [12:0]  syndm7_tmp; 
wire    [12:0]  syndm9_tmp; 
wire    [12:0]  syndm11_tmp;
wire    [12:0]  syndm13_tmp;
wire    [12:0]  syndm15_tmp;
wire    [12:0]  syndm17_tmp;
wire    [12:0]  syndm19_tmp;
wire    [12:0]  syndm21_tmp;
wire    [12:0]  syndm23_tmp;
wire    [12:0]  syndm25_tmp;
wire    [12:0]  syndm27_tmp;
wire    [12:0]  syndm29_tmp;

wire    [12:0]  syndm1_basic; 
wire    [12:0]  syndm3_basic; 
wire    [12:0]  syndm5_basic; 
wire    [12:0]  syndm7_basic; 
wire    [12:0]  syndm9_basic; 
wire    [12:0]  syndm11_basic;
wire    [12:0]  syndm13_basic;
wire    [12:0]  syndm15_basic;
wire    [12:0]  syndm17_basic;
wire    [12:0]  syndm19_basic;
wire    [12:0]  syndm21_basic;
wire    [12:0]  syndm23_basic;
wire    [12:0]  syndm25_basic;
wire    [12:0]  syndm27_basic;
wire    [12:0]  syndm29_basic;
                        
////////////////register
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
    else if(init_en_i)
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
    else if(dec_data_avail_i)
        begin
            syndm1  <= syndm1_tmp;
            syndm3  <= syndm3_tmp;
            syndm5  <= syndm5_tmp;
            syndm7  <= syndm7_tmp;
            syndm9  <= syndm9_tmp;
            syndm11 <= syndm11_tmp;
            syndm13 <= syndm13_tmp;
            syndm15 <= syndm15_tmp;
            if(ecc_opt_i)
                begin
                    syndm17 <= syndm17_tmp;
                    syndm19 <= syndm19_tmp;
                    syndm21 <= syndm21_tmp;
                    syndm23 <= syndm23_tmp;
                    syndm25 <= syndm25_tmp;
                    syndm27 <= syndm27_tmp;
                    syndm29 <= syndm29_tmp;
                end
        end
end

////////////////calculate logic
bchecc_gfmult15 u0_gfmult15(
                .data_a1_i    (syndm1),
                .data_a2_i    (syndm3),
                .data_a3_i    (syndm5),
                .data_a4_i    (syndm7),
                .data_a5_i    (syndm9),
                .data_a6_i    (syndm11),
                .data_a7_i    (syndm13),
                .data_a8_i    (syndm15),
                .data_a9_i    (syndm17),
                .data_a10_i   (syndm19),
                .data_a11_i   (syndm21),
                .data_a12_i   (syndm23),
                .data_a13_i   (syndm25),
                .data_a14_i   (syndm27),
                .data_a15_i   (syndm29),
                .data_b1_i    (ALPHA8),
                .data_b2_i    (ALPHA24),
                .data_b3_i    (ALPHA40),
                .data_b4_i    (ALPHA56),
                .data_b5_i    (ALPHA72),
                .data_b6_i    (ALPHA88),
                .data_b7_i    (ALPHA104),
                .data_b8_i    (ALPHA120),
                .data_b9_i    (ALPHA136),
                .data_b10_i   (ALPHA152),
                .data_b11_i   (ALPHA168),
                .data_b12_i   (ALPHA184),
                .data_b13_i   (ALPHA200),
                .data_b14_i   (ALPHA216),
                .data_b15_i   (ALPHA232),
                .data_s1_o    (syndm1_basic),
                .data_s2_o    (syndm3_basic),
                .data_s3_o    (syndm5_basic),
                .data_s4_o    (syndm7_basic),
                .data_s5_o    (syndm9_basic),
                .data_s6_o    (syndm11_basic),
                .data_s7_o    (syndm13_basic),
                .data_s8_o    (syndm15_basic),
                .data_s9_o    (syndm17_basic),
                .data_s10_o   (syndm19_basic),
                .data_s11_o   (syndm21_basic),
                .data_s12_o   (syndm23_basic),
                .data_s13_o   (syndm25_basic),
                .data_s14_o   (syndm27_basic),
                .data_s15_o   (syndm29_basic)
                );
                
assign  syndm1_tmp =   ((({12'h000,dec_data_i[7]}     ^ ({13{dec_data_i[6]}} & ALPHA1))
	                 ^  (({13{dec_data_i[5]}} & ALPHA2) ^ ({13{dec_data_i[4]}} & ALPHA3)))
	                 ^ ((({13{dec_data_i[3]}} & ALPHA4) ^ ({13{dec_data_i[2]}} & ALPHA5))
                   ^  (({13{dec_data_i[1]}} & ALPHA6) ^ ({13{dec_data_i[0]}} & ALPHA7)))) 
                   ^ syndm1_basic;
assign  syndm3_tmp =   ((({12'h000,dec_data_i[7]}      ^ ({13{dec_data_i[6]}} & ALPHA3))
                   ^  (({13{dec_data_i[5]}} & ALPHA6)  ^ ({13{dec_data_i[4]}} & ALPHA9)))
                   ^ ((({13{dec_data_i[3]}} & ALPHA12) ^ ({13{dec_data_i[2]}} & ALPHA15)) 
                   ^  (({13{dec_data_i[1]}} & ALPHA18) ^ ({13{dec_data_i[0]}} & ALPHA21)))) 
                   ^ syndm3_basic;
assign  syndm5_tmp =   ((({12'h000,dec_data_i[7]}      ^ ({13{dec_data_i[6]}} & ALPHA5))
                   ^  (({13{dec_data_i[5]}} & ALPHA10) ^ ({13{dec_data_i[4]}} & ALPHA15)))
                   ^ ((({13{dec_data_i[3]}} & ALPHA20) ^ ({13{dec_data_i[2]}} & ALPHA25))
                   ^  (({13{dec_data_i[1]}} & ALPHA30) ^ ({13{dec_data_i[0]}} & ALPHA35)))) 
                   ^ syndm5_basic;
assign  syndm7_tmp =   ((({12'h000,dec_data_i[7]}      ^ ({13{dec_data_i[6]}} & ALPHA7))
                   ^  (({13{dec_data_i[5]}} & ALPHA14) ^ ({13{dec_data_i[4]}} & ALPHA21)))
                   ^ ((({13{dec_data_i[3]}} & ALPHA28) ^ ({13{dec_data_i[2]}} & ALPHA35)) 
                   ^  (({13{dec_data_i[1]}} & ALPHA42) ^ ({13{dec_data_i[0]}} & ALPHA49)))) 
                   ^ syndm7_basic;
assign  syndm9_tmp =   ((({12'h000,dec_data_i[7]}      ^ ({13{dec_data_i[6]}} & ALPHA9)) 
                   ^  (({13{dec_data_i[5]}} & ALPHA18) ^ ({13{dec_data_i[4]}} & ALPHA27)))
                   ^ ((({13{dec_data_i[3]}} & ALPHA36) ^ ({13{dec_data_i[2]}} & ALPHA45))
                   ^  (({13{dec_data_i[1]}} & ALPHA54) ^ ({13{dec_data_i[0]}} & ALPHA63)))) 
                   ^ syndm9_basic;
assign  syndm11_tmp =  ((({12'h000,dec_data_i[7]}      ^ ({13{dec_data_i[6]}} & ALPHA11)) 
                   ^  (({13{dec_data_i[5]}} & ALPHA22) ^ ({13{dec_data_i[4]}} & ALPHA33)))
                   ^ ((({13{dec_data_i[3]}} & ALPHA44) ^ ({13{dec_data_i[2]}} & ALPHA55))
                   ^  (({13{dec_data_i[1]}} & ALPHA66) ^ ({13{dec_data_i[0]}} & ALPHA77)))) 
                   ^ syndm11_basic;
assign  syndm13_tmp =  ((({12'h000,dec_data_i[7]}      ^ ({13{dec_data_i[6]}} & ALPHA13))
                   ^  (({13{dec_data_i[5]}} & ALPHA26) ^ ({13{dec_data_i[4]}} & ALPHA39)))
                   ^ ((({13{dec_data_i[3]}} & ALPHA52) ^ ({13{dec_data_i[2]}} & ALPHA65))
                   ^  (({13{dec_data_i[1]}} & ALPHA78) ^ ({13{dec_data_i[0]}} & ALPHA91)))) 
                   ^ syndm13_basic;
assign  syndm15_tmp =  ((({12'h000,dec_data_i[7]}      ^ ({13{dec_data_i[6]}} & ALPHA15))
                   ^  (({13{dec_data_i[5]}} & ALPHA30) ^ ({13{dec_data_i[4]}} & ALPHA45)))
                   ^ ((({13{dec_data_i[3]}} & ALPHA60) ^ ({13{dec_data_i[2]}} & ALPHA75))
                   ^  (({13{dec_data_i[1]}} & ALPHA90) ^ ({13{dec_data_i[0]}} & ALPHA105)))) 
                   ^ syndm15_basic;
assign  syndm17_tmp =  ((({12'h000,dec_data_i[7]}       ^ ({13{dec_data_i[6]}} & ALPHA17)) 
                   ^  (({13{dec_data_i[5]}} & ALPHA34)  ^ ({13{dec_data_i[4]}} & ALPHA51)))
                   ^ ((({13{dec_data_i[3]}} & ALPHA68)  ^ ({13{dec_data_i[2]}} & ALPHA85))
                   ^  (({13{dec_data_i[1]}} & ALPHA102) ^ ({13{dec_data_i[0]}} & ALPHA119)))) 
                   ^ syndm17_basic;
assign  syndm19_tmp =  ((({12'h000,dec_data_i[7]}       ^ ({13{dec_data_i[6]}} & ALPHA19))
                   ^  (({13{dec_data_i[5]}} & ALPHA38)  ^ ({13{dec_data_i[4]}} & ALPHA57)))
                   ^ ((({13{dec_data_i[3]}} & ALPHA76)  ^ ({13{dec_data_i[2]}} & ALPHA95))
                   ^  (({13{dec_data_i[1]}} & ALPHA114) ^ ({13{dec_data_i[0]}} & ALPHA133)))) 
                   ^ syndm19_basic;
assign  syndm21_tmp =  ((({12'h000,dec_data_i[7]}       ^ ({13{dec_data_i[6]}} & ALPHA21))
                   ^  (({13{dec_data_i[5]}} & ALPHA42)  ^ ({13{dec_data_i[4]}} & ALPHA63)))
                   ^ ((({13{dec_data_i[3]}} & ALPHA84)  ^ ({13{dec_data_i[2]}} & ALPHA105))
                   ^  (({13{dec_data_i[1]}} & ALPHA126) ^ ({13{dec_data_i[0]}} & ALPHA147)))) 
                   ^ syndm21_basic;
assign  syndm23_tmp =  ((({12'h000,dec_data_i[7]}       ^ ({13{dec_data_i[6]}} & ALPHA23))
                   ^  (({13{dec_data_i[5]}} & ALPHA46)  ^ ({13{dec_data_i[4]}} & ALPHA69)))
                   ^ ((({13{dec_data_i[3]}} & ALPHA92)  ^ ({13{dec_data_i[2]}} & ALPHA115))
                   ^  (({13{dec_data_i[1]}} & ALPHA138) ^ ({13{dec_data_i[0]}} & ALPHA161)))) 
                   ^ syndm23_basic;
assign  syndm25_tmp =  ((({12'h000,dec_data_i[7]}       ^ ({13{dec_data_i[6]}} & ALPHA25)) 
                   ^  (({13{dec_data_i[5]}} & ALPHA50)  ^ ({13{dec_data_i[4]}} & ALPHA75))) 
                   ^ ((({13{dec_data_i[3]}} & ALPHA100) ^ ({13{dec_data_i[2]}} & ALPHA125))
                   ^  (({13{dec_data_i[1]}} & ALPHA150) ^ ({13{dec_data_i[0]}} & ALPHA175)))) 
                   ^ syndm25_basic;
assign  syndm27_tmp =  ((({12'h000,dec_data_i[7]}       ^ ({13{dec_data_i[6]}} & ALPHA27))
                   ^  (({13{dec_data_i[5]}} & ALPHA54)  ^ ({13{dec_data_i[4]}} & ALPHA81)))
                   ^ ((({13{dec_data_i[3]}} & ALPHA108) ^ ({13{dec_data_i[2]}} & ALPHA135))
                   ^  (({13{dec_data_i[1]}} & ALPHA162) ^ ({13{dec_data_i[0]}} & ALPHA189)))) 
                   ^ syndm27_basic;
assign  syndm29_tmp =  ((({12'h000,dec_data_i[7]}       ^ ({13{dec_data_i[6]}} & ALPHA29)) 
                   ^  (({13{dec_data_i[5]}} & ALPHA58)  ^ ({13{dec_data_i[4]}} & ALPHA87)))
                   ^ ((({13{dec_data_i[3]}} & ALPHA116) ^ ({13{dec_data_i[2]}} & ALPHA145))
                   ^  (({13{dec_data_i[1]}} & ALPHA174) ^ ({13{dec_data_i[0]}} & ALPHA203)))) 
                   ^ syndm29_basic;
                
////////////////output
assign  syndm1_o  = syndm1; 
assign  syndm3_o  = syndm3; 
assign  syndm5_o  = syndm5; 
assign  syndm7_o  = syndm7; 
assign  syndm9_o  = syndm9; 
assign  syndm11_o = syndm11;
assign  syndm13_o = syndm13;
assign  syndm15_o = syndm15;
assign  syndm17_o = syndm17;
assign  syndm19_o = syndm19;
assign  syndm21_o = syndm21;
assign  syndm23_o = syndm23;
assign  syndm25_o = syndm25;
assign  syndm27_o = syndm27;
assign  syndm29_o = syndm29;

endmodule