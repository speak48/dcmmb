//================================
//NAND256 Stimuli file
//================================

`timescale 1ns/1ns
//--------------------------------
module NAND_DRV (
                    IO    ,
                    CE    ,
                    WE    ,
                    RE    ,
                    WP    ,
                    CLE   ,
                    ALE   ,
                    RY_BY ,
                    VDD   ,
                    VSS
                 );
//--------------------------------
inout[7:0]  IO    ;
input       RY_BY ;
output      CE    ;
output      WE    ;
output      RE    ;
output      WP    ;
output      CLE   ;
output      ALE   ;
output      VDD   ;
output      VSS   ;
//--------------------------------
reg[7:0]    IO_BUF;
reg         CE    ;
reg         WE    ;
reg         RE    ;
reg         WP    ;
reg         CLE   ;
reg         ALE   ;
reg         VDD   ;
reg         VSS   ;
//--------------------------------
assign IO = IO_BUF;
//--------------------------------

initial begin
  VDD     = 1'b0;
  VSS     = 1'b0;
  #100
  VDD     = 1'b1;
  #100;

  CE      = 1'b1;
  RE      = 1'b1;
  WE      = 1'b1;
  WP      = 1'b1;
  CLE     = 1'b0;
  ALE     = 1'b0;
  IO_BUF  = 8'hzz;

  #600;	
  CE      = 1'b0;

  //Read Electronic Signature
  READ_ES;
  #200;

  //Read Status Register
  READ_SR;
  #200;

  //Read Memory Array
  $display("************************************************************************************************");
  READ(8'h01,8'h00,8'h00,8'h00,1);          //area b,read block 0,page 0,column 256
  #200;
  WP = 1'b0;
  #200;
  PROGRAM(8'h00,8'h00,8'h00,8'h88,256+16);  //write '88' to block 0,page 0,column 256~column 527
  #600e3;
  READ_SR;
  #200;
  WP = 1'b1;
  #200;
  READ_B;
  PROGRAM(8'h00,8'h00,8'h00,8'h88,256+16);  //write '88' to block 0,page 0,column 256~column 527
  #600e3;
  READ_SR;
  #200;
  READ(8'h00,8'hff,8'h00,8'h00,256+16+2);   //area a,read block 0,page 0,column 255 ~ block 0,page 1,column 0
  #200;
  $display("************************************************************************************************");
  READ(8'h50,8'h00,8'h1f,8'h00,1);          //area c,read block 0,page 31,column 512
  #200;
  READ(8'h50,8'hff,8'h1f,8'h00,1);          //area c,read block 0,page 31,column 527
  #200;
  PROGRAM(8'h00,8'h1f,8'h00,8'h55,16);      //write '55' to block 0,page 31,column 512~column 527
  #600e3;
  READ_SR;
  #200;
  READ(8'h01,8'hff,8'h1f,8'h00,16+2);       //area b,read block 0,page 31,column 511 ~ column 527
  #200;
  $display("************************************************************************************************");
  READ(8'h00,8'h00,8'h02,8'h00,1);          //area a,read block 0,page 2,column 0
  #200;
  PROGRAM(8'h00,8'h02,8'h00,8'haa,528);     //write 'aa' to block 0,page 2,column 0~column 527
  #600e3;
  READ_SR;
  #200;
  READ(8'h00,8'h00,8'h02,8'h00,528+1);      //area a,read block 0,page 2,column 0 ~ block 0,page 3,column 0
  #200;
  $display("************************************************************************************************");
  READ(8'h00,8'h00,8'h80,8'h00,1);          //area a,read block 4,page 0,column 0
  #200;
  PROGRAM(8'h00,8'h80,8'h00,8'h40,1);       //write '40' to block 4,page 0,column 0
  #600e3;
  PROGRAM(8'h00,8'h81,8'h00,8'h40,1);       //write '40' to block 4,page 1,column 0
  #600e3;
  READ(8'h00,8'h00,8'h80,8'h00,1);          //area a,read block 4,page 0,column 0
  #200;
  READ(8'h00,8'h00,8'h81,8'h00,1);          //area a,read block 4,page 1,column 0
  #200;
  $display("------------------------------------------------------------------------------------------------");
  READ(8'h50,8'h00,8'h80,8'h00,1);          //area c,read block 4,page 0,column 512
  #200;
  PROGRAM(8'h00,8'h80,8'h00,8'h40,1);       //write '40' to block 4,page 0,column 512
  #600e3;
  PROGRAM(8'h00,8'h81,8'h00,8'h40,1);       //write '40' to block 4,page 1,column 512
  #600e3;
  READ(8'h50,8'h00,8'h80,8'h00,1);          //area c,read block 4,page 0,column 512
  #200;
  READ(8'h50,8'h00,8'h81,8'h00,1);          //area c,read block 4,page 1,column 512
  #200;
  $display("------------------------------------------------------------------------------------------------");
  READ(8'h01,8'h00,8'h80,8'h00,1);          //area a,read block 4,page 0,column 256
  #200;
  READ(8'h01,8'h00,8'h81,8'h00,1);          //area a,read block 4,page 1,column 256
  #200;
  PROGRAM(8'h00,8'h80,8'h00,8'h40,1);       //write '40' to block 4,page 0,column 256
  #600e3;
  //PROGRAM(8'h00,8'h81,8'h00,8'h40,1);     //write '40' to block 4,page 1,column 256
  //#600e3;
  READ_B;
  PROGRAM(8'h00,8'h81,8'h00,8'h40,1);       //write '40' to block 4,page 1,column 256
  #600e3;
  READ(8'h01,8'h00,8'h80,8'h00,1);          //area a,read block 4,page 0,column 256
  #200;
  READ(8'h01,8'h00,8'h81,8'h00,1);          //area a,read block 4,page 1,column 256
  #200;
  $display("------------------------------------------------------------------------------------------------");
  READ(8'h50,8'hff,8'hff,8'hff,2);          //area c,read block 2047,page 31,column 527
  #200;
  PROGRAM(8'hff,8'hff,8'hff,8'h88,1);
  #600e3;
  READ(8'h50,8'hff,8'hff,8'hff,2);          //area c,read block 2047,page 31,column 527
  #200;
  $display("------------------------------------------------------------------------------------------------");
  RESET;
  #10e3;
  READ(8'h00,8'h00,8'h00,8'h00,528);        //area a,read block 0,page 0,column 0 ~ 527
  #200;  
  READ(8'h00,8'h00,8'h21,8'h00,528);        //area a,read block 1,page 1,column 0 ~ 527
  #200;
  WP = 1'b0;
  COPY_BACK(24'h000000,24'h002100);       //copy block 0,page 0 to block 1,page1,wr protect
  #600e3;
  READ(8'h00,8'h00,8'h21,8'h00,528);        //area a,read block 1,page 1,column 0 ~ 527
  #200
  WP = 1'b1;
  COPY_BACK(24'h000000,24'h002100);       //copy block 0,page 0 to block 1,page1,not protect
  #600e3;
  READ(8'h00,8'h00,8'h21,8'h00,528);        //area a,read block 1,page 1,column 0 ~ 527
  #200;
  $display("------------------------------------------------------------------------------------------------");
  VDD = 1'b0;
  #100;
  VDD = 1'b1;
  #100;
  WP = 1'b0;
  BLOCK_ERASE(8'h20,8'h00);                 //erase block1,wr protect
  #3e6;
  READ(8'h00,8'h00,8'h21,8'h00,528);        //area a,read block 1,page 1,column 0 ~ 527
  #200;
  WP = 1'b1;
  BLOCK_ERASE(8'h20,8'h00);                 //erase block1,not protect
  #3e6;
  READ(8'h00,8'h00,8'h21,8'h00,528);        //area a,read block 1,page 1,column 0 ~ 527
  #200;
  $finish;
end

//=========================================================
// Read Electronic Signature
//=========================================================
task READ_ES;
  begin
    #100;
    CLE = 1'b1;
    IO_BUF = 8'h90;   //command input
  
    #100;
    WE = 1'b0;
    #100;
    WE = 1'b1;        //write enable, data latched in
    #100;
  
    CLE = 1'b0;
    #100;
    ALE = 1'b1;
    IO_BUF = 8'h00;   //address input
  
    #100;
    WE = 1'b0;
    #100;
    WE = 1'b1;        //write enable, data latched in
    #100;
  
    ALE = 1'b0;
    IO_BUF = 8'hzz;   //read data from memory
    #100;
    RE = 1'b0;        //read enable, data output
    #100;
    RE = 1'b1;
    $display("%t,Electronic Signature = [%h]",$realtime,IO);
    #100;
    RE = 1'b0;
    #100;
    RE = 1'b1;
    $display("%t,Electronic Signature = [%h]",$realtime,IO);
    #100;
  end
endtask
//#########################################################

//=========================================================
// Read Status Register
//=========================================================
task READ_SR;
  begin
    #100;
    CLE = 1'b1;
    IO_BUF = 8'h70;   //command input
  
    #100;
    WE = 1'b0;
    #100;
    WE = 1'b1;        //write enable, data latched in
    #100;
  
    CLE = 1'b0;
    IO_BUF = 8'hzz;   //read data from memory
    #100;
    RE = 1'b0;        //read enable, data output
    #100;
    RE = 1'b1;
    $display("%t,Status Register = [%b]",$realtime,IO);
    #100;
  end
endtask
//#########################################################

task READ_A;
  begin
    #200;
    CLE = 1'b1;
    IO_BUF = 8'h00;     //command input, area a
  
    #200;
    WE = 1'b0;
    #200;
    WE = 1'b1;          //write enable, data latched in
    #200;
  end
endtask

task READ_B;
  begin
    #200;
    CLE = 1'b1;
    IO_BUF = 8'h01;     //command input, area b
  
    #200;
    WE = 1'b0;
    #200;
    WE = 1'b1;          //write enable, data latched in
    #200;
  end
endtask

task READ_C;
  begin
    #200;
    CLE = 1'b1;
    IO_BUF = 8'h50;     //command input, area c
  
    #200;
    WE = 1'b0;
    #200;
    WE = 1'b1;          //write enable, data latched in
    #200;
  end
endtask

//=========================================================
// Reset Command
//=========================================================
task RESET;
  begin
    #200;
    CLE = 1'b1;
    IO_BUF = 8'hff;     //command input, reset
  
    #200;
    WE = 1'b0;
    #200;
    WE = 1'b1;          //write enable, data latched in
    #200;
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
  //input[7:0] addr_4th;
  input      n;
  integer    i,n,temp;
  reg[12:0]  add_bk;
  reg[4:0]   add_pg;
  reg[9:0]   add_cl;

  begin
    #200;
    CLE = 1'b1;
    IO_BUF = cmd;       //command input, area a
  
    #200;
    WE = 1'b0;
    #200;
    WE = 1'b1;          //write enable, data latched in
    #200;
  
    CLE = 1'b0;
    #200;
    ALE = 1'b1;
    IO_BUF = addr_1st;  //address cycle 1
  
    #200;
    WE = 1'b0;
    #200;
    WE = 1'b1;          //write enable, data latched in
    #200;
  
    IO_BUF = addr_2nd;  //address cycle 2
    
    #200;
    WE = 1'b0;
    #200;
    WE = 1'b1;          //write enable, data latched in
    #200;
  
    IO_BUF = addr_3rd;  //address cycle 3
  
    #200;
    WE = 1'b0;
    #200;
    WE = 1'b1;          //write enable, data latched in
    #200;
                        //address cycle 4
//    IO_BUF = addr_4th & 8'h03;
  
//    #200;
//    WE = 1'b0;
//    #200;
//    WE = 1'b1;          //write enable, data latched in
//    #200;
  
    ALE = 1'b0;
    IO_BUF = 8'hzz;     //read data from memory
    #15e3;
    if(cmd === 8'h00) temp = addr_1st;
    if(cmd === 8'h01) temp = 256 + addr_1st;
    if(cmd === 8'h50) temp = 512 + addr_1st[3:0];
    for(i=temp;i<temp+n;i=i+1)
    begin
      add_bk = U_NAND256R3A.addr_block;
      add_pg = U_NAND256R3A.addr_page;
      add_cl = U_NAND256R3A.addr_column;
      #200;
      RE = 1'b0;
      #200
      RE = 1'b1;
      $display("%t, Block[%d],  Page[%d], Column[%d], Data=[%h]",$realtime,add_bk,add_pg,add_cl,IO);
      if(((cmd === 8'h00)||(cmd === 8'h01))&&((i-527)%528 === 0)) #(10e3+200);
      if(((cmd === 8'h00)||(cmd === 8'h01))&&((i-527)%16 === 0)) #(10e3+200);
    end
  end
endtask
//#########################################################

//=========================================================
// Page Program
//=========================================================
task PROGRAM;
  input[7:0] addr_1st;
  input[7:0] addr_2nd;
  input[7:0] addr_3rd;
//  input[7:0] addr_4th;
  input[7:0] data;
  input      n;
  integer    n,i;

  begin
    #200;
    CLE = 1'b1;
    IO_BUF = 8'h80;     //command input, area a
    #200;
    WE = 1'b0;
    #200;
    WE = 1'b1;          //write enable, data latched in
    #200;
  
    CLE = 1'b0;
    #200;
    ALE = 1'b1;
    IO_BUF = addr_1st;  //address cycle 1
    #200;
    WE = 1'b0;
    #200;
    WE = 1'b1;          //write enable, data latched in
    #200;
  
    IO_BUF = addr_2nd;  //address cycle 2
    #200;
    WE = 1'b0;
    #200;
    WE = 1'b1;          //write enable, data latched in
    #200;
  
    IO_BUF = addr_3rd;  //address cycle 3
    #200;
    WE = 1'b0;
    #200;
    WE = 1'b1;          //write enable, data latched in
    #200;
                        //address cycle 4
 //   IO_BUF = addr_4th & 8'h03;
 //   #200;
 //   WE = 1'b0;
 //   #200;
 //   WE = 1'b1;          //write enable, data latched in
 //   #200;
  
    ALE = 1'b0;
  
    for(i=0;i<n;i=i+1)
    begin
      IO_BUF = data;
      #200;
      WE = 1'b0;
      #200;
      WE = 1'b1;        //write enable, data latched in
      #200;
    end
  
    CLE = 1'b1;
    IO_BUF = 8'h10;     //Confirm Code
    #200;
    WE = 1'b0;
    #200;
    WE = 1'b1;          //write enable, data latched in
    #200;
  end
endtask
//#########################################################

//=========================================================
// Copy Back Program
//=========================================================
task COPY_BACK;
  input[23:0] address_src;
  input[23:0] address_tgt;
  reg  [23:0] address_src;
  reg  [23:0] address_tgt;
  begin
	  #100;
	  CLE = 1'b1;
	  IO_BUF = 8'h00;
	  #100;
    WE = 1'b0;
    #100;
    WE = 1'b1;          //write enable, data latched in
    #100;
    
    CLE = 1'b0;
    #100;
    ALE = 1'b1;
    IO_BUF = address_src[7:0];
    #100;
    WE = 1'b0;
    #100;
    WE = 1'b1;          //write enable, data latched in
    #100;
    IO_BUF = address_src[15:8];
    #100;
    WE = 1'b0;
    #100;
    WE = 1'b1;          //write enable, data latched in
    #100;
    IO_BUF = address_src[23:16];
    #100;
    WE = 1'b0;
    #100;
    WE = 1'b1;          //write enable, data latched in
    #100;
    //IO_BUF = address_src[25:24];
    //#100;
    //WE = 1'b0;
    //#100;
    //WE = 1'b1;          //write enable, data latched in
    //#100;

    #15e3;
    ALE = 1'b0;
    #100
    CLE = 1'b1;
    IO_BUF = 8'h8A;
    #100;
    WE = 1'b0;
    #100;
    WE = 1'b1;          //write enable, data latched in
    #100;

    CLE = 1'b0;
    #100;
    ALE = 1'b1;
    IO_BUF = address_tgt[7:0];
    #100;
    WE = 1'b0;
    #100;
    WE = 1'b1;          //write enable, data latched in
    #100;
    IO_BUF = address_tgt[15:8];
    #100;
    WE = 1'b0;
    #100;
    WE = 1'b1;          //write enable, data latched in
    #100;
    IO_BUF = address_tgt[23:16];
    #100;
    WE = 1'b0;
    #100;
    WE = 1'b1;          //write enable, data latched in
    #100;
    //IO_BUF = address_tgt[25:24];
    //#100;
    //WE = 1'b0;
    //#100;
    //WE = 1'b1;          //write enable, data latched in
    //#100;

    ALE = 1'b0;
    #100
    CLE = 1'b1;
    IO_BUF = 8'h10;
    #100;
    WE = 1'b0;
    #100;
    WE = 1'b1;          //write enable, data latched in
    #100;
  end
endtask

//=========================================================
// Block Erase
//=========================================================
task BLOCK_ERASE;
  input[7:0] addr_1st;
  input[7:0] addr_2nd;
  //input[7:0] addr_3rd;

  begin
    #200;
    CLE = 1'b1;
    IO_BUF = 8'h60;     //command input, area a
    #200;
    WE = 1'b0;
    #200;
    WE = 1'b1;          //write enable, data latched in
    #200;
  
    CLE = 1'b0;
    #200;
    ALE = 1'b1;
    IO_BUF = addr_1st;  //address cycle 1
    #200;
    WE = 1'b0;
    #200;
    WE = 1'b1;          //write enable, data latched in
    #200;
  
    IO_BUF = addr_2nd;  //address cycle 2
    #200;
    WE = 1'b0;
    #200;
    WE = 1'b1;          //write enable, data latched in
    #200;
  
    //IO_BUF = addr_3rd;  //address cycle 3
    //#200;
    //WE = 1'b0;
    //#200;
    //WE = 1'b1;          //write enable, data latched in
    //#200;

    ALE = 1'b0;
    CLE = 1'b1;
    IO_BUF = 8'hD0;     //Confirm Code
    #200;
    WE = 1'b0;
    #200;
    WE = 1'b1;          //write enable, data latched in
    #200;
  end
endtask
//#########################################################
endmodule

//=========================================================
//  TEST BENCH
//=========================================================
module test_bench;

  wire [7:0] IO   ;
  wire       CE   ;
  wire       WE   ;
  wire       RE   ;
  wire       WP   ;
  wire       CLE  ;
  wire       ALE  ;
  wire       VDD  ;
  wire       VSS  ;
  wire       RY_BY;

  NAND_DRV U_NAND_DRV
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