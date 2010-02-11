module vtc_cell(
    clk,
    reset_n,
    sync_in,
    data_in,
    fsm,
    code_rate,

    ram_addr,
    ram_wr,
    ram_d 
);

//Parameter
parameter D_WID = 6;
parameter A_WID = 8;

//Input ports
input                 clk        ;
input                 reset_n    ;
input                 code_rate  ;
input   [D_WID-1:0]   data_in    ; // LLR input
input                 sync_in    ;
input   [3:0]         fsm        ;

output  [A_WID-1:0]   ram_addr   ;
output                ram_wr     ;
output  [D_WID-1:0]   ram_d      ;

reg     [A_WID-1:0]   ram_addr   ;
reg                   ram_wr     ;
reg     [D_WID-1:0]   ram_d      ;

always @ (posedge clk or negedge reset_n)
begin : addr_r
    if(!reset_n)
        ram_addr <= #1 1'b0;
    else begin
    case(fsm)
    4'b0010:
	if(ram_wr)    
	ram_addr <= #1 ram_addr + 1'b1;
    default:
        ram_addr <= #1 1'b0;
    endcase
    end
end    

always @ (posedge clk or negedge reset_n)
begin : wr_r
    if(!reset_n)
        ram_wr <= #1 1'b0;
    else if(fsm[1])
	ram_wr <= #1 sync_in;
end

always @ (posedge clk or negedge reset_n)
begin : data_in_r
    if(!reset_n)
         ram_d <= #1 'h0;
    else if(sync_in)
	 ram_d <= #1 data_in;
end

endmodule
