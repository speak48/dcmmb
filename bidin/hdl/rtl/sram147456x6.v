module sram147456x6 (                             
	CLK,                                       
	A,                                         
	CE,                                       
	WE,                                       
	D,                                         
	Q                                          
);                                             

parameter  A_WID = 18,
           D_WID = 6;


input             CLK;                               
input [A_WID-1:0] A;                                 
input [D_WID-1:0] D;                                             
input             CE;
input             WE;                                                                 
output [D_WID-1:0] Q;                                

//reg    [D_WID-1:0] Q;                                   
/*********************************************/
/* this part should be replaced by ASIC sram */
/*
reg    [D_WID-1:0] mem [0:146879];                         
always @ ( posedge CLK )                       
    if(~CEN && ~WEN)                      
        mem[A] <= #1 D;            
                                               
always @ ( posedge CLK )                       
    if(~CEN && WEN)                        
	Q <= #1 mem[A];            
*/
/*********************************************/
wire       u1_CEN ;
wire       u2_CEN ;
wire       u3_CEN ;
wire [47:0] DATA  ;
reg  [7:0] U_WEN  ;
wire [47:0] u1_Q  ;
wire [47:0] u2_Q  ;
wire [47:0] u3_Q  ;
reg   [6:0] Q1    ;
reg   [6:0] Q2    ;
reg   [6:0] Q3    ;
reg   [2:0] A_rd  ;
reg   [2:0] CEN_rd;

assign u1_CEN = !(CE & ( A[17:16] == 2'b00) );
assign u2_CEN = !(CE & ( A[17:16] == 2'b01) );
assign u3_CEN = !(CE & ( A[17:14] == 4'b1000 ) );

always @ (posedge CLK)
   A_rd <= #1 A[2:0];

always @ (posedge CLK)
   CEN_rd <= #1 { u3_CEN, u2_CEN, u1_CEN };

always @ ( A[2:0] or WE )
begin if(WE)
   case(A[2:0])
   3'b000: U_WEN = 8'b1111_1110;
   3'b001: U_WEN = 8'b1111_1101;
   3'b010: U_WEN = 8'b1111_1011;
   3'b011: U_WEN = 8'b1111_0111;
   3'b100: U_WEN = 8'b1110_1111;
   3'b101: U_WEN = 8'b1101_1111;
   3'b110: U_WEN = 8'b1011_1111;
   3'b111: U_WEN = 8'b0111_1111;
   endcase
   else
   U_WEN = 8'hff;
end

assign DATA[ 5: 0] = ( WE & (A[2:0] == 3'b000) ) ? D : 6'h0;
assign DATA[11: 6] = ( WE & (A[2:0] == 3'b001) ) ? D : 6'h0;
assign DATA[17:12] = ( WE & (A[2:0] == 3'b010) ) ? D : 6'h0;
assign DATA[23:18] = ( WE & (A[2:0] == 3'b011) ) ? D : 6'h0;
assign DATA[29:24] = ( WE & (A[2:0] == 3'b100) ) ? D : 6'h0;
assign DATA[35:30] = ( WE & (A[2:0] == 3'b101) ) ? D : 6'h0;
assign DATA[41:36] = ( WE & (A[2:0] == 3'b110) ) ? D : 6'h0;
assign DATA[47:42] = ( WE & (A[2:0] == 3'b111) ) ? D : 6'h0;

assign Q = (!CEN_rd[2] ) ? Q3 : (!CEN_rd[1] ) ? Q2 : Q1;
//assign Q = (!u3_CEN ) ? Q3 : (!u2_CEN ) ? Q2 : Q1;

always @ ( A_rd[2:0] or u1_Q) 
begin
   case(A_rd[2:0])
   3'b000: Q1 = u1_Q[ 5: 0];
   3'b001: Q1 = u1_Q[11: 6];
   3'b010: Q1 = u1_Q[17:12];
   3'b011: Q1 = u1_Q[23:18];
   3'b100: Q1 = u1_Q[29:24];
   3'b101: Q1 = u1_Q[35:30];
   3'b110: Q1 = u1_Q[41:36];
   3'b111: Q1 = u1_Q[47:42];
   endcase
end  
 
always @ ( A_rd[2:0] or u2_Q) 
begin
   case(A_rd[2:0])
   3'b000: Q2 = u2_Q[ 5: 0];
   3'b001: Q2 = u2_Q[11: 6];
   3'b010: Q2 = u2_Q[17:12];
   3'b011: Q2 = u2_Q[23:18];
   3'b100: Q2 = u2_Q[29:24];
   3'b101: Q2 = u2_Q[35:30];
   3'b110: Q2 = u2_Q[41:36];
   3'b111: Q2 = u2_Q[47:42];
   endcase
end   

always @ ( A_rd[2:0] or u3_Q) 
begin
   case(A_rd[2:0])
   3'b000: Q3 = u3_Q[ 5: 0];
   3'b001: Q3 = u3_Q[11: 6];
   3'b010: Q3 = u3_Q[17:12];
   3'b011: Q3 = u3_Q[23:18];
   3'b100: Q3 = u3_Q[29:24];
   3'b101: Q3 = u3_Q[35:30];
   3'b110: Q3 = u3_Q[41:36];
   3'b111: Q3 = u3_Q[47:42];
   endcase
end   

sram8192x48 u1(
   .Q   ( u1_Q    ),
   .CLK ( CLK     ),
   .CEN ( u1_CEN  ),
   .WEN ( U_WEN   ),
   .A   ( A[15:3] ),
   .D   ( DATA    )
);

sram8192x48 u2(
   .Q   ( u2_Q    ),
   .CLK ( CLK     ),
   .CEN ( u2_CEN  ),
   .WEN ( U_WEN   ),
   .A   ( A[15:3] ),
   .D   ( DATA    )
);

sram2048x48 u3(
   .Q   ( u3_Q    ),
   .CLK ( CLK     ),
   .CEN ( u3_CEN  ),
   .WEN ( U_WEN   ),
   .A   ( A[13:3] ),
   .D   ( DATA    )
);

				                               
endmodule                                      
			                                   
