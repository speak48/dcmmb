//////////////////////////
//
//copyright 2009, SHHIC
//all right reserved
//
//project name: hongqiao
//filename    : vpu.v
//author      : Li Gang
//date        : 2009/10/20
//version     : 0.1
//
//module name : vpu
//discription : 
//
//modification history
//---------------------------------
//&Log&
//
//////////////////////////

module vpu (
            clk          ,
	    reset_n      ,
	    rate         ,                  
	    init_a       ,
	    init_en_out  ,
	    cpu_a        ,               
            vpu_a        ,
            cpu_en_out   ,
	    dec_a        ,
	    dec_b        ,
	    dec_addr     ,
	    dec_en_addr  ,                                                   
            vpu_dint     ,
            vpu_din      ,
            lram_dout    ,
                     
	    dec_din      ,
	    dec_en_in    ,
            vpu_dout     ,
            ram_addr     ,
            lram_addr    ,                   
            vpu_dout2  
            );
                        
                        

parameter Width_D    = 6  ;



input                            clk           ;                        
input                            reset_n       ;
input                            rate          ;
input                            init_a        ;
input                            init_en_out   ;       
input                            dec_a         ;
input                            dec_b         ;   
input                            dec_en_addr   ;
input   [7 : 0]                  dec_addr      ;
input                            cpu_a         ;
input                            vpu_a         ; 
input                            cpu_en_out    ;
input  [23 : 0]                  vpu_dint      ;
input  [3*Width_D-1 : 0]         vpu_din       ;
input  [Width_D : 0]             lram_dout     ;
                                          
output                           dec_din       ;   
output                           dec_en_in     ;
output [3*Width_D-1 : 0]         vpu_dout      ;
output [23 : 0]                  ram_addr      ;
output [7 : 0]                   lram_addr     ;                                             
output                           vpu_dout2     ;
   
reg                              dec_en_in     ;
reg     [7 : 0]                  lram_addr     ;
reg                              vpu_dout2     ;

reg                              ram_wren      ;
reg                              lram_wren     ;
reg    [Width_D-1 : 0]           vpu_dout_p0   ;
reg    [Width_D-1 : 0]           vpu_dout_p1   ;
reg    [Width_D-1 : 0]           vpu_dout_p2   ;
reg    [7 : 0]                   ram_addr0     ;
reg    [7 : 0]                   ram_addr1     ;
reg    [7 : 0]                   ram_addr2     ;
reg    [4 : 0]                   curstate      ;
reg    [4 : 0]                   nextstate     ;
reg    [7 : 0]                   att_1         ;
reg    [7 : 0]                   att_2         ;
reg    [7 : 0]                   att_3         ;
reg                              cpu_b_i       ;
reg                              vpu_b_i       ;

                                             
reg    [7 : 0]                   count1        ;
reg    [7 : 0]                   count2        ;                                               
reg    signed [Width_D+1 : 0]    p0            ;
reg    signed [Width_D+1 : 0]    p1            ;
reg    signed [Width_D+1 : 0]    p2            ;                                                
reg    signed [Width_D+1 : 0]    ppp0          ;
reg    signed [Width_D+1 : 0]    ppp1          ;
reg    signed [Width_D+1 : 0]    ppp2          ;
reg                              vpu_wren      ;
reg                              vpu_wren_reg  ;
reg                              vpu_wren_reg2 ;
reg                              dec_en_addr_d ; 
  

wire   [7 : 0]                   vpu_dint0     ;
wire   [7 : 0]                   vpu_dint1     ;
wire   [7 : 0]                   vpu_dint2     ;
wire   [Width_D-1:0]             vpu_din0      ;
wire   [Width_D-1:0]             vpu_din1      ;
wire   [Width_D-1:0]             vpu_din2      ;




wire   signed [Width_D-1 : 0]    vpu_din0f     ;
wire   signed [Width_D-1 : 0]    vpu_din1f     ;
wire   signed [Width_D-1 : 0]    vpu_din2f     ;
wire   signed [Width_D   : 0]    pp0           ;
wire   signed [Width_D   : 0]    pp1           ;
wire   signed [Width_D   : 0]    pp2           ;
wire   signed [Width_D-1 : 0]    lram_dout_p1  ;
wire   signed [Width_D+1 : 0]    sum_a         ;



parameter state1   = 5'b00001,
          state2   = 5'b00010,
          state3   = 5'b00100, 
          state4   = 5'b01000,
          state5   = 5'b10000;



          
assign    pp0 = p0[Width_D : 0];
assign    pp1 = p1[Width_D : 0];
assign    pp2 = p2[Width_D : 0];

assign    vpu_din0f = ff1(vpu_din0);
assign    vpu_din1f = ff1(vpu_din1);    
assign    vpu_din2f = ff1(vpu_din2);

assign    lram_dout_p1 = lram_dout[Width_D-1 : 0];  
assign    dec_din = lram_dout[Width_D];
assign    sum_a = lram_dout_p1 + vpu_din0f +  vpu_din1f +  vpu_din2f ;
assign    ram_addr   = {ram_addr2,ram_addr1, ram_addr0}; 
assign    vpu_dout = {vpu_dout_p2, vpu_dout_p1, vpu_dout_p0};

assign    vpu_din0 = vpu_din[Width_D-1:0];
assign    vpu_din1 = vpu_din[2*Width_D-1:Width_D];                        
assign    vpu_din2 = vpu_din[3*Width_D-1:2*Width_D];
 

assign    vpu_dint0 = vpu_dint[7 : 0]   ;
assign    vpu_dint1 = vpu_dint[15 : 8]  ;
assign    vpu_dint2 = vpu_dint[23 : 16] ;

always @( posedge clk or negedge reset_n ) begin
    if ( !reset_n ) 
        curstate <= state1;
    else
        curstate <= nextstate;
end

always @( *) begin
    case ( curstate ) 
        state1:  
            if(init_a) 
                nextstate = state2;
	    else  
	        nextstate = curstate; 
        state2:  
            if(cpu_a)  
                nextstate = state3;
            else               
                nextstate = curstate; 
        state3: 
            if(dec_a)  
                nextstate = state5; 
            else if ( vpu_a) 
                nextstate = state4;
            else    
                nextstate = curstate; 
        state4:  
            if(cpu_a)
                nextstate = state3;
	    else   
	        nextstate = curstate; 
        state5:  
            if(dec_b) 
                nextstate = state1;             
            else            
                nextstate = curstate; 
	default:  
	        nextstate = curstate; 
    endcase
end 

always @ (posedge clk or negedge reset_n) begin
    if (!reset_n) begin
    	vpu_dout2 <= 1'b0 ;
    	p0  <= 8'b0 ;
    	p1  <= 8'b0 ;
        p2  <= 8'b0 ;
    end
    else begin
        vpu_dout2 <= sum_a[Width_D+1];
	p0 <= lram_dout_p1 +  vpu_din1f + vpu_din2f;
	p1 <= lram_dout_p1 +  vpu_din0f + vpu_din2f;
	p2 <= lram_dout_p1 +  vpu_din0f + vpu_din1f;     
    end
end  
            
always @ ( * ) begin	
    if (!p0[Width_D+1]) 
        ppp0 <= p0 ;
    else begin
        ppp0[Width_D + 1] <=   p0[Width_D + 1] ;
        ppp0[Width_D : 0] <= - pp0 ;
    end

    if (!p1[Width_D+1]) 
        ppp1 <= p1 ;
    else begin
        ppp1[Width_D + 1] <=   p1[Width_D + 1] ;
        ppp1[Width_D : 0] <= - pp1 ;
    end    
    
    if (!p2[Width_D+1]) 
        ppp2 <= p2 ;
    else begin
        ppp2[Width_D + 1] <=   p2[Width_D + 1] ;
        ppp2[Width_D : 0] <= - pp2 ;
    end    
end

always @( posedge clk or negedge reset_n ) begin
    if ( !reset_n ) 
        lram_wren <= 1'b0 ;
    else
        if (curstate[0] && init_a)
            lram_wren <= 1'b0 ;
        else if (curstate[1])
            lram_wren <= init_en_out ;
        else if (curstate[3])
            lram_wren <= vpu_wren_reg2 ;
end   

always @( posedge clk or negedge reset_n ) begin
    if ( !reset_n ) begin
    	vpu_wren      <= 1'b0 ;
    	vpu_wren_reg  <= 1'b0 ;
    	vpu_wren_reg2 <= 1'b0 ;
    end
    else begin
        vpu_wren_reg  <= vpu_wren    ;
	vpu_wren_reg2 <= vpu_wren_reg;  
        if (curstate[1] && cpu_a)
            vpu_wren <= 1'b0 ;	
        else if (curstate[2] && (vpu_a))  	 
            vpu_wren <= 1'b1 ;
        else if (curstate[3] && (cpu_a | (count1 ==255)))
            vpu_wren <= 1'b0 ;
    end
end 


always @( posedge clk or negedge reset_n ) begin
    if ( !reset_n ) begin
        lram_addr <=    0 ;
    end
    else begin
    	case(curstate)
    	5'd1: begin
    	    if (init_a) begin
    	        lram_addr <= 0 ;
    	    end
    	end
    	5'd2: begin
    	    if (lram_wren && (lram_addr == 255)) 
    	        lram_addr <=  0 ;   	       
    	    else if (lram_wren)
    	        lram_addr <= lram_addr + 1'b1 ;
    	end
    	5'd4 : begin
    	    if (vpu_a)
    	        lram_addr <= att_2;
    	end
    	5'd8 : begin
    	    if (lram_addr == 255)
    	        lram_addr <= 0 ;
    	    else
    	        lram_addr <= lram_addr + 1'b1; 
    	end
    	5'd16: begin
    	    lram_addr <= ff3(dec_addr,(att_2 + att_3)); 
    	end
		default: begin
		end
        endcase
    end
end		


always @( posedge clk or negedge reset_n ) begin
    if ( !reset_n ) begin
    	vpu_dout_p0 <= 6'd0 ;
    	vpu_dout_p1 <= 6'd0 ;
    	vpu_dout_p2 <= 6'd0 ;
    end
    else begin
        if (curstate[3]) 
            begin
                 vpu_dout_p0[Width_D-1] <= ppp0[Width_D+1];
                 if ( ppp0[ Width_D : Width_D-1] == 0)
                     vpu_dout_p0[Width_D-2 : 0] <= ppp0[Width_D-2 : 0];
                 else
                     vpu_dout_p0[Width_D-2 : 0] <= 5'h1f;
                 
                 vpu_dout_p1[Width_D-1] <= ppp1[Width_D+1];
                 if ( ppp1[ Width_D : Width_D-1] == 0)
                     vpu_dout_p1[Width_D-2 : 0] <= ppp1[Width_D-2 : 0];
                 else
                     vpu_dout_p1[Width_D-2 : 0] <= 5'h1f;
                     
                 vpu_dout_p2[Width_D-1] <= ppp2[Width_D+1];
                 if ( ppp2[ Width_D : Width_D-1] == 0)
                     vpu_dout_p2[Width_D-2 : 0] <= ppp2[Width_D-2 : 0];
                 else
                     vpu_dout_p2[Width_D-2 : 0] <= 5'h1f;                               

           end
    end
end
                    

always @( posedge clk or negedge reset_n ) begin
    if ( !reset_n ) begin
    	ram_wren     <= 1'b0;     
    	ram_addr0 <= 8'b0 ;
    	ram_addr1 <= 8'b0 ;
    	ram_addr2 <= 8'b0 ;    
    end
    else begin
    	case(curstate)
    	5'd1: begin
    	    if (init_a) begin
    	        ram_wren  <= 1'b0 ;
    	    	ram_addr0 <= 8'b0 ;
    	        ram_addr1 <= 8'b0 ;
    	        ram_addr2 <= 8'b0 ;  
    	    end
    	end
    	5'd2: begin                       
    	    ram_wren  <= init_en_out ;
    	    if (ram_wren && (ram_addr0 == 255)) 
    	        ram_addr0 <=  8'b0 ;   	       
    	    else if (ram_wren)
    	        ram_addr0 <= ram_addr0 + 1'b1 ;
    	    else if (cpu_a)    
                ram_addr0 <= ff3( vpu_dint0, att_1);
                
    	    if (ram_wren && (ram_addr1 == 255)) 
    	        ram_addr1 <=  8'b0 ;   	       
    	    else if (ram_wren)
    	        ram_addr1 <= ram_addr1 + 1'b1 ;
    	    else if (cpu_a)    
                ram_addr1 <= ff3( vpu_dint1, att_1);    	        

    	    if (ram_wren && (ram_addr2 == 255)) 
    	        ram_addr2 <=  8'b0 ;   	       
    	    else if (ram_wren)
    	        ram_addr2 <= ram_addr2 + 1'b1 ; 
    	    else if (cpu_a)    
                ram_addr2 <= ff3( vpu_dint2, att_1);   	           	            	            	        
    	end
    	5'd4 : begin                       
    	    ram_wren <= cpu_en_out;
    	    if (vpu_a) begin
    	    	ram_addr0 <= att_1;    
    	    	ram_addr1 <= att_1;
    	    	ram_addr2 <= att_1;
    	    end
    	    else begin
    	        if (ram_addr0 ==  255) 
    	            ram_addr0<= 8'b0 ;
    	        else     
    	            ram_addr0<= ram_addr0 + 1'b1;
    	            
    	        if (ram_addr1 ==  255) 
    	            ram_addr1<= 8'b0 ;
    	        else
    	            ram_addr1<= ram_addr1 + 1'b1;
    	            
    	        if (ram_addr2 ==  255) 
    	            ram_addr2<= 8'b0 ;
    	        else
    	            ram_addr2<= ram_addr2 + 1'b1;   
    	    end 	          	        
    	end
    	5'd8 : begin                   
    	    ram_wren <= vpu_wren_reg2;
    	    if (cpu_a) begin
    	    	ram_addr0 <= ff3( vpu_dint0, att_1);   
    	    	ram_addr1 <= ff3( vpu_dint1, att_1);
    	    	ram_addr2 <= ff3( vpu_dint2, att_1);
    	    end	
    	    else begin	
    	        if (ram_addr0 ==  255) 
    	            ram_addr0<= 8'b0 ;
    	        else     
    	            ram_addr0<= ram_addr0 + 1'b1;
    	            
    	        if (ram_addr1 ==  255) 
    	            ram_addr1<= 8'b0 ;
    	        else     
    	            ram_addr1<= ram_addr1 + 1'b1;  
    	            
    	        if (ram_addr2 ==  255) 
    	            ram_addr2 <= 8'b0 ;
    	        else     
    	            ram_addr2 <= ram_addr2 + 1'b1;   
    	    end 	          	        
    	end
		default: begin
		end
        endcase
    end
end		
        	        

always @( posedge clk or negedge reset_n ) begin
    if ( !reset_n )
        count1 <= 8'b0 ;
    else begin
        if (curstate[1] && cpu_a)
            count1 <= 8'b0 ;
        else if (curstate[2]) begin
            if (vpu_a)
                count1 <= 8'b0 ;
            else if (count1 == 255)
                count1 <= 8'b0 ;
            else
                count1 <= count1 + 1'b1 ;
        end
        if (curstate[3]) begin
            if (cpu_a)
                count1 <= 8'b0 ;
            else if (count1 == 255)
                count1 <= 8'b0 ;
            else
                count1 <= count1 + 1'b1 ;
        end
    end
end
        
always @( posedge clk or negedge reset_n ) begin
    if ( !reset_n )
        count2 <= 8'b0 ;
    else begin
        if (curstate[1] && cpu_a)
            count2 <= 8'b0 ;  	     
        else if (curstate[2])  begin 
            if (vpu_a)
                count2 <= 8'b0 ;
            else if (ram_wren && (count2 == 255))
                count2 <= 8'b0 ;
            else if (ram_wren)
                count2 <= count2 + 1'b1 ;
        end
        else if (curstate[3]) begin
            if (cpu_a)
                count2 <= 8'b0 ;
            else if (ram_wren && (count2 == 255))
                count2 <= 8'b0 ;
            else if (ram_wren)
                count2 <= count2 + 1'b1 ;
        end 
    end
end
           		
always @( posedge clk or negedge reset_n ) begin
    if ( !reset_n )
        cpu_b_i <= 1'b0 ;
    else
        if (curstate[2] && ram_wren && (count2 == 255))
            cpu_b_i <= 1'b1 ;
        else 
            cpu_b_i <= 1'b0 ;
end

always @( posedge clk or negedge reset_n ) begin
    if ( !reset_n )
        vpu_b_i <= 1'b0 ;
    else
        if (curstate[3] && ram_wren && (count2 == 255))
            vpu_b_i <= 1'b1 ;
        else 
            vpu_b_i <= 1'b0 ;
end



        

always @( posedge clk or negedge reset_n ) begin
    if ( !reset_n ) 
        dec_en_addr_d <= 1'b0 ;            
    else
        dec_en_addr_d <= dec_en_addr;
end


always @( posedge clk or negedge reset_n ) begin
    if ( !reset_n ) 
        dec_en_in <= 1'b0 ;
    else
        if (curstate[0] && init_a)
            dec_en_in <= 1'b0 ;
        else if (curstate[4])
            dec_en_in <= dec_en_addr_d;
end
    		


always @( posedge clk or negedge reset_n ) begin
    if ( !reset_n ) begin
    	att_1  <= 8'b0;
	att_2  <= 8'b0;
	att_3  <= 8'b0;    
    end
    else begin
        if (init_a) begin
    	    att_1  <= 8'b0;
	    att_2  <= 8'b0;
	    att_3  <= 8'b0;  
	end
	else if (cpu_b_i ) 
	    att_1 <= ff3(att_1 , 8'd5) ;
	else if (vpu_b_i ) begin
	    att_1 <= ff3(att_1 , 8'd3) ;
	    att_2 <= ff3(att_2, 8'd2);
	    att_3 <= 8'd1 ;   
	end        	
    end
end




function signed [Width_D-1 : 0] ff1 ;
input    signed [Width_D-1 : 0] a       ;
begin
    if (!a[Width_D-1])
        ff1 = a ;
    else 
        ff1 = -{1'b0, a[Width_D-2 : 0]};
end
endfunction


function [Width_D-1 : 0] ff2 ;
input                       a    ;
input    signed [Width_D-2 : 0] b    ;
begin                  
    if (!a) 
        ff2 = {a,b} ;
    else begin
        ff2[Width_D - 1]   =   a   ;
        ff2[Width_D-2 : 0] = - b   ;
    end
end
endfunction


function [7:0] ff3;
input	 [7:0]	a  ;
input	 [7:0]	b  ;	
begin	
    if (a + b > 255)
        ff3 = a + b - 256 ;
    else
        ff3 = a + b     ;      
end
endfunction

endmodule

