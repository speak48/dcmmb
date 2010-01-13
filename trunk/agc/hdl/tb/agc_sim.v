`timescale 1ns/1ns
module agc_sim();
parameter CLK_PRD = 10;
parameter DATA_DEP = 16384;

reg clk;
reg reset_n;
reg [9:0] data_I_in;
reg [9:0] data_Q_in;

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
reg [31:0] mem_data_q [0:DATA_DEP-1];
reg [31:0]  temp;
//initial
begin	
   $readmemh("../../tb/pattern/data_in_i.dat",mem_data_i);
   $readmemh("../../tb/pattern/data_in_q.dat",mem_data_q);
   #(10*CLK_PRD)
   for ( i = 0; i < DATA_DEP; i=i+1 )
   begin
      temp = mem_data_i[i];
      data_I_in = temp[9:0];
      temp = mem_data_q[i];
      data_Q_in = temp[9:0];
      #(CLK_PRD)
      temp = 0;
    end
    #(100*CLK_PRD)
    $finish;
end
endtask

task dump_fsdb;
begin
	$fsdbDumpfile("agc.fsdb");
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

agc u_agc(
    .clk        (clk),
    .reset_n    (reset_n),
    .data_I_in  (data_I_in),
    .data_Q_in  (data_Q_in),
    .agc_en     (1'b1),
    .pwr_est_prd(2'b00),
    .pwr_est_val(),
    .agc_fix    (),
    .pwm_step   (),
    .pwm_ena    (),
    .pwm_inv    (),
    .pwm_th_ena (),
    .pwm_th_in  (),
    .pwm_max_val(),
    .pwm_th_out ()
);

endmodule
