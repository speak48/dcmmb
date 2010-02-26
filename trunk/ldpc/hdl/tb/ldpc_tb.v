qishi `timescale 1ns/1ns
`define DEBUG
//Module
module ldpc_tb;


parameter CLK_PRD = 10;
parameter D_WID = 6;
parameter DATA_DEP = 9216;

reg             clk;
reg             reset_n;
reg [D_WID-1:0] data_in;
reg             sync_in;
reg [4:0]       max_iter;
reg             rate;

wire            data_out;
wire            sync_out;
wire            busy;
wire [4:0]      num_iter;

//`include "debug.v"
integer         file_out;
initial begin
file_out = $fopen("../debussy/out.dat");
end

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
reg [31:0] mem_data [0:DATA_DEP-1];
reg [31:0]  temp;
//initial
begin   
   $readmemh("../../tb/pattern/data_in.dat",mem_data);
   data_in = 'd0;
   sync_in = 1'b0;
   rate = 1'b0;
   max_iter = 'd20;
   #(20.5*CLK_PRD+1)
   for ( i = 0; i < DATA_DEP; i=i+1 )
   begin
      temp = mem_data[i];
      data_in = temp[D_WID-1:0];
      sync_in = 1'b1;
      #(CLK_PRD);
    end
    sync_in = 1'b0;
    data_in = 'd0;
    #(9000*CLK_PRD)
    $finish;
end
endtask

task dump_fsdb;
begin
        $fsdbDumpfile("../debussy/ldpc.fsdb");
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

ldpc u_ldpc_dec(
    clk,
    reset_n,
    data_in,
    sync_in,
    rate,
    max_iter,
    
    data_out,
    sync_out,
    busy,
    num_iter
);


always @ (posedge clk)
begin
   if(sync_out)
   $fdisplay(file_out,"%d",data_out);
end

endmodule
