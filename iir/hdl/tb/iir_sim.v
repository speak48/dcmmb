`timescale 1ns/1ns
`define PRINT_OUT
module iir_sim();
parameter CLK_PRD = 10;
parameter DATA_DEP = 16384*5;

reg clk;
reg reset_n;
reg [9:0] data_in;
wire [9:0] data_out;

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
integer i;
reg [31:0] mem_data_i [0:DATA_DEP-1];
reg [31:0]  temp;
//initial
begin	
   $readmemh("../../tb/pattern/iir.dat",mem_data_i);
   #(10*CLK_PRD)
   for ( i = 0; i < DATA_DEP; i=i+1 )
   begin
      temp = mem_data_i[i];
      data_in = temp[9:0];
      #(CLK_PRD)
      temp = 0;
    end
    #(100*CLK_PRD)
    $finish;
end
endtask

task dump_fsdb;
begin
	$fsdbDumpfile("../debussy/iir.fsdb");
	$fsdbDumpvars;
	$fsdbDumpflush;
end
endtask

initial
    fork
	clock_gen;
	reset_gen;
//	dump_fsdb;
	read_data_in; 
    join


iir u_iir(
    .clk        (clk),
    .reset_n    (reset_n),
    .data_in    (data_in),
    .data_out   (data_out)
);

endmodule
