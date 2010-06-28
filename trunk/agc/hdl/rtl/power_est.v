// CMMB AGC control
// Power Estimation
// Singal sample frequency is the same as CLK 30 MHz

module power_est(
    clk,
    reset_n,
    data_i,
    data_q,
    agc_en,
    pwr_est_prd,
    pwr_req_val,
    pwr_est_dB,
    pwr_est_end
);

input                clk        ;
input                reset_n    ;
input   [6:0]        data_i     ;
input   [6:0]        data_q     ;
input                agc_en     ;
input   [1:0]        pwr_est_prd;
input   [8:0]        pwr_req_val;

output  [8:0]        pwr_est_dB ;
output               pwr_est_end;

reg     [6:0]        data_i_r   ;
reg     [6:0]        data_q_r   ;
reg     [6:0]        energy_est ;
reg     [13:0]       lpd_energy ;
reg     [9:0]        log_ten_i  ;
reg     [7:0]        tab_dat    ;
reg     [9:0]        log_ten_nor;
reg     [3:0]        num_n      ;
reg     [9:0]        data_xn    ;
reg     [9:0]        shift_data_xn;
reg     [9:0]        data_y0    ;
reg     [11:0]       data_y_n   ;
reg     [8:0]        pwr_est_dB ;
reg                  pwr_est_end;
reg     [10:0]       log_start_d;
reg                  log_start  ;
reg    [13:0]        pwr_est_cnt;
reg                  est_end    ;
reg     [8:0]        est_dB     ;

wire    [9:0]        pwr_est_dB_w;
wire   [13:0]        pwr_est_time;
wire                 pwr_rst_cnt ;
wire    [6:0]        abs_i_data ;
wire    [6:0]        abs_q_data ;
wire                 max_iq_cmp ;
wire    [6:0]        max_iq     ;
wire    [6:0]        min_iq     ;
wire    [6:0]        energy_est_w ;
wire    [17:0]       lpd_energy_w ;
wire    [10:0]       data_x2    ;
wire                 shift_en   ;
wire    [23:0]       dbm        ;

// Combinational Logic definition
assign abs_i_data = (data_i_r[6]) ? (~data_i_r+1'b1) : data_i_r;
assign abs_q_data = (data_q_r[6]) ? (~data_q_r+1'b1) : data_q_r;
assign max_iq_cmp = abs_q_data > abs_i_data;
assign max_iq = max_iq_cmp ? abs_q_data : abs_i_data;
assign min_iq = max_iq_cmp ? abs_i_data : abs_q_data;
assign energy_est_w = max_iq + {1'b0, min_iq[6:1]};
assign lpd_energy_w = lpd_energy - { 3'h0, lpd_energy[13:7] } + { 7'h0, energy_est};
assign data_x2 = {1'b0,data_xn}+{1'b0,shift_data_xn};
assign shift_en = | log_start_d[8:1] ;
assign dbm = $unsigned(data_y_n) * $unsigned(13'h1815);
assign pwr_est_time = pwr_est_prd[1] ? (pwr_est_prd[0] ? 14'h3fff : 14'h1fff )
                                     : (pwr_est_prd[0] ? 14'hfff  : 14'h7ff  );
assign pwr_rst_cnt = ( pwr_est_time == pwr_est_cnt );
assign pwr_est_dB_w = pwr_est_dB - { 3'h0, pwr_est_dB[8:3] } + { 3'h0, est_dB[8:3] };


// Log start control
always @ (posedge clk or negedge reset_n)
begin : pwr_est_cnt_r
    if(!reset_n)
        pwr_est_cnt <= 14'h0;
    else if(agc_en) begin
        if(pwr_rst_cnt)
        pwr_est_cnt <= 14'h0;
        else
        pwr_est_cnt <= #1 pwr_est_cnt + 1'b1;
        end
    else
        pwr_est_cnt <= 14'h0;
end

always @ (posedge clk or negedge reset_n)
begin : log_start_r
    if(!reset_n)
         log_start <= #1 1'b0;
    else
         log_start <= #1 pwr_rst_cnt;
end

// synchornous input data
always @ (posedge clk or negedge reset_n)
begin : data_i_sync
    if(!reset_n)
        data_i_r <= #1 7'h0;
    else 
        data_i_r <= #1 data_i;
end

always @ (posedge clk or negedge reset_n)
begin : data_q_sync
    if(!reset_n)
        data_q_r <= #1 7'h0;
    else 
        data_q_r <= #1 data_q;
end

// Max(|I|,|Q|) + 0.5 * Min(|I|,|Q|)
always @ (posedge clk or negedge reset_n)
begin : energy_est_r
    if(!reset_n)
        energy_est <= #1 7'h0;
    else 
        energy_est <= #1 energy_est_w;
end

always @ (posedge clk or negedge reset_n)
begin : lpd_energy_r
    if(!reset_n)
        lpd_energy <= #1 14'h0;
    else 
	lpd_energy <= #1 lpd_energy_w[13:0];
end

// Record a lpd_energy when log_start is active
always @ (posedge clk or negedge reset_n)
begin : log_ten_i_r
    if(!reset_n)
        log_ten_i <= #1 10'h0;
    else if(log_start)
	log_ten_i <= #1 lpd_energy[13:4];
end

// Synchronus Signal Piple line indication
always @ (posedge clk or negedge reset_n)
begin : log_start_d1_r
    if(!reset_n)
        log_start_d <= #1 11'h0;
    else
	log_start_d <= #1 {log_start_d[9:0],log_start};
end

// Log ten cordic like algorithm
// Normalization
always @ (log_ten_i)
begin : log_ten_nor_r
    if(log_ten_i[9])begin
	log_ten_nor = log_ten_i;
	num_n = 4'ha;end
    else if(log_ten_i[8])begin
	log_ten_nor = {log_ten_i[8:0],1'b0};
	num_n = 4'h9;end
    else if(log_ten_i[7])begin
	log_ten_nor = {log_ten_i[7:0],2'b0};
        num_n = 4'h8;end
    else if(log_ten_i[6])begin
	log_ten_nor = {log_ten_i[6:0],3'b0};
	num_n = 4'h7;end
    else if(log_ten_i[5])begin
	log_ten_nor = {log_ten_i[5:0],4'b0};
	num_n = 4'h6;end
    else if(log_ten_i[4])begin
	log_ten_nor = {log_ten_i[4:0],5'b0};
	num_n = 4'h5;end
    else if(log_ten_i[3])begin
	log_ten_nor = {log_ten_i[3:0],6'b0};
	num_n = 4'h4;end
   else if(log_ten_i[2])begin
	log_ten_nor = {log_ten_i[2:0],7'b0};
	num_n = 4'h3;end
   else if(log_ten_i[1])begin
	log_ten_nor = {log_ten_i[1:0],8'b0};
	num_n = 4'h2;end
   else begin
	log_ten_nor = {log_ten_i[0],9'h0};
	num_n = 4'h1;end
end

// Shift add or substract
always @ (posedge clk or negedge reset_n)
begin : data_xn_r
    if(!reset_n)
        data_xn <= #1 10'h0;
    else if(log_start_d[0])
        data_xn <= #1 log_ten_nor;
    else if(shift_en & ~data_x2[10])
	data_xn <= #1 data_x2[9:0];
end

always @ (posedge clk or negedge reset_n)
begin : data_y0_r
    if(!reset_n)
        data_y0 <= #1 10'h0;
    else if(log_start_d[0])
	data_y0 <= #1 10'h0;
    else if(shift_en & ~data_x2[10])
	data_y0 <= #1 data_y0 + tab_dat;
end

// Shift select
always @ (data_xn or log_start_d[8:1])
begin : shift_xn
    case(log_start_d[8:1])
    8'b0000_0001: shift_data_xn = {1'b0, data_xn[9:1]};
    8'b0000_0010: shift_data_xn = {2'b0, data_xn[9:2]};
    8'b0000_0100: shift_data_xn = {3'b0, data_xn[9:3]};
    8'b0000_1000: shift_data_xn = {4'b0, data_xn[9:4]};
    8'b0001_0000: shift_data_xn = {5'b0, data_xn[9:5]};
    8'b0010_0000: shift_data_xn = {6'b0, data_xn[9:6]};
    8'b0100_0000: shift_data_xn = {7'b0, data_xn[9:7]};
    8'b1000_0000: shift_data_xn = {8'b0, data_xn[9:8]};
    8'b0000_0000: shift_data_xn = {9'b0, data_xn[9]};
    default     : shift_data_xn = 10'h0;
    endcase
end

// Log table
always @ (log_start_d[8:1])
begin : log_table
    case (log_start_d[8:1])	
    8'b0000_0001:  tab_dat = 8'h95;
    8'b0000_0010:  tab_dat = 8'h52;
    8'b0000_0100:  tab_dat = 8'h2B;
    8'b0000_1000:  tab_dat = 8'h16;
    8'b0001_0000:  tab_dat = 8'h0B;
    8'b0010_0000:  tab_dat = 8'h05;
    8'b0100_0000:  tab_dat = 8'h02;
    8'b1000_0000:  tab_dat = 8'h01;
    default: tab_dat = 8'h0;
    endcase
end

always @ (posedge clk or negedge reset_n)
begin : data_y_n_r
    if(!reset_n)
        data_y_n <= #1 12'h0;
    else if(log_start_d[9])
	data_y_n <= #1 {num_n,8'h0}-{2'h0, data_y0};
end

// Indicate a new Pwr_est_val
always @ (posedge clk or negedge reset_n)
begin : est_end_r
    if(!reset_n)
        est_end <= #1 1'b0;
    else
	est_end <= #1 log_start_d[10];
end

always @ (posedge clk or negedge reset_n)
begin : pwr_est_end_r
    if(!reset_n)
        pwr_est_end <= #1 1'b0;
    else
	pwr_est_end <= #1 est_end;
end

// Power Estimation Result Unit : dB
always @ (posedge clk or negedge reset_n)
begin : est_db_r
    if(!reset_n)
        est_dB <= #1 9'h0;
    else if(log_start_d[10]) 
        est_dB <= #1 dbm[14] ? (dbm[23:15]+1'b1) : dbm[23:15];
end

always @ (posedge clk or negedge reset_n)
begin : pwr_est_db_r
    if(!reset_n)
        pwr_est_dB <= #1 9'h0;
    else if(~agc_en)
        pwr_est_dB <= #1 pwr_req_val;
    else if(est_end) 
        pwr_est_dB <= #1 pwr_est_dB_w;
end

endmodule
