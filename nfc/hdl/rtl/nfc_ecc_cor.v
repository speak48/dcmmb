module nfc_ecc_cor(
     clk         ,
     clk_2x      ,
     rst_n       ,
     
     nfc_dat_dir ,
     nfc_ecc_opt ,
     
     ecc_fifo_wr ,
     ecc_enc_dat ,
     ecc_dec_addr,
     ecc_done    ,
     
     mem_if_rd   ,
     mem_enc_dat ,    
     mem_dec_addr,
     ecc_enc_rdy ,
     ecc_dec_rdy ,

);

`include "nfc_parameter.v"

// System IF
input                  clk             ;
input                  clk_2x          ;
input                  rst_n           ;

// Control Reg 
input                  nfc_dat_dir     ;
input                  nfc_ecc_opt     ;

input                  ecc_fifo_wr     ;
input  [ECC_DWID-1:0]  ecc_enc_dat     ;
input  [ECC_AWID-1:0]  ecc_dec_addr    ;
input                  ecc_done        ;

input                  mem_if_rd       ;
output [DAT_WID -1:0]  mem_enc_dat     ;
output [ECC_AWID-1:0]  mem_dec_addr    ;
output                 ecc_enc_rdy     ;
output                 ecc_dec_rdy     ;

reg    [4         :0]  asymfifo_wr_addr;
reg    [3         :0]  asymfifo_rd_addr; 
reg                    ecc_wr1         ;
reg                    ecc_enc_wr      ;
reg                    ecc_dec_end     ;

wire   [1         :0]  asymfifo_wr     ;
wire                   asymfifo_rd     ;
wire   [DAT_WID-1 :0]  asymfifo_din    ;

///////////////////////////////////
// ECC clk_2x clock domain
///////////////////////////////////

// ECC ENC/DEC Write Active
assign asymfifo_wr[0] = nfc_dat_dir ? ecc_fifo_wr & (!asymfifo_wr_addr[0]) : ecc_fifo_wr ;
assign asymfifo_wr[1] = nfc_dat_dir ? (ecc_fifo_wr & asymfifo_wr_addr[0] ) : ecc_fifo_wr ;

// ECC ENC/DEC Write Data
assign asymfifo_din =  nfc_dat_dir ? { ecc_enc_dat, ecc_enc_dat } :
                                   { {{DAT_WID-ECC_AWID}{1'b0}}, ecc_dec_addr} ;

// ECC ENC/DEC Write Address
always @ (posedge clk_2x or negedge rst_n)
begin : ecc_wr_addr
    if(rst_n == 1'b0)
        asymfifo_wr_addr <= 5'h0;
    else if(ecc_done)
        asymfifo_wr_addr <= #1 5'h0;
    else if(ecc_fifo_wr)
        asymfifo_wr_addr <= #1 asymfifo_wr_addr + 1'b1;
end

// ECC ENC Write Procedure
always @ (posedge clk_2x or negedge rst_n)
begin : enc_rdy_r
    if(rst_n == 1'b0)
        ecc_enc_wr <= 1'b0;
    else if(ecc_done)
        ecc_enc_wr <= #1 1'b0;    
    else if(nfc_dat_dir & ecc_fifo_wr)
        ecc_enc_wr <= #1 1'b1;
end

// ECC ENC Write First Byte
always @ (posedge clk_2x or negedge rst_n)
begin : enc_wr1_r
    if(rst_n == 1'b0)
        ecc_wr1 <= 1'b0;
    else 
        ecc_wr1 <= #1 nfc_dat_dir & ecc_fifo_wr & (~ecc_enc_wr);
end        

// ECC DEC Write Last Byte End
always @ (posedge clk_2x or negedge rst_n)
begin : dec_end_r
    if(rst_n == 1'b0)
        ecc_dec_end <= #1 1'b0;
    else if((~nfc_dat_dir) | ecc_done)
        ecc_dec_end <= #1 1'b1;
    else
        ecc_dec_end <= #1 1'b0;
end        

// Cross domain cell transfer 2x pulse signal to 1x
pulse_sync pulse_sync1(
     .clk         ( clk     ),
     .clk_2x      ( clk_2x  ),
     .rst_n       ( rst_n   ),
     .pulse_in    ( ecc_wr1 ),
     .pulse_out   ( ecc_enc_rdy  )
);

pulse_sync pulse_sync2(
     .clk         ( clk     ),
     .clk_2x      ( clk_2x  ),
     .rst_n       ( rst_n   ),
     .pulse_in    ( ecc_dec_end ),
     .pulse_out   ( ecc_dec_rdy  )
);

//////////////////////////////////////
// MEM IF clk clock domain
//////////////////////////////////////

// MEM IF Read Active
assign asymfifo_rd  = mem_if_rd;

// MEM IF Read ENC Data / DEC Addr
assign mem_enc_dat  = nfc_dat_dir ? asymfifo_dout : {{DAT_WID}{1'b0}} ;
assign mem_dec_addr = nfc_dat_dir ? asymfifo_dout[ECC_AWID-1:0] : {{ECC_AWID}{1'b0}};

// MEM IF Read Address
always @ (posedge clk or negedge rst_n)
begin : mem_if_rd_addr
    if(rst_n == 1'b0)
        asymfifo_rd_addr <= 4'h0;
    else if(ecc_dec_rdy)
        asymfifo_rd_addr <= 4'h0;
    else if(asymfifo_rd)
        asymfifo_rd_addr <= #1 asymfifo_rd_addr + 1'b1;
end

// Register File AS FIFO
nfc_asynch_ram rf16x16(
    .wclk        (clk_2x            ),
    .rclk        (clk               ),
    .write       (asymfifo_wr       ),
    .read        (asymfifo_rd       ),
    .addr_wr     (asymfifo_wr_addr[4:1] ),
    .addr_rd     (asymfifo_rd_addr  ),
    .data_in     (asymfifo_din      ),
    .data_out    (asymfifo_dout     )
);


endmodule