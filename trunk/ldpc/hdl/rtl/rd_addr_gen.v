module rd_addr_gen(
    clk,
    reset_n,
    fsm,
    cycle,
    rate,
    rd_addr00,
    rd_addr01,
    rd_addr02,
    rd_addr03,
    rd_addr04,
    rd_addr05,
    rd_addr06,
    rd_addr07,
    rd_addr08,
    rd_addr09,
    rd_addr10,
    rd_addr11,
    rd_addr12,
    rd_addr13,
    rd_addr14,
    rd_addr15,
    rd_addr16,
    rd_addr17,
    rd_addr18,
    rd_addr19,
    rd_addr20,
    rd_addr21,
    rd_addr22,
    rd_addr23,
    rd_addr24,
    rd_addr25,
    rd_addr26,
    rd_addr27,
    rd_addr28,
    rd_addr29,
    rd_addr30,
    rd_addr31,
    rd_addr32,
    rd_addr33,
    rd_addr34,
    rd_addr35
);  

parameter A_WID = 8;
   
//Input ports                     
input                 clk        ;
input                 reset_n    ;
input                 rate       ;
input   [3:0]         fsm        ;
input   [1:0]         cycle      ;

//Output ports
output  [A_WID-1:0]   rd_addr00  ;
output  [A_WID-1:0]   rd_addr01  ;
output  [A_WID-1:0]   rd_addr02  ;
output  [A_WID-1:0]   rd_addr03  ;
output  [A_WID-1:0]   rd_addr04  ;
output  [A_WID-1:0]   rd_addr05  ;
output  [A_WID-1:0]   rd_addr06  ;
output  [A_WID-1:0]   rd_addr07  ;
output  [A_WID-1:0]   rd_addr08  ;
output  [A_WID-1:0]   rd_addr09  ;
output  [A_WID-1:0]   rd_addr10  ;
output  [A_WID-1:0]   rd_addr11  ;
output  [A_WID-1:0]   rd_addr12  ;
output  [A_WID-1:0]   rd_addr13  ;
output  [A_WID-1:0]   rd_addr14  ;
output  [A_WID-1:0]   rd_addr15  ;
output  [A_WID-1:0]   rd_addr16  ;
output  [A_WID-1:0]   rd_addr17  ;
output  [A_WID-1:0]   rd_addr18  ;
output  [A_WID-1:0]   rd_addr19  ;
output  [A_WID-1:0]   rd_addr20  ;
output  [A_WID-1:0]   rd_addr21  ;
output  [A_WID-1:0]   rd_addr22  ;
output  [A_WID-1:0]   rd_addr23  ;
output  [A_WID-1:0]   rd_addr24  ;
output  [A_WID-1:0]   rd_addr25  ;
output  [A_WID-1:0]   rd_addr26  ;
output  [A_WID-1:0]   rd_addr27  ;
output  [A_WID-1:0]   rd_addr28  ;
output  [A_WID-1:0]   rd_addr29  ;
output  [A_WID-1:0]   rd_addr30  ;
output  [A_WID-1:0]   rd_addr31  ;
output  [A_WID-1:0]   rd_addr32  ;
output  [A_WID-1:0]   rd_addr33  ;
output  [A_WID-1:0]   rd_addr34  ;
output  [A_WID-1:0]   rd_addr35  ;    

wire    [A_WID-1:0]   rd_addr00  ;
wire    [A_WID-1:0]   rd_addr01  ;
wire    [A_WID-1:0]   rd_addr02  ;
wire    [A_WID-1:0]   rd_addr03  ;
wire    [A_WID-1:0]   rd_addr04  ;
wire    [A_WID-1:0]   rd_addr05  ;
wire    [A_WID-1:0]   rd_addr06  ;
wire    [A_WID-1:0]   rd_addr07  ;
wire    [A_WID-1:0]   rd_addr08  ;
wire    [A_WID-1:0]   rd_addr09  ;
wire    [A_WID-1:0]   rd_addr10  ;
wire    [A_WID-1:0]   rd_addr11  ;
wire    [A_WID-1:0]   rd_addr12  ;
wire    [A_WID-1:0]   rd_addr13  ;
wire    [A_WID-1:0]   rd_addr14  ;
wire    [A_WID-1:0]   rd_addr15  ;
wire    [A_WID-1:0]   rd_addr16  ;
wire    [A_WID-1:0]   rd_addr17  ;
wire    [A_WID-1:0]   rd_addr18  ;
wire    [A_WID-1:0]   rd_addr19  ;
wire    [A_WID-1:0]   rd_addr20  ;
wire    [A_WID-1:0]   rd_addr21  ;
wire    [A_WID-1:0]   rd_addr22  ;
wire    [A_WID-1:0]   rd_addr23  ;
wire    [A_WID-1:0]   rd_addr24  ;
wire    [A_WID-1:0]   rd_addr25  ;
wire    [A_WID-1:0]   rd_addr26  ;
wire    [A_WID-1:0]   rd_addr27  ;
wire    [A_WID-1:0]   rd_addr28  ;
wire    [A_WID-1:0]   rd_addr29  ;
wire    [A_WID-1:0]   rd_addr30  ;
wire    [A_WID-1:0]   rd_addr31  ;
wire    [A_WID-1:0]   rd_addr32  ;
wire    [A_WID-1:0]   rd_addr33  ;
wire    [A_WID-1:0]   rd_addr34  ;
wire    [A_WID-1:0]   rd_addr35  ; 
wire  [3*A_WID-1:0]   offset00   ;
wire  [3*A_WID-1:0]   offset01   ;
wire  [3*A_WID-1:0]   offset02   ;
wire  [3*A_WID-1:0]   offset03   ;
wire  [3*A_WID-1:0]   offset04   ;
wire  [3*A_WID-1:0]   offset05   ;
wire  [3*A_WID-1:0]   offset06   ;
wire  [3*A_WID-1:0]   offset07   ;
wire  [3*A_WID-1:0]   offset08   ;
wire  [3*A_WID-1:0]   offset09   ;
wire  [3*A_WID-1:0]   offset10   ;
wire  [3*A_WID-1:0]   offset11   ;
wire  [3*A_WID-1:0]   offset12   ;
wire  [3*A_WID-1:0]   offset13   ;
wire  [3*A_WID-1:0]   offset14   ;
wire  [3*A_WID-1:0]   offset15   ;
wire  [3*A_WID-1:0]   offset16   ;
wire  [3*A_WID-1:0]   offset17   ;
wire  [3*A_WID-1:0]   offset18   ;
wire  [3*A_WID-1:0]   offset19   ;
wire  [3*A_WID-1:0]   offset20   ;
wire  [3*A_WID-1:0]   offset21   ;
wire  [3*A_WID-1:0]   offset22   ;
wire  [3*A_WID-1:0]   offset23   ;
wire  [3*A_WID-1:0]   offset24   ;
wire  [3*A_WID-1:0]   offset25   ;
wire  [3*A_WID-1:0]   offset26   ;
wire  [3*A_WID-1:0]   offset27   ;
wire  [3*A_WID-1:0]   offset28   ;
wire  [3*A_WID-1:0]   offset29   ;
wire  [3*A_WID-1:0]   offset30   ;
wire  [3*A_WID-1:0]   offset31   ;
wire  [3*A_WID-1:0]   offset32   ;
wire  [3*A_WID-1:0]   offset33   ;
wire  [3*A_WID-1:0]   offset34   ;
wire  [3*A_WID-1:0]   offset35   ;

reg     [A_WID-1:0]   rd_counter ;
wire                  rd_en      ;

assign rd_en = fsm[2];
assign offset00  =  {8'd0,8'd0,8'd0};
assign offset01  =  {8'd0,8'd0,8'd0};
assign offset02  =  {8'd0,8'd0,8'd0};
assign offset03  =  {8'd0,8'd0,8'd0};
assign offset04  =  {8'd0,8'd0,8'd0}; 
assign offset05  =  {8'd0,8'd0,8'd0};
assign offset06  =  {8'd0,8'd0,8'd0};
assign offset07  =  {8'd0,8'd0,8'd0};
assign offset08  =  {8'd0,8'd255,8'd0};
assign offset09  =  {8'd0,8'd129,8'd65};
assign offset10  =  {8'd0,8'd224,8'd240};
assign offset11  =  {8'd0,8'd216,8'd236};
assign offset12  =  {8'd0,8'd157,8'd250};
assign offset13  =  {8'd0,8'd132,8'd242};
assign offset14  =  {8'd0,8'd184,8'd247};
assign offset15  =  {8'd0,8'd254,8'd240};
assign offset16  =  {8'd0,8'd115,8'd242};
assign offset17  =  {8'd0,8'd209,8'd164};
assign offset18  =  {8'd0,8'd255,8'd248};
assign offset19  =  {8'd0,8'd246,8'd58};
assign offset20  =  {8'd0,8'd253,8'd215};
assign offset21  =  {8'd0,8'd252,8'd209};
assign offset22  =  {8'd0,8'd146,8'd249};
assign offset23  =  {8'd0,8'd231,8'd250};
assign offset24  =  {8'd254,8'd200,8'd0};
assign offset25  =  {8'd0,8'd85,8'd235};
assign offset26  =  {8'd0,8'd229,8'd69};
assign offset27  =  {8'd0,8'd203,8'd254};
assign offset28  =  {8'd0,8'd131,8'd251};
assign offset29  =  {8'd0,8'd115,8'd254};
assign offset30  =  {8'd0,8'd253,8'd255};  
assign offset31  =  {8'd0,8'd248,8'd254};
assign offset32  =  {8'd0,8'd255,8'd243}; 
assign offset33  =  {8'd0,8'd239,8'd253}; 
assign offset34  =  {8'd0,8'd248,8'd215}; 
assign offset35  =  {8'd0,8'd252,8'd164}; 
 
always @ (posedge clk or negedge reset_n)
begin : rd_counter_r
    if(!reset_n)
        rd_counter <= #1 8'h0;
    else if(fsm[2]) begin 
        if ( cycle == 2'b11)
        rd_counter <= #1 rd_counter + 1'b1;
        else
        rd_counter <= #1 rd_counter;
        end
    else
        rd_counter <= #1 8'h0;
end

rd_cell rd_cell00(.clk(clk),.reset_n(reset_n),.en(rd_en),.cycle(cycle),.base_addr(rd_counter),.addr_offset(offset00),.rd_addr(rd_addr00));
rd_cell rd_cell01(.clk(clk),.reset_n(reset_n),.en(rd_en),.cycle(cycle),.base_addr(rd_counter),.addr_offset(offset01),.rd_addr(rd_addr01));
rd_cell rd_cell02(.clk(clk),.reset_n(reset_n),.en(rd_en),.cycle(cycle),.base_addr(rd_counter),.addr_offset(offset02),.rd_addr(rd_addr02));
rd_cell rd_cell03(.clk(clk),.reset_n(reset_n),.en(rd_en),.cycle(cycle),.base_addr(rd_counter),.addr_offset(offset03),.rd_addr(rd_addr03));
rd_cell rd_cell04(.clk(clk),.reset_n(reset_n),.en(rd_en),.cycle(cycle),.base_addr(rd_counter),.addr_offset(offset04),.rd_addr(rd_addr04));
rd_cell rd_cell05(.clk(clk),.reset_n(reset_n),.en(rd_en),.cycle(cycle),.base_addr(rd_counter),.addr_offset(offset05),.rd_addr(rd_addr05));
rd_cell rd_cell06(.clk(clk),.reset_n(reset_n),.en(rd_en),.cycle(cycle),.base_addr(rd_counter),.addr_offset(offset06),.rd_addr(rd_addr06));
rd_cell rd_cell07(.clk(clk),.reset_n(reset_n),.en(rd_en),.cycle(cycle),.base_addr(rd_counter),.addr_offset(offset07),.rd_addr(rd_addr07));
rd_cell rd_cell08(.clk(clk),.reset_n(reset_n),.en(rd_en),.cycle(cycle),.base_addr(rd_counter),.addr_offset(offset08),.rd_addr(rd_addr08));
rd_cell rd_cell09(.clk(clk),.reset_n(reset_n),.en(rd_en),.cycle(cycle),.base_addr(rd_counter),.addr_offset(offset09),.rd_addr(rd_addr09));
rd_cell rd_cell10(.clk(clk),.reset_n(reset_n),.en(rd_en),.cycle(cycle),.base_addr(rd_counter),.addr_offset(offset10),.rd_addr(rd_addr10));
rd_cell rd_cell11(.clk(clk),.reset_n(reset_n),.en(rd_en),.cycle(cycle),.base_addr(rd_counter),.addr_offset(offset11),.rd_addr(rd_addr11));
rd_cell rd_cell12(.clk(clk),.reset_n(reset_n),.en(rd_en),.cycle(cycle),.base_addr(rd_counter),.addr_offset(offset12),.rd_addr(rd_addr12));
rd_cell rd_cell13(.clk(clk),.reset_n(reset_n),.en(rd_en),.cycle(cycle),.base_addr(rd_counter),.addr_offset(offset13),.rd_addr(rd_addr13));
rd_cell rd_cell14(.clk(clk),.reset_n(reset_n),.en(rd_en),.cycle(cycle),.base_addr(rd_counter),.addr_offset(offset14),.rd_addr(rd_addr14));
rd_cell rd_cell15(.clk(clk),.reset_n(reset_n),.en(rd_en),.cycle(cycle),.base_addr(rd_counter),.addr_offset(offset15),.rd_addr(rd_addr15));
rd_cell rd_cell16(.clk(clk),.reset_n(reset_n),.en(rd_en),.cycle(cycle),.base_addr(rd_counter),.addr_offset(offset16),.rd_addr(rd_addr16));
rd_cell rd_cell17(.clk(clk),.reset_n(reset_n),.en(rd_en),.cycle(cycle),.base_addr(rd_counter),.addr_offset(offset17),.rd_addr(rd_addr17));
rd_cell rd_cell18(.clk(clk),.reset_n(reset_n),.en(rd_en),.cycle(cycle),.base_addr(rd_counter),.addr_offset(offset18),.rd_addr(rd_addr18));
rd_cell rd_cell19(.clk(clk),.reset_n(reset_n),.en(rd_en),.cycle(cycle),.base_addr(rd_counter),.addr_offset(offset19),.rd_addr(rd_addr19));
rd_cell rd_cell20(.clk(clk),.reset_n(reset_n),.en(rd_en),.cycle(cycle),.base_addr(rd_counter),.addr_offset(offset20),.rd_addr(rd_addr20));
rd_cell rd_cell21(.clk(clk),.reset_n(reset_n),.en(rd_en),.cycle(cycle),.base_addr(rd_counter),.addr_offset(offset21),.rd_addr(rd_addr21));
rd_cell rd_cell22(.clk(clk),.reset_n(reset_n),.en(rd_en),.cycle(cycle),.base_addr(rd_counter),.addr_offset(offset22),.rd_addr(rd_addr22));
rd_cell rd_cell23(.clk(clk),.reset_n(reset_n),.en(rd_en),.cycle(cycle),.base_addr(rd_counter),.addr_offset(offset23),.rd_addr(rd_addr23));
rd_cell rd_cell24(.clk(clk),.reset_n(reset_n),.en(rd_en),.cycle(cycle),.base_addr(rd_counter),.addr_offset(offset24),.rd_addr(rd_addr24));
rd_cell rd_cell25(.clk(clk),.reset_n(reset_n),.en(rd_en),.cycle(cycle),.base_addr(rd_counter),.addr_offset(offset25),.rd_addr(rd_addr25));
rd_cell rd_cell26(.clk(clk),.reset_n(reset_n),.en(rd_en),.cycle(cycle),.base_addr(rd_counter),.addr_offset(offset26),.rd_addr(rd_addr26));
rd_cell rd_cell27(.clk(clk),.reset_n(reset_n),.en(rd_en),.cycle(cycle),.base_addr(rd_counter),.addr_offset(offset27),.rd_addr(rd_addr27));
rd_cell rd_cell28(.clk(clk),.reset_n(reset_n),.en(rd_en),.cycle(cycle),.base_addr(rd_counter),.addr_offset(offset28),.rd_addr(rd_addr28));
rd_cell rd_cell29(.clk(clk),.reset_n(reset_n),.en(rd_en),.cycle(cycle),.base_addr(rd_counter),.addr_offset(offset29),.rd_addr(rd_addr29));
rd_cell rd_cell30(.clk(clk),.reset_n(reset_n),.en(rd_en),.cycle(cycle),.base_addr(rd_counter),.addr_offset(offset30),.rd_addr(rd_addr30));
rd_cell rd_cell31(.clk(clk),.reset_n(reset_n),.en(rd_en),.cycle(cycle),.base_addr(rd_counter),.addr_offset(offset31),.rd_addr(rd_addr31));
rd_cell rd_cell32(.clk(clk),.reset_n(reset_n),.en(rd_en),.cycle(cycle),.base_addr(rd_counter),.addr_offset(offset32),.rd_addr(rd_addr32));
rd_cell rd_cell33(.clk(clk),.reset_n(reset_n),.en(rd_en),.cycle(cycle),.base_addr(rd_counter),.addr_offset(offset33),.rd_addr(rd_addr33));
rd_cell rd_cell34(.clk(clk),.reset_n(reset_n),.en(rd_en),.cycle(cycle),.base_addr(rd_counter),.addr_offset(offset34),.rd_addr(rd_addr34));
rd_cell rd_cell35(.clk(clk),.reset_n(reset_n),.en(rd_en),.cycle(cycle),.base_addr(rd_counter),.addr_offset(offset35),.rd_addr(rd_addr35));


endmodule