/****************************************************************************************

  NAND256R3A Parameters Definitions

  256Mbits (x8, 2048 Blocks, 32 Pages, 528 Bytes) 1.8V NAND Flash Memory

  Copyright (c) 2004 STMicroelectronics

*****************************************************************************************

  Model Version : 1.0

  Author : Xue-Feng Hu

*****************************************************************************************

  Model Version History:
-----------------------------------------------------------------------------------------
  1.0: Oct. 2004  First Version Release.

****************************************************************************************/

//=========================================================
// Definition regarding AC Specification
//=========================================================
`define tDVWH             20
`define tELWL              0
`define tWHDX             10
`define tWHEH             10
`define tWHWL             20
`define tWLWH             40
`define tWLWL             60
`define tALLWL             0
`define tALHWL             0
`define tCLHWL             0
`define tCLLWL             0
`define tWHALL            10
`define tWHALH            10
`define tWHCLL            10
`define tWHCLH            10
//---------------------------------------------------------
`define tEHEL             100
`define tRHRL             15
`define tRLRH             30
`define tRLRL             60
`define tWHRL             80
`define tALLRL            10
`define tCLLRL            10
//---------------------------------------------------------
`define tR                15e3
`define tWB               100 
`define tRB               100
`define tBERS             3e6
`define tRHZ              30
`define tREA              35
`define tCEA              45
`define tCHZ              20
`define tCRY              60
`define tBLBH1            10e3
`define tRESET            5e3
`define tPROG             500e3
//---------------------------------------------------------
`define tRESET_RY         5e3
`define tRESET_RD         5e3
`define tRESET_PG         10e3
`define tRESET_ER         500e3
//---------------------------------------------------------

//=======================================================================================
// Difinitions regarding size of memory
//=======================================================================================
// "BLK_BIT" is width of bits for blk address in a chip, 2048 blocks,11 bits
// "PAG_BIT" is width of bits for page address in block, 32 pages,5 bits
// "COL_BIT" is width of bits for column address in page, 528 bytes,10 bits
// "ADD_COL" is width of bits for main area column address in page, 512 bytes,9 bits
//---------------------------------------------------------------------------------------
`define CHP_BIT           26      // width of bits for whole chip address
`define ADD_BIT           25      // width of bits for the required input address
//---------------------------------------------------------------------------------------
`define BLK_BIT           11      // width of bits for block address
`define PAG_BIT           5       // width of bits for page address
`define COL_BIT           10      // width of bits for column address
`define ADD_COL           9       // width of bits for column address in main area
//---------------------------------------------------------------------------------------
`define BLK_IN_MEMORY     2048    // number of blocks in whole memory
`define COL_IN_PAGE       528     // number of bytes in every page
`define PAGE_IN_BLOCK     32      // number of pages in every block

//=======================================================================================
// Parameters regarding memory feature
//=======================================================================================
`define D_WIDTH           8       // width of data bus
`define AREA_BIT_A        8       // width of bits for address in area-a
`define AREA_BIT_B        8       // width of bits for address in area-b
`define AREA_BIT_C        4       // width of bits for address in area-c
//---------------------------------------------------------------------------------------
`define AREA_SIZ_A        256     // number of column in area-a/page
`define AREA_SIZ_B        256     // number of column in area-b/page
`define AREA_SIZ_C        16      // number of column in area-c/page
//---------------------------------------------------------------------------------------
`define ADD_CYCLES        3       // number of addr cycles is required to input
//---------------------------------------------------------------------------------------