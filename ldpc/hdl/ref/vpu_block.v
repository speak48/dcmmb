//////////////////////////
//
//copyright 2009, SHHIC
//all right reserved
//
//project name: hongqiao
//filename    : vpu_block.v
//author      : Li Gang
//date        : 2009/10/20
//version     : 0.1
//
//module name : vpu_block
//discription : 
//
//modification history
//---------------------------------
//&Log&
//
//////////////////////////

module vpu_block (
                  reset_n     , 
                  clk         , 
                  rate        ,   
                  init_a      ,   
                  init_en_out , 
                  cpu_a       ,   
                  vpu_a       , 
                  cpu_en_out  ,     
                  dec_a       ,    
                  dec_b       , 
                  dec_addr    ,    
                  dec_en_addr ,         
                  vpu_din     ,    
                  lram_dout   ,  
                  
                  cpu_b       ,   
                  vpu_b       ,                   
                  cpu_en_in   ,                                  
                  dec_din     ,  
                  dec_en_in   ,              
                  vpu_dout    ,    
                  ram_wren    ,  
                  ram_addr    ,  
                  lram_wren   ,  
                  lram_addr   ,  
                  vpu_dout2   ,            
                  vpu_state        
                 );



parameter Width_R    = 7  ;
parameter Width_A    = 8  ;
parameter Width_D    = 18 ;
parameter Width_A2   = 24 ;


input                         clk          ;
input                         reset_n      ;
input                         rate         ;
input                         init_a       ;
input                         init_en_out  ;
input                         dec_a        ;
input                         dec_b        ;
input  [287 : 0]              dec_addr     ;
input  [35  : 0]              dec_en_addr  ;
input                         cpu_a        ;
input                         vpu_a        ;
input                         cpu_en_out   ;
input  [647 : 0]              vpu_din   ;  
input  [251 : 0]              lram_dout ; 

output                        vpu_b     ;
output                        cpu_b     ;
output                        cpu_en_in ;
output [35  : 0]              dec_din   ;
output [35  : 0]              dec_en_in ; 
output [35  : 0]              vpu_dout2 ;     
output [647 : 0]              vpu_dout  ; 
output                        ram_wren  ;   
output [863 : 0]              ram_addr  ;
output                        lram_wren ;   
output [287 : 0]              lram_addr ;
output [4   : 0]              vpu_state ;

wire  [23 : 0]   vpu_dint [35:0] ;

assign vpu_dint[0 ]  =  24'd0       ;
assign vpu_dint[1 ]  =  24'd0       ;
assign vpu_dint[2 ]  =  24'd0       ;
assign vpu_dint[3 ]  =  24'd0       ;
assign vpu_dint[4 ]  =  24'd0       ; 
assign vpu_dint[5 ]  =  24'd0       ;
assign vpu_dint[6 ]  =  24'd0       ;
assign vpu_dint[7 ]  =  24'd0       ;
assign vpu_dint[8 ]  =  24'd65280   ;
assign vpu_dint[9 ]  =  24'd4292864 ;
assign vpu_dint[10]  =  24'd15785984;
assign vpu_dint[11]  =  24'd15521792;
assign vpu_dint[12]  =  24'd16424192;
assign vpu_dint[13]  =  24'd15893504;
assign vpu_dint[14]  =  24'd16234496;
assign vpu_dint[15]  =  24'd15793664;
assign vpu_dint[16]  =  24'd15889152;
assign vpu_dint[17]  =  24'd10801408;
assign vpu_dint[18]  =  24'd16318208;
assign vpu_dint[19]  =  24'd3864064 ;
assign vpu_dint[20]  =  24'd14155008;
assign vpu_dint[21]  =  24'd13761536;
assign vpu_dint[22]  =  24'd16355840;
assign vpu_dint[23]  =  24'd16443136;
assign vpu_dint[24]  =  24'd51454   ;
assign vpu_dint[25]  =  24'd15422720;
assign vpu_dint[26]  =  24'd4580608 ;
assign vpu_dint[27]  =  24'd16698112;
assign vpu_dint[28]  =  24'd16483072;
assign vpu_dint[29]  =  24'd16675584;
assign vpu_dint[30]  =  24'd16776448;  
assign vpu_dint[31]  =  24'd16709632;
assign vpu_dint[32]  =  24'd15990528; 
assign vpu_dint[33]  =  24'd16641792; 
assign vpu_dint[34]  =  24'd14153728; 
assign vpu_dint[35]  =  24'd10812416;  

vpu1 u_vpu_1(
          .reset_n              ( reset_n                     ),
          .clk                  ( clk                         ),
          .rate                 ( rate                        ),
          .init_a               ( init_a                      ),
          .init_en_out          ( init_en_out                 ),
          .cpu_a                ( cpu_a                       ),
          .vpu_a                ( vpu_a                       ),
          .cpu_en_out           ( cpu_en_out                  ),
          .dec_a                ( dec_a                       ),
          .dec_b                ( dec_b                       ),
          .dec_addr             ( dec_addr[Width_A -1 : 0 ]   ),
          .dec_en_addr          ( dec_en_addr[0]              ),                           
          .vpu_dint             ( vpu_dint[0]                 ),
          .vpu_din              ( vpu_din [1*Width_D-1 : 0]  ),
          .lram_dout            ( lram_dout [1*Width_R-1 : 0] ),  

          .cpu_b                ( cpu_b                       ),
          .vpu_b                ( vpu_b                       ),
          .cpu_en_in            ( cpu_en_in                   ),           
          .dec_din              ( dec_din[0]                  ),
          .dec_en_in            ( dec_en_in[0]                ),                    
          .vpu_dout2            ( vpu_dout2[0]                ),                 
          .vpu_dout             ( vpu_dout [1*Width_D-1 : 0] ),
          .ram_wren             ( ram_wren                    ),
          .ram_addr             ( ram_addr[1*Width_A2-1 : 0]  ),
          .lram_wren            ( lram_wren                   ),  
          .lram_addr            ( lram_addr[1*Width_A-1 : 0]  ),          
          .vpu_state            ( vpu_state                   )
          );

generate
    genvar i;    
    for(i=1; i<36; i=i+1)
        begin: vpu_inst
           vpu u_vpu(
	            .reset_n              ( reset_n                                 ),
	            .clk                  ( clk                                     ),
	            .rate                 ( rate                                    ),	                                                                                  
	            .init_a               ( init_a                                  ),
                    .init_en_out          ( init_en_out                             ),               
                    .cpu_a                ( cpu_a                                   ),
	            .vpu_a                ( vpu_a                                   ),            
                    .cpu_en_out           ( cpu_en_out                              ),                  
	            .dec_a                ( dec_a                                   ),
	            .dec_b                ( dec_b                                   ),
	            .dec_addr             ( dec_addr[(i+1)*Width_A-1 : i*Width_A]     ),
	            .dec_en_addr          ( dec_en_addr[i]                          ),    
                    .vpu_dint             ( vpu_dint[i]                             ),
                    .vpu_din              ( vpu_din [(i+1)*Width_D-1 : i*Width_D] ),
                    .lram_dout            ( lram_dout [(i+1)*Width_R-1 : i*Width_R] ),
                                                                                    
	            .dec_din              ( dec_din[i]                              ),
	            .dec_en_in            ( dec_en_in[i]                            ),	        
	            .vpu_dout2            ( vpu_dout2[i]                            ),                 
                    .vpu_dout             ( vpu_dout[(i+1)*Width_D-1 : i*Width_D] ),
                    .ram_addr             ( ram_addr[(i+1)*Width_A2-1 : i*Width_A2] ), 
                    .lram_addr            ( lram_addr[(i+1)*Width_A-1 : i*Width_A]  )
                    );       
      end
endgenerate

                  
endmodule

































