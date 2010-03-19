module main_man(
    clk          ,
    rst_n        ,
    bidin_sync_in,
    bidin_ena_in ,
    bidin_din    ,
    ldpc_req     ,
    bidin_rdy    ,
    bidin_ena_out,
    bidin_dout   ,

    state        ,
    sub_dout     ,
    sub_dout_en  ,
    sub_din      ,
    sub_din_en   ,
    
    main_addr    ,
    main_data_i  ,
    main_data_o  ,
    main_en      ,
    main_wr        
);

parameter WID = 6;


input                     clk          ;
input                     rst_n        ;
input                     bidin_sync_in;
input                     bidin_ena_in ;
input   [WID-1:0]         bidin_din    ;
input                     ldpc_req     ;

output                    bidin_rdy    ;
output                    bidin_ena_out;
output  [WID-1:0]         bidin_dout   ;

output  [4:0]             state        ;
input   [WID-1:0]         sub_dout     ;
output                    sub_dout_en  ;
output  [WID-1:0]         sub_din      ;
output                    sub_din_en   ;
    
output  [17:0]            main_addr    ;
output  [WID-1:0]         main_data_i  ;
input   [WID-1:0]         main_data_o  ;
output                    main_en      ;
output                    main_wr      ;

parameter     IDLE    = 'h1,
              WR_1ST  = 'h2,
              WR_FULL = 'h4;

reg         [4:0]         state        ;
reg         [4:0]         next_state   ;
reg                       wr_hv        ;
reg                       rd_hv        ;
reg         [17:0]        main_addr    ;
reg      [WID-1:0]        main_data_i  ;
reg                       main_en      ;
reg                       main_wr      ;
reg         [17:0]        rd_addr      ;
reg         [17:0]        wr_addr      ;
reg         [17:0]        count        ;
reg                       bidin_rdy    ;
reg         [8:0]         num_row      ;
reg         [8:0]         num_col      ;
reg         [8:0]         num_row_r    ;
reg         [8:0]         num_col_r    ;
reg         [17:0]        wr_addr_r    ;

wire                      wr_full      ;
wire                      rd_full      ;
wire                      state_idle   ;
wire                      wr_first_24  ;
wire                      rst_count    ;
wire                      rd_main_en   ;
wire                      main_rd_end  ;

assign state_idle = (state == IDLE   );
assign wr_full = (wr_addr == 'd129599);
assign rd_full = (rd_addr == 'd129599);

assign rst_count = (count == 'd138239);

always @ (posedge clk or negedge rst_n)
begin :count_r
    if(!rst_n)
        count <= # 18'd0;
    else if(bidin_sync_in) begin
        if(rst_count)
        count <= #1 18'd0;
        else 
        count <= #1 count + 1'b1;
    end
end

always @ (posedge clk or negedge rst_n)
begin : bidin_rdy_r
    if(!rst_n)
        bidin_rdy <= #1 1'b0;
    else
        bidin_rdy <= #1 rst_count;
end

// Main memory interface
always @ (posedge clk or negedge rst_n)
begin :main_wr_r
    if(!rst_n)
        main_wr <= #1 1'b0;
    else
        main_wr <= #1 bidin_sync_in;
end

always @ (posedge clk or negedge rst_n)
begin :main_di_r
    if(!rst_n)
        main_data_i <= #1 'h0;
    else if(bidin_sync_in)
        main_data_i <= #1 bidin_din;
end 

always @ (posedge clk or negedge rst_n)
begin :main_en_r
    if(!rst_n)
        main_en <= #1 1'b0;
    else
        main_en <= #1 bidin_sync_in | rd_main_en;
end

always @ (posedge clk or negedge rst_n)
begin :main_addr_r
    if(!rst_n)
        main_addr <= #1 'h0;
    else
        main_addr <= #1 bidin_sync_in ? wr_addr : rd_addr;
end

assign wr_first_24 = (wr_addr == 'd138239) | ( wr_addr == 'd146879 );

always @ (*)
begin
    if(state_idle) begin
        wr_addr_r = 9'h0;
        num_row_r = 9'd0;
        num_col_r = 9'd0;
        end
    else if(bidin_sync_in) begin
        if(!wr_hv) begin
            if(num_row == 9'd383) begin
                wr_addr_r = num_col + 1'b1;
                num_row_r = 9'd0;
                num_col_r = num_col + 1'b1;
             end
             else begin
                wr_addr_r = wr_addr + 9'd360;
                num_row_r = num_row + 1'b1;
                num_col_r = num_col;
             end
        end
        else begin
            if(num_col == 9'd359) begin
                wr_addr_r = 18'd138240 + (num_row * 'd24);
                num_row_r = num_row;
                num_col_r = num_col+1'b1;
                end
            else if(num_col == 9'd383) begin
                wr_addr_r = 360 * (num_row + 1'b1);
                num_row_r = num_row + 1'b1;
                num_col_r = 9'd0;
                end
            else begin
                wr_addr_r = wr_addr + 1'b1;
                num_row_r = num_row;
                num_col_r = num_col+1'b1;
                end
         end
    end	 
    else begin
        wr_addr_r = wr_addr ;
        num_row_r = num_row ;
        num_col_r = num_col ;
    end
end

always @ (posedge clk or negedge rst_n)
begin :wr_addr_d
    if(!rst_n)
        wr_addr <= #1 'h0;
    else
        wr_addr <= #1 wr_addr_r;
end

always @ (posedge clk or negedge rst_n)
begin : num_col_d
    if(!rst_n)
        num_col <= #1 9'h0;
    else
        num_col <= #1 num_col_r;
end

always @ (posedge clk or negedge rst_n)
begin : num_row_d
    if(!rst_n)
        num_row <= #1 9'h0;
    else
        num_row <= #1 num_row_r;
end

always @ (posedge clk or negedge rst_n)
begin :rd_addr_r
    if(!rst_n)
        rd_addr <= #1 'h0;
    else if(state_idle)
        rd_addr <= #1 'd9216;
    else if(rd_main_en) begin
        if(rd_full)
        rd_addr <= #1 'h0;
        else
        rd_addr <= #1 rd_addr + (rd_hv ? 'd360 : 'b1);
        end
end

always @ (posedge clk or negedge rst_n)
begin :wr_hv_r
    if(!rst_n)
        wr_hv <= #1 1'b0;
    else if(wr_full)
        wr_hv <= #1 ~wr_hv;
end

always @ (posedge clk or negedge rst_n)
begin : rd_hv_r
    if(!rst_n)
        rd_hv <= #1 1'b0;
    else if(rd_full)
        rd_hv <= #1 ~rd_hv;
end

// FSM state
always @ (posedge clk or negedge rst_n)
begin : fsm
    if(!rst_n)
        state <= #1 IDLE;
    else
        state <= #1 next_state;
end

always @ (*)
begin
    case(state)
    IDLE: begin
          if(bidin_sync_in)
              next_state = WR_1ST;
          else
              next_state = IDLE;
          end
    WR_1ST: begin
          if(rst_count)
              next_state = WR_FULL;
          else
              next_state = WR_1ST;
          end
    WR_FULL: begin
          if(main_rd_end)
              next_state = IDLE;
          else
              next_state = WR_FULL;
          end
     default: next_state = IDLE;
     endcase 
end

endmodule

