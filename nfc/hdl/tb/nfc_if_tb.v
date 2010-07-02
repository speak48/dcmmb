`timescale 1ns/1ns

module nfc_if_tb;
`include "nfc_parameter.v"
parameter CLK_PRD = 10;

reg                    clk             ;
reg                    rst_n           ;

reg     [DAT_WID-1:0]  nf_din          ;
wire    [DAT_WID-1:0]  nf_dout         ;
wire                   nf_dir          ;
wire                   nf_cle          ;
wire                   nf_ale          ;
wire                   nf_web          ;
wire                   nf_reb          ;
wire                   nf_wpb          ;
// nf_ce, nf_rb exclude here

reg                    nfc_dat_inv     ;
reg                    nfc_dat_dir     ; // 1: Write 0: Read
reg                    nfc_cmd_en      ;
reg     [SFR_WID-1:0]  nfc_if_cmd      ;
reg                    nfc_addr_en     ;
reg     [31       :0]  nfc_col_addr    ;
reg     [31       :0]  nfc_row_addr    ;
reg     [5        :0]  nfc_addr_cnt    ;
reg                    nfc_dat_en      ;
reg     [13       :0]  nfc_dat_cnt     ;
reg     [SFR_WID-1:0]  nfc_tconf       ;
reg     [1        :0]  nfc_mode        ;

wire                   nfif_cmd_done   ;
wire                   nfif_addr_done  ;
wire                   nfif_dat_done   ;

wire                   nfif_data_rd    ;
reg                    nfif_rd_rdy     ;
reg     [DAT_WID-1:0]  nfif_data_in    ;
wire                   nfif_data_wr    ;
wire    [DAT_WID-1:0]  nfif_data_out   ;
reg                    nfif_wr_rdy    ;

task clock_gen;
begin	
   clk = 1'b0;
   forever #(CLK_PRD/2) clk = ~clk; 
end   
endtask

task reset_gen;
begin	
   rst_n = 1'b0;
   #(10*CLK_PRD) rst_n = 1'b1;
   $display("reset end");
end   
endtask

task cmd_latch;
begin
    nfc_if_cmd   = 8'h70;
    nfc_cmd_en   = 1'b1;
    #(CLK_PRD)
    nfc_cmd_en   = 1'b0;
    wait(nfif_cmd_done)
    $display("command latch cycle end");
    #(CLK_PRD);
end	
endtask

task addr_latch;
begin	
    {nfc_row_addr,nfc_col_addr} = 64'h00_22_cc_55_00_aa_03_02;
    nfc_addr_cnt = 8'b00_011_010;
    nfc_addr_en = 1'b1;
    #(CLK_PRD)
    nfc_addr_en = 1'b0;
    wait(nfif_addr_done);
    $display("addr latch cycle end");
    #(CLK_PRD);
end
endtask

task data_write;
integer i;
reg [DAT_WID-1:0] tmp;
begin
    i = 0;	
    nfc_dat_cnt = 'h10;
    nfc_dat_dir = 1'b1;
    #(CLK_PRD)
    nfc_dat_en  = 1'b1;
    #(CLK_PRD)
    nfc_dat_en = 1'b0;
//    for(i=0;i<nfc_dat_cnt;i=i+1)
    while(i<nfc_dat_cnt)
    begin
        @ (posedge nfif_rd_rdy) begin
	    tmp = $random;
	    i = i + 1;    
	    nfif_data_in = i;
	    #(CLK_PRD);
	    end
    end
    wait(nfif_dat_done)
    $display("data write end");
    #(CLK_PRD);
end
endtask

always @ (nfif_data_rd)
    nfif_rd_rdy <= #(CLK_PRD) nfif_data_rd;

task data_read;
integer i;	
reg [DAT_WID-1:0] tmp;
begin
    i = 0;	
    nfc_dat_cnt = 'h10;
    nfc_dat_dir = 1'b0;
    nf_din = 1;
    nfif_wr_rdy = 1'b1;
    #(CLK_PRD)
    nfc_dat_en  = 1'b1;
    #(CLK_PRD)
    nfc_dat_en = 1'b0;
//    for(i=0;i<nfc_dat_cnt;i=i+1)
    while(i<nfc_dat_cnt)
    begin
        @ (posedge nfif_data_wr) begin
	    #(CLK_PRD)
	    nfif_wr_rdy = 1'b0;
	    #(CLK_PRD)
    	    tmp = $random;
	    i = i + 1;    
	    nf_din = tmp;
            nfif_wr_rdy = 1'b1;
	    #(CLK_PRD);
	    end
    end
    wait(nfif_dat_done)
    $display("data read end");
    #(CLK_PRD);
end
endtask

task nf_test;
begin
    #1;
    #(20*CLK_PRD)	
    cmd_latch;
    #(50*CLK_PRD)
    addr_latch;
    #(50*CLK_PRD)
    data_write;
    #(50*CLK_PRD)
    data_read;
    #(50*CLK_PRD)
    nfc_tconf[7] = 1'b1;
    data_read;
    #(100*CLK_PRD)
    $finish;
end
endtask

initial
begin	
    nfc_dat_inv  = 'b0    ;
    nfc_dat_dir  = 'b0    ; // 1: Write 0: Read
    nfc_cmd_en   = 'b0    ;
    nfc_addr_en  = 'b0    ;
    nfc_dat_en   = 'b0    ;
    nfc_if_cmd   = 'h0    ;
    nfc_dat_cnt  = 'h0    ;
    {nfc_row_addr,nfc_col_addr}     = 64'h0  ;
    nfc_tconf    = 8'h00  ;
    nfc_mode     = 2'b00  ;
    nfif_rd_rdy  = 8'h0   ;
    nfif_data_in = 16'h0  ;    
#(CLK_PRD)
    nfc_tconf    = 8'h36  ;
end

task dump_fsdb;
begin
	$fsdbDumpfile("../debussy/nfif.fsdb");
	$fsdbDumpvars;
	$fsdbDumpflush;
end
endtask

initial
    fork
	clock_gen;
	reset_gen;
	dump_fsdb;
	nf_test  ; 
    join

nfc_if u_nfc_if(
    .clk            (clk),
    .rst_n          (rst_n),
    .nf_din         (nf_din),
    .nf_dout        (nf_dout),
    .nf_dir         (nf_dir),
    .nf_cle         (nf_cle),
    .nf_ale         (nf_ale),
    .nf_web         (nf_web),
    .nf_reb         (nf_reb),
    
    .nfc_dat_inv    (nfc_dat_inv),
    .nfc_dat_dir    (nfc_dat_dir),
    .nfc_cmd_en     (nfc_cmd_en),
    .nfc_if_cmd     (nfc_if_cmd),
    .nfc_addr_en    (nfc_addr_en),
    .nfc_col_addr   (nfc_col_addr),
    .nfc_row_addr   (nfc_row_addr),
    .nfc_addr_cnt   (nfc_addr_cnt),
    .nfc_dat_en     (nfc_dat_en),
    .nfc_dat_cnt    (nfc_dat_cnt),
    .nfc_tconf      (nfc_tconf),
    .nfc_mode       (nfc_mode),
    .nfif_cmd_done  (nfif_cmd_done),
    .nfif_addr_done (nfif_addr_done),
    .nfif_dat_done  (nfif_dat_done),   
    .nfif_data_rd   (nfif_data_rd),
    .nfif_rd_rdy    (nfif_rd_rdy),
    .nfif_data_in   (nfif_data_in),
    .nfif_data_wr   (nfif_data_wr),
    .nfif_data_out  (nfif_data_out),
    .nfif_wr_rdy    (nfif_wr_rdy)
);

endmodule
