//Module
//
module byte_mem(
    clk        ,
    reset_n    ,
    ts0_mem_ad ,
    ts0_mem_di ,
    ts0_mem_do ,
    ts0_mem_en ,
    ts0_mem_wr ,
    ts0_mdo_en ,
    ts1_mem_ad ,
    ts1_mem_di ,
    ts1_mem_do ,
    ts1_mem_en ,
    ts1_mem_wr ,
    ts1_mdo_en ,
    m0_addr    ,
    m0_di      ,
    m0_en      ,
    m0_wr      ,
    m0_do      ,
    m1_addr    ,
    m1_di      ,
    m1_en      ,
    m1_wr      ,
    m1_do      
    
);

//inputs
input            clk           ;
input            reset_n       ;

output  [7:0]    ts0_mem_do    ;
output           ts0_mdo_en    ;
input  [16:0]    ts0_mem_ad    ;
input   [7:0]    ts0_mem_di    ;
input            ts0_mem_wr    ;
input            ts0_mem_en    ; 

output  [7:0]    ts1_mem_do    ;
output           ts1_mdo_en    ;
input  [16:0]    ts1_mem_ad    ;
input   [7:0]    ts1_mem_di    ;
input            ts1_mem_wr    ;
input            ts1_mem_en    ; 

output [16:0]    m0_addr       ;
output   [7:0]   m0_di         ;
output           m0_en         ;
output           m0_wr         ;
input    [7:0]   m0_do         ;

output [16:0]    m1_addr       ;
output   [7:0]   m1_di         ;
output           m1_en         ;
output           m1_wr         ;
input    [7:0]   m1_do         ;

reg              ts0_mdo_en    ;
reg              ts1_mdo_en    ;

assign m0_addr = ts0_mem_ad    ;
assign m0_di   = ts0_mem_di    ;
assign m0_en   = ts0_mem_en    ;
assign m0_wr   = ts0_mem_wr    ;
assign ts0_mem_do = m0_do      ;

assign m1_addr = ts1_mem_ad    ;
assign m1_di   = ts1_mem_di    ;
assign m1_en   = ts1_mem_en    ;
assign m1_wr   = ts1_mem_wr    ;
assign ts1_mem_do = m1_do      ;

always @ (posedge clk or negedge reset_n)
begin : ts0_mdo_en_r
    if(!reset_n)
        ts0_mdo_en <= #1 1'b0;
    else
        ts0_mdo_en <= #1 ts0_mem_en & ( !ts0_mem_wr ) ;
end

always @ (posedge clk or negedge reset_n)
begin : ts1_mdo_en_r
    if(!reset_n)
        ts1_mdo_en <= #1 1'b0;
    else
        ts1_mdo_en <= #1 ts1_mem_en & ( !ts1_mem_wr ) ;
end

endmodule
