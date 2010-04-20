`timescale 1ns/1ns
//`define PRINT_OUT
module bidin_sim();
parameter CLK_PRD = 10;
parameter DATA_DEP = 240*72;
parameter WID = 8;

reg clk;
reg reset_n;
reg            data_in;
reg            sync_in;
reg            rs_cor_fail;
reg            rs_row_finish;
reg            rs_en_out;
reg   [7:0]    rs_dout  ;

wire           rs_en_in ;
wire [7:0]     rs_din   ;

wire [WID-1:0] ts0_dout;
wire           ts0_en_out;
wire           ts0_int;

reg            ts0_win;
reg            ts0_en_rd;

`ifdef PRINT_OUT
integer file;
integer file1;
initial begin
    file = $fopen("../debussy/out.dat");
    file1 = $fopen("../debussy/in.dat");
end    

always @ (posedge clk)
  if(ts0_en_out)
    $fdisplay(file,"%d",ts0_dout);	

always @ (posedge clk)
  if(u_bydin.byte_sync)
    $fdisplay(file1,"%d",u_bydin.byte_data);	

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
reg [31:0] mem_data_i [0:DATA_DEP-1];
reg [31:0]  temp;
//integer ptr;
//initial
begin	
//   $readmemh("../../tb/pattern/bit_in.dat",mem_data_i);
      ts0_win = 1'b0;
      sync_in = 1'b0;
      data_in = 'h0;
   #(20.5*CLK_PRD+1)   
   for ( i = 0; i < 30 ; i = i+1) begin
      #(CLK_PRD);
      #(CLK_PRD)
         ts0_win = 1'b1;
      for ( j = 0; j < 4608; j = j+1) begin
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
   #(200000*CLK_PRD)
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
      .ofdm_mode_in  ( 1'b0    ),

      .ts0_win       ( ts0_win ),
      .ts0_bydin_mode( 3'b001  ),
      .ts0_rs_mode   ( 2'b01   ),
      .ts0_rs_ena    ( 1'b1    ),
      .ts0_ldpc_rate ( 1'b0    ),
      .ts0_en_rd     ( ts0_en_rd ),

      .ts1_win       ( 1'b0    ),
      .ts1_bydin_mode( 3'b000  ),
      .ts1_rs_mode   ( 2'b00   ),
      .ts1_rs_ena    ( 1'b0    ),
      .ts1_ldpc_rate ( 1'b0    ),
      .ts1_en_rd     ( 1'b0    ),

      .rs_cor_fail   ( rs_cor_fail ),
      .rs_row_finish ( rs_row_finish ),
      .rs_en_out     ( rs_en_out),
      .rs_dout       ( rs_dout  ),

      .rs_mode      (),
      .rs_en_in     ( rs_en_in ),
      .rs_din       ( rs_din   ),

      .ts0_int      ( ts0_int    ),
      .ts0_en_out   ( ts0_en_out ),
      .ts0_dout     ( ts0_dout   ),

      .ts1_int      (),
      .ts1_en_out   (),
      .ts1_dout     ()

);

always @ (*)
    rs_dout <= #(640*CLK_PRD) rs_din;

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
            for (i=0;i<223;i=i+1) begin
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

task int_deal;
integer i;
begin	
    ts0_en_rd = 1'b0;
    while(1)
    begin
       wait(ts0_int)
            #(CLK_PRD);
       for (i=0;i<224*72;i=i+1)begin
	    ts0_en_rd = 1'b1;
            #(CLK_PRD)
	    ts0_en_rd = 1'b0;
	    #(7*CLK_PRD);
       end   
    end
end   
endtask

endmodule
