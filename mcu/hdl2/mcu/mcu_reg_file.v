//------------------------------------------------------------------------
// Copyright (c) 2009, HHIC
// HHIC Confidential Proprietary
//------------------------------------------------------------------------
// FILE NAME :mcu_reg_file.v
// TYPE : module
// DEPARTMENT : Design
// AUTHOR :  Shuang Li
// AUTHOR    S EMAIL : lishuang@hhic.com
//------------------------------------------------------------------------
// Release history
// VERSION | Date     | AUTHOR       |  DESCRIPTION
// 0.1     | 09/4/15  | Shuang Li    |
//------------------------------------------------------------------------
// PURPOSE :
//------------------------------------------------------------------------
// PARAMETERS
// PARAM NAME RANGE : DESCRIPTION : DEFAULT : VA UNITS
// N.A.
//------------------------------------------------------------------------
// REUSE ISSUES : N.A.
// sys_rst Strategy : N.A.
// Clock Domains : N.A.
// Critical Timing : N.A.
// Test Features : N.A.
// Asynchronous I/F : N.A.
// Scan Methodology : N.A.
// Instantiations : N.A.
//
//------------------------------------------------------------------------

module mcu_reg_file(
            sys_clk,
            sys_rst,
            chip_version,

            io_int_oe,
            io_int_out,

            io_hpd,
            phy_rx_sense,

            vdc_int_event,
            frm_vs_event,
            vsync_int_event,
            adc_int_status,
            ddc_rfifo_depth,
            rab_write,
            rab_read,
            rab_addr,
            rab_wdata,

            rab_ack,
            rab_rdata,

            mcu_sys_clk_n_valid,
            mcu_sys_clk_divider,
            mcu_vid_clk_gate,
            mcu_tmds_clk_gate,
            mcu_au_clk_gate,

            vdc_reset,
            vdp_reset,
            adc_reset,
            dpg_reset,
            frm_reset,
            ciph_reset,
            tenc_reset,
            r80515_reset,

            vdc_ack,
            vdc_rdata,
            vdp_ack,
            vdp_rdata,
            adc_ack,
            adc_rdata,
            dpg_ack,
            dpg_rdata,
            frm_ack,
            frm_rdata,
            ciph_ack,
            ciph_rdata,
            tenc_ack,
            tenc_rdata,
            ddc_ack,
            ddc_rdata,
            key_ack,
            key_rdata,
            add_on_ack,
            add_on_rdata,
            
            test_sel,
            test_module_sel,
            
            ex0,
            
            pllclk_ratio_set,
            mcu_sel_250m,
            
            prog_mode,
            ram_mode,
            
            ana_all_on

          );

///////////////////////////////////////////////////////////////////////////////
// parameters
///////////////////////////////////////////////////////////////////////////////
`include "binhai_global_parameters.v"

///////////////////////////////////////////////////////////////////////////////
// MCU address definition
///////////////////////////////////////////////////////////////////////////////
parameter VENDOR_ID0_ADDR    = 9'h000;
parameter VENDOR_ID1_ADDR    = 9'h001;
parameter POWER_CTRL_ADDR    = 9'h002;
parameter CHIP_VERSION_ADDR  = 9'h003;
parameter CKG_CTRL0_ADDR     = 9'h005;
parameter CKG_CTRL1_ADDR     = 9'h006;
parameter MCU_SW_RESET_ADDR  = 9'h007;
parameter DDC_FREQ_ADDR      = 9'h008;
parameter MCU_INT_CTL_ADDR   = 9'h009;
parameter MCU_INT_STATE_ADDR = 9'h00a;
parameter MCU_INT_STATUS_ADDR= 9'h00b;
parameter MCU_INT_EN_ADDR    = 9'h00c;
parameter MCU_TEST_MUX_ADDR  = 9'h00d; 
parameter MCU_EX0_INT_EN_ADDR= 9'h00e;
parameter MCU_EX0_INT_STATUS_ADDR = 9'h00f;
parameter PHY_PLLCLK_SET_ADDR= 9'h010;
parameter PROG_RAM_SEL_ADDR  = 9'h011;
parameter ANA_ALL_ON_ADDR    = 9'h012;

//parameter MCU_INV_ADDR_1     = 9'h003;
//parameter MCU_INV_ADDR_1     = 9'h004;


///////////////////////////////////////////////////////////////////////////////
// MCU register bit definition
///////////////////////////////////////////////////////////////////////////////

// CKG_CTR0 bit definition
parameter CK_RPT_LSB        = 0;
parameter CK_RPT_MSB        = 1;
parameter PLL_MUL_LSB       = 2;
parameter PLL_MUL_MSB       = 3;

// CKG_CTRL1 bit definition
parameter SYS_CLK_N_LSB     = 0;
parameter SYS_CLK_N_MSB     = 2;
parameter VID_CLK_GATE_BP   = 4;
parameter TMDS_CLK_GATE_BP  = 5;
parameter AU_CLK_GATE_BP    = 6;

// PD_MODE bit definition
parameter PD_MODE_LSB       = 0;
parameter PD_MODE_MSB       = 1;

// MCU_SW_RESET bit definition
parameter VDC_RST_BP        = 0;
parameter VDP_RST_BP        = 1;
parameter ADC_RST_BP        = 2;
parameter DPG_RST_BP        = 3;
parameter FRM_RST_BP        = 4;
parameter CIPH_RST_BP       = 5;
parameter TENC_RST_BP       = 6;
parameter R80515_RST_BP     = 7;

// DDC_FREQ bit definition
parameter DDC_FREQ_LSB      = 0;
parameter DDC_FREQ_MSB      = 1;

// MCU_INT_CTRL bit definition
parameter MCU_INT_OD_BP     = 0;
parameter MCU_INT_POL_BP    = 1;

// MCU_INT_STATE bit definition
parameter MCU_HPD_STATE_BP  = 0;
parameter MCU_RXSENSE_BP    = 1;

// MCU_INT_STATUS bit definition
parameter MCU_HPD_INT_BP    = 0;
parameter MCU_RXSENSE_INT_BP= 1;
parameter MCU_VS_INT_BP     = 2;
parameter MCU_VDC_INT_BP    = 3;
parameter MCU_ADC_INT_BP    = 4;

// MCU_INT_EN bit definition
parameter MCU_HPD_INT_EN_BP = 0;
parameter MCU_RXSENSE_INT_EN_BP = 1;
parameter MCU_VS_INT_EN_BP  = 2;
parameter MCU_VDC_INT_EN_BP = 3;
parameter MCU_ADC_INT_EN_BP = 4;

// MCU_TEST_MUX bit definition
parameter MCU_TMUX_SEL_LSB    = 0;
parameter MCU_TMUX_SEL_MSB    = 1;
parameter MCU_TMUX_MODULE_LSB = 4;
parameter MCU_TMUX_MODULE_MSB = 6;

// MCU_EXT_INT_EN bit definition
parameter DDC_FREQ_INT_EN_BP = 0;
parameter DDC_DATA_INT_EN_BP = 1;
parameter VSYNC_INT_EN_BP    = 2;
parameter PO_INT_EN_BP       = 3;
parameter PD_INT_EN_BP       = 4;
parameter HPD_EX0_INT_EN_BP  = 5;

// MCU_EXT_INT_STATUS bit definition
parameter DDC_FREQ_INT_STATUS_BP = 0;
parameter DDC_DATA_INT_STATUS_BP = 1;
parameter VSYNC_INT_STATUS_BP    = 2;
parameter PO_INT_STATUS_BP       = 3;
parameter PD_INT_STATUS_BP       = 4;
parameter HPD_EX0_INT_STATUS_BP  = 5;    

// PHY_PLLCLK_SET bit definition
parameter PLLCLK_RATIO_SET_LSB = 0;
parameter PLLCLK_RATIO_SET_MSB = 2;
parameter MCU_SEL_250M_BP      = 3;

//PROG_RAM_SEL bit definition
parameter PROG_MODE_BP         = 0;
parameter RAM_MODE_BP          = 1;

//ANA_ALL_ON bit definition
parameter ANA_ALL_BP           = 0;

///////////////////////////////////////////////////////////////////////////////
// Input and outputs
///////////////////////////////////////////////////////////////////////////////

input sys_clk;
input sys_rst;
input [7:0] chip_version;

//external interrupt
output io_int_oe;       //interrupt output enable, to IO
output io_int_out;      //interrupt output, to IO

//HPD and RXsense
input io_hpd;
input phy_rx_sense;

//interrrupt sources
input vdc_int_event;
input frm_vs_event;
input vsync_int_event;
input adc_int_status;
input [3:0] ddc_rfifo_depth;

//RAB bus signals
input rab_write;
input rab_read;
input [RAB_ADDR_WIDTH-1:0] rab_addr;
input [RAB_DATA_WIDTH-1:0] rab_wdata;

output rab_ack;
output [RAB_DATA_WIDTH-1:0] rab_rdata;

//module RAB bus acknowledge and read data
input vdc_ack;
input [RAB_DATA_WIDTH-1:0] vdc_rdata;
input vdp_ack;
input [RAB_DATA_WIDTH-1:0] vdp_rdata;
input adc_ack;
input [RAB_DATA_WIDTH-1:0] adc_rdata;
input dpg_ack;
input [RAB_DATA_WIDTH-1:0] dpg_rdata;
input frm_ack;
input [RAB_DATA_WIDTH-1:0] frm_rdata;
input ciph_ack;
input [RAB_DATA_WIDTH-1:0] ciph_rdata;
input tenc_ack;
input [RAB_DATA_WIDTH-1:0] tenc_rdata;
input ddc_ack;
input [RAB_DATA_WIDTH-1:0] ddc_rdata;
input key_ack;
input [RAB_DATA_WIDTH-1:0] key_rdata;
input add_on_ack;
input [RAB_DATA_WIDTH-1:0] add_on_rdata;


//CKG signals
output mcu_sys_clk_n_valid;
output [2:0] mcu_sys_clk_divider;
output mcu_vid_clk_gate;
output mcu_tmds_clk_gate;
output mcu_au_clk_gate;

//module software reset signals
output vdc_reset;
output vdp_reset;
output adc_reset;
output dpg_reset;
output frm_reset;
output ciph_reset;
output tenc_reset;
output r80515_reset;

//test mux select signals
output [1:0] test_sel;
output [2:0] test_module_sel;

//output to external interrupt 0
output ex0;

//output to PHY
output [2:0] pllclk_ratio_set;
output       mcu_sel_250m    ;

input ana_all_on;

//program RAM select signals
output       prog_mode;
output       ram_mode ;

///////////////////////////////////////////////////////////////////////////////
// Descriptions
///////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////
// Debounce of HPD
///////////////////////////////////////////////////////////////////////////////

//sample io_hpd 4 cycles to avoid meta-stability
reg [3:0] io_hpd_sample;
always @(posedge sys_clk or posedge sys_rst)
begin
  if(sys_rst)
  begin
    io_hpd_sample <= 4'b0;
  end
  else
  begin
    io_hpd_sample <= io_hpd_sample << 1;
    io_hpd_sample[0] <= io_hpd;
  end
end

//debounce of HPD
reg [3:0] io_hpd_d;
reg hpd_debounced;
always @(posedge sys_clk or posedge sys_rst)
begin
  if(sys_rst)
  begin
    io_hpd_d <= 4'b0;
    hpd_debounced <= 1'b0;
  end
  else
  begin
    io_hpd_d <= io_hpd_d << 1;
    io_hpd_d[0] <= io_hpd_sample[3];

    if( ( (&io_hpd_d) == 1'b1) && ( (|io_hpd_d) == 1'b1) )
    begin
      hpd_debounced <= 1'b1;
    end
    else if( ( (&io_hpd_d) == 1'b0) && ( (|io_hpd_d) == 1'b0) )
    begin
      hpd_debounced <= 1'b0;
    end
    //else keep old value
  end
end


///////////////////////////////////////////////////////////////////////////////
// Debounce of Rx sense
///////////////////////////////////////////////////////////////////////////////

//phy_rx_sense sample
reg [3:0] phy_rx_sense_sample;
always @(posedge sys_clk or posedge sys_rst)
begin
  if(sys_rst)
  begin
    phy_rx_sense_sample <= 4'b0;
  end
  else
  begin
    phy_rx_sense_sample <= phy_rx_sense_sample << 1;
    phy_rx_sense_sample[0] <= phy_rx_sense;
  end
end

//debounce of phy_rx_sense
reg [3:0] phy_rx_sense_d;
reg rx_sense_debounce;
always @(posedge sys_clk or posedge sys_rst)
begin
  if(sys_rst)
  begin
    phy_rx_sense_d <= 4'b0;
    rx_sense_debounce <= 1'b0;
  end
  else
  begin
    phy_rx_sense_d <= phy_rx_sense_d << 1;
    phy_rx_sense_d[0] <= phy_rx_sense_sample[3];

    if( ((&phy_rx_sense_d) == 1'b1) &&
        ((|phy_rx_sense_d) == 1'b1) )
    begin
      rx_sense_debounce <= 1'b1;
    end
    else if( ((&phy_rx_sense_d) == 1'b0) &&
             ((|phy_rx_sense_d) == 1'b0) )
    begin
      rx_sense_debounce <= 1'b0;
    end
    //else keep old value
  end
end


///////////////////////////////////////////////////////////////////////////////
// register access
///////////////////////////////////////////////////////////////////////////////
reg [2:0] mcu_sys_clk_divider;
reg mcu_vid_clk_gate;
reg mcu_tmds_clk_gate;
reg mcu_au_clk_gate;

reg vdc_reset;
reg vdp_reset;
reg adc_reset;
reg dpg_reset;
reg frm_reset;
reg ciph_reset;
reg tenc_reset;
reg r80515_reset;

reg int_od;
reg int_pol;
//reg hpd_change_int_event;
//reg rxsense_change_int_event;

reg hpd_int_status;
reg rxsense_int_status;
reg vs_int_status;
reg vdc_int_status;

reg hpd_int_en;
reg rxsense_int_en;
reg vs_int_en;
reg vdc_int_en;
reg adc_int_en;

reg [1:0] ddc_freq;


reg mcu_ack;
reg [RAB_DATA_WIDTH-1:0] mcu_rdata;

reg [1:0] test_sel;
reg [2:0] test_module_sel;

reg [1:0] pd_mode;

reg ddc_freq_int_en;
reg ddc_data_int_en;
reg vsync_int_en;
reg po_int_en;
reg pd_int_en;
reg hpd_ex0_int_en;

reg ddc_freq_int_status;
reg ddc_data_int_status;
reg vsync_int_status;
reg po_int_status;
reg pd_int_status;
reg hpd_ex0_int_status;

//reg analog_all_on;
reg mcu_sel_250m ;
reg [2:0] pllclk_ratio_set;

//program ram mode select
reg prog_mode;
reg ram_mode ;


//register write/read access

always @(posedge sys_clk or posedge sys_rst)
begin
  if(sys_rst)
  begin
    mcu_sys_clk_divider <= 3'd1;
    mcu_vid_clk_gate <= 1'b1;
    mcu_tmds_clk_gate <= 1'b1;
    mcu_au_clk_gate <= 1'b1;

    vdc_reset <= 1'b1;
    vdp_reset <= 1'b1;
    adc_reset <= 1'b1;
    dpg_reset <= 1'b1;
    frm_reset <= 1'b1;
    ciph_reset <= 1'b1;
    tenc_reset <= 1'b1;
    r80515_reset <= 1'b1;

    int_od <= 1'b0;
    int_pol <= 1'b0;
    
    hpd_int_en <=1'b0;
    rxsense_int_en <= 1'b0;
    vs_int_en <= 1'b0;
    vdc_int_en <= 1'b0;
    adc_int_en <= 1'b0;

    ddc_freq <= 2'b0;

    //mcu_ack <= 1'b0;
    mcu_rdata <= {RAB_DATA_WIDTH{1'b0}};
    
    test_sel <= 2'b0;
    test_module_sel <= 3'b0;
    
    pd_mode <= 2'b01;
    
    ddc_freq_int_en <= 1'b0;
    ddc_data_int_en <= 1'b0;
    vsync_int_en    <= 1'b0;
    po_int_en       <= 1'b0;
    pd_int_en       <= 1'b0;
    hpd_ex0_int_en      <= 1'b0;
    
    mcu_sel_250m    <= 1'b0;
    pllclk_ratio_set<= 3'b0;
    
    prog_mode       <= 1'b0;
    ram_mode        <= 1'b0;
  end
  else
  begin
    //mcu_ack <= 1'b0;
    mcu_rdata <= {RAB_DATA_WIDTH{1'b0}};
    //r80515_reset <= 1'b0; //auto clear //10.1.11 modified, not autoclear

    if(rab_write)
    begin
      case(rab_addr)

        CKG_CTRL0_ADDR:
        begin
          //mcu_ack <= 1'b1;
        end

        CKG_CTRL1_ADDR:
        begin
          //mcu_ack <= 1'b1;

          mcu_sys_clk_divider <= rab_wdata[SYS_CLK_N_MSB:SYS_CLK_N_LSB];
          mcu_vid_clk_gate <= rab_wdata[VID_CLK_GATE_BP];
          mcu_tmds_clk_gate <= rab_wdata[TMDS_CLK_GATE_BP];
          mcu_au_clk_gate <= rab_wdata[AU_CLK_GATE_BP];
        end
        
        POWER_CTRL_ADDR:
        begin
          //mcu_ack <= 1'b1;
          
          pd_mode <= rab_wdata[PD_MODE_MSB:PD_MODE_LSB];
        end
        

        MCU_SW_RESET_ADDR:
        begin
          //mcu_ack <= 1'b1;

          vdc_reset <= rab_wdata[VDC_RST_BP];
          vdp_reset <= rab_wdata[VDP_RST_BP];
          adc_reset <= rab_wdata[ADC_RST_BP];
          dpg_reset <= rab_wdata[DPG_RST_BP];
          frm_reset <= rab_wdata[FRM_RST_BP];
          ciph_reset <= rab_wdata[CIPH_RST_BP];
          tenc_reset <= rab_wdata[TENC_RST_BP];
          r80515_reset <= rab_wdata[R80515_RST_BP];
        end

        DDC_FREQ_ADDR:
        begin
          //mcu_ack <= 1'b1;

          ddc_freq <= rab_wdata[DDC_FREQ_MSB:DDC_FREQ_LSB];
        end

        MCU_INT_CTL_ADDR:
        begin
          //mcu_ack <= 1'b1;
          
          int_od  <= rab_wdata[MCU_INT_OD_BP];
          int_pol <= rab_wdata[MCU_INT_POL_BP];
        end

        MCU_INT_STATUS_ADDR:
        begin
          //mcu_ack <=1'b1;
        end

        MCU_INT_EN_ADDR:
        begin
          //mcu_ack <=1'b1;

          hpd_int_en <= rab_wdata[MCU_HPD_INT_EN_BP];
          rxsense_int_en <= rab_wdata[MCU_RXSENSE_INT_EN_BP];
          vs_int_en <= rab_wdata[MCU_VS_INT_EN_BP];
          vdc_int_en <= rab_wdata[MCU_VDC_INT_EN_BP];
          adc_int_en <=rab_wdata[MCU_ADC_INT_EN_BP];
        end
        
        MCU_TEST_MUX_ADDR:
        begin
          //mcu_ack <= 1'b1;
          
          test_sel <= rab_wdata[MCU_TMUX_SEL_MSB:MCU_TMUX_SEL_LSB];
          test_module_sel <= rab_wdata[MCU_TMUX_MODULE_MSB:MCU_TMUX_MODULE_LSB];
        end
        
        MCU_EX0_INT_EN_ADDR:
        begin
          //mcu_ack <= 1'b1;
          
          ddc_freq_int_en <= rab_wdata[DDC_FREQ_INT_EN_BP];
          ddc_data_int_en <= rab_wdata[DDC_DATA_INT_EN_BP];
          vsync_int_en    <= rab_wdata[VSYNC_INT_EN_BP];
          po_int_en       <= rab_wdata[PO_INT_EN_BP];
          pd_int_en       <= rab_wdata[PD_INT_EN_BP];
          hpd_ex0_int_en  <= rab_wdata[HPD_EX0_INT_EN_BP];
        end

        
        MCU_EX0_INT_STATUS_ADDR:
        begin
          //mcu_ack <= 1'b1;
        end
        
        PHY_PLLCLK_SET_ADDR:
        begin
          //mcu_ack <= 1'b1;
              
          pllclk_ratio_set <= rab_wdata[PLLCLK_RATIO_SET_MSB:PLLCLK_RATIO_SET_LSB];
          mcu_sel_250m     <= rab_wdata[MCU_SEL_250M_BP];
        end
        
        PROG_RAM_SEL_ADDR:
        begin
          //mcu_ack <= 1'b1;
          
          prog_mode <= rab_wdata[PROG_MODE_BP];
          ram_mode  <= rab_wdata[RAM_MODE_BP];
        end
                
//        MCU_INV_ADDR_1:
//        begin
          //mcu_ack <= 1'b1;
//        end
        
        default:
        begin
          //mcu_ack <= 1'b0;
        end
        
      endcase
    end//if(rab_write)

    if(rab_read)
    begin
      case(rab_addr)
        
        VENDOR_ID0_ADDR:
        begin
          //mcu_ack <= 1'b1;
          mcu_rdata <= 8'h72;
        end
        
        VENDOR_ID1_ADDR:
        begin
          //mcu_ack <= 1'b1;
          mcu_rdata <= 8'h72;
        end
        
        POWER_CTRL_ADDR:
        begin
          //mcu_ack <= 1'b1;
          
          mcu_rdata[PD_MODE_MSB:PD_MODE_LSB] <= pd_mode;
        end

        CKG_CTRL0_ADDR:
        begin
          //mcu_ack <= 1'b1;
        end

        CKG_CTRL1_ADDR:
        begin
          //mcu_ack <= 1'b1;

          mcu_rdata[SYS_CLK_N_MSB:SYS_CLK_N_LSB] <= mcu_sys_clk_divider;
          mcu_rdata[VID_CLK_GATE_BP] <= mcu_vid_clk_gate;
          mcu_rdata[TMDS_CLK_GATE_BP] <= mcu_tmds_clk_gate;
          mcu_rdata[AU_CLK_GATE_BP] <= mcu_au_clk_gate;
        end

        MCU_SW_RESET_ADDR:
        begin
          //mcu_ack <= 1'b1;

          mcu_rdata[VDC_RST_BP]  <= vdc_reset ;
          mcu_rdata[VDP_RST_BP]  <= vdp_reset ;
          mcu_rdata[ADC_RST_BP]  <= adc_reset ;
          mcu_rdata[DPG_RST_BP]  <= dpg_reset ;
          mcu_rdata[FRM_RST_BP]  <= frm_reset ;
          mcu_rdata[CIPH_RST_BP] <= ciph_reset;
          mcu_rdata[TENC_RST_BP] <= tenc_reset;
          mcu_rdata[R80515_RST_BP] <= r80515_reset;
        end

        DDC_FREQ_ADDR:
        begin
          //mcu_ack <= 1'b1;

          mcu_rdata[DDC_FREQ_MSB:DDC_FREQ_LSB] <= ddc_freq;
        end
        
        MCU_INT_CTL_ADDR:
        begin
          //mcu_ack <= 1'b1;
    
          mcu_rdata[MCU_INT_OD_BP] <= int_od;
          mcu_rdata[MCU_INT_POL_BP] <= int_pol;
        end

        MCU_INT_STATE_ADDR:
        begin
          //mcu_ack <= 1'b1;

          mcu_rdata[MCU_HPD_STATE_BP] <= hpd_debounced;
          mcu_rdata[MCU_RXSENSE_BP] <= rx_sense_debounce;
        end

        MCU_INT_STATUS_ADDR:
        begin
          //mcu_ack <= 1'b1;

          mcu_rdata[MCU_HPD_INT_BP] <= hpd_int_status;
          mcu_rdata[MCU_RXSENSE_INT_BP] <= rxsense_int_status;
          mcu_rdata[MCU_VS_INT_BP] <= vs_int_status;
          mcu_rdata[MCU_VDC_INT_BP] <= vdc_int_status;
          mcu_rdata[MCU_ADC_INT_BP] <=  adc_int_status;
        end

        MCU_INT_EN_ADDR:
        begin
          //mcu_ack <= 1'b1;

          mcu_rdata[MCU_HPD_INT_EN_BP] <= hpd_int_en;
          mcu_rdata[MCU_RXSENSE_INT_EN_BP] <=rxsense_int_en;
          mcu_rdata[MCU_VS_INT_EN_BP] <= vs_int_en;
          mcu_rdata[MCU_VDC_INT_EN_BP] <= vdc_int_en;
          mcu_rdata[MCU_ADC_INT_EN_BP] <= adc_int_en;
        end
        
        MCU_TEST_MUX_ADDR:
        begin
          //mcu_ack <= 1'b1;

          mcu_rdata[MCU_TMUX_SEL_MSB:MCU_TMUX_SEL_LSB]<= test_sel;
          mcu_rdata[MCU_TMUX_MODULE_MSB:MCU_TMUX_MODULE_LSB]<= test_module_sel;
        end
        


        MCU_EX0_INT_EN_ADDR:
        begin
          //mcu_ack <= 1'b1;
          
          mcu_rdata[DDC_FREQ_INT_EN_BP] <= ddc_freq_int_en;
          mcu_rdata[DDC_DATA_INT_EN_BP] <= ddc_data_int_en;
          mcu_rdata[VSYNC_INT_EN_BP]    <= vsync_int_en;
          mcu_rdata[PO_INT_EN_BP]       <= po_int_en;
          mcu_rdata[PD_INT_EN_BP]       <= pd_int_en;
          mcu_rdata[HPD_EX0_INT_EN_BP]  <= hpd_ex0_int_en;
        end

        
        MCU_EX0_INT_STATUS_ADDR:
        begin
          //mcu_ack <= 1'b1;

          mcu_rdata[DDC_FREQ_INT_STATUS_BP] <= ddc_freq_int_status;
          mcu_rdata[DDC_DATA_INT_STATUS_BP] <= ddc_data_int_status;
          mcu_rdata[VSYNC_INT_STATUS_BP]    <= vsync_int_status;
          mcu_rdata[PO_INT_STATUS_BP]       <= po_int_status;
          mcu_rdata[PD_INT_STATUS_BP]       <= pd_int_status;
          mcu_rdata[HPD_EX0_INT_STATUS_BP]  <= hpd_ex0_int_status;          
        end

        CHIP_VERSION_ADDR:
        begin
          //mcu_ack <= 1'b1;
          
          mcu_rdata <= chip_version;
        end  
        
        PHY_PLLCLK_SET_ADDR:
        begin
          //mcu_ack <= 1'b1;
         
          mcu_rdata[PLLCLK_RATIO_SET_MSB:PLLCLK_RATIO_SET_LSB] <= pllclk_ratio_set;
          mcu_rdata[MCU_SEL_250M_BP]                           <= mcu_sel_250m    ;
        end         
        
        PROG_RAM_SEL_ADDR:
        begin
          //mcu_ack <= 1'b1;
          
          mcu_rdata[PROG_MODE_BP] <= prog_mode;
          mcu_rdata[RAM_MODE_BP]  <= ram_mode ;
        end
        
        ANA_ALL_ON_ADDR:
        begin
          //mcu_ack <= 1'b1;
          
          mcu_rdata[ANA_ALL_BP] <= ana_all_on;
        end

               
//        MCU_INV_ADDR_1:
//        begin
          //mcu_ack <= 1'b1;
//        end
        

        default:
        begin
          //mcu_ack <= 1'b0;
        end

      endcase
      
    end//if(rab_read)
  end
end


always @(posedge sys_clk or posedge sys_rst)
begin
  if(sys_rst)
    mcu_ack <= 1'b0;
  else if((rab_write||rab_read) && (rab_addr[8:5]==4'h0)) begin //9'h000~9'h01f
    case(rab_addr)
      9'h1a: mcu_ack <= 1'b0;    
      9'h1b: mcu_ack <= 1'b0;
      9'h1c: mcu_ack <= 1'b0; 
      default: mcu_ack <= 1'b1;
    endcase
  end
  else
    mcu_ack <= 1'b0;
end


//mcu_sys_clk_n_valid toggling generation
reg [2:0] mcu_sys_clk_divider_n_d;  //delay of mcu_sys_clk_divider
reg sys_clk_n_change;               // SYS_CLK_N change indication
reg mcu_sys_clk_n_valid;            //
always @(posedge sys_clk or posedge sys_rst)
begin
  if(sys_rst)
  begin
    mcu_sys_clk_divider_n_d <= 3'd4;
    sys_clk_n_change <= 1'b0;
    mcu_sys_clk_n_valid <= 1'b0;
  end
  else
  begin
    mcu_sys_clk_divider_n_d <= mcu_sys_clk_divider;

    if(mcu_sys_clk_divider_n_d != mcu_sys_clk_divider)
    begin
      sys_clk_n_change <= 1'b1;
    end
    else
    begin
      sys_clk_n_change <=1'b0;
    end

    if(sys_clk_n_change)
    begin
      mcu_sys_clk_n_valid <= ~mcu_sys_clk_n_valid;
    end
  end
end


///////////////////////////////////////////////////////////////////////////////
// rab_ack and rab_rdata convergence
///////////////////////////////////////////////////////////////////////////////
wire rab_ack;
assign rab_ack = vdc_ack | vdp_ack  | adc_ack | dpg_ack |
                 frm_ack | ciph_ack | tenc_ack | ddc_ack |
                 key_ack | mcu_ack  | add_on_ack;

reg [RAB_DATA_WIDTH-1:0] rab_rdata;
always @(*)
begin
  if(vdc_ack)
  begin
    rab_rdata = vdc_rdata;
  end
  else if(vdp_ack)
  begin
    rab_rdata = vdp_rdata;
  end
  else if(adc_ack)
  begin
    rab_rdata = adc_rdata;
  end
  else if(dpg_ack)
  begin
    rab_rdata = dpg_rdata;
  end
  else if(frm_ack)
  begin
    rab_rdata = frm_rdata;
  end
  else if(ciph_ack)
  begin
    rab_rdata = ciph_rdata;
  end
  else if(tenc_ack)
  begin
    rab_rdata = tenc_rdata;
  end
  else if(ddc_ack)
  begin
    rab_rdata = ddc_rdata;
  end
  else if(key_ack)
  begin
    rab_rdata = key_rdata;
  end
  else if(mcu_ack)
  begin
    rab_rdata = mcu_rdata;
  end
  else if(add_on_ack)
    rab_rdata = add_on_rdata;
  else
  begin
    rab_rdata = {RAB_DATA_WIDTH{1'b0}};
//    rab_rdata = add_on_rdata;
  end
end



///////////////////////////////////////////////////////////////////////////////
// internal (to 8051) interrupt handling
///////////////////////////////////////////////////////////////////////////////


//DDC frequency change interrupt geneation
reg ddc_freq_int_event;
always @(posedge sys_clk or posedge sys_rst)
begin
  if(sys_rst)
  begin
    ddc_freq_int_event    <= 1'b0;
  end
  else
  begin
    ddc_freq_int_event <= 1'b0;

    if( rab_write && (rab_addr==DDC_FREQ_ADDR) )
    begin
      if(rab_wdata[DDC_FREQ_MSB:DDC_FREQ_LSB] != ddc_freq)
      begin
        ddc_freq_int_event <= 1'b1;
      end
    end
  end
end


//DDC data ready interrupt geneation
//DDC data ready means RFIFO depth is at least 1
reg [3:0] ddc_rfifo_depth_d;
reg ddc_data_ready_int_event;
always @(posedge sys_clk or posedge sys_rst)
begin
  if(sys_rst)
  begin
    ddc_rfifo_depth_d <= 4'b0;
    ddc_data_ready_int_event <= 1'b0;
  end
  else
  begin
    ddc_rfifo_depth_d <= ddc_rfifo_depth;

    ddc_data_ready_int_event <= 1'b0;

    if( (ddc_rfifo_depth == 1) && (ddc_rfifo_depth_d == 0) )
    begin
      ddc_data_ready_int_event <= 1'b1;
    end
  end
end


///////////////////////////////////////////////////////////////////////////////
// external (binhai) interrupt handling
///////////////////////////////////////////////////////////////////////////////

//hpd interrupt event generation
//once hpd_debounced status changed
//it will generate a hpd_int_event
reg hpd_debounce_d;
reg hpd_int_event;
always @(posedge sys_clk or posedge sys_rst)
begin
  if(sys_rst)
  begin
    hpd_debounce_d <= 1'b0;
    hpd_int_event <= 1'b0;
  end
  else
  begin
    hpd_debounce_d <= hpd_debounced;

    hpd_int_event <= 1'b0;
    if(hpd_debounce_d != hpd_debounced)
    begin
      hpd_int_event <= 1'b1;
    end
  end
end  

//RXSENSE interrupt event generation
//once rx_sense_debounce status changed,
//it will generate a rxsense_int_event
reg rxsense_debounce_d;
reg rxsense_int_event;
always @(posedge sys_clk or posedge sys_rst)
begin
  if(sys_rst)
  begin
    rxsense_debounce_d <= 1'b0;
    rxsense_int_event  <= 1'b0;
  end
  else
  begin
    rxsense_debounce_d <= rx_sense_debounce;

    rxsense_int_event <= 1'b0;
    if (rxsense_debounce_d != rx_sense_debounce)
    begin
      rxsense_int_event <= 1'b1;
    end
  end
end    

//Power on interrupt event geneartion
//once pd_mode switch to power on mode,
//it will generate a po_int_event
reg [1:0] pd_mode_d;
reg       po_int_event;
always @(posedge sys_clk or posedge sys_rst)
begin
  if(sys_rst)
  begin
    pd_mode_d <= 2'b00;
    po_int_event <= 1'b0;
  end
  else
  begin
        pd_mode_d <= pd_mode;
    
    po_int_event <= 1'b0;
    if((pd_mode_d != 2) & (pd_mode == 2))
    begin
        po_int_event <= 1'b1;
    end
  end
end

//Power down interrupt event geneartion
//once pd_mode switch to power down(power saving) mode,
//it will generate a pd_int_event
reg       pd_int_event;
always @(posedge sys_clk or posedge sys_rst)
begin
  if(sys_rst)
  begin
    pd_int_event <= 1'b0;
  end
  else
  begin
   
    pd_int_event <= 1'b0;
    if((pd_mode_d != 1) & (pd_mode == 1))
    begin
        pd_int_event <= 1'b1;
    end
  end
end


    
//interrupt capture
//capture related *_int_event to generate related *_int_status
//Please note *_int_status will be cleared by writting 1
always @(posedge sys_clk or posedge sys_rst)
begin
  if(sys_rst)
  begin
    hpd_int_status <= 1'b0;
    rxsense_int_status <= 1'b0;
    vs_int_status <= 1'b0;
    vdc_int_status <= 1'b0;
    
    ddc_freq_int_status <= 1'b0;
    ddc_data_int_status <= 1'b0;
    vsync_int_status <= 1'b0;
    po_int_status <= 1'b0;
    pd_int_status <= 1'b0;
    hpd_ex0_int_status <= 1'b0;
    
  end
  else
  begin
    //HPD INT event capture
    if(hpd_int_event)
    begin
      hpd_int_status <= 1'b1;
    end
    else
    begin
      //W1C
      if( (rab_write && rab_addr == MCU_INT_STATUS_ADDR) )
      begin
        if(rab_wdata[MCU_HPD_INT_BP] == 1'b1)
            begin
              hpd_int_status <= 1'b0;
            end
      end
    end
    
    //rxsense int event capture
    if(rxsense_int_event)
    begin
      rxsense_int_status <= 1'b1;
    end
    else
    begin
      //W1C
      if( (rab_write && rab_addr == MCU_INT_STATUS_ADDR) )
      begin
        if(rab_wdata[MCU_RXSENSE_INT_BP] == 1'b1)
            begin
          rxsense_int_status <= 1'b0;
            end
      end
    end
    
    //VS int event capture
    if(frm_vs_event)
    begin
      vs_int_status <= 1'b1;
    end
    else
    begin
      //W1C
      if( (rab_write && rab_addr == MCU_INT_STATUS_ADDR) )
      begin
        if(rab_wdata[MCU_VS_INT_BP] == 1'b1)
            begin
          vs_int_status <= 1'b0;
            end
      end
    end
    

    //VDC int event capture
    if(vdc_int_event)
    begin
      vdc_int_status <= 1'b1;
    end
    else
    begin
      //W1C
      if( (rab_write && rab_addr == MCU_INT_STATUS_ADDR) )
      begin
        if(rab_wdata[MCU_VDC_INT_BP] == 1'b1)
            begin
          vdc_int_status <= 1'b0;
            end
      end
    end

    //DDC frequency change int event capture
    if(ddc_freq_int_event)
    begin
      ddc_freq_int_status <= 1'b1;
    end
    else
    begin
      //W1C
      if( (rab_write && rab_addr == MCU_EX0_INT_STATUS_ADDR) )
      begin
        if(rab_wdata[DDC_FREQ_INT_STATUS_BP] == 1'b1)
            begin
          ddc_freq_int_status <= 1'b0;
            end
      end
    end

    //DDC data ready int event capture
    if(ddc_data_ready_int_event)
    begin
      ddc_data_int_status <= 1'b1;
    end
    else
    begin
      //W1C
      if( (rab_write && rab_addr == MCU_EX0_INT_STATUS_ADDR) )
      begin
        if(rab_wdata[DDC_DATA_INT_STATUS_BP] == 1'b1)
            begin
          ddc_data_int_status <= 1'b0;
            end
      end
    end


    //VSYNC int event capture
    if(vsync_int_event)
    begin
      vsync_int_status <= 1'b1;
    end
    else
    begin
      //W1C
      if( (rab_write && rab_addr == MCU_EX0_INT_STATUS_ADDR) )
      begin
        if(rab_wdata[VSYNC_INT_STATUS_BP] == 1'b1)
            begin
          vsync_int_status <= 1'b0;
            end
      end
    end

    //power on int event capture
    if(po_int_event)
    begin
      po_int_status <= 1'b1;
    end
    else
    begin
      //W1C
      if( (rab_write && rab_addr == MCU_EX0_INT_STATUS_ADDR) )
      begin
        if(rab_wdata[PO_INT_STATUS_BP] == 1'b1)
            begin
          po_int_status <= 1'b0;
            end
      end
    end

    //power down int event capture
    if(pd_int_event)
    begin
      pd_int_status <= 1'b1;
    end
    else
    begin
      //W1C
      if( (rab_write && rab_addr == MCU_EX0_INT_STATUS_ADDR) )
      begin
        if(rab_wdata[PD_INT_STATUS_BP] == 1'b1)
            begin
          pd_int_status <= 1'b0;
            end
      end
    end

    //hpd int event capture(output to ex0)
    if(hpd_int_event)
    begin
      hpd_ex0_int_status <= 1'b1;
    end
    else
    begin
      //W1C
      if( (rab_write && rab_addr == MCU_EX0_INT_STATUS_ADDR) )
      begin
        if(rab_wdata[HPD_EX0_INT_STATUS_BP] == 1'b1)
            begin
          hpd_ex0_int_status <= 1'b0;
            end
      end
    end

  end
end

     


reg io_int_out;
reg io_int_oe;

always @(*)
begin
  if( (hpd_int_status & hpd_int_en) |
      (rxsense_int_status & rxsense_int_en) |
      (vs_int_status & vs_int_en) |
      (vdc_int_status & vdc_int_en) |
      (adc_int_status & adc_int_en) )
  begin
     io_int_out = int_pol;
     io_int_oe  = 1'b1;
  end
  else  //if not interrupt generation
  begin
    //if output style is open-drain
    //binhai will not drive the int pin while no interrupt
    //
    if(int_od)
    begin
      io_int_out = !int_pol;
      io_int_oe  = 1'b0;
    end
    else //if is push-poll
    begin
      io_int_out = !int_pol;
      io_int_oe  = 1'b1;
    end
  end
end


//interrupts output to ex0
reg ex0;
always @(*)
begin
        if((hpd_int_event & hpd_ex0_int_en) |
       (ddc_freq_int_event & ddc_freq_int_en) |
       (ddc_data_ready_int_event & ddc_data_int_en) |
       (vsync_int_event & vsync_int_en)       |
       (po_int_event & po_int_en)   |
       (pd_int_event & pd_int_en))
    begin
       ex0 = 1'b1;
    end   
    else
    begin
       ex0 = 1'b0;
    end
       
end





endmodule
