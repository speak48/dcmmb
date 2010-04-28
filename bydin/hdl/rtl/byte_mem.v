//Module
//
module byte_mem(
    clk        ,
    reset_n    ,
    byte_sync  ,
    byte_data  ,
    byte_win   ,
//    ofdm_mode  ,
//    ldpc_rate  ,
    bydin_mode ,
    slot_ini   ,
    slot_num   ,
    ts_en_rd   ,
    ts_new     ,
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
    ts_overflow,
    ts_en_out  ,
    ts_dout    ,
);
parameter   MAX_ROW = 9'd288   ;

input            clk           ;
input            reset_n       ;
input            byte_sync     ;
input   [7:0]    byte_data     ;
input            byte_win      ;
//input            ofdm_mode     ;
//input            ldpc_rate     ;
input   [2:0]    bydin_mode    ;
input            slot_ini      ;
input   [2:0]    slot_num      ;
input   [1:0]    rs_mode       ;
input            ts_en_rd      ;
input            rs_ena        ;
input            rs_finish     ;
input            rs_en_out     ;
input   [7:0]    rs_dout       ;
input            ts_new        ;

input   [7:0]    mem_do        ;
output [16:0]    mem_addr      ;
output  [7:0]    mem_di        ;
output           mem_wr        ;
output           mem_en        ;

output           rs_en_in      ;
output  [7:0]    rs_din        ;
output           ts_en_rs      ;

output           ts_int        ;
output           ts_overflow   ;
output           ts_en_out     ;
output  [7:0]    ts_dout       ;


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
//reg              rd2rs         ;
reg              rs_start      ;
reg              byte_read     ;
reg              mem_rd_dly    ;
reg              state_rd_r    ;
reg              rs_en_in      ;
reg              rs_dec_end    ;
reg              ts_overflow   ;
reg              slot_wr_en    ;
reg     [2:0]    slot_n        ;

reg     [8:0]    mi_r          ;
reg     [7:0]    k_r           ;
reg     [3:0]    next_fsm      ;
reg    [16:0]    addr_r        ;
reg     [7:0]    num_col_r     ;
reg     [8:0]    num_row_r     ;
reg     [2:0]    slot_n_r      ;

wire             state_idle    ;
wire             state_wr      ;
wire             write_end     ;
wire             read_end      ;
wire             rs_end        ;
wire    [7:0]    rs_din        ;
wire    [7:0]    ts_dout       ;
wire    [8:0]    total_row     ;
wire             col_jump      ;
wire             slot_match    ;
wire   [16:0]    slot_addr     ;

assign ts_dout  = data_out ;
assign rs_din   = data_out ;

assign mem_addr = addr ;
assign mem_en   = mem_wr | mem_rd ;
assign mem_di   = data_i;

assign state_idle = (fsm == IDLE   );
assign state_rs   = (fsm == RS_DEC );
assign state_rd   = (fsm == RD_OUT );
assign state_wr   = (fsm == WR_IN  );

assign total_row  = (mi_reg + 1'b1) * slot_num - 1'b1;
assign slot_match = slot_n == (slot_num - 1'b1);

assign write_end = state_wr & slot_match & (num_row == mi_reg) & ( num_col == 'd239);
assign read_end = state_rd & slot_match & (num_row == mi_reg) & ( num_col == k_reg) & byte_read;

assign rs_end = (num_row == total_row ) & rs_dec_end ;

assign col_jump = byte_read ? ( num_col == k_r ) : ( num_col == 'd239 );

assign slot_addr = ( mi_reg + 1'b1) * 'd240;

always @ (*)
begin
    case(bydin_mode)
    3'b001: mi_r = 9'd71 ;
    3'b010: mi_r = 9'd143;
    3'b011: mi_r = 9'd287;
    3'b101: mi_r = 9'd107;
    3'b110: mi_r = 9'd215;
    3'b111: mi_r = 9'd431;
    3'b000: mi_r = 9'd35 ;
    3'b100: mi_r = 9'd53 ;
    endcase
end

always @ (*)
begin
    case(rs_mode)	
    2'b00: k_r = 8'd239;
    2'b01: k_r = 8'd223;
    2'b10: k_r = 8'd191;
    2'b11: k_r = 8'd175;
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
    if(ts_overflow)
        next_fsm = IDLE;
    else begin	    
    case(fsm)
    IDLE: if(byte_win & byte_sync & slot_wr_en)
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
end

// Interrupt Generation
always @ (posedge clk or negedge reset_n)
begin: ts_int_r
    if(!reset_n)
        ts_int <= #1 1'b0;
    else
        ts_int <= #1 (fsm != RD_OUT) & ( next_fsm == RD_OUT);
end 

always @ (posedge clk or negedge reset_n)
begin: ts_overflow_r
    if(!reset_n)
        ts_overflow <= #1 1'b0;
    else
        ts_overflow <= #1 ( (fsm == RD_OUT) | (fsm == RS_DEC) ) & ts_new;
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

always @ (posedge clk or negedge reset_n)
begin : byte_read_d	
    if(!reset_n)
        byte_read <= #1 1'b0;
    else
        byte_read <= #1 state_rd & ts_en_rd ;	    
end

always @ (*)
begin	
    addr_r    = addr   ;	
    num_row_r = num_row;
    num_col_r = num_col;
    slot_n_r  = slot_n ;   
    if(state_idle | write_end | read_end | rs_end )  begin 
        addr_r = 17'h0;
        num_row_r = 9'h0;
        num_col_r = 8'h0;
        slot_n_r  = 3'h0;
        end
    else if((byte_sync & byte_win) | byte_read ) begin
    if(num_row == mi_reg)  begin   
            num_row_r = 9'h0;
//	    addr_r = addr + 1'b1;
        if(col_jump) begin
            num_col_r = 9'h0;
            addr_r    = slot_addr * ( slot_n + 1'b1 );
            slot_n_r  = slot_n + 1'b1; 
            end
        else  begin  
            num_col_r = num_col + 1'b1;
	    addr_r = addr + 1'b1;
//            addr_r = (mi_reg + 1'b1) * ( num_col + 1'b1) + (mi_reg + 1'b1) * slot_n;
            end
        end
    else begin
            addr_r = addr + 1'b1;	
            num_row_r = num_row + 1'b1;
        end
        end
    else if(state_rs) begin
        if(mem_rd) begin
            if(num_col == 'd239)begin
//                addr_r = num_row + 1'b1;
                addr_r    = num_row;                
                num_col_r = 8'h0;
//                num_row_r = num_row + 1'b1;
            end		
	    else begin	    
                addr_r = addr + mi_reg + 1'b1;       
                num_col_r = num_col + 1'b1;
            end            
        end   
    else begin
         if((num_col == k_reg) | rs_dec_end) begin
                addr_r = num_row + 1'b1;
                num_col_r = 8'h0;
                num_row_r = num_row + 1'b1;
                end
            else if(mem_wr) begin
                addr_r = addr + mi_reg + 1'b1;
                num_col_r = num_col + 1'b1;
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
begin : slot_n_d
    if(!reset_n)
        slot_n <= #1 3'h0;
    else
        slot_n <= #1 slot_n_r;
end

always @ (posedge clk or negedge reset_n)
begin : data_i_d
    if(!reset_n)
        data_i <= #1 8'h0;
    else if(byte_sync & byte_win)
        data_i <= #1 byte_data;        	    
    else if(state_rs & rs_en_out)
        data_i <= #1 rs_dout;
end

always @ (posedge clk or negedge reset_n)
begin : mem_wr_d
    if(!reset_n)
        mem_wr <= #1 1'b0;
    else 
        mem_wr <= #1 (byte_sync & byte_win ) | ( state_rs & rs_en_out);
end

always @ (posedge clk or negedge reset_n)
begin : mem_rd_d
    if(!reset_n)
        mem_rd <= #1 1'b0;
    else if(state_rs) begin
        if(num_col == 'd239)
        mem_rd <= #1 1'b0;
        else if( rs_start | (rs_dec_end & !rs_end) ) 
        mem_rd <= #1 1'b1;
        end
    else
        mem_rd <= #1 (state_rd & ts_en_rd );
end

always @ (posedge clk or negedge reset_n)
begin : mem_rd_d1
    if(!reset_n)
        mem_rd_dly <= #1 1'b0;
    else
        mem_rd_dly <= #1 mem_rd;
end

always @ (posedge clk or negedge reset_n)
begin : data_out_r
    if(!reset_n)
        data_out <= #1 8'h0;
    else if(mem_rd_dly)
        data_out <= #1 mem_do;
end
/*
always @ (posedge clk or negedge reset_n)
begin : rd2rs_d
    if(!reset_n)
        rd2rs <= #1 1'b0;
    else if(num_col == 'd239)
        rd2rs <= #1 1'b0;
    else if( rs_start | rs_dec_end ) 
        rd2rs <= #1 1'b1;
end
*/
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
        ts_en_out <= #1 mem_rd_dly & state_rd_r;
end

always @ (posedge clk or negedge reset_n)
begin : state_rd_d	
    if(!reset_n)
        state_rd_r <= #1 1'b0;
    else
        state_rd_r <= #1 state_rd;
end

always @ (posedge clk or negedge reset_n)
begin : rs_en_in_d
    if(!reset_n)	
        rs_en_in <= #1 1'b0;
    else 
        rs_en_in <= #1 mem_rd_dly & state_rs;
end

always @ (posedge clk or negedge reset_n)
begin : rs_dec_end_d
    if(!reset_n)
        rs_dec_end <= #1 1'b0;
    else
        rs_dec_end <= #1 rs_finish;	    
end

always @ (posedge clk or negedge reset_n)
begin : wr_en_r
    if(!reset_n)	
        slot_wr_en <= #1 1'b0;
    else if(write_end)
        slot_wr_en <= #1 1'b0;    
    else if(slot_ini)
        slot_wr_en <= #1 1'b1;
end

endmodule
