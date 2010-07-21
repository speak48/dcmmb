// FILE NAME :mcu_top.v
// TYPE : module
// DEPARTMENT : DE
// AUTHOR :  Chen Zhengyi
// AUTHOR'S EMAIL : chenzhengyi@shhic.com
//------------------------------------------------------------------------
// Release history
// VERSION | Date     | AUTHOR       |  DESCRIPTION
// 0.1     | 09/4/3   | chenzy       |  mcu top module of hongqiao
//------------------------------------------------------------------------
// PURPOSE : hongqiao mcu top module
//------------------------------------------------------------------------
// PARAMETERS
// PARAM NAME RANGE : DESCRIPTION : DEFAULT : VA UNITS
// N.A.
//------------------------------------------------------------------------
// REUSE ISSUES : N.A.
// Reset Strategy : N.A.
// Clock Domains : N.A.
// Critical Timing : N.A.
// Test Features : N.A.
// Asynchronous I/F : N.A.
// Scan Methodology : N.A.
// Instantiations : N.A.
//
//------------------------------------------------------------------------

module hq_reg_file(
            sys_clk,
            sys_rst,
            chip_version,

            rab_write,
            rab_read,
            rab_addr,
            rab_wdata,

            rab_ack,
            rab_rdata,
            
            pram_rdata,
            pram_ack  ,

            r80515_reset,
            prog_mode
);

///////////////////////
// parameters
///////////////////////
`include "hq_global_parameter.v"

///////////////////////
// MCU address definition
///////////////////////
parameter VENDOR_ID0_ADDR    = 9'h000;
parameter VENDOR_ID1_ADDR    = 9'h001;
parameter CHIP_VERSION_ADDR  = 9'h003;
parameter PROG_RAM_SEL_ADDR  = 9'h011;
parameter MCU_SW_RESET_ADDR  = 9'h111;


//PROG_RAM_SEL bit definition
parameter PROG_MODE_BP       = 0;
parameter R80515_RST_BP      = 7;

input sys_clk;
input sys_rst;
input [7:0] chip_version;

//RAB bus signals
input rab_write;
input rab_read;
input [RAB_ADDR_WIDTH-1:0] rab_addr;
input [RAB_DATA_WIDTH-1:0] rab_wdata;

input [7:0] pram_rdata;
input       pram_ack;

output rab_ack;
output [RAB_DATA_WIDTH-1:0] rab_rdata;
output r80515_reset;

//program RAM select signals
output prog_mode;



reg [RAB_DATA_WIDTH-1:0] mcu_rdata ;
reg                      mcu_ack   ;
reg                      prog_mode ;
reg                      r80515_reset;

// RAB ACK
wire rab_ack;
assign rab_ack = mcu_ack;

reg [RAB_DATA_WIDTH-1:0] rab_rdata;

always @(*)
begin
  if(mcu_ack)
    rab_rdata = mcu_rdata;
  if(pram_ack)
    rab_rdata = pram_rdata;
  else
    rab_rdata = {RAB_DATA_WIDTH{1'b0}};
end  


//register write/read access

always @(posedge sys_clk or posedge sys_rst)
begin
  if(sys_rst) begin
    mcu_rdata <= {RAB_DATA_WIDTH{1'b0}};
    prog_mode <= 1'b0;
    r80515_reset <= 1'b1;
    end
  else begin        
    mcu_rdata <= {RAB_DATA_WIDTH{1'b0}};
    if(rab_write)
    begin
      case(rab_addr)
        PROG_RAM_SEL_ADDR:
        begin
          prog_mode <= rab_wdata[PROG_MODE_BP];
        end

        MCU_SW_RESET_ADDR:
        begin
          r80515_reset <= rab_wdata[R80515_RST_BP];
        end

      default :
        begin

        end 
      endcase
    end
    else if(rab_read)
    begin
       case(rab_addr)
        VENDOR_ID0_ADDR:
        begin
          mcu_rdata <= 8'h72;
        end
        
        VENDOR_ID1_ADDR:
        begin
          mcu_rdata <= 8'h72;
        end

        CHIP_VERSION_ADDR:
        begin
          mcu_rdata <= chip_version;
        end
        
        MCU_SW_RESET_ADDR:
        begin
          mcu_rdata[R80515_RST_BP] <= r80515_reset;
        end

        PROG_RAM_SEL_ADDR:
        begin         
          mcu_rdata[PROG_MODE_BP] <= prog_mode;
        end

        default:
        begin
          mcu_rdata <= {RAB_DATA_WIDTH{1'b0}};  
        end
       endcase
    end
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

 
endmodule
