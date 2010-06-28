`timescale 1ns/1ns
module agc_sim();
parameter CLK_PRD = 10;
parameter DATA_DEP = 16384*5;

reg clk;
reg reset_n;
reg [9:0] data_I_in;
reg [9:0] data_Q_in;
reg agc_en;

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

reg  pwm_ena;    
initial
begin
    pwm_ena = 0;
    agc_en = 0;
    #(40*CLK_PRD)    
    pwm_ena = 1'b1;
    agc_en = 1'b1;
end

agc u_agc(
    .clk        (clk),
    .reset_n    (reset_n),
    .data_I_in  (data_I_in),
    .data_Q_in  (data_Q_in),
    .agc_en     (agc_en),
    .pwr_req_val(9'b10_1101_001),
    .pwr_est_prd(2'b00),
    .pwr_range  (8'b00000_101),
    .pwr_est_val(),
    .agc_fix    (),
    .pwm_step   (2'b1),
    .pwm_ena    (pwm_ena),
    .pwm_inv    (1'b0),
    .pwm_th_ena (1'b0),
    .pwm_th_in  (8'h3f),
    .pwm_max_val(8'h7f),
    .pwm_min_val(8'h00),
    .pwm_th_out ()
);

endmodule
