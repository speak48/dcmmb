//////////////////////////
//
//copyright 2009, SHHIC
//all right reserved
//
//project name: hongqiao
//filename    : ldpc_rom.v
//author      : Li Gang
//date        : 2009/10/20
//version     : 0.1
//
//module name : ldpc_rom
//discription : 
//
//modification history
//---------------------------------
//&Log&
//
//////////////////////////

module ldpc_rom (	addr          ,
                        clk           ,
                        dout          );
                        

input        clk  ;
input [13:0] addr ;
output[13:0] dout ;


ldpc_rom_ise  u_ldpc_rom_ise (
	.addr(addr[12:0]), // Bus [12 : 0] 
	.clk(clk),
	.dout(dout)); // Bus [13 : 0] 

             
endmodule            

