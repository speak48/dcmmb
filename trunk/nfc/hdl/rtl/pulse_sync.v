module pulse_sync(
     clk         ,
     clk_2x      ,
     rst_n       ,
     
     pulse_in    ,
     pulse_out   
);

// System IF
input                  clk             ;
input                  clk_2x          ;
input                  rst_n           ;

input                  pulse_in        ;
output                 pulse_out       ;
wire                   pulse_out       ;

reg                    pulse_sync1     ;
reg                    pulse_sync2     ;

assign pulse_out  = pulse_sync2;

always @ (posedge clk_2x or negedge rst_n)
begin
    if(rst_n == 1'b0)
        pulse_sync1 <= #1 1'b0;
    else if(pulse_sync2)
        pulse_sync1 <= #1 1'b0;
    else if(pulse_in)
        pulse_sync1 <= #1 1'b1;
end

always @ (posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0)
        pulse_sync2 <= #1 1'b0;
    else
        pulse_sync2 <= #1 pulse_sync1;
end        

endmodule
