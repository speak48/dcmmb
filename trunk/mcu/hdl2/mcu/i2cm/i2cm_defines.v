//+FHDR------------------------------------------------------------------- 
// Copyright (c) 2007, HHIC
// HHIC Confidential Proprietary 
//------------------------------------------------------------------------ 
// FILE NAME : i2cm_defines
// TYPE : module 
// DEPARTMENT : design 
// AUTHOR : Shuang Li
// AUTHOR'S EMAIL : lishuang@shhic.com
//------------------------------------------------------------------------ 
// Release history 
// VERSION Date AUTHOR DESCRIPTION 
// 1.0 27 Feb. 09 name lishuang 
//------------------------------------------------------------------------ 
// PURPOSE : parameters for i2c master. 
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

//the address parameters of I2C master registers
parameter     RAB_ADDR_WIDTH          = 9     ;
//parameter     I2CM_BASEADDR           = 4'h0  ;

//address of I2C master registers                                       
parameter     I2CM_DEVICE_ID_SEG      = 4'h0  ;
parameter     I2CM_OFFSET             = 4'h1  ;
parameter     I2CM_LEN_LSB            = 4'h2  ;
parameter     I2CM_LEN_MSB            = 4'h3  ;
parameter     I2CM_CTRL               = 4'h4  ;
parameter     I2CM_DATA_WR            = 4'h5  ;
parameter     I2CM_DATA_RD            = 4'h6  ;
parameter     I2CM_FIFO_DEPTH         = 4'h7  ;
parameter     I2CM_FIFO_CLR           = 4'h8  ;
parameter     I2CM_TIMING_PARA_LSB    = 4'h9  ;
parameter     I2CM_TIMING_PARA_MSB    = 4'ha  ;
parameter     I2CM_STATE              = 4'hb  ;
parameter     I2CM_DEBUG_BYTE         = 4'hc  ;


//command decoder. the order from byte ctrl to bit ctrl
parameter     I2CM_CMD_IDLE           = 3'h0  ;
parameter     I2CM_CMD_START          = 3'h1  ;
parameter     I2CM_CMD_STOP           = 3'h2  ;
parameter     I2CM_CMD_WRITE          = 3'h3  ;
parameter     I2CM_CMD_READ           = 3'h4  ;

// types
parameter       CUR_READ            = 3'h0;     //current read
parameter       SEQ_READ            = 3'h1;     //sequential read
parameter       EDID_READ           = 3'h2;     //EDID read
parameter       SEQ_WRITE           = 3'h3;     //sequential write
parameter       BKSV_READ           = 3'h4;     //BKSV list read

