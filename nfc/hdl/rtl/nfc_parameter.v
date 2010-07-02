// nfc_parameter.v

parameter SFR_WID = 8;
parameter DAT_WID = 16;
parameter ECC_DWID = 8;
parameter ECC_AWID = 13;
parameter PRE_CYCLE = 3'h1;

parameter     NFC_ECC_CTRL_OFFSET       = 6'h00;
parameter     NFC_IF_CMD_OFFSET         = 6'h10;
parameter     NFC_IF_CTRL0_OFFSET       = 6'h11;
parameter     NFC_IF_CTRL1_OFFSET       = 6'h12;
parameter     NFC_DATA_STATUS0_OFFSET   = 6'h13;
parameter     NFC_DATA_STATUS1_OFFSET   = 6'h14;
parameter     NFC_TIMING_CONFC_OFFSET   = 6'h15;
parameter     NFC_DATA_ADDR0_OFFSET     = 6'h16;
parameter     NFC_DATA_ADDR1_OFFSET     = 6'h17;
parameter     NFC_SPARE_ADDR0_OFFSET    = 6'h18;
parameter     NFC_SPARE_ADDR1_OFFSET    = 6'h19;
parameter     NFC_TRN_CNT0_OFFSET       = 6'h1a;
parameter     NFC_TRN_CNT1_OFFSET       = 6'h1b;
parameter     NFC_BLK_LEN0_OFFSET       = 6'h1c;
parameter     NFC_BLK_LEN1_OFFSET       = 6'h1d;
parameter     NFC_RED_LEN_OFFSET        = 6'h1e;
parameter     NFC_ADDR_CNT_OFFSET       = 6'h1f;
parameter     NFC_COLUMN_ADDR0_OFFSET   = 6'h20;
parameter     NFC_COLUMN_ADDR1_OFFSET   = 6'h21;
parameter     NFC_COLUMN_ADDR2_OFFSET   = 6'h22;
parameter     NFC_COLUMN_ADDR3_OFFSET   = 6'h23;
parameter     NFC_ROW_ADDR0_OFFSET      = 6'h24;
parameter     NFC_ROW_ADDR1_OFFSET      = 6'h25;
parameter     NFC_ROW_ADDR2_OFFSET      = 6'h26;
parameter     NFC_ROW_ADDR3_OFFSET      = 6'h27;
parameter     NFC_LOGIC_ADDR0_OFFSET    = 6'h28;
parameter     NFC_LOGIC_ADDR1_OFFSET    = 6'h29;
parameter     NFC_LOGIC_ADDR2_OFFSET    = 6'h2a;
parameter     NFC_PHY_ADDR0_OFFSET      = 6'h2b;
parameter     NFC_PHY_ADDR1_OFFSET      = 6'h2c;
parameter     NFC_PHY_ADDR2_OFFSET      = 6'h2d;
parameter     NFC_BIT0_LOC_OFFSET       = 6'h2e;
parameter     NFC_BIT1_LOC_OFFSET       = 6'h2f;
parameter     NFC_BIT2_LOC_OFFSET       = 6'h30;
parameter     NFC_BIT_STATUS_OFFSET     = 6'h31;
parameter     NFC_RAND_SEED0_OFFSET     = 6'h32;
parameter     NFC_RAND_SEED1_OFFSET     = 6'h33;
parameter     NFC_RAND_SEED2_OFFSET     = 6'h34;
parameter     NFC_RAND_SEED3_OFFSET     = 6'h35;

parameter     NFC_ECC_CFG0_OFFSET       = 6'h04;
parameter     NFC_ECC_CFG1_OFFSET       = 6'h05;
//parameter     NFC_ECC_CFG2_OFFSET       = 6'h06;
//parameter     NFC_ECC_CFG3_OFFSET       = 6'h07;

parameter     NFC_ECC_STA0_OFFSET       = 6'h08;
//parameter     NFC_ECC_STA1_OFFSET       = 6'h09;
//parameter     NFC_ECC_STA2_OFFSET       = 6'h0A;
//parameter     NFC_ECC_STA3_OFFSET       = 6'h0B;
