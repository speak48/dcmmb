//////////////////////////
//
//copyright 2009, SHHIC
//all right reserved
//
//project name: hongqiao
//filename    : ldpc_decoder.v
//author      : Li Gang
//date        : 2009/10/20
//version     : 0.1
//
//module name : ldpc_decoder
//discription : 
//
//modification history
//---------------------------------
//&Log&
//
//////////////////////////

`timescale 1ns/1ns

module ldpc_decoder    (clk          ,
	                reset_n      ,
	                rate         ,
	                bidin_rdy    ,
	                en_in        ,
	                din          ,
	                max          ,                           
                        
                        ldpc_req     ,
	                dec_out_flag ,
	                sync_out     ,
	                en_out       ,
	                dout         ,
	                busy         ,	                
	                num     
	               );
	                
input                clk          ;
input                reset_n      ;
input                rate         ;
input                bidin_rdy    ;
input                en_in        ;
input   [5:0]        din          ;
input   [7:0]        max          ;

output               ldpc_req     ;                     
output               busy         ;
output               dec_out_flag ;
output               sync_out     ;
output               dout         ;
output               en_out       ;
output  [7:0]        num          ;


wire                 init_a      ;
wire                 init_b      ;
wire                 init_en_out ;
wire  [215: 0]       init_dout   ;
wire                 vpu_b       ;
wire                 cpu_b       ;
wire                 cpu_en_in   ;
wire                 cpu_en_out  ;
wire  [17 : 0]       cpu_dout2   ;
wire                 dec_a ;
wire  [35 : 0]       dec_din     ;
wire  [35 : 0]       dec_en_in   ;
wire  [287: 0]       dec_addr    ;
wire  [35 : 0]       dec_en_addr ;
wire                 dec_b       ;
wire                 cpu_a       ;
wire                 vpu_a       ;
wire                 busy        ;
wire  [647 : 0]      cpu_dout    ;
wire  [647 : 0]      cpu_din1    ;
wire  [107 : 0]      cpu_din2    ;
wire  [647 : 0]      vpu_din     ;   
wire  [35 :  0]      vpu_dout2   ;     
wire  [647 : 0]      vpu_dout    ; 
wire  [251 : 0]      lram_dout   ; 
wire                 ram_wren    ;   
wire  [863 : 0]      ram_addr    ;
wire                 lram_wren   ;   
wire  [287 : 0]      lram_addr   ;
wire  [4 :   0]      vpu_state   ;
         
init_ldpc  u_init_ldpc (
	               .reset_n     (reset_n     ),
	               .clk         (clk         ),
	               .en_in       (en_in       ),
	               .din         (din         ),	             
	               .init_a      (init_a      ),
	               .en_out      (init_en_out ),
	               .dout        (init_dout   )
	               );		
		

edge_mem  u_edge_mem (  
                      .clk        (clk       ),                        
                      .reset_n    (reset_n   ),
                      .rate       (rate      ),
                      .init_dout  (init_dout ),
                      .cpu_a      (cpu_a     ),
                      .vpu_dout   (vpu_dout  ), 
                      .ram_wren   (ram_wren  ),                           
                      .ram_addr   (ram_addr  ),
                      .lram_wren  (lram_wren ),                           
                      .lram_addr  (lram_addr ),                        
                      .vpu_dout2  (vpu_dout2 ),
                      .state      (vpu_state ), 
                      .cpu_dout   (cpu_dout  ), 
                      .init_b     (init_b    ),
                      .vpu_din    (vpu_din   ), 
                      .lram_dout  (lram_dout ), 
                      .cpu_din1   (cpu_din1  ),
                      .cpu_din2   (cpu_din2  ) 
                     );
                          
                 
vpu_block  u_vpu_block(
                      .reset_n               (reset_n      ),
                      .clk                   (clk          ),
                      .rate                  (rate         ),                                                               
                      .init_a                (init_a       ),
                      .init_en_out           (init_en_out  ),                                             
                      .cpu_b                 (cpu_b        ),
                      .vpu_b                 (vpu_b        ),
                      .cpu_a                 (cpu_a        ),
                      .vpu_a                 (vpu_a        ),                                            
                      .cpu_en_in             (cpu_en_in    ),
                      .cpu_en_out            (cpu_en_out   ),
                      .dec_a                 (dec_a        ),
                      .dec_b                 (dec_b        ),
                      .dec_din               (dec_din      ),
                      .dec_en_in             (dec_en_in    ),
                      .dec_addr              (dec_addr     ),
                      .dec_en_addr           (dec_en_addr  ),                                                               
                      .vpu_din               (vpu_din      ),
                      .lram_dout             (lram_dout    ),                
                      .vpu_dout              (vpu_dout     ),
                      .ram_wren              (ram_wren     ),
                      .ram_addr              (ram_addr     ),
                      .lram_wren             (lram_wren    ),  
                      .lram_addr             (lram_addr    ),  
                      .vpu_dout2             (vpu_dout2    ),         
                      .vpu_state             (vpu_state    ) 
                      );        
 

cpu_block  u_cpu_block   (
                          .reset_n     (reset_n    ),
	                  .clk         (clk        ),
	                  .rate        (rate       ),
	                  .en_in       (cpu_en_in  ),
	                  .cpu_din2    (cpu_din2   ),
	                  .cpu_din1    (cpu_din1   ),                               
	                  .en_out      (cpu_en_out ),
	                  .cpu_dout    (cpu_dout   ),
	                  .cpu_dout2   (cpu_dout2  )
	                  );


dec_out  u_dec_out (
	           .reset_n       (reset_n    ),
	           .clk           (clk        ),
	           .rate          (rate       ),
	           .dec_a         (dec_a      ),
	           .din           (dec_din    ),
	           .en_in         (dec_en_in  ),	           
	           .dec_addr      (dec_addr   ),
                   .dec_en_addr   (dec_en_addr),
                   .dout          (dout       ),
                   .en_out        (en_out     ),
                   .sync_out      (sync_out   ),
                   .dec_b         (dec_b      )
                   );
                 

ctrl     u_ctrl (
                .reset_n        (reset_n      ),
	        .clk            (clk          ),
	        .rate           (rate         ),
	        .bidin_rdy      (bidin_rdy    ),
	        .init_a         (init_a       ),
	        .init_b         (init_b       ),
	        .cpu_b          (cpu_b        ),
	        .vpu_b          (vpu_b        ),
	        .cpu_en_out     (cpu_en_out   ),
	        .cpu_dout2      (cpu_dout2    ),
	        .max            (max          ),
	        .dec_b          (dec_b        ),
	        .ldpc_req	(ldpc_req     ),                        
	        .cpu_a          (cpu_a        ),
	        .vpu_a          (vpu_a        ),
	        .dec_out_flag   (dec_out_flag ),
	        .dec_a          (dec_a        ),
	        .num            (num          ),
	        .busy           (busy         )        
	        );  


endmodule

