
//Project: 3901U421
//Initial by  : Gu Fumin             2009.08
//Modified by : Yongliu Wang         2010.05



`timescale 1 ns/10 ps

module nfc_rng_dat(
    rst_n,
    clk,
    en,
    rd,
    seed,
    mode,
    rng_dat
);
  
input          rst_n;
input          clk;
input          en;
input          rd;
input  [31:0]  seed;
input  [1:0]   mode;
output [7:0]   rng_dat;

wire           rng32_xor;

reg    [31:0]  rng32;
reg            en_dly;
reg    [1:0]   cnt;
reg    [7:0]   rng_dat;

assign rng32_xor = rng32[31] ^ rng32[6] ^ rng32[4] ^ rng32[2] ^ rng32[1] ^ rng32[0];

always @(posedge clk or negedge rst_n)
begin
  if (rst_n==1'b0)
    en_dly <= 1'b0;
  else
    en_dly <= #1 en;
end

always @(posedge clk or negedge rst_n)
begin
  if (rst_n==1'b0)
    cnt[1:0] <= 2'b11;
  else if ((en==1'b1) && (en_dly==1'b1) && (mode == 2'b00) && rd)
    cnt[1:0] <= #1 cnt[1:0] + 1'b1;
  else if(mode != 2'b00 || !en)
    cnt[1:0] <= #1 2'b11;
end

always @(posedge clk or negedge rst_n)
begin
  if (rst_n==1'b0)
    rng32[31:0] <= 32'h00000000;
  else if ((en==1'b1) && (en_dly==1'b0))
      rng32[31:0] <= #1 seed[31:0];
  else if ((en==1'b1) && (en_dly==1'b1) && (cnt[1:0]==2'b11) && rd)
    case(mode)
    2'b00: rng32[31:0]   <= #1 {rng32[30:0], rng32_xor};
    2'b10: rng32[31:24]  <= #1 rng32[31:24] + 1'b1;
    2'b11: rng32[31:24]  <= #1 rng32[31:24] - 1'b1;
    endcase
end

always @(cnt[1:0] or rng32[31:0])
begin
  case (cnt[1:0])
    2'b00: rng_dat[7:0] = rng32[7:0];
    2'b01: rng_dat[7:0] = rng32[15:8];
    2'b10: rng_dat[7:0] = rng32[23:16];
    2'b11: rng_dat[7:0] = rng32[31:24];
  endcase
end
  
endmodule

