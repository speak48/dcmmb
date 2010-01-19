////////////////////////////////////////////////////
//module name:spi
//file name:  spi_fifo.v
//version:    1.0
//author:     zxc
//date:       2008.06.17
//function:   spi fifo
///////////////////////////////////////////////////
//revision history

`timescale 1ns/1ns
module spi_fifo(
                 rstb_i,          //fifo reset
                 clk_i,           //system clock
                 read_i,          //fifo read
                 write_i,         //fifo write
                 fifo_clr_i,      //fifo clear
                 din_i,           //data input
                 dout_o,          //data output
                 fifo_full_o,     //fifo full flag
                 fifo_empty_o     //fifo empty flag
               );
            
input rstb_i;
input clk_i;
input read_i;
input write_i;
input fifo_clr_i;
input [7:0]din_i;
output [7:0]dout_o;
output fifo_full_o;
output fifo_empty_o;

//internal signal
reg [7:0]fifo_mem[1:0];
reg [1:0]rd_pointer;
reg [1:0]wr_pointer;


//fifo flag
assign fifo_empty_o = (rd_pointer[0] == wr_pointer[0]) & (~(rd_pointer[1] ^ wr_pointer[1]));
assign fifo_full_o = (rd_pointer[0] == wr_pointer[0]) & (rd_pointer[1] ^ wr_pointer[1]);


//rd_pointer
always @(posedge clk_i or negedge rstb_i)
  begin
    if(!rstb_i)
      rd_pointer <= 2'b0;
    else if(fifo_clr_i)
      rd_pointer <= 2'b0;      
    else if(read_i && (!fifo_empty_o))
      rd_pointer <= rd_pointer + 1'b1;
  end


//wr_pointer
always @(posedge clk_i or negedge rstb_i)
  begin
    if(!rstb_i)
      wr_pointer <= 2'b0;
    else if(fifo_clr_i)
      wr_pointer <= 2'b0;        
    else
      begin
        if(write_i && (!fifo_full_o))
          wr_pointer <= wr_pointer + 1'b1;
      end
  end

	
//fifo write  
always @(posedge clk_i or negedge rstb_i)
  begin
  	if(!rstb_i)
      begin
        fifo_mem[0] <= 8'h0;
        fifo_mem[1] <= 8'h0;
      end
    else if(fifo_clr_i) 
      begin
        fifo_mem[0] <= 8'h0;
        fifo_mem[1] <= 8'h0;
      end    
    else if(write_i && (!fifo_full_o))
      fifo_mem[wr_pointer[0]] <= din_i;
  end

  
//fifo read
assign dout_o = fifo_mem[rd_pointer[0]];


endmodule