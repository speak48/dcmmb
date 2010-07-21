//+FHDR-------------------------------------------------------------------
// Copyright (c) 2007, HHIC
// HHIC Confidential Proprietary
//------------------------------------------------------------------------
// FILE NAME : i2cm_bytet_ctrl
// TYPE : module
// DEPARTMENT : design
// AUTHOR : Shuang Li
// AUTHOR'S EMAIL : lishuang@shhic.com
//------------------------------------------------------------------------
// Release history
// VERSION Date AUTHOR DESCRIPTION
// 1.0 27 Mar 09 name lishuang
//------------------------------------------------------------------------
// PURPOSE : Sends transaction commands to bit-controller, and transmits
//           data to fifo.
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


module  i2cm_byte_ctrl(
        //inputs
        sys_clk                   ,
        sys_rst                   ,
        en                        ,
        tfifo_empty               ,
        rfifo_full                ,
        tfifo_data_to_shift       ,
        rbit_from_bitctrl         ,
        cmd_ack_from_bitctrl      ,
        bus_busy                  ,
        start                     ,
        trans_type                ,
        device_id_seg             ,
        addr_offset               ,
        data_len                  ,
        //outputs
        tfifo_pop                 ,
        rfifo_push                ,
        rfifo_data_from_shift     ,
        tbit_to_bitctrl           ,
        cmd_to_bitctrl            ,
        fsm_enable                ,
        non_ack                   ,
        c_state
        );
`include "i2cm_defines.v"

//FSM states
parameter       ST_IDLE             = 4'h0;
parameter       ST_START            = 4'h1;
parameter       ST_WR_ID            = 4'h2;
parameter       ST_WR_OFFSET        = 4'h3;
parameter       ST_RD_DATA          = 4'h4;
parameter       ST_WR_DATA          = 4'h5;
parameter       ST_STOP             = 4'h6;

//inputs
input           sys_clk                 ;
input           sys_rst                 ;
input           en                      ;
input           tfifo_empty             ;   //tfifo empty flag
input           rfifo_full              ;   //rfifo full flag
input   [ 7: 0] tfifo_data_to_shift     ;   //data pop from tfifo to shifter
input           rbit_from_bitctrl       ;   //bit data received from bit-controller
input           cmd_ack_from_bitctrl    ;   //acknowledge from bit-controller
input           bus_busy                ;   //i2c bus is busy
input           start                   ;   //start transaction command(from register)
input   [ 2: 0] trans_type              ;   //transaction type
input   [ 7: 0] device_id_seg           ;   //device id or segment in EDDC
input   [ 7: 0] addr_offset             ;   //address offset of device
input   [ 9: 0] data_len                ;   //length of transaction data(byte)
//outputs
output          tfifo_pop               ;   //tfifo pop data to i2c master
output          rfifo_push              ;   //i2c master push data to rfifo
output  [ 7: 0] rfifo_data_from_shift   ;   //data push to rfifo
output          tbit_to_bitctrl         ;   //bit data send to bit-controller
output  [ 2: 0] cmd_to_bitctrl          ;   //command send to bit-controller
output          fsm_enable              ;   //enable FSM
output          non_ack                 ;   //error flag(no acknowledge)
output  [ 3: 0] c_state                 ;   //FSM status of byte-controller


//real F/F
reg             rfifo_push              ;
reg             tfifo_pop               ;
reg             fsm_enable              ;
reg             non_ack                 ;
reg     [ 2: 0] cmd_to_bitctrl          ;
reg             tbit_to_bitctrl         ;

reg     [ 3: 0] c_state                 ;   //current state
reg     [ 1: 0] cmd_cnt                 ;   //counter for command
reg     [ 9: 0] dat_cnt                 ;   //counter for transaction data length
reg     [ 3: 0] bit_cnt                 ;   //counter for 8 bits
reg     [ 7: 0] shift                   ;   //data shifter

//combinational logic
reg     [ 7: 0] dev_id_load             ;   //load device ID
reg     [ 7: 0] offset_load             ;   //load offset
reg     [ 1: 0] cmd_cnt_load            ;   //load initial vaule to command counter





// load several "start" (according to trans type) to cmd_cnt
always @(trans_type)
  begin
    case(trans_type)
      BKSV_READ : begin  // BKSV read
        cmd_cnt_load = 2'h1;    // 2 start
      end
      SEQ_WRITE : begin  // Sequential write
        cmd_cnt_load = 2'h0;    // 1 start
      end
      EDID_READ : begin  // EDDC read
        cmd_cnt_load = 2'h2;    // 3 start
      end
      SEQ_READ  : begin  // Sequential read
        cmd_cnt_load = 2'h1;    // 2 start
      end
      CUR_READ  : begin  // Current read
        cmd_cnt_load = 2'h0;    // 1 start
      end
      default   : begin
        cmd_cnt_load = 2'h0;    // default value
      end
    endcase
  end



// load different device id and offset address according the order of
// "start" on the condition of transaction type to FSM
always @(cmd_cnt or trans_type or  device_id_seg or addr_offset)
  begin
    case(trans_type)
      BKSV_READ : begin     // BKSV read
        case(cmd_cnt)
          2'h1 : begin      // 1st send device_id + "W" and offset address
            dev_id_load = {device_id_seg[6:0],1'b0} ;
            offset_load = 8'h43 ;
          end
          2'h0 : begin      // 2nd send device_id + "R" only
            dev_id_load = {device_id_seg[6:0],1'b1} ;
            offset_load = 8'h0  ;
          end
          default: begin
            dev_id_load = 8'h0  ;   // default value
            offset_load = 8'h0  ;   // default value
          end
        endcase
      end //end for case BKSV_READ
      SEQ_WRITE : begin    // Sequential write
        dev_id_load = {device_id_seg[6:0],1'b0};
        offset_load = addr_offset   ;
      end
      EDID_READ : begin    // EDDC read
        case(cmd_cnt)
          2'h2 : begin     // 1st send 0x60 and segment
            dev_id_load = 8'h60 ;
            offset_load = device_id_seg ;
          end
          2'h1 : begin     // 2nd send 0xA0 and offset address
            dev_id_load = 8'ha0 ;
            offset_load = addr_offset   ;
          end
          2'h0 : begin     // 3rd send 0xA1 only
            dev_id_load = 8'ha1 ;
            offset_load = 8'h0  ;
          end
          default: begin
            dev_id_load = 8'h0  ;   // default value
            offset_load = 8'h0  ;   // default value
          end
        endcase
      end //end for case EDID_READ
      SEQ_READ : begin     // Sequential read
        case(cmd_cnt)
          2'h1 : begin     // 1st send device_id + "W" and 0x43
            dev_id_load = {device_id_seg[6:0],1'b0} ;
            offset_load = addr_offset   ;
          end
          2'h0 : begin     // 2nd send device_id + "R" only
            dev_id_load = {device_id_seg[6:0],1'b1} ;
            offset_load = 8'h0  ;
          end
          default: begin
            dev_id_load = 8'h0  ;   // default value
            offset_load = 8'h0  ;   // default value
          end
        endcase
      end
      CUR_READ : begin     // Current read
        dev_id_load = {device_id_seg[6:0],1'b1};
        offset_load = 8'h0  ;
      end
      default: begin
        dev_id_load = 8'h0  ;   // default value
        offset_load = 8'h0  ;   // default value
      end
    endcase
  end  //end for "always"



//enable state machine while received the "start" command from CPU
always @(posedge sys_clk or posedge sys_rst)
  if(sys_rst)
    fsm_enable <=   1'b0;
  else if(!en)
    fsm_enable <=   1'b0;
  else if(start)
    fsm_enable <=   1'b1;
  else if((c_state == ST_STOP) & cmd_ack_from_bitctrl)
    fsm_enable <=   1'b0;




///////////////////////  FSM  //////////////////////////////////
always @(posedge sys_clk or posedge sys_rst)
  if(sys_rst) begin
    c_state     <=   ST_IDLE      ;
    cmd_cnt     <=   2'h0         ;
    dat_cnt     <=  10'h0         ;
    bit_cnt     <=   4'h0         ;
    shift       <=   8'h0         ;
    cmd_to_bitctrl  <=   I2CM_CMD_IDLE   ;
    non_ack     <=   1'b0         ;
  end
  else if(!en) begin
    c_state     <=   ST_IDLE      ;
    cmd_cnt     <=   2'h0         ;
    dat_cnt     <=  10'h0         ;
    bit_cnt     <=   4'h0         ;
    shift       <=   8'h0         ;
    cmd_to_bitctrl  <=   I2CM_CMD_IDLE   ;
    non_ack     <=   1'b0         ;
  end
  else begin
    non_ack     <=   1'b0         ;

    case(c_state)
      ST_IDLE               : begin
        if(fsm_enable & (~bus_busy)) begin
            c_state     <=   ST_START     ;
            cmd_cnt     <=   cmd_cnt_load ;
            dat_cnt     <=   data_len     ;
            bit_cnt     <=   4'h0         ;
            shift       <=   8'h0         ;
            cmd_to_bitctrl  <=   I2CM_CMD_START  ;
        end
      end
      ST_START              : begin
        if(cmd_ack_from_bitctrl) begin  // wait until the cmd done by bitctrl
            c_state     <=   ST_WR_ID     ;
            bit_cnt     <=   4'h8         ;
            shift       <=   dev_id_load  ;
            cmd_to_bitctrl  <=   I2CM_CMD_WRITE  ;
        end
      end
      ST_WR_ID              : begin
        if(cmd_ack_from_bitctrl) begin  // wait until the cmd done by bitctrl
          if(bit_cnt ==  4'h1) begin    // have send all the 8 bit of dev id
            bit_cnt     <=   4'h0         ;
            shift       <=   8'h0         ;
            cmd_to_bitctrl  <=   I2CM_CMD_READ   ;
          end
          else if(bit_cnt ==  4'h0) begin        // wait WRITE_ID ACK
              non_ack     <=   rbit_from_bitctrl  ;
              if(trans_type == SEQ_WRITE) begin  // sequential write, this is always the last start.
                c_state     <=   ST_WR_OFFSET   ;
                bit_cnt     <=   4'h8         ;
                shift       <=   offset_load  ;
                cmd_to_bitctrl  <=   I2CM_CMD_WRITE  ;
              end
              else begin // EDDC read/sequential read/BKSV read/current read
                if(cmd_cnt ==  2'h0) begin // the last "start"
                  c_state     <=   ST_RD_DATA   ;
                  bit_cnt     <=   4'h8         ;
                  shift       <=   8'h0         ;
                  cmd_to_bitctrl  <=   I2CM_CMD_READ   ;
                end
                else begin // not last "start"
                  c_state     <=   ST_WR_OFFSET   ;
                  bit_cnt     <=   4'h8         ;
                  shift       <=   offset_load  ;
                  cmd_to_bitctrl  <=   I2CM_CMD_WRITE  ;
                end
              end
          end
          else begin // if have not send the 8 bit of dev id
            c_state     <=   ST_WR_ID     ;
            bit_cnt     <=   bit_cnt - 1'b1   ;
            shift       <=   {shift[6:0],1'b0};
            cmd_to_bitctrl  <=   I2CM_CMD_WRITE  ;
          end
        end
      end
      ST_WR_OFFSET            : begin
        if(cmd_ack_from_bitctrl) begin  // wait until the cmd done by bitctrl
          if(bit_cnt ==  4'h1) begin    // have send all the 8 bit of addr
            bit_cnt     <=   4'h0         ;
            shift       <=   8'h0         ;
            cmd_to_bitctrl  <=   I2CM_CMD_READ   ;
          end
          else if(bit_cnt ==  4'h0) begin      //wait WR_ADDR ACK
            non_ack     <=   rbit_from_bitctrl  ;
            if(trans_type == SEQ_WRITE) begin  // sequential write, this is always the last start.
              c_state     <=   ST_WR_DATA   ;
              bit_cnt     <=   4'h8         ;
              shift       <=   tfifo_data_to_shift    ;
              cmd_to_bitctrl  <=   I2CM_CMD_WRITE   ;
            end
            else begin // EDDC read/sequential read/BKSV read/current read
              c_state     <=   ST_START     ;
              cmd_cnt     <=   cmd_cnt - 1'b1 ; // remain the cmd_cnt
              bit_cnt     <=   4'h0         ;
              shift       <=   8'h0         ;
              cmd_to_bitctrl  <=   I2CM_CMD_START  ;
            end
          end
          else begin // if have not send the 8 bit of dev id
            c_state     <=   ST_WR_OFFSET   ;
            bit_cnt     <=   bit_cnt - 1'b1   ;
            shift       <=   {shift[6:0],1'b0};
            cmd_to_bitctrl  <=   I2CM_CMD_WRITE  ;
          end
        end
      end

      ST_RD_DATA            : begin
        if(cmd_ack_from_bitctrl) begin  // wait until the cmd done by bitctrl
          if(bit_cnt ==  4'h1) begin    // have received all the 8 bit of data
            bit_cnt     <=   4'h0         ;
            shift       <=   {shift[6:0],rbit_from_bitctrl}   ;
            cmd_to_bitctrl  <=   I2CM_CMD_WRITE  ;
          end
          else if(bit_cnt ==  4'h0) begin //Echo RD_DATA ACK
            if(dat_cnt == 10'h0) begin
              c_state     <=   ST_STOP          ;
              dat_cnt     <=   10'h0            ; // remain the dat_cnt
              bit_cnt     <=   4'h0             ;
              cmd_to_bitctrl  <=   I2CM_CMD_STOP   ;
            end
            else begin
              c_state     <=   ST_RD_DATA       ;
              dat_cnt     <=   dat_cnt - 1'b1   ;
              bit_cnt     <=   4'h8             ;
              cmd_to_bitctrl  <=   I2CM_CMD_READ   ;
            end
          end
          else begin // haven't received all the 8 bit of data
            c_state     <=   ST_RD_DATA   ;
            bit_cnt     <=   bit_cnt - 1'b1   ;
            shift       <=   {shift[6:0],rbit_from_bitctrl}   ;
            cmd_to_bitctrl  <=   I2CM_CMD_READ   ;
          end
        end
      end
      ST_WR_DATA            : begin
        if(cmd_ack_from_bitctrl) begin  // wait until the cmd done by bitctrl
          if(bit_cnt ==  4'h1) begin    // have send all the 8 bit of addr
            bit_cnt     <=   4'h0         ;
            shift       <=   8'h0         ;
            cmd_to_bitctrl  <=   I2CM_CMD_READ   ;
          end
          else if(bit_cnt ==  4'h0) begin// wait WR_DATA ACK
            non_ack     <=   rbit_from_bitctrl  ;
            if(dat_cnt == 10'h0) begin   // have send all data
              c_state     <=   ST_STOP      ;
              bit_cnt     <=   4'h0         ;
              shift       <=   8'h0         ;
              cmd_to_bitctrl  <=   I2CM_CMD_STOP ;
            end
            else begin
              c_state     <=   ST_WR_DATA         ;
              dat_cnt     <=   dat_cnt - 1'b1     ;
              bit_cnt     <=   4'h8               ;
              shift       <=   tfifo_data_to_shift;
              cmd_to_bitctrl  <=   I2CM_CMD_WRITE;
            end
          end
          else begin // if have not send the 8 bit of dev id
            c_state     <=   ST_WR_DATA   ;
            bit_cnt     <=   bit_cnt - 1'b1   ;
            shift       <=   {shift[6:0],1'b0};
            cmd_to_bitctrl  <=   I2CM_CMD_WRITE  ;
          end
        end
      end
      ST_STOP               : begin
        if(cmd_ack_from_bitctrl) begin  // wait until the cmd done by bitctrl
          c_state     <=   ST_IDLE      ;
          bit_cnt     <=   4'h0         ;
          shift       <=   8'h0         ;
          cmd_to_bitctrl  <=   I2CM_CMD_IDLE ;
        end
      end
      default               : begin
        c_state     <=   ST_IDLE      ;
        cmd_cnt     <=   cmd_cnt_load ;
        dat_cnt     <=   data_len     ;
        bit_cnt     <=   4'h8         ;
        shift       <=   8'h0         ;
        cmd_to_bitctrl  <=   I2CM_CMD_IDLE   ;
        non_ack     <=   1'b0         ;
      end
    endcase
  end



/////////////////////////  outputs declaration  //////////////////////////////

//bit data send to bit-controller
always @(c_state or dat_cnt or shift or bit_cnt)
  begin
    if((c_state == ST_RD_DATA)&&(bit_cnt == 4'h0)) begin // 1 byte has been read
        if(dat_cnt == 10'h0)
          tbit_to_bitctrl = 1'b1 ;    // n-acknowledge while transaction finished
        else
          tbit_to_bitctrl = 1'b0 ;    // acknowledge while transaction unfinished
    end
    else
        tbit_to_bitctrl = shift[7] ;  // data from shifter
  end



////// fifo control ///
assign  rfifo_data_from_shift   = shift ;   // output data from shifter to fifo

//pop data from tfifo to i2c master:
//1)while transaction type is sequential write and current state of FSM is ST_WR_OFFSET,
//  1 byte has been send over and received over the acknowledge from bit-controller
//2)while current state of FSM is ST_WR_DATA, data transaction finished,
//  1 byte has been send over and received over the acknowledge from bit-controller
always @(posedge sys_clk or posedge sys_rst)
  if(sys_rst)
    tfifo_pop  <=  1'b0;
  else if(!en)
    tfifo_pop  <=  1'b0;
  else begin
    if((c_state==ST_WR_OFFSET)&&(trans_type==SEQ_WRITE)) begin
      if(cmd_ack_from_bitctrl&&(bit_cnt==4'h0))
        tfifo_pop  <=  1'b1; //pop data from tfifo to i2c master
      else
        tfifo_pop  <=  1'b0;
    end
    else if((c_state==ST_WR_DATA)&&(dat_cnt!=10'h0)) begin
      if(cmd_ack_from_bitctrl&&(bit_cnt==4'h0))
        tfifo_pop  <=  1'b1; //pop data from tfifo to i2c master
      else
        tfifo_pop  <=  1'b0;
    end
    else
      tfifo_pop    <=  1'b0;
  end

//i2c master push data to rfifo:
//while curren state of FSM is ST_RD_DATA, 1 byte has been send over,
//and received an acknowledge form bit-controller
always @(posedge sys_clk or posedge sys_rst)
  if(sys_rst)
    rfifo_push <=  1'b0;
  else if(!en)
    rfifo_push <=  1'b0;
  else begin
    if((c_state==ST_RD_DATA)&&cmd_ack_from_bitctrl&&(bit_cnt==4'h0))
      rfifo_push <= 1'b1;
    else
      rfifo_push <= 1'b0;
  end


endmodule
