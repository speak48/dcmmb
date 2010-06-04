module nfc_asynch_ram(
                    wclk,
                    rclk,

                    write,
                    read,

                    addr_wr,
                    addr_rd,

                    data_in,
                    data_out

                    );

parameter  WIDTH  = 16;
parameter  ADDR   = 4;
parameter  DEPTH  = 16;

input          wclk;
input          rclk;
input [1:0]    write;
input          read;

input [ADDR-1:0]  addr_wr;
input [ADDR-1:0]  addr_rd;

input [WIDTH-1:0] data_in;
output [WIDTH-1:0] data_out;



reg [WIDTH-1:0] ram [0:DEPTH-1];
reg [ADDR-1:0]  addr_rd_p1;

always @(posedge wclk)
begin
  if(write[0])
    ram[addr_wr][7:0] <= data_in[7:0];
  if(write[1])
    ram[addr_wr][15:8] <= data_in[15:8];
end

always @(posedge rclk)
begin
  if(read)
    addr_rd_p1 <= addr_rd;
end

assign data_out = ram[addr_rd_p1];


endmodule

