module iir_hq(
    clk       ,
    reset_n   ,
    data_I_in ,
    data_Q_in ,
    data_I_o  ,
    data_I_o  
);

parameter IN_WID  = 10,
          OUT_WID = 10;

input                clk       ;
input                reset_n   ;
input  [IN_WID-1:0]  data_I_in ;
input  [IN_WID-1:0]  data_Q_in ;

output [OUT_WID-1:0] data_I_o  ;
output [OUT_WID-1:0] data_Q_o  ;

iir iir_i(
    .clk      ( clk       ),
    .reset_n  ( reset_n   ),
    .data_in  ( data_I_in ),
    .data_out ( data_I_o  )
);

iir iir_q(
    .clk      ( clk       ),
    .reset_n  ( reset_n   ),
    .data_in  ( data_Q_in ),
    .data_out ( data_Q_o  )
);

endmodule
