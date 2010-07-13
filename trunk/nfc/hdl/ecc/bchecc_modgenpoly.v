//+File Header//////////////////////////////////////////////////////////////////
//Copyright 2009, shhic. All rights reserved
//Filename    : bchecc_modgenpoly.v
//Module name : bchecc_modgenpoly
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
module bchecc_modgenpoly(
                data_i,
                ecc_r_i,
                gen_poly_i,
                ecc_r_o
                );
////////////////input port
input           data_i;
input   [194:0] ecc_r_i;
input   [194:0] gen_poly_i;

////////////////output port
output  [194:0] ecc_r_o;

////////////////define internal signals
wire            ecc_c;

////////////////calculate
assign  ecc_c   = data_i ^ ecc_r_i[0];
assign  ecc_r_o = ({195{ecc_c}} & gen_poly_i) ^ {1'b0,ecc_r_i[194:1]};
	
	
endmodule