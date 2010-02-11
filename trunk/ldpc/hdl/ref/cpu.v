//////////////////////////
//
//copyright 2009, SHHIC
//all right reserved
//
//project name: hongqiao
//filename    : cpu.v
//author      : Li Gang
//date        : 2009/10/20
//version     : 0.1
//
//module name : cpu
//discription : 
//
//modification history
//---------------------------------
//&Log&
//
//////////////////////////


module cpu     (clk      ,
	        reset_n  ,
	        rate     ,
	        en_in    ,
	        din2     ,
	        din1     ,
	        
	        dout     ,
	        dout2        
	        );
	                

parameter Width_D  = 6  ;
parameter Width_A  = 5  ;

input                               reset_n  ;   
input                               clk      ;
input                               rate     ;
input                               en_in    ;
input [11 : 0]                      din2     ;
input [Width_D*12-1 : 0]            din1     ;

output[Width_D*12-1 : 0]            dout     ;
output                              dout2    ;

reg   [Width_D*12 -1 : 0]           dout     ;
reg                                 dout2    ;


reg   [Width_A-1 : 0]   comp0      [0 : 11] ;
reg   [11 : 0]          dout_temp;
reg                     en_in_d1;
reg                     en_in_d2;
reg                     en_in_d3;

reg   [Width_A-1 : 0]   comp1_1;
reg   [Width_A-1 : 0]   comp1_2;
reg   [Width_A-1 : 0]   comp1_3;
reg   [Width_A-1 : 0]   comp1_4;
reg   [Width_A-1 : 0]   comp1_5;
reg   [Width_A-1 : 0]   comp1_6;
                        
reg   [Width_A-1 : 0]   comp2_1;
reg   [Width_A-1 : 0]   comp2_2;
reg   [Width_A-1 : 0]   comp2_3;
reg   [Width_A-1 : 0]   comp2_4;
reg   [Width_A-1 : 0]   comp2_5;
reg   [Width_A-1 : 0]   comp2_6;

reg   [3 : 0]           comp3_1;
reg   [3 : 0]           comp3_2;
reg   [3 : 0]           comp3_3;
reg   [3 : 0]           comp3_4;
reg   [3 : 0]           comp3_5;
reg   [3 : 0]           comp3_6;

reg                     comp4_1;
reg                     comp4_2;
reg                     comp4_3;
reg                     comp4_4;
reg                     comp4_5;
reg                     comp4_6;
                        
reg                     comp5_1;
reg                     comp5_2;
reg                     comp5_3;
reg                     comp5_4;
reg                     comp5_5;
reg                     comp5_6;


reg   [Width_A-1 : 0]  comp1_7;
reg   [Width_A-1 : 0]  comp1_8;
reg   [Width_A-1 : 0]  comp1_9;

reg   [Width_A-1 : 0]  comp2_7;
reg   [Width_A-1 : 0]  comp2_8;
reg   [Width_A-1 : 0]  comp2_9;

reg   [3 : 0]           comp3_7;
reg   [3 : 0]           comp3_8;
reg   [3 : 0]           comp3_9;

reg                     comp4_7;
reg                     comp4_8;
reg                     comp4_9;
                       
reg                     comp5_7;
reg                     comp5_8;
reg                     comp5_9;


reg   [Width_A-1 : 0]  comp1_10;
reg   [Width_A-1 : 0]  comp1_11;

reg   [Width_A-1 : 0]  comp2_10;
reg   [Width_A-1 : 0]  comp2_11;

reg   [3 : 0]           comp3_10;
reg   [3 : 0]           comp3_11;

reg                     comp4_10;
reg                     comp4_11;
                        
reg                     comp5_10;
reg                     comp5_11;
                        
                        
reg                     comp6_1 ;
reg                     comp6_2 ;
reg                     comp6_3 ;
reg                     comp6_4 ;
reg                     comp6_5 ;
reg                     comp6_6 ;
reg                     comp6_7 ;
reg                     comp6_8 ;
reg                     comp6_9 ;
reg                     comp6_10;
reg                     comp6_11;
reg                     comp6_12;
                        
reg                     comp7_1 ;
reg                     comp7_2 ;
reg                     comp7_3 ;
reg                     comp7_4 ;
reg                     comp7_5 ;
reg                     comp7_6 ;
reg                     comp7_7 ;
reg                     comp7_8 ;
reg                     comp7_9 ;
reg                     comp7_10;
reg                     comp7_11;
reg                     comp7_12;     
                        
reg                     comp8_1 ;
reg                     comp8_2 ;
reg                     comp8_3 ;
reg                     comp8_4 ;
reg                     comp8_5 ;
reg                     comp8_6 ;
reg                     comp8_7 ;
reg                     comp8_8 ;
reg                     comp8_9 ;
reg                     comp8_10;
reg                     comp8_11;
reg                     comp8_12;

wire [Width_A-1 : 0]  com_dout0 ;
wire [Width_A-1 : 0]  com_dout1 ;
wire [Width_A-1 : 0]  com_dout2 ;
wire [Width_A-1 : 0]  com_dout3 ;
wire [Width_A-1 : 0]  com_dout4 ;
wire [Width_A-1 : 0]  com_dout5 ;
//wire [Width_A-1 : 0]  com_dout6 ;
//wire [Width_A-1 : 0]  com_dout8 ;
//wire [Width_A-1 : 0]  com_dout9 ;
//wire [Width_A-1 : 0]  com_dout10;
//wire [Width_A-1 : 0]  com_dout11;



conv u_conv0   ( .din      ( comp0[0]     ) ,
                 .dout     ( com_dout0    ));
               

conv u_conv1   ( .din      ( comp0[1]     ) ,
                 .dout     ( com_dout1    ));


conv u_conv2   ( .din      ( comp0[2]     ) ,
                 .dout     ( com_dout2    ));


conv u_conv3   ( .din      ( comp0[3]     ) ,
                 .dout     ( com_dout3    ));


conv u_conv4   ( .din      ( comp0[4]     ) ,
                 .dout     ( com_dout4    ));


conv u_conv5   ( .din      ( comp0[5]     ) ,
                 .dout     ( com_dout5    ));



always @ (posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        en_in_d1 <= 1'b0 ;
        en_in_d2 <= 1'b0 ;
        en_in_d3 <= 1'b0 ;
        comp6_1  <= 1'b0 ;
        comp7_1  <= 1'b0 ;
        comp8_1  <= 1'b0 ;
        comp6_2  <= 1'b0 ;
        comp7_2  <= 1'b0 ;
        comp8_2  <= 1'b0 ;
        comp6_3  <= 1'b0 ;
        comp7_3  <= 1'b0 ;
        comp8_3  <= 1'b0 ;  
        comp6_4  <= 1'b0 ;
        comp7_4  <= 1'b0 ;
        comp8_4  <= 1'b0 ;
        comp6_5  <= 1'b0 ;
        comp7_5  <= 1'b0 ;
        comp8_5  <= 1'b0 ;
        comp6_6  <= 1'b0 ;
        comp7_6  <= 1'b0 ;
        comp8_6  <= 1'b0 ;
        comp6_7  <= 1'b0 ;
        comp7_7  <= 1'b0 ;
        comp8_7  <= 1'b0 ;
        comp6_8  <= 1'b0 ;
        comp7_8  <= 1'b0 ;
        comp8_8  <= 1'b0 ;
        comp6_9  <= 1'b0 ;
        comp7_9  <= 1'b0 ;
        comp8_9  <= 1'b0 ;  
        comp6_10 <= 1'b0 ;
        comp7_10 <= 1'b0 ;
        comp8_10 <= 1'b0 ;
        comp6_11 <= 1'b0 ;
        comp7_11 <= 1'b0 ;
        comp8_11 <= 1'b0 ;
        comp6_12 <= 1'b0 ;
        comp7_12 <= 1'b0 ;
        comp8_12 <= 1'b0 ;                                              
    end
    else begin
        en_in_d1 <= en_in              ;
        en_in_d2 <= en_in_d1           ;
        en_in_d3 <= en_in_d2           ;
        comp6_1  <= din1[Width_D-1]    ;
        comp7_1  <= comp6_1            ;  
        comp8_1  <= comp7_1            ;  
        comp6_2  <= din1[2*Width_D-1]  ;
        comp7_2  <= comp6_2            ;   
        comp8_2  <= comp7_2            ;   
        comp6_3  <= din1[3*Width_D-1]  ;  
        comp7_3  <= comp6_3            ;  
        comp8_3  <= comp7_3            ;    
        comp6_4  <= din1[4*Width_D-1]  ;  
        comp7_4  <= comp6_4            ;  
        comp8_4  <= comp7_4            ;  
        comp6_5  <= din1[5*Width_D-1]  ;  
        comp7_5  <= comp6_5            ;  
        comp8_5  <= comp7_5            ;  
        comp6_6  <= din1[6*Width_D-1]  ;  
        comp7_6  <= comp6_6            ;  
        comp8_6  <= comp7_6            ;  
        comp6_7  <= din1[7*Width_D-1]  ;  
        comp7_7  <= comp6_7            ;  
        comp8_7  <= comp7_7            ;  
        comp6_8  <= din1[8*Width_D-1]  ;  
        comp7_8  <= comp6_8            ;  
        comp8_8  <= comp7_8            ;  
        comp6_9  <= din1[9*Width_D-1]  ;  
        comp7_9  <= comp6_9            ;  
        comp8_9  <= comp7_9            ;   
        comp6_10 <= din1[10*Width_D-1] ;  
        comp7_10 <= comp6_10           ;  
        comp8_10 <= comp7_10           ;  
        comp6_11 <= din1[11*Width_D-1] ;  
        comp7_11 <= comp6_11           ;  
        comp8_11 <= comp7_11           ;  
        comp6_12 <= din1[12*Width_D-1] ;  
        comp7_12 <= comp6_12           ;  
        comp8_12 <= comp7_12           ;  
    end
end     	
 

always @ (posedge clk or negedge reset_n) begin
    if (!reset_n) begin
    	comp0[0]  <= 5'b0 ;
    	comp0[1]  <= 5'b0 ;
    	comp0[2]  <= 5'b0 ;
    	comp0[3]  <= 5'b0 ;
    	comp0[4]  <= 5'b0 ;
    	comp0[5]  <= 5'b0 ;    	    	       
    	comp0[6]  <= 5'b0 ;
    	comp0[7]  <= 5'b0 ;
    	comp0[8]  <= 5'b0 ;
    	comp0[9]  <= 5'b0 ;
    	comp0[10] <= 5'b0 ;
    	comp0[11] <= 5'b0 ;  
    end    	
    else begin
        if ( en_in_d2) begin
            if ((comp1_8 < comp1_7) && (comp3_8 == 0) && (comp1_7 < comp2_8)) 
                comp0[0] <= comp1_7 ;
            else if ((comp1_8 < comp1_7) && (comp3_8 == 0) && (comp1_7 >= comp2_8)) 
                comp0[0] <= comp2_8 ;
            else if ((comp1_8 < comp1_7) && (comp3_8 != 0))
                comp0[0] <= comp1_8 ;
            else if ((comp1_8 >= comp1_7) && (comp3_7 == 0) && (comp1_8 < comp2_7))
                comp0[0] <= comp1_8 ; 
            else if ((comp1_8 >= comp1_7) && (comp3_7 == 0) && (comp1_8 >= comp2_7))                  
                comp0[0] <= comp2_7 ; 
            else if ((comp1_8 >= comp1_7) && (comp3_7 != 0))
                comp0[0] <= comp1_7 ;     
            
           if ((comp1_8 < comp1_7) && (comp3_8 == 1) && (comp1_7 < comp2_8))     
               comp0[1] <= comp1_7 ;
           else if ((comp1_8 < comp1_7) && (comp3_8 == 1) && (comp1_7 >= comp2_8)) 
               comp0[1] <= comp2_8 ;
           else if ((comp1_8 < comp1_7) && (comp3_8 != 1))
               comp0[1] <= comp1_8 ;
           else if ((comp1_8 >= comp1_7) && (comp3_7 == 1) && (comp1_8 < comp2_7))
               comp0[1] <= comp1_8 ; 
           else if ((comp1_8 >= comp1_7) && (comp3_7 == 1) && (comp1_8 >= comp2_7))                  
               comp0[1] <= comp2_7 ; 
           else if ((comp1_8 >= comp1_7) && (comp3_7 != 1))
               comp0[1] <= comp1_7 ;  
                
           if ((comp1_8 < comp1_7) && (comp3_8 == 2) && (comp1_7 < comp2_8))     
               comp0[2] <= comp1_7 ;
           else if ((comp1_8 < comp1_7) && (comp3_8 == 2) && (comp1_7 >= comp2_8)) 
               comp0[2] <= comp2_8 ;
           else if ((comp1_8 < comp1_7) && (comp3_8 != 2))
               comp0[2] <= comp1_8 ;
           else if ((comp1_8 >= comp1_7) && (comp3_7 == 2) && (comp1_8 < comp2_7))
               comp0[2] <= comp1_8 ; 
           else if ((comp1_8 >= comp1_7) && (comp3_7 == 2) && (comp1_8 >= comp2_7))                  
               comp0[2] <= comp2_7 ; 
           else if ((comp1_8 >= comp1_7) && (comp3_7 != 2))
               comp0[2] <= comp1_7 ;                                                                                              

           if ((comp1_8 < comp1_7) && (comp3_8 == 3) && (comp1_7 < comp2_8))     
               comp0[3] <= comp1_7 ;
           else if ((comp1_8 < comp1_7) && (comp3_8 == 3) && (comp1_7 >= comp2_8)) 
               comp0[3] <= comp2_8 ;
           else if ((comp1_8 < comp1_7) && (comp3_8 != 3))
               comp0[3] <= comp1_8 ;
           else if ((comp1_8 >= comp1_7) && (comp3_7 == 3) && (comp1_8 < comp2_7))
               comp0[3] <= comp1_8 ; 
           else if ((comp1_8 >= comp1_7) && (comp3_7 == 3) && (comp1_8 >= comp2_7))                  
               comp0[3] <= comp2_7 ; 
           else if ((comp1_8 >= comp1_7) && (comp3_7 != 3))
               comp0[3] <= comp1_7 ; 
                 
           if ((comp1_8 < comp1_7) && (comp3_8 == 4) && (comp1_7 < comp2_8))     
               comp0[4] <= comp1_7 ;
           else if ((comp1_8 < comp1_7) && (comp3_8 == 4) && (comp1_7 >= comp2_8)) 
               comp0[4] <= comp2_8 ;
           else if ((comp1_8 < comp1_7) && (comp3_8 != 4))
               comp0[4] <= comp1_8 ;
           else if ((comp1_8 >= comp1_7) && (comp3_7 == 4) && (comp1_8 < comp2_7))
               comp0[4] <= comp1_8 ; 
           else if ((comp1_8 >= comp1_7) && (comp3_7 == 4) && (comp1_8 >= comp2_7))                  
               comp0[4] <= comp2_7 ; 
           else if ((comp1_8 >= comp1_7) && (comp3_7 != 4))
               comp0[4] <= comp1_7 ;  

           if ((comp1_8 < comp1_7) && (comp3_8 == 5) && (comp1_7 < comp2_8))     
               comp0[5] <= comp1_7 ;
           else if ((comp1_8 < comp1_7) && (comp3_8 == 5) && (comp1_7 >= comp2_8)) 
               comp0[5] <= comp2_8 ;
           else if ((comp1_8 < comp1_7) && (comp3_8 != 5))
               comp0[5] <= comp1_8 ;
           else if ((comp1_8 >= comp1_7) && (comp3_7 == 5) && (comp1_8 < comp2_7))
               comp0[5] <= comp1_8 ; 
           else if ((comp1_8 >= comp1_7) && (comp3_7 == 5) && (comp1_8 >= comp2_7))                  
               comp0[5] <= comp2_7 ; 
           else if ((comp1_8 >= comp1_7) && (comp3_7 != 5))
               comp0[5] <= comp1_7 ;    
        end
	               
    end  
end


always @ (posedge clk or negedge reset_n) begin
    if (!reset_n) 
        dout2 <= 1'b0 ;
    else
        if (en_in_d2 )
            dout2 <= comp5_7 ^ comp5_8;

end

always @ (posedge clk or negedge reset_n) begin
    if (!reset_n) 
    	dout_temp <= 12'b0 ;
    else begin
        if (en_in_d2 ) begin
            dout_temp[0] <= comp4_7 ^ comp4_8 ^ comp7_1 ;
            dout_temp[1] <= comp4_7 ^ comp4_8 ^ comp7_2 ;
            dout_temp[2] <= comp4_7 ^ comp4_8 ^ comp7_3 ;
            dout_temp[3] <= comp4_7 ^ comp4_8 ^ comp7_4 ;
            dout_temp[4] <= comp4_7 ^ comp4_8 ^ comp7_5 ;
            dout_temp[5] <= comp4_7 ^ comp4_8 ^ comp7_6 ;
        end
    end
end

always @ (posedge clk or negedge reset_n) begin
    if (!reset_n) begin
    	comp1_1  <= 5'b0 ;
    	comp1_2  <= 5'b0 ;
    	comp1_3  <= 5'b0 ;
    	comp1_4  <= 5'b0 ;
    	comp1_5  <= 5'b0 ;
    	comp1_6  <= 5'b0 ;    	
    	comp3_1  <= 4'b0 ;
    	comp3_2  <= 4'b0 ; 
    	comp3_3  <= 4'b0 ;
    	comp3_4  <= 4'b0 ;
    	comp3_5  <= 4'b0 ;
    	comp3_6  <= 4'b0 ;      	 
    	comp2_1  <= 5'b0 ; 	
        comp2_2  <= 5'b0 ;
    	comp2_3  <= 5'b0 ;
    	comp2_4  <= 5'b0 ;
    	comp2_5  <= 5'b0 ;
    	comp2_6  <= 5'b0 ;          	   
        comp4_1  <= 1'b0 ;
        comp4_2  <= 1'b0 ;
    	comp4_3  <= 1'b0 ;
    	comp4_4  <= 1'b0 ;
    	comp4_5  <= 1'b0 ;
    	comp4_6  <= 1'b0 ;          
        comp5_1 <= 1'b0 ;
        comp5_2 <= 1'b0 ;
    	comp5_3 <= 1'b0 ;
    	comp5_4 <= 1'b0 ;
    	comp5_5 <= 1'b0 ;
    	comp5_6 <= 1'b0 ;          
      end 
    else begin
    	if (en_in) begin
    	    if (din1[2*Width_D-2 : Width_D] < din1[Width_D-2 : 0]) begin
    	        comp1_1 <= din1[2*Width_D-2 : Width_D] ;
    	        comp3_1 <= 4'd1 ;
    	        comp2_1 <= din1[Width_D-2 : 0];
    	    end
    	    else begin
    	        comp1_1 <= din1[Width_D-2 : 0] ;
    	        comp3_1 <= 4'd0 ;
    	        comp2_1 <= din1[2*Width_D-2 : Width_D];
    	    end
    	    
    	    if (din1[4*Width_D-2 : 3*Width_D] < din1[3*Width_D-2 : 2*Width_D]) begin
    	        comp1_2 <= din1[4*Width_D-2 : 3*Width_D] ;
    	        comp3_2 <= 4'd3 ;
    	        comp2_2 <= din1[3*Width_D-2 : 2*Width_D];
    	    end
    	    else begin
    	        comp1_2 <= din1[3*Width_D-2 : 2*Width_D] ;
    	        comp3_2 <= 4'd2 ;
    	        comp2_2 <= din1[4*Width_D-2 : 3*Width_D];
    	    end
    	    
    	    if (din1[6*Width_D-2 : 5*Width_D] < din1[5*Width_D-2 : 4*Width_D]) begin
    	        comp1_3 <= din1[6*Width_D-2 : 5*Width_D] ;
    	        comp3_3 <= 4'd5 ;
    	        comp2_3 <= din1[5*Width_D-2 : 4*Width_D];
    	    end
    	    else begin
    	        comp1_3 <= din1[5*Width_D-2 : 4*Width_D] ;
    	        comp3_3 <= 4'd4 ;
    	        comp2_3 <= din1[6*Width_D-2 : 5*Width_D];
    	    end

    	    comp4_1 <= din1[2*Width_D-1] ^ din1[Width_D-1] ;
    	    comp5_1 <= din2[1] ^ din2[0] ;
    	    comp4_2 <= din1[4*Width_D-1] ^ din1[3*Width_D-1] ;
    	    comp5_2 <= din2[3] ^ din2[2] ;
    	    comp4_3 <= din1[6*Width_D-1] ^ din1[5*Width_D-1] ;
    	    comp5_3 <= din2[5] ^ din2[4] ;    	    
    	        	    
    	    comp1_4  <= 5'b11111 ;
    	    comp1_5  <= 5'b11111 ;
    	    comp1_6  <= 5'b11111 ;    	    
    	    comp3_4  <= 4'b1111 ;
    	    comp3_5  <= 4'b1111 ;
    	    comp3_6  <= 4'b1111 ;
    	    comp2_4  <= 5'b11111 ;
    	    comp2_5  <= 5'b11111 ;
    	    comp2_6  <= 5'b11111 ;
    	    comp4_4  <= 1'b1 ;
    	    comp4_5  <= 1'b1 ;
    	    comp4_6  <= 1'b1 ;
    	    comp5_4  <= 1'b1 ;
    	    comp5_5  <= 1'b1 ;
    	    comp5_6  <= 1'b1 ;
    	end  			        	    
    end	
end    

always @ (posedge clk or negedge reset_n) begin
    if (!reset_n) begin
    	comp1_7  <= 5'b0 ;
    	comp1_8  <= 5'b0 ;
    	comp1_9  <= 5'b0 ;
    	comp3_7  <= 4'b0 ;
    	comp3_8  <= 4'b0 ;
    	comp3_9  <= 4'b0 ;  
    	comp2_7  <= 5'b0 ; 	
        comp2_8  <= 5'b0 ;	   
        comp2_9  <= 5'b0 ;    	
        comp4_7  <= 1'b0 ;
        comp4_8  <= 1'b0 ;
        comp4_9  <= 1'b0 ;
        comp5_7 <= 1'b0 ;
        comp5_8 <= 1'b0 ;
        comp5_9 <= 1'b0 ;
    end 
    else begin
    	if (en_in_d1) begin
    	    if ((comp1_2 < comp1_1) && (comp1_1 < comp2_2)) begin
    	        comp1_7 <= comp1_2 ;
    	        comp3_7 <= comp3_2 ;
    	        comp2_7 <= comp1_1 ;
    	    end
    	    else if ((comp1_2 < comp1_1) && (comp1_1 >= comp2_2)) begin  
    	        comp1_7 <= comp1_2 ;
    	        comp3_7 <= comp3_2 ;
    	        comp2_7 <= comp2_2 ;  
    	    end
    	    else if ((comp1_2 >= comp1_1) && (comp1_2 < comp2_1)) begin     	       
    	        comp1_7 <= comp1_1 ;
    	        comp3_7 <= comp3_1 ;
    	        comp2_7 <= comp1_2 ;  
    	    end
    	    else if ((comp1_2 >= comp1_1) && (comp1_2 >= comp2_1)) begin  	    	
    	        comp1_7 <= comp1_1 ;
    	        comp3_7 <= comp3_1 ;
    	        comp2_7 <= comp2_1 ;  
    	    end
    	    
    	    comp1_8 <= comp1_3;
            comp3_8 <= comp3_3;
            comp2_8 <= comp2_3;
    	    comp4_7 <= comp4_1 ^ comp4_2 ;
    	    comp5_7 <= comp5_1 ^ comp5_2 ;
    	    comp4_8 <= comp4_3 ;
    	    comp5_8 <= comp5_3 ;
    	    comp1_9  <= 5'b11111 ;
    	    comp3_9  <= 4'b1111 ;   
            comp2_9  <= 5'b11111 ; 
            comp4_9  <= 1'b1 ;
            comp5_9  <= 1'b1 ; 
    	end		  	            	
    end
end

always @ (posedge clk or negedge reset_n) begin
    if (!reset_n) begin
    	comp1_10     <= 5'b0 ;
    	comp1_11     <= 5'b0 ;
    	comp3_10  <= 4'b0 ;
    	comp3_11  <= 4'b0 ;   
    	comp2_10  <= 5'b0 ; 	
        comp2_11  <= 5'b0 ;	   
        comp4_10  <= 1'b0 ;
        comp4_11  <= 1'b0 ;
        comp5_10 <= 1'b0 ;
        comp5_11 <= 1'b0 ;
    end 
    else begin

    	if (en_in_d2) begin
    	    if ((comp1_8 < comp1_7) && (comp1_7 < comp2_8)) begin
    	    	comp1_10 <= comp1_8 ;
    	    	comp3_10 <= comp3_8 ;
    	    	comp2_10 <= comp1_7 ;
    	    end
    	    else if ((comp1_8 < comp1_7) && (comp1_7 >= comp2_8)) begin
    	    	comp1_10 <= comp1_8 ;
    	    	comp3_10 <= comp3_8 ;
    	    	comp2_10 <= comp2_8 ;
    	    end 
	    else if ((comp1_8 >= comp1_7) && (comp1_8 < comp2_7)) begin
	        comp1_10 <= comp1_7;
	        comp3_10 <= comp3_7;
	        comp2_10 <= comp1_8;  
	    end 
	    else if ((comp1_8 >= comp1_7) && (comp1_8 >= comp2_7)) begin  
		comp1_10 <= comp1_7;      	    	   	       	    	
		comp3_10 <= comp3_7;    	  
		comp2_10 <= comp2_7;
	    end
	    
	    comp1_11 <= comp1_9 ;
	    comp3_11 <= comp3_9 ;
	    comp2_11 <= comp2_9 ;	    
	    comp4_10 <= comp4_7 ^ comp4_8 ;
	    comp5_10 <= comp5_7 ^ comp5_8 ;
	    comp4_11 <= comp4_9 ;
	    comp5_11 <= comp5_9 ;
	end
    end
end



always @( * ) begin
    	dout[Width_D-2 : 0]                 <= com_dout0    ;
    	dout[2 * Width_D-2 : Width_D]       <= com_dout1    ;
    	dout[3 * Width_D-2 : 2 * Width_D]   <= com_dout2    ;
    	dout[4 * Width_D-2 : 3 * Width_D]   <= com_dout3    ;
    	dout[5 * Width_D-2 : 4 * Width_D]   <= com_dout4    ; 
    	dout[6 * Width_D-2 : 5 * Width_D]   <= com_dout5    ;
        dout[Width_D-1]                     <= dout_temp[0 ];
        dout[2 * Width_D-1]                 <= dout_temp[1 ];
        dout[3 * Width_D-1]                 <= dout_temp[2 ];
        dout[4 * Width_D-1]                 <= dout_temp[3 ];
        dout[5  * Width_D-1]                <= dout_temp[4 ];        
        dout[6  * Width_D-1]                <= dout_temp[5 ];
    	dout[7 * Width_D-2 : 6 * Width_D]   <= 5'b0         ;
    	dout[8 * Width_D-2 : 7 * Width_D]   <= 5'b0         ;
    	dout[9 * Width_D-2 : 8 * Width_D]   <= 5'b0         ; 
    	dout[10 * Width_D-2 : 9 * Width_D]  <= 5'b0         ; 
    	dout[11 * Width_D-2 : 10 * Width_D] <= 5'b0         ;    	   	   	    	
    	dout[12 * Width_D-2 : 11 * Width_D] <= 5'b0         ;             	    	
        dout[7  * Width_D-1]                <= 1'b0         ; 
        dout[8  * Width_D-1]                <= 1'b0         ; 
        dout[9  * Width_D-1]                <= 1'b0         ; 
        dout[10 * Width_D-1]                <= 1'b0         ; 
        dout[11 * Width_D-1]                <= 1'b0         ; 
        dout[12 * Width_D-1]                <= 1'b0         ;     	

end   	
    	
endmodule

