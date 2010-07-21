//------------------------------------------------------------------------
// Copyright (c) 2009, HHIC
// HHIC Confidential Proprietary
//------------------------------------------------------------------------
// FILE NAME :mcu_fpga_test.v
// TYPE : TYPE can be module, macromodule
// DEPARTMENT :
// AUTHOR :   Lishuang
// AUTHOR'S EMAIL : lishuang@shhic.com
//------------------------------------------------------------------------
// Release history
// VERSION Date    AUTHOR   DESCRIPTION
// 0.1    09/6/11 lishuang  mcu_fpga_test  submodule
//------------------------------------------------------------------------
// PURPOSE : Short description of functionality
//           this module is used for fpga test, observe critical signal 
//           in mcu
//------------------------------------------------------------------------
// PARAMETERS
// PARAM NAME RANGE : DESCRIPTION : DEFAULT : VA UNITS
//
//------------------------------------------------------------------------
// REUSE ISSUES
// Reset Strategy :  sys_rst
// Clock Domains :     N/A
// Critical Timing :   N/A
// Test Features :     N/A
// Asynchronous I/F :  N/A 
// Scan Methodology :  N/A
// Instantiations :    N/A
// Other :             N/A
//------------------------------------------------------------------------ 


module mcu_fpga_test (
                mcu_test_out  ,
                test_sel	  ,
                mcu_rab_write ,
                mcu_rab_read  ,
                i2cs_rab_write,
                i2cs_rab_read ,
                rab_write     ,
                rab_read      ,
                dataram_cen   ,
                prog_rom_cen  ,
                inter_ram_cen ,
                memaddr       ,
                memwr         ,
                memrd         ,
                dataram_write ,
                dataram_read  ,
                ddc_rfifo_depth,
                mcu_port0o    ,
                mcu_txd0

					);
                    
  /////////////////////////////////////////////////////
  //    IO definition
  /////////////////////////////////////////////////////
  //output                                                                 
  output [31:0]  mcu_test_out;  
  
  //input
  input  [ 1:0]  test_sel  ;         //select the test signal
  
  input          mcu_rab_write ;
  input 		 mcu_rab_read  ;
  input			 i2cs_rab_write;
  input			 i2cs_rab_read ;
  input  		 rab_write     ;
  input          rab_read      ;
  input			 dataram_cen   ;
  input			 prog_rom_cen  ;
  input			 inter_ram_cen ;
  input  [15:0]  memaddr       ;
  input          memwr         ;
  input          memrd         ;
  input          dataram_write ;
  input          dataram_read  ;
  input  [ 3:0]  ddc_rfifo_depth;
  input  [ 7:0]  mcu_port0o    ;
  input          mcu_txd0      ;
 
  reg    [31:0]  mcu_test_out  ; 

  /////////////////////////////////////////////////////
  //    main code start
  /////////////////////////////////////////////////////  
  always@(*) begin
  	case(test_sel)
    	2'b00: mcu_test_out = {26'h0,mcu_rab_write,mcu_rab_read,i2cs_rab_write,i2cs_rab_read,rab_write,rab_read};
        2'b01: mcu_test_out = {29'h0,dataram_cen,prog_rom_cen,inter_ram_cen};
        2'b10: mcu_test_out = {12'h0,memaddr,memwr,memrd,dataram_write,dataram_read};
        2'b11: mcu_test_out = {19'h0,ddc_rfifo_depth,mcu_port0o,mcu_txd0};
    endcase
  
  end
  
  
endmodule
