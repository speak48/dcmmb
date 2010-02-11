//////////////////////////
//
//copyright 2009, SHHIC
//all right reserved
//
//project name: hongqiao
//filename    : ldpc_ram.v
//author      : Li Gang
//date        : 2009/10/20
//version     : 0.1
//
//module name : ldpc_ram
//discription : 
//
//modification history
//---------------------------------
//&Log&
//
//////////////////////////

module ldpc_ram    (    clk          ,
                        reset_n      ,
                        wren         ,
                        addr         ,
                        din          ,
                        dout         );
                        
input       clk      ;
input       reset_n  ;
input [7:0] addr     ;
input [6:0] din      ;
input       wren     ;

output[6:0] dout     ;


reg  [7:0] wr_addr ;
reg  [6:0] wr_din  ; 
reg        wr_en   ;

wire [7:0] rd_addr ;

assign  rd_addr=addr;

always @ (posedge clk or negedge reset_n )  begin
    if (!reset_n ) begin
        wr_addr <= 0;
        wr_din  <= 0;
        wr_en   <= 1'b0 ;
    end
    else begin
        wr_addr <= addr;
        wr_din  <= din;
        wr_en   <= wren;
    end
end





 ldpc_ram_dm   u_ldpc_ram_dm (
	                        .clk      (clk),
	                        .d        (wr_din),
	                        .a        (wr_addr),
	                        .we       (wr_en),
	                        .qdpo_clk (clk),
	                        .dpra     (rd_addr),
	                        .qdpo     (dout)
	                       );

	
endmodule	                               

