 
//+FHDR-------------------------------------------------------------------
// Copyright (c) 200p, HHIC
// HHIC Confidential Proprietary
//------------------------------------------------------------------------
// FILE NAME : hongqiao_global_parameters.v
// TYPE : global parameters file
// DEPARTMENT : MM
// AUTHOR : Chen Zhengyi
// AUTHOR¡¯S EMAIL : chenzhengyi@shhic.com
//------------------------------------------------------------------------
// Release history
// VERSION :  Date           :  AUTHOR        : DESCRIPTION
// 1.0     :  7 May 2009     :  chenzhengyi   : initial created
//------------------------------------------------------------------------
// PURPOSE : define all global parameters
//------------------------------------------------------------------------
// PARAMETERS
// PARAM NAME RANGE : DESCRIPTION : DEFAULT : VA UNITS
//  NA              : NA          : NA      : NA
//------------------------------------------------------------------------
// REUSE ISSUES
// reset Strategy :   NA
// Clock Domains :    NA
// Critical Timing :  NA
// Test Features :    NA
// Asynchronous I/F : NA
// Scan Methodology : NA
// Instantiations :   NA
// Other : !!Always use parameters has been defined in this file!!
//-FHDR-------------------------------------------------------------------


parameter RAB_ADDR_WIDTH    = 9;      //define the module address bus width
parameter RAB_DATA_WIDTH    = 8;      //define the module data bus width

`define   F                   1'b0
`define   T                   1'b1
`define   ON                  1'b1
`define   OFF                 1'b0

