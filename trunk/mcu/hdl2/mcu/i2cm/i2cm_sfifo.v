//+FHDR-------------------------------------------------------------------
// Copyright (c) 2007, HHIC
// HHIC Confidential Proprietary
//------------------------------------------------------------------------
// FILE NAME : i2cm_sfifo
// TYPE : module
// DEPARTMENT : design
// AUTHOR : Shuang Li
// AUTHOR'S EMAIL : lishuang@shhic.com
//------------------------------------------------------------------------
// Release history
// VERSION Date AUTHOR DESCRIPTION
// 1.0 27 Feb. 09 name lishuang
//------------------------------------------------------------------------
// PURPOSE : store data temprately
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



module i2cm_sfifo(
                //inputs
                sys_clk  ,
                sys_rst  ,
                en       ,
                push     ,
                pop      ,
                data_i   ,
                //outputs
                data_o   ,
                word_cnt ,
                free_cnt ,
                full     ,
                empty    ,
                overflow ,
                underflow
                );

parameter  ADDR_WIDTH = 3 ;                  //address width = log2(data_depth)
parameter  DATA_WIDTH = 8 ;                  //data width
parameter  DATA_DEPTH = 8 ;                  //data depth


//inputs
input                       sys_clk   ;      //system clock
input                       sys_rst   ;      //asyn reset
input                       en        ;      //enable or software reset
input                       push      ;      //push data to fifo
input                       pop       ;      //pop data from fifo
input    [DATA_WIDTH-1:0]   data_i    ;      //data in
//outputs
output   [DATA_WIDTH-1:0]   data_o    ;      //data out
output   [ADDR_WIDTH  :0]   word_cnt  ;      //data number in fifo
output   [ADDR_WIDTH  :0]   free_cnt  ;      //free spaces in fifo
output                      full      ;      //full flag of fifo
output                      empty     ;      //empty flag of fifo
output                      overflow  ;      //overflow flag of fifo
output                      underflow ;      //underflow flag of fifo


////////// real F/F //////////////////
//port type declaration
reg      [ADDR_WIDTH  :0]   word_cnt  ;
//internal register declaration
reg      [ADDR_WIDTH-1:0]   wp        ;      //write pointer
reg      [ADDR_WIDTH-1:0]   rp        ;      //read  pointer

///////// combination logic //////////
//internal wire declaration
reg                         wr        ;      //write enable
reg                         rd        ;      //read enable
reg                         overflow  ;
reg                         underflow ;


assign   full = ~(| free_cnt)            ;      //full while no free space
assign   empty= ~(| word_cnt)            ;      //empty while no data in fifo
assign   free_cnt = DATA_DEPTH - word_cnt;      //free space=total spaces - data number

//write enable
  always @(push or pop or full)
      if(~full)
        if(push)         //write enable while 1)push and fifo is not full
            wr = 1'b1;
        else
            wr = 1'b0;
      else
        if(pop & push)   //write enable while 2)fifo is full but push and pop in the same time
          wr = 1'b1;
        else
          wr = 1'b0;


//read enable
  always @(empty or pop) begin
     if((~empty)&(pop))  //read eanble while pop and fifo is not empty
        rd = 1'b1;
     else
        rd = 1'b0;
  end

//overflow
  always @(full or pop or push)
     if(full)          //overflow: push (but don't pop at same time) while fifo is full
        if(push &(~pop))
            overflow = 1'b1;
        else
            overflow = 1'b0;
     else
        overflow = 1'b0;

//underflow
  always @(empty or pop) //underflow while pop and fifo is empty
    if(empty & pop)
        underflow = 1'b1;
    else
        underflow = 1'b0;


///////////////////// register description /////////////////////////////
reg [DATA_WIDTH-1: 0]   mem [DATA_DEPTH-1:0];
integer m;
  always @(posedge sys_clk or posedge sys_rst)
    if(sys_rst)
        for(m=0;m<DATA_DEPTH;m=m+1)
            mem[m] <= {DATA_WIDTH {1'b0}};
    else if(wr)
        mem[wp] <= data_i;        //put data to registers



/////////////////// control logic description  //////////////////////////////
//write pointer
  always @(posedge sys_clk or posedge sys_rst)
     if(sys_rst)
        wp <= {ADDR_WIDTH{1'b0}} ;
     else if(!en)
        wp <= {ADDR_WIDTH{1'b0}} ;
     else if(wr)                             //while write enable
        wp <= wp + 1'b1 ;

//read pointer
  always @(posedge sys_clk or posedge sys_rst)
     if(sys_rst)
        rp <= {ADDR_WIDTH{1'b0}} ;
     else if(!en)
        rp <= {ADDR_WIDTH{1'b0}} ;
     else if(rd)                             //while read enable
        rp <= rp + 1'b1 ;

//word counter
  always @(posedge sys_clk or posedge sys_rst)
     if(sys_rst)
        word_cnt <= {(ADDR_WIDTH+1){1'b0}} ;
     else if(!en)
        word_cnt <= {(ADDR_WIDTH+1){1'b0}} ;
     else
        case({wr,rd})
            2'b01 : word_cnt <= word_cnt - 1'b1;     //data number-1 while read enable
            2'b10 : word_cnt <= word_cnt + 1'b1;     //data number+1 while write enable
            default:word_cnt <= word_cnt       ;     //data number won't change while neither read nor write;
                                                     //data number won't change while read and write at same time
        endcase

//data output
assign data_o = mem[rp];

endmodule
