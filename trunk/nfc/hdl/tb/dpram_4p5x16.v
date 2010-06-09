module dpram_4p5x16 (
    clka,
    clkb,
    dpram_addra,
    dpram_addrb,
    dpram_cena,
    dpram_cenb,
    dpram_wena,
    dpram_wenb,
    dpram_dina,
    dpram_dinb,
    dpram_douta,
    dpram_doutb
    );

input           clka;
input           clkb;
input[12:0]     dpram_addra;
input[12:0]     dpram_addrb;
input           dpram_cena;
input           dpram_cenb;
input[1:0]      dpram_wena;
input[1:0]      dpram_wenb;
input[15:0]     dpram_dina;
input[15:0]     dpram_dinb;
output[15:0]    dpram_douta;
wire[15:0]      dpram_douta;
output[15:0]    dpram_doutb;
wire[15:0]      dpram_doutb;

//internal signals
wire drpam_csa, dpram_csb;

assign dpram_csa = ~dpram_cena;
assign dpram_csb = ~dpram_cenb;

SJ180_4608X8X2CM16 u_dpram(
   .A0    (dpram_addra[0]),  .A1    (dpram_addra[1]),  .A2    (dpram_addra[2]),  .A3    (dpram_addra[3]), 
   .A4    (dpram_addra[4]),  .A5    (dpram_addra[5]),  .A6    (dpram_addra[6]),  .A7    (dpram_addra[7]),
   .A8    (dpram_addra[8]),  .A9    (dpram_addra[9]),  .A10   (dpram_addra[10]), .A11   (dpram_addra[11]),
   .A12   (dpram_addra[12]), 
   .B0    (dpram_addrb[0]),  .B1    (dpram_addrb[1]),  .B2    (dpram_addrb[2]),  .B3    (dpram_addrb[3]), 
   .B4    (dpram_addrb[4]),  .B5    (dpram_addrb[5]),  .B6    (dpram_addrb[6]),  .B7    (dpram_addrb[7]),
   .B8    (dpram_addrb[8]),  .B9    (dpram_addrb[9]),  .B10   (dpram_addrb[10]), .B11   (dpram_addrb[11]),
   .B12   (dpram_addrb[12]),
   .DOA0  (dpram_douta[0]),  .DOA1  (dpram_douta[1]),  .DOA2  (dpram_douta[2]),  .DOA3  (dpram_douta[3]), 
   .DOA4  (dpram_douta[4]),  .DOA5  (dpram_douta[5]),  .DOA6  (dpram_douta[6]),  .DOA7  (dpram_douta[7]),
   .DOA8  (dpram_douta[8]),  .DOA9  (dpram_douta[9]),  .DOA10 (dpram_douta[10]), .DOA11 (dpram_douta[11]), 
   .DOA12 (dpram_douta[12]), .DOA13 (dpram_douta[13]), .DOA14 (dpram_douta[14]), .DOA15 (dpram_douta[15]),
   .DOB0  (dpram_doutb[0]),  .DOB1  (dpram_doutb[1]),  .DOB2  (dpram_doutb[2]),  .DOB3  (dpram_doutb[3]), 
   .DOB4  (dpram_doutb[4]),  .DOB5  (dpram_doutb[5]),  .DOB6  (dpram_doutb[6]),  .DOB7  (dpram_doutb[7]),
   .DOB8  (dpram_doutb[8]),  .DOB9  (dpram_doutb[9]),  .DOB10 (dpram_doutb[10]), .DOB11 (dpram_doutb[11]), 
   .DOB12 (dpram_doutb[12]), .DOB13 (dpram_doutb[13]), .DOB14 (dpram_doutb[14]), .DOB15 (dpram_doutb[15]),
   .DIA0  (dpram_dina[0]),   .DIA1  (dpram_dina[1]),   .DIA2  (dpram_dina[2]),   .DIA3  (dpram_dina[3]), 
   .DIA4  (dpram_dina[4]),   .DIA5  (dpram_dina[5]),   .DIA6  (dpram_dina[6]),   .DIA7  (dpram_dina[7]), 
   .DIA8  (dpram_dina[8]),   .DIA9  (dpram_dina[9]),   .DIA10 (dpram_dina[10]),  .DIA11 (dpram_dina[11]), 
   .DIA12 (dpram_dina[12]),  .DIA13 (dpram_dina[13]),  .DIA14 (dpram_dina[14]),  .DIA15 (dpram_dina[15]),
   .DIB0  (dpram_dinb[0]),   .DIB1  (dpram_dinb[1]),   .DIB2  (dpram_dinb[2]),   .DIB3  (dpram_dinb[3]), 
   .DIB4  (dpram_dinb[4]),   .DIB5  (dpram_dinb[5]),   .DIB6  (dpram_dinb[6]),   .DIB7  (dpram_dinb[7]), 
   .DIB8  (dpram_dinb[8]),   .DIB9  (dpram_dinb[9]),   .DIB10 (dpram_dinb[10]),  .DIB11 (dpram_dinb[11]), 
   .DIB12 (dpram_dinb[12]),  .DIB13 (dpram_dinb[13]),  .DIB14 (dpram_dinb[14]),  .DIB15 (dpram_dinb[15]),
   .CKA   (clka),            .CKB   (clkb),       
   .WEAN0 (dpram_wena[0]),   .WEAN1 (dpram_wena[1]),   .WEBN0 (dpram_wenb[0]),   .WEBN1 (dpram_wenb[1]),
   .CSA   (dpram_csa),       .CSB   (dpram_csb),      .OEA   (1'b1),           .OEB   (1'b1));



endmodule
