module bidin(
                // Input Ports
                clk6, 
                rst_n, 
                bidin_sync_in, 
                bidin_ena_in, 
                bidin_din, 
                ldpc_req,
                ldpc_fin,
                
                // Output Ports
                bidin_rdy,
                bidin_full,
                bidin_ena_out,
                bidin_dout
                );

parameter WID = 6;

//Input ports declaration
input                 clk6,rst_n;               
input                 bidin_sync_in;
input                 bidin_ena_in;
input   [WID-1:0]     bidin_din;
input                 ldpc_req;
input                 ldpc_fin;

//Output ports declaration
output                bidin_rdy;
output                bidin_ena_out;
output   [WID-1:0]    bidin_dout;
output                bidin_full;

////////////////////////////////////////////////
//signal declaration
//
   
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
   .ldpc_fin       (ldpc_fin     ),
   .bidin_rdy      (bidin_rdy    ),
   .bidin_full     (bidin_full   ),
   .bidin_ena_out  (bidin_ena_out),
   .bidin_dout     (bidin_dout   ),

   .main_addr      (main_addr    ),
   .main_data_i    (main_data_i  ),
   .main_data_o    (main_data_o  ),
   .main_en        (main_en      ),
   .main_wr        (main_wr      )
);

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
endmodule

