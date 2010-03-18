module iir(
    clk        ,
    reset_n    ,
    data_in    ,
    data_out   
);

parameter IN_WID  = 10,
	  WID     = 11,
          OUT_WID = 10;

input                clk      ;
input                reset_n  ;
input  [IN_WID-1:0]  data_in  ;

output [OUT_WID-1:0] data_out ;

reg    [OUT_WID-1:0] data_out ;
reg    [IN_WID-1:0]  data_dly ;
reg    [IN_WID+2:0]  b1       ; 
reg    [IN_WID+3:0]  b2       ; 
reg    [IN_WID+4:0]  b3       ;
reg    [IN_WID+2:0]  b4       ;
reg    [IN_WID+4:0]  b5       ;
reg    [IN_WID+3:0]  b6       ;
reg    [IN_WID+5:0]  b7       ;
reg    [IN_WID+1:0]  state1   ;
reg    [IN_WID+4:0]  state2   ;
reg    [IN_WID+3:0]  state3   ;
reg    [IN_WID+3:0]  state4   ;
reg    [IN_WID+2:0]  state5   ;
reg    [IN_WID+5:0]  state6   ;
reg    [IN_WID+4:0]  state7   ;

wire   [IN_WID+2:0]  adp_out1_a   ;
wire   [IN_WID+3:0]  adp_out2_a   ;
wire   [IN_WID+4:0]  adp_out3_a   ;
wire   [IN_WID+2:0]  adp_out4_a   ;
wire   [IN_WID+4:0]  adp_out5_a   ;
wire   [IN_WID+3:0]  adp_out6_a   ;
wire   [IN_WID+5:0]  adp_out7_a   ;
wire   [IN_WID+1:0]  adp_out1_b   ;
wire   [IN_WID+4:0]  adp_out2_b   ;
wire   [IN_WID+3:0]  adp_out3_b   ;
wire   [IN_WID+3:0]  adp_out4_b   ;
wire   [IN_WID+2:0]  adp_out5_b   ;
wire   [IN_WID+5:0]  adp_out6_b   ;
wire   [IN_WID+4:0]  adp_out7_b   ;

reg    [IN_WID-1:0]  data_out_r   ;
wire   [IN_WID+4:0]  data_out_w   ;
wire   [10:0]        alpha1       ;
wire   [10:0]        alpha2       ;
wire   [10:0]        alpha3       ;
wire   [10:0]        alpha4       ;
wire   [10:0]        alpha5       ;
wire   [10:0]        alpha6       ;
wire   [10:0]        alpha7       ;

assign alpha1 = 11'd662;
assign alpha2 = 11'h4E5;
assign alpha3 = 11'd740;
assign alpha4 = 11'h5CC;
assign alpha5 = 11'd850;
assign alpha6 = 11'h440;
assign alpha7 = 11'd691;

assign data_out_w = {b2[IN_WID+3],b2} + {b6[IN_WID+3],b6}+1'b1;

always @ (data_out_w)
begin
    if(data_out_w[IN_WID+4])
        begin
            if(data_out_w[IN_WID+3:IN_WID]==4'hf)
                 data_out_r = data_out_w[IN_WID:1];
            else
	         data_out_r = 10'h201;
         end
    else begin
             if(data_out_w[IN_WID+3:IN_WID]==4'h0)
	         data_out_r = data_out_w[IN_WID:1];
             else
	         data_out_r = 10'h1FF;
         end	 
end	

//data_dly
always @ (posedge clk or negedge reset_n)
begin: data_d1
    if(!reset_n)
        data_dly <= #1 10'h0;
    else
	data_dly <= #1 data_in;
end

//porta
always @ (posedge clk or negedge reset_n)
begin: b_r
    if(!reset_n) begin
        b1 <= #1 'h0;
        b2 <= #1 'h0;	
        b3 <= #1 'h0;
	b4 <= #1 'h0;
	b5 <= #1 'h0;
	b6 <= #1 'h0;
	b7 <= #1 'h0;
        end
    else begin
        b1 <= #1 adp_out1_a;
        b2 <= #1 adp_out2_a;
	b3 <= #1 adp_out3_a;
	b4 <= #1 adp_out4_a;
	b5 <= #1 adp_out5_a;
	b6 <= #1 adp_out6_a;
	b7 <= #1 adp_out7_a;
    end
end

//portb
always @ (posedge clk or negedge reset_n)
begin: state_r
    if(!reset_n) begin
        state1 <= #1 'h0;
        state2 <= #1 'h0;	
        state3 <= #1 'h0;
	state4 <= #1 'h0;
	state5 <= #1 'h0;
	state6 <= #1 'h0;
	state7 <= #1 'h0;
        end
    else begin
        state1 <= #1 adp_out1_b;
        state2 <= #1 adp_out2_b;
	state3 <= #1 adp_out3_b;
	state4 <= #1 adp_out4_b;
	state5 <= #1 adp_out5_b;
	state6 <= #1 adp_out6_b;
	state7 <= #1 adp_out7_b;
    end
end

always @ (posedge clk or negedge reset_n)
begin : out_r
    if(!reset_n)
        data_out <= #1 'h0;
    else
        data_out <= #1 data_out_r;//data_out_w[IN_WID:1];
end	

adaptor_2port0 #(WID-1,WID+1,WID+2,WID+1) a1(
    .a1    (data_dly  ),
    .a2    (state1    ),
    .alpha (alpha1    ),
    .b1    (adp_out1_a),
    .b2    (adp_out1_b)
);

adaptor_2port1 #(WID+2,WID+4,WID+3,WID+4) a2(
    .a1    (b1        ),
    .a2    (adp_out3_a),
    .alpha (alpha2    ),
    .b1    (adp_out2_a),
    .b2    (adp_out2_b)
);

adaptor_2port2 #(WID+4,WID+3,WID+4,WID+3) a3(
    .a1    (state2    ),
    .a2    (state3    ),
    .alpha (alpha3    ),
    .b1    (adp_out3_a),
    .b2    (adp_out3_b)
);

adaptor_2port1 #(WID-1,WID+4,WID+2,WID+3) a4(
    .a1    (data_dly  ),
    .a2    (adp_out5_a),
    .alpha (alpha4    ),
    .b1    (adp_out4_a),
    .b2    (adp_out4_b)
);

adaptor_2port2 #(WID+3,WID+2,WID+4,WID+2) a5(
    .a1    (state4    ),
    .a2    (state5    ),
    .alpha (alpha5    ),
    .b1    (adp_out5_a),
    .b2    (adp_out5_b)
);

adaptor_2port1 #(WID+2,WID+5,WID+3,WID+5) a6(
    .a1    (b4        ),
    .a2    (adp_out7_a),
    .alpha (alpha6    ),
    .b1    (adp_out6_a),
    .b2    (adp_out6_b)
);

adaptor_2port2 #(WID+5,WID+4,WID+5,WID+4) a7(
    .a1    (state6    ),
    .a2    (state7    ),
    .alpha (alpha7    ),
    .b1    (adp_out7_a),
    .b2    (adp_out7_b)
);

endmodule
