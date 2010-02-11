//////////////////////////
//
//copyright 2009, SHHIC
//all right reserved
//
//project name: hongqiao
//filename    : dec_out.v
//author      : Li Gang
//date        : 2009/10/20
//version     : 0.1
//
//module name : dec_out
//discription : 
//
//modification history
//---------------------------------
//&Log&
//
//////////////////////////



module     dec_out    (	clk         ,
	                reset_n     ,
	                rate        ,
	                dec_a       ,
	                din         ,
	                en_in       ,
	                
	                dec_addr    ,
	                dec_en_addr ,
	                dout        ,
	                en_out      ,
	                sync_out    ,
	                dec_b     
	               );
	                

input                     clk       ;
input                     reset_n   ;
input                     rate      ;
input                     dec_a     ;
input[35 : 0]             en_in     ;
input[35 : 0]             din       ;

output[287 : 0]           dec_addr     ;
output[35 : 0]            dec_en_addr  ;
output                    dout         ;
output                    en_out       ;                                               
output                    sync_out     ;
output                    dec_b        ;

reg                       dout         ;
                                               
reg   [12 : 0]            count       ;
reg   [13 : 0]            rom_addr    ;
reg                       en_addr_temp  ;
reg                       en_addr_temp_d;
reg   [35 : 0]            dec_en_addr   ;
reg   [7:0]               rom_dout_d    ; 
reg                       en_out;
reg                       dec_b ;

wire  [13 : 0]            rom_dout    ;

ldpc_rom   u_ldpc_rom (
                      .addr ( rom_addr ),
                      .clk  ( clk        ),
                      .dout ( rom_dout )
                      );

assign sync_out = dec_a ;


always @ (posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        rom_addr     <= 14'b0 ;
        en_addr_temp   <= 1'b0  ;
        en_addr_temp_d <= 1'b0 ;
    end  
    else begin
    	en_addr_temp_d <= en_addr_temp ;
    	if (dec_a) begin
    	    rom_addr <= 14'b0 ;
    	    en_addr_temp <= 1'b1  ;
    	end
    	else begin
    	    if (rom_addr == 4607) begin
    	        rom_addr <= 14'b0 ;
    	        en_addr_temp <= 1'b0  ;
    	    end
    	    else 
    	        rom_addr <= rom_addr + 1'b1 ;
    	end

    end
end    	        
   
            
assign dec_addr[7  : 0  ]  = rom_dout_d ;
assign dec_addr[15  : 8  ] = rom_dout_d ;
assign dec_addr[23  : 16 ] = rom_dout_d ;
assign dec_addr[31  : 24 ] = rom_dout_d ;
assign dec_addr[39  : 32 ] = rom_dout_d ;
assign dec_addr[47  : 40 ] = rom_dout_d ;
assign dec_addr[55  : 48 ] = rom_dout_d ;
assign dec_addr[63  : 56 ] = rom_dout_d ;
assign dec_addr[71  : 64 ] = rom_dout_d ;
assign dec_addr[79  : 72 ] = rom_dout_d ;
assign dec_addr[87  : 80 ] = rom_dout_d ;
assign dec_addr[95  : 88 ] = rom_dout_d ;
assign dec_addr[103 : 96 ] = rom_dout_d ;
assign dec_addr[111 : 104] = rom_dout_d ;
assign dec_addr[119 : 112] = rom_dout_d ;
assign dec_addr[127 : 120] = rom_dout_d ;
assign dec_addr[135 : 128] = rom_dout_d ;
assign dec_addr[143 : 136] = rom_dout_d ;
assign dec_addr[151 : 144] = rom_dout_d ;
assign dec_addr[159 : 152] = rom_dout_d ;
assign dec_addr[167 : 160] = rom_dout_d ;
assign dec_addr[175 : 168] = rom_dout_d ;
assign dec_addr[183 : 176] = rom_dout_d ;
assign dec_addr[191 : 184] = rom_dout_d ;
assign dec_addr[199 : 192] = rom_dout_d ;
assign dec_addr[207 : 200] = rom_dout_d ;
assign dec_addr[215 : 208] = rom_dout_d ;
assign dec_addr[223 : 216] = rom_dout_d ;
assign dec_addr[231 : 224] = rom_dout_d ;
assign dec_addr[239 : 232] = rom_dout_d ;
assign dec_addr[247 : 240] = rom_dout_d ;
assign dec_addr[255 : 248] = rom_dout_d ;
assign dec_addr[263 : 256] = rom_dout_d ;
assign dec_addr[271 : 264] = rom_dout_d ;
assign dec_addr[279 : 272] = rom_dout_d ; 
assign dec_addr[287 : 280] = rom_dout_d ; 

always @ (posedge clk or negedge reset_n) begin
    if (!reset_n) begin 
    	dec_en_addr<= 36'b0  ;      
 	rom_dout_d <= 8'd0;
    end
    else begin
        rom_dout_d <= 8'd0;
      	dec_en_addr <= 36'b0  ;
    	if (en_addr_temp_d) begin
            rom_dout_d <= rom_dout[7:0] ;
            dec_en_addr[rom_dout[13 : 8]] <= 1'b1;
        end
    end
end


integer j;
always @ (posedge clk or negedge reset_n) begin
    if (!reset_n) begin 
    	count     <= 13'b0  ;
    	dout      <= 1'b0  ;
    	en_out    <= 1'b0   ;
    	dec_b     <= 1'b0   ;
    end
    else begin
    	if (dec_a) begin
    	    count  <= 13'b0 ;
    	    dout   <= 1'b0 ;
    	end
    	else begin
    	    dec_b  <= 1'b0  ;
    	    en_out <= 1'b0 ;
    	    for (j=1 ; j < 37 ; j = j + 1) begin
    	        if (en_in[j-1]) begin
    	            if (count == 4607) begin
    	                count <= 13'b0 ;
    	                dec_b <= 1'b1  ;
    	            end
    	            else begin
    	                count <= count + 1'b1 ;
    	            end
    	            
    	            dout <= din[j-1];
    	            en_out <= 1'b1 ;
    	        end
    	    end
    	end
    end
end

endmodule

