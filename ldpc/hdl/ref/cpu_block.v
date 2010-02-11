//////////////////////////
//
//copyright 2009, SHHIC
//all right reserved
//
//project name: hongqiao
//filename    : cpu_block.v
//author      : Li Gang
//date        : 2009/10/20
//version     : 0.1
//
//module name : cpu_block
//discription : 
//
//modification history
//---------------------------------
//&Log&
//
//////////////////////////


module	cpu_block (reset_n  ,  
	           clk        ,  
	           rate       ,  
	           en_in ,  
	           cpu_din2   ,  
	           cpu_din1   ,  
                  
                              
	           en_out     , 
	           cpu_dout   , 
	           cpu_dout2        
	           );
	         
     


input                          clk      ;
input                          reset_n  ;
input                          rate     ;
input                          en_in    ;
input  [107 : 0]               cpu_din2 ;
input  [647 : 0]               cpu_din1 ;

output                         en_out   ;
output [647 : 0]               cpu_dout ;
output [17 :  0]               cpu_dout2;

reg    [647 : 0]               cpu_dout ;

wire   [11 : 0]                din2_cpu [17:0]   ;
wire   [71 : 0]                din1_cpu [17:0]   ;
wire   [71:0]                  dout_cpu [17:0]   ;



assign din1_cpu[0 ] = {36'b0, cpu_din1[35  :  0   ]} ;
assign din1_cpu[1 ] = {36'b0, cpu_din1[71  :  36  ]} ;
assign din1_cpu[2 ] = {36'b0, cpu_din1[107 :  72  ]} ;
assign din1_cpu[3 ] = {36'b0, cpu_din1[143 :  108 ]} ;
assign din1_cpu[4 ] = {36'b0, cpu_din1[179 :  144 ]} ;
assign din1_cpu[5 ] = {36'b0, cpu_din1[215 :  180 ]} ;
assign din1_cpu[6 ] = {36'b0, cpu_din1[251 :  216 ]} ;
assign din1_cpu[7 ] = {36'b0, cpu_din1[287 :  252 ]} ;
assign din1_cpu[8 ] = {36'b0, cpu_din1[323 :  288 ]} ;
assign din1_cpu[9 ] = {36'b0, cpu_din1[359 :  324 ]} ;
assign din1_cpu[10] = {36'b0, cpu_din1[395 :  360 ]} ;
assign din1_cpu[11] = {36'b0, cpu_din1[431 :  396 ]} ;
assign din1_cpu[12] = {36'b0, cpu_din1[467 :  432 ]} ;
assign din1_cpu[13] = {36'b0, cpu_din1[503 :  468 ]} ;
assign din1_cpu[14] = {36'b0, cpu_din1[539 :  504 ]} ;
assign din1_cpu[15] = {36'b0, cpu_din1[575 :  540 ]} ;
assign din1_cpu[16] = {36'b0, cpu_din1[611 :  576 ]} ;
assign din1_cpu[17] = {36'b0, cpu_din1[647 :  612 ]} ;

assign din2_cpu[0 ] = {6'b0, cpu_din2[5   :  0   ]} ;
assign din2_cpu[1 ] = {6'b0, cpu_din2[11  :  6   ]} ;
assign din2_cpu[2 ] = {6'b0, cpu_din2[17  :  12  ]} ;
assign din2_cpu[3 ] = {6'b0, cpu_din2[23  :  18  ]} ;
assign din2_cpu[4 ] = {6'b0, cpu_din2[29  :  24  ]} ;
assign din2_cpu[5 ] = {6'b0, cpu_din2[35  :  30  ]} ;
assign din2_cpu[6 ] = {6'b0, cpu_din2[41  :  36  ]} ;
assign din2_cpu[7 ] = {6'b0, cpu_din2[47  :  42  ]} ;
assign din2_cpu[8 ] = {6'b0, cpu_din2[53  :  48  ]} ;
assign din2_cpu[9 ] = {6'b0, cpu_din2[59  :  54  ]} ;
assign din2_cpu[10] = {6'b0, cpu_din2[65  :  60  ]} ;
assign din2_cpu[11] = {6'b0, cpu_din2[71  :  66  ]} ;
assign din2_cpu[12] = {6'b0, cpu_din2[77  :  72  ]} ;
assign din2_cpu[13] = {6'b0, cpu_din2[83  :  78  ]} ;
assign din2_cpu[14] = {6'b0, cpu_din2[89  :  84  ]} ;
assign din2_cpu[15] = {6'b0, cpu_din2[95  :  90  ]} ;
assign din2_cpu[16] = {6'b0, cpu_din2[101 :  96  ]} ;
assign din2_cpu[17] = {6'b0, cpu_din2[107 :  102 ]} ;

always @ ( * ) begin
        cpu_dout[35  :  0   ]  <= dout_cpu[0 ][35 : 0] ;	
        cpu_dout[71  :  36  ]  <= dout_cpu[1 ][35 : 0] ;	
        cpu_dout[107 :  72  ]  <= dout_cpu[2 ][35 : 0] ;	
        cpu_dout[143 :  108 ]  <= dout_cpu[3 ][35 : 0] ;	
        cpu_dout[179 :  144 ]  <= dout_cpu[4 ][35 : 0] ;	
        cpu_dout[215 :  180 ]  <= dout_cpu[5 ][35 : 0] ;	
        cpu_dout[251 :  216 ]  <= dout_cpu[6 ][35 : 0] ;	
        cpu_dout[287 :  252 ]  <= dout_cpu[7 ][35 : 0] ;	
        cpu_dout[323 :  288 ]  <= dout_cpu[8 ][35 : 0] ;	
        cpu_dout[359 :  324 ]  <= dout_cpu[9 ][35 : 0] ;	
        cpu_dout[395 :  360 ]  <= dout_cpu[10][35 : 0] ;	
        cpu_dout[431 :  396 ]  <= dout_cpu[11][35 : 0] ;	
        cpu_dout[467 :  432 ]  <= dout_cpu[12][35 : 0] ;	
        cpu_dout[503 :  468 ]  <= dout_cpu[13][35 : 0] ;	
        cpu_dout[539 :  504 ]  <= dout_cpu[14][35 : 0] ;	
        cpu_dout[575 :  540 ]  <= dout_cpu[15][35 : 0] ;	
        cpu_dout[611 :  576 ]  <= dout_cpu[16][35 : 0] ;	
        cpu_dout[647 :  612 ]  <= dout_cpu[17][35 : 0] ;	

end


    cpu1   u_cpu_1
		(
		 .reset_n     ( reset_n     ),
	         .clk         ( clk         ),
	         .rate        ( rate        ),
	         .en_in       ( en_in       ),
	         .din2        ( din2_cpu[0] ),
	         .din1        ( din1_cpu[0] ),

	         .en_out      ( en_out      ),
	         .dout        ( dout_cpu[0] ),
	         .dout2       ( cpu_dout2[0])
	         );   



generate
    genvar i;
    
    for(i=1; i<18; i=i+1)
        begin: cpu_inst        
	     cpu   u_cpu
		(
		 .reset_n     ( reset_n     ),
	         .clk         ( clk         ),
	         .rate        ( rate        ),
	         .en_in       ( en_in       ),
	         .din2        ( din2_cpu[i] ),
	         .din1        ( din1_cpu[i] ),

	         .dout        ( dout_cpu[i] ),
	         .dout2       ( cpu_dout2[i])
	         );        
        end

endgenerate

         
endmodule




















	        	

