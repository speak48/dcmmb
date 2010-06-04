module T_COUNTER(
                 clk,
                 rst_n,
                 t_en,
                 tconf_c,
                 t_cnt
                );


input            clk;
input            rst_n;
input            t_en;

input   [2:0]    tconf_c;
output  [2:0]    t_cnt;


wire             clk;
wire             rstb;
wire             t_en;
wire    [2:0]    tconf_c;
reg     [2:0]    t_cnt_r;
wire    [2:0]    t_cnt;

assign t_cnt = t_cnt_r;

always @(posedge clk or negedge rst_n)
begin
    if (rst_n == 1'b0)
        t_cnt_r[2:0] <= #1 3'b0;
    else if (t_en == 1)
        begin
            if (t_cnt_r == tconf_c)
                t_cnt_r[2:0] <= #1 3'b0;
            else
                t_cnt_r[2:0] <= #1 t_cnt_r[2:0] + 3'b001;
        end
    else
        t_cnt_r[2:0] <= #1 3'b0;
end

endmodule            

