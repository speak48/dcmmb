`timescale 1ns/1ns

module nfc_tb;
`include "nfc_parameter.v"
parameter CLK_PRD = 10;

reg                    clk             ;
reg                    clk_2x          ;
reg                    rst_n           ;
reg   [8       :0]     cpu_bfm_addr    ;
reg                    cpu_bfm_rd      ; 
reg                    cpu_bfm_wr      ; 
reg   [7       :0]     cpu_bfm_din     ; 

task clock_gen;
begin	
   clk = 1'b0;
   forever #(CLK_PRD/2) clk = ~clk; 
end   
endtask

task clock_gen_x2;
begin	
   clk_2x = 1'b0;
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

// bfm_write(,8'h); 
task nfc_test;
begin
    #1;
    #(100*CLK_PRD)
    // Latch Test
    bfm_write(NFC_IF_CMD_OFFSET, 8'h70);
    #(100*CLK_PRD)
    // Address Test
    bfm_write(NFC_ROW_ADDR0_OFFSET,8'h00);
    bfm_write(NFC_ROW_ADDR1_OFFSET,8'h22);
    bfm_write(NFC_ROW_ADDR2_OFFSET,8'hcc);
    bfm_write(NFC_ROW_ADDR3_OFFSET,8'h55);
    bfm_write(NFC_COLUMN_ADDR0_OFFSET,8'h02);
    bfm_write(NFC_COLUMN_ADDR1_OFFSET,8'h03);
    bfm_write(NFC_COLUMN_ADDR2_OFFSET,8'haa);
    bfm_write(NFC_COLUMN_ADDR3_OFFSET,8'h00);
    bfm_write(NFC_ADDR_CNT_OFFSET,8'b00_011_010);
    bfm_write(NFC_TIMING_CONFC_OFFSET,8'h36); 
    bfm_write(NFC_IF_CTRL0_OFFSET,8'b0000_0010); 
    //bfm_write(,8'h); 
    //bfm_write(,8'h); 
    #(150*CLK_PRD)
    bfm_write(NFC_TRN_CNT0_OFFSET,8'h10);
    bfm_write(NFC_IF_CTRL0_OFFSET,8'b1100_1001);
    #(300*CLK_PRD)
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
   .nfc_mif_reg_dout(), 
   .nf_ale_o        (), 
   .nf_ceb_o        (), 
   .nf_cle_o        (), 
   .nf_dat_o        (), 
   .nf_dat_i        (),
   .nf_rnb_i        (1'b1), 
   .nf_io_ctrl      (), 
   .nf_reb_o        (), 
   .nf_web_o        (), 
   .nf_wpb_o        (), 
   .nf_sram_addr    (nfc_ram_addr), 
   .nf_sram_cen     (nfc_ram_cen ), 
   .nf_sram_wen     (nfc_ram_wen ), 
   .nf_sram_wr_dat  (nfc_ram_din ), 
//   .nf_sram_rd_dat  (ram_nfc_dout) 
   .nf_sram_rd_dat  (16'h0 ) 
);

endmodule
