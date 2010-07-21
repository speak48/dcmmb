//+FHDR------------------------------------------------------------------- 
// Copyright (c) 2007, HHIC
// HHIC Confidential Proprietary 
//------------------------------------------------------------------------ 
// FILE NAME : i2cm_top
// TYPE : module 
// DEPARTMENT : design 
// AUTHOR : Shuang Li
// AUTHOR'S EMAIL : lishuang@shhic.com
//------------------------------------------------------------------------ 
// Release history 
// VERSION Date AUTHOR DESCRIPTION 
// 1.0 27 Feb. 09 name lishuang 
//------------------------------------------------------------------------ 
// PURPOSE : top module of i2c master 
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

module  i2cm_top(
        //inputs
        sys_clk         ,   
        sys_rst         ,
        baseaddr        ,
        rab_write       ,   
        rab_read        ,
        rab_addr        ,
        rab_wdata       ,
        io_scl_in       ,   
        io_sda_in       ,
        //outputs
        io_scl_out      ,
        io_sda_out      ,
        io_scl_oe       ,
        io_sda_oe       ,
        i2cm_rdata      ,
        i2cm_ack        ,
        rfifo_wordcnt
);

`include "i2cm_defines.v"

parameter  ADDR_WIDTH = 3 ;
parameter  DATA_WIDTH = 8 ;
parameter  DATA_DEPTH = 8 ;

//inputs
input           sys_clk         ;
input           sys_rst         ;
input   [ 4: 0] baseaddr        ;   
input           rab_write       ;
input           rab_read        ;
input   [ 8: 0] rab_addr        ;
input   [ 7: 0] rab_wdata       ;
input           io_scl_in       ;
input           io_sda_in       ;
//outputs
output          io_scl_out      ;
output          io_sda_out      ;
output          io_scl_oe       ;
output          io_sda_oe       ;
output  [ 7: 0] i2cm_rdata      ;
output          i2cm_ack        ;
output  [ ADDR_WIDTH:0] rfifo_wordcnt;

// internal wire description

// regfile
wire    [ 7: 0] device_id_seg   ;
wire    [ 7: 0] offset          ;
wire    [ 9: 0] data_len        ;
wire            i2cm_en         ;
wire            start           ;
wire    [ 2: 0] trans_type      ;
wire    [ 9: 0] timing_para     ;
wire            opendrain       ;
wire    [ 3: 0] byte_fsm_status ;
//wire    [ 4: 0] bit_fsm_status  ;
wire            slave_waiting   ;
wire            sto_condition   ;


// tfifo/rfifo
wire            tfifo_en            ;
wire            rfifo_en            ;
wire            tfifo_push          ;
wire            rfifo_pop           ;
wire    [ 7: 0] tfifo_data_from_reg ;
wire    [ 7: 0] rfifo_data_to_reg   ;
wire            rfifo_empty         ;
wire            tfifo_empty         ;
wire    [ 3: 0] tfifo_freecnt       ;
wire    [ ADDR_WIDTH: 0] rfifo_wordcnt       ;

wire            rfifo_full              ;
wire            tfifo_pop               ;
wire    [ 7: 0] tfifo_data_to_shift     ;
wire            rfifo_push              ;
wire    [ 7: 0] rfifo_data_from_shift   ;


// byte ctrl
wire            busy                ;

wire            tbit_to_bitctrl     ;
wire            rbit_from_bitctrl   ;
wire            fsm_using           ;
wire            non_ack             ;
wire    [ 2: 0] cmd_to_bitctrl      ;
wire            cmd_ack_from_bitctrl;



//registers          
i2cm_regfile           #(ADDR_WIDTH)
                       u1_regs(            
.sys_clk               ( sys_clk           ),
.sys_rst               ( sys_rst           ),
.baseaddr              ( baseaddr          ),
.i2cm_wr               ( rab_write         ),
.i2cm_rd               ( rab_read          ),
.rab_addr              ( rab_addr          ),
.i2cm_wdata            ( rab_wdata         ),
.rfifo_data_to_reg     ( rfifo_data_to_reg ),
.rfifo_empty           ( rfifo_empty       ),
.tfifo_empty           ( tfifo_empty       ),
.tfifo_freecnt         ( tfifo_freecnt     ),
.rfifo_wordcnt         ( rfifo_wordcnt     ),
//.busy                  ( busy              ),
.fsm_using             ( fsm_using         ), 
.byte_fsm_status       ( byte_fsm_status   ),
.slave_waiting         ( slave_waiting     ),
.non_ack               ( non_ack           ),
.tfifo_overflow        ( tfifo_overflow    ),
.rfifo_underflow       ( rfifo_underflow   ),
.sto_condition         ( sto_condition     ),
.i2cm_rdata            ( i2cm_rdata        ),
.i2cm_ack              ( i2cm_ack          ),
.tfifo_push            ( tfifo_push        ),
.rfifo_pop             ( rfifo_pop         ),
.tfifo_data_from_reg   ( tfifo_data_from_reg ),
.device_id_seg         ( device_id_seg     ),
.offset                ( offset            ),
.data_len              ( data_len          ),
.i2c_en                ( i2cm_en           ),
.start                 ( start             ),
.trans_type            ( trans_type        ),
.tfifo_en              ( tfifo_en          ),
.rfifo_en              ( rfifo_en          ),
.timing_para           ( timing_para       ),
.opendrain             ( opendrain         )
);




//tfifo
i2cm_sfifo      #(ADDR_WIDTH,
                  DATA_WIDTH,
                  DATA_DEPTH)
                u2_tfifo(
.sys_clk        ( sys_clk               ),
.sys_rst        ( sys_rst               ),
.en             ( tfifo_en              ),
.push           ( tfifo_push            ),
.pop            ( tfifo_pop             ),
.data_i         ( tfifo_data_from_reg   ),
.data_o         ( tfifo_data_to_shift   ),
.word_cnt       (                       ),
.free_cnt       ( tfifo_freecnt         ),
.full           (                       ),
.empty          ( tfifo_empty           ),
.overflow       ( tfifo_overflow        ),
.underflow      (                       )
 );


//rfifo
i2cm_sfifo      #(ADDR_WIDTH,
                  DATA_WIDTH,
                  DATA_DEPTH)
                u3_rfifo(
.sys_clk        ( sys_clk               ),
.sys_rst        ( sys_rst               ),
.en             ( rfifo_en              ),
.push           ( rfifo_push            ),
.pop            ( rfifo_pop             ),
.data_i         ( rfifo_data_from_shift ),
.data_o         ( rfifo_data_to_reg     ),
.word_cnt       ( rfifo_wordcnt         ),
.free_cnt       (                       ),
.full           ( rfifo_full            ),
.empty          ( rfifo_empty           ),
.overflow       (                       ),
.underflow      ( rfifo_underflow       )
 );


//byte control
i2cm_byte_ctrl  u4_byte_ctrl(
.sys_clk                ( sys_clk                   ),
.sys_rst                ( sys_rst                   ),
.en                     ( i2cm_en                   ),
.tfifo_empty            ( tfifo_empty               ),
.rfifo_full             ( rfifo_full                ),
.tfifo_pop              ( tfifo_pop                 ),
.tfifo_data_to_shift    ( tfifo_data_to_shift       ),
.rfifo_push             ( rfifo_push                ),
.rfifo_data_from_shift  ( rfifo_data_from_shift     ),
.tbit_to_bitctrl        ( tbit_to_bitctrl           ),
.rbit_from_bitctrl      ( rbit_from_bitctrl         ),
.cmd_to_bitctrl         ( cmd_to_bitctrl            ),
.cmd_ack_from_bitctrl   ( cmd_ack_from_bitctrl      ),
.bus_busy               ( busy                      ),
.start                  ( start                     ),
.trans_type             ( trans_type                ),
.device_id_seg          ( device_id_seg             ),
.addr_offset            ( offset                    ),
.data_len               ( data_len                  ),
.fsm_enable             ( fsm_using                 ),
.non_ack                ( non_ack                   ),
.c_state                ( byte_fsm_status           )
);



//bit control
i2cm_bit_ctrl   u5_bit_ctrl(
.sys_clk           ( sys_clk                ),
.sys_rst           ( sys_rst                ),
.en                ( i2cm_en                ),
.cmd               ( cmd_to_bitctrl         ),
.din               ( tbit_to_bitctrl        ),
.scl_i             ( io_scl_in              ),
.sda_i             ( io_sda_in              ),
.opendrain         ( opendrain              ),
.timing_para       ( timing_para            ),
.cmd_ack           ( cmd_ack_from_bitctrl   ),
.busy              ( busy                   ),
.dout              ( rbit_from_bitctrl      ),
.scl_o             ( io_scl_out             ),
.scl_oe            ( io_scl_oe              ),
.sda_o             ( io_sda_out             ),
.sda_oe            ( io_sda_oe              ),
//.bit_fsm_status    ( bit_fsm_status         ),
.hold_cnt          ( slave_waiting          ),
.sto_condition     ( sto_condition          )
);





endmodule
