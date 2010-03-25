module main_man(
    clk          ,
    rst_n        ,
    bidin_sync_in,
    bidin_ena_in ,
    bidin_din    ,
    ldpc_req     ,
    ldpc_fin     ,
    bidin_rdy    ,
    bidin_full   ,
    bidin_ena_out,
    bidin_dout   ,

    
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
input                     ldpc_fin     ;

output                    bidin_rdy    ;
output                    bidin_ena_out;
output  [WID-1:0]         bidin_dout   ;
output                    bidin_full   ;

    
output  [17:0]            main_addr    ;
output  [WID-1:0]         main_data_i  ;
input   [WID-1:0]         main_data_o  ;
output                    main_en      ;
output                    main_wr      ;

parameter     IDLE    = 'h1,
              WR_1ST  = 'h2,
              WR_MORE   = 'h4;

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
reg                       dv_dly       ;
reg      [WID-1:0]        dt_dly       ;
reg         [17:0]        count        ;
reg                       bidin_rdy    ;
reg         [8:0]         num_row      ;
reg         [8:0]         num_col      ;
reg         [8:0]         num_row_r    ;
reg         [8:0]         num_col_r    ;
reg         [17:0]        wr_addr_r    ;
reg         [17:0]        rd_addr_r    ;
reg         [8:0]         num1_row     ;
reg         [8:0]         num1_col     ;
reg         [8:0]         num1_row_r   ;
reg         [8:0]         num1_col_r   ;
reg                       bidin_full   ;
reg      [WID-1:0]        bidin_dout   ;
reg                       bidin_ena_out;
reg                       main_rd_dly  ;

wire                      wr_full      ;
wire                      rd_full      ;
wire                      state_idle   ;
wire                      rst_count    ;

assign state_idle = (state == IDLE   );
assign wr_full = (wr_addr == 'd138239) | ( wr_addr == 'd146879);
assign rd_full = (rd_addr == 'd138239) | ( rd_addr == 'd146879);

assign rst_count = (count == 'd138239);

always @ (posedge clk or negedge rst_n)
begin :count_r
    if(!rst_n)
        count <= # 18'd0;
    else if(bidin_ena_in) begin
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
begin :dv_d
    if(!rst_n)
        dv_dly <= #1 1'b0;
    else
        dv_dly <= #1 bidin_ena_in;
end

always @ (posedge clk or negedge rst_n)
begin :main_wr_r
    if(!rst_n)
        main_wr <= #1 1'b0;
    else
        main_wr <= #1 dv_dly;
end

always @ (posedge clk or negedge rst_n)
begin : dt_d
    if(!rst_n)
        dt_dly <= #1 'h0;
    else
        dt_dly <= #1 bidin_din;
end

always @ (posedge clk or negedge rst_n)
begin :main_di_r
    if(!rst_n)
        main_data_i <= #1 'h0;
    else if(dv_dly)
        main_data_i <= #1 dt_dly;
end 

always @ (posedge clk or negedge rst_n)
begin :main_en_r
    if(!rst_n)
        main_en <= #1 1'b0;
    else
        main_en <= #1 dv_dly | ldpc_req;
end

always @ (posedge clk or negedge rst_n)
begin :main_addr_r
    if(!rst_n)
        main_addr <= #1 'h0;
    else
        main_addr <= #1 dv_dly ? wr_addr : rd_addr;
end


always @ (*)
begin
    if(state_idle | wr_full) begin
        wr_addr_r = 9'h0;
        num_row_r = 9'd0;
        num_col_r = 9'd0;
        end
    else if(dv_dly) begin
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

always @ (*)
begin
    if(state_idle | rd_full) begin
        rd_addr_r = 9'h0;
        num1_row_r = 9'd0;
        num1_col_r = 9'd0;
        end
    else if(ldpc_req) begin
        if(!rd_hv) begin
                rd_addr_r = rd_addr + 1'b1;
                num1_row_r = 9'h0;
                num1_col_r = 9'h0;
        end
        else begin
            if((num1_col == 9'd359) && ( num1_row == 9'd359)) begin
                rd_addr_r = 'd138240;
		num1_row_r = 9'h0;
		num1_col_r = num1_col + 1'b1;
            end
	    else if(num1_col > 9'd359) begin
                if(num1_row == 9'd359) begin
		    rd_addr_r  = 'd138240 + num1_col - 9'd359;
                    num1_row_r = 9'h0;
	            num1_col_r = num1_col + 1'b1;
                end
                else begin
                    rd_addr_r = rd_addr + 'd24;
                    num1_row_r = num1_row + 1'b1;
                    num1_col_r = num1_col;
                end		    
            end
            else begin
                if(num1_row == 9'd359) begin
                    rd_addr_r = num1_col + 1'b1;                 
                    num1_row_r = 9'h0;
                    num1_col_r = num1_col + 1'b1;
                end
		else begin	   
		    rd_addr_r = rd_addr + 9'd360;
                    num1_row_r = num1_row + 1'b1;
                    num1_col_r = num1_col;
                end
	    end
        end
    end	    
    else begin
        rd_addr_r = rd_addr ;
        num1_row_r = num1_row ;
        num1_col_r = num1_col ;
    end
end

always @ (posedge clk or negedge rst_n)
begin :rd_addr_d
    if(!rst_n)
        rd_addr <= #1 'h0;
    else
        rd_addr <= #1 rd_addr_r;
end

always @ (posedge clk or negedge rst_n)
begin : num1_col_d
    if(!rst_n)
        num1_col <= #1 9'h0;
    else
        num1_col <= #1 num1_col_r;
end

always @ (posedge clk or negedge rst_n)
begin : num1_row_d
    if(!rst_n)
        num1_row <= #1 9'h0;
    else
        num1_row <= #1 num1_row_r;
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
              next_state = WR_MORE;
          else
              next_state = WR_1ST;
          end
    WR_MORE: begin
          if(rd_full & (count == 'h0))
              next_state = IDLE;
          else
              next_state = WR_MORE;
          end
     default: next_state = IDLE;
     endcase 
end

always @ (posedge clk or negedge rst_n)
begin : bidin_full_r
    if(!rst_n)	
        bidin_full <= #1 1'b0;
    else if((count =='d138237) | ( ldpc_fin & rd_addr != 0) )
	bidin_full <= #1 1'b1;
    else if(!main_en & main_rd_dly)
	bidin_full <= #1 1'b0;
end

always @ (posedge clk or negedge rst_n)
begin : bidin_dout_r
    if(!rst_n)
        bidin_dout <= #1 'h0;
    else if(main_rd_dly)
        bidin_dout <= #1 main_data_o;
end

always @ (posedge clk or negedge rst_n)
begin : bidin_ena_r
    if(!rst_n)
        bidin_ena_out <= #1 1'b0;
    else
        bidin_ena_out <= #1 main_rd_dly;
end

always @ (posedge clk or negedge rst_n)
begin : main_rd_d
    if(!rst_n)	
        main_rd_dly <= #1 1'b0;
    else
        main_rd_dly <= #1 main_en & (!main_wr);
end

endmodule

