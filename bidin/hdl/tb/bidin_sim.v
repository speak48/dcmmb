`timescale 1ns/1ns
`define PRINT_OUT
module bidin_sim();
parameter CLK_PRD = 10;
parameter DATA_DEP = 138240*4;
parameter WID = 6;

reg clk;
reg reset_n;
reg [WID-1:0] data_in;
reg           sync_in;
reg           head_in;
reg           ldpc_req;
reg           ldpc_fin;

wire [WID-1:0] data_out;
wire           bidin_ena_out;
wire [WID-1:0] bidin_dout;

`ifdef PRINT_OUT
integer file;
initial begin
    file = $fopen("../debussy/out.dat");
end    

always @ (posedge clk)
  if(bidin_ena_out)
    $fdisplay(file,"%d",bidin_dout);	

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
integer ptr;
//initial
begin	
   $readmemh("../../tb/pattern/bit_in.dat",mem_data_i);
      head_in = 1'b0;
      sync_in = 1'b0;
      data_in = 'h0;
      ptr  = 'h0;
   #(20.5*CLK_PRD+1)   
   for ( i = 0; i < 52 ; i = i+1) begin
      #(CLK_PRD)
         head_in = 1'b1;
      #(CLK_PRD)
         head_in = 1'b0;
      #(3*CLK_PRD)
      for ( j = 0; j < 2610*2; j = j+1) begin
 //        temp = $random;
         temp = mem_data_i[ptr];
	 ptr = ptr + 1'b1;
         data_in = temp[9:0];
	 sync_in = 1'b1;
      #(CLK_PRD)
         temp = 0;
      end
      sync_in = 1'b0;
      #(20000*CLK_PRD)
      ;
   end
   // No 53
   //
   for ( j = 0; j < (2610-90)*2; j = j+1) begin
 //        temp = $random;
         temp = mem_data_i[ptr];
	 ptr = ptr + 1'b1;
         data_in = temp[9:0];
	 sync_in = 1'b1;
	#(CLK_PRD)
         temp = 0;
    end
         sync_in = 1'b0;
   #(400000*CLK_PRD)
   $finish;
end
endtask

task dump_fsdb;
begin
	$fsdbDumpfile("../debussy/bidin.fsdb");
	$fsdbDumpvars;
	$fsdbDumpflush;
end
endtask

initial
    fork
	clock_gen;
	reset_gen;
	dump_fsdb;
	ldpc_read;
	read_data_in; 
    join

wire [WID-1:0] fifo_dout  ;       
wire           stack_empty;
wire           stack_ae   ;
wire           bidin_full ;
reg            fifo_rd    ;
reg            fifo_rd_d  ;
wire           bidin_rdy  ;

always @ (posedge clk or negedge reset_n)
begin 
    if(!reset_n)
        fifo_rd <= #1 1'b0;
    else if(bidin_full)
	fifo_rd <= #1 1'b0;
    else if(ldpc_fin)
	fifo_rd <= #1 1'b0;
    else if(fifo_rd & stack_ae)
	fifo_rd <= #1 1'b0;
    else if(~stack_empty)
	fifo_rd <= #1 1'b1;
//    else if(stack_ae)
//	fifo_rd <= #1 ~fifo_rd;
    
end	

always @ (posedge clk or negedge reset_n)
begin
    if(!reset_n)	
        fifo_rd_d <= #1 1'b0;
    else
	fifo_rd_d <= #1 fifo_rd;
end


 bidin u_bidin(
    .clk6          ( clk     ), 
    .rst_n         ( reset_n ), 
    .bidin_sync_in ( head_in ), 
    .bidin_ena_in  ( fifo_rd_d ), 
//    .bidin_din     ( data_in ), 
    .bidin_din     ( fifo_dout),
    .ldpc_req      ( ldpc_req ),
    .ldpc_fin      ( ldpc_fin ),
		
    .bidin_full    (bidin_full),
    .bidin_rdy     (bidin_rdy ),
    .bidin_ena_out (bidin_ena_out),
    .bidin_dout    (bidin_dout)
);

// add a FIFO debug IF
//
 FIFO_Buffer #(WID,8192,13,1) fifo_buffer(
    .Data_out          (fifo_dout),
    .stack_full        (         ),
    .stack_almost_full (         ),
    .stack_half_full   (         ),
    .stack_almost_empty(stack_ae ),
    .stack_empty       (stack_empty),
    .Data_in           ( data_in ),
    .write_to_stack    ( sync_in ),
    .read_from_stack   ( fifo_rd ),
    .clk               ( clk     ),
    .rst               (~reset_n)
  );

task ldpc_read;
integer i,j;	
begin
    ldpc_req = 1'b0;
    ldpc_fin = 1'b0;
    #(20*CLK_PRD)	
    while (1)
    begin
      wait(bidin_rdy)
      begin
	#(CLK_PRD)    
        for ( i = 0; i < 15 ; i = i+1 ) begin
            for ( j = 0; j < 9216; j = j + 1)
            begin
            #(CLK_PRD) ldpc_req = 1'b1;		    
            end
            #(CLK_PRD) ldpc_req = 1'b0;
	    #(512*30*CLK_PRD)
	    ;
	    #(CLK_PRD) ldpc_fin = 1'b1;
	    #(CLK_PRD) ldpc_fin = 1'b0;
            #(CLK_PRD*2) ;
        end	    
      end	 
    end   
end
endtask


endmodule
