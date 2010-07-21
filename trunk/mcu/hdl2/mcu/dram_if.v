module dram_if (
       memaddr       ,
       memwr         ,
       memrd         ,
       xram_wdata    ,
       xram_rdata    ,

       dram_rdata    ,
       dram_wr       ,
       dram_rd       ,
       dram_addr     ,
       dram_wdata    ,

       mcu_rab_ack   ,
       mcu_rab_rdata ,
       mcu_rab_wdata ,
       mcu_rab_write ,
       mcu_rab_read  ,
       mcu_rab_addr  
);
       
////////////////////////
// parameters
////////////////////////
`include "hq_global_parameter.v"

////////////////////////
// Input and outputs
////////////////////////

//input         clk          ;
//input         rst          ;

input  [15:0] memaddr      ;     // memory address
input         memwr        ;     // memory write
input         memrd        ;     // memory read
input  [ 7:0] xram_wdata   ;     // data read from memory
output [ 7:0] xram_rdata   ;     // data write to memory  

input  [ 7:0] dram_rdata   ;     // data from ram
output [ 7:0] dram_wdata   ;     // data to ram
output [11:0] dram_addr    ;     // ram address
output        dram_wr      ;     // ram write
output        dram_rd      ;     // ram read

input         mcu_rab_ack  ;
input  [ 7:0] mcu_rab_rdata;
output [ 7:0] mcu_rab_wdata;
output [RAB_ADDR_WIDTH-1:0]  mcu_rab_addr ;     // address of registers accessed by i2c
output        mcu_rab_write;     // i2c write, access register, through arbiter
output        mcu_rab_read ;     // i2c read, access register, through arbiter


//combination logics
wire          dram_sel     ;
wire          regfile_sel  ;
wire          mcu_rab_write;
wire          mcu_rab_read ;
wire          dram_wr      ;
wire          dram_rd      ;
reg  [ 7:0]   xram_rdata   ;

// address 
assign mcu_rab_addr = memaddr[RAB_ADDR_WIDTH-1:0];
assign dram_addr    = memaddr[11:0]; 
   
// control 
assign dram_sel    = ( memaddr[15:12] == 4'h0  ); // 16'h0000~16'h0fff

assign regfile_sel = ( memaddr[15:9]  == 7'h7f ); // 16'hfe00~16'hffff

assign mcu_rab_write = regfile_sel & memwr ;
assign mcu_rab_read  = regfile_sel & memrd ;
assign dram_wr       = dram_sel    & memwr ;
assign dram_rd       = dram_sel    & memrd ;
//assign dram_cen      = dram_sel    & ( memwr | memrd );
//assign dram_wen      = !dram_wr             ;

//data
//wdata
assign dram_wdata    = xram_wdata ;
assign mcu_rab_wdata = xram_wdata ;
      
//rdata
always @(mcu_rab_ack or mcu_rab_rdata or dram_rdata )
  if(mcu_rab_ack ) 
      xram_rdata = mcu_rab_rdata ;
  else 
      xram_rdata = dram_rdata ; 
         
endmodule
