//+FHDR-------------------------------------------------------------------
// Copyright (c) 2007, HHIC
// HHIC Confidential Proprietary
//------------------------------------------------------------------------
// FILE NAME : i2cm_regfile
// TYPE : module
// DEPARTMENT : design
// AUTHOR : Shuang Li
// AUTHOR'S EMAIL : lishuang@shhic.com
//------------------------------------------------------------------------
// Release history
// VERSION Date AUTHOR DESCRIPTION
// 1.0 27 Feb. 09 name lishuang
//------------------------------------------------------------------------
// PURPOSE : Registers for i2c master.
//------------------------------------------------------------------------
// PARAMETERS
// PARAM NAME RANGE : DESCRIPTION : DEFAULT : VA UNITS
//------------------------------------------------------------------------
// REUSE ISSUES
// reset Strategy :
// Clock Domains :
// Critical Timing :
// Test Features :
// Asynchronous I/F :
// Scan Methodology :
// Instantiations :
// Other :
//-FHDR-------------------------------------------------------------------


module  i2cm_regfile(
        //inputs
        sys_clk              ,
        sys_rst              ,
        baseaddr             ,
        i2cm_wr              ,
        i2cm_rd              ,
        rab_addr             ,
        i2cm_wdata           ,
        rfifo_data_to_reg    ,
        rfifo_empty          ,
        tfifo_empty          ,
        tfifo_freecnt        ,
        rfifo_wordcnt        ,
//        busy                 ,
        fsm_using            ,
        byte_fsm_status      ,
        slave_waiting        ,
        non_ack              ,
        tfifo_overflow       ,
        rfifo_underflow      ,
        sto_condition        ,
        //outputs
        i2cm_rdata           ,
        i2cm_ack             ,
        tfifo_push           ,
        rfifo_pop            ,
        tfifo_data_from_reg  ,
        device_id_seg        ,
        offset               ,
        data_len             ,
        i2c_en               ,
        start                ,
        trans_type           ,
        tfifo_en             ,
        rfifo_en             ,
        timing_para          ,
        opendrain
        );

`include "i2cm_defines.v"

parameter   ADDR_WIDTH     = 3;

//input ports
input           sys_clk         ;           //system clock
input           sys_rst         ;           //reset, high active
input   [ 4: 0] baseaddr;     //base address(MSB) of i2c master register address
input           i2cm_wr         ;           //rab_write
input           i2cm_rd         ;           //rab_read
input   [ 8: 0] rab_addr;     //global address of register address
input   [ 7: 0] i2cm_wdata      ;           //Mcu write data to registers
input   [ 7: 0] rfifo_data_to_reg     ;     //input data from rfifo to register
input           rfifo_empty     ;           //rfifo empty flag
input           tfifo_empty     ;           //tfifo empty flag
input   [ADDR_WIDTH: 0] tfifo_freecnt ;     //free spaces of tfifo
input   [ADDR_WIDTH: 0] rfifo_wordcnt ;     //word numbers of rfifo
//input           busy            ;           //busy state
input           fsm_using       ;           //flag for byte FSM is being used
input   [ 3: 0] byte_fsm_status ;           //flag for byte FSM status
input           slave_waiting   ;           //flag for scl is hold low by slave
input           non_ack         ;           //flag for slave has not make a valid acknowledge
input           tfifo_overflow  ;           //flag for overflow of tfifo
input           rfifo_underflow ;           //flag for underflow of rfifo
input           sto_condition   ;           //stop condition
//output ports
output  [ 7: 0] i2cm_rdata      ;           //Mcu read data from registers
output          i2cm_ack        ;           //acknowledge of write/read access of register
output          tfifo_push      ;           //push data to tfifo
output          rfifo_pop       ;           //pop data from rfifo
output  [ 7: 0] tfifo_data_from_reg   ;     //output data from register to tfifo

output  [ 7: 0] device_id_seg   ;           //the device address for i2c read/write
output  [ 7: 0] offset          ;           //offset
output  [ 9: 0] data_len        ;           //length of transaction data
output          i2c_en          ;           //i2c master enable signal
output          start           ;           //transaction start signal
output  [ 2: 0] trans_type      ;           //transaction type
output          tfifo_en        ;           //enable tfifo
output          rfifo_en        ;           //enalbe rfifo
output  [ 9: 0] timing_para     ;           //timing parameter
output          opendrain       ;           //SCL/SDA mode,0=pull-push,1=open drain



////// real F/F ////////
reg     [ 7: 0] i2cm_rdata      ;
reg             i2cm_ack        ;
  // control register descriptions
reg     [ 7: 0] device_id_seg   ;
reg     [ 7: 0] offset          ;
reg     [ 9: 0] data_len        ;
reg             i2c_en          ;
reg             start           ;           // auto clear
reg     [ 2: 0] trans_type      ;
reg             tfifo_clr       ;
reg             rfifo_clr       ;
reg     [ 9: 0] timing_para     ;
reg             nonopendrain    ;
reg             non_ack_status  ;           // read status register
reg             tfifo_overflow_status ;     // tfifo overflow status register
reg             rfifo_underflow_status;     // rfifo underflow status register
reg             i2cm_busy       ;           // i2c master busy flag

/////////////////////// write/read register access //////////////////
//write registers
always @(posedge sys_clk or posedge sys_rst)
  if(sys_rst) begin
    device_id_seg   <=  8'h0    ;
    offset          <=  8'h0    ;
    data_len        <= 10'h0    ;
    i2c_en          <=  1'b0    ;
    start           <=  1'b0    ;
    trans_type      <=  3'h0    ;
    nonopendrain    <=  1'b0    ;
    tfifo_clr       <=  1'b0    ;
    rfifo_clr       <=  1'b0    ;
    timing_para     <= 10'h14   ;
  end
  //write register while write enable and select I2C master registers
  else if(i2cm_wr&&(rab_addr[8:4]==baseaddr)) begin
    case(rab_addr[3:0])
       I2CM_DEVICE_ID_SEG   : begin
          device_id_seg[ 7: 0]    <= i2cm_wdata[ 7: 0];
      end
       I2CM_OFFSET          : begin
          offset[ 7: 0]           <= i2cm_wdata[ 7: 0];
      end
       I2CM_LEN_LSB         : begin
          data_len[ 7: 0]         <= i2cm_wdata[ 7: 0];
      end
       I2CM_LEN_MSB         : begin
          data_len[ 9: 8]         <= i2cm_wdata[ 1: 0];
      end
       I2CM_CTRL            : begin
          i2c_en                  <= i2cm_wdata[    0];
          start                   <= i2cm_wdata[    1];
          nonopendrain            <= i2cm_wdata[    2];
          trans_type[ 2: 0]       <= i2cm_wdata[ 6: 4];
      end
       I2CM_FIFO_CLR        : begin
          tfifo_clr               <= i2cm_wdata[    0];
          rfifo_clr               <= i2cm_wdata[    1];
      end
       I2CM_TIMING_PARA_LSB : begin
          timing_para[ 7: 0]      <= i2cm_wdata[ 7: 0];
      end
       I2CM_TIMING_PARA_MSB : begin
          timing_para[ 9: 8]      <= i2cm_wdata[ 1: 0];
      end
    endcase
  end                   // end for "else if"
  else begin
    start     <= 1'b0;   // auto clear
    tfifo_clr <= 1'b0;   // auto clear
    rfifo_clr <= 1'b0;   // auto clear
  end


//read registers
always @(posedge sys_clk or posedge sys_rst)
  if(sys_rst) begin
    i2cm_rdata      <=  8'h0    ;
  end
  //read register while read enable and select I2C master registers
  else if(i2cm_rd&&(rab_addr[8:4]==baseaddr)) begin
    i2cm_rdata      <=  8'h0    ;          //default value
    case(rab_addr[3:0])
      I2CM_DEVICE_ID_SEG   : begin
          i2cm_rdata[ 7: 0]   <= device_id_seg[ 7: 0]  ;
      end
      I2CM_OFFSET          : begin
          i2cm_rdata[ 7: 0]   <= offset[ 7: 0]         ;
      end
      I2CM_LEN_LSB         : begin
          i2cm_rdata[ 7: 0]   <= data_len[ 7: 0]       ;
      end
      I2CM_LEN_MSB         : begin
          i2cm_rdata[ 1: 0]   <= data_len[ 9: 8]       ;
      end
      I2CM_CTRL            : begin
          i2cm_rdata[    0]   <= i2c_en                ;
          i2cm_rdata[    1]   <= start                 ;
          i2cm_rdata[    2]   <= nonopendrain          ;
          i2cm_rdata[ 6: 4]   <= trans_type[ 2: 0]     ;
      end
      I2CM_DATA_RD         : begin
          i2cm_rdata[ 7: 0]   <= rfifo_data_to_reg[ 7: 0]      ;
      end
      I2CM_FIFO_DEPTH      : begin
          i2cm_rdata[ 7: 4]   <= tfifo_freecnt[ADDR_WIDTH: 0]  ;
          i2cm_rdata[ 3: 0]   <= rfifo_wordcnt[ADDR_WIDTH: 0]  ;
      end
      I2CM_FIFO_CLR        : begin
          i2cm_rdata[    0]   <= tfifo_clr             ;
          i2cm_rdata[    1]   <= rfifo_clr             ;
      end
      I2CM_TIMING_PARA_LSB : begin
          i2cm_rdata[ 7: 0]   <= timing_para[ 7: 0]    ;
      end
      I2CM_TIMING_PARA_MSB : begin
          i2cm_rdata[ 1: 0]   <= timing_para[ 9: 8]    ;
      end
      I2CM_STATE           : begin
          i2cm_rdata[    0]   <= i2cm_busy             ;
          i2cm_rdata[    1]   <= ~rfifo_empty          ;
          i2cm_rdata[    2]   <= tfifo_empty           ;
          i2cm_rdata[    3]   <= fsm_using             ;
          i2cm_rdata[    4]   <= slave_waiting         ;
          i2cm_rdata[    5]   <= non_ack_status        ;
          i2cm_rdata[    6]   <= tfifo_overflow_status ;
          i2cm_rdata[    7]   <= rfifo_underflow_status;
      end
      I2CM_DEBUG_BYTE      : begin
          i2cm_rdata[ 3: 0]   <= byte_fsm_status       ;
      end
      default              : begin
          i2cm_rdata          <= 8'h0                  ;
      end
    endcase
  end   //end for "else if"


//write/read access acknowledge
always @(posedge sys_clk or posedge sys_rst)
  if(sys_rst)
    i2cm_ack <=  1'b0;
  else  //while select i2c master registers, either write or read, acknowledge
    i2cm_ack <=  (i2cm_wr | i2cm_rd)&&(rab_addr[8:4]==baseaddr);



//i2c master busy flag
always @(posedge sys_clk or posedge sys_rst)
  if(sys_rst)
    i2cm_busy <= 1'b0;
  else if(!i2c_en)
    i2cm_busy <= 1'b0;
  //while start(write "1" to start register), i2c master busy
  else if(i2cm_wr & (rab_addr[8:4]==baseaddr) & (((rab_addr[3:0] == I2CM_CTRL) & (i2cm_wdata[0]!=1'b0)) 
         | (rab_addr[3:2] == 2'b00) | (rab_addr[3:0] == I2CM_TIMING_PARA_LSB) | (rab_addr[3:0] == I2CM_TIMING_PARA_MSB))) 
    i2cm_busy <= 1'b1;
  else if(sto_condition) //while stop, i2c master unbusy
    i2cm_busy <= 1'b0;



//write "1" clear register
always @(posedge sys_clk or posedge sys_rst)
  if(sys_rst)
    non_ack_status <=  1'b0;
  else if(!i2c_en)
    non_ack_status <=  1'b0;
  else if(non_ack & (byte_fsm_status!=4'h2)) //NACK in EDDC read won't bring an error flag
    non_ack_status <=  1'b1;
  else if(i2cm_wr & (rab_addr[3:0] == I2CM_STATE) &(rab_addr[8:4]==baseaddr) & (i2cm_wdata[5]==1'b1))
    non_ack_status <=  1'b0;    

//write "1" clear register    
always @(posedge sys_clk or posedge sys_rst)
  if(sys_rst)
    tfifo_overflow_status <= 1'b0;
  else if(!i2c_en)
    tfifo_overflow_status <= 1'b0;
  else if(tfifo_overflow)
    tfifo_overflow_status <= 1'b1;
  else if(i2cm_wr & (rab_addr[3:0] == I2CM_STATE) &(rab_addr[8:4]==baseaddr) & (i2cm_wdata[6]==1'b1)) 
    tfifo_overflow_status <= 1'b0;

//write "1" clear register    
always @(posedge sys_clk or posedge sys_rst)
  if(sys_rst)
    rfifo_underflow_status <= 1'b0;
  else if(!i2c_en)
    rfifo_underflow_status <= 1'b0;
  else if(rfifo_underflow)
    rfifo_underflow_status <= 1'b1;
  else if(i2cm_wr & (rab_addr[3:0] == I2CM_STATE) &(rab_addr[8:4]==baseaddr) & (i2cm_wdata[7]==1'b1))
    rfifo_underflow_status <= 1'b0;
               

////////////// output description //////////////////
assign  opendrain   = ~nonopendrain;  //open drain control

//fifo control commands

//push enable while: write signal active and select i2c master registers
assign  tfifo_push  = i2cm_wr & (rab_addr=={baseaddr,I2CM_DATA_WR})   ;
//pop enable while: read signal active and select i2c master registers
assign  rfifo_pop   = i2cm_rd & (rab_addr=={baseaddr,I2CM_DATA_RD})   ;

//write data from registers to fifo
assign  tfifo_data_from_reg = i2cm_wdata[ 7: 0] ;

assign  tfifo_en    = i2c_en & (~tfifo_clr);  //enable tfifo
assign  rfifo_en    = i2c_en & (~rfifo_clr);  //enable rfifo




endmodule
