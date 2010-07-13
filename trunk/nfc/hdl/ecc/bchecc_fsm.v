//+File Header//////////////////////////////////////////////////////////////////
//Copyright 2009, shhic. All rights reserved
//Filename    : bchecc_fsm.v
//Module name : bchecc_fsm
//Department  : security
//Author      : Xu Yunxiu
//Author's mail : xuyx@shhic.com
//------------------------------------------------------------------------ 
// Release history 
// VERSION  Date       AUTHOR       DESCRIPTION 
// 1.0      2010-6-1   Xun Yunxiu   Initial version
//------------------------------------------------------------------------ 
// Other: The IP is based on ECC_V100.
//-File Header//////////////////////////////////////////////////////////////////

`timescale 1ns/100ps
module  bchecc_fsm(
                rst_n,
                clk,
                ecc_ctrl_i,
                ecc_cfg_i,
                ecc_wr_i,
                ecc_data_i,
                bma_error_i,
                bma_expt_i,
                detect_error_i,
                error_data_i,
                
                init_en_o,
                ecc_data_o,
                ecc_wr_o,
                ecc_done_o,
                error_addr_o,
                change_stat_o,
                ecc_busy_o,
                ecc_block_o,
                ecc_error_o,
                correct_fail_o,
               
                enc_data_avail_o,
                dec_data_avail_o,
                enc_last_o,
                enc_out_en_o,
                enc_out_first_o,
               
                bma_opt_o,
                bma_load_o,
                syndm_en_o,
                delta_en_o,
                bma_en_o,
                bma_end_o,
               
                bma_cnt_o,
                delta_cnt_o,
                bma_sel_cnt_o,
               
                chien_load_o,
                chien_en_o,
                chien_out_o,
                chien_first_o,
                over_cnt_o,

                error_cnt_o
                );
////////////////input
input           rst_n;
input           clk;
input   [3:0]   ecc_ctrl_i;
input   [9:0]   ecc_cfg_i;
input           ecc_wr_i;
input   [7:0]   ecc_data_i;
input           bma_error_i;
input   [4:0]   bma_expt_i;
input           detect_error_i;
input   [5:0]   error_data_i;

////////////////output
output          init_en_o;
output  [7:0]   ecc_data_o;
output          ecc_wr_o;
output          ecc_done_o;
output  [12:0]  error_addr_o;
output          change_stat_o;
output          ecc_busy_o;
output          ecc_block_o;
output          ecc_error_o;
output          correct_fail_o;

output          enc_data_avail_o;
output          dec_data_avail_o;
output          enc_last_o;
output          enc_out_en_o;
output          enc_out_first_o;

output          bma_opt_o;
output          bma_load_o;
output          syndm_en_o;
output          delta_en_o;
output          bma_en_o;
output          bma_end_o;

output  [4:0]   bma_cnt_o;
output  [3:0]   delta_cnt_o;
output  [3:0]   bma_sel_cnt_o;

output          chien_load_o;
output          chien_en_o;
output          chien_out_o;
output          chien_first_o;
output  [1:0]   over_cnt_o;
output  [3:0]   error_cnt_o;

////////////////FSM coding
parameter       IDLE        = 3'b000;
parameter       ENC_CALC    = 3'b001;
parameter       ENC_OUT     = 3'b011;
parameter       ENC_DONE    = 3'b010;
parameter       DEC_CALC    = 3'b100;
parameter       DEC_DONE    = 3'b110;

parameter       BMA_IDLE    = 3'b000;
parameter       BMA_SYNDM   = 3'b001;
parameter       BMA_CALC1   = 3'b011;
parameter       BMA_CALC2   = 3'b010;
parameter       BMA_DONE    = 3'b110;

parameter       CHIEN_IDLE  = 2'b00;
parameter       CHIEN_CALC  = 2'b01;
parameter       CHIEN_OUT   = 2'b11;
parameter       CHIEN_DONE  = 2'b10;

////////////////sfr signals
wire            ecc_en;
wire            ecc_opt;
wire            enc_dec;
wire            correct_en;

wire    [11:0]  enc_outcnt;
wire    [11:0]  dec_incnt;
wire    [3:0]   correct_cap;
wire    [3:0]   correct_cap_sub1;

////////////////FSM
reg     [2:0]   current_state;
reg     [2:0]   next_state;

wire            init_en;
wire            idle_st;
wire            enc_calc_st;
wire            enc_out_st;
wire            enc_done_st;
wire            dec_calc_st;
wire            dec_done_st;
reg     [11:0]  ecc_cnt;

////////////////BMA_FSM
reg     [2:0]   current_bma_state;
reg     [2:0]   next_bma_state;

wire            bma_idle_st;
wire            bma_syndm_st;
wire            bma_calc1_st;
wire            bma_calc2_st;
wire            bma_done_st;

reg     [4:0]   bma_cnt;
reg     [3:0]   delta_cnt;
reg     [3:0]   bma_sel_cnt;

wire            bma_load;
reg             bma_opt;
reg             bma_correct_en;

////////////////CHIEN_FSM
reg     [1:0]   current_chien_state;
reg     [1:0]   next_chien_state;

wire            chien_idle_st;
wire            chien_calc_st;
wire            chien_out_st;
wire            chien_done_st;
reg             chien_first;

reg     [11:0]  chien_cnt_tmp0;
reg     [11:0]  chien_cnt_tmp1;
reg     [11:0]  chien_cnt_tmp2;
reg     [1:0]   over_cnt_tmp;
reg     [1:0]   over_cnt;
reg     [11:0]  chien_cnt;
reg     [3:0]   error_cnt;
reg     [12:0]  error_addr;

wire            chien_load;
reg             chien_correct_en;
reg     [4:0]   chien_expt;
reg             chien_error;

////////////////ecc data
reg     [7:0]   ecc_data;
reg             enc_data_avail;
reg             dec_data_avail;
reg             ecc_wr;
reg             ecc_done;

////////////////sfr signals
assign  ecc_en     = ecc_ctrl_i[0];
assign  ecc_opt    = ecc_ctrl_i[1];
assign  enc_dec    = ecc_ctrl_i[2];
assign  correct_en = ecc_ctrl_i[3];

assign  enc_outcnt  = ecc_opt ? 12'h018 : 12'h00C;
assign  dec_incnt   = ecc_opt ? ({2'b00,ecc_cfg_i} + 12'h018) 
                              : ({2'b00,ecc_cfg_i} + 12'h00D);
assign  correct_cap = ecc_opt ? 4'hF : 4'h8;
assign  correct_cap_sub1 = ecc_opt ? 4'hE : 4'h7;

////////////////FSM
always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            current_state <= IDLE;
        end
    else
        begin
            current_state <= next_state;
        end
end

always  @(*)
begin
    case(current_state)
        IDLE:
            begin
                if(ecc_en && ecc_wr_i)
                    begin
                        if(enc_dec)
                            begin
                                next_state = DEC_CALC;
                            end
                        else
                            begin
                                next_state = ENC_CALC;
                            end
                    end
                else
                    begin
                        next_state = IDLE;
                    end
            end
        ENC_CALC:
            begin
                if(ecc_en)
                    begin
                        if(ecc_cnt < {2'b00,ecc_cfg_i})
                            begin
                                next_state = ENC_CALC;
                            end
                        else
                            begin
                                next_state = ENC_OUT;
                            end
                    end
                else
                    begin
                        next_state = IDLE;
                    end
            end
        ENC_OUT:
            begin
                if(ecc_en)
                    begin
                        if(ecc_cnt < enc_outcnt)
                            begin
                                next_state = ENC_OUT;
                            end
                        else
                            begin
                                next_state = ENC_DONE;
                            end
                    end
                else
                    begin
                        next_state = IDLE;
                    end
            end
        ENC_DONE:   
            begin
                next_state = IDLE;
            end
        DEC_CALC:
            begin
                if(ecc_en)
                    begin
                        if(ecc_cnt < dec_incnt)
                            begin
                                next_state = DEC_CALC;
                            end
                        else
                            begin
                                next_state = DEC_DONE;
                            end
                    end
                else
                    begin
                        next_state = IDLE;
                    end
            end
        DEC_DONE:
            begin
                if(ecc_en)
                    begin
                        if(bma_idle_st)
                            begin
                                next_state = IDLE;
                            end
                        else
                            begin
                                next_state = DEC_DONE;
                            end
                    end
                else
                    begin
                        next_state = IDLE;
                    end
            end
        default:
            begin
                next_state = IDLE;
            end
    endcase
end

assign  init_en     = ecc_en & idle_st;
assign  idle_st     = (current_state == IDLE);
assign  enc_calc_st = (current_state == ENC_CALC);
assign  enc_out_st  = (current_state == ENC_OUT);
assign  enc_done_st = (current_state == ENC_DONE);
assign  dec_calc_st = (current_state == DEC_CALC);
assign  dec_done_st = (current_state == DEC_DONE);

always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            ecc_cnt <= 12'h000;
        end
    else if(ecc_en)
        begin
            if(idle_st)
                begin
                    if(ecc_wr_i)
                        begin
                            ecc_cnt <= ecc_cnt + 12'h001;
                        end
                    else
                        begin
                            ecc_cnt <= 12'h000;
                        end
                end
            else if(enc_calc_st)
                begin
                    if(ecc_cnt < {2'b00,ecc_cfg_i})
                        begin
                            if(ecc_wr_i)
                                begin
                                    ecc_cnt <= ecc_cnt + 12'h001;
                                end
                        end
                    else
                        begin
                            ecc_cnt <= 12'h000;
                        end
                end
            else if(dec_calc_st)
                begin
                    if(ecc_cnt < dec_incnt)
                        begin
                            if(ecc_wr_i)
                                begin
                                    ecc_cnt <= ecc_cnt + 12'h001;
                                end
                        end
                    else
                        begin
                            ecc_cnt <= 12'h000;
                        end
                end
            else if(enc_out_st)
                begin
                    if(ecc_cnt < enc_outcnt)
                        begin
                            ecc_cnt <= ecc_cnt + 12'h001;
                        end
                    else
                        begin
                            ecc_cnt <= 12'h000;
                        end
                end
            else
                begin
                    ecc_cnt <= 12'h000;
                end
        end
    else
        begin
            ecc_cnt <= 12'h000;
        end
end

////////////////BMA_FSM
assign  bma_load = bma_idle_st && dec_done_st;

always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            current_bma_state <= BMA_IDLE;
        end
    else
        begin
            current_bma_state <= next_bma_state;
        end
end

always  @(*)
begin
    case(current_bma_state)
        BMA_IDLE:
            begin
                if(ecc_en)
                    begin
                        if(dec_done_st)
                            begin
                                next_bma_state = BMA_SYNDM;
                            end
                        else
                            begin
                                next_bma_state = BMA_IDLE;
                            end
                    end
                else
                    begin
                        next_bma_state = BMA_IDLE;
                    end
            end
        BMA_SYNDM:
            begin
                if(ecc_en)
                    begin
                        if(bma_error_i && bma_correct_en)
                            begin
                                if(bma_opt)
                                    begin
                                        if(bma_cnt < 5'h06)
                                            begin
                                                next_bma_state = BMA_SYNDM;
                                            end
                                        else
                                            begin
                                                next_bma_state = BMA_CALC1;
                                            end
                                    end
                                else
                                    begin
                                        if(bma_cnt < 5'h03)
                                            begin
                                                next_bma_state = BMA_SYNDM;
                                            end
                                        else
                                            begin
                                                next_bma_state = BMA_CALC1;
                                            end
                                    end
                            end
                        else
                            begin
                                next_bma_state = BMA_DONE;
                            end
                    end
                else
                    begin
                        next_bma_state = BMA_IDLE;
                    end
            end
        BMA_CALC1:
            begin
                if(ecc_en)
                    begin
                        if(delta_cnt < bma_expt_i[4:1])
                            begin
                                next_bma_state = BMA_CALC1;
                            end
                        else
                            begin
                                next_bma_state = BMA_CALC2;
                            end
                    end
                else
                    begin
                        next_bma_state = BMA_IDLE;
                    end
            end
        BMA_CALC2:
            begin
                if(ecc_en)
                    begin
                        if(delta_cnt < correct_cap)
                            begin
                                next_bma_state = BMA_CALC2;
                            end
                        else
                            begin
                                if(bma_cnt[4:1] < correct_cap_sub1)
                                    begin
                                        next_bma_state = BMA_CALC1;
                                    end
                                else
                                    begin
                                        next_bma_state = BMA_DONE;
                                    end
                            end
                    end
                else
                    begin
                        next_bma_state = BMA_IDLE;
                    end
            end
        BMA_DONE:
            begin
                if(ecc_en)
                    begin
                        if(chien_idle_st)
                            begin
                                next_bma_state = BMA_IDLE;
                            end
                        else
                            begin
                                next_bma_state = BMA_DONE;
                            end
                    end
                else
                    begin
                        next_bma_state = BMA_IDLE;
                    end
            end
        default:
            begin
                next_bma_state = BMA_IDLE;
            end
    endcase
end

assign  bma_idle_st  = (current_bma_state==BMA_IDLE);
assign  bma_syndm_st = (current_bma_state==BMA_SYNDM);
assign  bma_calc1_st = (current_bma_state==BMA_CALC1);
assign  bma_calc2_st = (current_bma_state==BMA_CALC2);
assign  bma_done_st  = (current_bma_state==BMA_DONE);

always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            bma_opt <= 1'b0;
        end
    else if(bma_load)
        begin
            bma_opt <= ecc_opt;
        end
end

always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            bma_correct_en <= 1'b0;
        end
    else if(bma_load)
        begin
            bma_correct_en <= correct_en;
        end
end

always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            bma_cnt <= 5'h00;
        end
    else if(bma_load)
        begin
            bma_cnt <= 5'h00;
        end
    else if(bma_syndm_st)
        begin
            if(bma_opt)
                begin
                    if(bma_cnt < 5'h06)
                        begin
                            bma_cnt <= bma_cnt + 5'h01;
                        end
                    else
                        begin
                            bma_cnt <= 5'h00;
                        end
                end
            else
                begin
                    if(bma_cnt < 5'h03)
                        begin
                            bma_cnt <= bma_cnt + 5'h01;
                        end
                    else
                        begin
                            bma_cnt <= 5'h00;
                        end
                end
        end
    else if(bma_calc1_st || bma_calc2_st)
        begin
            if(bma_calc2_st)
                begin
                    if(delta_cnt == correct_cap)
                        begin
                            if(bma_cnt[4:1] < correct_cap_sub1)
                                begin
                                    bma_cnt <= bma_cnt + 5'h02;
                                end
                            else
                                begin
                                    bma_cnt <= 5'h00;
                                end
                        end
                end
        end
    else
        begin
            bma_cnt <= 5'h00;
        end
end

always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            delta_cnt <= 4'h0;
        end
    else if(bma_load)
        begin
            delta_cnt <= 4'h0;
        end
    else if(bma_calc1_st)
        begin
            if(delta_cnt < bma_expt_i[4:1])
                begin
                    delta_cnt <= delta_cnt + 4'h1;
                end
            else
                begin
                    delta_cnt <= 4'h0;
                end
        end
    else if(bma_calc2_st)
        begin
            if(delta_cnt < correct_cap)
                begin
                    delta_cnt <= delta_cnt + 4'h1;
                end
            else
                begin
                    delta_cnt <= 4'h0;
                end
        end
    else
        begin
            delta_cnt <= 4'h0;
        end
end

always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            bma_sel_cnt <= 4'h0;
        end
    else if(bma_load)
        begin
            bma_sel_cnt <= 4'h0;
        end
    else if(bma_calc1_st)
        begin
            bma_sel_cnt <= bma_sel_cnt - 4'h1;
        end
    else if(bma_calc2_st)
        begin
            bma_sel_cnt <= bma_cnt[4:1] + 4'h1;
        end
    else
        begin
            bma_sel_cnt <= 4'h0;
        end
end

////////////////CHIEN_FSM
assign  chien_load = chien_idle_st && bma_done_st;

always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            current_chien_state <= CHIEN_IDLE;
        end
    else
        begin
            current_chien_state <= next_chien_state;
        end
end

always  @(*)
begin
    case(current_chien_state)
        CHIEN_IDLE:
            begin
                if(ecc_en)
                    begin
                        if(bma_done_st)
                            begin
                                next_chien_state = CHIEN_CALC;
                            end
                        else
                            begin
                                next_chien_state = CHIEN_IDLE;
                            end
                    end
                else
                    begin
                        next_chien_state = CHIEN_IDLE;
                    end
            end
        CHIEN_CALC:
            begin
                if(ecc_en)
                    begin
                        if(chien_error && chien_correct_en && (chien_expt<5'h10))
                            begin
                                if({1'b0,error_cnt} < chien_expt)
                                    begin
                                    	  if(detect_error_i)
                                            begin
                                                next_chien_state = CHIEN_OUT;
                                            end
                                        else if(chien_cnt > 12'h000)
                                            begin
                                                next_chien_state = CHIEN_CALC;
                                            end
                                        else
                                            begin
                                                next_chien_state = CHIEN_DONE;
                                            end
                                    end
                                else
                                    begin
                                        next_chien_state = CHIEN_DONE;
                                    end
                            end
                        else
                            begin
                                next_chien_state = CHIEN_DONE;
                            end
                    end
                else
                    begin
                        next_chien_state = CHIEN_IDLE;
                    end
            end
        CHIEN_OUT:
            begin
                if(ecc_en)
                    begin
                        if(detect_error_i)
                            begin
                                next_chien_state = CHIEN_OUT;
                            end
                        else if(chien_cnt==12'h000)
                            begin
                                next_chien_state = CHIEN_DONE;
                            end
                        else
                            begin
                                next_chien_state = CHIEN_CALC;
                            end
                    end
                else
                    begin
                        next_chien_state = CHIEN_IDLE;
                    end
            end
        CHIEN_DONE:
            begin
                next_chien_state = CHIEN_IDLE;
            end
        default:
            begin
                next_chien_state = CHIEN_IDLE;
            end
    endcase
end

assign  chien_idle_st = (current_chien_state==CHIEN_IDLE);
assign  chien_calc_st = (current_chien_state==CHIEN_CALC);
assign  chien_out_st  = (current_chien_state==CHIEN_OUT);
assign  chien_done_st = (current_chien_state==CHIEN_DONE);

always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            chien_correct_en <= 1'b0;
        end
    else if(chien_load)
        begin
            chien_correct_en <= bma_correct_en;
        end
end

always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            chien_error <= 1'b0;
        end
    else if(chien_load)
        begin
            chien_error <= bma_error_i;
        end
end

always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            chien_expt <= 5'h00;
        end
    else if(chien_load)
        begin
            chien_expt <= bma_expt_i;
        end
end

always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            chien_cnt_tmp0 <= 12'h000;
        end
    else if(idle_st)
        begin
            chien_cnt_tmp0 <= dec_incnt;
        end
    else if(dec_calc_st)
        begin
            if(chien_cnt_tmp0 > 12'h003)
                begin
                    chien_cnt_tmp0 <= chien_cnt_tmp0 - 12'h003;
                end
        end
end

always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            chien_cnt_tmp1 <= 12'h000;
        end
    else if(idle_st)
        begin
            chien_cnt_tmp1 <= 12'h000;
        end
    else if(dec_calc_st)
        begin
            if(chien_cnt_tmp0 > 12'h003)
                begin
                    chien_cnt_tmp1 <= chien_cnt_tmp1 + 12'h001;
                end
        end
end

always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            chien_cnt_tmp2 <= 12'h000;
        end
    else if(bma_load)
        begin
            chien_cnt_tmp2 <= dec_incnt + chien_cnt_tmp1;
        end
end

always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            over_cnt_tmp <= 2'b00;
        end
    else if(bma_load)
        begin
            over_cnt_tmp <= chien_cnt_tmp0[1:0];
        end
end

always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            over_cnt <= 2'b00;
        end
    else if(chien_load)
        begin
            over_cnt <= over_cnt_tmp;
        end
end

always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            chien_first <= 1'b0;
        end
    else
        begin
            chien_first <= chien_load;
        end
end

always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            chien_cnt <= 12'h000;
        end
    else if(chien_load)
        begin
            chien_cnt <= chien_cnt_tmp2;
        end
    else if(chien_calc_st || chien_out_st)
        begin
            if(!detect_error_i)
                begin
                    if(chien_cnt > 12'h000)
                        begin
                            chien_cnt <= chien_cnt - 12'h001;
                        end
                    else
                        begin
                            chien_cnt <= 12'h000;
                        end
                end
        end
    else
        begin
            chien_cnt <= 12'h000;
        end
end

always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            error_cnt <= 4'h0;
        end
    else if(chien_load)
        begin
            error_cnt <= 4'h0;
        end
    else if(chien_out_st)
        begin
            if({1'b0,error_cnt} < chien_expt)
                begin
                    error_cnt <= error_cnt + 4'h1;
                end
        end
end

always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            error_addr <= 13'h0000;
        end
    else if(chien_load || chien_calc_st)
        begin
            error_addr <= 13'h0000;
        end
    else if(chien_out_st)
        begin
            if(error_data_i[0])
                begin
                    error_addr <= {chien_cnt[10:0],2'b00} + {1'b0,chien_cnt[10:0],1'b0} + 13'h0005;
                end
            else if(error_data_i[1])
                begin
                    error_addr <= {chien_cnt[10:0],2'b00} + {1'b0,chien_cnt[10:0],1'b0} + 13'h0004;
                end
            else if(error_data_i[2])
                begin
                    error_addr <= {chien_cnt[10:0],2'b00} + {1'b0,chien_cnt[10:0],1'b0} + 13'h0003;
                end
            else if(error_data_i[3])
                begin
                    error_addr <= {chien_cnt[10:0],2'b00} + {1'b0,chien_cnt[10:0],1'b0} + 13'h0002;
                end
            else if(error_data_i[4])
                begin
                    error_addr <= {chien_cnt[10:0],2'b00} + {1'b0,chien_cnt[10:0],1'b0} + 13'h0001;
                end
            else if(error_data_i[5])
                begin
                    error_addr <= {chien_cnt[10:0],2'b00} + {1'b0,chien_cnt[10:0],1'b0};
                end
        end
end

////////////////ecc data
always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            ecc_data <= 8'h00;
        end
    else if(ecc_en && ecc_wr_i)
        begin
            ecc_data <= ecc_data_i;
        end
end

always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            enc_data_avail <= 1'b0;
        end
    else if(ecc_en && (enc_dec==1'b0) && (idle_st || enc_calc_st))
        begin
            if(ecc_cnt < {2'b00,ecc_cfg_i})
                begin
                    enc_data_avail <= ecc_wr_i;
                end
            else
                begin
                    enc_data_avail <= 1'b0;
                end
        end
    else
        begin
            enc_data_avail <= 1'b0;
        end
end

always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            dec_data_avail <= 1'b0;
        end
    else if(ecc_en && (enc_dec==1'b1) && (idle_st || dec_calc_st))
        begin
            if(ecc_cnt < dec_incnt)
                begin
                    dec_data_avail <= ecc_wr_i;
                end
            else
                begin
                    dec_data_avail <= 1'b0;
                end
        end
    else
        begin
            dec_data_avail <= 1'b0;
        end
end

always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            ecc_wr <= 1'b0;
        end
    else if(ecc_en)
        begin
            ecc_wr <= enc_out_st || chien_out_st;
        end
    else
        begin
            ecc_wr <= 1'b0;
        end
end

always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            ecc_done <= 1'b0;
        end
    else if(ecc_en)
        begin
            ecc_done <= enc_done_st || chien_done_st;
        end
    else
        begin
            ecc_done <= 1'b0;
        end
end

////////////////output for encoder and syndm
assign  init_en_o  = init_en;
assign  ecc_data_o = ecc_data;
assign  enc_data_avail_o = enc_data_avail;
assign  dec_data_avail_o = dec_data_avail;
assign  enc_last_o      = enc_calc_st && (ecc_cnt == {2'b00,ecc_cfg_i});
assign  enc_out_en_o    = enc_out_st;
assign  enc_out_first_o = enc_out_st && (ecc_cnt==12'h000);

assign  ecc_wr_o   = ecc_wr;
assign  ecc_done_o = ecc_done;

////////////////output for bma
assign  bma_opt_o  = bma_opt;
assign  bma_load_o = bma_load;
assign  syndm_en_o = bma_syndm_st;
assign  delta_en_o = bma_calc1_st;
assign  bma_en_o   = bma_calc2_st;
assign  bma_end_o  = bma_calc2_st && (delta_cnt == correct_cap);

assign  bma_cnt_o     = bma_cnt;
assign  delta_cnt_o   = delta_cnt;
assign  bma_sel_cnt_o = bma_sel_cnt;

////////////////output for chien
assign  chien_load_o = chien_load;
assign  chien_en_o   = chien_calc_st;
assign  chien_out_o  = chien_out_st;
assign  chien_first_o = chien_first;
assign  over_cnt_o   = over_cnt;
assign  error_cnt_o  = error_cnt;
assign  error_addr_o = error_addr;

assign  change_stat_o  = chien_done_st;
assign  ecc_busy_o     = ~(idle_st & bma_idle_st & chien_idle_st);
assign  ecc_block_o    = (dec_calc_st && (ecc_cnt>=dec_incnt-12'h001)) || (dec_done_st && ~bma_idle_st);
assign  ecc_error_o    = chien_error;
assign  correct_fail_o = chien_correct_en && ({1'b0,error_cnt} < chien_expt);

endmodule