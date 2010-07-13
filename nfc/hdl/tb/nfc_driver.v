
//=========================================================
// Reset Command
//=========================================================
task RESET;
    begin
    bfm_write(NFC_IF_CMD_OFFSET, 8'hff); // command input reset
    #400;    
    end
endtask  
//#########################################################


//=========================================================
// Read Electronic Signature
//=========================================================
task READ_ES;
reg nfc_addr_en;
reg [7:0] sfr_reg;
begin
    bfm_write(NFC_IF_CMD_OFFSET      , 8'h90); // command input
    #(5*CLK_PRD);
    bfm_write(NFC_ROW_ADDR0_OFFSET, 8'h00);
    bfm_write(NFC_ADDR_CNT_OFFSET    , 8'b00_000_001);   
    #(5*CLK_PRD);
    nfc_addr_en = 1'b1;
    bfm_write(NFC_IF_CTRL0_OFFSET    , 8'b0000_0010); // address input
    while(nfc_addr_en) begin
        bfm_read(NFC_IF_CTRL0_OFFSET     , sfr_reg     );
        nfc_addr_en = sfr_reg[1];
        #(3*CLK_PRD);
    end
    bfm_write(NFC_BLK_LEN0_OFFSET,8'h2);
    bfm_write(NFC_BLK_LEN1_OFFSET,8'h0);    
    bfm_write(NFC_TRN_CNT0_OFFSET,8'h1);   
    bfm_write(NFC_IF_CTRL0_OFFSET        , 8'b0001_0001); // dst reg, ena data 
    #(10*CLK_PRD)   
    bfm_read(NFC_DATA_STATUS0_OFFSET     , sfr_reg     );
    $display("%t,Electronic Signature = [%h]",$realtime,sfr_reg);
    bfm_read(NFC_DATA_STATUS1_OFFSET     , sfr_reg     );
    $display("%t,Electronic Signature = [%h]",$realtime,sfr_reg);
    #(10*CLK_PRD);
end
endtask
//#########################################################

task READ_A;
begin
    bfm_write(NFC_IF_CMD_OFFSET, 8'h00); // command input area a
    #400;    
end
endtask

task READ_B;
begin
    bfm_write(NFC_IF_CMD_OFFSET, 8'h01); // command input area b
    #400;    
end
endtask

task READ_C;
begin
    bfm_write(NFC_IF_CMD_OFFSET, 8'h50); // command input area c
    #400;    
end
endtask

//=========================================================
// Read Status Register
//=========================================================

task READ_SR;
reg [7:0] sfr_reg;
begin
    bfm_write(NFC_IF_CMD_OFFSET, 8'h70); // command input area c
    #100;
    bfm_write(NFC_BLK_LEN0_OFFSET,8'h1);
    bfm_write(NFC_BLK_LEN1_OFFSET,8'h0);    
    bfm_write(NFC_TRN_CNT0_OFFSET,8'h1);   
    bfm_write(NFC_IF_CTRL0_OFFSET        , 8'b0001_0001); // dst reg, ena data    
    #(10*CLK_PRD)   
    bfm_read(NFC_DATA_STATUS0_OFFSET     , sfr_reg     );
    $display("%t,Electronic Signature = [%b]",$realtime,sfr_reg);
end
endtask

//=========================================================
// Page Program
//=========================================================
task PROGRAM;
input[7:0] addr_1st;
input[7:0] addr_2nd;
input[7:0] addr_3rd;
input[9:0] block_size;
input[3:0] trn_size;
//input      n;
integer    n,i;
reg nfc_addr_en;
reg [7:0] sfr_reg;
begin
    bfm_write(NFC_IF_CMD_OFFSET      , 8'h80); // command input, area a
    #(5*CLK_PRD);
    bfm_write(NFC_COLUMN_ADDR0_OFFSET, addr_1st);
    bfm_write(NFC_COLUMN_ADDR1_OFFSET, addr_2nd);
    bfm_write(NFC_COLUMN_ADDR2_OFFSET, addr_3rd);   
    bfm_write(NFC_ADDR_CNT_OFFSET    , 8'h3);   
    #(5*CLK_PRD);
    nfc_addr_en = 1'b1;
    bfm_write(NFC_IF_CTRL0_OFFSET    , 8'b0000_0010); // address input
    while(nfc_addr_en) begin
        bfm_read(NFC_IF_CTRL0_OFFSET , sfr_reg     );
        nfc_addr_en = sfr_reg[1]; // addr bit
        #(5*CLK_PRD);
    end
    bfm_write(NFC_BLK_LEN0_OFFSET,block_size[7:0]);
    bfm_write(NFC_BLK_LEN1_OFFSET,block_size[9:8]);
    bfm_write(NFC_TRN_CNT0_OFFSET,{4'h0,trn_size[3:0]});
    bfm_write(NFC_IF_CTRL0_OFFSET,8'b1110_1001); // Random Data from RND decrease
    nfc_addr_en = 1'b1;
    while(nfc_addr_en) begin
        bfm_read(NFC_IF_CTRL0_OFFSET , sfr_reg     );
        nfc_addr_en = sfr_reg[0]; // data bit
        #(5*CLK_PRD);
    end
    bfm_write(NFC_IF_CMD_OFFSET      , 8'h10); // confirm code
end
endtask

//=========================================================
// Read Memory Array
//=========================================================
task READ;
input[7:0] cmd;
input[7:0] addr_1st;
input[7:0] addr_2nd;
input[7:0] addr_3rd;
input[9:0] block_size;
input[3:0] trn_size;
integer    i,n,temp;
reg[12:0]  add_bk;
reg[4:0]   add_pg;
reg[9:0]   add_cl;
reg nfc_addr_en;
reg [7:0] sfr_reg;
begin
    bfm_write(NFC_IF_CMD_OFFSET      , cmd); // command input, area a
    #(5*CLK_PRD);
    bfm_write(NFC_COLUMN_ADDR0_OFFSET, addr_1st);
    bfm_write(NFC_COLUMN_ADDR1_OFFSET, addr_2nd);
    bfm_write(NFC_COLUMN_ADDR2_OFFSET, addr_3rd);   
    bfm_write(NFC_ADDR_CNT_OFFSET    , 8'h3);   
    #(5*CLK_PRD);
    nfc_addr_en = 1'b1;
    bfm_write(NFC_IF_CTRL0_OFFSET    , 8'b0000_0010); // address input
    while(nfc_addr_en) begin
        bfm_read(NFC_IF_CTRL0_OFFSET , sfr_reg     );
        nfc_addr_en = sfr_reg[1]; // addr bit
        #(5*CLK_PRD);
    end
    #15e3;// waiting for busy signal
    bfm_write(NFC_BLK_LEN0_OFFSET,block_size[7:0]);
    bfm_write(NFC_BLK_LEN1_OFFSET,block_size[9:8]);
    bfm_write(NFC_TRN_CNT0_OFFSET,{4'h0,trn_size[3:0]});
    bfm_write(NFC_IF_CTRL0_OFFSET,8'b0000_0001); // read data from NF
    nfc_addr_en = 1'b1;
    while(nfc_addr_en) begin
        bfm_read(NFC_IF_CTRL0_OFFSET , sfr_reg     );
        nfc_addr_en = sfr_reg[0]; // data bit
        #(5*CLK_PRD);
    end
    
//    if(cmd === 8'h00) temp = addr_1st;
//    if(cmd === 8'h01) temp = 256 + addr_1st;
//    if(cmd === 8'h50) temp = 512 + addr_1st[3:0];
//    add_bk = U_NAND256R3A.addr_block;
//    add_pg = U_NAND256R3A.addr_page;
//    add_cl = U_NAND256R3A.addr_column;
   
end
endtask
