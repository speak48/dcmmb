// Buffer Size 2048
//
module bydin_dma(
    clk,
    reset_n,
    bydin_int,
    bydin_en_out,
    bydin_dout,
    spi_rd_ena,
    dma_depth,

    dma_en_out,
    dma_dout,
    dma_int
);

parameter BUF_WID  = 11;
parameter BUF_SIZE = ((1 << BUF_WID) - 1);

input                 clk         ;
input                 reset_n     ;
input                 bydin_int   ;
input                 bydin_en_out;
input  [7:0]          bydin_dout  ;
input                 spi_rd_ena  ;
input  [16:0]         dma_depth   ;

output                dma_en_out  ;
output  [7:0]         dma_dout    ;
output                dma_int     ;

reg    [16:0]         dma_counter ;
reg                   ena_counter ;
reg                   dma_int     ;
reg                   dma_en_out  ;
reg     [7:0]         dma_dout    ;
reg  [BUF_WID-1:0]    spi_counter ;
reg                   spi_rd      ;
reg                   spi_rd_d1   ;

wire                  rst_counter ;
wire                  dma_fifo_full;
wire                  new_dma_rd  ;

assign rst_counter = ( dma_counter == dma_depth ) | bydin_int;
assign dma_fifo_full = ( dma_counter[BUF_WID-1:0] == (BUF_SIZE-1) ) & ena_counter;
assign new_dma_rd = ( spi_counter == BUF_SIZE ) & ( dma_counter != 'h0 );

// clear when all data read finish
// or new bydin int start
always @ (posedge clk or negedge reset_n)
if(!reset_n)
    dma_counter <= #1 'h0;
else if(rst_counter)
    dma_counter <= #1 'h0;	
else if(ena_counter)
    dma_counter <= #1 dma_counter + 1'b1;

always @ (posedge clk or negedge reset_n)
if(!reset_n)
    ena_counter <= #1 1'b0;
else if(dma_fifo_full)
    ena_counter <= #1 1'b0;	
else if(bydin_int | new_dma_rd)
    ena_counter <= #1 1'b1;

always @ (posedge clk or negedge reset_n)
if(!reset_n)
    dma_int <= #1 1'b0;
else	
    dma_int <= #1 dma_fifo_full;

always @ (posedge clk or negedge reset_n)
if(!reset_n)
    spi_counter <= #1 'h0;
else if(spi_rd_ena)
    spi_counter <= #1 spi_counter + 1'b1;

always @ (posedge clk or negedge reset_n)
if(!reset_n) begin
    spi_rd <= #1 1'b0;
    spi_rd_d1 <= #1 1'b0;
    end
else begin
    spi_rd <= #1 spi_rd_ena;	
    spi_rd_d1 <= #1 spi_rd;
end

always @ (posedge clk or negedge reset_n)
if(!reset_n)
    dma_en_out <= #1 1'b0;
else
    dma_en_out <= #1 spi_rd_d1;

always @ (posedge clk or negedge reset_n)
if(!reset_n)
    dma_dout <= #1 8'h0;
else if(spi_rd_d1)
    dma_dout <= #1 mem_q;	



endmodule
