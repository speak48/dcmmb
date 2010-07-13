//
//
module nfc_mif(
    clk            ,
    rst_n          ,
     
    rng_sel        ,
    rng_dat        ,
    mif_rng_rd     ,

    nfc_blk_len    ,
    nfc_spa_len    ,
    nfc_spa_en     ,
    nfc_ecc_opt    ,
    nfc_ecc_en     ,
    nfc_trn_cnt    ,
    nfc_dat_addr   ,
    nfc_spa_addr   ,
    nfc_mode       ,

    nfc_dat_dir    ,
    nfc_dat_inv    ,
    nfc_dat_en     ,
    nfc_dat_end    ,

    nfif_dat_rdy   ,
    mem_if_wr    ,
    mem_if_din   ,

    nfif_data_wr   ,
    nfif_data_out  ,
    nfif_wr_rdy    ,
     
    mif_ecc_rd     ,
    ecc_enc_dat    ,    
    ecc_dec_addr   ,
    ecc_enc_rdy    ,
    ecc_dec_rdy    ,
    mif_ecc_wr     ,
    mif_ecc_dat    ,

    data_status0   ,
    data_status1   ,  
 
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
input   [15       :0]  rng_dat         ;
output                 mif_rng_rd      ;

// SFR interface
input   [9        :0]  nfc_blk_len     ;
input   [3        :0]  nfc_spa_len     ;
input                  nfc_ecc_opt     ;
input                  nfc_ecc_en      ;
input                  nfc_spa_en      ;
input   [3        :0]  nfc_trn_cnt     ;
input   [13       :0]  nfc_dat_addr    ;
input   [13       :0]  nfc_spa_addr    ;
input                  nfc_dat_en      ;
input                  nfc_dat_dir     ;
input                  nfc_dat_inv     ;
input                  nfc_dat_end     ; // Reg/RAM
input   [1        :0]  nfc_mode        ;

// NF_IF Interface
//input                  nfif_dat_done   ;
input                  nfif_dat_rdy    ;
output                 mem_if_wr       ;
output  [DAT_WID-1:0]  mem_if_din      ;
input                  nfif_data_wr    ;
input   [DAT_WID-1:0]  nfif_data_out   ;
output                 nfif_wr_rdy     ;

// ECC interface
output                 mif_ecc_rd      ;
input   [15       :0]  ecc_enc_dat     ;
input   [12       :0]  ecc_dec_addr    ;
input                  ecc_enc_rdy     ;
input                  ecc_dec_rdy     ;
output                 mif_ecc_wr      ;
output  [DAT_WID-1 :0] mif_ecc_dat     ;

// RAM Interface
output  [7        :0]  data_status0    ;
output  [7        :0]  data_status1    ;
output  [12       :0]  nfc_ram_addr    ;
output                 nfc_ram_cen     ;
output  [1        :0]  nfc_ram_wen     ;
output  [15       :0]  nfc_ram_din     ;
input   [15       :0]  ram_nfc_dout    ; 

parameter      MIF_RD_IDLE = 3'b000    ,
               MIF_RD_DAT  = 3'b001    ,
               MIF_RD_SPA  = 3'b010    ,
               MIF_RD_ECC  = 3'b011    ,
               MIF_ECC_ENC = 3'b100    ,
               MIF_BLK_END = 3'b101    ;

reg     [3        :0]  mif_cnt         ;
reg     [9        :0]  blk_cnt         ;
reg     [2        :0]  mif_rd_sta      ;
reg     [DAT_WID-1:0]  mem_if_din    ;
reg     [13       :0]  mif_dat_addr    ;
reg     [13       :0]  mif_spa_addr    ;
reg                    ram_rd_dly      ;
reg                    ecc_rd_dly      ;
reg                    nfc_dat_en_dly  ;
reg                    last_ecc_rdy    ;
reg     [15       :0]  rng_dat_dly     ;
reg                    ecc_rd_en       ;
reg                    mif_rd_en       ;
reg                    last_ecc_rd     ;
reg                    rd_buffer       ;
reg                    rd_dly2         ;
reg                    dat_rd_en       ;
reg                    spa_rd_en       ;
reg                    dat8_sel        ;
reg     [7        :0]  data_status0    ;
reg     [7        :0]  data_status1    ;
reg                    data_status_sel ;
reg                    dat_wr          ;
reg                    dat_wr_en       ;
reg     [15       :0]  mif_data_out    ;

reg     [2        :0]  mif_rd_nxt_sta  ;
reg     [9        :0]  blk_len         ;
reg     [15       :0]  dat_tmp         ;
reg                    mif_mem_rd      ;
//reg     [15       :0]  dat8_tmp        ;

wire                   reg_wr          ;
wire                   mem_if_wr       ;
wire                   mif_cnt_en      ;
wire                   blk_cnt_en      ;
wire                   mif_cnt_rst     ;
wire                   blk_end         ;
wire                   sta_rd_dat      ;
wire                   sta_rd_spa      ;
wire                   sta_rd_ecc      ;
wire                   sta_ecc_enc     ;
wire                   sta_rd_idl      ;
wire                   sta_blk_end     ;
wire                   nxt_sta_rd_sta  ;
wire                   rng_rd          ;
wire                   dat_rd          ;
wire                   ecc_rd          ;
wire                   spa_rd          ;
wire                   nfc_dat_ini     ;
wire                   last_ecc_byte   ;
//wire                   last_ecc_rd     ;

assign nfif_wr_rdy  = 1'b1;
assign mif_rng_rd   = rng_rd & dat_rd_en; // 8/16 switch
assign mif_ecc_rd   = ecc_rd;
assign mem_if_wr    = rd_dly2;
assign nfc_ram_addr = sta_rd_spa ? mif_spa_addr[13:1] : mif_dat_addr[13:1];
assign nfc_ram_cen  = ~( (dat_rd & dat_rd_en) | (spa_rd & spa_rd_en) | dat_wr );
assign nfc_ram_wen[1] = ~(dat_wr & dat_wr_en);
assign nfc_ram_wen[0] = ~(dat_wr & ~dat_wr_en);
assign nfc_ram_din  = mif_data_out;

assign mif_ecc_wr   = nfc_ecc_en & ((( sta_rd_dat | sta_rd_spa | sta_ecc_enc ) & ecc_rd_en) | dat_wr); // last ecc byte 2 cycles later
assign mif_ecc_dat  = nfc_dat_dir ? mem_if_din : mif_data_out;

// FSM Active Signal
assign sta_rd_idl = (mif_rd_sta == MIF_RD_IDLE);
assign sta_rd_dat = (mif_rd_sta == MIF_RD_DAT);
assign sta_rd_spa = (mif_rd_sta == MIF_RD_SPA);
assign sta_rd_ecc = (mif_rd_sta == MIF_RD_ECC);
assign sta_ecc_enc = (mif_rd_sta == MIF_ECC_ENC);
assign sta_blk_end = (mif_rd_sta == MIF_BLK_END);
assign nxt_sta_rd_dat = (mif_rd_nxt_sta == MIF_RD_DAT);

// RNG/DAT/SPA/ECC Read Active signal
assign rng_rd = (sta_rd_dat & rng_sel[2]   &   mif_mem_rd ); 
assign dat_rd = (sta_rd_dat & (!rng_sel[2]) &  mif_mem_rd ); 
assign spa_rd = (sta_rd_spa & (!rng_sel[2]) &  mif_mem_rd ); 
assign ecc_rd = sta_rd_ecc & mif_mem_rd;

// read firt data imediately after en
// read continued data while data have been read by NFC_IF
assign blk_cnt_en = rng_rd || dat_rd || spa_rd || ecc_rd ;
assign mif_cnt_en = sta_blk_end ;
// mif_cnt rst if all data are tranmitted
assign mif_cnt_rst = ( mif_cnt == nfc_trn_cnt - 1'b1 ) & sta_blk_end;

assign blk_end = (blk_cnt == blk_len - 1'b1 ) & blk_cnt_en;

assign nfc_dat_ini = (~nfc_dat_en_dly) & nfc_dat_en;

assign last_ecc_byte = ((sta_rd_dat & (~nfc_spa_en) & nfc_ecc_en) | (sta_rd_spa & nfc_ecc_en)) & blk_end & nfc_ecc_opt;

//assign last_ecc_rd  = nfc_ecc_opt & last_ecc_byte & ram_rd_dly;
always @ (posedge clk or negedge rst_n)
begin : last_ecc_rdy_r
    if(rst_n == 1'b0)
        last_ecc_rd <= 1'b0;
    else if(last_ecc_byte)
        last_ecc_rd <= #1 1'b1;
    else if(mif_ecc_wr)
        last_ecc_rd <= #1 1'b0;
end

always @ (posedge clk or negedge rst_n)
begin : ecc_rdy_d
    if(rst_n == 1'b0)
        ecc_rd_en <= 1'b0;
    else
        ecc_rd_en <= #1 ram_rd_dly;
end
/*
always @ (posedge clk or negedge rst_n)
begin : last_ecc_rdy_d
    if(rst_n == 1'b0)
        last_ecc_rd_dly <= 1'b0;
    else
        last_ecc_rd_dly <= #1 last_ecc_rd;
end
*/
// NFC_DAT_EN Delay
always @ (posedge clk or negedge rst_n)
begin : nfc_dat_en_d
    if(rst_n == 1'b0)
        nfc_dat_en_dly <= 1'b0;
    else
        nfc_dat_en_dly <= #1 nfc_dat_en;
end

// MIF counter 4 bit for max 9K size
always @ (posedge clk or negedge rst_n)
begin : trn_cnt_r
    if(rst_n == 1'b0)
        mif_cnt <= 4'h0;
    else if(mif_cnt_rst)
        mif_cnt <= #1 4'h0;
    else if(mif_cnt_en)
        mif_cnt <= #1 mif_cnt + 1'b1;	    
end

// Block counter 10 bit for max 512 size
always @ (posedge clk or negedge rst_n)
begin : blk_cnt_r 
    if(rst_n == 1'b0)
        blk_cnt <= 10'h0;
    else if(blk_end)
        blk_cnt <= #1 10'h0;
    else if(blk_cnt_en)
        blk_cnt <= #1 blk_cnt + 1'b1;	    
end

/////////////////////////////////////////
// Read FSM
/////////////////////////////////////////
always @ (posedge clk or negedge rst_n)
begin : rd_fsm
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
        if(nfc_dat_ini)// & nfc_dat_dir)	    
            mif_rd_nxt_sta = MIF_RD_DAT;
    MIF_RD_DAT:
        if(blk_end) begin
            if( nfc_spa_en)
	        mif_rd_nxt_sta = MIF_RD_SPA;
            else if( nfc_ecc_en )
                mif_rd_nxt_sta = MIF_ECC_ENC;
            else
                mif_rd_nxt_sta = MIF_BLK_END;
        end
    MIF_RD_SPA:
        if(blk_end) begin
	    if( nfc_ecc_en )
                mif_rd_nxt_sta = MIF_ECC_ENC;
	    else
	        mif_rd_nxt_sta = MIF_BLK_END;
        end
    MIF_ECC_ENC:
        if(ecc_enc_rdy)
            mif_rd_nxt_sta = MIF_RD_ECC;
    MIF_RD_ECC:
	if(blk_end) begin
            mif_rd_nxt_sta = MIF_BLK_END;
        end
    MIF_BLK_END:
        begin
	    if( mif_cnt_rst )	    
                mif_rd_nxt_sta = MIF_RD_IDLE;
	    else
                mif_rd_nxt_sta = MIF_RD_DAT;
	end
    default: mif_rd_nxt_sta = MIF_RD_IDLE;
    endcase
end    

// Block Length Selection For Different Stage
always @ (*)
begin	
    case(mif_rd_sta)
    MIF_RD_DAT : blk_len = nfc_blk_len;
    MIF_RD_SPA : blk_len = {6'h0, nfc_spa_len } + 1'b1;
    MIF_RD_ECC : blk_len =  nfc_ecc_opt ? 'd25 : 'd13 ;
    default:     blk_len = nfc_blk_len;
    endcase
end

// Memeory Read Enable
always @ (posedge clk or negedge rst_n)
begin : mif_rd_en_r
    if(rst_n == 1'b0)
        mif_rd_en <= #1 1'b0;
    else if(nfc_dat_ini)
        mif_rd_en <= #1 1'b1;
    else
        mif_rd_en <= #1 nfif_dat_rdy;
end

always @ (*)
begin
    if(~nfif_dat_rdy)
	 mif_mem_rd = 1'b0;
    else 
	 mif_mem_rd = mif_rd_en | rd_buffer ;
end    

always @ (posedge clk or negedge rst_n)
    if(!rst_n)
        rd_buffer <= #1 1'b0;
    else if(nfif_dat_rdy)
        rd_buffer <= #1 1'b0;
    else if(~nfif_dat_rdy & (ram_rd_dly | ecc_rd_dly) & ~last_ecc_rd)
        rd_buffer <= #1 1'b1;

// Data Selection
// Data Stage
always @ (posedge clk or negedge rst_n)
begin : ram_rd_d
    if(rst_n == 1'b0)
        ram_rd_dly <= 1'b0;
    else
        ram_rd_dly <= #1 dat_rd | spa_rd | rng_rd; 
end

// ECC Stage
always @ (posedge clk or negedge rst_n)
begin : ecc_rd_d
    if(rst_n == 1'b0)
        ecc_rd_dly <= 1'b0;
    else
        ecc_rd_dly <= #1 ecc_rd ; 
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
	rd_dly2 <= 1'b0;
    else if(~nfif_dat_rdy)
        rd_dly2 <= #1 1'b0;
    else if(nfif_dat_rdy & rd_buffer & ~last_ecc_rd)
        rd_dly2 <= #1 1'b1;
    else
	rd_dly2 <= #1 (ram_rd_dly & ~last_ecc_rd) | ecc_rd_dly;
end

always @ (posedge clk or negedge rst_n)
begin : nfif_din_r
    if(rst_n == 1'b0)
        mem_if_din <= 16'h0;
    else if(ecc_rd_dly)
        mem_if_din <= ecc_enc_dat;
    else if(ram_rd_dly)
        mem_if_din <= #1 (mem_if_wr ^ dat8_sel) ? { 8'h0, dat_tmp[15:8]} : {8'h0, dat_tmp[7:0]} ; // support 8 bit mode only
end

// Random / RAM / ECC data
always @ (*)
begin
    dat_tmp = mem_if_din;
    casex({rng_sel[2],nfc_dat_inv})
    2'b10: dat_tmp = rng_dat_dly ;
    2'b11: dat_tmp = ~rng_dat_dly;
    2'b00: dat_tmp = ram_nfc_dout;
    2'b01: dat_tmp = ~ram_nfc_dout;
    default: dat_tmp = mem_if_din;
    endcase
end    

always @ (posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0)
         dat8_sel <= 1'b0;
    else if(nfc_dat_ini)
         dat8_sel <= #1 1'b0;
    else if(mem_if_wr)
         dat8_sel <= #1 ~dat8_sel;
end

// RNG data delay 1 step for synchrnous SRAM timing
always @ (posedge clk or negedge rst_n)
begin : rng_dat_d
    if(!rst_n)
        rng_dat_dly <= 8'h0;
    else if(mif_rng_rd)
        rng_dat_dly <= #1 rng_dat[15:0];
end

/*
always @ (posedge clk or negedge rst_n)
begin : nfif_rdy_r
    if(rst_n == 1'b0)
        mem_if_wr <= 1'b0;
    else if( 
        mem_if_wr <= #1 (( ram_rd_dly & ~last_ecc_rd) | ecc_rd_dly ) & nfif_dat_rdy;
//        mem_if_wr <= #1  (ram_rd_dly & ~last_ecc_rd) | ecc_rd_dly;
end	
*/

// MIF DAT ADDR
always @ (posedge clk or negedge rst_n)
begin : dat_addr_r
    if(rst_n == 1'b0)
        mif_dat_addr <= 14'h0;
    else if(nfc_dat_ini)
        mif_dat_addr <= #1 nfc_dat_addr;
    else if((dat_rd & dat_rd_en)|(dat_wr & dat_wr_en))
        mif_dat_addr <= #1 mif_dat_addr + 2'b10;	   
    else 
        mif_dat_addr <= #1 mif_dat_addr; 
end

always @ (posedge clk or negedge rst_n)
begin : dat_rd_en_r
    if(rst_n == 1'b0)
        dat_rd_en <= 1'b0;
    else if(nfc_dat_ini)
        dat_rd_en <= #1 1'b1;
    else if((dat_rd | rng_rd) & (nfc_mode == 2'b00))
        dat_rd_en <= #1 ~dat_rd_en;
end

// MIF SPA ADDR
always @ (posedge clk or negedge rst_n)
begin : spa_addr_r
    if(rst_n == 1'b0)
        mif_spa_addr <= 14'h0;
    else if(nfc_dat_ini)
        mif_spa_addr <= #1 nfc_spa_addr;
    else if(spa_rd & spa_rd_en)
        mif_spa_addr <= #1 mif_spa_addr + 2'b10;	    
    else
        mif_spa_addr <= #1 mif_spa_addr;
end

always @ (posedge clk or negedge rst_n)
begin : spa_rd_en_r
    if(rst_n == 1'b0)
        spa_rd_en <= 1'b0;
    else if(nfc_dat_ini)
        spa_rd_en <= 1'b1;
    else if(spa_rd & (nfc_mode == 2'b00))
        spa_rd_en <= #1 ~spa_rd_en;
end

assign reg_wr = nfif_data_wr & nfc_dat_end;

always @ (posedge clk or negedge rst_n)
begin : data_status0_r
    if(rst_n == 1'b0)
        data_status0 <= 8'h0;
    else if(nfc_dat_end & nfc_dat_ini)
        data_status0 <= #1 8'h0;
    else if(reg_wr & ~data_status_sel)
        data_status0 <= #1 nfif_data_out;
end

always @ (posedge clk or negedge rst_n)
begin : data_status1_r
    if(rst_n == 1'b0)
        data_status1 <= 8'h0;
    else if(nfc_dat_end & nfc_dat_ini)
        data_status1 <= #1 8'h0;
    else if(reg_wr & data_status_sel)
        data_status1 <= #1 nfif_data_out;
end

always @ (posedge clk or negedge rst_n)
begin : data_status_sel_r
    if(rst_n == 1'b0)
        data_status_sel <= 1'b0;
    else if(nfc_dat_ini)
        data_status_sel <= #1 1'b0;
    else if(reg_wr)
        data_status_sel <= #1 1'b1;
end

always @ (posedge clk or negedge rst_n)
begin: data_wr_r
    if(rst_n == 1'b0)
         dat_wr <= 1'b0;
    else 
         dat_wr <= #1  nfif_data_wr & ~nfc_dat_end;
end

always @ (posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0)
        dat_wr_en <= 1'b0;
    else if(nfc_dat_ini)
        dat_wr_en <= #1 ~(nfc_mode == 2'b00) ;
    else if((dat_wr) & (nfc_mode == 2'b00))
        dat_wr_en <= #1 ~dat_wr_en;
end

always @ (posedge clk or negedge rst_n)
begin: data_out_r
    if(rst_n == 1'b0)
        mif_data_out <= 16'h0;
    else if(nfif_data_wr & ~nfc_dat_end)
        begin 
        if(nfc_mode == 2'b00)
            mif_data_out <= #1 {nfif_data_out[7:0],nfif_data_out[7:0]};
        else
            mif_data_out <= #1 nfif_data_out;
        end
end

endmodule
