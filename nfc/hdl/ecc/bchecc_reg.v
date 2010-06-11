`timescale 1ns/100ps
module  bchecc_reg(
                rst_n,
                clk,
                sfr_en_i,
                sfr_rd_i,
                sfr_wr_i,
                sfr_size_i,
                sfr_addr_i,
                sfr_wdata_i,
                change_stat_i,
                ecc_busy_i,
                ecc_block_i,
                ecc_error_i,
                correct_fail_i,
                error_cnt_i,
                sfr_rdata_o,
                ecc_ctrl_o,
                ecc_cfg_o
                );
////////////////input
input           rst_n;
input           clk;
input           sfr_en_i;
input           sfr_rd_i;
input           sfr_wr_i;
input   [1:0]   sfr_size_i;
input   [3:0]   sfr_addr_i;
input   [31:0]  sfr_wdata_i;
input           change_stat_i;
input           ecc_busy_i;
input           ecc_block_i;
input           ecc_error_i;
input           correct_fail_i;
input   [3:0]   error_cnt_i;

////////////////output
output  [31:0]  sfr_rdata_o;
output  [3:0]   ecc_ctrl_o;
output  [9:0]   ecc_cfg_o;
reg     [31:0]  sfr_rdata;

////////////////register
reg     [3:0]   ecc_ctrl;
reg     [9:0]   ecc_cfg;
reg     [7:0]   ecc_stat;

////////////////read and write register
wire            sfr_sel;
reg             sfr_byte0_sel;
reg             sfr_byte1_sel;
wire            ecc_ctrl_sel;
wire            ecc_cfg0_sel;
wire            ecc_cfg1_sel;
wire            ecc_stat_sel;

wire            ecc_ctrl_rd;
wire            ecc_cfg0_rd;
wire            ecc_cfg1_rd;
wire            ecc_stat_rd;

wire            ecc_ctrl_wr;
wire            ecc_cfg0_wr;
wire            ecc_cfg1_wr;
wire            ecc_stat_wr;

////////////////generate read and write signals
assign  sfr_sel = sfr_en_i && (sfr_size_i<2'b11) && (sfr_addr_i[3:2]<2'b11) && (sfr_addr_i[1]==1'b0);

always  @(*)
begin
    if(sfr_sel)
        begin
            if((sfr_size_i==2'b00)&&(sfr_addr_i[1:0]==2'b00))
                begin
                    sfr_byte0_sel = 1'b1;
                end
            else if((sfr_size_i==2'b01)&&(sfr_addr_i[1]==1'b0))
                begin
                    sfr_byte0_sel = 1'b1;
                end
            else if(sfr_size_i==2'b10)
                begin
                    sfr_byte0_sel = 1'b1;
                end
            else
                begin
                    sfr_byte0_sel = 1'b0;
                end
        end
    else
        begin
            sfr_byte0_sel = 1'b0;
        end
end

always  @(*)
begin
    if(sfr_sel)
        begin
            if((sfr_size_i==2'b00)&&(sfr_addr_i[1:0]==2'b01))
                begin
                    sfr_byte1_sel = 1'b1;
                end
            else if((sfr_size_i==2'b01)&&(sfr_addr_i[1]==1'b0))
                begin
                    sfr_byte1_sel = 1'b1;
                end
            else if(sfr_size_i==2'b10)
                begin
                    sfr_byte1_sel = 1'b1;
                end
            else
                begin
                    sfr_byte1_sel = 1'b0;
                end
        end
    else
        begin
            sfr_byte1_sel = 1'b0;
        end
end

assign  ecc_ctrl_sel = (sfr_addr_i[3:2]==2'b00) && sfr_byte0_sel;
assign  ecc_cfg0_sel = (sfr_addr_i[3:2]==2'b01) && sfr_byte0_sel;
assign  ecc_cfg1_sel = (sfr_addr_i[3:2]==2'b01) && sfr_byte1_sel;
assign  ecc_stat_sel = (sfr_addr_i[3:2]==2'b10) && sfr_byte0_sel;
assign  ecc_ctrl_rd  = ecc_ctrl_sel && sfr_rd_i;
assign  ecc_cfg0_rd  = ecc_cfg0_sel && sfr_rd_i;
assign  ecc_cfg1_rd  = ecc_cfg1_sel && sfr_rd_i;
assign  ecc_stat_rd  = ecc_stat_sel && sfr_rd_i;
assign  ecc_ctrl_wr  = ecc_ctrl_sel && sfr_wr_i;
assign  ecc_cfg0_wr  = ecc_cfg0_sel && sfr_wr_i;
assign  ecc_cfg1_wr  = ecc_cfg1_sel && sfr_wr_i;
assign  ecc_stat_wr  = ecc_stat_sel && sfr_wr_i;

///////////////write register
always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            ecc_ctrl <= 4'h0;
        end
    else if(ecc_ctrl_wr)
        begin
            ecc_ctrl <= sfr_wdata_i[3:0];
        end
end

always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            ecc_cfg <= 10'h000;
        end
    else
        begin
            if(ecc_cfg0_wr)
                begin
                    ecc_cfg[7:0] <= sfr_wdata_i[7:0];
                end
            if(ecc_cfg1_wr)
                begin
                    ecc_cfg[9:8] <= sfr_wdata_i[9:8];
                end
        end
end

always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            ecc_stat[0] <= 1'b0;
            ecc_stat[3] <= 1'b0;
        end
    else
        begin
            ecc_stat[0] <= ecc_busy_i;
            ecc_stat[3] <= ecc_block_i;
        end
end

always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            ecc_stat[1] <= 1'b0;
        end
    else if(change_stat_i)
        begin
            ecc_stat[1] <= ecc_error_i;
        end
end

always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            ecc_stat[2] <= 1'b0;
        end
    else if(ecc_stat_wr)
        begin
            ecc_stat[2] <= sfr_wdata_i[2];
        end
    else if(change_stat_i)
        begin
            ecc_stat[2] <= ecc_stat[2] | correct_fail_i;
        end
end

always  @(negedge rst_n or posedge clk)
begin
    if(!rst_n)
        begin
            ecc_stat[7:4] <= 4'h0;
        end
    else if(change_stat_i)
        begin
            ecc_stat[7:4] <= error_cnt_i;
        end
end

////////////////read register
always  @(*)
begin
    case({ecc_ctrl_rd,ecc_stat_rd,ecc_cfg1_rd,ecc_cfg0_rd})
        4'b1000:
            begin
                if(sfr_size_i==2'b00)
                    begin
                        sfr_rdata = {4{4'h0,ecc_ctrl}};
                    end
                else if(sfr_size_i==2'b01)
                    begin
                        sfr_rdata = {2{12'h000,ecc_ctrl}};
                    end
                else
                    begin
                        sfr_rdata = {28'h0000000,ecc_ctrl};
                    end
            end
        4'b0100:
            begin
                if(sfr_size_i==2'b00)
                    begin
                        sfr_rdata = {4{ecc_stat}};
                    end
                else if(sfr_size_i==2'b01)
                    begin
                        sfr_rdata = {2{8'h00,ecc_stat}};
                    end
                else
                    begin
                        sfr_rdata = {24'h000000,ecc_stat};
                    end
            end
        4'b0001:
            begin
                if(sfr_size_i==2'b00)
                    begin
                        sfr_rdata = {4{ecc_cfg[7:0]}};
                    end
                else if(sfr_size_i==2'b01)
                    begin
                        sfr_rdata = {2{8'h00,ecc_cfg[7:0]}};
                    end
                else
                    begin
                        sfr_rdata = {24'h000000,ecc_cfg[7:0]};
                    end
            end
        4'b0010:
            begin
                if(sfr_size_i==2'b00)
                    begin
                        sfr_rdata = {4{6'b000000,ecc_cfg[9:8]}};
                    end
                else if(sfr_size_i==2'b01)
                    begin
                        sfr_rdata = {2{6'b000000,ecc_cfg[9:8],8'h00}};
                    end
                else
                    begin
                        sfr_rdata = {{22{1'b0}},ecc_cfg[9:8],8'h00};
                    end
            end
        4'b0011:
            begin
                if(sfr_size_i==2'b01)
                    begin
                        sfr_rdata = {2{6'b000000,ecc_cfg[9:0]}};
                    end
                else
                    begin
                        sfr_rdata = {{22{1'b0}},ecc_cfg[9:0]};
                    end
            end
        default: sfr_rdata = {32{1'b0}};
    endcase
end

////////////////output
assign  sfr_rdata_o = sfr_rdata;
assign  ecc_ctrl_o  = ecc_ctrl; 
assign  ecc_cfg_o   = ecc_cfg;

endmodule