module pwm_gen(
    clk,
    reset_n,
    pwr_req_val,
    pwr_est_dB,
    pwr_est_end,
    pwm_step,
    pwm_ena,
    pwm_inv,
    pwm_th_ena,
    pwm_th_in,
    agc_fix,
    pwm_max_val,
    pwm_val,
    pwm_val_up
);

input                clk        ;
input                reset_n    ;
input  [8:0]         pwr_req_val;
input  [8:0]         pwr_est_dB ;
input                pwr_est_end;

input  [1:0]         pwm_step   ;
input                pwm_ena    ;
input                pwm_inv    ;
input                pwm_th_ena ;
input  [7:0]         pwm_th_in  ; // pwm value 128 step
input  [7:0]         pwm_max_val;
output [7:0]         pwm_val    ;
output               pwm_val_up ;
output               agc_fix    ;

reg                  pwm_dir    ;
reg                  pwm_adj_en ;
reg                  pwr_est_d1 ;
reg    [7:0]         pwm_val    ;
reg                  pwm_val_up ;
reg    [3:0]         pwr_cnt    ;
reg                  agc_fix    ;

wire   [9:0]         delta_dB   ;
wire   [8:0]         abs_delta_dB;
wire                 dB_in_range;
wire   [8:0]         pwm_val_add_tmp;
wire   [8:0]         pwm_val_sub_tmp;
wire   [7:0]         pwm_val_add;
wire   [7:0]         pwm_val_sub;

assign delta_dB = {1'b0,pwr_req_val} - {1'b0,pwr_est_dB};
assign abs_delta_dB = delta_dB[9] ? (~delta_dB[8:0] + 1'b1):delta_dB[8:0];
assign dB_in_range = abs_delta_dB <= 9'b000000_101; // 0.625dB
assign pwm_val_add_tmp = {1'b0, pwm_val} + pwm_step ;
assign pwm_val_sub_tmp = {1'b0, pwm_val} - pwm_step ;
assign pwm_val_add =  pwm_val_add_tmp[8] ? pwm_max_val : pwm_val_add_tmp[7:0];
assign pwm_val_sub =  pwm_val_sub_tmp[8] ? 7'h0 : pwm_val_sub_tmp[7:0];

always @ (posedge clk or negedge reset_n)
begin : pwm_dir_r
    if(!reset_n)
        pwm_dir <= #1 1'b0;
    else if(pwm_ena & pwr_est_end)
	pwm_dir <= #1 delta_dB[9];
end

always @ (posedge clk or negedge reset_n)
begin : pwr_cnt_r
    if(!reset_n)
        pwr_cnt <= #1 4'h0;
    else if(pwr_est_end)
    begin
        if(!agc_fix & dB_in_range)
        pwr_cnt <= #1 pwr_cnt + 1'b1;
        else
        pwr_cnt <= #1 4'h0;		
    end
end	    

always @ (posedge clk or negedge reset_n)
begin : agc_fix_r
    if(!reset_n)
        agc_fix <= #1 1'b0;
    else if(pwr_cnt == 4'h4)
        agc_fix <= #1 1'b1;	    
end	    

always @ (posedge clk or negedge reset_n)
begin : pwm_adj_en_r	
    if(!reset_n)
        pwm_adj_en <= #1 1'b0;
    else if(pwm_ena)
        pwm_adj_en <= #1 (!dB_in_range) & pwr_est_end;
end

always @ (posedge clk or negedge reset_n)
begin : pwm_est_end_d
    if(!reset_n)
        pwr_est_d1 <= #1 1'b0;
    else if(pwm_ena)
	pwr_est_d1 <= #1 pwr_est_end;
end

always @ (posedge clk or negedge reset_n)
begin : pwm_up_r
    if(!reset_n)
        pwm_val_up <= #1 1'b0;
    else 
	pwm_val_up <= #1 pwr_est_d1;
end

always @ (posedge clk or negedge reset_n)
begin : pwm_val_r
    if(!reset_n)	
        pwm_val <= #1 8'h0;
    else if(!pwm_ena | pwm_th_ena)
	pwm_val <= #1 pwm_th_in;
    else if(pwm_adj_en)
        pwm_val <= #1 pwm_dir ? pwm_val_sub : pwm_val_add; 
end


endmodule
