module agc(
    clk,
    reset_n,
    data_I_in,
    data_Q_in,
    agc_en,
    pwr_est_prd,
    pwr_est_val,
    agc_fix,
    pwm_step,
    pwm_ena,
    pwm_inv,
    pwm_th_ena,
    pwm_th_in,
    pwm_max_val,
    pwm_th_out
);

parameter D_WID = 10;

input                clk        ;
input                reset_n    ;
input  [D_WID-1:0]   data_I_in  ;
input  [D_WID-1:0]   data_Q_in  ;
input                agc_en     ;
input  [1:0]         pwr_est_prd;
output [7:0]         pwr_est_val;
output               agc_fix    ;

input  [1:0]         pwm_step   ;
input                pwm_ena    ;
input                pwm_inv    ;
input                pwm_th_ena ;
input  [6:0]         pwm_th_in  ; // pwm value 128 step
input  [6:0]         pwm_max_val;
output [6:0]         pwm_th_out ;

reg                  log_start  ;
reg    [13:0]        pwr_est_cnt;

wire   [8:0]         pwr_est_dB  ;
wire                 pwr_est_end ;
wire   [13:0]        pwr_est_time;
wire                 pwr_rst_cnt ;

assign pwr_est_time = pwr_est_prd[1] ? (pwr_est_prd[0] ? 14'h3fff : 14'h1fff )
                                     : (pwr_est_prd[0] ? 14'hfff  : 14'h7ff  );
assign pwr_rst_cnt = ( pwr_est_time == pwr_est_cnt );

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

power_est u_power_est(
    .clk        ( clk        ),
    .reset_n    ( reset_n    ),
    .data_i     ( data_I_in[9:3] ),
    .data_q     ( data_Q_in[9:3] ),
    .agc_en     ( agc_en     ),
    .log_start  ( log_start  ),
    .pwr_est_dB ( pwr_est_dB ),
    .pwr_est_end( pwr_est_end)
);

/*
pwm_gen u_pwm_gen(

);
*/
endmodule
