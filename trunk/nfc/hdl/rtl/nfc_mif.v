//
//
module nfc_mif(
    clk            ,
    rst_n          ,
     
    rng_sel        ,
    rng_dat        ,
    rng_rd         ,

    nfc_blk_len    ,
    nfc_spa_len    ,
    nfc_ecc_len    ,
    nfc_trn_cnt    ,
    nfc_dat_addr   ,
    nfc_spa_addr   ,
    nfc_mode       ,

    nfc_dat_dir    ,
    nfc_dat_en     ,
    nfc_dat_end    ,

    nfif_data_rd   ,
    nfif_rd_rdy    ,
    nfif_data_in   ,

    nfif_data_wr   ,
    nfif_data_out  ,
    nfif_wr_rdy    ,
     
    mif_ecc_rd     ,
    ecc_enc_dat    ,    
    ecc_dec_addr   ,
    ecc_enc_rdy    ,
    ecc_dec_rdy    ,

    nfc_ram_addr   ,
    nfc_ram_cen    ,
    nfc_ram_wen    ,
    nfc_ram_din    ,
    ram_nfc_dout       
);

`include "nfc_parameter.v"
// System IF
input                  clk             ;
input                  rst_n           ;

// RNG Interface
input   [2        :0]  rng_sel         ;        
input   [7        :0]  rng_dat         ;
output                 rng_rd          ;

// SFR interface
input   [11       :0]  nfc_blk_len     ;
input   [3        :0]  nfc_spa_len     ;
input   [1        :0]  nfc_ecc_len     ;
input   [13       :0]  nfc_trn_cnt     ;
input   [13       :0]  nfc_dat_addr    ;
input   [13       :0]  nfc_spa_addr    ;
input                  nfc_dat_en      ;
input                  nfc_dat_dir     ;
input                  nfc_dat_end     ; // Reg/RAM
input   [1        :0]  nfc_mode        ;

// NF_IF Interface
//input                  nfif_dat_done   ;
input                  nfif_data_rd    ;
output                 nfif_rd_rdy     ;
output  [DAT_WID-1:0]  nfif_data_in    ;
input                  nfif_data_wr    ;
input   [DAT_WID-1:0]  nfif_data_out   ;
output                 nfif_wr_rdy     ;

// ECC interface
output                 mif_ecc_rd      ;
input   [15       :0]  ecc_enc_dat     ;
input   [12       :0]  ecc_dec_addr    ;
input                  ecc_enc_rdy     ;
input                  ecc_dec_rdy     ;

// RAM Interface
output  [12       :0]  nfc_ram_addr    ;
output                 nfc_ram_cen     ;
output  [1        :0]  nfc_ram_wen     ;
output  [15       :0]  nfc_ram_din     ;
input   [15       :0]  ram_nfc_dout    ; 

parameter      MIF_RD_IDLE = 2'b00     ,
               MIF_RD_DAT  = 2'b01     ,
               MIF_RD_SPA  = 2'b10     ,
               MIF_RD_ECC  = 2'b11     ;

reg     [13       :0]  mif_cnt         ;
reg     [11       :0]  blk_cnt         ;
reg     [1        :0]  mif_rd_sta      ;
reg     [DAT_WID-1:0]  nfif_data_in    ;
reg     [13       :0]  mif_dat_addr    ;
reg     [13       :0]  mif_spa_addr    ;
reg                    nfif_rd_rdy     ;
reg                    ram_rd_dly      ;
reg                    ecc_rd_dly      ;

reg     [1        :0]  mif_rd_nxt_sta  ;
reg     [11       :0]  blk_len         ;
reg     [7        :0]  dat8_tmp        ;

wire                   mif_cnt_en      ;
wire                   mif_cnt_rst     ;
wire                   blk_end         ;
wire                   sta_rd_dat      ;
wire                   sta_rd_spa      ;
wire                   sta_rd_ecc      ;
wire                   sta_rd_idl      ;
wire                   nxt_sta_rd_sta  ;
wire                   rng_rd          ;
wire                   dat_rd          ;
wire                   ecc_rd          ;
wire                   spa_rd          ;


wire nfc_ecc_en = 1'b0;
wire nfc_spa_en = 1'b0;

assign mif_ecc_rd = ecc_rd;
assign nfc_ram_addr = sta_rd_spa ? mif_spa_addr : mif_dat_addr;
assign nfc_ram_cen  = !(dat_rd | spa_rd );
assign nfc_ram_wen  = 2'b11;

// FSM Active Signal
assign sta_rd_idl = (mif_rd_sta == MIF_RD_IDLE);
assign sta_rd_dat = (mif_rd_sta == MIF_RD_DAT);
assign sta_rd_spa = (mif_rd_sta == MIF_RD_SPA);
assign sta_rd_ecc = (mif_rd_sta == MIF_RD_ECC);
assign nxt_sta_rd_dat = (mif_rd_nxt_sta == MIF_RD_DAT);

// RNG/DAT/SPA/ECC Read Active signal
assign rng_rd     = sta_rd_dat & rng_sel[2] & nfif_data_rd;
assign dat_rd     = sta_rd_dat & (!rng_sel[2]) & nfif_data_rd;
assign spa_rd     = sta_rd_spa & (!rng_sel[2]) & nfif_data_rd;
assign ecc_rd     = sta_rd_ecc & nfif_data_rd;

// read firt data imediately after en
// read continued data while data have been read by NFC_IF
assign mif_cnt_en = rng_rd | dat_rd | spa_rd | ecc_rd;
// mif_cnt rst if all data are tranmitted
assign mif_cnt_rst = ( mif_cnt == nfc_trn_cnt );

assign blk_end = (blk_cnt == blk_len );

// MIF counter 14 bit for max 9K size
always @ (posedge clk or negedge rst_n)
begin 
    if(rst_n == 1'b0)
        mif_cnt <= 14'h0;
    else if(mif_cnt_rst)
        mif_cnt <= #1 14'h0;
    else if(mif_cnt_en)
        mif_cnt <= #1 mif_cnt + 1'b1;	    
end

// Block counter 10 bit for max 512 size
always @ (posedge clk or negedge rst_n)
begin 
    if(rst_n == 1'b0)
        blk_cnt <= 12'h0;
    else if(blk_end)
        blk_cnt <= #1 12'h0;
    else if(mif_cnt_en)
        blk_cnt <= #1 blk_cnt + 1'b1;	    
end

// Read FSM
always @ (posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0)
        mif_rd_sta <= MIF_RD_IDLE;
    else
	mif_rd_sta <= #1 mif_rd_nxt_sta;
end

// Read Next FSM
always @ (*)
begin
    mif_rd_nxt_sta = mif_rd_sta;	
    case(mif_rd_sta)
    MIF_RD_IDLE:
        if(nfc_dat_en & nfc_dat_dir)	    
            mif_rd_nxt_sta = MIF_RD_DAT;
    MIF_RD_DAT:
        if(blk_end) begin
          if( nfc_spa_en)
	        mif_rd_nxt_sta = MIF_RD_SPA;
          else if( nfc_ecc_en )
            mif_rd_nxt_sta = MIF_RD_ECC;
	      else
		    mif_rd_nxt_sta = MIF_RD_IDLE;
        end
    MIF_RD_SPA:
        if(blk_end) begin
	      if( nfc_ecc_en )
              mif_rd_nxt_sta = MIF_RD_ECC;
	      else
		      mif_rd_nxt_sta = MIF_RD_IDLE;
        end
    MIF_RD_ECC:
	if(blk_end) begin
	    if( mif_cnt_rst )	    
            mif_rd_nxt_sta = MIF_RD_IDLE;
	    else
		    mif_rd_nxt_sta = MIF_RD_DAT;
	end
    default: mif_rd_nxt_sta = MIF_RD_IDLE;
    endcase
end    

always @ (*)
begin	
    case(mif_rd_sta)
    MIF_RD_DAT : blk_len = nfc_blk_len;
    MIF_RD_SPA : blk_len = {8'h0, nfc_spa_len};
    MIF_RD_ECC :  
	case(nfc_ecc_len)
        2'b00: blk_len = 12'h0;
        2'b01: blk_len = 12'd18;
        2'b10: blk_len = 12'd25;
        default: blk_len = 12'h0;
        endcase
    default: blk_len = 12'h0;
    endcase
end

// Data Selection
always @ (posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0)
        ram_rd_dly <= 1'b0;
    else
        ram_rd_dly <= #1 dat_rd | spa_rd ; 
end

always @ (posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0)
        ecc_rd_dly <= 1'b0;
    else
        ecc_rd_dly <= #1 ecc_rd ; 
end

always @ (*)
begin
    dat8_tmp = nfif_data_in;
    casex({rng_rd,ram_rd_dly,ecc_rd_dly})
    3'b1XX: dat8_tmp = rng_dat ;
    3'b01X: dat8_tmp = ram_nfc_dout;
    4'b001: dat8_tmp = ecc_enc_dat;
    default: dat8_tmp = nfif_data_in;
    endcase
end    

always @ (posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0)
        nfif_data_in <= 16'h0;
    else
        nfif_data_in <= #1 {8'h0, dat8_tmp }; // support 8 bit mode only
end

always @ (posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0)
        nfif_rd_rdy <= 1'b0;
    else 
        nfif_rd_rdy <= rng_rd | ram_rd_dly | ecc_rd_dly;
end	

// MIF DAT ADDR
always @ (posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0)
        mif_dat_addr <= 14'h0;
    else if(sta_rd_idl & nxt_sta_rd_dat)
        mif_dat_addr <= #1 nfc_dat_addr;
    else if(dat_rd)
        mif_dat_addr <= #1 mif_dat_addr + 1'b1;	    
end

// MIF SPA ADDR
always @ (posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0)
        mif_spa_addr <= 14'h0;
    else if(sta_rd_idl & nxt_sta_rd_dat)
        mif_spa_addr <= #1 nfc_spa_addr;
    else if(spa_rd)
        mif_spa_addr <= #1 mif_spa_addr + 1'b1;	    
end

// Last Byte In 195 bit mode



endmodule
