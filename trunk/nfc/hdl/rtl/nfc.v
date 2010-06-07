//
// Module HHIC3901U711_lib.NF_CTRL.struct
//
// Created:
//          by - user.UNKNOWN (USER-39D27DD636)
//          at - 16:23:22 2010-01-29
//
// Generated by Mentor Graphics' HDL Designer(TM) 2005.2 (Build 37)
//

`resetall
`timescale 1 ns/ 10ps
module nfc( 
   nfc_clk, 
   ecc_clk, 
   rstb_nfc, 
   mif_nfc_reg_addr, 
   mif_nfc_reg_rd, 
   mif_nfc_reg_wr, 
   mif_nfc_reg_din, 
   nfc_mif_reg_dout, 
   nf_ale_o, 
   nf_ceb_o, 
   nf_cle_o, 
   nf_dat_o, 
   nf_dat_i,
   nf_rnb_i, 
   nf_io_ctrl, 
   nf_reb_o, 
   nf_web_o, 
   nf_wpb_o, 
   nf_sram_addr, 
   nf_sram_cen, 
   nf_sram_wen, 
   nf_sram_wr_dat, 
   nf_sram_rd_dat, 
);

`include "nfc_parameter.v"
// Internal Declarations

input         nfc_clk;
input         ecc_clk;
input  [15:0] nf_dat_i;
input         nf_rnb_i;
input         mif_nfc_reg_rd;
input  [8:0]  mif_nfc_reg_addr;
input         mif_nfc_reg_wr;
input  [7:0]  mif_nfc_reg_din;
input  [15:0] nf_sram_rd_dat;
input         rstb_nfc;
output        nf_ale_o;
output [3:0]  nf_ceb_o;
output        nf_cle_o;
output [15:0] nf_dat_o;
output        nf_io_ctrl;
output        nf_reb_o;
output [7:0]  nfc_mif_reg_dout;
output [15:0] nf_sram_addr;
output        nf_sram_cen;
output [1:0]  nf_sram_wen;
output [15:0] nf_sram_wr_dat;
output        nf_web_o;
output        nf_wpb_o;

wire          clk   ;
wire          clk_2x;
wire          rst_n ;

assign clk    = nfc_clk;
assign clk_2x = ecc_clk;
assign rst_n  = rstb_nfc;

wire   [2:0]  nf_rng_sel;
wire   [7:0]  nf_cmd;
wire   [1:0]  nf_mode;
wire   [2:0]  nf_total_cycle;
wire   [3:0]  nf_high_cycle;
wire   [15:0] nf_data_addr;
wire   [15:0] nf_spare_addr;
wire   [2:0]  nf_column_addr_cnt;
wire   [2:0]  nf_row_addr_cnt;
wire   [31:0] nf_column_addr;
wire   [31:0] nf_row_addr;
wire   [31:0] nf_rand_seed;
wire   [7:0]  rng_data;
wire   [15:0] enc_data;
wire   [12:0] dec_addr;
wire   [11:0] nf_blk_len;
wire   [4:0]  nf_spare_len;
wire          nf_spare_en;
wire          nf_ecc_en;
wire          nf_ecc_len;
wire   [13:0] nf_trn_cnt;
wire   [15:0] memif_nfif_data;
wire   [15:0] nfif_memif_data;
wire          nf_edo_en;
wire          nf_cmd_valid;
wire          nf_dat_end;
wire          nf_dat_inv;
//wire   [7:0]  ecc_data;
//wire   [12:0] ecc_addr;

wire   [SFR_WID-1 :0]  nfc_if_cmd      ;
wire                   nfc_addr_en     ;
wire   [31        :0]  nfc_col_addr    ;
wire   [31        :0]  nfc_row_addr    ;
wire   [5         :0]  nfc_addr_cnt    ;
wire                   nfc_dat_en      ;
wire   [13        :0]  nfc_dat_cnt     ;
wire   [SFR_WID-1 :0]  nfc_tconf       ;
wire   [1         :0]  nfc_mode        ;
wire   [DAT_WID-1 :0]  nfif_data_in    ; 
wire   [DAT_WID-1 :0]  nfif_data_out   ; 

wire   [DAT_WID-1 :0]  nf_din          ; 
wire   [DAT_WID-1 :0]  nf_dout         ;  
wire                   nf_dir          ; 
wire                   nf_cle          ; 
wire                   nf_ale          ; 
wire                   nf_web          ; 
wire                   nf_reb          ; 

wire   [ECC_DWID-1:0]  ecc_enc_dat     ;
wire   [ECC_AWID-1:0]  ecc_dec_addr    ;
wire   [DAT_WID -1:0]  mem_enc_dat     ;   
wire   [ECC_AWID-1:0]  mem_dec_addr    ;   
 
wire   [12        :0]  nfc_ram_addr    ;  
wire                   nfc_ram_cen     ;  
wire   [1         :0]  nfc_ram_wen     ;  
wire   [15        :0]  nfc_ram_din     ;  
wire   [15        :0]  ram_nfc_dout    ;  

wire   [11        :0]  nfc_blk_len     ;
wire   [3         :0]  nfc_spa_len     ;
wire   [1         :0]  nfc_ecc_len     ; 
wire   [13        :0]  nfc_trn_cnt     ; 
wire   [13        :0]  nfc_dat_addr    ; 
wire   [13        :0]  nfc_spa_addr    ; 

wire   [2         :0]  rng_sel         ; 
wire   [7         :0]  rng_dat         ; 
wire   [31        :0]  nfc_rand_seed   ; 
wire                   nfc_cmd_en      ;
wire                   nfc_dat_end     ;
wire                   nfc_dat_inv     ;
 
assign rng_sel    = nf_rng_sel;
assign nfc_if_cmd = nf_cmd;
assign nfc_mode   = nf_mode;
assign nfc_tconf  = { nf_edo_en, nf_high_cycle ,nf_total_cycle};
assign nfc_dat_addr = nf_data_addr;      
assign nfc_spa_addr = nf_spare_addr;     
assign nfc_addr_cnt = {nf_row_addr_cnt, nf_column_addr_cnt};
assign nfc_col_addr = nf_column_addr;    
assign nfc_row_addr = nf_row_addr;       
assign nfc_rand_seed = nf_rand_seed;      
assign nfc_dat_inv = nf_dat_inv;
assign nfc_dat_end = nf_dat_end;
assign nfc_cmd_en  = nf_cmd_valid;
assign nfc_dat_dir = nf_dir;



 
nfc_sfr_if  u_nfc_sfr_if(
    .clk                 (nfc_clk),
    .rst_n               (rstb_nfc),

    .mif_nfc_reg_wr      (mif_nfc_reg_wr),
    .mif_nfc_reg_rd      (mif_nfc_reg_rd),
    .mif_nfc_reg_addr    (mif_nfc_reg_addr),
    .mif_nfc_reg_din     (mif_nfc_reg_din),
    .nfc_mif_reg_dout    (nfc_mif_reg_dout),

    .rnb_i               (nf_rnb_i),

    .nf_cmd              (nf_cmd),
    .nf_cmd_valid        (nf_cmd_valid),
    .nf_rng_sel          (nf_rng_sel),
    .nf_dat_end          (nf_dat_end),
    .nf_dir              (nf_dat_dir),
    .nf_dat_inv          (nf_dat_inv),
    .nf_addr_en          (nf_addr_en),
    .nf_dat_en           (nf_dat_en),

    .nf_mode             (nf_mode),
    .nf_ceb              (nf_ceb_o),
    .nf_ecc_len          (nf_ecc_len),
    .nf_ecc_en           (nf_ecc_en),
    .nf_spare_len        (nf_spare_len),
    .nf_spare_en         (nf_spare_en),

    .nf_edo_en           (nf_edo_en),
    .nf_total_cycle      (nf_total_cycle),
    .nf_high_cycle       (nf_high_cycle),
    .nf_data_addr        (nf_data_addr),
    .nf_spare_addr       (nf_spare_addr),

    .nf_column_addr_cnt  (nf_column_addr_cnt),
    .nf_row_addr_cnt     (nf_row_addr_cnt),
    .nf_column_addr      (nf_column_addr),
    .nf_row_addr         (nf_row_addr),

    .nf_rand_seed        (nf_rand_seed)
);

nfc_rng_dat u_rng_dat(
    .rst_n               (rstb_nfc     ),
    .clk                 (nfc_clk      ),
    .en                  (rng_sel[2]   ),
    .rd                  (rng_rd       ),
    .seed                (nfc_rand_seed ),
    .mode                (rng_sel[1:0] ),
    .rng_dat             (rng_dat      )
);

nfc_mif u_nfc_mif(
    .clk            (clk),
    .rst_n          (rst_n),
                  
    .rng_sel        (rng_sel),
    .rng_dat        (rng_dat),
    .rng_rd         (rng_rd ),
               
    .nfc_blk_len    (nfc_blk_len),
    .nfc_spa_len    (nfc_spa_len),
    .nfc_ecc_len    (nfc_ecc_len),
    .nfc_trn_cnt    (nfc_trn_cnt),
    .nfc_dat_addr   (nfc_dat_addr),
    .nfc_spa_addr   (nfc_spa_addr),
                 
    .nfc_dat_dir    (nfc_dat_dir),
    .nfc_dat_en     (nfc_dat_en),
    .nfc_dat_end    (nfc_dat_end),
                  
    .nfif_data_rd   (nfif_data_rd),
    .nfif_rd_rdy    (nfif_rd_rdy),
    .nfif_data_in   (nfif_data_in),
                  
    .nfif_data_wr   (nfif_data_wr),
    .nfif_data_out  (nfif_data_out),
    .nfif_wr_rdy    (nfif_wr_rdy),
                  
    .mif_ecc_rd     (mif_ecc_rd ),
    .ecc_enc_dat    (ecc_enc_dat),    
    .ecc_dec_addr   (ecc_dec_addr),
    .ecc_enc_rdy    (ecc_enc_rdy),
    .ecc_dec_rdy    (ecc_dec_rdy),
                  
    .nfc_ram_addr   (nfc_ram_addr),
    .nfc_ram_cen    (nfc_ram_cen),
    .nfc_ram_wen    (nfc_ram_wen),
    .nfc_ram_din    (nfc_ram_din),
    .ram_nfc_dout   (ram_nfc_dout) 
);    
                        
nfc_if u_nfc_if(
    .clk            (clk),
    .rst_n          (rst_n),
    .nf_din         (nf_din),
    .nf_dout        (nf_dout),
    .nf_dir         (nf_dir),
    .nf_cle         (nf_cle),
    .nf_ale         (nf_ale),
    .nf_web         (nf_web),
    .nf_reb         (nf_reb),
    
    .nfc_dat_inv    (nfc_dat_inv),
    .nfc_dat_dir    (nfc_dat_dir),
    .nfc_cmd_en     (nfc_cmd_en),
    .nfc_if_cmd     (nfc_if_cmd),
    .nfc_addr_en    (nfc_addr_en),
    .nfc_col_addr   (nfc_col_addr),
    .nfc_row_addr   (nfc_row_addr),
    .nfc_addr_cnt   (nfc_addr_cnt),
    .nfc_dat_en     (nfc_dat_en),
    .nfc_dat_cnt    (nfc_dat_cnt),
    .nfc_tconf      (nfc_tconf),
    .nfc_mode       (nfc_mode),
    .nfif_cmd_done  (nfif_cmd_done),
    .nfif_addr_done (nfif_addr_done),
    .nfif_dat_done  (nfif_dat_done),   
    .nfif_data_rd   (nfif_data_rd),
    .nfif_rd_rdy    (nfif_rd_rdy),
    .nfif_data_in   (nfif_data_in),
    .nfif_data_wr   (nfif_data_wr),
    .nfif_data_out  (nfif_data_out),
    .nfif_wr_rdy    (nfif_wr_rdy)
);

nfc_ecc_cor u_nfc_ecc_cor(
    .clk          (clk),
    .clk_2x       (clk_2x),
    .rst_n        (rst_n),
    
    .nfc_dat_dir  (nfc_dat_dir),
    .nfc_ecc_opt  (nfc_ecc_opt),
    .ecc_fifo_wr  (ecc_wr),
    .ecc_enc_dat  (ecc_enc_dat),
    .ecc_dec_addr (ecc_dec_addr),
    .ecc_done     (ecc_done),

    .mem_if_rd    (mif_ecc_rd),
    .mem_enc_dat  (mem_enc_dat),    
    .mem_dec_addr (mem_dec_addr),
    .ecc_enc_rdy  (ecc_enc_rdy),
    .ecc_dec_rdy  (ecc_dec_rdy)
);

/*                                             
bchecc  u_nf_ecc(
    .rst_n        (rstb_nfc),
    .clk          (ecc_clk),
    .sfr_en_i     ((mif_nfc_reg_wr || mif_nfc_reg_rd ) && mif_nfc_reg_addr[8:4] == 5'h0),
    .sfr_rd_i     (mif_nfc_reg_rd),
    .sfr_wr_i     (mif_nfc_reg_wr),
    .sfr_size_i   (2'b00),
    .sfr_addr_i   (mif_nfc_reg_addr[3:0]),
    .sfr_wdata_i  ({24'h0,mif_nfc_reg_din}),
    .ecc_wr_i     (memif_ecc_wr),
    .ecc_data_i   (memif_ecc_data),
    .sfr_rdata_o  (),
    .ecc_wr_o     (ecc_wr),
    .enc_data_o   (ecc_enc_dat ),
    .dec_addr_o   (ecc_dec_addr),
    .ecc_done_o   (ecc_done)
);
*/

endmodule
