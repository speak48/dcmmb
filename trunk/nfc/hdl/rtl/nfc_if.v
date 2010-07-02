//
//
module nfc_if(
    clk            ,
    clk_2x         ,
    rst_n          ,

    nf_din         ,
    nf_dout        ,
    nf_dir         ,
    nf_cle         ,
    nf_ale         ,
    nf_web         ,
    nf_reb         ,

    nfc_dat_inv    ,
    nfc_dat_dir    ,
    nfc_cmd_en     ,
    nfc_if_cmd     ,
    nfc_addr_en    ,
    nfc_col_addr   ,
    nfc_row_addr   ,
    nfc_addr_cnt   ,
    nfc_dat_en     ,
    nfc_dat_cnt    ,
    nfc_tconf      ,
    nfc_mode       ,

    nfif_cmd_done  ,
    nfif_addr_done ,
    nfif_dat_done  ,
   
    nfif_dat_rdy   ,
    mem_if_wr      ,
    mem_if_din     ,

    nfif_data_wr   ,
    nfif_data_out  ,
    nfif_wr_rdy   
);

`include "nfc_parameter.v"

input                  clk             ;
input                  clk_2x          ;
input                  rst_n           ;

// Interface connect with Nandflash
input   [DAT_WID-1:0]  nf_din          ;
output  [DAT_WID-1:0]  nf_dout         ;
output                 nf_dir          ;
output                 nf_cle          ;
output                 nf_ale          ;
output                 nf_web          ;
output                 nf_reb          ;
// nf_ce, nf_rb, nf_wpb exclude here

// Control signal from Regiseter
input                  nfc_dat_inv     ;
input                  nfc_dat_dir     ; // 1: Write 0: Read
input                  nfc_cmd_en      ;
input   [SFR_WID-1:0]  nfc_if_cmd      ;
input                  nfc_addr_en     ;
input   [31       :0]  nfc_col_addr    ;
input   [31       :0]  nfc_row_addr    ;
input   [5        :0]  nfc_addr_cnt    ;
input                  nfc_dat_en      ;
input   [13       :0]  nfc_dat_cnt     ;
input   [SFR_WID-1:0]  nfc_tconf       ;
input   [1        :0]  nfc_mode        ;

// Status signal to Register
output                 nfif_cmd_done   ;
output                 nfif_addr_done  ;
output                 nfif_dat_done   ;

// Interface with NFC memory interface
// Read 
output                 nfif_dat_rdy    ;
input                  mem_if_wr       ;
input   [DAT_WID-1:0]  mem_if_din      ;
// Write
output                 nfif_data_wr    ;
output  [DAT_WID-1:0]  nfif_data_out   ;
input                  nfif_wr_rdy     ;

parameter      NFIF_IDLE     = 4'b0000 ,
               NFIF_CMD_PRE  = 4'b0001 ,
               NFIF_CMD_WR   = 4'b0010 ,
               NFIF_ADDR_PRE = 4'b0011 ,
               NFIF_ADDR_WR  = 4'b0100 ,
               NFIF_DAT_LD   = 4'b0101 ,
               NFIF_DAT_WR   = 4'b0110 ,
               NFIF_DAT_HD   = 4'b0111 ,
               NFIF_DAT_RD   = 4'b1000 ,
               NFIF_END      = 4'b1001 ;
//             NFIF_DAT_EDO  = 4'b1010 ;

// Internal register definition
reg                     nf_cle         ;
reg                     nf_ale         ;
reg                     nf_reb_pos     ;
reg                     nf_web_pos     ;
reg                     nf_reb_neg     ;
reg                     nf_web_neg     ;
reg    [DAT_WID-1  :0]  nf_dout        ;
reg    [DAT_WID-1  :0]  nfif_data_out  ;
//reg                     nfif_data_wr   ;
reg                     nfif_dat_rdy   ;

reg    [3          :0]  nfif_sta       ;
reg    [2          :0]  addr_cnt       ;
reg    [13         :0]  data_cnt       ;
reg    [3          :0]  t_cnt          ;
reg    [2          :0]  addr_cnt_dly   ;
reg                     addr_cnt_incr  ;
reg                     mem_wr_en      ;
reg                     edo_rd_dly     ;
reg                     edo_rd_dly2    ;

// Internal Varible defintion
reg    [3          :0]  nfif_nxt_sta   ;
reg                     nf_cle_nxt     ;
reg                     nf_ale_nxt     ;
reg                     nf_web_nxt     ;
reg                     nf_reb_nxt     ;
reg   [7           :0]  nfc_addr_dat   ;
reg   [DAT_WID-1   :0]  nf_dout_nxt    ;

wire                    nfif_data_wr   ;
wire                    load_cmd       ;
wire                    load_addr      ;
wire                    load_dat       ;
//wire                    addr_cnt_incr  ;
wire                    t_cnt_en       ;
wire                    t_cnt_rst      ;
wire                    nxt_sta_end    ;
wire                    sta_idle       ;
wire                    sta_cmd_wr     ;
wire                    sta_addr_pre   ;
wire                    sta_addr_wr    ;
wire                    sta_dat_wr     ;
wire                    sta_dat_rd     ;
//wire  [2           :0]  nfc_addr_num   ;
wire  [2           :0]  total_cycle    ;
wire  [3           :0]  high_cycle      ;
wire                    half_cycle     ;
wire  [2           :0]  load_dat_cnt   ;
wire                    data_wr_op     ;
wire                    data_rd_op     ;
wire                    edo_mode       ;
wire                    edo_rd         ;
//wire  [2           :0]  col_addr_num   ;
//wire  [2           :0]  row_addr_num   ;
wire                    addr_done      ;
wire                    dat_done       ;
wire                    dat_fetch_done ;
wire                    dat_rd_done    ;

assign nf_web = nf_web_pos;
assign nf_reb = nf_reb_pos;
assign nf_dir = sta_cmd_wr | sta_addr_wr | data_wr_op;
//assign nf_dir = data_rd_op ? 1'b0 : 1'b1; 
assign nfif_data_wr = edo_rd_dly | edo_rd_dly2;

//assign col_addr_num = nfc_addr_cnt[2:0];
//assign row_addr_num = nfc_addr_cnt[5:3];
assign total_cycle  = nfc_tconf[6:4];
assign high_cycle   = nfc_tconf[3:0]; // nfc_tconf max 1110
assign half_cycle   = nfc_tconf[0]  ;
assign edo_mode     = nfc_tconf[7]  ;

// NFC CMD/ADDR/DATA operation flag 
assign nxt_sta_end  =  (nfif_nxt_sta == NFIF_END );
assign sta_idle     =  (nfif_sta == NFIF_IDLE    );
assign sta_cmd_wr   =  (nfif_sta == NFIF_CMD_WR  );
assign sta_addr_pre =  (nfif_sta == NFIF_ADDR_PRE);
assign sta_addr_wr  =  (nfif_sta == NFIF_ADDR_WR );
assign sta_dat_wr   =  (nfif_sta == NFIF_DAT_WR  );
assign sta_dat_rd   =  (nfif_sta == NFIF_DAT_RD  );
assign sta_end      =  (nfif_sta == NFIF_END     );
assign data_wr_op   =  (nfif_sta == NFIF_DAT_LD ) | sta_dat_wr;
assign data_rd_op   =  (nfif_sta == NFIF_DAT_HD ) | sta_dat_rd;

//assign sta_dat_ld   =  (nfif_sta == NFIF_DAT_LD  );
assign addr_done    =  (addr_cnt_dly == nfc_addr_cnt - 1'b1);
assign dat_done     =  (data_cnt == nfc_dat_cnt - 1'b1 );
assign dat_fetch_done = (nfc_dat_cnt > 14'h2 ) ? (data_cnt > (nfc_dat_cnt - 14'h2)) : 1'b1;

assign dat_rd_done  =  (total_cycle == 3'h0) ? (data_cnt == (nfc_dat_cnt - 1'b1)) : 
	               ( edo_mode ? ( data_cnt == (nfc_dat_cnt - 1'b1)) :
		       ( data_cnt == nfc_dat_cnt )) & ( t_cnt[3:1] == total_cycle) ;

assign nfif_cmd_done  = sta_cmd_wr  & ( t_cnt[3:1] == total_cycle);
assign nfif_addr_done = sta_addr_wr & ( t_cnt[3:1] == total_cycle) & addr_done;
//assign nfif_dat_done  = edo_mode ?  nfif_edo_done : (((sta_dat_wr & dat_done ) | ( sta_dat_rd & dat_done)) &  ( t_cnt[3:1] == total_cycle) )  ;
assign nfif_dat_done  = ((sta_dat_wr & dat_done ) | ( sta_dat_rd & dat_done)) &  ( t_cnt[3:1] == total_cycle) ;

assign load_cmd  = (nfif_sta == NFIF_CMD_PRE );
assign load_addr = sta_addr_pre | (sta_addr_wr & t_cnt_rst);
// 1st Load, 2~N start at total cycle - catch data time, for example 1 cycle 
assign load_dat_cnt = (total_cycle > PRE_CYCLE) ? ( total_cycle - PRE_CYCLE ) : 3'h0 ;

//assign load_dat  = (sta_idle & (nfif_nxt_sta == NFIF_DAT_LD )) | ( sta_dat_wr & (t_cnt[3:1] == load_dat_cnt) & ( data_cnt != nfc_dat_cnt )); // high 3 bit
assign load_dat =  ( sta_dat_wr & (t_cnt[3:1] == load_dat_cnt) & ( data_cnt != nfc_dat_cnt ));

//assign addr_cnt_incr = load_addr & ( addr_cnt != ( row_addr_num + 2'b11 )) ;

assign t_cnt_rst = ( t_cnt == {total_cycle, 1'b1});
assign t_cnt_en  = ( sta_cmd_wr | sta_addr_wr | sta_dat_wr | sta_dat_rd );

assign edo_rd = edo_mode ? t_cnt_rst : (!nf_reb_pos & nf_reb_nxt);

// load new address then couter add 1, last load ignore
always @ (posedge clk_2x or negedge rst_n)
begin: addr_incr_r
    if(rst_n == 1'b0)
        addr_cnt_incr <= 1'b0;
    else 
        addr_cnt_incr <= load_addr & ~addr_done;
end	

// NFC_IF_FSM
always @ (posedge clk_2x or negedge rst_n)
begin: nfif_fsm
    if(rst_n == 1'b0)
        nfif_sta <= NFIF_IDLE;
    else 
        nfif_sta <= #1 nfif_nxt_sta ;
end

always @ (*)
begin
    nfif_nxt_sta = nfif_sta ;
    case(nfif_sta)
    NFIF_IDLE:
    begin    
        casex({nfc_cmd_en,nfc_addr_en,nfc_dat_en,nfc_dat_dir})
        4'b1XXX: nfif_nxt_sta = NFIF_CMD_PRE    ; 	
        4'b01XX: nfif_nxt_sta = NFIF_ADDR_PRE   ;
        4'b0011: nfif_nxt_sta = NFIF_DAT_LD     ;
        4'b0010: nfif_nxt_sta = NFIF_DAT_HD     ;
        default: nfif_nxt_sta = NFIF_IDLE       ;
        endcase
    end
    NFIF_CMD_PRE:  
        nfif_nxt_sta = NFIF_CMD_WR;
    NFIF_CMD_WR:
        if(t_cnt_rst)
            nfif_nxt_sta = NFIF_END;
    NFIF_ADDR_PRE:  
           nfif_nxt_sta = NFIF_ADDR_WR;
    NFIF_ADDR_WR:
        if(t_cnt_rst & addr_done)
            nfif_nxt_sta = NFIF_END;
    NFIF_DAT_LD:
        if(mem_wr_en)
            nfif_nxt_sta = NFIF_DAT_WR;
    NFIF_DAT_WR:
        if(t_cnt_rst) 
        begin	
            if(dat_done)
                nfif_nxt_sta = NFIF_END;
            else if(!mem_wr_en )
                nfif_nxt_sta = NFIF_DAT_LD;
        end
    NFIF_DAT_HD:	
        if(nfif_wr_rdy)
	begin 
                nfif_nxt_sta = NFIF_DAT_RD;	
        end
    NFIF_DAT_RD:
        if(t_cnt_rst)
        begin
            if(dat_done)
                nfif_nxt_sta = NFIF_END;
            else if(!nfif_wr_rdy)
                nfif_nxt_sta = NFIF_DAT_HD;
        end
    NFIF_END:
        nfif_nxt_sta = NFIF_IDLE;	    
    default: 
        nfif_nxt_sta = NFIF_IDLE;
    endcase
end    

////////////////////////////////////////////
// Nandflash Interface Control Signal
////////////////////////////////////////////
// CLE, ALE
always @ (posedge clk_2x or negedge rst_n)
begin : cle_ale_r
    if(rst_n == 1'b0)
    begin
        nf_cle  <=  1'b0;
        nf_ale  <=  1'b0;
    end
    else
    begin
        nf_cle  <= #1 nf_cle_nxt ;
        nf_ale  <= #1 nf_ale_nxt ;
    end
end    

// WEB, REB
always @ (posedge clk_2x or negedge rst_n)
begin : web_reb_r
    if(rst_n == 1'b0)	
    begin
        nf_web_pos <= 1'b1;
        nf_reb_pos <= 1'b1;
    end
    else
    begin
        nf_web_pos <= #1 nf_web_nxt;
        nf_reb_pos <= #1 nf_reb_nxt;
    end
end    

// ALE, CLE
always @ (*)
begin
    nf_cle_nxt      = nf_cle      ;   
    nf_ale_nxt      = nf_ale      ;
    case(nfif_nxt_sta)	
    NFIF_END:
        begin
            nf_cle_nxt = 1'b0;
            nf_ale_nxt = 1'b0;
        end	
    NFIF_CMD_PRE:
        begin
            nf_cle_nxt = 1'b1;
        end
    NFIF_ADDR_PRE:
        begin
            nf_ale_nxt = 1'b1;
        end
    default:;
    endcase
end

// Web
always @ (*)
begin
    nf_web_nxt = nf_web_pos  ;
    case(nfif_nxt_sta)
    NFIF_END:
         nf_web_nxt = 1'b1;
    NFIF_CMD_WR, NFIF_ADDR_WR,NFIF_DAT_WR:
        begin
        if(t_cnt_rst) 
            nf_web_nxt = 1'b0;
        else if(t_cnt_en & (t_cnt >= high_cycle) )
            nf_web_nxt = 1'b1;
        else
	    nf_web_nxt = 1'b0;
        end
    default:;
    endcase
end

// Reb
always @ (*)
begin
    nf_reb_nxt = nf_reb_pos  ;
    case(nfif_nxt_sta)
    NFIF_END:
         nf_reb_nxt = 1'b1;
    NFIF_DAT_RD:
        begin
        if(t_cnt_rst) 
            nf_reb_nxt = 1'b0;
        else if(t_cnt_en & (t_cnt >= high_cycle) )
            nf_reb_nxt = 1'b1;
        else
            nf_reb_nxt = 1'b0;
        end
    default:;
    endcase
end

always @ (posedge clk_2x or negedge rst_n)
begin : addr_cnt_r	
    if(rst_n == 1'b0)
        addr_cnt <= 3'h0;
    else if(addr_cnt_incr)
        addr_cnt <= #1 addr_cnt + 1'b1;
/*	    
    else if(sta_addr_pre)
        addr_cnt <= #1 (col_addr_num == 3'b000) ? 3'b100 : 3'b000 ;
    else if(addr_cnt_incr) 
    begin
        if(addr_cnt == (col_addr_num - 1'b1))
            addr_cnt <= #1 3'b100;
    else    
        addr_cnt <= #1 addr_cnt + 1'b1;
    end
*/    
    else if(!sta_addr_wr)
        addr_cnt <= #1 3'h0;	   
end

// Address delay one cycle for end detection
always @ (posedge clk_2x or negedge rst_n)
begin
    if(rst_n == 1'b0)
        addr_cnt_dly <= 3'b000;
//    else if(sta_addr_pre)
//        addr_cnt_dly <= #1 (col_addr_num == 3'b000) ? 3'b100 : 3'b000 ;	
    else if(load_addr)
        addr_cnt_dly <= #1 addr_cnt;
    else if(!sta_addr_wr)
        addr_cnt_dly <= #1 3'h0;	
end

// Data counter
always @ (posedge clk_2x or negedge rst_n)
begin : data_cnt_r	
    if(rst_n == 1'b0)
        data_cnt <= 3'h0;
//    else if(mem_wr_en  | nfif_data_wr)
//        data_cnt <= #1 data_cnt + 1'b1;
    else if(data_wr_op | data_rd_op )
        begin
            if(t_cnt_rst)
                data_cnt <= #1 data_cnt + 1'b1;
            else
                data_cnt <= #1 data_cnt;
        end
    else
        data_cnt <= #1 3'h0;	   
end

always @ (posedge clk_2x or negedge rst_n)
begin : edo_rd_d
    if(rst_n == 1'b0)
        edo_rd_dly <= 1'b0;
    else if(data_rd_op)
        edo_rd_dly <= #1 edo_rd ;
    else
        edo_rd_dly <= #1 1'b0;
end

always @ (posedge clk_2x or negedge rst_n)
begin : edo_rd_d2
    if(rst_n == 1'b0)
        edo_rd_dly2 <= 1'b0;
    else 
        edo_rd_dly2 <= #1 edo_rd_dly;
end


always @ (posedge clk_2x or negedge rst_n)
begin : nfif_d_out_r
    if(rst_n == 1'b0)
        nfif_data_out <= {{DAT_WID}{1'b0}};
    else if(data_rd_op & edo_rd)
        nfif_data_out <= #1 nf_din;
end

always @ (posedge clk_2x or negedge rst_n)
begin : timing_cnt_r
    if(rst_n == 1'b0)
        t_cnt <= 4'b0;
    else if(t_cnt_rst)
        t_cnt <= #1 4'b0;
    else if(t_cnt_en)
        t_cnt <= #1 t_cnt + 1'b1;
end 

always @ (posedge clk_2x or negedge rst_n)
begin : mem_wr_en_r
    if(rst_n == 1'b0)
        mem_wr_en <= 1'b0;
    else if(mem_wr_en)
	mem_wr_en <= #1 1'b0;
    else
        mem_wr_en <= #1 mem_if_wr;
end

/////////////////////////////////////////////////
// Transmit DATA to Nandflash 
// All date need to aligment to clk 1x domain
/////////////////////////////////////////////////
always @ (posedge clk or negedge rst_n)
begin : nf_dout_r
    if(rst_n == 1'b0)
        nf_dout <= {{DAT_WID}{1'b0}};
    else
        nf_dout <= #1 nf_dout_nxt;
end

// Address data transfer selection
always @ (*)
    begin
        case(addr_cnt)	
        3'b000: nfc_addr_dat = nfc_col_addr[7 : 0];
        3'b001: nfc_addr_dat = nfc_col_addr[15: 8];
        3'b010: nfc_addr_dat = nfc_col_addr[23:16];
        3'b011: nfc_addr_dat = nfc_col_addr[31:24];
        3'b100: nfc_addr_dat = nfc_row_addr[7 : 0];
        3'b101: nfc_addr_dat = nfc_row_addr[15: 8];
        3'b110: nfc_addr_dat = nfc_row_addr[23:16];
        3'b111: nfc_addr_dat = nfc_row_addr[31:24];
        default: nfc_addr_dat = 8'h0;
        endcase
    end

// NFC Dout Mux & Register
// Load Command
// Load Address
// Load Data or Data inverter
always @ ( * )
begin
    nf_dout_nxt = nf_dout;
    casex({load_cmd,load_addr,mem_wr_en}) // ,nfc_dat_inv})    
    3'b100: nf_dout_nxt = { 8'h0, nfc_if_cmd };
    3'b010: nf_dout_nxt = { 8'h0, nfc_addr_dat };
    3'b001: nf_dout_nxt = mem_if_din  ;
    default: nf_dout_nxt = nf_dout;
    endcase
end

always @ (*)
begin
    if(~nfc_dat_en)	
        nfif_dat_rdy = 1'b0;
    else if(dat_fetch_done)
        nfif_dat_rdy = 1'b0;
    else if(mem_if_wr) begin
        if(total_cycle==3'b000)
            nfif_dat_rdy = 1'b1;
        else
            nfif_dat_rdy = 1'b0;
        end
    else if(load_dat)
        nfif_dat_rdy = 1'b1;	
    else if(sta_dat_wr)
        nfif_dat_rdy = 1'b0;
    else
        nfif_dat_rdy = nfc_dat_en & nfc_dat_dir;
end

endmodule

