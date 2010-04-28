`timescale 1ns/1ns
`define PRINT_OUT
`define BYDIN0_MODE 3'b010
`define BYDIN0_RS_ENA 1'b0
`define BYDIN0_RS_MODE 2'b01
`define BYDIN0_SLOT 3'h1

`define BYDIN1_MODE 3'b001
`define BYDIN1_RS_ENA 1'b1
`define BYDIN1_RS_MODE 2'b01
`define BYDIN1_SLOT 3'h2

`define LDPC_FRAME 4608 //6912
`define MIN_ROW_TS0  72
`define MIN_ROW_TS1  72

module bidin_sim();
parameter CLK_PRD = 10;
//parameter DATA_DEP = 240*72;
parameter WID = 8;

reg clk;
reg reset_n;
reg            data_in;
reg            sync_in;
reg            rs_cor_fail;
reg            rs_row_finish;
reg            rs_en_out    ;
reg   [7:0]    rs_dout      ;
reg            ts_slot_ini;
reg   [2:0]    ts0_slot_num  ;
reg   [2:0]    ts1_slot_num  ;

wire           rs_en_in ;
wire  [7:0]    rs_din   ;
wire  [1:0]    rs_mode  ;

wire [WID-1:0] ts0_dout;
wire           ts0_en_out;
wire           ts0_int;
reg            ts0_win;
reg            ts0_en_rd;

wire [WID-1:0] ts1_dout;
wire           ts1_en_out;
wire           ts1_int;
reg            ts1_win;
reg            ts1_en_rd;

`ifdef PRINT_OUT
integer file0,file1;
integer file2,file3;
initial begin
    file0 = $fopen("../debussy/out0.dat");
    file1 = $fopen("../debussy/out1.dat");
    file2 = $fopen("../debussy/in0.dat");
    file3 = $fopen("../debussy/in1.dat");
end    

always @ (posedge clk)
  if(ts0_en_out)
    $fdisplay(file0,"%x",ts0_dout);
  else if(ts1_en_out)
    $fdisplay(file1,"%x",ts1_dout);	  

always @ (posedge clk)
  if(u_bydin.byte_sync & u_bydin.byte_win0)
    $fdisplay(file2,"%x",u_bydin.byte_data);	
  else if(u_bydin.byte_sync & u_bydin.byte_win1)
    $fdisplay(file3,"%x",u_bydin.byte_data);	

`endif

task clock_gen;
begin	
   clk = 1'b0;
   forever #(CLK_PRD/2) clk = ~clk; 
end   
endtask

task reset_gen;
begin	
   reset_n = 1'b0;
   #(10*CLK_PRD) reset_n = 1'b1;
   $display("reset end");
end   
endtask

task read_data_in;
integer i,j;
//reg [31:0] mem_data_i [0:DATA_DEP-1];
reg [31:0]  temp;
begin	
      ts0_win = 1'b0;
      ts1_win = 1'b0;
      sync_in = 1'b0;
      data_in = 'h0;
      ts_slot_ini = 1'b0; 
      ts0_slot_num = 'h1;
      ts1_slot_num = 'h1; 
   #(20.5*CLK_PRD+1)  
   #(CLK_PRD)
         ts0_win = 1'b1;
	 ts_slot_ini = 1'b1;
	 ts0_slot_num = 'h1;
    for ( j = 0; j < `LDPC_FRAME; j = j+1 ) begin
	 temp = $random;
	 data_in = temp[0];
	 sync_in = 1'b1;
	 #(CLK_PRD)
	 temp = 0;
      end
      ts_slot_ini = 1'b0;
      sync_in = 1'b0;
      ts0_win = 1'b0;
      #(100*CLK_PRD); 
   for ( i = 0; i < (30 * `BYDIN0_MODE * `BYDIN0_SLOT-1); i = i+1) begin
      #(CLK_PRD);
      #(CLK_PRD)
         ts0_win = 1'b1;
      for ( j = 0; j < `LDPC_FRAME; j = j+1) begin
         temp = $random;
         data_in = temp[0];
	 sync_in = 1'b1;
         #(CLK_PRD)
         temp = 0;
      end
      sync_in = 1'b0;
      ts0_win = 1'b0;
      #(100*CLK_PRD)
      ;
   end
   #(100000*CLK_PRD);
// test another mode for each slot interleaver solely
// start from here  
    #(CLK_PRD)
         ts1_win = 1'b1;
	 ts_slot_ini = 1'b1;
	 ts1_slot_num = 'h2;
    for ( j = 0; j < `LDPC_FRAME; j = j+1 ) begin
	 temp = $random;
	 data_in = temp[0];
	 sync_in = 1'b1;
	 #(CLK_PRD)
	 temp = 0;
      end
      ts_slot_ini = 1'b0;
      sync_in = 1'b0;
      ts1_win = 1'b0;
      #(100*CLK_PRD);
      
   for ( i = 0; i < (30 * `BYDIN1_MODE * `BYDIN1_SLOT-1) ; i = i+1) begin
      #(CLK_PRD);
      #(CLK_PRD)
         ts1_win = 1'b1;
      for ( j = 0; j < `LDPC_FRAME; j = j+1) begin
         temp = $random;
         data_in = temp[0];
	 sync_in = 1'b1;
         #(CLK_PRD)
         temp = 0;
      end
      sync_in = 1'b0;
      ts1_win = 1'b0;
      #(100*CLK_PRD)
      ;
   end
// end
   #(1.5*30*`BYDIN1_MODE*`BYDIN1_SLOT*`LDPC_FRAME*CLK_PRD)
   $finish;   
end
endtask

task dump_fsdb;
begin
	$fsdbDumpfile("../debussy/bydin.fsdb");
	$fsdbDumpvars;
	$fsdbDumpflush;
end
endtask

initial
    fork
	clock_gen;
	reset_gen;
	dump_fsdb;
	rs_dec   ;
	int_deal ;
	read_data_in; 
    join



 bydin u_bydin(
      .clk           ( clk     ),
      .reset_n       ( reset_n ),
      .ldpc_en_out   ( sync_in ),
      .ldpc_dout     ( data_in ),
 //     .ofdm_mode_in  ( 1'b0    ),
      .ts_slot_ini   ( ts_slot_ini  ),

      .ts0_win       ( ts0_win ),
      .ts0_slot_num  ( `BYDIN0_SLOT     ),
      .ts0_bydin_mode( `BYDIN0_MODE     ),
      .ts0_rs_mode   ( `BYDIN0_RS_MODE  ),
      .ts0_rs_ena    ( `BYDIN0_RS_ENA   ),
 //     .ts0_ldpc_rate ( 1'b0    ),
      .ts0_en_rd     ( ts0_en_rd ),

      .ts1_win       ( ts1_win ),
      .ts1_slot_num  ( `BYDIN1_SLOT     ),
      .ts1_bydin_mode( `BYDIN1_MODE     ),
      .ts1_rs_mode   ( `BYDIN1_RS_MODE  ),
      .ts1_rs_ena    ( `BYDIN1_RS_ENA   ),
 //     .ts1_ldpc_rate ( 1'b0    ),
      .ts1_en_rd     ( ts1_en_rd ),

 //     .rs_cor_fail   ( rs_cor_fail ),
      .rs_row_finish ( rs_row_finish ),
      .rs_en_out     ( rs_en_out),
      .rs_dout       ( rs_dout  ),

      .rs_mode      ( rs_mode  ),
      .rs_en_in     ( rs_en_in ),
      .rs_din       ( rs_din   ),

      .ts0_int      ( ts0_int    ),
      .ts0_en_out   ( ts0_en_out ),
      .ts0_dout     ( ts0_dout   ),
      .ts0_overflow (            ),

      .ts1_int      ( ts1_int    ),
      .ts1_en_out   ( ts1_en_out ),
      .ts1_dout     ( ts1_dout   ),
      .ts1_overflow (            )
);

always @ (*)
    rs_dout <= #(640*CLK_PRD) rs_din;

reg  [7:0] k_r2;
always @ (*)
begin
    case(rs_mode)	
    2'b00: k_r2 = 8'd240;
    2'b01: k_r2 = 8'd224;
    2'b10: k_r2 = 8'd192;
    2'b11: k_r2 = 8'd176;
    endcase
end

task rs_dec;
integer i,j;	
reg  temp;
begin
//    rs_dout = 1'b0;
    rs_en_out = 1'b0;
    rs_row_finish = 1'b0;
    rs_cor_fail = 1'b0;
    #(20*CLK_PRD)	
    while (1)
    begin
      wait(rs_en_in)
      begin
	#(240*CLK_PRD)    
	;
	temp = $random;
	if(temp == 1) begin
	#(400*CLK_PRD)
            for (i=0;i<(k_r2-1);i=i+1) begin
 //               rs_dout = 8'hff;
	        rs_en_out = 1'b1;
            #(CLK_PRD) ;
            end
            rs_row_finish = 1'b1;
	    #(CLK_PRD)
	    rs_row_finish = 1'b0;
//	    rs_dout = 8'h00;
	    rs_en_out = 1'b0;
	    end
        else begin
	    #(100*CLK_PRD)	
            rs_row_finish = 1'b1;
	    rs_cor_fail = 1'b1;
	    #(CLK_PRD)
	    rs_row_finish = 1'b0;
	    rs_cor_fail = 1'b0;
        end
      end	 
    end   
end
endtask

wire [1:0] ts0_mode = `BYDIN0_RS_MODE;
wire [1:0] ts1_mode = `BYDIN1_RS_MODE;
reg  [7:0] k_r0,k_r1;
always @ (*)
begin
    case(ts0_mode)	
    2'b00: k_r0 = 8'd240;
    2'b01: k_r0 = 8'd224;
    2'b10: k_r0 = 8'd192;
    2'b11: k_r0 = 8'd176;
    endcase
end

always @ (*)
begin
    case(ts1_mode)	
    2'b00: k_r1 = 8'd240;
    2'b01: k_r1 = 8'd224;
    2'b10: k_r1 = 8'd192;
    2'b11: k_r1 = 8'd176;
    endcase
end

task int_deal;
integer i;
begin	
    ts0_en_rd = 1'b0;
    ts1_en_rd = 1'b0;
    while(1)
    begin
        wait(ts0_int || ts1_int) begin
	if(ts0_int) begin
	    #(CLK_PRD);	    
            for (i=0;i<k_r0*`MIN_ROW_TS0*`BYDIN0_MODE*`BYDIN0_SLOT;i=i+1)begin
	        ts0_en_rd = 1'b1;
            #(CLK_PRD)
	        ts0_en_rd = 1'b0;
	    #(7*CLK_PRD);
            end
       end
       else if(ts1_int) begin
	    #(CLK_PRD);	    
            for (i=0;i<k_r1*`MIN_ROW_TS1*`BYDIN1_MODE*`BYDIN1_SLOT;i=i+1)begin
	        ts1_en_rd = 1'b1;
            #(CLK_PRD)
	        ts1_en_rd = 1'b0;
	    #(7*CLK_PRD);
            end
       end   
       end    
    end
end   
endtask

endmodule
