module bit2byte(
      clk           ,
      reset_n       ,
      ldpc_en_out   ,
      ldpc_dout     ,
      ts0_win,      ,
      ts1_win,      ,

      byte_sync     ,
      byte_data     ,
      byte_win0     ,
      byte_win1     
);

//inputs
input            clk           ;
input            reset_n       ;
input            ldpc_en_out   ;
input            ldpc_dout     ;
input            ts0_win       ;
input            ts1_win       ;

output           byte_sync     ;
output  [7:0]    byte_data     ;
output           byte_win0     ;
output           byte_win1     ;

reg     [2:0]    counter       ;
reg     [7:0]    byte_data     ;
reg              byte_sync     ;
reg              byte_win0     ;
reg              byte_win1     ;

always @ (posedge clk or negedge reset_n)
begin
    if(!reset_n)
        counter <= #1 3'b0;
    else if(ldpc_en_out & (ts0_win | ts1_win) )
	counter <= #1 counter + 1'b1;
//    else
//	counter <= #1 3'b0;
end

always @ (posedge clk or negedge reset_n)
begin
    if(!reset_n)
        byte_data <= #1 8'h0;
    else if(ldpc_en_out)
        byte_data <= #1 {ldpc_dout, byte_data[7:1]};
//    else
//        byte_data <= #1 8'h0;	    
end

always @ (posedge clk or negedge reset_n)
begin
     if(!reset_n)
         byte_sync <= #1 1'b0;
     else if(counter == 3'b111)
         byte_sync <= #1 1'b1;
     else
         byte_sync <= #1 1'b0;
end

always @ (posedge clk or negedge reset_n) 
begin
     if(!reset_n)
         byte_win0 <= #1 1'b0;
     else if(!ts0_win)
         byte_win0 <= #1 1'b0;
     else if(counter === 3'b111)
         byte_win0 <= #1 1'b1;
end

always @ (posedge clk or negedge reset_n) 
begin
     if(!reset_n)
         byte_win1 <= #1 1'b0;
     else if(!ts1_win)
         byte_win1 <= #1 1'b0;
     else if(counter === 3'b111)
         byte_win1 <= #1 1'b1;
end

endmodule
