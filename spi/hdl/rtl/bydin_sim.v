module bydin_sim(
    clk,
    reset_n,
    mem_rd_ena,
    mem_data_out,
    mem_ena_out,
    bydin_int
);

input            clk;
input            reset_n;
input            mem_rd_ena;

output   [7:0]   mem_data_out;
output           mem_ena_out;
output           bydin_int;

parameter MI_DEPTH =  9'd288;
parameter K_REG = 8'd224;

reg              rd_ena_d1;
reg              rd_ena_d2;
reg              rd_ena_d3;
reg              mem_ena_out;
reg      [7:0]   mem_data_out;
reg      [8:0]   row_out;
reg      [7:0]   counter_out;
reg      [16:0]  ram_addr;

wire     [8:0]   mi_reg;
wire     [7:0]   k_reg;

wire   ram_rd = rd_ena_d2;
wire   ram_rd_d1 = rd_ena_d3;

assign mi_reg = MI_DEPTH;
assign k_reg  = K_REG;

always @ (posedge clk or negedge reset_n)
begin
   if(reset_n == 1'b0)
       row_out <= #1 9'h0;	   
   else if(rd_ena_d1) begin
       if(row_out[8:0] == (mi_reg[8:0] - 1'b1) )
           row_out <= #1 9'h0;
       else
	   row_out <= #1 row_out + 1'b1;
   end
end  

always @ (posedge clk or negedge reset_n)
begin
   if(reset_n == 1'b0)
       counter_out <= #1 8'h0;	   
   else if((row_out[8:0] == (mi_reg[8:0] - 1'b1)) & rd_ena_d1) begin
       if(counter_out[7:0] == (k_reg[7:0] - 1'b1))
           counter_out <= #1 8'h0;
       else
	   counter_out <= #1 counter_out + 1'b1;
   end
end  

always @ (posedge clk or negedge reset_n)
begin
    if(reset_n == 1'b0)
	 ram_addr[16:0] <= #1 17'b0;
    else if(rd_ena_d1)
	 ram_addr[16:0] <= #1 row_out[8:0]*8'd240+counter_out[7:0];
end

always @ (posedge clk or negedge reset_n)
begin
    if(reset_n == 1'b0)
	 rd_ena_d1 <= #1 1'b0;
    else
	 rd_ena_d1 <= #1 mem_rd_ena;
end

always @ (posedge clk or negedge reset_n)
begin
    if(reset_n == 1'b0)
	 rd_ena_d2 <= #1 1'b0;
    else
	 rd_ena_d2 <= #1 rd_ena_d1;
end

always @ (posedge clk or negedge reset_n)
begin
    if(reset_n == 1'b0)
	 rd_ena_d3 <= #1 1'b0;
    else
	 rd_ena_d3 <= #1 rd_ena_d2;
end

always @ (posedge clk or negedge reset_n)
begin
    if(reset_n == 1'b0)
	 mem_ena_out <= #1 1'b0;
    else
	 mem_ena_out <= #1 rd_ena_d3;
end

always @ (posedge clk or negedge reset_n)
begin
    if(reset_n == 1'b0)
	 mem_data_out <= #1 8'b0;
    else
	 mem_data_out <= #1 ram_addr[16:9] ^ ram_addr[7:0]; //ram_dataout[7:0];
end

// 1s generate 1 interrupt vector
reg [3:0]  low_counter;
reg [21:0] high_counter;
reg        bydin_int;
wire   low_cnt_clk = low_counter[3];
`ifdef FPGA
wire   rst_counter = high_counter == 22'h2625A0;
`else
wire   rst_counter = high_counter == 22'h200;
`endif

always @ (posedge clk or negedge reset_n)
begin
    if(reset_n == 1'b0)
	 low_counter <= #1 4'b0;
    else
	 low_counter <= #1 low_counter + 1'b1;
end

always @ (posedge low_cnt_clk or negedge reset_n)
begin
    if(reset_n == 1'b0)
	 high_counter <= #1 22'b0;
    else if(rst_counter)
	 high_counter <= #1 22'b0;
    else
	 high_counter <= #1 high_counter + 1'b1;
end

always @ (posedge low_cnt_clk or negedge reset_n)
begin
    if(reset_n == 1'b0)
	 bydin_int  <= #1 1'b0;
    else
	 bydin_int <= #1 rst_counter;
end


endmodule
