
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
  output [15:0]  rng_dat;

wire           rng32_xor;

reg    [31:0]  rng32;
reg            en_dly;
  reg            cnt;
  reg    [15:0]  rng_dat;

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
      cnt <= 1'b1;
  else if ((en==1'b1) && (en_dly==1'b1) && (mode == 2'b00) && rd)
      cnt <= ~cnt ;
  else if(mode != 2'b00 || !en)
      cnt <= 1'b1;
end

always @(posedge clk or negedge rst_n)
begin
  if (rst_n==1'b0)
    rng32[31:0] <= 32'h00000000;
  else if ((en==1'b1) && (en_dly==1'b0))
      rng32[31:0] <= #1 seed[31:0];
    else if ((en==1'b1) && (en_dly==1'b1) && (cnt) && rd)
    case(mode)
      2'b00: rng32[31:0] <= #1 {rng32[30:0], rng32_xor};
      2'b10: begin
             rng32[31:24]  <= #1 rng32[31:24] + 2'b10;
             rng32[23:16]  <= #1 rng32[31:24] + 1'b1;
             end
      2'b11: begin
             rng32[31:24]  <= #1 rng32[31:24] - 2'b10;
             rng32[23:16]  <= #1 rng32[31:24] - 1'b1;
             end
      2'b01: rng32[23:16]  <= #1 rng32[31:24]; 
      endcase
end

  always @(*)
begin
    case (cnt)
      1'b0: rng_dat[15:0] = rng32[15:0];
      1'b1: rng_dat[15:0] = rng32[31:16];
  endcase
end
  
endmodule

