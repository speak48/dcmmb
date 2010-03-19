module bidin(
		// Input Ports
		clk6, 
		rst_n, 
		bidin_sync_in, 
		bidin_ena_in, 
		bidin_din, 
		ldpc_req,
		
		// Output Ports
		bidin_rdy,

		bidin_ena_out,
		bidin_dout
		);

parameter WID = 6;

//Input ports declaration
input  	              clk6,rst_n;		
input		      bidin_sync_in;
input		      bidin_ena_in;
input   [WID-1:0]     bidin_din;
input                 ldpc_req;

//Output ports declaration
output                bidin_rdy;
output                bidin_ena_out;
output   [WID-1:0]    bidin_dout;

////////////////////////////////////////////////
//signal declaration
//

wire   [4:0]             state        ;
wire   [WID-1:0]         sub_dout     ;
wire                     sub_dout_en  ;
wire   [WID-1:0]         sub_din      ;
wire                     sub_din_en   ;
    
wire   [17:0]            main_addr    ;
wire   [WID-1:0]         main_data_i  ;
wire   [WID-1:0]         main_data_o  ;
wire                     main_en      ;
wire                     main_wr      ; 

main_man u_main_man(
   .clk            (clk6),
   .rst_n          (rst_n),
   .bidin_sync_in  (bidin_sync_in),
   .bidin_ena_in   (bidin_ena_in ),
   .bidin_din      (bidin_din    ),
   .ldpc_req       (ldpc_req     ),
   .bidin_rdy      (bidin_rdy    ),
   .bidin_ena_out  (bidin_ena_out),
   .bidin_dout     (bidin_dout   ),

   .state          (state        ),
   .sub_dout       (sub_data_o   ),
   .sub_dout_en    (sub_dout_en  ),
   .sub_din        (sub_din      ),
   .sub_din_en     (sub_din_en   ),

   .main_addr      (main_addr    ),
   .main_data_i    (main_data_i  ),
   .main_data_o    (main_data_o  ),
   .main_en        (main_en      ),
   .main_wr        (main_wr      )
);

/*
sub_man(
    .clk           (clk           ),
    .rst_n         (rst_n         ),
    .state         (state         ),
    .sub_dout      (sub_dout      ),
    .sub_dout_en   (sub_dout_en   ),
    .sub_din       (sub_din       ),
    .sub_din_en    (sub_din_en    ),
    .sub_addr      (sub_addr      ),
    .sub_data_i    (sub_data_i    ),
//    .sub_data_o    (sub_data_o    ),
    .sub_en        (sub_en        ),
    .sub_wr        (sub_wr        )
);
*/

sram146880x6 u_sram146880x6(
    .A     (main_addr  ),
    .CLK   (clk6       ),
    .D     (main_data_i),
    .Q     (main_data_o),
    .CEN   (!main_en   ),
    .WEN   (!main_wr   )
);
/*
sram146880x6 u_sram146880x6(
    .addr  (main_addr  ),
    .clk   (clk6       ),
    .din   (main_data_i),
    .dout  (main_data_o),
    .en    (main_en    ),
    .we    (main_wr    )
);
*/

/*
sram9216x6 u_sram9216(
    .addr  (sub_addr   ),
    .clk   (clk        ),
    .din   (sub_data_i ),
    .dout  (sub_data_o ),
    .en    (sub_en     ),
    .we    (sub_wr     )
);
*/

endmodule

