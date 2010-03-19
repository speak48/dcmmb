`timescale 1ns/1ns
//`define PRINT_OUT
module bidin_sim();
parameter CLK_PRD = 10;
parameter DATA_DEP = 138240*4;
parameter WID = 6;

reg clk;
reg reset_n;
reg [WID-1:0] data_in;
reg           sync_in;
reg           head_in;

wire [WID-1:0] data_out;

`ifdef PRINT_OUT
integer file;
initial begin
    file = $fopen("../debussy/out.dat");
end    

always @ (posedge clk)
    $fdisplay(file,"%d",$signed(data_out));	

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
//initial
begin	
//   $readmemh("../../tb/pattern/iir.dat",mem_data_i);
   #(10*CLK_PRD)
      head_in = 1'b0;
      sync_in = 1'b0;
   for ( i = 0; i < 52 ; i = i+1) begin
      #(CLK_PRD)
         head_in = 1'b1;
      #(2*CLK_PRD)
      for ( j = 0; j < 2610; j = j+1) begin
         temp = $random;
         data_in = temp[9:0];
	 sync_in = 1'b1;
      #(CLK_PRD)
         temp = 0;
      end
      sync_in = 1'b0;
      #(20000*CLK_PRD)
      ;
   end
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
	read_data_in; 
    join


 bidin u_bidin(
    .clk6          ( clk     ), 
    .rst_n         ( reset_n ), 
    .bidin_sync_in ( head_in ), 
    .bidin_ena_in  ( sync_in ), 
    .bidin_din     ( data_in ), 
    .ldpc_req      ( 1'b0    ),
		
    .bidin_rdy     (),
    .bidin_ena_out (),
    .bidin_dout    ()
);

endmodule
