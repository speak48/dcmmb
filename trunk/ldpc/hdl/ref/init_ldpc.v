//////////////////////////
//
//copyright 2009, SHHIC
//all right reserved
//
//project name: hongqiao
//filename    : init_ldpc.v
//author      : Li Gang
//date        : 2009/10/20
//version     : 0.1
//
//module name : init_ldpc
//discription : 
//
//modification history
//---------------------------------
//&Log&
//
//////////////////////////

module init_ldpc (
                 clk      ,
	         reset_n  ,
	         en_in    ,
	         din      ,
	         
	         init_a   ,
	         en_out   ,
	         dout   
	        );	 


input               clk        ;                
input	            reset_n    ;
input	            en_in      ;
input[5:0]          din        ;
                               
output              init_a     ;
output[215 : 0]     dout       ; 
output              en_out     ;
                               
reg                 en_out     ;

reg                 din_a      ;
reg                 en_in_d1   ; 
reg                 en_in_d2   ;
reg   [5:0]         din_d1     ; 
reg   [5:0]         din_d2     ;
reg   [5:0]         count      ;
reg   [215  : 0]    dout       ;

assign init_a = din_a ;

always @( posedge clk or negedge reset_n ) begin
    if ( !reset_n ) 
        count <= 0 ;
    else
        if (din_a)
            count <= 0 ;
        else if (en_in_d2)
        begin
            if (count == 35)
                count <= 0;
            else
                count <= count + 1'b1 ;
        end  
end  

always @( posedge clk or negedge reset_n ) begin
    if ( !reset_n ) 
        en_out <= 1'b0 ;
    else if ((count == 35) && en_in_d2)
        en_out <= 1'b1 ;
    else
        en_out <= 1'b0 ;
end
            
always @( posedge clk or negedge reset_n ) begin
    if ( !reset_n ) 
        dout <= 0 ;
    else 
        if (din_a)
            dout <= 0 ;
        else if (en_in_d2)
            begin
                dout[215 : 210] <= din_d2;       
                dout[209 : 0] <= dout[215 : 6];    
            end  
end

always @ (posedge clk or negedge reset_n)
if(!reset_n)
    begin
         en_in_d1 <= 1'b0;
         en_in_d2 <= 1'b0;
         din_a <= 1'b0;
         din_d1<=6'd0;
         din_d2<=6'd0;
    end
else
    begin
         din_d1<=din;	
         din_d2 <= din_d1;
         en_in_d1 <= en_in;
         en_in_d2 <= en_in_d1;
         
         if(en_in && !en_in_d1)
             din_a <= 1'b1;
         else
             din_a <= 1'b0;
    end


endmodule

