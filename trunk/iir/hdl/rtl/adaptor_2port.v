module adaptor_2port0(
    a1,
    a2,
    alpha,
    b1,
    b2
);

parameter D_WID1 = 10,
          D_WID2 = 11,
          D_WID3 = 12,
          D_WID4 = 12;	  

input  [D_WID1-1:0]  a1;
input  [D_WID2-1:0]  a2;
input  [10:0]        alpha;
output [D_WID3-1:0]  b1;
output [D_WID4-1:0]  b2;

wire   [D_WID2-1:0]  temp1;
wire   [D_WID2+10:0] temp2;
wire   [D_WID3:0]  temp3;
wire   [D_WID4:0]  temp4;

assign temp1 = a2 - {{{D_WID2-D_WID1}{a1[D_WID1-1]}},a1};
assign temp2 = $signed(alpha) * $signed(temp1);
assign temp3 = {{{D_WID3-D_WID2}{a2[D_WID2-1]}},a2,1'b0} + temp2[D_WID2+10:9]+1'b1;
assign temp4 = {{{D_WID4-D_WID1}{a1[D_WID1-1]}},a1,1'b0} + temp2[D_WID2+10:9]+1'b1;
assign b1 = temp3[D_WID3:1];
assign b2 = temp4[D_WID4:1];


endmodule

module adaptor_2port1(
    a1,
    a2,
    alpha,
    b1,
    b2
);

parameter D_WID1 = 10,
          D_WID2 = 12,
          D_WID3 = 12,
          D_WID4 = 12;	  

input  [D_WID1-1:0]  a1;
input  [D_WID2-1:0]  a2;
input  [10:0]        alpha;
output [D_WID3-1:0]  b1;
output [D_WID4-1:0]  b2;

wire   [D_WID2-1:0]  temp1;
wire   [D_WID2+10:0] temp2;
wire   [D_WID2:0]  temp3;
wire   [D_WID4:0]  temp4;

assign temp1 = a2 - {{{D_WID2-D_WID1}{a1[D_WID1-1]}},a1};
assign temp2 = $signed(alpha) * $signed(temp1);
assign temp3 = {a2,1'b0} + temp2[D_WID2+10:9]+1'b1;
assign temp4 = {{{D_WID4-D_WID1}{a1[D_WID1-1]}},a1,1'b0} + temp2[D_WID2+10:9]+1'b1;
assign b1 = temp3[D_WID3:1];
assign b2 = temp4[D_WID4:1];


endmodule

module adaptor_2port2(
    a1,
    a2,
    alpha,
    b1,
    b2
);

parameter D_WID1 = 12,
          D_WID2 = 10,
          D_WID3 = 12,
          D_WID4 = 12;	  

input  [D_WID1-1:0]  a1;
input  [D_WID2-1:0]  a2;
input  [10:0]        alpha;
output [D_WID3-1:0]  b1;
output [D_WID4-1:0]  b2;

wire   [D_WID2-1:0]  temp1;
wire   [D_WID1+10:0] temp2;
wire   [D_WID3:0]  temp3;
wire   [D_WID4:0]  temp4;

assign temp1 = {{{D_WID1-D_WID2}{a2[D_WID2-1]}},a2} - a1;
assign temp2 = $signed(alpha) * $signed(temp1);
assign temp3 = {{{D_WID3-D_WID2}{a2[D_WID2-1]}},a2,1'b0} + temp2[D_WID1+10:9]+1'b1;
assign temp4 = {a1,1'b0} + temp2[D_WID2+10:9]+1'b1;
assign b1 = temp3[D_WID3:1];
assign b2 = temp4[D_WID4:1];


endmodule


