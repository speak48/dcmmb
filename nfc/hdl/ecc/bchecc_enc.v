`timescale 1ns/100ps
module  bchecc_enc(
                rst_n,
                clk,
                init_en_i,
                ecc_opt_i,
                ecc_data_i,
                enc_data_avail_i,
                enc_last_i,
                enc_out_en_i,
                enc_out_first_i,
                enc_data_o
                );
////////////////input
input           rst_n;
input           clk;
input           init_en_i;
input           ecc_opt_i;
input   [7:0]   ecc_data_i;
input           enc_data_avail_i;
input           enc_last_i;
input           enc_out_en_i;
input           enc_out_first_i;

////////////////output
output  [7:0]   enc_data_o;
reg     [7:0]   enc_dout;

////////////////encoder register
reg     [194:0] enc_data;

////////////////encoder logic signals
wire    [194:0] gen_poly;
wire    [194:0] enc_data0;
wire    [194:0] enc_data1;
wire    [194:0] enc_data2;
wire    [194:0] enc_data3;
wire    [194:0] enc_data4;
wire    [194:0] enc_data5;
wire    [194:0] enc_data6;
wire    [194:0] enc_data7;
wire    [194:0] enc_data_tmp;
                        
////////////////encoder register
always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            enc_data <= {195{1'b0}};
        end
    else if(init_en_i)
        begin
            enc_data <= {195{1'b0}};
        end
    else if(enc_data_avail_i)
        begin
            enc_data[194:0] <= enc_data_tmp[194:0];
        end
    else if(enc_out_en_i)
        begin
            if(ecc_opt_i && enc_out_first_i)
                begin
                    enc_data <= {3'b000,enc_data[194:3]};
                end
            else
                begin
                    enc_data <= {8'h00,enc_data[194:8]};
                end
        end
end

always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            enc_dout <= 8'h00;
        end
    else if(init_en_i)
        begin
            enc_dout <= 8'h00;
        end
    else if(enc_out_en_i)
        begin
            if (ecc_opt_i && enc_out_first_i)
                begin
                    enc_dout <= {enc_data[2:0],ecc_data_i[4:0]};
                end
            else
                begin
                    enc_dout <= enc_data[7:0];
                end
        end
end

////////////////encoder logic
assign  gen_poly = ecc_opt_i? 195'h59A7A9C6E291DE47EBBAAE07E6B438E89058613FE6BED40CC :
                              195'h00000000000000000000000C4DF23A382E1C830DE07289FA8;

bchecc_modgenpoly  u0_modgenpoly(
                .data_i      (ecc_data_i[0]),
                .ecc_r_i     (enc_data),
                .gen_poly_i  (gen_poly),
                .ecc_r_o     (enc_data0)
                );

bchecc_modgenpoly  u1_modgenpoly(
                .data_i      (ecc_data_i[1]),
                .ecc_r_i     (enc_data0),
                .gen_poly_i  (gen_poly),
                .ecc_r_o     (enc_data1)
                );

bchecc_modgenpoly  u2_modgenpoly(
                .data_i      (ecc_data_i[2]),
                .ecc_r_i     (enc_data1),
                .gen_poly_i  (gen_poly),
                .ecc_r_o     (enc_data2)
                );

bchecc_modgenpoly  u3_modgenpoly(
                .data_i      (ecc_data_i[3]),
                .ecc_r_i     (enc_data2),
                .gen_poly_i  (gen_poly),
                .ecc_r_o     (enc_data3)
                );

bchecc_modgenpoly  u4_modgenpoly(
                .data_i      (ecc_data_i[4]),
                .ecc_r_i     (enc_data3),
                .gen_poly_i  (gen_poly),
                .ecc_r_o     (enc_data4)
                );

bchecc_modgenpoly  u5_modgenpoly(
                .data_i      (ecc_data_i[5]),
                .ecc_r_i     (enc_data4),
                .gen_poly_i  (gen_poly),
                .ecc_r_o     (enc_data5)
                );

bchecc_modgenpoly  u6_modgenpoly(
                .data_i      (ecc_data_i[6]),
                .ecc_r_i     (enc_data5),
                .gen_poly_i  (gen_poly),
                .ecc_r_o     (enc_data6)
                );

bchecc_modgenpoly  u7_modgenpoly(
                .data_i      (ecc_data_i[7]),
                .ecc_r_i     (enc_data6),
                .gen_poly_i  (gen_poly),
                .ecc_r_o     (enc_data7)
                );
                
assign  enc_data_tmp = (ecc_opt_i && enc_last_i) ? enc_data4 : enc_data7;

////////////////output
assign  enc_data_o = enc_dout;

endmodule
              