//
//

module demo_reg(
    clk,
    reset_n,
    reg_addr,
    reg_data_i,
    reg_data_o,
    reg_rd,
    reg_wr
);

input            clk;
input            reset_n;
input  [6:0]     reg_addr;
input  [7:0]     reg_data_i;
input            reg_rd;
input            reg_wr;

output  [7:0]    reg_data_o;

reg     [7:0]    reg_data_o;
reg     [7:0]    reg_data [0:127];
integer i;

always @ (posedge clk or negedge reset_n)
if(reset_n == 1'b0)
    begin 
    for(i=0;i<128;i=i+1)
        reg_data[i] <= 8'h0;
    end
else if(reg_wr)
	reg_data[reg_addr] <= reg_data_i;
else ;

always @ (posedge clk or negedge reset_n)
if(reset_n == 1'b0)
    reg_data_o <= 8'h0;
else if(reg_rd)
    reg_data_o <= reg_data[reg_addr];	
else ;


endmodule
