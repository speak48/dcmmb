//+FHDR-------------------------------------------------------------------
// Copyright (c) 2007, HHIC
// HHIC Confidential Proprietary
//------------------------------------------------------------------------
// FILE NAME : i2cm_bit_ctrl
// TYPE : module
// DEPARTMENT : design
// AUTHOR : Shuang Li
// AUTHOR'S EMAIL : lishuang@shhic.com
//------------------------------------------------------------------------
// Release history
// VERSION Date AUTHOR DESCRIPTION
// 1.0 27 Feb. 09 name lishuang
//------------------------------------------------------------------------
// PURPOSE : Translate simple commands into SCL/SDA transitions
//------------------------------------------------------------------------
// PARAMETERS
// PARAM NAME RANGE : DESCRIPTION : DEFAULT : VA UNITS
// e.g.DATA_WIDTH_PP [32,16] : width of the data : 32 :
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

module  i2cm_bit_ctrl(
        //inputs
        sys_clk       ,
        sys_rst       ,
        en            ,
        cmd           ,
        din           ,
        scl_i         ,
        sda_i         ,
        opendrain     ,
        timing_para   ,
        //outputs
        cmd_ack       ,
        busy          ,
        dout          ,
        scl_o         ,
        scl_oe        ,
        sda_o         ,
        sda_oe        ,
//        bit_fsm_status,
        hold_cnt      ,
        sto_condition
        );

`include "i2cm_defines.v"

// bit ctrl FSM state
parameter [4:0] IDLE    = 5'h0 ;
parameter [4:0] START_A = 5'h1 ;
parameter [4:0] START_B = 5'h2 ;
parameter [4:0] START_C = 5'h3 ;
parameter [4:0] START_D = 5'h4 ;
parameter [4:0] START_E = 5'h5 ;
parameter [4:0] STOP_A  = 5'h6 ;
parameter [4:0] STOP_B  = 5'h7 ;
parameter [4:0] STOP_C  = 5'h8 ;
parameter [4:0] STOP_D  = 5'h9 ;
parameter [4:0] RD_A    = 5'ha ;
parameter [4:0] RD_B    = 5'hb ;
parameter [4:0] RD_C    = 5'hc ;
parameter [4:0] RD_D    = 5'hd ;
parameter [4:0] WR_A    = 5'he ;
parameter [4:0] WR_B    = 5'hf ;
parameter [4:0] WR_C    = 5'h10;
parameter [4:0] WR_D    = 5'h11;


//inputs
input           sys_clk     ;   //system clock
input           sys_rst     ;   //HIGH active
input           en          ;   //enable
input   [ 2: 0] cmd         ;   //command sent by byte controller
input           din         ;   // data from byte ctrl
input           scl_i       ;   // i2c clock line input
input           sda_i       ;   // i2c data line input
input           opendrain   ;   //mode of SCL/SDA output,0=push pull,1=open drain
input   [ 9: 0] timing_para ;   //timing parameter input
//outputs
output          cmd_ack     ;   //acknowledge after finish every command
output          busy        ;   // i2c wire is busy
output          dout        ;   // output data
output          scl_o       ;   // i2c clock line output
output          scl_oe      ;   // i2c clock line output enable (active low)
output          sda_o       ;   // i2c data line output
output          sda_oe      ;   // i2c data line output enable (active low)
//output  [ 4: 0] bit_fsm_status  ;
output          hold_cnt        ;
output          sto_condition   ; //stop condition

///////////// all real F/F ///////////////////////////
// Port Type description
reg             cmd_ack     ;
reg             busy        ;
reg             dout        ;
reg             scl_o       ;
reg             scl_oe      ;
reg             sda_o       ;
reg             sda_oe      ;
//reg     [ 4: 0] bit_fsm_status  ;

// Debounce
//de-bounce and synchronize registers
reg             s_scl_0     ;           //synchroniz SCL inputs
reg             s_scl_1     ;           //synchroniz SCL inputs
reg             s_scl_2     ;           //synchroniz SCL inputs
reg             s_sda_0     ;           //synchroniz SDA inputs
reg             s_sda_1     ;           //synchroniz SDA inputs
reg             s_sda_2     ;           //synchroniz SDA inputs
reg             de_scl_0    ;           //de-bounce SCL
reg             de_scl_1    ;           //de-bounce SCL
reg             de_sda_0    ;           //de-bounce SDA
reg             de_sda_1    ;           //de-bounce SDA
reg             d_scl       ;           //SCL after de-bounce
reg             d_sda       ;           //SDA after de-bounce
reg             d_scl_d1    ;           //delay of d_scl
reg             d_sda_d1    ;           //delay of d_sda

// internal logic
reg             sta_condition   ;       //star condition
reg             sto_condition   ;       //stop condition
//reg             sda_chk     ;           //check sda
reg     [ 9: 0] cnt         ;           //counter to load timing parameter
reg             clk_en      ;           //enable SCL
reg     [ 4: 0] c_state     ;           //current state of FSM

//////////////// combination logic ///////////////////
// internal logic
reg             hold_cnt    ;           //hold FSM
wire            d_sda_rising    ;       //detecting the rising edge of sda
wire            d_sda_falling   ;       //detecting the falling edge of sda
wire            d_scl_rising    ;       //detecting the rising edge of scl
wire            d_scl_falling   ;       //detecting the falling edge of scl

wire            scltohigh   ;           //set scl to high
//wire            sdatohigh   ;           //set sda to high




///////////// input process ////////////////
//synchronize SCL and SDA
always @(posedge sys_clk or posedge sys_rst)
  if(sys_rst) begin
    s_scl_0   <= 1'b1;
    s_scl_1   <= 1'b1;
    s_scl_2   <= 1'b1;
    s_sda_0   <= 1'b1;
    s_sda_1   <= 1'b1;
    s_sda_2   <= 1'b1;
  end
  else begin
    s_scl_0   <= scl_i   ;
    s_scl_1   <= s_scl_0 ;
    s_scl_2   <= s_scl_1 ;
    s_sda_0   <= sda_i   ;
    s_sda_1   <= s_sda_0 ;
    s_sda_2   <= s_sda_1 ;
  end

//de-bounce
always @(posedge sys_clk or posedge sys_rst)
  if(sys_rst) begin
    de_scl_0  <= 1'b1;
    de_scl_1  <= 1'b1;
    de_sda_0  <= 1'b1;
    de_sda_1  <= 1'b1;
  end
  else begin
    de_scl_0  <= s_scl_2 ;
    de_scl_1  <= de_scl_0;
    de_sda_0  <= s_sda_2 ;
    de_sda_1  <= de_sda_0;
  end
always @(s_scl_2 or de_scl_0 or de_scl_1)
  begin
    case({s_scl_2,de_scl_0,de_scl_1})
        3'b011: d_scl = 1'b1;
        3'b101: d_scl = 1'b1;
        3'b110: d_scl = 1'b1;
        3'b111: d_scl = 1'b1;
        default:d_scl = 1'b0;
    endcase
  end
always @(s_sda_2 or de_sda_0 or de_sda_1)
  begin
    case({s_sda_2,de_sda_0,de_sda_1})
        3'b011: d_sda = 1'b1;
        3'b101: d_sda = 1'b1;
        3'b110: d_sda = 1'b1;
        3'b111: d_sda = 1'b1;
        default:d_sda = 1'b0;
    endcase
  end
//delay de-bouced d_scl and d_sda
always @(posedge sys_clk or posedge sys_rst)
  if(sys_rst) begin
    d_scl_d1 <= 1'b1;
    d_sda_d1 <= 1'b1;
  end
  else begin
    d_scl_d1 <= d_scl;
    d_sda_d1 <= d_sda;
  end





////////////// generat busy flag ///////////////////
//detect the rising and falling edge of scl and sda
assign  d_sda_rising  = d_sda & (~d_sda_d1) ;
assign  d_sda_falling = (~d_sda) & d_sda_d1 ;
assign  d_scl_rising  = d_scl & (~d_scl_d1) ;
//assign  d_scl_falling = (~d_scl) & d_scl_d1 ;


// detect start condition : detect falling edge on SDA while SCL is high
always @(posedge sys_clk or posedge sys_rst)
    if (sys_rst)
        sta_condition <=   1'b0;
    else if(!en)
        sta_condition <=   1'b0;
    else
        sta_condition <=   d_sda_falling & d_scl;

// detect stop condition : detect rising edge on SDA while SCL is high
always @(posedge sys_clk or posedge sys_rst)
    if (sys_rst)
        sto_condition <=   1'b0;
    else if(!en)
        sto_condition <=   1'b0;
    else
        sto_condition <=   d_sda_rising & d_scl;

// generate i2c bus busy signal
always @(posedge sys_clk or posedge sys_rst)
    if(sys_rst)
        busy <=  1'b0;
    else if(!en)
        busy <=  1'b0;
    else if(sta_condition)
        busy <=  1'b1;
    else if(sto_condition)
        busy <=  1'b0;




/////////////////////////// counter /////////////////////
//hold counter when: setting scl to high but scl is forced to low at start,read,write,stop states
always @(scltohigh or d_scl or c_state) begin
    if(c_state != IDLE)
        if(scltohigh & (~d_scl))  //compare de-bounced input scl and output scl from FSM
            hold_cnt = 1'b1;
        else
            hold_cnt = 1'b0;
    else
        hold_cnt = 1'b0;
end
//assign  hold_cnt = scltohigh & (~d_scl) & (~c_state_at_idlestatus) ;

always @(posedge sys_clk or posedge sys_rst)
  if(sys_rst) begin
    cnt <= 10'h00 ;
    clk_en <= 1'b1;
  end
  else if(!en) begin
    cnt <= timing_para;
    clk_en <= 1'b1;
  end
  else if(cnt==10'h00) begin   //load timing parameter while cnt==0 and FSM begin to run
    cnt <= timing_para;
    clk_en <= 1'b1;
  end
  else if(hold_cnt) begin      //hold counter: counter don't decrease and FSM keep the curren state
    cnt <= cnt;
    clk_en <= 1'b0;
  end
  else begin                   //when counter decrease and FSM keep the curren state
    cnt <= cnt - 1'b1;
    clk_en <= 1'b0;
  end

//opendrain mode: scl_oe is low(disable), scl is set to high
//push-pull mode: scl_o is high, scl is set to high
assign  scltohigh = opendrain? (~scl_oe): scl_o;





/////////////////////////// FSM /////////////////////

        // generate statemachine
  always @(posedge sys_clk or posedge sys_rst)
      if(sys_rst)
          begin
                  c_state <= IDLE;
                  cmd_ack <= 1'b0;
              scl_o   <= 1'b0;
              scl_oe  <= 1'b0;
              sda_o   <= 1'b0;
              sda_oe  <= 1'b0;
              //sda_chk <= 1'b0;
          end
//      else if((!en) | arb_lost)
      else if(!en)
          begin
                  c_state <= IDLE;
                  cmd_ack <= 1'b0;
                  scl_o   <= 1'b1;                  // set SCL high
                  scl_oe  <= opendrain?1'b0:1'b1;
                  sda_o   <= 1'b1;                  // set SDA high
                  sda_oe  <= opendrain?1'b0:1'b1;
              //sda_chk <= 1'b0;
          end
      else
          begin
              cmd_ack <= 1'b0 ;          // default value
                  if(clk_en)
                      case(c_state)
                          IDLE:
                          begin
                                  case(cmd)             //switch to the specify state when receiving commands
                                       I2CM_CMD_START:
                                          c_state <= START_A;
                                       I2CM_CMD_STOP:
                                          c_state <= STOP_A;
                                       I2CM_CMD_WRITE:
                                          c_state <= WR_A;
                                       I2CM_CMD_READ:
                                          c_state <= RD_A;
                                      default:
                                          c_state <= IDLE;
                                  endcase
                                  cmd_ack <= 1'b0;
                                  scl_o   <= scl_o   ;  // keep SCL in same state
                                  scl_oe  <= scl_oe  ;
                                  sda_o   <= sda_o   ;  // keep SDA in same state
                                  sda_oe  <= sda_oe  ;
                          //sda_chk <= 1'b0    ;  // don't check SDA output
                          end
                          //start
                          START_A:
                          begin
                                      c_state <= START_B;
                                  cmd_ack <= 1'b0;
                                  scl_o   <= scl_o              ; // keep SCL in same state
                                  scl_oe  <= scl_oe             ;
                                  sda_o   <= 1'b1;                // set SDA high
                                  sda_oe  <= opendrain?1'b0:1'b1;
                                  //sda_chk <= 1'b0               ; // don't check SDA output
                          end

                          START_B:
                          begin
                                      c_state <= START_C;
                                      cmd_ack <= 1'b0;
                                      scl_o   <= 1'b1;                // set SCL high
                                      scl_oe  <= opendrain?1'b0:1'b1;
                                      sda_o   <= 1'b1;                // set SDA high
                                      sda_oe  <= opendrain?1'b0:1'b1;
                                      //sda_chk <= 1'b0               ; // don't check SDA output
                          end

                          START_C:
                          begin
                                      c_state <= START_D;
                                      cmd_ack <= 1'b0;
                                      scl_o   <= 1'b1;                // set SCL high
                                      scl_oe  <= opendrain?1'b0:1'b1;
                                      sda_o   <= 1'b0;                // set SDA low
                                      sda_oe  <= 1'b1;
                                      //sda_chk <= 1'b0               ; // don't check SDA output
                          end

                          START_D:
                          begin
                                      c_state <= START_E;
                                      cmd_ack <= 1'b0;
                                      scl_o   <= 1'b1;                // set SCL high
                                      scl_oe  <= opendrain?1'b0:1'b1;
                                      sda_o   <= 1'b0;                // set SDA low
                                      sda_oe  <= opendrain?1'b1:1'b1;
                                     //sda_chk <= 1'b0               ; // don't check SDA output
                          end

                          START_E:
                          begin
                                      c_state <= IDLE;
                                      cmd_ack <= 1'b1;
                                      scl_o   <= 1'b0;                // set SCL low
                                      scl_oe  <= 1'b1;
                                      sda_o   <= 1'b0;                // set SDA low
                                      sda_oe  <= 1'b1;
                                      //sda_chk <= 1'b0               ; // don't check SDA output
                          end
                          //stop
                          STOP_A:
                          begin
                                      c_state <= STOP_B;
                                      cmd_ack <= 1'b0;
                                      scl_o   <= 1'b0;                // set SCL low
                                      scl_oe  <= 1'b1;
                                      sda_o   <= 1'b0;                // set SDA low
                                      sda_oe  <= 1'b1;
                                      //sda_chk <= 1'b0               ; // don't check SDA output
                          end

                          STOP_B:
                          begin
                                      c_state <= STOP_C;
                                      cmd_ack <= 1'b0;
                                      scl_o   <= 1'b1;                // set SCL high
                              scl_oe  <= opendrain?1'b0:1'b1;
                              sda_o   <= 1'b0;                // set SDA low
                              sda_oe  <= 1'b1;
                              //sda_chk <= 1'b0               ; // don't check SDA output
                          end

                          STOP_C:
                          begin
                                      c_state <= STOP_D;
                                      cmd_ack <= 1'b0;
                                      scl_o   <= 1'b1;                // set SCL high
                                      scl_oe  <= opendrain?1'b0:1'b1;
                                      sda_o   <= 1'b0;                // set SDA low
                                      sda_oe  <= 1'b1;
                                      //sda_chk <= 1'b0               ; // don't check SDA output
                          end

                          STOP_D:
                          begin
                                      c_state <= IDLE;
                                      cmd_ack <= 1'b1;
                                      scl_o   <= 1'b1;                // set SCL high
                                      scl_oe  <= opendrain?1'b0:1'b1;
                                      sda_o   <= 1'b1;                // set SDA high
                                      sda_oe  <= opendrain?1'b0:1'b1;
                                      //sda_chk <= 1'b0               ; // don't check SDA output
                          end

                          //read
                          RD_A:
                          begin
                                      c_state <= RD_B;
                                      cmd_ack <= 1'b0;
                              scl_o   <= 1'b0;                // set SCL low
                              scl_oe  <= 1'b1;
                              sda_o   <= 1'b0;                // tri-state SDA, release SDA
                              sda_oe  <= 1'b0;
                              //sda_chk <= 1'b0               ; // don't check SDA output
                            end

                          RD_B:
                          begin
                                      c_state <= RD_C;
                                      cmd_ack <= 1'b0;
                                      scl_o   <= 1'b1;                // set SCL high
                                      scl_oe  <= opendrain?1'b0:1'b1;
                                      sda_o   <= 1'b0;                // tri-state SDA, release SDA
                              sda_oe  <= 1'b0;
                              //sda_chk <= 1'b0               ; // don't check SDA output
                            end

                          RD_C:
                          begin
                                      c_state <= RD_D;
                                      cmd_ack <= 1'b0;
                                      scl_o   <= 1'b1;                // set SCL high
                                      scl_oe  <= opendrain?1'b0:1'b1;
                                      sda_o   <= 1'b0;                // tri-state SDA, release SDA
                                      sda_oe  <= 1'b0;
                                      //sda_chk <= 1'b0               ; // don't check SDA output
                            end
                          RD_D:
                          begin
                                      c_state <= IDLE;
                                      cmd_ack <= 1'b1;
                                      scl_o   <= 1'b0;                // set SCL low
                                      scl_oe  <= 1'b1;
                                      sda_o   <= 1'b0;                // tri-state SDA, release SDA
                                      sda_oe  <= 1'b0;
                                      //sda_chk <= 1'b0               ; // don't check SDA output
                            end

                          //write
                          WR_A:
                          begin
                                      c_state <= WR_B;
                                      cmd_ack <= 1'b0;
                                      scl_o   <= 1'b0;                // set SCL low
                                      scl_oe  <= 1'b1;
                                      sda_o   <= opendrain?1'b0:din ; // set SDA to din
                                      sda_oe  <= opendrain?(~din):1'b1;
                                      //sda_chk <= 1'b0               ; // don't check SDA output (SCL low)
                            end

                          WR_B:
                          begin
                                      c_state <= WR_C;
                                      cmd_ack <= 1'b0;
                                      scl_o   <= 1'b1;                // set SCL high
                                      scl_oe  <= 1'b1;
                                      sda_o   <= opendrain?1'b0:din ; // keep SDA to din
                                      sda_oe  <= opendrain?(~din):1'b1;
                                      //sda_chk <= 1'b1               ; // check SDA output
                            end

                          WR_C:
                          begin
                                      c_state <= WR_D;
                                      cmd_ack <= 1'b0;
                                      scl_o   <= 1'b1;                // set SCL high
                              scl_oe  <= opendrain?1'b0:1'b1;
                              sda_o   <= opendrain?1'b0:din ; // keep SDA to din
                              sda_oe  <= opendrain?(~din):1'b1;
                              //sda_chk <= 1'b1               ; // check SDA output
                            end

                          WR_D:
                          begin
                                      c_state <= IDLE;
                                      cmd_ack <= 1'b1;
                                      scl_o   <= 1'b0;                // set SCL low
                                      scl_oe  <= 1'b1;
                                      sda_o   <= opendrain?1'b0:din ; // keep SDA to din
                                      sda_oe  <= opendrain?(~din):1'b1;
                                      //sda_chk <= 1'b0               ; // don't check SDA output (SCL low)
                            end
                          default:
                          begin
                              c_state <= IDLE;
                                      cmd_ack <= 1'b1;
                                      scl_o   <= 1'b1;
                                      scl_oe  <= 1'b1;
                                      sda_o   <= 1'b1;
                                      sda_oe  <= 1'b1;
                                      //sda_chk <= 1'b0;
                            end
                      endcase

          end  //end for "else"


///////////// latch sda /////////////////
always @(posedge sys_clk or posedge sys_rst)
  if(sys_rst)
    dout <= 1'b1;
  else if(!en)
    dout <= 1'b1;
  else if(d_scl_rising)
    dout <= d_sda;

endmodule

