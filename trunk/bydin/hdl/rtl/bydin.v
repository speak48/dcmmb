//Module
module bydin (
      clk           ,
      reset_n       ,
      ldpc_en_out   ,
      ldpc_dout     ,
      ofdm_mode_in  ,

      ts0_win       ,
      ts0_bydin_mode,
      ts0_rs_mode   ,
      ts0_rs_ena    ,
      ts0_ldpc_rate ,
      ts0_en_rd     ,

      ts1_win       ,
      ts1_bydin_mode,
      ts1_rs_mode   ,
      ts1_rs_ena    ,
      ts1_ldpc_rate ,
      ts1_en_rd     ,

      rs_cor_fail   ,
      rs_row_finish ,
      rs_en_out     ,
      rs_dout       ,

      rs_mode      ,
      rs_en_in     ,
      rs_din       ,

      ts0_int      ,
      ts0_en_out   ,
      ts0_dout     ,

      ts1_int      ,
      ts1_en_out   ,
      ts1_dout
 );

//inputs
input            clk           ;
input            reset_n       ;
input            ldpc_en_out   ;
input            ldpc_dout     ;
input            ofdm_mode_in  ;  // band width 8M or 2MHz
// ts0 control IF
input            ts0_win       ;
input  [2:0]     ts0_bydin_mode;
input  [1:0]     ts0_rs_mode   ;
input            ts0_ldpc_rate ;
input            ts0_rs_ena    ;
input            ts0_en_rd     ;
// ts1 Control IF
input            ts1_win       ;
input  [2:0]     ts1_bydin_mode;
input  [1:0]     ts1_rs_mode   ;
input            ts1_rs_ena    ;
input            ts1_ldpc_rate ;
input            ts1_en_rd     ;
// RS IF
input            rs_cor_fail   ;
input            rs_row_finish ;
input            rs_en_out     ;
input  [7:0]     rs_dout       ;

//outputs
// RS IF
output [1:0]     rs_mode       ;
output           rs_en_in      ;
output [7:0]     rs_din        ;

// TS0 IF
output           ts0_int       ;
output           ts0_en_out    ;
output [7:0]     ts0_dout      ;

// TS1 IF
output           ts1_en_out    ;
output           ts1_int       ;
output [7:0]     ts1_dout      ;

wire             byte_sync     ;
wire   [7:0]     byte_data     ;
wire             byte_win0     ;
wire             byte_win1     ;

wire    [7:0]    ts0_mem_do        ;
wire   [16:0]    ts0_mem_addr      ;
wire    [7:0]    ts0_mem_di        ;
wire             ts0_mem_wr        ;
wire             ts0_mem_en        ;
wire             ts0_en_rs         ;

wire    [7:0]    ts1_mem_do        ;
wire   [16:0]    ts1_mem_addr      ;
wire    [7:0]    ts1_mem_di        ;
wire             ts1_mem_wr        ;
wire             ts1_mem_en        ;  
wire             ts1_en_rs         ;


assign rs_mode = ts0_en_rs ? ts0_rs_mode :
	         ts1_en_rs ? ts1_rs_mode : 2'b00;

bit2byte u0_bit2byte(
      .clk         ( clk        ),
      .reset_n     ( reset_n    ),
      .ldpc_en_out ( ldpc_en_out),
      .ldpc_dout   ( ldpc_dout  ),
      .ts0_win     ( ts0_win    ),
      .ts1_win     ( ts1_win    ),

      .byte_sync   ( byte_sync  ),
      .byte_data   ( byte_data  ),
      .byte_win0   ( byte_win0  ),
      .byte_win1   ( byte_win1  )  
);

byte_mem ts0_by_mem(
    .clk        ( clk          ),
    .reset_n    ( reset_n      ),
    .byte_sync  ( byte_sync    ),
    .byte_data  ( byte_data    ),
    .byte_win   ( byte_win0    ),
    .ofdm_mode  ( ofdm_mode_in ),
    .ldpc_rate  ( ts0_ldpc_rate),
    .bydin_mode ( ts0_bydin_mode),
    .ts_en_rd   ( ts0_en_rd    ),
    .rs_ena     ( ts0_rs_ena   ),
    .rs_mode    ( ts0_rs_mode  ),
    .rs_finish  ( rs_row_finish),
    .rs_en_out  ( rs_en_out    ),
    .rs_dout    ( rs_dout      ),

    .mem_addr   ( ts0_mem_addr ),
    .mem_wr     ( ts0_mem_wr   ),
    .mem_en     ( ts0_mem_en   ),
    .mem_di     ( ts0_mem_di   ),
    .mem_do     ( ts0_mem_do   ),

    .rs_en_in   ( rs_en_in     ),
    .rs_din     ( rs_din       ),
    .ts_en_rs   ( ts0_en_rs    ),

    .ts_int     ( ts0_int      ),
    .ts_en_out  ( ts0_en_out   ),
    .ts_dout    ( ts0_dout     )

);

byte_mem ts1_by_mem(
    .clk        ( clk          ),
    .reset_n    ( reset_n      ),
    .byte_sync  ( byte_sync    ),
    .byte_data  ( byte_data    ),
    .byte_win   ( byte_win0    ),
    .ofdm_mode  ( ofdm_mode_in ),
    .ldpc_rate  ( ts1_ldpc_rate),
    .bydin_mode ( ts1_bydin_mode),
    .ts_en_rd   ( ts1_en_rd    ),
    .rs_ena     ( ts1_rs_ena   ),
    .rs_mode    ( ts1_rs_mode  ),
    .rs_finish  ( rs_row_finish),
    .rs_en_out  ( rs_en_out    ),
    .rs_dout    ( rs_dout      ),

    .mem_addr   ( ts1_mem_addr ),
    .mem_wr     ( ts1_mem_wr   ),
    .mem_en     ( ts1_mem_en   ),
    .mem_di     ( ts1_mem_di   ),
    .mem_do     ( ts1_mem_do   ),

    .rs_en_in   ( rs_en_in     ),
    .rs_din     ( rs_din       ),
    .ts_en_rs   ( ts1_en_rs    ),

    .ts_int     ( ts1_int      ),
    .ts_en_out  ( ts1_en_out   ),
    .ts_dout    ( ts1_dout     )
);

sram69120x8 ts0_ram(
    .A     (ts0_mem_addr  ),
    .CLK   (clk           ),
    .D     (ts0_mem_di    ),
    .Q     (ts0_mem_do    ),
    .CEN   (~ts0_mem_en   ),
    .WEN   (~ts0_mem_wr   )
);

sram69120x8 ts1_ram(
    .A     (ts1_mem_addr  ),
    .CLK   (clk           ),
    .D     (ts1_mem_di    ),
    .Q     (ts1_mem_do    ),
    .CEN   (~ts1_mem_en   ),
    .WEN   (~ts1_mem_wr   )
);

endmodule
