//Module
//
module byte_mem(
    clk        ,
    reset_n    ,
    byte_sync  ,
    byte_data  ,
    byte_win   ,
    ofdm_mode  ,
    ldpc_rate  ,
    bydin_mode ,
    ts_en_rd   ,
    rs_ena     ,
    rs_mode    ,
    rs_finish  ,
    rs_en_out  ,
    rs_dout    ,

    mem_addr   ,
    mem_wr     ,
    mem_en     ,
    mem_di     ,
    mem_do     ,

    rs_en_in   ,
    rs_din     ,
    ts_en_rs   ,

    ts_int     ,
    ts_en_out  ,
    ts_dout    ,
);

input            clk           ;
input            reset_n       ;
input            byte_sync     ;
input   [7:0]    byte_data     ;
input            byte_win      ;
input            ofdm_mode     ;
input            ldpc_rate     ;
input   [2:0]    bydin_mode    ;
input   [1:0]    rs_mode       ;
input            ts_en_rd      ;
input            rs_ena        ;
input            rs_finish     ;
input            rs_en_out     ;
input   [7:0]    rs_dout       ;

input   [7:0]    mem_do        ;
output [16:0]    mem_addr      ;
output  [7:0]    mem_di        ;
output           mem_wr        ;
output           mem_en        ;

output           rs_en_in      ;
output  [7:0]    rs_din        ;
output           ts_en_rs      ;

output           ts_int        ;
output           ts_en_out     ;
output  [7:0]    ts_dout       ;


parameter   MAX_ROW = 9'd432   ;

parameter   IDLE   = 4'b0001   ,
            WR_IN  = 4'b0010   ,
            RS_DEC = 4'b0100   ,
            RD_OUT = 4'b1000   ;	    


reg     [8:0]    mi_reg        ;
reg     [7:0]    k_reg         ;
reg     [3:0]    fsm           ;
reg    [16:0]    addr          ;
reg     [7:0]    num_col       ;
reg     [8:0]    num_row       ;
reg              ts_int        ;
reg              ts_en_out     ;
reg              ts_en_rs      ;
reg     [7:0]    data_i        ;
reg              mem_wr        ;
reg              mem_rd        ;
reg     [7:0]    data_out      ;
reg              rd2rs         ;
reg              rs_start      ;

reg     [8:0]    mi_r          ;
reg     [7:0]    k_r           ;
reg     [3:0]    next_fsm      ;
reg    [16:0]    addr_r        ;
reg     [7:0]    num_col_r     ;
reg     [8:0]    num_row_r     ;


wire             state_idle    ;
wire             write_end     ;
wire             read_end      ;
wire             rs_end        ;

assign ts_dout  = data_out ;
assign rs_dout  = data_out ;

assign mem_addr = addr ;
assign mem_en   = mem_wr | mem_rd ;
assign mem_di   = data_i;

assign state_idle = (fsm == IDLE   );
assign state_rs   = (fsm == RS_DEC );
assign state_rd   = (fsm == RD_OUT );
assign write_end = (num_row == mi_reg) & ( num_col == 'd239);
assign read_end = state_rd & (num_row == mi_reg) & ( num_col == k_reg);
assign rs_end = (num_row == mi_reg) & ( num_col == k_reg ) & rs_finish ;

always @ (*)
begin
    case({ofdm_mode, ldpc_rate, bydin_mode})
    5'b0_0_001: mi_r = 9'd71 ;
    5'b0_0_010: mi_r = 9'd143;
    5'b0_0_100: mi_r = 9'd287;
    5'b0_1_001: mi_r = 9'd107;
    5'b0_1_010: mi_r = 9'd215;
    5'b0_1_100: mi_r = 9'd431;
    5'b1_0_001: mi_r = 9'd35 ;
    5'b1_0_010: mi_r = 9'd71 ;
    5'b1_0_100: mi_r = 9'd143;
    5'b1_1_001: mi_r = 9'd53 ;
    5'b1_1_010: mi_r = 9'd107;
    5'b1_1_100: mi_r = 9'd215;
    default   : mi_r = 9'd0;
    endcase
end

always @ (*)
begin
    case(rs_mode)	
    2'b00: k_r = 8'd240;
    2'b01: k_r = 8'd224;
    2'b10: k_r = 8'd192;
    2'b11: k_r = 8'd176;
    endcase
end

always @ (posedge clk or negedge reset_n)
begin : para_reg
    if(!reset_n) begin
        mi_reg <= #1 9'h0;
	k_reg  <= #1 8'h0; end
    else //if()
    begin    
        mi_reg <= #1 mi_r;
        k_reg  <= #1 k_r;
    end
end   

always @ (posedge clk or negedge reset_n)
begin : fsm_reg
    if(!reset_n)
        fsm <= #1 IDLE;
    else
        fsm <= #1 next_fsm;
end

always @ (*)
begin
    case(fsm)
    IDLE: if(byte_win & byte_sync)
              next_fsm = WR_IN;
          else
              next_fsm = IDLE;
    WR_IN: if(write_end) begin
              if(rs_ena)
                  next_fsm = RS_DEC;
              else
                  next_fsm = RD_OUT;end
          else  
              next_fsm = WR_IN;
    RS_DEC: if(rs_end)
              next_fsm = RD_OUT;
          else
              next_fsm = RS_DEC;
    RD_OUT: if(read_end)
              next_fsm = IDLE;
          else
              next_fsm = RD_OUT;
    endcase
end

// Interrupt Generation
always @ (posedge clk or negedge reset_n)
begin: ts_int_r
    if(!reset_n)
         ts_int = 1'b0;
    else
         ts_int = (fsm != RD_OUT) & ( next_fsm == RD_OUT);
end 

always @ (posedge clk or negedge reset_n)
begin : ts_en_rs_d
    if(!reset_n)
        ts_en_rs <= #1 1'b0;
    else if(rs_end)
	ts_en_rs <= #1 1'b0;
    else if(write_end & rs_ena)
        ts_en_rs <= #1 1'b1;
end

always @ (*)
begin	
    addr_r    = addr   ;	
    num_row_r = num_row;
    num_col_r = num_col;    
    if(state_idle | write_end | read_end)  begin 
        addr_r = 17'h0;
        num_row_r = 9'h0;
        num_col_r = 8'h0;
        end
    else if(byte_sync | ts_en_rd) begin
	if(num_row == mi_reg)  begin   
            addr_r = MAX_ROW * ( num_col + 1'b1);
            num_row_r = 9'h0;
            num_col_r = num_col + 1'b1;
        end
	else begin
	    addr_r = addr + 1'b1;	
            num_row_r = num_row + 1'b1;
        end
        end
    else if(state_rs) begin
        if(rd2rs) begin
            if(num_col == 'd239)begin
//                addr_r = num_row + 1'b1;
                addr_r    = num_row;                
	        num_col_r = 8'h0;
//		num_row_r = num_row + 1'b1;
            end		
	    else begin	    
                addr_r = addr + MAX_ROW;       
                num_col_r = num_col + 1'b1;
            end            
        end   
	else begin
      	    if((num_col == k_reg) | rs_finish) begin
                addr_r = num_row + 1'b1;
                num_col_r = 8'h0;
		num_row_r = num_row + 1'b1;
                end
            else if(mem_wr) begin
                addr_r = addr + MAX_ROW;
                num_col = num_col + 1'b1;
            end
	end
    end
end

always @ (posedge clk or negedge reset_n)
begin : addr_d
    if(!reset_n)
        addr <= #1 'h0;
    else
        addr <= #1 addr_r;
end

always @ (posedge clk or negedge reset_n)
begin : num_col_d
    if(!reset_n)
        num_col <= #1 8'h0;
    else
        num_col <= #1 num_col_r;
end

always @ (posedge clk or negedge reset_n)
begin : num_row_d
    if(!reset_n)
        num_row <= #1 9'h0;
    else
        num_row <= #1 num_row_r;
end

always @ (posedge clk or negedge reset_n)
begin : data_i_d
    if(!reset_n)
        data_i <= #1 8'h0;
    else if(byte_sync & byte_win)
        data_i <= #1 byte_data;        	    
    else if(state_rs & ts_en_out)
        data_i <= #1 ts_dout;
end

always @ (posedge clk or negedge reset_n)
begin : mem_wr_d
    if(!reset_n)
        mem_wr <= #1 1'b0;
    else 
        mem_wr <= #1 (byte_sync & byte_win ) | ( state_rs & ts_en_out);
end

always @ (posedge clk or negedge reset_n)
begin : mem_rd_d
    if(!reset_n)
        mem_rd <= #1 1'b0;
    else
	mem_rd <= #1 (state_rd & ts_en_rd ) | ( state_rs & rd2rs );
end

always @ (posedge clk or negedge reset_n)
begin : data_out_r
    if(!reset_n)
        data_out <= #1 8'h0;
    else if(mem_rd)
	data_out <= #1 mem_do;
end

always @ (posedge clk or negedge reset_n)
begin : rd2rs_d
    if(!reset_n)
        rd2rs <= #1 1'b0;
    else if(num_col == 'd239)
	rd2rs <= #1 1'b0;
    else if( rs_start | rs_finish ) 
	rd2rs <= #1 1'b1;
end

always @ (posedge clk or negedge reset_n)
begin : rs_start_d
    if(!reset_n)
	rs_start <= #1 1'b0;
    else
        rs_start <= #1  (fsm == WR_IN ) & ( next_fsm == RS_DEC);
end

always @ (posedge clk or negedge reset_n)
begin : ts_en_d
    if(!reset_n)
	ts_en_out <= #1 1'b0;
    else
        ts_en_out <= #1 state_rd & mem_rd;
end

endmodule
