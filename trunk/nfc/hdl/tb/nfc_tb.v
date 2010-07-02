`timescale 1ns/1ns

module nfc_tb;
parameter CLK_PRD = 20;
`include "nfc_parameter.v"
`include "nfc_driver.v"


reg                    clk             ;
reg                    clk_2x          ;
reg                    rst_n           ;
reg   [8       :0]     cpu_bfm_addr    ;
reg                    cpu_bfm_rd      ; 
reg                    cpu_bfm_wr      ; 
reg   [7       :0]     cpu_bfm_din     ; 
wire  [7       :0]     cpu_bfm_dout    ;

wire   [12        :0]  nfc_ram_addr    ;  
wire                   nfc_ram_cen     ;  
wire   [1         :0]  nfc_ram_wen     ;  
wire   [15        :0]  nfc_ram_din     ;  
wire   [15        :0]  ram_nfc_dout    ; 

wire         nf_ale_o;
wire  [3:0]  nf_ceb_o;
wire         nf_cle_o;
wire  [15:0] nf_dat_o;
wire         nf_io_ctrl;
wire         nf_reb_o;
wire         nf_web_o;
wire         nf_wpb_o;
wire  [15:0] nf_dat_i;
wire         nf_rnb_i;

task clock_gen;
begin	
   clk = 1'b0;
   forever #(CLK_PRD/2) clk = ~clk; 
end   
endtask

task clock_gen_x2;
begin	
   clk_2x = 1'b0;
   #(CLK_PRD/2) clk_2x = 1'b1;
   forever #(CLK_PRD/4) clk_2x = ~clk_2x; 
end   
endtask

task reset_gen;
begin	
   rst_n = 1'b0;
   #(10*CLK_PRD) rst_n = 1'b1;
   $display("reset end");
end   
endtask

task dump_fsdb;
begin
    $fsdbDumpfile("../debussy/nfc.fsdb");
    $fsdbDumpvars;
    $fsdbDumpflush;
end
endtask

initial
begin	
    cpu_bfm_addr    = 'h0;
    cpu_bfm_rd      = 'b0;
    cpu_bfm_wr      = 'b0;
    cpu_bfm_din     = 'b0;
end

task bfm_write;
input [8 :0] bfm_addr;
input [7 :0] bfm_data;
begin
    #(CLK_PRD)
    cpu_bfm_addr = bfm_addr;
    cpu_bfm_din  = bfm_data;
    cpu_bfm_wr   = 1'b1;
    #(CLK_PRD)  
    cpu_bfm_addr = 'h0;
    cpu_bfm_din  = 'h0;
    cpu_bfm_wr   = 1'b0;
end
endtask

task bfm_read;
input  [8 :0] bfm_addr;
output [7 :0] bfm_data;
begin
    #(CLK_PRD)
    cpu_bfm_addr = bfm_addr;
    cpu_bfm_rd   = 1'b1;
    #(CLK_PRD)  
    cpu_bfm_addr = 'h0;
    bfm_data = cpu_bfm_dout;
    cpu_bfm_rd   = 1'b0;
end
endtask

// bfm_write(,8'h); 
task nfc_test;
reg [9:0] block_size;
reg [9:0]  data_size;
reg [7:0] trn_size;
begin
    #1;
    block_size = 'd512;
    data_size  = 'd512;
    #(100*CLK_PRD)
//    bfm_write(NFC_TIMING_CONFC_OFFSET,8'b0_000_0000);
    bfm_write(NFC_TIMING_CONFC_OFFSET,8'b0_100_0100);
    #(100*CLK_PRD)
    READ_ES;
    #(20*CLK_PRD)
    READ_SR;
    $display("****************************************************************");
    #(20*CLK_PRD) 
    READ(8'h01,8'h00,8'h00,8'h00,1,1);  //area b,read block 0,page 0,column 256
    #(20*CLK_PRD)
    bfm_write(NFC_IF_CTRL1_OFFSET,8'bx000_1110);
    bfm_write(NFC_RAND_SEED2_OFFSET,8'hab);
    bfm_write(NFC_RAND_SEED3_OFFSET,8'haa);
    PROGRAM(8'h00,8'h00,8'h00,(256+16),1);
    #600e3;
    READ_SR;
    #(20*CLK_PRD);
    bfm_write(NFC_IF_CTRL1_OFFSET,8'bx100_1110);
    #(20*CLK_PRD);
    READ_B;
    bfm_write(NFC_RAND_SEED2_OFFSET,8'hab);
    bfm_write(NFC_RAND_SEED3_OFFSET,8'haa);
    PROGRAM(8'h00,8'h00,8'h00,(256+16),1);
    #600e3;
    READ_SR;
    $display("****************************************************************");
  //  READ(8'h00,8'hff,8'h00,8'h00,(256+16+2),1);   //area a,read block 0,page 0,column 255 ~ block 0,page 1,column 0
  //  READ_B;
    READ(8'h01,8'h00,8'h00,8'h00,(256),1);
  //   #(6300*CLK_PRD)
    $finish;
end
endtask 
  
initial
    fork
	clock_gen;
	clock_gen_x2;
	reset_gen;
	dump_fsdb;
	nfc_test  ; 
    join

nfc u_nfc( 
   .nfc_clk         (clk), 
   .ecc_clk         (clk_2x), 
   .rstb_nfc        (rst_n), 
   .mif_nfc_reg_addr(cpu_bfm_addr), 
   .mif_nfc_reg_rd  (cpu_bfm_rd  ), 
   .mif_nfc_reg_wr  (cpu_bfm_wr  ), 
   .mif_nfc_reg_din (cpu_bfm_din ), 
   .nfc_mif_reg_dout(cpu_bfm_dout), 
   .nf_ale_o        (nf_ale_o), 
   .nf_ceb_o        (nf_ceb_o), 
   .nf_cle_o        (nf_cle_o), 
   .nf_dat_o        (nf_dat_o), 
   .nf_dat_i        (nf_dat_i),
   .nf_rnb_i        (nf_rnb_i), 
   .nf_io_ctrl      (nf_io_ctrl), 
   .nf_reb_o        (nf_reb_o), 
   .nf_web_o        (nf_web_o), 
   .nf_wpb_o        (nf_wpb_o), 
   .nf_sram_addr    (nfc_ram_addr), 
   .nf_sram_cen     (nfc_ram_cen ), 
   .nf_sram_wen     (nfc_ram_wen ), 
   .nf_sram_wr_dat  (nfc_ram_din ), 
   .nf_sram_rd_dat  (ram_nfc_dout) 
//   .nf_sram_rd_dat  (16'h0 ) 
);

reg [15:0]  data;
assign ram_nfc_dout = data;

dpram_4p5x16 dpram_4p5x16(
        .clka        (clk),
        .dpram_dina (nfc_ram_din),
        .dpram_addra (nfc_ram_addr[12:0]),
        .dpram_cena  (nfc_ram_cen),
        .dpram_wena  (nfc_ram_wen),
//        .dpram_douta (ram_nfc_dout)
        .dpram_douta  ()
        );

always @ (posedge clk)
begin
    if(nfc_ram_cen == 1'b0)	
        data <= #1 $random;
//    else
//	data <= #1 16'hXX;
end

  wire [7:0] IO   ;
  wire       CE   ;
  wire       WE   ;
  wire       RE   ;
  wire       WP   ;
  wire       CLE  ;
  wire       ALE  ;
  reg        VDD  ;
  reg        VSS  ;
  wire       RY_BY;

assign CE = nf_ceb_o[0];
assign WE = nf_web_o;
assign RE = nf_reb_o;
assign WP = nf_wpb_o;
assign CLE = nf_cle_o;
assign ALE = nf_ale_o;

pullup(RY_BY);
assign nf_rnb_i = RY_BY;
assign IO = nf_io_ctrl ? nf_dat_o[7:0] : 8'hzz;
assign nf_dat_i = {8'h0, IO};

initial begin
  VDD     = 1'b0;
  VSS     = 1'b0;
  #100
  VDD     = 1'b1;
  #100;
end
  
                        
NAND256R3A U_NAND256R3A
                         (
                          .IO(IO),
                          .CE(CE),
                          .WE(WE),
                          .RE(RE),
                          .WP(WP),
                          .CLE(CLE),
                          .ALE(ALE),
                          .RY_BY(RY_BY),
                          .VDD(VDD),
                          .VSS(VSS)
                         );
	    
endmodule

/*
task nfc_test;
reg [9:0] block_size;
reg [9:0]  data_size;
reg [7:0] trn_size;
begin
    #1;
    block_size = 'd512;
    data_size  = 'd512;
    #(100*CLK_PRD)
    // Latch Test
    bfm_write(NFC_TIMING_CONFC_OFFSET,8'b0_000_0000);
//    bfm_write(NFC_TIMING_CONFC_OFFSET,8'b0_001_0001);
    bfm_write(NFC_IF_CMD_OFFSET, 8'h70);
    #(100*CLK_PRD)
    // Address Test
    bfm_write(NFC_ROW_ADDR0_OFFSET,8'h55);
    bfm_write(NFC_ROW_ADDR1_OFFSET,8'h22);
    bfm_write(NFC_ROW_ADDR2_OFFSET,8'hcc);
    bfm_write(NFC_ROW_ADDR3_OFFSET,8'h66);
    bfm_write(NFC_COLUMN_ADDR0_OFFSET,8'h02);
    bfm_write(NFC_COLUMN_ADDR1_OFFSET,8'h03);
    bfm_write(NFC_COLUMN_ADDR2_OFFSET,8'haa);
    bfm_write(NFC_COLUMN_ADDR3_OFFSET,8'h00);
    bfm_write(NFC_ADDR_CNT_OFFSET,8'b00_010_011); // col, row
    bfm_write(NFC_IF_CTRL0_OFFSET,8'b0000_0010); 
    //bfm_write(,8'h); 
    //bfm_write(,8'h); 
    #(100*CLK_PRD)
    bfm_write(NFC_BLK_LEN0_OFFSET,block_size[7:0]);
    bfm_write(NFC_BLK_LEN1_OFFSET,block_size[9:8]);
    bfm_write(NFC_RED_LEN_OFFSET,8'b00_0_00000);

// ECC set        
    bfm_write(NFC_ECC_CFG0_OFFSET,block_size[7:0]);
    bfm_write(NFC_ECC_CFG1_OFFSET,block_size[9:8]);   

    bfm_write(NFC_ECC_CTRL_OFFSET,8'b0000_0_0_1_1); //{ ECC_ENC, ECC_8_bit ECC EN }
    
    trn_size = 4'd2; // 'd13 'd25
    bfm_write(NFC_TRN_CNT0_OFFSET,trn_size[7:0]);
//    bfm_write(NFC_TRN_CNT1_OFFSET,trn_size[15:8]);
    bfm_write(NFC_RAND_SEED2_OFFSET,8'hab);
    bfm_write(NFC_RAND_SEED3_OFFSET,8'haa);
    bfm_write(NFC_IF_CTRL0_OFFSET,8'b1110_1001); // Random Data from RND decrease
//    bfm_write(NFC_IF_CTRL0_OFFSET,8'b0000_1001); // Read data from memory
//    #(150*CLK_PRD)
//    bfm_write(NFC_IF_CTRL0_OFFSET,8'b0000_1001); // Read data from memory
    #(2300*CLK_PRD)
    bfm_write(NFC_TIMING_CONFC_OFFSET,8'b0_001_0001);
    bfm_write(NFC_DATA_ADDR0_OFFSET,8'h00);
    bfm_write(NFC_DATA_ADDR1_OFFSET,8'h01);    
    bfm_write(NFC_SPARE_ADDR0_OFFSET,8'h00);
    bfm_write(NFC_SPARE_ADDR1_OFFSET,8'h07);
//    bfm_write(NFC_RED_LEN_OFFSET,8'b0010_1111);
//    ECC set        
//    block_size = data_size + 5'h10;
    bfm_write(NFC_ECC_CFG0_OFFSET,block_size[7:0]);
    bfm_write(NFC_ECC_CFG1_OFFSET,block_size[9:8]);   

    bfm_write(NFC_ECC_CTRL_OFFSET,8'b0000_0_0_1_1); //{ ECC_ENC, ECC_8_bit ECC EN }
    bfm_write(NFC_IF_CTRL0_OFFSET,8'b1110_1001); // Random Data from RND decrease
    //bfm_write(NFC_IF_CTRL0_OFFSET,8'b0000_1001); // Read data from memory
    #(3300*CLK_PRD)
 //   bfm_write(NFC_TIMING_CONFC_OFFSET,8'b0_100_0101);
 //   bfm_write(NFC_IF_CTRL0_OFFSET,8'b1110_1001); // Random Data from RND decrease
 //   #(6300*CLK_PRD)
    $finish;
end
endtask 
*/