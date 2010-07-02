/****************************************************************************************

  NAND256R3A Parameters Definitions

  256Mbits (x8, 2048 Blocks, 32 Pages, 528 Bytes) 1.8V NAND Flash Memory

  Copyright (c) 2004 STMicroelectronics

*****************************************************************************************

  Model Version : 1.0

  Author : Xue-Feng Hu

*****************************************************************************************

  Model Version History:
-----------------------------------------------------------------------------------------
  1.0: Oct. 2004  First Version Release.

****************************************************************************************/

`timescale      1ns/1ns
`include  "NAND_PARAM.v"

//-----------------------------------------------------------------------------
// Memory control
//-----------------------------------------------------------------------------
`define MEMORY_ALLOC        1  //1:whole 0:partial
`define NO_OF_BLK_ALLOC     5  //the number of partial blocks if above is '0'

//-----------------------------------------------------------------------------
// Difinitions of Electronic Signature
//-----------------------------------------------------------------------------
`define MANUFC_CODE         8'h20
`define DEVICE_CODE         8'h35

//=======================================================================================
// NAND256R3A 256Mbits(x8 bus width), 528 Bytes Page, 1.8V Device Simulation Model
//=======================================================================================
module NAND256R3A(
                   IO,
                   CE,
                   WE,
                   RE,
                   WP,
                   CLE,
                   ALE,
                   RY_BY,
                   VDD,
                   VSS
                 );

parameter NUM_BLKS = `MEMORY_ALLOC ? `BLK_IN_MEMORY : `NO_OF_BLK_ALLOC;
parameter MEM_SIZE = `MEMORY_ALLOC ? `PAGE_IN_BLOCK * `COL_IN_PAGE * `BLK_IN_MEMORY :
                                     `PAGE_IN_BLOCK * `COL_IN_PAGE * `NO_OF_BLK_ALLOC;

//===============================================
// Difinition regarding input/output signal
//===============================================
inout [7:0]        IO;
input              CE;
input              WE;
input              RE;
input              WP;
input              CLE;
input              ALE;
input              VDD;
input              VSS;
output             RY_BY;

//=============================================================================
// For Input Signals: Attach 'I', For Output Signals: Attach 'O'.
// RY_BY is output by buffer, output '0' is strong and '1' is Weak.
//=============================================================================
reg [7:0] dout;
reg eIO;
//-----------------------------------------------
wire[`D_WIDTH-1:0] iIO    ;
wire[`D_WIDTH-1:0] oIO    ;
wire               iCE    ;
wire               iWE    ;
wire               iRE    ;
wire               iWP    ;
wire               iCLE   ;
wire               iALE   ;
wire               oRY_BY ;
//-----------------------------------------------
assign iCE    =    CE  & 1'b1;
assign iWE    =    WE  & 1'b1;
assign iRE    =    RE  & 1'b1;
assign iWP    =    WP  & 1'b1;
assign iCLE   =    CLE & 1'b1;
assign iALE   =    ALE & 1'b1;
assign IO     =    eIO ? oIO : 8'hzz;
assign oIO    =    dout;
assign iIO    =    IO  & 8'hff ;
assign RY_BY  =    oRY_BY ? 1'bz : 1'b0;

//-----------------------------------------------
//RY_BY output, an open drain output
//-----------------------------------------------
reg BUSY_BY_RD,BUSY_BY_PG,BUSY_BY_BE,BUSY_BY_RESET;
//-----------------------------------------------
assign oRY_BY = BUSY_BY_RESET & BUSY_BY_RD & BUSY_BY_PG & BUSY_BY_BE;

//=============================================================================
// Back up previous values of input signals; Named by addition 'b'.
//=============================================================================
reg[`D_WIDTH-1:0] bIO  ;
reg               bCE  ;
reg               bWE  ;
reg               bRE  ;
reg               bWP  ;
reg               bCLE ;
reg               bALE ;
//-----------------------------------------------
always@(iIO)      bIO  <= iIO  ;
always@(iCE)      bCE  <= iCE  ;
always@(iWE)      bWE  <= iWE  ;
always@(iRE)      bRE  <= iRE  ;
always@(iWP)      bWP  <= iWP  ;
always@(iCLE)     bCLE <= iCLE ;
always@(iALE)     bALE <= iALE ;

//===============================================
// Parameters Regarding Commands
//===============================================
parameter CMD_READ_A          = 8'h00 ;
parameter CMD_READ_B          = 8'h01 ;
parameter CMD_READ_C          = 8'h50 ;
parameter CMD_RESET           = 8'hff ;
parameter CMD_READ_ES         = 8'h90 ;
parameter CMD_READ_SR         = 8'h70 ;
parameter CMD_PAGE_PROGRAM_1  = 8'h80 ; //page program setup code
parameter CMD_PAGE_PROGRAM_2  = 8'h10 ; //page program and copy back program confirm code
parameter CMD_COPY_BACK_PG    = 8'h8A ; //copy back program
parameter CMD_BLOCK_ERASE_1   = 8'h60 ; //block erase setup code
parameter CMD_BLOCK_ERASE_2   = 8'hD0 ; //block erase confirm code

//===============================================
// Parameters Regarding Commands
//===============================================
reg[1:0]  operation;
//-----------------------------------------------
parameter OP_READY            = 2'b00 ;
parameter OP_READ             = 2'b01 ;
parameter OP_PROGRAM          = 2'b10 ;
parameter OP_ERASE            = 2'b11 ;

//===============================================
// Memory Main Register
//===============================================
reg [`D_WIDTH-1:0] DATA[`COL_IN_PAGE-1:0];
reg [`D_WIDTH-1:0] MEMORY[MEM_SIZE-1:0];
reg [`D_WIDTH-1:0] REG_CMD;
reg [`ADD_BIT-1:0] REG_ADD;
reg [`D_WIDTH-1:0] REG_STAT;
reg [`BLK_BIT-1:0] addr_block;
reg [`PAG_BIT-1:0] addr_page;
reg [`COL_BIT-1:0] addr_column;

//===============================================
// Variable of AC Timing
//===============================================
reg  iIO_C;
reg  iCE_R,iCE_F;
reg  iWE_R,iWE_F;
reg  iRE_R,iRE_F;
reg  iCLE_R,iCLE_F;
reg  iALE_R,iALE_F;
//---------------------------
time tc_iIO;
time tr_iCE,tf_iCE;
time tr_iWE,tf_iWE;
time tr_iRE,tf_iRE;
time tr_iCLE,tf_iCLE;
time tr_iALE,tf_iALE;

//===============================================
// Generate Mode Signals By Decoding Commands
//===============================================
wire  MOD_READ_A          ;
wire  MOD_READ_B          ;
wire  MOD_READ_C          ;
wire  MOD_RESET           ;
wire  MOD_READ_ES         ;
wire  MOD_READ_SR         ;
wire  MOD_PAGE_PROGRAM_1  ;
wire  MOD_PAGE_PROGRAM_2  ;
wire  MOD_COPY_BACK_PG    ;
wire  MOD_BLOCK_ERASE_1   ;
wire  MOD_BLOCK_ERASE_2   ;
wire  MOD_READ_MODE       ; //read mode A or B or C
//-----------------------------------------------------------------------------
assign MOD_READ_A         = ( REG_CMD == CMD_READ_A );
assign MOD_READ_B         = ( REG_CMD == CMD_READ_B );
assign MOD_READ_C         = ( REG_CMD == CMD_READ_C );
assign MOD_RESET          = ( REG_CMD == CMD_RESET  );
assign MOD_READ_ES        = ( REG_CMD == CMD_READ_ES );
assign MOD_READ_SR        = ( REG_CMD == CMD_READ_SR );
assign MOD_PAGE_PROGRAM_1 = ( REG_CMD == CMD_PAGE_PROGRAM_1 );
assign MOD_PAGE_PROGRAM_2 = ( REG_CMD == CMD_PAGE_PROGRAM_2 );
assign MOD_COPY_BACK_PG   = ( REG_CMD == CMD_COPY_BACK_PG );
assign MOD_BLOCK_ERASE_1  = ( REG_CMD == CMD_BLOCK_ERASE_1 );
assign MOD_BLOCK_ERASE_2  = ( REG_CMD == CMD_BLOCK_ERASE_2 );
assign MOD_READ_MODE      = ( MOD_READ_A ) || ( MOD_READ_B ) || (MOD_READ_C);

//=============================================================================
integer addr_temp1,addr_temp2;
integer l,signature,add_cycle;
//-------------------------------------
reg COPYBACK_ID1;
reg COPYBACK_ID2;
reg ADD_COMPLETE;
reg DIN_COMPLETE;
reg programming1;
reg programming2;
reg blockerasing;
//-------------------------------------
reg power_on,reset,wr_addr_bk;
reg area_a,area_b,area_c;
reg not_blank,wr_protect,last_data;
//-------------------------------------
reg [`CHP_BIT-1:0] address_src;
reg [`CHP_BIT-1:0] address_tgt;
reg [`COL_BIT-1:0] start_addr,end_addr;
integer m;
//=============================================================================
initial begin
  $display ("%t: Note: Load memory with Initial content.",$realtime); 
  for(l=0;l< NUM_BLKS;l=l+1) begin
    //$display("%d,%d",l*528*32,(l*528*32+528*32-1));
    $readmemh("NAND_BLK_INIT.txt",MEMORY,l*528*32,(l*528*32+528*32-1));
  end
  $display ("%t: Note: Initial Load End.\n",$realtime);
  //-----------------------------------------------------------------
  operation      = OP_READY;
  power_on       = 1'b0;
  reset          = 1'b0;
  BUSY_BY_RESET  = 1'b1;
  BUSY_BY_RD     = 1'b1;    
  BUSY_BY_PG     = 1'b1;    
  BUSY_BY_BE     = 1'b1;
end

//=============================================================================
// Genarate power_on signal
// power_on: has initial value 0, after power supply is provided, gets to 1
//           indicates if the correct voltage has been supplied.
//=============================================================================
always@(VDD or VSS)
begin
  if( VSS !== 1'b0 )
  begin
    power_on <= 1'b0; $display("%t Note: Vss is not connected to the ground well!\n",$realtime);
  end
  else if(( VDD == 1'b1 ) && ( VSS == 1'b0 ))
  begin
    power_on <= 1'b1; $display("%t Note: Device is powered on!\n",$realtime);
  end
  else if(( power_on == 1'b1 ) && ( VDD !== 1'b1 ) && ( VSS == 1'b0 ))
  begin
    power_on <= 1'b0; $display("%t Note: Device is powered off!\n",$realtime);
  end
  else if(( power_on == 1'b0 ) && ( VDD !== 1'b1 ) && ( VSS == 1'b0 ))
  begin
    power_on <= 1'b0; $display("%t Note: Device is not powered on!\n",$realtime);
  end
end

//=========================================================
// Genarate wr_protect signal
//=========================================================
always@(negedge iWP)
begin
  if(power_on && ({bWP,iWP} == 2'b10) && (MOD_PAGE_PROGRAM_1 || MOD_BLOCK_ERASE_1 || MOD_COPY_BACK_PG))
  begin
    wr_protect <= 1'b1;
    REG_STAT[7] <= 1'b0;  //wrprotected
  end
end
//---------------------------------------------------------
always@(posedge MOD_COPY_BACK_PG or posedge MOD_PAGE_PROGRAM_1 or posedge MOD_BLOCK_ERASE_1)
begin
  if(power_on && iWP === 1'b0)
  begin
    wr_protect <= 1'b1;
    REG_STAT[7] <= 1'b0;  //wrprotected
  end
  if(power_on && iWP === 1'b1)
  begin
    wr_protect <= 1'b0;
    REG_STAT[7] <= 1'b1;  //unprotected
  end
end

//=========================================================
// Generate signal which indicate the selected area
//=========================================================
always@(posedge MOD_READ_A) {area_a,area_b,area_c}<=3'b100;
always@(posedge MOD_READ_B) {area_a,area_b,area_c}<=3'b010;
always@(posedge MOD_READ_C) {area_a,area_b,area_c}<=3'b001;

//=========================================================
//                   reset operation
//=========================================================
always@(posedge MOD_RESET) reset <= 1'b1;
//---------------------------------------------------------
always@(posedge reset or posedge power_on)
begin
  //power on reset
  operation     <= OP_READY;
  signature     <= 0;
  add_cycle     <= 0;
  reset         <= 1'b0;
  not_blank     <= 1'b0;
  eIO           <= 1'b0;
  area_a        <= 1'b1;
  area_b        <= 1'b0;
  area_c        <= 1'b0;
  wr_protect    <= 1'b0;
  wr_addr_bk    <= 1'b1;
  last_data     <= 1'b0;
  BUSY_BY_RD    <= 1'b1;    
  BUSY_BY_PG    <= 1'b1;    
  BUSY_BY_BE    <= 1'b1;
  COPYBACK_ID1  <= 1'b0;
  COPYBACK_ID2  <= 1'b0;
  REG_CMD       <= 8'h00;
  REG_ADD       <= 8'h00;
  REG_STAT      <= 8'he0;
  //if reset command is active
  if(power_on && reset)
  begin
    $display("%t Note: Memory internal reset!\n",$realtime);
    case(operation)
      OP_READY   : begin BUSY_BY_RESET <= 1'b0; BUSY_BY_RESET <= #(`tRESET_RY) 1'b1; end
      OP_READ    : begin BUSY_BY_RESET <= 1'b0; BUSY_BY_RESET <= #(`tRESET_RD) 1'b1; end
      OP_PROGRAM : begin BUSY_BY_RESET <= 1'b0; BUSY_BY_RESET <= #(`tRESET_PG) 1'b1; end
      OP_ERASE   : begin BUSY_BY_RESET <= 1'b0; BUSY_BY_RESET <= #(`tRESET_ER) 1'b1; end
    endcase
  end
end

//=========================================================
// Command Input Bus Operation
//=========================================================
always@(posedge iWE)
begin
  if(power_on && {iCE,iALE,iCLE,iRE,iWE,bWE}===6'b001110)
    if(CMD_CHECK(iIO) == 1'b1) REG_CMD <= iIO;
end
//---------------------------------------------------------
// Command Latch Enable, IO as input mode
//---------------------------------------------------------
always@(posedge iCLE)
begin
  if(power_on && iCE==1'b0)
  begin
    eIO <= 1'b0;
    ADD_COMPLETE <= 1'b0;
  end
end

//===================================================================
// Address Input Bus Operation
//===================================================================
always@(posedge iWE)
begin
  if(power_on && {iCE,iALE,iCLE,iRE,iWE,bWE}===6'b010110) begin
  //-----------------------------------------------------------------
  //1. Latch Address After Read, Program Command Setup Code
  //-----------------------------------------------------------------
    if(MOD_READ_MODE || MOD_PAGE_PROGRAM_1 || MOD_COPY_BACK_PG) begin
      case(add_cycle)
        3:   REG_ADD <= {REG_ADD[`ADD_BIT-1:9],area_b,iIO};
        2:   REG_ADD <= {REG_ADD[`ADD_BIT-1:17],iIO,REG_ADD[8:0]};
        1: begin
             REG_ADD <= {iIO,REG_ADD[16:0]};
             ADD_COMPLETE <= 1'b1; //cycles for address input is over
             if(MOD_PAGE_PROGRAM_1) wr_addr_bk <= 1'b1;
           end
      endcase
      ADD_CYC_DETECT;
    end
  //-----------------------------------------------------------------
  //2. Latch Address After Block Erase Command Setup Code
  //-----------------------------------------------------------------
    else if(MOD_BLOCK_ERASE_1) begin
      case(add_cycle)
        2:   REG_ADD <= {REG_ADD[`ADD_BIT-1:17],iIO,{`ADD_COL{1'b0}}};
        1: begin
             REG_ADD <= {iIO,REG_ADD[16:0]};
             ADD_COMPLETE <= 1'b1; //cycles for address input is over
           end
      endcase
      ADD_CYC_DETECT;
    end
  //-----------------------------------------------------------------
  //3. Latch Address After Read E.S. Command Code, (address is 00H)
  //-----------------------------------------------------------------
    else if(MOD_READ_ES) begin
      case(add_cycle)
        1: if(iIO == 8'h00) ADD_COMPLETE <= 1'b1;
           else begin
             REG_CMD <= 8'h55;  //command register reset to 55
             $display("%t, Error: Invalid Address[%h] in Read ES Command, the Address must be '00H'.\n",$realtime,iIO);
           end
      endcase
      ADD_CYC_DETECT;
    end
  //-----------------------------------------------------------------
  //4. In other Commands, they need not address input
  //-----------------------------------------------------------------
    else begin
      REG_CMD <= 8'h55;  //command register reset to 55
      $display("%t, Error: Invalid Command Sequence! A redundant address cycle is inputted!\n",$realtime);
    end
  end
end
//-------------------------------------------------------------------
always@(posedge ADD_COMPLETE)
begin
  if(power_on && MOD_READ_MODE || MOD_PAGE_PROGRAM_1 || MOD_COPY_BACK_PG || MOD_BLOCK_ERASE_1)
  begin
    addr_page <= REG_ADD[`ADD_BIT-`BLK_BIT-1:`ADD_BIT-`BLK_BIT-`PAG_BIT];
    addr_block <= REG_ADD[`ADD_BIT-1:`ADD_BIT-`BLK_BIT];
    if(MOD_READ_MODE) begin
      COPYBACK_ID1 <= #( 0 )  1'b1; //flag for wait copy back program command
      BUSY_BY_RD   <= #(`tR)  1'b1;
      BUSY_BY_RD   <= #(`tWB) 1'b0; //#(`tWB): write enable high to ready/busy low
    end
    if(MOD_COPY_BACK_PG)  COPYBACK_ID2 <= 1'b1;
  end 
end
//-------------------------------------------------------------------
task ADD_CYC_DETECT;
  begin
    if(add_cycle > 0) add_cycle <= add_cycle - 1;
    //input address cycles exceed
    else if(add_cycle == 0) begin
      REG_CMD <= 8'h55;  //command register reset to 55
      $display("%t, Error: Invalid Command Sequence! A redundant address cycle is inputted!\n",$realtime);
    end
  end
endtask

//===================================================================
//  Data Register Pointer (IN PAGE)
//===================================================================
always@(posedge iWE)
begin
  if(power_on && MOD_READ_MODE && {iCE,iALE,iCLE,iRE,iWE,bWE}===6'b010110) begin
    if(add_cycle === 3 && area_c === 1'b0) addr_column <= {area_c,area_b,iIO};
    if(add_cycle === 3 && area_c === 1'b1) addr_column <= {area_c,area_b,4'b0000,iIO[3:0]};
  end else
  if(power_on && MOD_PAGE_PROGRAM_1 && {iCE,iALE,iCLE,iRE,iWE,bWE}===6'b010110) begin
    if(add_cycle === 3 && area_c === 1'b0) addr_column <= {area_c,area_b,iIO};
    if(add_cycle === 3 && area_c === 1'b1) addr_column <= {area_c,area_b,4'b0000,iIO[3:0]};
  end
end

//===================================================================
//  Data Input Bus Operation (In PAGE PORGRAM MODE)
//===================================================================
always@(posedge iWE)
begin
  if(power_on && {iCE,iALE,iCLE,iRE,iWE,bWE}===6'b000110)
  begin
    //In Page Program mode, data is written in data buffer
    if(MOD_PAGE_PROGRAM_1 && ADD_COMPLETE)
    begin
      if(wr_addr_bk === 1'b1) begin
        wr_addr_bk <= 1'b0;
        start_addr <= addr_column;
      end
      if(addr_column < `COL_IN_PAGE) begin
        DATA[addr_column] <= iIO;
        end_addr <= addr_column;
        addr_column <= addr_column + 1;
      end
      //if(addr_column == (`COL_IN_PAGE-1))
      //begin
      //  DIN_COMPLETE <= 1'b1;
      //  $display("%t, Note: Input data is loaded into the last byte of data buffer.\n",$realtime);
      //end
    end
    //In Page Program mode, data input during addr input cycle
    if(MOD_PAGE_PROGRAM_1 && !ADD_COMPLETE)
    begin
      REG_CMD <= 8'h55;
      $display("%t, Error: Invalid Command Sequence! Data can't be inputted during address cycles!\n",$realtime);
    end
    //In other mode, they need not data byte input
    if(!MOD_PAGE_PROGRAM_1)
    begin                  
      REG_CMD <= 8'h55;
      $display("%t, Error: Invalid Command Sequence! A redundant data cycle is inputted!\n",$realtime);
    end
  end
end

//===================================================================
// read enable rising edge for read operation
//===================================================================
always@(posedge iRE)
begin
  if(power_on && operation === OP_READ)
  begin
    //data hold time tRHQZ has the value of 15ns~30ns; //2004/12/13
    //here first 15ns the data is maintained and the last 15ns the data is 'z'.
    dout <= #(`tRHZ/2) 8'hzz;
    //if read enable after the data in last column of page is output;
    //memory is busy, and next page is automatically loaded.
    if(MOD_READ_MODE && last_data === 1'b1)
    begin
      last_data <= 1'b0;
      BUSY_BY_RD <= #(`tRB) 1'b0;
      BUSY_BY_RD <= #(`tRB + `tBLBH1) 1'b1;
    end
  end
end

//===============================================
//          read memory array operation
//===============================================
always@(negedge iRE)
begin
  if(power_on && MOD_READ_MODE && ADD_COMPLETE && {iCE,iALE,iCLE,iRE,iWE,bRE,oRY_BY}===7'b0000111)
  begin
    //if the read operation is started;
    //the copy back program wait flag will be cleared.
    if(COPYBACK_ID1 === 1'b1) COPYBACK_ID1 <= 1'b0;
    //-----------------------------------------------------
    operation <= OP_READ;
    //"tREA" is rd enable low to output valid.
    eIO <= #(`tREA) 1'b1;
    dout <= #(`tREA) MEMORY[{addr_block,addr_page,addr_column} - ({addr_block,addr_page}*(1024-`COL_IN_PAGE))];
    //$display("address[%d]",{addr_block,addr_page,addr_column} - ({addr_block,addr_page}*(1024-`COL_IN_PAGE)));
    //-----------------------------------------------------
    //address increase 1 in the sequential read operation.
    if(addr_page <= `PAGE_IN_BLOCK-1 && addr_column < `COL_IN_PAGE-1)
      addr_column <= addr_column + 1'b1;
    //-----------------------------------------------------
    //last data of the page is output;
    //the next page will be loaded to output.
    else if(addr_page < `PAGE_IN_BLOCK-1 && addr_column === `COL_IN_PAGE-1)
    begin
      //last data byte in page is outputted.
      last_data <= 1'b1;
      if({area_a,area_b,area_c}===3'b100 || {area_a,area_b,area_c}===3'b010)
        addr_column <= `COL_BIT'h000; addr_page <= addr_page + 1'b1;
      if({area_a,area_b,area_c}===3'b001)
        addr_column <= `COL_BIT'h200; addr_page <= addr_page + 1'b1;
    end
    //-----------------------------------------------------
    //sequential read can only be used to read one block.
    else if(addr_page === `PAGE_IN_BLOCK-1 && addr_column === `COL_IN_PAGE-1)
      $display("%t, Note: Sequential Read Operation within Block[%d] is Completed.",$realtime,addr_block);
  end
end

//===============================================
//      read electronic signature operation
//===============================================
always@(negedge iRE)
begin
  if(power_on && MOD_READ_ES && ADD_COMPLETE && {iCE,iALE,iCLE,iRE,iWE,bRE}===6'b000011)
  begin
    $display("%t, Note: Read Electronic Signature.",$realtime);
    operation <= OP_READ;
    //"tREA" is rd enable low to output valid
    eIO <= #(`tREA) 1'b1;
    case(signature)
      0: begin dout <= #(`tREA) `MANUFC_CODE; signature <= 1; end
      1: begin dout <= #(`tREA) `DEVICE_CODE; signature <= 2; end
      2: begin dout <= #(`tREA)  8'hA5;       signature <= 3; end
      3: begin dout <= #(`tREA)  8'h00;       signature <= 0; end
    endcase
  end
end

//===============================================
//        read status register operation
//===============================================
always@(negedge iRE)
begin
  if(power_on && MOD_READ_SR && {iCE,iALE,iCLE,iRE,iWE,bRE}===6'b000011)
  begin
    $display("%t, Note: Read Status Register.",$realtime);
    operation <= OP_READ;
    //"tREA" is rd enable low to output valid
    eIO <= #(`tREA) 1'b1;
    dout <= #(`tREA) REG_STAT;
  end
end

//===============================================
//            block erase operation
//===============================================
always@(posedge MOD_BLOCK_ERASE_2)
begin
  if(power_on == 1'b1 && wr_protect == 1'b0)
  begin
    //memory is busy; p/e/r controller is active.
    //"tWB" is wr enable high to ready/busy low.
    operation    <= #(`tWB) OP_ERASE;
    BUSY_BY_BE   <= #(`tWB) 1'b0;
    REG_STAT[6]  <= #(`tWB) 1'b0;
    //memory is ready; p/e/r controller is inactive.
    //"tBERS" is block erase operation busy time.
    operation    <= #(`tWB + `tBERS) OP_READY;
    BUSY_BY_BE   <= #(`tWB + `tBERS) 1'b1;
    REG_STAT[6]  <= #(`tWB + `tBERS) 1'b1;
    //block erase operation.
    //all bits in the addressed block are set to '1'.
    blockerasing <= 1'b1;
    for(addr_temp2 = 0 ; addr_temp2 < `PAGE_IN_BLOCK ; addr_temp2 = addr_temp2 + 1)
      for(addr_temp1 = 0 ; addr_temp1 < `COL_IN_PAGE ; addr_temp1 = addr_temp1 + 1)
        MEMORY[{addr_block,addr_temp2[`PAG_BIT-1:0],addr_temp1[`COL_BIT-1:0]}
        - ({addr_block,addr_temp2[`PAG_BIT-1:0]}*(1024-`COL_IN_PAGE))] <= #(`tWB + `tBERS) {`D_WIDTH{1'b1}};
  end
  else if(wr_protect == 1'b1)
  begin
    //wr_protect <= 1'b0;
    //REG_STAT[7] <= 1'b1;
    $display("%t, Error: Write Protect, the Block Erase Operation is not accepted!\n",$realtime);
  end
end
//-----------------------------------------------
always@(posedge BUSY_BY_BE)
begin
  if(blockerasing == 1'b1) begin
    $display("%t, Note: Block[%d] Erase Operation is completed!\n",$realtime,addr_block);
    blockerasing <= 1'b0;
  end
end

//===============================================
//       copy back, page program operation
//===============================================
always@(posedge COPYBACK_ID1) address_src <= {addr_block,addr_page,addr_column};
always@(posedge COPYBACK_ID2) address_tgt <= {addr_block,addr_page,addr_column};

//-----------------------------------------------
//page program and copy back program confirm
//-----------------------------------------------
always@(posedge MOD_PAGE_PROGRAM_2)
begin
  if(power_on == 1'b1 && wr_protect == 1'b0)
  begin
    //memory is busy; p/e/r controller is active.
    //"tWB" is wr enable high to ready/busy low.
    operation   <= #(`tWB) OP_PROGRAM;
    BUSY_BY_PG  <= #(`tWB) 1'b0;
    REG_STAT[6] <= #(`tWB) 1'b0;
    //memory is ready; p/e/r controller is inactive.
    //"tPROG" is program operation busy time.
    operation   <= #(`tWB + `tPROG) OP_READY;
    BUSY_BY_PG  <= #(`tWB + `tPROG) 1'b1;
    REG_STAT[6] <= #(`tWB + `tPROG) 1'b1;
    //page program operation.
    //program tha data bytes to the memory array.
    if(COPYBACK_ID2 == 1'b0)
    begin
      programming1 <= 1'b1;
      for(addr_temp1 = start_addr ; addr_temp1 <= end_addr ; addr_temp1 = addr_temp1 + 1)
      begin
        if(MEMORY[{addr_block,addr_page,addr_temp1[`COL_BIT-1:0]}
           - ({addr_block,addr_page}*(1024-`COL_IN_PAGE))] & 8'hff === 8'hff)
          MEMORY[{addr_block,addr_page,addr_temp1[`COL_BIT-1:0]}
          - ({addr_block,addr_page}*(1024-`COL_IN_PAGE))] <= #(`tWB + `tPROG) DATA[addr_temp1[`COL_BIT-1:0]];
        else begin
          programming1 <= 1'b0;
          not_blank = 1'b1;
          REG_STAT[0] = 1'b1;
          $stop;
        end
      end
      if(not_blank == 1'b1)
      begin
        not_blank = 1'b0;
        $display("\n%t, Error: the bytes addressed to program are not blank, a Block Erase Command must be issued before page program!\n",$realtime);
      end
    end
    //copy back program operation.
    //copy the data stored in one page and reprogram it in another page.
    if(COPYBACK_ID2 === 1'b1 && address_src[`CHP_BIT-1] === address_tgt[`CHP_BIT-1])
    begin
      for(addr_temp1 = 0 ; addr_temp1 < `COL_IN_PAGE ; addr_temp1 = addr_temp1 + 1)
      begin
        if(MEMORY[{address_tgt[`CHP_BIT-1:10],addr_temp1[`COL_BIT-1:0]}
           - {address_tgt[`CHP_BIT-1:10]}*(1024-`COL_IN_PAGE)] & 8'hff !== 8'hff)
        begin
          not_blank = 1'b1;       //addressed page blank check
        end
      end
      if(not_blank == 1'b1)       //if the page is not blank
      begin
        not_blank = 1'b0;
        REG_STAT[0] = 1'b1;
        $display("\n%t, Error: the bytes addressed to program are not blank, a Block Erase Command must be issued before copy back program!\n",$realtime);
      end
      else if(not_blank == 1'b0)  //the page is blank, copy program
      begin
        programming2 <= 1'b1;
        for(addr_temp1 = 0 ; addr_temp1 < `COL_IN_PAGE ; addr_temp1 = addr_temp1 + 1)
        begin
            //$display("source[%d],target[%d]",{address_tgt[`CHP_BIT-1:10],addr_temp1[`COL_BIT-1:0]}
            //- {address_tgt[`CHP_BIT-1:10]}*(1024-`COL_IN_PAGE),{address_src[`CHP_BIT-1:10],addr_temp1[`COL_BIT-1:0]}
            //- {address_src[`CHP_BIT-1:10]}*(1024-`COL_IN_PAGE));
            MEMORY[{address_tgt[`CHP_BIT-1:10],addr_temp1[`COL_BIT-1:0]}
            - {address_tgt[`CHP_BIT-1:10]}*(1024-`COL_IN_PAGE)] <= #(`tWB + `tPROG)
            MEMORY[{address_src[`CHP_BIT-1:10],addr_temp1[`COL_BIT-1:0]}
            - {address_src[`CHP_BIT-1:10]}*(1024-`COL_IN_PAGE)];
        end
      end
    end
    if(COPYBACK_ID2 === 1'b1 && address_src[`CHP_BIT-1] !== address_tgt[`CHP_BIT-1])
      $display("\n%t, Error: The most significant address bit must be the same for source and target!\n",$realtime);
  end
  else if(wr_protect == 1'b1)
  begin
    //wr_protect <= 1'b0;
    //REG_STAT[7] <= 1'b1;
    case(COPYBACK_ID2)
      0: $display("\n%t, Error: Write Protect, the Program Operation is not accepted!\n",$realtime);
      1: $display("\n%t, Error: Write Protect, the Copy Back Program Operation is not accepted!\n",$realtime);
    endcase
  end
end
//-----------------------------------------------
always@(posedge BUSY_BY_PG)
begin
  if(programming1 == 1'b1) begin
    $display("\n%t, Note: Block[%d] Page[%d] Program Operation is completed!\n",$realtime,addr_block,addr_page);
    programming1 <= 1'b0;
  end
  if(programming2 == 1'b1) begin
    $display("\n%t, Note: Copy Back Program Operation is completed!",$realtime);
    $display("%t, Block[%d] Page[%d] to Block[%d] Page[%d]\n",$realtime,
    address_src[`CHP_BIT-1:`CHP_BIT-`BLK_BIT],address_src[`CHP_BIT-1-`BLK_BIT:`CHP_BIT-`BLK_BIT-`PAG_BIT],
    address_tgt[`CHP_BIT-1:`CHP_BIT-`BLK_BIT],address_tgt[`CHP_BIT-1-`BLK_BIT:`CHP_BIT-`BLK_BIT-`PAG_BIT]);
    programming2 <= 1'b0;
  end
  COPYBACK_ID2 <= 1'b0;
end  

//===================================================================
always@(posedge iCE)
begin
  if(oRY_BY && ( bCE == 1'b0 )) begin
    $display("%t, Note: Chip Select is high, the memory enters Standby mode!\n",$realtime);
    if(MOD_READ_ES && OP_READ)   dout <= #(`tCHZ) 8'hzz;
    if(MOD_READ_SR && OP_READ)   dout <= #(`tCHZ) 8'hzz;
    if(MOD_READ_MODE && OP_READ) dout <= #(`tCHZ) 8'hzz;
  end
  else if(!oRY_BY && ( bCE == 1'b0 )) begin
    if(MOD_READ_MODE && OP_READ)
    begin
      BUSY_BY_RD <= #(`tCRY) 1'b1;
      $display("%t, Note: Chip Select does high during device BUSY, Read Operation is aborted!\n",$realtime);
    end
  end
end
//-------------------------------------------------------------------
always@(negedge iCE)
begin
  if(power_on && MOD_READ_SR)
  begin
    operation <= OP_READ;
    eIO <= #(`tCEA) 1'b1;      //#(`tCEA): chip enable low to output valid
    dout <= #(`tCEA) REG_STAT;
  end
  if(power_on && (operation == OP_READ) && MOD_READ_MODE && ($time - tr_iCE >= `tEHEL)) 
  begin
    //reset <= 1'b1;
    $display("%t, Note: Sequential Read Operation is terminated!\n",$realtime);
  end
end

//=============================================================================
//  CHECKING COMMANDS
//-----------------------------------------------------------------------------
//  returns '1' in case of valid command
//  returns '0' in case of invalid command.
//=============================================================================
function CMD_CHECK;
input[`D_WIDTH-1:0] CMD_NEW;
begin
  case(CMD_NEW)
  //---------------------------------------------------------------------------------------------------------
    CMD_READ_SR:       CMD_CHECK = 1'b1;
  //---------------------------------------------------------------------------------------------------------
    CMD_RESET  :       CMD_CHECK = 1'b1;
  //---------------------------------------------------------------------------------------------------------
    CMD_READ_A :
      if(oRY_BY) begin CMD_CHECK = 1'b1; add_cycle = 3; end
      else begin
        $display("%t, Error: Device is Busy,Read Area A Command is Rejected!\n",$realtime);
        CMD_CHECK = 1'b0;
      end
  //---------------------------------------------------------------------------------------------------------
    CMD_READ_B :
      if(oRY_BY) begin CMD_CHECK = 1'b1; add_cycle = 3; end
      else begin
        $display("%t, Error: Device is Busy,Read Area B Command is Rejected!\n",$realtime);
        CMD_CHECK = 1'b0;
      end
  //---------------------------------------------------------------------------------------------------------
    CMD_READ_C :
      if(oRY_BY) begin CMD_CHECK = 1'b1; add_cycle = 3; end
      else begin
        $display("%t, Error: Device is Busy,Read Area C Command is Rejected!\n",$realtime);
        CMD_CHECK = 1'b0;
      end
  //---------------------------------------------------------------------------------------------------------
    CMD_READ_ES:
      if(oRY_BY) begin CMD_CHECK = 1'b1; add_cycle = 1; end
      else begin
        $display("%t, Error: Device is Busy,Read Electronic Signature Command is Rejected!\n",$realtime);
        CMD_CHECK = 1'b0;
      end
  //---------------------------------------------------------------------------------------------------------
    CMD_BLOCK_ERASE_1:
      if(oRY_BY) begin CMD_CHECK = 1'b1; add_cycle = 2; end
      else begin
        $display("%t, Error: Device is Busy,Block Erase Command is Rejected!\n",$realtime);
        CMD_CHECK = 1'b0;
      end
  //---------------------------------------------------------------------------------------------------------
    CMD_PAGE_PROGRAM_1:
      if(MOD_READ_MODE || (MOD_PAGE_PROGRAM_2 && (area_a == 1'b1 || area_c == 1'b1)))
        if(oRY_BY) begin CMD_CHECK = 1'b1; add_cycle = 3; end
        else begin
          $display("%t, Error: Device is Busy,Page Program Command is Rejected!\n",$realtime);
          CMD_CHECK = 1'b0;
        end
      else $display("%t, Error: Incorrect Program Command Sequence!\n",$realtime);
  //---------------------------------------------------------------------------------------------------------
    CMD_COPY_BACK_PG:
      if(MOD_READ_A && COPYBACK_ID1)
        if(oRY_BY) begin CMD_CHECK = 1'b1; add_cycle = 3; end
        else begin
          $display("%t, Error: Device is Busy,Copy Back Program Command is Rejected!\n",$realtime);
          CMD_CHECK = 1'b0;
        end
      else $display("%t, Error: Incorrect Copy Back Program Command Sequence!\n",$realtime);
  //---------------------------------------------------------------------------------------------------------
    CMD_BLOCK_ERASE_2:
      if(MOD_BLOCK_ERASE_1) CMD_CHECK = ( oRY_BY ) ? 1'b1 : 1'b0;
      else $display("%t, Error: Incorrect Block Erase Command Sequence!\n",$realtime);
  //---------------------------------------------------------------------------------------------------------
    CMD_PAGE_PROGRAM_2:
      if(MOD_COPY_BACK_PG || MOD_PAGE_PROGRAM_1) CMD_CHECK = ( oRY_BY ) ? 1'b1 : 1'b0;
      else $display("%t, Error: Incorrect Page Program or Copy Back Program Command Sequence!\n",$realtime);
  //---------------------------------------------------------------------------------------------------------
    default:
    begin
      CMD_CHECK = 1'b0;
      $display("%t, Error: An Unkown Command Code(%h)H is Latched!\n",$realtime,CMD_NEW);
    end
  //---------------------------------------------------------------------------------------------------------
  endcase
end
endfunction
//-----------------------------------------------------------------------------------------------------------

//===================================================================
//          CHECKING INPUT SIGNAL AC TIMING CHARACTERISTICS
//===================================================================
always@(posedge iWE)
begin
  tr_iWE <= $time;
  iWE_R <= 1'b1;
  if(iIO_C === 1'b1)
  begin
    //iIO_C <= 1'b0;
    if($time - tc_iIO < `tDVWH) $display("%t, Error: Data Setup Time(tDS) violated.\n",$realtime);
  end
  if(iWE_F === 1'b1)
  begin
    //iWE_F <= 1'b0;
    if($time - tf_iWE < `tWLWH) $display("%t, Error: /W Pulse Width(tWP) violated.\n",$realtime);
  end
end
//-------------------------------------------------------------------
always@(negedge iWE)
begin
  tf_iWE <= $time;
  iWE_F <= 1'b1;
  if(iWE_R === 1'b1)
  begin
    //iWE_R <= 1'b0;
    if($time - tr_iWE < `tWHWL) $display("%t, Error: /W High Hold Time(tWH) violated.\n",$realtime);
  end
  if(iWE_F === 1'b1)
  begin
    //iWE_F <= 1'b0;
    if($time - tf_iWE < `tWLWL) $display("%t, Error: Write Cycle Time(tWC) violated.\n",$realtime);
  end
  if(iCE_F === 1'b1)
  begin
    //iCE_F <= 1'b0;
    if($time - tf_iCE < `tELWL) $display("%t, Error: /E Setup Time(tCS) violated.\n",$realtime);
  end
  if(iCLE_R === 1'b1)
  begin
    //iCLE_R <= 1'b0;
    if($time - tr_iCLE < `tCLHWL) $display("%t, Error: CL Setup Time(tCLS) violated.\n",$realtime);
  end
  if(iCLE_F === 1'b1)
  begin
    //iCLE_F <= 1'b0;
    if($time - tf_iCLE < `tCLLWL) $display("%t, Error: CL Setup Time(tCLS) violated.\n",$realtime);
  end
  if(iALE_R === 1'b1)
  begin
    //iALE_R <= 1'b0)
    if($time - tr_iALE < `tALHWL) $display("%t, Error: AL Setup Time(tALS) violated.\n",$realtime);
  end
  if(iALE_F === 1'b1)
  begin
    //iALE_F <= 1'b0;
    if($time - tf_iALE < `tALLWL) $display("%t, Error: AL Setup Time(tALS) violated.\n",$realtime);
  end
end
//===================================================================
always@(posedge iRE)
begin
  tr_iRE <= $time;
  iRE_R <= 1'b1;
  if(iRE_F === 1'b1)
  begin
    //iRE_F <= 1'b0;
    if($time - tf_iRE < `tRLRH) $display("%t, Error: Read Enable Pulse Width(tRP) violated.\n",$realtime);
  end
end
//-------------------------------------------------------------------
always@(negedge iRE)
begin
  tf_iRE <= $time;
  iRE_F <= 1'b1;
  if(iALE_F === 1'b1)
  begin
    //iALE_F <= 1'b0;
    if($time - tf_iALE < `tALLRL) $display("%t, Error: Address Latch Low to Read Enable Low(tAR) violated.\n",$realtime);
  end
  if(iCLE_F === 1'b1)
  begin
    //iCLE_F <= 1'b0;
    if($time - tf_iCLE < `tCLLRL) $display("%t, Error: Command Latch Low to Read Enable Low(tCLR) violated.\n",$realtime);
  end
  if(iRE_F === 1'b1)
  begin
    //iRE_F <= 1'b0;
    if($time - tf_iRE < `tRLRL) $display("%t, Error: Read Cycle Time(tRC) violated.\n",$realtime);
  end
  if(iRE_R === 1'b1)
  begin
    //iRE_R <= 1'b0;
    if($time - tr_iRE < `tRHRL) $display("%t, Error: Read Enable High Hold Time(tREH) violated.\n",$realtime);
  end
  if(iWE_R === 1'b1)
  begin
    //iWE_R <= 1'b0;
    if($time - tr_iWE < `tWHRL) $display("%t, Error: Write Enable High to Read Enable Low(tWHR) violated.\n",$realtime);
  end
end
//===================================================================
always@(posedge iALE)
begin
  tr_iALE <= $time;
  iALE_R <= 1'b1;
  if(iWE_R === 1'b1)
  begin
    //iWE_R <= 1'b0;
    if($time - tr_iWE < `tWHALH) $display("%t, Error: AL Hold Time(tALH) violated.\n",$realtime);
  end
end
//-------------------------------------------------------------------
always@(negedge iALE)
begin
  tf_iALE <= $time;
  iALE_F <= 1'b1;
  if(iWE_R === 1'b1)
  begin
    //iWE_R <= 1'b0;
    if($time - tr_iWE < `tWHALL) $display("%t, Error: AL Hold Time(tALH) violated.\n",$realtime);
  end
end
//===================================================================
always@(posedge iCLE)
begin
  tr_iCLE <= $time;
  iCLE_R <= 1'b1;
  if(iWE_R === 1'b1)
  begin
    //iWE_R <= 1'b0;
    if($time - tr_iWE < `tWHCLH) $display("%t, Error: CL Hold Time(tCLH) violated.\n",$realtime);
  end
end
//-------------------------------------------------------------------
always@(negedge iCLE)
begin
  tf_iCLE <= $time;
  iCLE_F <= 1'b1;
  if(iWE_R === 1'b1)
  begin
    //iWE_R <= 1'b0;
    if($time - tr_iWE < `tWHCLL) $display("%t, Error: CL Hold Time(tCLH) violated.\n",$realtime);
  end
end
//===================================================================
always@(posedge iCE)
begin
  tr_iCE <= $time;
  iCE_R <= 1'b1;
  if(iWE_R === 1'b1)
  begin
    //iWE_R <= 1'b0;
    if($time - tr_iWE < `tWHEH) $display("%t, Error: /E Hold Time(tCH) violated.\n",$realtime);
  end
end
//-------------------------------------------------------------------
always@(negedge iCE)
begin
  tf_iCE <= $time;
  iCE_F <= 1'b1;
  if(iCE_R === 1'b1)
  begin
    //iCE_R <= 1'b0;
    if($time - tr_iCE < `tEHEL) $display("%t, Error: Chip Enable High to Chip Enable Low(tEHEL) violated.\n",$realtime);
  end
end
//===================================================================
always@(iIO)
begin
  tc_iIO <= $time;
  iIO_C <= 1'b1;
  if(iWE_R === 1'b1)
  begin
    //iWE_R <= 1'b0;
    if($time - tr_iWE < `tWHDX) $display("%t, Error: Data Hold Time(tDH) violated.\n",$realtime);
  end
end
//###################################################################

endmodule