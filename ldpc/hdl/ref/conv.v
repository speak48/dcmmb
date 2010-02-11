module conv (din   ,
             dout       
            );
    
parameter Width_D = 5  ;
    
input [Width_D-1 : 0]  din      ;
output[Width_D-1 : 0]  dout  ;
reg   [Width_D-1 : 0]  dout  ;
    
always @ (din) begin
    case(din)
    5'd0 : dout <= 5'd0 ;
    5'd1 : dout <= 5'd1 ;
    5'd2 : dout <= 5'd2 ;
    5'd3 : dout <= 5'd2 ;
    5'd4 : dout <= 5'd3 ;
    5'd5 : dout <= 5'd4 ;
    5'd6 : dout <= 5'd5 ;
    5'd7 : dout <= 5'd6 ;
    5'd8 : dout <= 5'd6 ;
    5'd9 : dout <= 5'd7 ;
    5'd10: dout <= 5'd8 ; 
    5'd11: dout <= 5'd9 ;
    5'd12: dout <= 5'd10;
    5'd13: dout <= 5'd10;
    5'd14: dout <= 5'd11;
    5'd15: dout <= 5'd12;
    5'd16: dout <= 5'd13;
    5'd17: dout <= 5'd14;
    5'd18: dout <= 5'd14;
    5'd19: dout <= 5'd15;
    5'd20: dout <= 5'd16;
    5'd21: dout <= 5'd17;
    5'd22: dout <= 5'd18;
    5'd23: dout <= 5'd18;
    5'd24: dout <= 5'd19;
    5'd25: dout <= 5'd20;
    5'd26: dout <= 5'd21;
    5'd27: dout <= 5'd22;
    5'd28: dout <= 5'd22;
    5'd29: dout <= 5'd23;
    5'd30: dout <= 5'd24;
    5'd31: dout <= 5'd25;
    endcase
end

endmodule

