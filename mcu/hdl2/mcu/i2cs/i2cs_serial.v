//`timescale 1ns/1ps
//+FHDR-------------------------------------------------------------------
// Copyright (c) 2007, HHIC
// HHIC Confidential Proprietary
//------------------------------------------------------------------------
// FILE NAME : i2cm_top
// TYPE : module
// DEPARTMENT : design
// AUTHOR : Shuang Li
// AUTHOR  S EMAIL : lishuang@hhic.com
//------------------------------------------------------------------------
// Release history
// VERSION   Date    AUTHOR    DESCRIPTION
// 1.0         /       /      initial version
// 1.1    9/13/2004    /      Modified i2c_slave for EDID reading
// 1.2    5/31/2006    /      Add support for 3rd I2C address for UDP
// 1.3    18/8/2009 lishuang  Modified i2c_slave for current reading and
//                            interface
//------------------------------------------------------------------------
// PURPOSE : implementation of i2c slave
//
//AD9387_A
//1) Add output wrStrobe_st for packet ram enable
//   This signal is active high
//2) Add rdClk for packet ram read.
//                  ___________
//rdStrobe   ______|          |__________
//            ______     _________________
//rdClk            |_____|
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


module i2cs_serial (
                 porb,
                 sys_clk,
//                 rst,         //modified by ls
                 scl_tmp,
                 sdaclkin_tmp,
                 sdain,
                 sdaout,
//                 devAddr,
                 devAddr0,    //add by ls
                 devAddr1,

//                 regAddr,
//                 data,
                 regAddr_o,   //add by ls
                 data_i,
                 data_o,
                 data_oe,

                 wrStrobe,
                 wrStrobe_st,
                 rdStrobe,
                 rdClk,
                 scanMode
                 );

input              porb;
input              sys_clk;
//input              rst;         //modified by ls
input              scl_tmp;
input              sdain;
input              sdaclkin_tmp;
input              scanMode;
output             sdaout;
//input     [6:0]    devAddr;
input     [6:0]    devAddr0;
input     [6:0]    devAddr1;

//output    [7:0]    regAddr;   //modified by ls
output    [8:0]    regAddr_o;

//inout     [7:0]    data;      //modified by ls
input     [7:0]    data_i;
output    [7:0]    data_o;
output             data_oe;

output             wrStrobe;
output             wrStrobe_st;
output             rdStrobe;
output             rdClk;

reg                sdaout;
reg       [7:0]    dataReg;
reg       [7:0]    regAddr;
reg                rdStrobe_q;

//tri       [7:0]    data;      //modified by ls

wire               wrStrobe;
wire               rdStrobe;

reg       [3:0]    state;
reg       [2:0]    bitCount;

reg                stopFlag;
reg                startFlag;

reg                wrStrobe_st;
//reg                wrStrobe_mask;  //modified by ls
reg                rdStrobe_st;      //added by ls

reg                rab_addr_msb;     //added by ls
//assign             rab_addr_msb = (dataReg[6:0]==devAddr0) ? 1'b0 : 1'b1;
assign             regAddr_o = {rab_addr_msb,regAddr};


wire               stateReset;
wire               startStopReset;
wire               startFlagReset;
wire               stopReset;

wire               scl_as_data;
wire               scl_neg;

wire               sdaClkIn_neg;

//add by tangxl on 2010/01/28
wire scl, sdaclkin;

parameter
// override this parameter to set the max address
MAX_ADDR = 8'hFF,
// state vectors
IDLE = 0,
READ_DEVID = 1,
GET_SUBADDR = 2,
WRITE_LOOP = 3,
READ_LOOP = 4,
CHECK_ACK = 5,
SEND_ACK1 = 6,
SEND_ACK2 = 7,
SEND_ACK3 = 8,
SEND_ACK4 = 9;
/*
// state machine resets on porb=0 OR stopFlag=1
//assign stateReset = scanMode ? !porb : (!porb | stopFlag) & !startFlag;
wire   temp_porb  = (!porb | stopFlag) & !startFlag;
//wire   temp_porb  = (rst | stopFlag) & !startFlag; 
//MX2X4 scan_stateReset ( .A(temp_porb), .B(!porb), .S0(scanMode), .Y(stateReset) );
assign stateReset = scanMode ? !porb : temp_porb;
//assign stateReset = scanMode ? rst : temp_porb;

// bypass startflag during scan mode
assign startFlagReset = scanMode ? 1'b0 : startFlag;

// rdStrobe is active during the first half of the
// first cycle of the READ_LOOP state
// assign rdStrobe = ((state[3:0] == SEND_ACK4) || (state[3:0] == CHECK_ACK)); //modified by ls


// wrStrobe is active during SEND_ACK3
//assign wrStrobe = wrStrobe_st && ~wrStrobe_mask;
assign wrStrobe = wrStrobe_st; //modified by ls

// data bus is driven during wrStrobe
// (receiver should clock data in on negetive edge)
//assign data[7:0] = (state[3:0] == SEND_ACK3) ? dataReg[7:0] : 8'bzzzzzzzz;
assign data_oe      = (state[3:0] == SEND_ACK3); //modified by ls
assign data_o[7:0]  = dataReg[7:0];


// reset start/stop detectors on scl low or porb
assign startStopReset = scanMode ? !porb : !scl | !porb;
//assign startStopReset = scanMode ? rst : !scl | rst;


// reset stop flag also when start flag goes high
assign stopReset = scanMode ? !porb : !scl | !porb | startFlag;
//assign stopReset = scanMode ? rst : !scl | rst | startFlag;

// don't use scl as data in scan mode
assign scl_as_data = scanMode ? 1'b0 : scl;

// use only posedge in scan mode
assign scl_neg = scanMode ^ scl;
assign sdaClkIn_neg = scanMode ^ sdaclkin;
*/

//modify by tangxl on 2010/01/28
// state machine resets on porb=0 OR stopFlag=1
//assign stateReset = scanMode ? !porb : (!porb | stopFlag) & !startFlag;
wire   temp_porb  = (!porb | stopFlag) & !startFlag;
//wire   temp_porb  = (rst | stopFlag) & !startFlag; 
//MX2X4 scan_stateReset ( .A(temp_porb), .B(!porb), .S0(scanMode), .Y(stateReset) );
assign stateReset = scanMode ? !porb : temp_porb;
//assign stateReset = scanMode ? rst : temp_porb;

// bypass startflag during scan mode
assign startFlagReset = scanMode ? 1'b0 : startFlag;

// rdStrobe is active during the first half of the
// first cycle of the READ_LOOP state
// assign rdStrobe = ((state[3:0] == SEND_ACK4) || (state[3:0] == CHECK_ACK)); //modified by ls


// wrStrobe is active during SEND_ACK3
//assign wrStrobe = wrStrobe_st && ~wrStrobe_mask;
assign wrStrobe = wrStrobe_st; //modified by ls

// data bus is driven during wrStrobe
// (receiver should clock data in on negetive edge)
//assign data[7:0] = (state[3:0] == SEND_ACK3) ? dataReg[7:0] : 8'bzzzzzzzz;
assign data_oe      = (state[3:0] == SEND_ACK3); //modified by ls
assign data_o[7:0]  = dataReg[7:0];


// reset start/stop detectors on scl low or porb
assign startStopReset = scanMode ? !porb : !scl | !porb;
//assign startStopReset = scanMode ? rst : !scl | rst;


// reset stop flag also when start flag goes high
assign stopReset = scanMode ? !porb : !scl | !porb | startFlag;
//assign stopReset = scanMode ? rst : !scl | rst | startFlag;

// don't use scl as data in scan mode
assign scl_as_data = scanMode ? 1'b0 : scl;

// use only posedge in scan mode
assign scl = scanMode ? sys_clk : scl_tmp;
assign sdaclkin = scanMode ? sys_clk : sdaclkin_tmp;
assign scl_neg = scanMode ^ scl;
assign sdaClkIn_neg = scanMode ^ sdaclkin;


always@(posedge sdaclkin or posedge stopReset)
begin
    if (stopReset)
        stopFlag <= #1 1'b0;
    else
        stopFlag <= #1 scl_as_data;
end


always@(negedge sdaClkIn_neg or posedge startStopReset)
begin
    if (startStopReset)
        startFlag <= #1 1'b0;
    else
        startFlag <= #1 scl_as_data;
end

// State machine:  This logic controls state transitions
// and reading and writing to the external data port
always@(posedge scl or posedge startFlagReset or posedge stateReset)
begin
    if (startFlagReset)
        begin
            bitCount[2:0]  <= #1 3'd0;
            state[3:0]     <= #1 READ_DEVID;
            wrStrobe_st    <= #1 1'b0;
        end
    else if (stateReset)
        begin
            // bit count always reset to 0
            bitCount[2:0]  <= #1 3'd0;

            // two reset conditions for state vector
            state[3:0]     <= #1 IDLE;

            // if reset thea clear reg address
            //regAddr[7:0]   <= #1 8'd0;   //modified by ls

            dataReg[7:0]   <= #1 8'd0;
            wrStrobe_st    <= #1 1'b0;
            rab_addr_msb   <= #1 1'b0;     //add by ls
        end
    else
        begin
            case (state[3:0])
            IDLE:
            begin
                state[3:0]      <= #1 IDLE; // start reset to next state
                //regAddr[7:0]    <= #1 8'd0;  //modified by ls
                bitCount[2:0]   <= #1 3'd0;
            end
            READ_DEVID:
            begin
                dataReg[7:0]    <= #1 {dataReg[6:0], sdain};
                if (bitCount[2:0] == 3'd7)
                    begin
//                        if (dataReg[6:0] == devAddr[6:0])
                        if ((dataReg[6:0] == devAddr0[6:0]) || (dataReg[6:0] == devAddr1[6:0])) //modified by ls
                           begin
                               if(dataReg[6:0]==devAddr0)    //add by ls
                                   rab_addr_msb <= 1'b0;
                               else
                                   rab_addr_msb <= 1'b1;

                               state[3:0] <= #1 sdain ? SEND_ACK4 : SEND_ACK1;
                           end
                        else
                           state[3:0] <= #1 IDLE;
                        bitCount[2:0] <= #1 3'd0;
                    end
                else
                    bitCount[2:0] <= #1 bitCount[2:0] + 1'b1;
            end
            SEND_ACK1:
            begin
                state[3:0]    <= #1 GET_SUBADDR;
                bitCount[2:0] <= #1 3'd0;
            end
            GET_SUBADDR:
            begin
                dataReg[7:0]  <= #1 {dataReg[6:0], sdain};
                if (bitCount[2:0] == 3'd7)
                    begin
                        if ({dataReg[6:0],sdain} <= MAX_ADDR)
                            state[3:0] <= #1 SEND_ACK2;
                        else
                            state[3:0] <= #1 IDLE;
                        bitCount[2:0] <= #1 3'd0;
                        regAddr[7:0]  <= #1 {dataReg[6:0],sdain};
                    end
                else
                    bitCount[2:0] <= #1 bitCount[2:0] + 1'b1;
            end
            SEND_ACK2:
            begin
                state[3:0]    <= #1 WRITE_LOOP;
                bitCount[2:0] <= #1 3'd0;
            end
            WRITE_LOOP:
            begin
                dataReg[7:0] <= #1 {dataReg[6:0], sdain};
                if (bitCount[2:0] == 3'd7)
                    begin
                        state[3:0]    <= #1 SEND_ACK3;
                        wrStrobe_st   <= #1 1'b1;
                        bitCount[2:0] <= #1 3'd0;
                    end
                else
                    bitCount[2:0] <= #1 bitCount[2:0] + 1'b1;
            end
            SEND_ACK3:
            begin
                state[3:0]    <= #1 WRITE_LOOP;
                wrStrobe_st   <= #1 1'b0;
                bitCount[2:0] <= #1 3'd0;
                regAddr[7:0]  <= #1 regAddr[7:0] + 1'b1;
            end
            SEND_ACK4:
            begin
                state[3:0]    <= #1 READ_LOOP;
                bitCount[2:0] <= #1 3'd0;
//                dataReg[7:0]  <= #1 data[7:0];
                dataReg[7:0]  <= #1 data_i[7:0];  //modified by ls
            end
            READ_LOOP:
            begin
                dataReg[7:0] <= #1 {dataReg[6:0], 1'b0};
                if (bitCount[2:0] == 3'd7)
                    begin
                        state[3:0]    <= #1 CHECK_ACK;
                        bitCount[2:0] <= #1 3'd0;
                    end
                else
                    bitCount[2:0] <= #1 bitCount[2:0] + 1'b1;
                if (bitCount[2:0] == 3'd0)
                    regAddr[7:0] <= #1 regAddr[7:0] + 1'b1;
            end
            CHECK_ACK:
            begin
                if (sdain)
                    state[3:0] <= #1 IDLE;
                else
                    state[3:0] <= #1 READ_LOOP;
                bitCount[2:0] <= #1 3'd0;
//                dataReg[7:0]  <= #1 data[7:0];
                dataReg[7:0]  <= #1 data_i[7:0];  //modified by ls
            end
            default: state[3:0] <= #1 IDLE;
            endcase
        end
end


// SDA out logic: This always block controls sdaout transitions based on
// the current state.
always@(negedge scl_neg or posedge stateReset)
begin
    if (stateReset)
        begin
            sdaout        <= #1 1'b1; // 1 = inactive since sdaout uses open drain
//            wrStrobe_mask <= #1 1'b0; //modified by ls
            rdStrobe_q    <= #1 1'b0;
        end
    else
        begin
            // use mask to clip wrStrobe on falling edge scl, deleted by ls
//            if (state[3:0] == SEND_ACK3)
//                wrStrobe_mask <= 1'b1;
//            else
//                wrStrobe_mask <= 1'b0;

            //Generate rdClk
            rdStrobe_q <= #1 rdStrobe;
            // set SDA out based on state.
            // set to 1 for disable
            case (state[3:0])
            IDLE        : sdaout <= #1 1'b1;
            READ_DEVID  : sdaout <= #1 1'b1;
            SEND_ACK1   : sdaout <= #1 1'b0;
            GET_SUBADDR : sdaout <= #1 1'b1;
            SEND_ACK2   : sdaout <= #1 1'b0;
            WRITE_LOOP  : sdaout <= #1 1'b1;
            SEND_ACK3   : sdaout <= #1 1'b0;
            SEND_ACK4   : sdaout <= #1 1'b0;
            READ_LOOP   : sdaout <= #1 dataReg[7];
            CHECK_ACK   : sdaout <= #1 1'b1;
            default     : sdaout <= #1 1'b1;
            endcase
        end
end

assign rdClk = rdStrobe_q || (!rdStrobe);

//rd register output, add by ls
assign rdStrobe = rdStrobe_st; 

always@(posedge scl or posedge startFlagReset or posedge stateReset)
begin
    if (startFlagReset)
        begin
            rdStrobe_st <= #1 1'b0;
        end
    else if (stateReset)
        begin
            rdStrobe_st <= #1 1'b0;
        end
    else
        begin
            case(state[3:0])
            READ_DEVID:
            begin
                if (bitCount[2:0] == 3'd7)
                    begin
                        if ((dataReg[6:0] == devAddr0[6:0]) || (dataReg[6:0] == devAddr1[6:0]))
                            begin
                                rdStrobe_st <= #1 sdain ? 1'b1: 1'b0;
                            end
                        else
                            begin
                                rdStrobe_st <= #1 1'b0;
                            end
                    end
                else
                    begin
                        rdStrobe_st <= #1 1'b0;
                    end
            end
            READ_LOOP:
            begin
                if (bitCount[2:0] == 3'd7)
                    begin
                        rdStrobe_st <= #1 1'b1;
                    end
                else
                    begin
                        rdStrobe_st <= #1 1'b0;
                    end
            end
            default:
            begin
                rdStrobe_st <= #1 1'b0;
            end
            endcase
        end
end

endmodule
