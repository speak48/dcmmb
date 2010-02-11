//////////////////////////
//
//copyright 2009, SHHIC
//all right reserved
//
//project name: hongqiao
//filename    : ctrl.v
//author      : Li Gang
//date        : 2009/10/20
//version     : 0.1
//
//module name : ctrl
//discription : 
//
//modification history
//---------------------------------
//&Log&
//
//////////////////////////

module ctrl     (  clk          ,
	           reset_n      ,
	           rate         ,
	           bidin_rdy    ,	           
	           init_a       ,
	           init_b       ,
	           cpu_b        ,
	           vpu_b        ,
	           cpu_en_out   ,
	           cpu_dout2    ,
	           max          ,
	           dec_b        ,
	           
	           ldpc_req     ,
	           cpu_a        ,
	           vpu_a        ,
	           dec_out_flag ,
	           dec_a        ,
	           num          ,
	           busy         
	           );	
	                
                  
           
	                
input                  clk         ;
input                  reset_n     ;	
input                  rate        ; 
input                  bidin_rdy   ;
input                  init_a      ;
input                  init_b      ;
input                  cpu_b       ;
input                  vpu_b       ;
input                  cpu_en_out  ;
input[17 : 0]          cpu_dout2   ;
input[7:0]             max         ;
input                  dec_b       ;    

output                 ldpc_req     ;                       
output                 cpu_a        ;
output                 vpu_a        ;
output                 dec_out_flag ;
output                 dec_a        ;
output [7:0]           num          ;  
output                 busy         ;

reg                    ldpc_req     ;                       
reg                    cpu_a        ;
reg                    vpu_a        ;
reg                    dec_out_flag ;
reg                    dec_a        ;
reg    [7:0]           num          ; 
reg                    busy         ;

reg [4 : 0]            curstate     ; 
reg [4 : 0]            nextstate    ;
reg                    tc           ; 
reg                    tc_temp      ;  
reg   [3:0]            count1       ;           
reg   [22:0]           count2       ;
reg                    bidin_t      ;

parameter state1  = 5'b00001,
          state2  = 5'b00010,
          state3  = 5'b00100, 
          state4  = 5'b01000,
          state5  = 5'b10000;


always @ (posedge clk or negedge reset_n) begin
    if (!reset_n) begin
             ldpc_req <= 1'b0 ;
             bidin_t <= 1'b0 ;
             count1 <= 0;
             count2 <= 0;
        end
    else begin
        if (bidin_rdy)            
            bidin_t <= 1'b1 ;      
        
        if (count1 == 4'd15) 
            bidin_t <= 1'b0 ;

 
           
        if (bidin_t ) begin
                 if(count2 == 40000)
                    count2 <= 0;
                 else
                    count2 <= count2 + 1;
                 
                 if(count2 == 39999)
                    count1 <= count1 + 1;
                                         
                 if(count2 < 9216)    
                    ldpc_req <= 1'b1;
                 else 
                    ldpc_req <= 1'b0;

             end
        else begin
                 ldpc_req <= 1'b0;
                 count2 <= 0;              
                 count1 <= 0; 
             end           
      end      
end



always @ (posedge clk or negedge reset_n) begin
    if (!reset_n)
        busy <= 1'b0 ;
    else
        if (init_a)
            busy <= 1'b1 ;
        else if (dec_b)
            busy <= 1'b0 ;
end





always @( posedge clk or negedge reset_n ) begin
    if ( !reset_n ) 
        curstate <= state1;
    else
        curstate <= nextstate;
end

always @(*) begin
    nextstate = curstate;
    case ( curstate ) 
        state1:  
            if(init_a) 
                nextstate = state2   ;
        state2:
            if(init_b) 
                nextstate = state3    ;
        state3: 
            if(cpu_b & ((!tc) | (num == max) ) ) 
                nextstate = state5 ; 
            else if ( cpu_b &  tc  & (num != max)    ) 
                nextstate = state4    ; 
        state4:  
            if(vpu_b)  
                nextstate = state3    ;
        state5 : 
            if(dec_b)  
                nextstate = state1   ;             
    endcase
end 


always @ (*) begin   
            tc_temp <= tc | (|cpu_dout2) ;
end
  
always @ (posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        num   <= 8'b0 ;
        dec_a <= 1'b0 ;
        dec_out_flag    <= 1'b0 ;
        vpu_a    <= 1'b0 ;
        cpu_a    <= 1'b0 ;
        tc      <= 1'b0 ;
        end
    else begin
        cpu_a <= 1'b0 ;
        dec_a <= 1'b0 ;
        vpu_a    <= 1'b0 ;
        
        case(curstate)
        5'd1: begin
            if (init_a) begin
                num <= 8'b0 ;
                dec_out_flag  <= 1'b0 ;
                end
            end
        5'd2: begin
            if (init_b) begin
            	cpu_a <= 1'b1 ;
            	tc   <= 1'b0 ;
            	end
            end
        5'd4 : begin
            if (cpu_b) begin
                if(!tc) begin
                    dec_out_flag    <= 1'b1 ;
                    dec_a <= 1'b1 ;
                end
                else if (num == max)
                    dec_a <= 1'b1 ;
                else begin
                    tc      <= 1'b0 ;
                    vpu_a    <= 1'b1 ;
                    num   <= num + 1'b1 ;
                end
            end
            if (cpu_en_out)
                tc <= tc_temp ;
        end
        5'd8 : begin
            if (vpu_b)
                cpu_a <= 1'b1 ;
            end
        5'd16: begin
            if (dec_b)
                dec_out_flag  <= 1'b0;
            end	
        endcase
    end
end
            
endmodule

