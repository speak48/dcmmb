//////////////////////////
//
//copyright 2009, SHHIC
//all right reserved
//
//project name: hongqiao
//filename    : edge_mem.v
//author      : Li Gang
//date        : 2009/10/20
//version     : 0.1
//
//module name : edge_mem
//discription : 
//
//modification history
//---------------------------------
//&Log&
//
//////////////////////////

module edge_mem  (  clk       ,                        
                    reset_n   ,
                    rate      ,
                    init_dout ,
                    cpu_a     , 
                    vpu_dout  ,                    
                    ram_wren  ,    
                    ram_addr  ,
                    lram_wren ,
                    lram_addr ,                    
                    vpu_dout2 ,
                    state     ,
                    cpu_dout  ,

                    init_b    ,  
                    vpu_din   ,
                    lram_dout ,
                    cpu_din1  ,
                    cpu_din2  
                 );
                 


                 

parameter Width_R    = 7  ;
parameter Width_D    = 6  ;
parameter Width_A    = 8  ;

input                         clk      ;                        
input                         reset_n  ;
input                         rate     ;                             
input     [215 : 0]           init_dout;
input                         cpu_a    ; 
input     [647 : 0]           vpu_dout ;
input                         ram_wren ;   
input     [863 : 0]           ram_addr ;
input                         lram_wren;
input     [287 : 0]           lram_addr;
input     [35:0]              vpu_dout2;
input     [4:0]               state    ;
input     [647 : 0]           cpu_dout ;                                

output                        init_b   ;                                     
output    [647 : 0]           vpu_din  ;
output    [251 : 0]           lram_dout;
output    [647 : 0]           cpu_din1 ;
output    [107 : 0]           cpu_din2 ; 
          
reg       [647 : 0]           cpu_din1 ;
reg       [107 : 0]           cpu_din2 ; 

wire      [647 : 0]           vpu_din  ;  
wire      [107 : 0]           ram_dout ;
reg       [647 : 0]           ram_din  ;
                             
reg       [647 : 0]           ram_din_d;
reg       [215 : 0]           init_dout_d  ;


wire  [Width_A-1 : 0]  
  ram_addr107, ram_addr106, ram_addr105, ram_addr104, ram_addr103, ram_addr102, ram_addr101, ram_addr100,
  ram_addr99, ram_addr98, ram_addr97, ram_addr96, ram_addr95, ram_addr94, ram_addr93, ram_addr92, ram_addr91, ram_addr90,
  ram_addr89, ram_addr88, ram_addr87, ram_addr86, ram_addr85, ram_addr84, ram_addr83, ram_addr82, ram_addr81, ram_addr80,
  ram_addr79, ram_addr78, ram_addr77, ram_addr76, ram_addr75, ram_addr74, ram_addr73, ram_addr72, ram_addr71, ram_addr70,
  ram_addr69, ram_addr68, ram_addr67, ram_addr66, ram_addr65, ram_addr64, ram_addr63, ram_addr62, ram_addr61, ram_addr60,
  ram_addr59, ram_addr58, ram_addr57, ram_addr56, ram_addr55, ram_addr54, ram_addr53, ram_addr52, ram_addr51, ram_addr50,
  ram_addr49, ram_addr48, ram_addr47, ram_addr46, ram_addr45, ram_addr44, ram_addr43, ram_addr42, ram_addr41, ram_addr40,
  ram_addr39, ram_addr38, ram_addr37, ram_addr36, ram_addr35, ram_addr34, ram_addr33, ram_addr32, ram_addr31, ram_addr30,
  ram_addr29, ram_addr28, ram_addr27, ram_addr26, ram_addr25, ram_addr24, ram_addr23, ram_addr22, ram_addr21, ram_addr20,
  ram_addr19, ram_addr18, ram_addr17, ram_addr16, ram_addr15, ram_addr14, ram_addr13, ram_addr12, ram_addr11, ram_addr10,
  ram_addr9, ram_addr8, ram_addr7, ram_addr6, ram_addr5, ram_addr4, ram_addr3, ram_addr2, ram_addr1, ram_addr0;

reg  [Width_R-1 : 0]  
  ram_din107, ram_din106, ram_din105, ram_din104, ram_din103, ram_din102, ram_din101, ram_din100,
  ram_din99, ram_din98, ram_din97, ram_din96, ram_din95, ram_din94, ram_din93, ram_din92, ram_din91, ram_din90,
  ram_din89, ram_din88, ram_din87, ram_din86, ram_din85, ram_din84, ram_din83, ram_din82, ram_din81, ram_din80,
  ram_din79, ram_din78, ram_din77, ram_din76, ram_din75, ram_din74, ram_din73, ram_din72, ram_din71, ram_din70,
  ram_din69, ram_din68, ram_din67, ram_din66, ram_din65, ram_din64, ram_din63, ram_din62, ram_din61, ram_din60,
  ram_din59, ram_din58, ram_din57, ram_din56, ram_din55, ram_din54, ram_din53, ram_din52, ram_din51, ram_din50,
  ram_din49, ram_din48, ram_din47, ram_din46, ram_din45, ram_din44, ram_din43, ram_din42, ram_din41, ram_din40,
  ram_din39, ram_din38, ram_din37, ram_din36, ram_din35, ram_din34, ram_din33, ram_din32, ram_din31, ram_din30,
  ram_din29, ram_din28, ram_din27, ram_din26, ram_din25, ram_din24, ram_din23, ram_din22, ram_din21, ram_din20,
  ram_din19, ram_din18, ram_din17, ram_din16, ram_din15, ram_din14, ram_din13, ram_din12, ram_din11, ram_din10,
  ram_din9, ram_din8, ram_din7, ram_din6, ram_din5, ram_din4, ram_din3, ram_din2, ram_din1, ram_din0;

wire  [Width_R-1 : 0]  
  ram_dout107, ram_dout106, ram_dout105, ram_dout104, ram_dout103, ram_dout102, ram_dout101, ram_dout100,
  ram_dout99, ram_dout98, ram_dout97, ram_dout96, ram_dout95, ram_dout94, ram_dout93, ram_dout92, ram_dout91, ram_dout90,
  ram_dout89, ram_dout88, ram_dout87, ram_dout86, ram_dout85, ram_dout84, ram_dout83, ram_dout82, ram_dout81, ram_dout80,
  ram_dout79, ram_dout78, ram_dout77, ram_dout76, ram_dout75, ram_dout74, ram_dout73, ram_dout72, ram_dout71, ram_dout70,
  ram_dout69, ram_dout68, ram_dout67, ram_dout66, ram_dout65, ram_dout64, ram_dout63, ram_dout62, ram_dout61, ram_dout60,
  ram_dout59, ram_dout58, ram_dout57, ram_dout56, ram_dout55, ram_dout54, ram_dout53, ram_dout52, ram_dout51, ram_dout50,
  ram_dout49, ram_dout48, ram_dout47, ram_dout46, ram_dout45, ram_dout44, ram_dout43, ram_dout42, ram_dout41, ram_dout40,
  ram_dout39, ram_dout38, ram_dout37, ram_dout36, ram_dout35, ram_dout34, ram_dout33, ram_dout32, ram_dout31, ram_dout30,
  ram_dout29, ram_dout28, ram_dout27, ram_dout26, ram_dout25, ram_dout24, ram_dout23, ram_dout22, ram_dout21, ram_dout20,
  ram_dout19, ram_dout18, ram_dout17, ram_dout16, ram_dout15, ram_dout14, ram_dout13, ram_dout12, ram_dout11, ram_dout10,
  ram_dout9, ram_dout8, ram_dout7, ram_dout6, ram_dout5, ram_dout4, ram_dout3, ram_dout2, ram_dout1, ram_dout0;


wire  [Width_A-1 : 0]  
  lram_addr35, lram_addr34, lram_addr33, lram_addr32, lram_addr31, lram_addr30,lram_addr29, lram_addr28, lram_addr27, lram_addr26, 
  lram_addr25, lram_addr24, lram_addr23, lram_addr22, lram_addr21, lram_addr20,lram_addr19, lram_addr18, lram_addr17, lram_addr16, 
  lram_addr15, lram_addr14, lram_addr13, lram_addr12, lram_addr11, lram_addr10,lram_addr9, lram_addr8, lram_addr7, lram_addr6, 
  lram_addr5, lram_addr4, lram_addr3, lram_addr2, lram_addr1, lram_addr0;

reg  [Width_R-1 : 0]  
  lram_din35, lram_din34, lram_din33, lram_din32, lram_din31, lram_din30,lram_din29, lram_din28, lram_din27, lram_din26, 
  lram_din25, lram_din24, lram_din23, lram_din22, lram_din21, lram_din20,lram_din19, lram_din18, lram_din17, lram_din16, 
  lram_din15, lram_din14, lram_din13, lram_din12, lram_din11, lram_din10,lram_din9, lram_din8, lram_din7, lram_din6, 
  lram_din5, lram_din4, lram_din3, lram_din2, lram_din1, lram_din0;


wire  [Width_R-1 : 0]  
  lram_dout35, lram_dout34, lram_dout33, lram_dout32, lram_dout31, lram_dout30,lram_dout29, lram_dout28, lram_dout27, lram_dout26, 
  lram_dout25, lram_dout24, lram_dout23, lram_dout22, lram_dout21, lram_dout20,lram_dout19, lram_dout18, lram_dout17, lram_dout16, 
  lram_dout15, lram_dout14, lram_dout13, lram_dout12, lram_dout11, lram_dout10,lram_dout9, lram_dout8, lram_dout7, lram_dout6, 
  lram_dout5, lram_dout4, lram_dout3, lram_dout2, lram_dout1, lram_dout0;



assign lram_addr0 = lram_addr[1*Width_A-1 : 0];
assign lram_addr1 = lram_addr[2*Width_A-1 : 1*Width_A];
assign lram_addr2 = lram_addr[3*Width_A-1 : 2*Width_A];
assign lram_addr3 = lram_addr[4*Width_A-1 : 3*Width_A];
assign lram_addr4 = lram_addr[5*Width_A-1 : 4*Width_A]; 
assign lram_addr5 = lram_addr[6*Width_A-1 : 5*Width_A];
assign lram_addr6 = lram_addr[7*Width_A-1 : 6*Width_A];
assign lram_addr7 = lram_addr[8*Width_A-1 : 7*Width_A];
assign lram_addr8 = lram_addr[9*Width_A-1 : 8*Width_A];
assign lram_addr9 = lram_addr[10*Width_A-1 : 9*Width_A];

assign lram_addr10 = lram_addr[11*Width_A-1 : 10*Width_A];
assign lram_addr11 = lram_addr[12*Width_A-1 : 11*Width_A];
assign lram_addr12 = lram_addr[13*Width_A-1 : 12*Width_A];
assign lram_addr13 = lram_addr[14*Width_A-1 : 13*Width_A];
assign lram_addr14 = lram_addr[15*Width_A-1 : 14*Width_A]; 
assign lram_addr15 = lram_addr[16*Width_A-1 : 15*Width_A];
assign lram_addr16 = lram_addr[17*Width_A-1 : 16*Width_A];
assign lram_addr17 = lram_addr[18*Width_A-1 : 17*Width_A];
assign lram_addr18 = lram_addr[19*Width_A-1 : 18*Width_A];
assign lram_addr19 = lram_addr[20*Width_A-1 : 19*Width_A];

assign lram_addr20 = lram_addr[21*Width_A-1 : 20*Width_A];
assign lram_addr21 = lram_addr[22*Width_A-1 : 21*Width_A];
assign lram_addr22 = lram_addr[23*Width_A-1 : 22*Width_A];
assign lram_addr23 = lram_addr[24*Width_A-1 : 23*Width_A];
assign lram_addr24 = lram_addr[25*Width_A-1 : 24*Width_A]; 
assign lram_addr25 = lram_addr[26*Width_A-1 : 25*Width_A];
assign lram_addr26 = lram_addr[27*Width_A-1 : 26*Width_A];
assign lram_addr27 = lram_addr[28*Width_A-1 : 27*Width_A];
assign lram_addr28 = lram_addr[29*Width_A-1 : 28*Width_A];
assign lram_addr29 = lram_addr[30*Width_A-1 : 29*Width_A];

assign lram_addr30 = lram_addr[31*Width_A-1 : 30*Width_A];
assign lram_addr31 = lram_addr[32*Width_A-1 : 31*Width_A];
assign lram_addr32 = lram_addr[33*Width_A-1 : 32*Width_A];
assign lram_addr33 = lram_addr[34*Width_A-1 : 33*Width_A];
assign lram_addr34 = lram_addr[35*Width_A-1 : 34*Width_A]; 
assign lram_addr35 = lram_addr[36*Width_A-1 : 35*Width_A];



always @( posedge clk or negedge reset_n ) begin
    if ( !reset_n ) 
        begin
    	    lram_din0 <= 7'd0; 
    	    lram_din1 <= 7'd0; 
    	    lram_din2 <= 7'd0; 
    	    lram_din3 <= 7'd0; 
    	    lram_din4 <= 7'd0; 
    	    lram_din5 <= 7'd0; 
    	    lram_din6 <= 7'd0; 
    	    lram_din7 <= 7'd0; 
    	    lram_din8 <= 7'd0; 
    	    lram_din9  <= 7'd0; 
    	    lram_din10 <= 7'd0; 
    	    lram_din11 <= 7'd0; 
    	    lram_din12 <= 7'd0; 
    	    lram_din13 <= 7'd0; 
    	    lram_din14 <= 7'd0; 
    	    lram_din15 <= 7'd0; 
    	    lram_din16 <= 7'd0; 
    	    lram_din17 <= 7'd0; 
    	    lram_din18 <= 7'd0; 
    	    lram_din19 <= 7'd0; 
    	    lram_din20 <= 7'd0; 
    	    lram_din21 <= 7'd0; 
    	    lram_din22 <= 7'd0; 
    	    lram_din23 <= 7'd0; 
    	    lram_din24 <= 7'd0; 
    	    lram_din25 <= 7'd0; 
    	    lram_din26 <= 7'd0; 
    	    lram_din27 <= 7'd0; 
    	    lram_din28 <= 7'd0;     	    
    	    lram_din29 <= 7'd0;  
    	    lram_din30 <= 7'd0; 
    	    lram_din31 <= 7'd0; 
    	    lram_din32 <= 7'd0; 
    	    lram_din33 <= 7'd0; 
    	    lram_din34 <= 7'd0; 
    	    lram_din35 <= 7'd0; 
        end    	
    else 
    	if (state[1]) 
    	begin
    	    lram_din0 <= {init_dout[1*Width_D-1], init_dout[1*Width_D-1 : 0]}; 
    	    lram_din1 <= {init_dout[2*Width_D-1], init_dout[2*Width_D-1 : 1*Width_D]}; 
    	    lram_din2 <= {init_dout[3*Width_D-1], init_dout[3*Width_D-1 : 2*Width_D]}; 
    	    lram_din3 <= {init_dout[4*Width_D-1], init_dout[4*Width_D-1 : 3*Width_D]}; 
    	    lram_din4 <= {init_dout[5*Width_D-1], init_dout[5*Width_D-1 : 4*Width_D]}; 
    	    lram_din5 <= {init_dout[6*Width_D-1], init_dout[6*Width_D-1 : 5*Width_D]}; 
    	    lram_din6 <= {init_dout[7*Width_D-1], init_dout[7*Width_D-1 : 6*Width_D]}; 
    	    lram_din7 <= {init_dout[8*Width_D-1], init_dout[8*Width_D-1 : 7*Width_D]}; 
    	    lram_din8 <= {init_dout[9*Width_D-1], init_dout[9*Width_D-1 : 8*Width_D]}; 
    	    lram_din9  <= {init_dout[10*Width_D-1], init_dout[10*Width_D-1 : 9*Width_D]}; 
    	    lram_din10 <= {init_dout[11*Width_D-1], init_dout[11*Width_D-1 : 10*Width_D]}; 
    	    lram_din11 <= {init_dout[12*Width_D-1], init_dout[12*Width_D-1 : 11*Width_D]}; 
    	    lram_din12 <= {init_dout[13*Width_D-1], init_dout[13*Width_D-1 : 12*Width_D]}; 
    	    lram_din13 <= {init_dout[14*Width_D-1], init_dout[14*Width_D-1 : 13*Width_D]}; 
    	    lram_din14 <= {init_dout[15*Width_D-1], init_dout[15*Width_D-1 : 14*Width_D]}; 
    	    lram_din15 <= {init_dout[16*Width_D-1], init_dout[16*Width_D-1 : 15*Width_D]}; 
    	    lram_din16 <= {init_dout[17*Width_D-1], init_dout[17*Width_D-1 : 16*Width_D]}; 
    	    lram_din17 <= {init_dout[18*Width_D-1], init_dout[18*Width_D-1 : 17*Width_D]}; 
    	    lram_din18 <= {init_dout[19*Width_D-1], init_dout[19*Width_D-1 : 18*Width_D]}; 
    	    lram_din19 <= {init_dout[20*Width_D-1], init_dout[20*Width_D-1 : 19*Width_D]}; 
    	    lram_din20 <= {init_dout[21*Width_D-1], init_dout[21*Width_D-1 : 20*Width_D]}; 
    	    lram_din21 <= {init_dout[22*Width_D-1], init_dout[22*Width_D-1 : 21*Width_D]}; 
    	    lram_din22 <= {init_dout[23*Width_D-1], init_dout[23*Width_D-1 : 22*Width_D]}; 
    	    lram_din23 <= {init_dout[24*Width_D-1], init_dout[24*Width_D-1 : 23*Width_D]}; 
    	    lram_din24 <= {init_dout[25*Width_D-1], init_dout[25*Width_D-1 : 24*Width_D]}; 
    	    lram_din25 <= {init_dout[26*Width_D-1], init_dout[26*Width_D-1 : 25*Width_D]}; 
    	    lram_din26 <= {init_dout[27*Width_D-1], init_dout[27*Width_D-1 : 26*Width_D]}; 
    	    lram_din27 <= {init_dout[28*Width_D-1], init_dout[28*Width_D-1 : 27*Width_D]}; 
    	    lram_din28 <= {init_dout[29*Width_D-1], init_dout[29*Width_D-1 : 28*Width_D]};     	    
    	    lram_din29 <= {init_dout[30*Width_D-1], init_dout[30*Width_D-1 : 29*Width_D]};  
    	    lram_din30 <= {init_dout[31*Width_D-1], init_dout[31*Width_D-1 : 30*Width_D]}; 
    	    lram_din31 <= {init_dout[32*Width_D-1], init_dout[32*Width_D-1 : 31*Width_D]}; 
    	    lram_din32 <= {init_dout[33*Width_D-1], init_dout[33*Width_D-1 : 32*Width_D]}; 
    	    lram_din33 <= {init_dout[34*Width_D-1], init_dout[34*Width_D-1 : 33*Width_D]}; 
    	    lram_din34 <= {init_dout[35*Width_D-1], init_dout[35*Width_D-1 : 34*Width_D]}; 
    	    lram_din35 <= {init_dout[36*Width_D-1], init_dout[36*Width_D-1 : 35*Width_D]}; 
    	end       	    
    	else if (state[3])
    	begin 
    	    lram_din0 <= {vpu_dout2[0], lram_dout0[Width_D-1 : 0]};
    	    lram_din1 <= {vpu_dout2[1], lram_dout1[Width_D-1 : 0]};
    	    lram_din2 <= {vpu_dout2[2], lram_dout2[Width_D-1 : 0]};
    	    lram_din3 <= {vpu_dout2[3], lram_dout3[Width_D-1 : 0]};
    	    lram_din4 <= {vpu_dout2[4], lram_dout4[Width_D-1 : 0]};
    	    lram_din5 <= {vpu_dout2[5], lram_dout5[Width_D-1 : 0]};
    	    lram_din6 <= {vpu_dout2[6], lram_dout6[Width_D-1 : 0]};
    	    lram_din7 <= {vpu_dout2[7], lram_dout7[Width_D-1 : 0]};
    	    lram_din8 <= {vpu_dout2[8], lram_dout8[Width_D-1 : 0]};
    	    lram_din9 <= {vpu_dout2[9], lram_dout9[Width_D-1 : 0]};    	    
    	    lram_din10 <= {vpu_dout2[10], lram_dout10[Width_D-1 : 0]};
    	    lram_din11 <= {vpu_dout2[11], lram_dout11[Width_D-1 : 0]};
    	    lram_din12 <= {vpu_dout2[12], lram_dout12[Width_D-1 : 0]};
    	    lram_din13 <= {vpu_dout2[13], lram_dout13[Width_D-1 : 0]};
    	    lram_din14 <= {vpu_dout2[14], lram_dout14[Width_D-1 : 0]};
    	    lram_din15 <= {vpu_dout2[15], lram_dout15[Width_D-1 : 0]};
    	    lram_din16 <= {vpu_dout2[16], lram_dout16[Width_D-1 : 0]};
    	    lram_din17 <= {vpu_dout2[17], lram_dout17[Width_D-1 : 0]};
    	    lram_din18 <= {vpu_dout2[18], lram_dout18[Width_D-1 : 0]};
    	    lram_din19 <= {vpu_dout2[19], lram_dout19[Width_D-1 : 0]}; 
    	    lram_din20 <= {vpu_dout2[20], lram_dout20[Width_D-1 : 0]};
    	    lram_din21 <= {vpu_dout2[21], lram_dout21[Width_D-1 : 0]};
    	    lram_din22 <= {vpu_dout2[22], lram_dout22[Width_D-1 : 0]};
    	    lram_din23 <= {vpu_dout2[23], lram_dout23[Width_D-1 : 0]};
    	    lram_din24 <= {vpu_dout2[24], lram_dout24[Width_D-1 : 0]};
    	    lram_din25 <= {vpu_dout2[25], lram_dout25[Width_D-1 : 0]};
    	    lram_din26 <= {vpu_dout2[26], lram_dout26[Width_D-1 : 0]};
    	    lram_din27 <= {vpu_dout2[27], lram_dout27[Width_D-1 : 0]};
    	    lram_din28 <= {vpu_dout2[28], lram_dout28[Width_D-1 : 0]};
    	    lram_din29 <= {vpu_dout2[29], lram_dout29[Width_D-1 : 0]}; 
    	    lram_din30 <= {vpu_dout2[30], lram_dout30[Width_D-1 : 0]};
    	    lram_din31 <= {vpu_dout2[31], lram_dout31[Width_D-1 : 0]};
    	    lram_din32 <= {vpu_dout2[32], lram_dout32[Width_D-1 : 0]};
    	    lram_din33 <= {vpu_dout2[33], lram_dout33[Width_D-1 : 0]};
    	    lram_din34 <= {vpu_dout2[34], lram_dout34[Width_D-1 : 0]};
    	    lram_din35 <= {vpu_dout2[35], lram_dout35[Width_D-1 : 0]};
    	end
end


assign lram_dout = 
{
lram_dout35[Width_R-1 : 0],
lram_dout34[Width_R-1 : 0],
lram_dout33[Width_R-1 : 0],
lram_dout32[Width_R-1 : 0],
lram_dout31[Width_R-1 : 0],
lram_dout30[Width_R-1 : 0],
lram_dout29[Width_R-1 : 0],
lram_dout28[Width_R-1 : 0],
lram_dout27[Width_R-1 : 0],
lram_dout26[Width_R-1 : 0],
lram_dout25[Width_R-1 : 0],
lram_dout24[Width_R-1 : 0],
lram_dout23[Width_R-1 : 0],
lram_dout22[Width_R-1 : 0],
lram_dout21[Width_R-1 : 0],
lram_dout20[Width_R-1 : 0],
lram_dout19[Width_R-1 : 0],
lram_dout18[Width_R-1 : 0],
lram_dout17[Width_R-1 : 0],
lram_dout16[Width_R-1 : 0],
lram_dout15[Width_R-1 : 0],
lram_dout14[Width_R-1 : 0],
lram_dout13[Width_R-1 : 0],
lram_dout12[Width_R-1 : 0],
lram_dout11[Width_R-1 : 0],
lram_dout10[Width_R-1 : 0],
lram_dout9[Width_R-1 : 0],
lram_dout8[Width_R-1 : 0],
lram_dout7[Width_R-1 : 0],
lram_dout6[Width_R-1 : 0],
lram_dout5[Width_R-1 : 0],
lram_dout4[Width_R-1 : 0],
lram_dout3[Width_R-1 : 0],
lram_dout2[Width_R-1 : 0],
lram_dout1[Width_R-1 : 0],
lram_dout0[Width_R-1 : 0]
};



reg temp1, init_b;   	        
always @( posedge clk or negedge reset_n ) begin
    if ( !reset_n ) begin
        temp1  <= 1'b0 ;
        init_b  <= 1'b0 ;
    end
    else if (state[1] && lram_wren && (lram_addr0 == 255)) begin
        temp1  <= 1'b1 ;
        init_b    <= temp1 ;
    end
    else begin
        temp1  <= 1'b0 ;
        init_b    <= temp1 ;
    end
end                        

reg [35:0]   dd1;

always @( posedge clk or negedge reset_n ) begin
    if ( !reset_n )
        dd1 <= 36'd0 ;
    else
        if (state[1])
          begin
            dd1[0] <= init_dout[Width_D-1];
            dd1[1] <= init_dout[2*Width_D-1];
            dd1[2] <= init_dout[3*Width_D-1];            
            dd1[3] <= init_dout[4*Width_D-1];
            dd1[4] <= init_dout[5*Width_D-1];
            dd1[5] <= init_dout[6*Width_D-1];
            dd1[6] <= init_dout[7*Width_D-1];            
            dd1[7] <= init_dout[8*Width_D-1];
            dd1[8] <= init_dout[9*Width_D-1];
            dd1[9] <= init_dout[10*Width_D-1];
            dd1[10] <= init_dout[11*Width_D-1];
            dd1[11] <= init_dout[12*Width_D-1];
            dd1[12] <= init_dout[13*Width_D-1];            
            dd1[13] <= init_dout[14*Width_D-1];
            dd1[14] <= init_dout[15*Width_D-1];
            dd1[15] <= init_dout[16*Width_D-1];
            dd1[16] <= init_dout[17*Width_D-1];            
            dd1[17] <= init_dout[18*Width_D-1];
            dd1[18] <= init_dout[19*Width_D-1];
            dd1[19] <= init_dout[20*Width_D-1];
            dd1[20] <= init_dout[21*Width_D-1];
            dd1[21] <= init_dout[22*Width_D-1];
            dd1[22] <= init_dout[23*Width_D-1];            
            dd1[23] <= init_dout[24*Width_D-1];
            dd1[24] <= init_dout[25*Width_D-1];
            dd1[25] <= init_dout[26*Width_D-1];
            dd1[26] <= init_dout[27*Width_D-1];            
            dd1[27] <= init_dout[28*Width_D-1];
            dd1[28] <= init_dout[29*Width_D-1];
            dd1[29] <= init_dout[30*Width_D-1];
            dd1[30] <= init_dout[31*Width_D-1];
            dd1[31] <= init_dout[32*Width_D-1];
            dd1[32] <= init_dout[33*Width_D-1];            
            dd1[33] <= init_dout[34*Width_D-1];
            dd1[34] <= init_dout[35*Width_D-1];
            dd1[35] <= init_dout[36*Width_D-1]; 
          end    
        else if (state[2])
            dd1 <= 36'd0 ;
        else if (state[3])
            dd1 <= vpu_dout2;
end



assign ram_addr0 = ram_addr[Width_A-1 : 0] ;
assign ram_addr1 = ram_addr[2*Width_A-1 : 1*Width_A] ;
assign ram_addr2 = ram_addr[3*Width_A-1 : 2*Width_A] ;
assign ram_addr3 = ram_addr[4*Width_A-1 : 3*Width_A] ;
assign ram_addr4 = ram_addr[5*Width_A-1 : 4*Width_A] ;
assign ram_addr5 = ram_addr[6*Width_A-1 : 5*Width_A] ;
assign ram_addr6 = ram_addr[7*Width_A-1 : 6*Width_A] ;
assign ram_addr7 = ram_addr[8*Width_A-1 : 7*Width_A] ;
assign ram_addr8 = ram_addr[9*Width_A-1 : 8*Width_A] ;
assign ram_addr9 = ram_addr[10*Width_A-1 : 9*Width_A];

assign ram_addr10 = ram_addr[11*Width_A-1 : 10*Width_A];
assign ram_addr11 = ram_addr[12*Width_A-1 : 11*Width_A];
assign ram_addr12 = ram_addr[13*Width_A-1 : 12*Width_A];
assign ram_addr13 = ram_addr[14*Width_A-1 : 13*Width_A];
assign ram_addr14 = ram_addr[15*Width_A-1 : 14*Width_A];
assign ram_addr15 = ram_addr[16*Width_A-1 : 15*Width_A];
assign ram_addr16 = ram_addr[17*Width_A-1 : 16*Width_A];
assign ram_addr17 = ram_addr[18*Width_A-1 : 17*Width_A];
assign ram_addr18 = ram_addr[19*Width_A-1 : 18*Width_A];
assign ram_addr19 = ram_addr[20*Width_A-1 : 19*Width_A];

assign ram_addr20 = ram_addr[21*Width_A-1 : 20*Width_A];
assign ram_addr21 = ram_addr[22*Width_A-1 : 21*Width_A];
assign ram_addr22 = ram_addr[23*Width_A-1 : 22*Width_A];
assign ram_addr23 = ram_addr[24*Width_A-1 : 23*Width_A];
assign ram_addr24 = ram_addr[25*Width_A-1 : 24*Width_A];
assign ram_addr25 = ram_addr[26*Width_A-1 : 25*Width_A];
assign ram_addr26 = ram_addr[27*Width_A-1 : 26*Width_A];
assign ram_addr27 = ram_addr[28*Width_A-1 : 27*Width_A];
assign ram_addr28 = ram_addr[29*Width_A-1 : 28*Width_A];
assign ram_addr29 = ram_addr[30*Width_A-1 : 29*Width_A];

assign ram_addr30 = ram_addr[31*Width_A-1 : 30*Width_A] ;
assign ram_addr31 = ram_addr[32*Width_A-1 : 31*Width_A] ;
assign ram_addr32 = ram_addr[33*Width_A-1 : 32*Width_A] ;
assign ram_addr33 = ram_addr[34*Width_A-1 : 33*Width_A] ;
assign ram_addr34 = ram_addr[35*Width_A-1 : 34*Width_A] ;
assign ram_addr35 = ram_addr[36*Width_A-1 : 35*Width_A] ;
assign ram_addr36 = ram_addr[37*Width_A-1 : 36*Width_A] ;
assign ram_addr37 = ram_addr[38*Width_A-1 : 37*Width_A] ;
assign ram_addr38 = ram_addr[39*Width_A-1 : 38*Width_A] ;
assign ram_addr39 = ram_addr[40*Width_A-1 : 39*Width_A] ;

assign ram_addr40 = ram_addr[41*Width_A-1 : 40*Width_A] ;
assign ram_addr41 = ram_addr[42*Width_A-1 : 41*Width_A] ;
assign ram_addr42 = ram_addr[43*Width_A-1 : 42*Width_A] ;
assign ram_addr43 = ram_addr[44*Width_A-1 : 43*Width_A] ;
assign ram_addr44 = ram_addr[45*Width_A-1 : 44*Width_A] ;
assign ram_addr45 = ram_addr[46*Width_A-1 : 45*Width_A] ;
assign ram_addr46 = ram_addr[47*Width_A-1 : 46*Width_A] ;
assign ram_addr47 = ram_addr[48*Width_A-1 : 47*Width_A] ;
assign ram_addr48 = ram_addr[49*Width_A-1 : 48*Width_A] ;
assign ram_addr49 = ram_addr[50*Width_A-1 : 49*Width_A] ;

assign ram_addr50 = ram_addr[51*Width_A-1 : 50*Width_A] ;
assign ram_addr51 = ram_addr[52*Width_A-1 : 51*Width_A] ;
assign ram_addr52 = ram_addr[53*Width_A-1 : 52*Width_A] ;
assign ram_addr53 = ram_addr[54*Width_A-1 : 53*Width_A] ;
assign ram_addr54 = ram_addr[55*Width_A-1 : 54*Width_A] ;
assign ram_addr55 = ram_addr[56*Width_A-1 : 55*Width_A] ;
assign ram_addr56 = ram_addr[57*Width_A-1 : 56*Width_A] ;
assign ram_addr57 = ram_addr[58*Width_A-1 : 57*Width_A] ;
assign ram_addr58 = ram_addr[59*Width_A-1 : 58*Width_A] ;
assign ram_addr59 = ram_addr[60*Width_A-1 : 59*Width_A] ;

assign ram_addr60 = ram_addr[61*Width_A-1 : 60*Width_A] ;
assign ram_addr61 = ram_addr[62*Width_A-1 : 61*Width_A] ;
assign ram_addr62 = ram_addr[63*Width_A-1 : 62*Width_A] ;
assign ram_addr63 = ram_addr[64*Width_A-1 : 63*Width_A] ;
assign ram_addr64 = ram_addr[65*Width_A-1 : 64*Width_A] ;
assign ram_addr65 = ram_addr[66*Width_A-1 : 65*Width_A] ;
assign ram_addr66 = ram_addr[67*Width_A-1 : 66*Width_A] ;
assign ram_addr67 = ram_addr[68*Width_A-1 : 67*Width_A] ;
assign ram_addr68 = ram_addr[69*Width_A-1 : 68*Width_A] ;
assign ram_addr69 = ram_addr[70*Width_A-1 : 69*Width_A] ;

assign ram_addr70 = ram_addr[71*Width_A-1 : 70*Width_A] ;
assign ram_addr71 = ram_addr[72*Width_A-1 : 71*Width_A] ;
assign ram_addr72 = ram_addr[73*Width_A-1 : 72*Width_A] ;
assign ram_addr73 = ram_addr[74*Width_A-1 : 73*Width_A] ;
assign ram_addr74 = ram_addr[75*Width_A-1 : 74*Width_A] ;
assign ram_addr75 = ram_addr[76*Width_A-1 : 75*Width_A] ;
assign ram_addr76 = ram_addr[77*Width_A-1 : 76*Width_A] ;
assign ram_addr77 = ram_addr[78*Width_A-1 : 77*Width_A] ;
assign ram_addr78 = ram_addr[79*Width_A-1 : 78*Width_A] ;
assign ram_addr79 = ram_addr[80*Width_A-1 : 79*Width_A] ;

assign ram_addr80 = ram_addr[81*Width_A-1 : 80*Width_A] ;
assign ram_addr81 = ram_addr[82*Width_A-1 : 81*Width_A] ;
assign ram_addr82 = ram_addr[83*Width_A-1 : 82*Width_A] ;
assign ram_addr83 = ram_addr[84*Width_A-1 : 83*Width_A] ;
assign ram_addr84 = ram_addr[85*Width_A-1 : 84*Width_A] ;
assign ram_addr85 = ram_addr[86*Width_A-1 : 85*Width_A] ;
assign ram_addr86 = ram_addr[87*Width_A-1 : 86*Width_A] ;
assign ram_addr87 = ram_addr[88*Width_A-1 : 87*Width_A] ;
assign ram_addr88 = ram_addr[89*Width_A-1 : 88*Width_A] ;
assign ram_addr89 = ram_addr[90*Width_A-1 : 89*Width_A] ;

assign ram_addr90 = ram_addr[91*Width_A-1 : 90*Width_A] ;
assign ram_addr91 = ram_addr[92*Width_A-1 : 91*Width_A] ;
assign ram_addr92 = ram_addr[93*Width_A-1 : 92*Width_A] ;
assign ram_addr93 = ram_addr[94*Width_A-1 : 93*Width_A] ;
assign ram_addr94 = ram_addr[95*Width_A-1 : 94*Width_A] ;
assign ram_addr95 = ram_addr[96*Width_A-1 : 95*Width_A] ;
assign ram_addr96 = ram_addr[97*Width_A-1 : 96*Width_A] ;
assign ram_addr97 = ram_addr[98*Width_A-1 : 97*Width_A] ;
assign ram_addr98 = ram_addr[99*Width_A-1 : 98*Width_A] ;
assign ram_addr99 = ram_addr[100*Width_A-1 : 99*Width_A] ;

assign ram_addr100 = ram_addr[101*Width_A-1 : 100*Width_A];
assign ram_addr101 = ram_addr[102*Width_A-1 : 101*Width_A];
assign ram_addr102 = ram_addr[103*Width_A-1 : 102*Width_A];
assign ram_addr103 = ram_addr[104*Width_A-1 : 103*Width_A];
assign ram_addr104 = ram_addr[105*Width_A-1 : 104*Width_A];
assign ram_addr105 = ram_addr[106*Width_A-1 : 105*Width_A];
assign ram_addr106 = ram_addr[107*Width_A-1 : 106*Width_A];
assign ram_addr107 = ram_addr[108*Width_A-1 : 107*Width_A];



always @ (posedge clk or negedge reset_n)
begin
    if ( ! reset_n  ) 
        begin
    	    ram_din_d <= 648'd0 ;
    	    init_dout_d <= 216'd0;
        end	
    else
        begin 	
            ram_din_d <= ram_din;
            init_dout_d <= init_dout;	
        end    
end	





always @ (*)
begin	
    if (state[1]) 
    begin
    	ram_din0 = {init_dout_d[Width_D-1], conv_s(init_dout_d[Width_D-1],init_dout_d[Width_D-2 : 0])} ;
    	ram_din1 = {init_dout_d[Width_D-1], conv_s(init_dout_d[Width_D-1],init_dout_d[Width_D-2 : 0])} ;
    	ram_din2 = {init_dout_d[Width_D-1], conv_s(init_dout_d[Width_D-1],init_dout_d[Width_D-2 : 0])} ;
    	
    	ram_din3 = {init_dout_d[2*Width_D-1], conv_s(init_dout_d[2*Width_D-1],init_dout_d[2*Width_D-2 : Width_D])} ;
    	ram_din4 = {init_dout_d[2*Width_D-1], conv_s(init_dout_d[2*Width_D-1],init_dout_d[2*Width_D-2 : Width_D])} ;
    	ram_din5 = {init_dout_d[2*Width_D-1], conv_s(init_dout_d[2*Width_D-1],init_dout_d[2*Width_D-2 : Width_D])} ;  
    	  	
    	ram_din6 = {init_dout_d[3*Width_D-1], conv_s(init_dout_d[3*Width_D-1],init_dout_d[3*Width_D-2 : 2*Width_D])} ;
    	ram_din7 = {init_dout_d[3*Width_D-1], conv_s(init_dout_d[3*Width_D-1],init_dout_d[3*Width_D-2 : 2*Width_D])} ;
    	ram_din8 = {init_dout_d[3*Width_D-1], conv_s(init_dout_d[3*Width_D-1],init_dout_d[3*Width_D-2 : 2*Width_D])} ;   
    	
    	ram_din9  = {init_dout_d[4*Width_D-1], conv_s(init_dout_d[4*Width_D-1],init_dout_d[4*Width_D-2 : 3*Width_D])} ;
    	ram_din10 = {init_dout_d[4*Width_D-1], conv_s(init_dout_d[4*Width_D-1],init_dout_d[4*Width_D-2 : 3*Width_D])} ;
    	ram_din11 = {init_dout_d[4*Width_D-1], conv_s(init_dout_d[4*Width_D-1],init_dout_d[4*Width_D-2 : 3*Width_D])} ;  	
    	
    	ram_din12 = {init_dout_d[5*Width_D-1], conv_s(init_dout_d[5*Width_D-1],init_dout_d[5*Width_D-2 : 4*Width_D])} ;
    	ram_din13 = {init_dout_d[5*Width_D-1], conv_s(init_dout_d[5*Width_D-1],init_dout_d[5*Width_D-2 : 4*Width_D])} ;
    	ram_din14 = {init_dout_d[5*Width_D-1], conv_s(init_dout_d[5*Width_D-1],init_dout_d[5*Width_D-2 : 4*Width_D])} ;
    	
    	ram_din15 = {init_dout_d[6*Width_D-1], conv_s(init_dout_d[6*Width_D-1],init_dout_d[6*Width_D-2 : 5*Width_D])} ;
    	ram_din16 = {init_dout_d[6*Width_D-1], conv_s(init_dout_d[6*Width_D-1],init_dout_d[6*Width_D-2 : 5*Width_D])} ;
    	ram_din17 = {init_dout_d[6*Width_D-1], conv_s(init_dout_d[6*Width_D-1],init_dout_d[6*Width_D-2 : 5*Width_D])} ;    	
    	
    	ram_din18 = {init_dout_d[7*Width_D-1], conv_s(init_dout_d[7*Width_D-1],init_dout_d[7*Width_D-2 : 6*Width_D])} ;    	
    	ram_din19 = {init_dout_d[7*Width_D-1], conv_s(init_dout_d[7*Width_D-1],init_dout_d[7*Width_D-2 : 6*Width_D])} ;    	
    	ram_din20 = {init_dout_d[7*Width_D-1], conv_s(init_dout_d[7*Width_D-1],init_dout_d[7*Width_D-2 : 6*Width_D])} ;    	
    	
    	ram_din21 = {init_dout_d[8*Width_D-1], conv_s(init_dout_d[8*Width_D-1],init_dout_d[8*Width_D-2 : 7*Width_D])} ;    	
    	ram_din22 = {init_dout_d[8*Width_D-1], conv_s(init_dout_d[8*Width_D-1],init_dout_d[8*Width_D-2 : 7*Width_D])} ;    	
    	ram_din23 = {init_dout_d[8*Width_D-1], conv_s(init_dout_d[8*Width_D-1],init_dout_d[8*Width_D-2 : 7*Width_D])} ;    	
 
    	ram_din24 = {init_dout_d[9*Width_D-1], conv_s(init_dout_d[9*Width_D-1],init_dout_d[9*Width_D-2 : 8*Width_D])} ; 
    	ram_din25 = {init_dout_d[9*Width_D-1], conv_s(init_dout_d[9*Width_D-1],init_dout_d[9*Width_D-2 : 8*Width_D])} ; 
    	ram_din26 = {init_dout_d[9*Width_D-1], conv_s(init_dout_d[9*Width_D-1],init_dout_d[9*Width_D-2 : 8*Width_D])} ; 
 
    	ram_din27 = {init_dout_d[10*Width_D-1], conv_s(init_dout_d[10*Width_D-1],init_dout_d[10*Width_D-2 : 9*Width_D])} ; 
    	ram_din28 = {init_dout_d[10*Width_D-1], conv_s(init_dout_d[10*Width_D-1],init_dout_d[10*Width_D-2 : 9*Width_D])} ; 
    	ram_din29 = {init_dout_d[10*Width_D-1], conv_s(init_dout_d[10*Width_D-1],init_dout_d[10*Width_D-2 : 9*Width_D])} ; 
 
    	ram_din30 = {init_dout_d[11*Width_D-1], conv_s(init_dout_d[11*Width_D-1],init_dout_d[11*Width_D-2 : 10*Width_D])} ; 
    	ram_din31 = {init_dout_d[11*Width_D-1], conv_s(init_dout_d[11*Width_D-1],init_dout_d[11*Width_D-2 : 10*Width_D])} ; 
    	ram_din32 = {init_dout_d[11*Width_D-1], conv_s(init_dout_d[11*Width_D-1],init_dout_d[11*Width_D-2 : 10*Width_D])} ; 
 
    	ram_din33 = {init_dout_d[12*Width_D-1], conv_s(init_dout_d[12*Width_D-1],init_dout_d[12*Width_D-2 : 11*Width_D])} ; 
    	ram_din34 = {init_dout_d[12*Width_D-1], conv_s(init_dout_d[12*Width_D-1],init_dout_d[12*Width_D-2 : 11*Width_D])} ; 
    	ram_din35 = {init_dout_d[12*Width_D-1], conv_s(init_dout_d[12*Width_D-1],init_dout_d[12*Width_D-2 : 11*Width_D])} ; 
 
    	ram_din36 = {init_dout_d[13*Width_D-1], conv_s(init_dout_d[13*Width_D-1],init_dout_d[13*Width_D-2 : 12*Width_D])} ;                       
    	ram_din37 = {init_dout_d[13*Width_D-1], conv_s(init_dout_d[13*Width_D-1],init_dout_d[13*Width_D-2 : 12*Width_D])} ;                      
    	ram_din38 = {init_dout_d[13*Width_D-1], conv_s(init_dout_d[13*Width_D-1],init_dout_d[13*Width_D-2 : 12*Width_D])} ;                       
    	
    	ram_din39 = {init_dout_d[14*Width_D-1], conv_s(init_dout_d[14*Width_D-1],init_dout_d[14*Width_D-2 : 13*Width_D])} ;     	
    	ram_din40 = {init_dout_d[14*Width_D-1], conv_s(init_dout_d[14*Width_D-1],init_dout_d[14*Width_D-2 : 13*Width_D])} ;     	
    	ram_din41 = {init_dout_d[14*Width_D-1], conv_s(init_dout_d[14*Width_D-1],init_dout_d[14*Width_D-2 : 13*Width_D])} ;     	
    	
    	ram_din42 = {init_dout_d[15*Width_D-1], conv_s(init_dout_d[15*Width_D-1],init_dout_d[15*Width_D-2 : 14*Width_D])} ;     	
    	ram_din43 = {init_dout_d[15*Width_D-1], conv_s(init_dout_d[15*Width_D-1],init_dout_d[15*Width_D-2 : 14*Width_D])} ;     	
    	ram_din44 = {init_dout_d[15*Width_D-1], conv_s(init_dout_d[15*Width_D-1],init_dout_d[15*Width_D-2 : 14*Width_D])} ;     	
    	
    	ram_din45 = {init_dout_d[16*Width_D-1], conv_s(init_dout_d[16*Width_D-1],init_dout_d[16*Width_D-2 : 15*Width_D])} ;     	
    	ram_din46 = {init_dout_d[16*Width_D-1], conv_s(init_dout_d[16*Width_D-1],init_dout_d[16*Width_D-2 : 15*Width_D])} ;     	
    	ram_din47 = {init_dout_d[16*Width_D-1], conv_s(init_dout_d[16*Width_D-1],init_dout_d[16*Width_D-2 : 15*Width_D])} ;  
    	
    	ram_din48 = {init_dout_d[17*Width_D-1], conv_s(init_dout_d[17*Width_D-1],init_dout_d[17*Width_D-2 : 16*Width_D])} ;     	   	
    	ram_din49 = {init_dout_d[17*Width_D-1], conv_s(init_dout_d[17*Width_D-1],init_dout_d[17*Width_D-2 : 16*Width_D])} ;     	
    	ram_din50 = {init_dout_d[17*Width_D-1], conv_s(init_dout_d[17*Width_D-1],init_dout_d[17*Width_D-2 : 16*Width_D])} ;     	
    	
    	ram_din51 = {init_dout_d[18*Width_D-1], conv_s(init_dout_d[18*Width_D-1],init_dout_d[18*Width_D-2 : 17*Width_D])} ;     	
    	ram_din52 = {init_dout_d[18*Width_D-1], conv_s(init_dout_d[18*Width_D-1],init_dout_d[18*Width_D-2 : 17*Width_D])} ;     	
    	ram_din53 = {init_dout_d[18*Width_D-1], conv_s(init_dout_d[18*Width_D-1],init_dout_d[18*Width_D-2 : 17*Width_D])} ;     	 

    	ram_din54 = {init_dout_d[19*Width_D-1], conv_s(init_dout_d[19*Width_D-1],init_dout_d[19*Width_D-2 : 18*Width_D])} ; 
    	ram_din55 = {init_dout_d[19*Width_D-1], conv_s(init_dout_d[19*Width_D-1],init_dout_d[19*Width_D-2 : 18*Width_D])} ; 
    	ram_din56 = {init_dout_d[19*Width_D-1], conv_s(init_dout_d[19*Width_D-1],init_dout_d[19*Width_D-2 : 18*Width_D])} ; 

    	ram_din57 = {init_dout_d[20*Width_D-1], conv_s(init_dout_d[20*Width_D-1],init_dout_d[20*Width_D-2 : 19*Width_D])} ;                                
    	ram_din58 = {init_dout_d[20*Width_D-1], conv_s(init_dout_d[20*Width_D-1],init_dout_d[20*Width_D-2 : 19*Width_D])} ;                                
    	ram_din59 = {init_dout_d[20*Width_D-1], conv_s(init_dout_d[20*Width_D-1],init_dout_d[20*Width_D-2 : 19*Width_D])} ;                                

    	ram_din60 = {init_dout_d[21*Width_D-1], conv_s(init_dout_d[21*Width_D-1],init_dout_d[21*Width_D-2 : 20*Width_D])} ;  
    	ram_din61 = {init_dout_d[21*Width_D-1], conv_s(init_dout_d[21*Width_D-1],init_dout_d[21*Width_D-2 : 20*Width_D])} ;   
    	ram_din62 = {init_dout_d[21*Width_D-1], conv_s(init_dout_d[21*Width_D-1],init_dout_d[21*Width_D-2 : 20*Width_D])} ;      	
    	
    	ram_din63 = {init_dout_d[22*Width_D-1], conv_s(init_dout_d[22*Width_D-1],init_dout_d[22*Width_D-2 : 21*Width_D])} ;      	
    	ram_din64 = {init_dout_d[22*Width_D-1], conv_s(init_dout_d[22*Width_D-1],init_dout_d[22*Width_D-2 : 21*Width_D])} ;      	
    	ram_din65 = {init_dout_d[22*Width_D-1], conv_s(init_dout_d[22*Width_D-1],init_dout_d[22*Width_D-2 : 21*Width_D])} ;      	
    	
    	ram_din66 = {init_dout_d[23*Width_D-1], conv_s(init_dout_d[23*Width_D-1],init_dout_d[23*Width_D-2 : 22*Width_D])} ;      	
    	ram_din67 = {init_dout_d[23*Width_D-1], conv_s(init_dout_d[23*Width_D-1],init_dout_d[23*Width_D-2 : 22*Width_D])} ;      	
    	ram_din68 = {init_dout_d[23*Width_D-1], conv_s(init_dout_d[23*Width_D-1],init_dout_d[23*Width_D-2 : 22*Width_D])} ;      	
    	
    	ram_din69 = {init_dout_d[24*Width_D-1], conv_s(init_dout_d[24*Width_D-1],init_dout_d[24*Width_D-2 : 23*Width_D])} ;      	
    	ram_din70 = {init_dout_d[24*Width_D-1], conv_s(init_dout_d[24*Width_D-1],init_dout_d[24*Width_D-2 : 23*Width_D])} ;      	
    	ram_din71 = {init_dout_d[24*Width_D-1], conv_s(init_dout_d[24*Width_D-1],init_dout_d[24*Width_D-2 : 23*Width_D])} ;      	
    	
    	ram_din72 = {init_dout_d[25*Width_D-1], conv_s(init_dout_d[25*Width_D-1],init_dout_d[25*Width_D-2 : 24*Width_D])} ;      	
    	ram_din73 = {init_dout_d[25*Width_D-1], conv_s(init_dout_d[25*Width_D-1],init_dout_d[25*Width_D-2 : 24*Width_D])} ;      	
    	ram_din74 = {init_dout_d[25*Width_D-1], conv_s(init_dout_d[25*Width_D-1],init_dout_d[25*Width_D-2 : 24*Width_D])} ;      	
    	                                                                                         
    	ram_din75 = {init_dout_d[26*Width_D-1], conv_s(init_dout_d[26*Width_D-1],init_dout_d[26*Width_D-2 : 25*Width_D])} ;      	
    	ram_din76 = {init_dout_d[26*Width_D-1], conv_s(init_dout_d[26*Width_D-1],init_dout_d[26*Width_D-2 : 25*Width_D])} ;      	
    	ram_din77 = {init_dout_d[26*Width_D-1], conv_s(init_dout_d[26*Width_D-1],init_dout_d[26*Width_D-2 : 25*Width_D])} ;      	
    	                                                                                         
    	ram_din78 = {init_dout_d[27*Width_D-1], conv_s(init_dout_d[27*Width_D-1],init_dout_d[27*Width_D-2 : 26*Width_D])} ;      	
    	ram_din79 = {init_dout_d[27*Width_D-1], conv_s(init_dout_d[27*Width_D-1],init_dout_d[27*Width_D-2 : 26*Width_D])} ;      	
    	ram_din80 = {init_dout_d[27*Width_D-1], conv_s(init_dout_d[27*Width_D-1],init_dout_d[27*Width_D-2 : 26*Width_D])} ;      	
    	                                                                                         
    	ram_din81 = {init_dout_d[28*Width_D-1], conv_s(init_dout_d[28*Width_D-1],init_dout_d[28*Width_D-2 : 27*Width_D])} ;      	
    	ram_din82 = {init_dout_d[28*Width_D-1], conv_s(init_dout_d[28*Width_D-1],init_dout_d[28*Width_D-2 : 27*Width_D])} ;      	
    	ram_din83 = {init_dout_d[28*Width_D-1], conv_s(init_dout_d[28*Width_D-1],init_dout_d[28*Width_D-2 : 27*Width_D])} ;    
  	
    	ram_din84 = {init_dout_d[29*Width_D-1], conv_s(init_dout_d[29*Width_D-1],init_dout_d[29*Width_D-2 : 28*Width_D])} ;      	  	
    	ram_din85 = {init_dout_d[29*Width_D-1], conv_s(init_dout_d[29*Width_D-1],init_dout_d[29*Width_D-2 : 28*Width_D])} ;      	
    	ram_din86 = {init_dout_d[29*Width_D-1], conv_s(init_dout_d[29*Width_D-1],init_dout_d[29*Width_D-2 : 28*Width_D])} ;      	
    	
    	ram_din87 = {init_dout_d[30*Width_D-1], conv_s(init_dout_d[30*Width_D-1],init_dout_d[30*Width_D-2 : 29*Width_D])} ;      	
    	ram_din88 = {init_dout_d[30*Width_D-1], conv_s(init_dout_d[30*Width_D-1],init_dout_d[30*Width_D-2 : 29*Width_D])} ;      	
    	ram_din89 = {init_dout_d[30*Width_D-1], conv_s(init_dout_d[30*Width_D-1],init_dout_d[30*Width_D-2 : 29*Width_D])} ;      	
    	
    	ram_din90 = {init_dout_d[31*Width_D-1], conv_s(init_dout_d[31*Width_D-1],init_dout_d[31*Width_D-2 : 30*Width_D])} ;     	
    	ram_din91 = {init_dout_d[31*Width_D-1], conv_s(init_dout_d[31*Width_D-1],init_dout_d[31*Width_D-2 : 30*Width_D])} ;     	
    	ram_din92 = {init_dout_d[31*Width_D-1], conv_s(init_dout_d[31*Width_D-1],init_dout_d[31*Width_D-2 : 30*Width_D])} ;     	
    	
    	ram_din93 = {init_dout_d[32*Width_D-1], conv_s(init_dout_d[32*Width_D-1],init_dout_d[32*Width_D-2 : 31*Width_D])} ;     	
    	ram_din94 = {init_dout_d[32*Width_D-1], conv_s(init_dout_d[32*Width_D-1],init_dout_d[32*Width_D-2 : 31*Width_D])} ;     	
    	ram_din95 = {init_dout_d[32*Width_D-1], conv_s(init_dout_d[32*Width_D-1],init_dout_d[32*Width_D-2 : 31*Width_D])} ;     	
    	
    	ram_din96 = {init_dout_d[33*Width_D-1], conv_s(init_dout_d[33*Width_D-1],init_dout_d[33*Width_D-2 : 32*Width_D])} ;     	
    	ram_din97 = {init_dout_d[33*Width_D-1], conv_s(init_dout_d[33*Width_D-1],init_dout_d[33*Width_D-2 : 32*Width_D])} ;     	
    	ram_din98 = {init_dout_d[33*Width_D-1], conv_s(init_dout_d[33*Width_D-1],init_dout_d[33*Width_D-2 : 32*Width_D])} ;     	
    	
    	ram_din99 = {init_dout_d[34*Width_D-1], conv_s(init_dout_d[34*Width_D-1],init_dout_d[34*Width_D-2 : 33*Width_D])} ;     	
    	ram_din100= {init_dout_d[34*Width_D-1], conv_s(init_dout_d[34*Width_D-1],init_dout_d[34*Width_D-2 : 33*Width_D])} ;     	
    	ram_din101= {init_dout_d[34*Width_D-1], conv_s(init_dout_d[34*Width_D-1],init_dout_d[34*Width_D-2 : 33*Width_D])} ;     	
    	
    	ram_din102= {init_dout_d[35*Width_D-1], conv_s(init_dout_d[35*Width_D-1],init_dout_d[35*Width_D-2 : 34*Width_D])} ;     	
    	ram_din103= {init_dout_d[35*Width_D-1], conv_s(init_dout_d[35*Width_D-1],init_dout_d[35*Width_D-2 : 34*Width_D])} ;     	
    	ram_din104= {init_dout_d[35*Width_D-1], conv_s(init_dout_d[35*Width_D-1],init_dout_d[35*Width_D-2 : 34*Width_D])} ;     
    	
    	ram_din105= {init_dout_d[36*Width_D-1], conv_s(init_dout_d[36*Width_D-1],init_dout_d[36*Width_D-2 : 35*Width_D])} ;     	
    	ram_din106= {init_dout_d[36*Width_D-1], conv_s(init_dout_d[36*Width_D-1],init_dout_d[36*Width_D-2 : 35*Width_D])} ;     	
    	ram_din107= {init_dout_d[36*Width_D-1], conv_s(init_dout_d[36*Width_D-1],init_dout_d[36*Width_D-2 : 35*Width_D])} ;     	
    end		
    else if (state[2])
    begin
        ram_din0 = {1'b0 , ram_din_d[Width_D-1 : 0]} ;
        ram_din1 = {1'b0 , ram_din_d[2*Width_D-1 : 1*Width_D]} ;
        ram_din2 = {1'b0 , ram_din_d[3*Width_D-1 : 2*Width_D]} ;
        ram_din3 = {1'b0 , ram_din_d[4*Width_D-1 : 3*Width_D]} ;
        ram_din4 = {1'b0 , ram_din_d[5*Width_D-1 : 4*Width_D]} ;
        ram_din5 = {1'b0 , ram_din_d[6*Width_D-1 : 5*Width_D]} ;
        ram_din6 = {1'b0 , ram_din_d[7*Width_D-1 : 6*Width_D]} ;
        ram_din7 = {1'b0 , ram_din_d[8*Width_D-1 : 7*Width_D]} ;
        ram_din8 = {1'b0 , ram_din_d[9*Width_D-1 : 8*Width_D]} ;
        ram_din9 = {1'b0 , ram_din_d[10*Width_D-1 : 9*Width_D]} ;
       
        ram_din10 = {1'b0 , ram_din_d[11*Width_D-1 : 10*Width_D]} ;
        ram_din11 = {1'b0 , ram_din_d[12*Width_D-1 : 11*Width_D]} ;
        ram_din12 = {1'b0 , ram_din_d[13*Width_D-1 : 12*Width_D]} ;
        ram_din13 = {1'b0 , ram_din_d[14*Width_D-1 : 13*Width_D]} ;
        ram_din14 = {1'b0 , ram_din_d[15*Width_D-1 : 14*Width_D]} ;
        ram_din15 = {1'b0 , ram_din_d[16*Width_D-1 : 15*Width_D]} ;
        ram_din16 = {1'b0 , ram_din_d[17*Width_D-1 : 16*Width_D]} ;
        ram_din17 = {1'b0 , ram_din_d[18*Width_D-1 : 17*Width_D]} ;
        ram_din18 = {1'b0 , ram_din_d[19*Width_D-1 : 18*Width_D]} ;
        ram_din19 = {1'b0 , ram_din_d[20*Width_D-1 : 19*Width_D]} ;
                                 
        ram_din20 = {1'b0 , ram_din_d[21*Width_D-1 : 20*Width_D]} ;
        ram_din21 = {1'b0 , ram_din_d[22*Width_D-1 : 21*Width_D]} ;
        ram_din22 = {1'b0 , ram_din_d[23*Width_D-1 : 22*Width_D]} ;
        ram_din23 = {1'b0 , ram_din_d[24*Width_D-1 : 23*Width_D]} ;
        ram_din24 = {1'b0 , ram_din_d[25*Width_D-1 : 24*Width_D]} ;
        ram_din25 = {1'b0 , ram_din_d[26*Width_D-1 : 25*Width_D]} ;
        ram_din26 = {1'b0 , ram_din_d[27*Width_D-1 : 26*Width_D]} ;
        ram_din27 = {1'b0 , ram_din_d[28*Width_D-1 : 27*Width_D]} ;
        ram_din28 = {1'b0 , ram_din_d[29*Width_D-1 : 28*Width_D]} ;
        ram_din29 = {1'b0 , ram_din_d[30*Width_D-1 : 29*Width_D]} ;
                                 
        ram_din30 = {1'b0 , ram_din_d[31*Width_D-1 : 30*Width_D]} ;
        ram_din31 = {1'b0 , ram_din_d[32*Width_D-1 : 31*Width_D]} ;
        ram_din32 = {1'b0 , ram_din_d[33*Width_D-1 : 32*Width_D]} ;
        ram_din33 = {1'b0 , ram_din_d[34*Width_D-1 : 33*Width_D]} ;
        ram_din34 = {1'b0 , ram_din_d[35*Width_D-1 : 34*Width_D]} ;
        ram_din35 = {1'b0 , ram_din_d[36*Width_D-1 : 35*Width_D]} ;
        ram_din36 = {1'b0 , ram_din_d[37*Width_D-1 : 36*Width_D]} ;
        ram_din37 = {1'b0 , ram_din_d[38*Width_D-1 : 37*Width_D]} ;
        ram_din38 = {1'b0 , ram_din_d[39*Width_D-1 : 38*Width_D]} ;
        ram_din39 = {1'b0 , ram_din_d[40*Width_D-1 : 39*Width_D]} ;
                                 
        ram_din40 = {1'b0 , ram_din_d[41*Width_D-1 : 40*Width_D]} ;
        ram_din41 = {1'b0 , ram_din_d[42*Width_D-1 : 41*Width_D]} ;
        ram_din42 = {1'b0 , ram_din_d[43*Width_D-1 : 42*Width_D]} ;
        ram_din43 = {1'b0 , ram_din_d[44*Width_D-1 : 43*Width_D]} ;
        ram_din44 = {1'b0 , ram_din_d[45*Width_D-1 : 44*Width_D]} ;
        ram_din45 = {1'b0 , ram_din_d[46*Width_D-1 : 45*Width_D]} ;
        ram_din46 = {1'b0 , ram_din_d[47*Width_D-1 : 46*Width_D]} ;
        ram_din47 = {1'b0 , ram_din_d[48*Width_D-1 : 47*Width_D]} ;
        ram_din48 = {1'b0 , ram_din_d[49*Width_D-1 : 48*Width_D]} ;
        ram_din49 = {1'b0 , ram_din_d[50*Width_D-1 : 49*Width_D]} ;
                                
        ram_din50 = {1'b0 , ram_din_d[51*Width_D-1 : 50*Width_D]} ;
        ram_din51 = {1'b0 , ram_din_d[52*Width_D-1 : 51*Width_D]} ;
        ram_din52 = {1'b0 , ram_din_d[53*Width_D-1 : 52*Width_D]} ;
        ram_din53 = {1'b0 , ram_din_d[54*Width_D-1 : 53*Width_D]} ;
        ram_din54 = {1'b0 , ram_din_d[55*Width_D-1 : 54*Width_D]} ;
        ram_din55 = {1'b0 , ram_din_d[56*Width_D-1 : 55*Width_D]} ;
        ram_din56 = {1'b0 , ram_din_d[57*Width_D-1 : 56*Width_D]} ;
        ram_din57 = {1'b0 , ram_din_d[58*Width_D-1 : 57*Width_D]} ;
        ram_din58 = {1'b0 , ram_din_d[59*Width_D-1 : 58*Width_D]} ;
        ram_din59 = {1'b0 , ram_din_d[60*Width_D-1 : 59*Width_D]} ;
                                
        ram_din60 = {1'b0 , ram_din_d[61*Width_D-1 : 60*Width_D]} ;
        ram_din61 = {1'b0 , ram_din_d[62*Width_D-1 : 61*Width_D]} ;
        ram_din62 = {1'b0 , ram_din_d[63*Width_D-1 : 62*Width_D]} ;
        ram_din63 = {1'b0 , ram_din_d[64*Width_D-1 : 63*Width_D]} ;
        ram_din64 = {1'b0 , ram_din_d[65*Width_D-1 : 64*Width_D]} ;
        ram_din65 = {1'b0 , ram_din_d[66*Width_D-1 : 65*Width_D]} ;
        ram_din66 = {1'b0 , ram_din_d[67*Width_D-1 : 66*Width_D]} ;
        ram_din67 = {1'b0 , ram_din_d[68*Width_D-1 : 67*Width_D]} ;
        ram_din68 = {1'b0 , ram_din_d[69*Width_D-1 : 68*Width_D]} ;
        ram_din69 = {1'b0 , ram_din_d[70*Width_D-1 : 69*Width_D]} ;
                                 
        ram_din70 = {1'b0 , ram_din_d[71*Width_D-1 : 70*Width_D]} ;
        ram_din71 = {1'b0 , ram_din_d[72*Width_D-1 : 71*Width_D]} ;
        ram_din72 = {1'b0 , ram_din_d[73*Width_D-1 : 72*Width_D]} ;
        ram_din73 = {1'b0 , ram_din_d[74*Width_D-1 : 73*Width_D]} ;
        ram_din74 = {1'b0 , ram_din_d[75*Width_D-1 : 74*Width_D]} ;
        ram_din75 = {1'b0 , ram_din_d[76*Width_D-1 : 75*Width_D]} ;
        ram_din76 = {1'b0 , ram_din_d[77*Width_D-1 : 76*Width_D]} ;
        ram_din77 = {1'b0 , ram_din_d[78*Width_D-1 : 77*Width_D]} ;
        ram_din78 = {1'b0 , ram_din_d[79*Width_D-1 : 78*Width_D]} ;
        ram_din79 = {1'b0 , ram_din_d[80*Width_D-1 : 79*Width_D]} ;
                                 
        ram_din80 = {1'b0 , ram_din_d[81*Width_D-1 : 80*Width_D]} ;
        ram_din81 = {1'b0 , ram_din_d[82*Width_D-1 : 81*Width_D]} ;
        ram_din82 = {1'b0 , ram_din_d[83*Width_D-1 : 82*Width_D]} ;
        ram_din83 = {1'b0 , ram_din_d[84*Width_D-1 : 83*Width_D]} ;
        ram_din84 = {1'b0 , ram_din_d[85*Width_D-1 : 84*Width_D]} ;
        ram_din85 = {1'b0 , ram_din_d[86*Width_D-1 : 85*Width_D]} ;
        ram_din86 = {1'b0 , ram_din_d[87*Width_D-1 : 86*Width_D]} ;
        ram_din87 = {1'b0 , ram_din_d[88*Width_D-1 : 87*Width_D]} ;
        ram_din88 = {1'b0 , ram_din_d[89*Width_D-1 : 88*Width_D]} ;
        ram_din89 = {1'b0 , ram_din_d[90*Width_D-1 : 89*Width_D]} ;
                                
        ram_din90 = {1'b0 , ram_din_d[91*Width_D-1 : 90*Width_D]} ;
        ram_din91 = {1'b0 , ram_din_d[92*Width_D-1 : 91*Width_D]} ;
        ram_din92 = {1'b0 , ram_din_d[93*Width_D-1 : 92*Width_D]} ;
        ram_din93 = {1'b0 , ram_din_d[94*Width_D-1 : 93*Width_D]} ;
        ram_din94 = {1'b0 , ram_din_d[95*Width_D-1 : 94*Width_D]} ;
        ram_din95 = {1'b0 , ram_din_d[96*Width_D-1 : 95*Width_D]} ;
        ram_din96 = {1'b0 , ram_din_d[97*Width_D-1 : 96*Width_D]} ;
        ram_din97 = {1'b0 , ram_din_d[98*Width_D-1 : 97*Width_D]} ;
        ram_din98 = {1'b0 , ram_din_d[99*Width_D-1 : 98*Width_D]} ;
        ram_din99 = {1'b0 , ram_din_d[100*Width_D-1 : 99*Width_D]} ;
       
        ram_din100 = {1'b0 , ram_din_d[101*Width_D-1 : 100*Width_D]} ;
        ram_din101 = {1'b0 , ram_din_d[102*Width_D-1 : 101*Width_D]} ;
        ram_din102 = {1'b0 , ram_din_d[103*Width_D-1 : 102*Width_D]} ;
        ram_din103 = {1'b0 , ram_din_d[104*Width_D-1 : 103*Width_D]} ;
        ram_din104 = {1'b0 , ram_din_d[105*Width_D-1 : 104*Width_D]} ;
        ram_din105 = {1'b0 , ram_din_d[106*Width_D-1 : 105*Width_D]} ;
        ram_din106 = {1'b0 , ram_din_d[107*Width_D-1 : 106*Width_D]} ;
        ram_din107 = {1'b0 , ram_din_d[108*Width_D-1 : 107*Width_D]} ;
    end
    else if (state[3])
    begin
        ram_din0 = {dd1[0] , vpu_dout[Width_D-1 : 0]} ;
        ram_din1 = {dd1[0] , vpu_dout[2*Width_D-1 : 1*Width_D]} ;
        ram_din2 = {dd1[0] , vpu_dout[3*Width_D-1 : 2*Width_D]} ;
        ram_din3 = {dd1[1] , vpu_dout[4*Width_D-1 : 3*Width_D]} ;
        ram_din4 = {dd1[1] , vpu_dout[5*Width_D-1 : 4*Width_D]} ;
        ram_din5 = {dd1[1] , vpu_dout[6*Width_D-1 : 5*Width_D]} ;
        ram_din6 = {dd1[2] , vpu_dout[7*Width_D-1 : 6*Width_D]} ;
        ram_din7 = {dd1[2] , vpu_dout[8*Width_D-1 : 7*Width_D]} ;
        ram_din8 = {dd1[2] , vpu_dout[9*Width_D-1 : 8*Width_D]} ;
        ram_din9 = {dd1[3] , vpu_dout[10*Width_D-1 : 9*Width_D]} ;
       
        ram_din10 = {dd1[3] , vpu_dout[11*Width_D-1 : 10*Width_D]} ;
        ram_din11 = {dd1[3] , vpu_dout[12*Width_D-1 : 11*Width_D]} ;
        ram_din12 = {dd1[4] , vpu_dout[13*Width_D-1 : 12*Width_D]} ;
        ram_din13 = {dd1[4] , vpu_dout[14*Width_D-1 : 13*Width_D]} ;
        ram_din14 = {dd1[4] , vpu_dout[15*Width_D-1 : 14*Width_D]} ;
        ram_din15 = {dd1[5] , vpu_dout[16*Width_D-1 : 15*Width_D]} ;
        ram_din16 = {dd1[5] , vpu_dout[17*Width_D-1 : 16*Width_D]} ;
        ram_din17 = {dd1[5] , vpu_dout[18*Width_D-1 : 17*Width_D]} ;
        ram_din18 = {dd1[6] , vpu_dout[19*Width_D-1 : 18*Width_D]} ;
        ram_din19 = {dd1[6] , vpu_dout[20*Width_D-1 : 19*Width_D]} ;
       
        ram_din20 = {dd1[6] , vpu_dout[21*Width_D-1 : 20*Width_D]} ;
        ram_din21 = {dd1[7] , vpu_dout[22*Width_D-1 : 21*Width_D]} ;
        ram_din22 = {dd1[7] , vpu_dout[23*Width_D-1 : 22*Width_D]} ;
        ram_din23 = {dd1[7] , vpu_dout[24*Width_D-1 : 23*Width_D]} ;
        ram_din24 = {dd1[8] , vpu_dout[25*Width_D-1 : 24*Width_D]} ;
        ram_din25 = {dd1[8] , vpu_dout[26*Width_D-1 : 25*Width_D]} ;
        ram_din26 = {dd1[8] , vpu_dout[27*Width_D-1 : 26*Width_D]} ;
        ram_din27 = {dd1[9] , vpu_dout[28*Width_D-1 : 27*Width_D]} ;
        ram_din28 = {dd1[9] , vpu_dout[29*Width_D-1 : 28*Width_D]} ;
        ram_din29 = {dd1[9] , vpu_dout[30*Width_D-1 : 29*Width_D]} ;
       
        ram_din30 = {dd1[10] , vpu_dout[31*Width_D-1 : 30*Width_D]} ;
        ram_din31 = {dd1[10] , vpu_dout[32*Width_D-1 : 31*Width_D]} ;
        ram_din32 = {dd1[10] , vpu_dout[33*Width_D-1 : 32*Width_D]} ;
        ram_din33 = {dd1[11] , vpu_dout[34*Width_D-1 : 33*Width_D]} ;
        ram_din34 = {dd1[11] , vpu_dout[35*Width_D-1 : 34*Width_D]} ;
        ram_din35 = {dd1[11] , vpu_dout[36*Width_D-1 : 35*Width_D]} ;
        ram_din36 = {dd1[12] , vpu_dout[37*Width_D-1 : 36*Width_D]} ;
        ram_din37 = {dd1[12] , vpu_dout[38*Width_D-1 : 37*Width_D]} ;
        ram_din38 = {dd1[12] , vpu_dout[39*Width_D-1 : 38*Width_D]} ;
        ram_din39 = {dd1[13] , vpu_dout[40*Width_D-1 : 39*Width_D]} ;
       
        ram_din40 = {dd1[13] , vpu_dout[41*Width_D-1 : 40*Width_D]} ;
        ram_din41 = {dd1[13] , vpu_dout[42*Width_D-1 : 41*Width_D]} ;
        ram_din42 = {dd1[14] , vpu_dout[43*Width_D-1 : 42*Width_D]} ;
        ram_din43 = {dd1[14] , vpu_dout[44*Width_D-1 : 43*Width_D]} ;
        ram_din44 = {dd1[14] , vpu_dout[45*Width_D-1 : 44*Width_D]} ;
        ram_din45 = {dd1[15] , vpu_dout[46*Width_D-1 : 45*Width_D]} ;
        ram_din46 = {dd1[15] , vpu_dout[47*Width_D-1 : 46*Width_D]} ;
        ram_din47 = {dd1[15] , vpu_dout[48*Width_D-1 : 47*Width_D]} ;
        ram_din48 = {dd1[16] , vpu_dout[49*Width_D-1 : 48*Width_D]} ;
        ram_din49 = {dd1[16] , vpu_dout[50*Width_D-1 : 49*Width_D]} ;
       
        ram_din50 = {dd1[16] , vpu_dout[51*Width_D-1 : 50*Width_D]} ;
        ram_din51 = {dd1[17] , vpu_dout[52*Width_D-1 : 51*Width_D]} ;
        ram_din52 = {dd1[17] , vpu_dout[53*Width_D-1 : 52*Width_D]} ;
        ram_din53 = {dd1[17] , vpu_dout[54*Width_D-1 : 53*Width_D]} ;
        ram_din54 = {dd1[18] , vpu_dout[55*Width_D-1 : 54*Width_D]} ;
        ram_din55 = {dd1[18] , vpu_dout[56*Width_D-1 : 55*Width_D]} ;
        ram_din56 = {dd1[18] , vpu_dout[57*Width_D-1 : 56*Width_D]} ;
        ram_din57 = {dd1[19] , vpu_dout[58*Width_D-1 : 57*Width_D]} ;
        ram_din58 = {dd1[19] , vpu_dout[59*Width_D-1 : 58*Width_D]} ;
        ram_din59 = {dd1[19] , vpu_dout[60*Width_D-1 : 59*Width_D]} ;
       
        ram_din60 = {dd1[20] , vpu_dout[61*Width_D-1 : 60*Width_D]} ;
        ram_din61 = {dd1[20] , vpu_dout[62*Width_D-1 : 61*Width_D]} ;
        ram_din62 = {dd1[20] , vpu_dout[63*Width_D-1 : 62*Width_D]} ;
        ram_din63 = {dd1[21] , vpu_dout[64*Width_D-1 : 63*Width_D]} ;
        ram_din64 = {dd1[21] , vpu_dout[65*Width_D-1 : 64*Width_D]} ;
        ram_din65 = {dd1[21] , vpu_dout[66*Width_D-1 : 65*Width_D]} ;
        ram_din66 = {dd1[22] , vpu_dout[67*Width_D-1 : 66*Width_D]} ;
        ram_din67 = {dd1[22] , vpu_dout[68*Width_D-1 : 67*Width_D]} ;
        ram_din68 = {dd1[22] , vpu_dout[69*Width_D-1 : 68*Width_D]} ;
        ram_din69 = {dd1[23] , vpu_dout[70*Width_D-1 : 69*Width_D]} ;
       
        ram_din70 = {dd1[23] , vpu_dout[71*Width_D-1 : 70*Width_D]} ;
        ram_din71 = {dd1[23] , vpu_dout[72*Width_D-1 : 71*Width_D]} ;
        ram_din72 = {dd1[24] , vpu_dout[73*Width_D-1 : 72*Width_D]} ;
        ram_din73 = {dd1[24] , vpu_dout[74*Width_D-1 : 73*Width_D]} ;
        ram_din74 = {dd1[24] , vpu_dout[75*Width_D-1 : 74*Width_D]} ;
        ram_din75 = {dd1[25] , vpu_dout[76*Width_D-1 : 75*Width_D]} ;
        ram_din76 = {dd1[25] , vpu_dout[77*Width_D-1 : 76*Width_D]} ;
        ram_din77 = {dd1[25] , vpu_dout[78*Width_D-1 : 77*Width_D]} ;
        ram_din78 = {dd1[26] , vpu_dout[79*Width_D-1 : 78*Width_D]} ;
        ram_din79 = {dd1[26] , vpu_dout[80*Width_D-1 : 79*Width_D]} ;
       
        ram_din80 = {dd1[26] , vpu_dout[81*Width_D-1 : 80*Width_D]} ;
        ram_din81 = {dd1[27] , vpu_dout[82*Width_D-1 : 81*Width_D]} ;
        ram_din82 = {dd1[27] , vpu_dout[83*Width_D-1 : 82*Width_D]} ;
        ram_din83 = {dd1[27] , vpu_dout[84*Width_D-1 : 83*Width_D]} ;
        ram_din84 = {dd1[28] , vpu_dout[85*Width_D-1 : 84*Width_D]} ;
        ram_din85 = {dd1[28] , vpu_dout[86*Width_D-1 : 85*Width_D]} ;
        ram_din86 = {dd1[28] , vpu_dout[87*Width_D-1 : 86*Width_D]} ;
        ram_din87 = {dd1[29] , vpu_dout[88*Width_D-1 : 87*Width_D]} ;
        ram_din88 = {dd1[29] , vpu_dout[89*Width_D-1 : 88*Width_D]} ;
        ram_din89 = {dd1[29] , vpu_dout[90*Width_D-1 : 89*Width_D]} ;
       
        ram_din90 = {dd1[30] , vpu_dout[91*Width_D-1 : 90*Width_D]} ;
        ram_din91 = {dd1[30] , vpu_dout[92*Width_D-1 : 91*Width_D]} ;
        ram_din92 = {dd1[30] , vpu_dout[93*Width_D-1 : 92*Width_D]} ;
        ram_din93 = {dd1[31] , vpu_dout[94*Width_D-1 : 93*Width_D]} ;
        ram_din94 = {dd1[31] , vpu_dout[95*Width_D-1 : 94*Width_D]} ;
        ram_din95 = {dd1[31] , vpu_dout[96*Width_D-1 : 95*Width_D]} ;
        ram_din96 = {dd1[32] , vpu_dout[97*Width_D-1 : 96*Width_D]} ;
        ram_din97 = {dd1[32] , vpu_dout[98*Width_D-1 : 97*Width_D]} ;
        ram_din98 = {dd1[32] , vpu_dout[99*Width_D-1 : 98*Width_D]} ;
        ram_din99 = {dd1[33] , vpu_dout[100*Width_D-1 : 99*Width_D]} ;
       
        ram_din100 = {dd1[33] , vpu_dout[101*Width_D-1 : 100*Width_D]} ;
        ram_din101 = {dd1[33] , vpu_dout[102*Width_D-1 : 101*Width_D]} ;
        ram_din102 = {dd1[34] , vpu_dout[103*Width_D-1 : 102*Width_D]} ;
        ram_din103 = {dd1[34] , vpu_dout[104*Width_D-1 : 103*Width_D]} ;
        ram_din104 = {dd1[34] , vpu_dout[105*Width_D-1 : 104*Width_D]} ;
        ram_din105 = {dd1[35] , vpu_dout[106*Width_D-1 : 105*Width_D]} ;
        ram_din106 = {dd1[35] , vpu_dout[107*Width_D-1 : 106*Width_D]} ;
        ram_din107 = {dd1[35] , vpu_dout[108*Width_D-1 : 107*Width_D]} ;
    end
    else begin
        ram_din0 = 0;
        ram_din1 = 0;
        ram_din2 = 0;
        ram_din3 = 0;
        ram_din4 = 0;
        ram_din5 = 0;
        ram_din6 = 0;
        ram_din7 = 0;
        ram_din8 = 0;
        ram_din9 = 0;
       
        ram_din10 = 0;
        ram_din11 = 0;
        ram_din12 = 0;
        ram_din13 = 0;
        ram_din14 = 0;
        ram_din15 = 0;
        ram_din16 = 0;
        ram_din17 = 0;
        ram_din18 = 0;
        ram_din19 = 0;
       
        ram_din20 = 0;
        ram_din21 = 0;
        ram_din22 = 0;
        ram_din23 = 0;
        ram_din24 = 0;
        ram_din25 = 0;
        ram_din26 = 0;
        ram_din27 = 0;
        ram_din28 = 0;
        ram_din29 = 0;
       
        ram_din30 = 0;
        ram_din31 = 0;
        ram_din32 = 0;
        ram_din33 = 0;
        ram_din34 = 0;
        ram_din35 = 0;
        ram_din36 = 0;
        ram_din37 = 0;
        ram_din38 = 0;
        ram_din39 = 0;
       
        ram_din40 = 0;
        ram_din41 = 0;
        ram_din42 = 0;
        ram_din43 = 0;
        ram_din44 = 0;
        ram_din45 = 0;
        ram_din46 = 0;
        ram_din47 = 0;
        ram_din48 = 0;
        ram_din49 = 0;
       
        ram_din50 = 0;
        ram_din51 = 0;
        ram_din52 = 0;
        ram_din53 = 0;
        ram_din54 = 0;
        ram_din55 = 0;
        ram_din56 = 0;
        ram_din57 = 0;
        ram_din58 = 0;
        ram_din59 = 0;
       
        ram_din60 = 0;
        ram_din61 = 0;
        ram_din62 = 0;
        ram_din63 = 0;
        ram_din64 = 0;
        ram_din65 = 0;
        ram_din66 = 0;
        ram_din67 = 0;
        ram_din68 = 0;
        ram_din69 = 0;
       
        ram_din70 = 0;
        ram_din71 = 0;
        ram_din72 = 0;
        ram_din73 = 0;
        ram_din74 = 0;
        ram_din75 = 0;
        ram_din76 = 0;
        ram_din77 = 0;
        ram_din78 = 0;
        ram_din79 = 0;
       
        ram_din80 = 0;
        ram_din81 = 0;
        ram_din82 = 0;
        ram_din83 = 0;
        ram_din84 = 0;
        ram_din85 = 0;
        ram_din86 = 0;
        ram_din87 = 0;
        ram_din88 = 0;
        ram_din89 = 0;
       
        ram_din90 = 0;
        ram_din91 = 0;
        ram_din92 = 0;
        ram_din93 = 0;
        ram_din94 = 0;
        ram_din95 = 0;
        ram_din96 = 0;
        ram_din97 = 0;
        ram_din98 = 0;
        ram_din99 = 0;
       
        ram_din100 = 0;
        ram_din101 = 0;
        ram_din102 = 0;
        ram_din103 = 0;
        ram_din104 = 0;
        ram_din105 = 0;
        ram_din106 = 0;
        ram_din107 = 0;
    end
end    


assign vpu_din =
{ram_dout107[Width_D-1 :0], 
ram_dout106[Width_D-1 : 0],
ram_dout105[Width_D-1 : 0], 
ram_dout104[Width_D-1 : 0], 
ram_dout103[Width_D-1 : 0], 
ram_dout102[Width_D-1 : 0], 
ram_dout101[Width_D-1 : 0], 
ram_dout100[Width_D-1 : 0],
ram_dout99[Width_D-1 : 0], 
ram_dout98[Width_D-1 : 0],
ram_dout97[Width_D-1 : 0],
ram_dout96[Width_D-1 : 0],
ram_dout95[Width_D-1 : 0],
ram_dout94[Width_D-1 : 0],
ram_dout93[Width_D-1 : 0],
ram_dout92[Width_D-1 : 0],
ram_dout91[Width_D-1 : 0],
ram_dout90[Width_D-1 : 0],
ram_dout89[Width_D-1 : 0],
ram_dout88[Width_D-1 : 0],
ram_dout87[Width_D-1 : 0],
ram_dout86[Width_D-1 : 0],
ram_dout85[Width_D-1 : 0],
ram_dout84[Width_D-1 : 0],
ram_dout83[Width_D-1 : 0],
ram_dout82[Width_D-1 : 0],
ram_dout81[Width_D-1 : 0],
ram_dout80[Width_D-1 : 0],
ram_dout79[Width_D-1 : 0],
ram_dout78[Width_D-1 : 0],
ram_dout77[Width_D-1 : 0],
ram_dout76[Width_D-1 : 0],
ram_dout75[Width_D-1 : 0],
ram_dout74[Width_D-1 : 0],
ram_dout73[Width_D-1 : 0],
ram_dout72[Width_D-1 : 0],
ram_dout71[Width_D-1 : 0],
ram_dout70[Width_D-1 : 0],
ram_dout69[Width_D-1 : 0],
ram_dout68[Width_D-1 : 0],
ram_dout67[Width_D-1 : 0],
ram_dout66[Width_D-1 : 0],
ram_dout65[Width_D-1 : 0],
ram_dout64[Width_D-1 : 0],
ram_dout63[Width_D-1 : 0],
ram_dout62[Width_D-1 : 0],
ram_dout61[Width_D-1 : 0],
ram_dout60[Width_D-1 : 0],
ram_dout59[Width_D-1 : 0],
ram_dout58[Width_D-1 : 0],
ram_dout57[Width_D-1 : 0],
ram_dout56[Width_D-1 : 0],
ram_dout55[Width_D-1 : 0],
ram_dout54[Width_D-1 : 0],
ram_dout53[Width_D-1 : 0],
ram_dout52[Width_D-1 : 0],
ram_dout51[Width_D-1 : 0],
ram_dout50[Width_D-1 : 0],
ram_dout49[Width_D-1 : 0],
ram_dout48[Width_D-1 : 0],
ram_dout47[Width_D-1 : 0],
ram_dout46[Width_D-1 : 0],
ram_dout45[Width_D-1 : 0],
ram_dout44[Width_D-1 : 0],
ram_dout43[Width_D-1 : 0],
ram_dout42[Width_D-1 : 0],
ram_dout41[Width_D-1 : 0],
ram_dout40[Width_D-1 : 0],
ram_dout39[Width_D-1 : 0],
ram_dout38[Width_D-1 : 0],
ram_dout37[Width_D-1 : 0],
ram_dout36[Width_D-1 : 0],
ram_dout35[Width_D-1 : 0],
ram_dout34[Width_D-1 : 0],
ram_dout33[Width_D-1 : 0],
ram_dout32[Width_D-1 : 0],
ram_dout31[Width_D-1 : 0],
ram_dout30[Width_D-1 : 0],
ram_dout29[Width_D-1 : 0],
ram_dout28[Width_D-1 : 0],
ram_dout27[Width_D-1 : 0],
ram_dout26[Width_D-1 : 0],
ram_dout25[Width_D-1 : 0],
ram_dout24[Width_D-1 : 0],
ram_dout23[Width_D-1 : 0],
ram_dout22[Width_D-1 : 0],
ram_dout21[Width_D-1 : 0],
ram_dout20[Width_D-1 : 0],
ram_dout19[Width_D-1 : 0],
ram_dout18[Width_D-1 : 0],
ram_dout17[Width_D-1 : 0],
ram_dout16[Width_D-1 : 0],
ram_dout15[Width_D-1 : 0],
ram_dout14[Width_D-1 : 0],
ram_dout13[Width_D-1 : 0],
ram_dout12[Width_D-1 : 0],
ram_dout11[Width_D-1 : 0],
ram_dout10[Width_D-1 : 0],
ram_dout9[Width_D-1 : 0],
ram_dout8[Width_D-1 : 0],
ram_dout7[Width_D-1 : 0],
ram_dout6[Width_D-1 : 0],
ram_dout5[Width_D-1 : 0],
ram_dout4[Width_D-1 : 0],
ram_dout3[Width_D-1 : 0],
ram_dout2[Width_D-1 : 0],
ram_dout1[Width_D-1 : 0],
ram_dout0[Width_D-1 : 0]};



assign ram_dout[107: 0] = 
{ram_dout107[Width_D], 
ram_dout106[Width_D],
ram_dout105[Width_D], 
ram_dout104[Width_D], 
ram_dout103[Width_D], 
ram_dout102[Width_D], 
ram_dout101[Width_D], 
ram_dout100[Width_D],
ram_dout99[Width_D], 
ram_dout98[Width_D],
ram_dout97[Width_D],
ram_dout96[Width_D],
ram_dout95[Width_D],
ram_dout94[Width_D],
ram_dout93[Width_D],
ram_dout92[Width_D],
ram_dout91[Width_D],
ram_dout90[Width_D],
ram_dout89[Width_D],
ram_dout88[Width_D],
ram_dout87[Width_D],
ram_dout86[Width_D],
ram_dout85[Width_D],
ram_dout84[Width_D],
ram_dout83[Width_D],
ram_dout82[Width_D],
ram_dout81[Width_D],
ram_dout80[Width_D],
ram_dout79[Width_D],
ram_dout78[Width_D],
ram_dout77[Width_D],
ram_dout76[Width_D],
ram_dout75[Width_D],
ram_dout74[Width_D],
ram_dout73[Width_D],
ram_dout72[Width_D],
ram_dout71[Width_D],
ram_dout70[Width_D],
ram_dout69[Width_D],
ram_dout68[Width_D],
ram_dout67[Width_D],
ram_dout66[Width_D],
ram_dout65[Width_D],
ram_dout64[Width_D],
ram_dout63[Width_D],
ram_dout62[Width_D],
ram_dout61[Width_D],
ram_dout60[Width_D],
ram_dout59[Width_D],
ram_dout58[Width_D],
ram_dout57[Width_D],
ram_dout56[Width_D],
ram_dout55[Width_D],
ram_dout54[Width_D],
ram_dout53[Width_D],
ram_dout52[Width_D],
ram_dout51[Width_D],
ram_dout50[Width_D],
ram_dout49[Width_D],
ram_dout48[Width_D],
ram_dout47[Width_D],
ram_dout46[Width_D],
ram_dout45[Width_D],
ram_dout44[Width_D],
ram_dout43[Width_D],
ram_dout42[Width_D],
ram_dout41[Width_D],
ram_dout40[Width_D],
ram_dout39[Width_D],
ram_dout38[Width_D],
ram_dout37[Width_D],
ram_dout36[Width_D],
ram_dout35[Width_D],
ram_dout34[Width_D],
ram_dout33[Width_D],
ram_dout32[Width_D],
ram_dout31[Width_D],
ram_dout30[Width_D],
ram_dout29[Width_D],
ram_dout28[Width_D],
ram_dout27[Width_D],
ram_dout26[Width_D],
ram_dout25[Width_D],
ram_dout24[Width_D],
ram_dout23[Width_D],
ram_dout22[Width_D],
ram_dout21[Width_D],
ram_dout20[Width_D],
ram_dout19[Width_D],
ram_dout18[Width_D],
ram_dout17[Width_D],
ram_dout16[Width_D],
ram_dout15[Width_D],
ram_dout14[Width_D],
ram_dout13[Width_D],
ram_dout12[Width_D],
ram_dout11[Width_D],
ram_dout10[Width_D],
ram_dout9[Width_D],
ram_dout8[Width_D],
ram_dout7[Width_D],
ram_dout6[Width_D],
ram_dout5[Width_D],
ram_dout4[Width_D],
ram_dout3[Width_D],
ram_dout2[Width_D],
ram_dout1[Width_D],
ram_dout0[Width_D]}; 


 
always@(*) begin
    	cpu_din1[0*6*Width_D + (0+1)*Width_D -1 : 0*6*Width_D+0*Width_D]
        <=  vpu_din[Width_D-1 : 0] ;

        cpu_din1[1*6*Width_D + (0+1)*Width_D -1 : 1*6*Width_D+0*Width_D]
               <=  vpu_din[2*Width_D-1 : Width_D] ;  
               
        cpu_din1[2*6*Width_D + (0+1)*Width_D -1 : 2*6*Width_D+0*Width_D]
               <=  vpu_din[3*Width_D-1 : 2*Width_D] ;         
        
        cpu_din1[3*6*Width_D + (0+1)*Width_D -1 : 3*6*Width_D+0*Width_D]
               <=  vpu_din[3 * Width_D + Width_D-1 : 3 * Width_D] ;
        
        cpu_din1[4*6*Width_D + (0+1)*Width_D -1 : 4*6*Width_D+0*Width_D]
               <=  vpu_din[3 * Width_D + 2*Width_D-1 : 3 * Width_D + Width_D] ;  
               
        cpu_din1[5*6*Width_D + (0+1)*Width_D -1 : 5*6*Width_D+0*Width_D]
               <=  vpu_din[3 * Width_D + 3*Width_D-1 : 3 * Width_D + 2*Width_D] ;   
        
        cpu_din1[6*6*Width_D + (0+1)*Width_D -1 : 6*6*Width_D+0*Width_D]
               <=  vpu_din[2 * 3 * Width_D + Width_D-1 : 2 * 3 * Width_D] ;
        
        cpu_din1[7*6*Width_D + (0+1)*Width_D -1 : 7*6*Width_D+0*Width_D]
               <=  vpu_din[2 * 3 * Width_D + 2*Width_D-1 : 2 * 3 * Width_D + Width_D] ;  
               
        cpu_din1[8*6*Width_D + (0+1)*Width_D -1 : 8*6*Width_D+0*Width_D]
               <=  vpu_din[2 * 3 * Width_D + 3*Width_D-1 : 2 * 3 * Width_D + 2*Width_D] ;  
               
        cpu_din1[9*6*Width_D + (0+1)*Width_D -1 : 9*6*Width_D+0*Width_D]
               <=  vpu_din[3 * 3 * Width_D + Width_D-1 : 3 * 3 * Width_D] ;
        
        cpu_din1[10*6*Width_D + (0+1)*Width_D -1 : 10*6*Width_D+0*Width_D]
               <=  vpu_din[3 * 3 * Width_D + 2*Width_D-1 : 3 * 3 * Width_D + Width_D] ;  
               
        cpu_din1[11*6*Width_D + (0+1)*Width_D -1 : 11*6*Width_D+0*Width_D]
               <=  vpu_din[3 * 3 * Width_D + 3*Width_D-1 : 3 * 3 * Width_D + 2*Width_D] ;
               
        cpu_din1[12*6*Width_D + (0+1)*Width_D -1 : 12*6*Width_D+0*Width_D]
               <=  vpu_din[4 * 3 * Width_D + Width_D-1 : 4 * 3 * Width_D] ;
        
        cpu_din1[13*6*Width_D + (0+1)*Width_D -1 : 13*6*Width_D+0*Width_D]
               <=  vpu_din[4 * 3 * Width_D + 2*Width_D-1 : 4 * 3 * Width_D + Width_D] ;  
               
        cpu_din1[14*6*Width_D + (0+1)*Width_D -1 : 14*6*Width_D+0*Width_D]
               <=  vpu_din[4 * 3 * Width_D + 3*Width_D-1 : 4 * 3 * Width_D + 2*Width_D] ; 
               
        cpu_din1[15*6*Width_D + (0+1)*Width_D -1 : 15*6*Width_D+0*Width_D]
               <=  vpu_din[5 * 3 * Width_D + Width_D-1 : 5 * 3 * Width_D] ;
        
        cpu_din1[16*6*Width_D + (0+1)*Width_D -1 : 16*6*Width_D+0*Width_D]
               <=  vpu_din[5 * 3 * Width_D + 2*Width_D-1 : 5 * 3 * Width_D + Width_D] ;  
               
        cpu_din1[17*6*Width_D + (0+1)*Width_D -1 : 17*6*Width_D+0*Width_D]
               <=  vpu_din[5 * 3 * Width_D + 3*Width_D-1 : 5 * 3 * Width_D + 2*Width_D] ; 
               
        cpu_din1[0*6*Width_D + (1+1)*Width_D -1 : 0*6*Width_D+1*Width_D]
               <=  vpu_din[6 * 3 * Width_D + Width_D-1 : 6 * 3 * Width_D] ;
        
        cpu_din1[3*6*Width_D + (1+1)*Width_D -1 : 3*6*Width_D+1*Width_D]
               <=  vpu_din[6 * 3 * Width_D + 2*Width_D-1 : 6 * 3 * Width_D + Width_D] ;  
               
        cpu_din1[6*6*Width_D + (1+1)*Width_D -1 : 6*6*Width_D+1*Width_D]
               <=  vpu_din[6 * 3 * Width_D + 3*Width_D-1 : 6 * 3 * Width_D + 2*Width_D] ;        
        
        cpu_din1[1*6*Width_D + (1+1)*Width_D -1 : 1*6*Width_D+1*Width_D]
               <=  vpu_din[7 * 3 * Width_D + Width_D-1 : 7 * 3 * Width_D] ;
        
        cpu_din1[9*6*Width_D + (1+1)*Width_D -1 : 9*6*Width_D+1*Width_D]
               <=  vpu_din[7 * 3 * Width_D + 2*Width_D-1 : 7 * 3 * Width_D + Width_D] ;  
               
        cpu_din1[12*6*Width_D + (1+1)*Width_D -1 : 12*6*Width_D+1*Width_D]
               <=  vpu_din[7 * 3 * Width_D + 3*Width_D-1 : 7 * 3 * Width_D + 2*Width_D] ; 
               
        cpu_din1[2*6*Width_D + (1+1)*Width_D -1 : 2*6*Width_D+1*Width_D]
               <=  vpu_din[8 * 3 * Width_D + Width_D-1 : 8 * 3 * Width_D] ;
        
        cpu_din1[4*6*Width_D + (1+1)*Width_D -1 : 4*6*Width_D+1*Width_D]
               <=  vpu_din[8 * 3 * Width_D + 2*Width_D-1 : 8 * 3 * Width_D + Width_D] ;  
               
        cpu_din1[15*6*Width_D + (1+1)*Width_D -1 : 15*6*Width_D+1*Width_D]
               <=  vpu_din[8 * 3 * Width_D + 3*Width_D-1 : 8 * 3 * Width_D + 2*Width_D] ;                               
        cpu_din1[5*6*Width_D + (1+1)*Width_D -1 : 5*6*Width_D+1*Width_D]
               <=  vpu_din[9 * 3 * Width_D + Width_D-1 : 9 * 3 * Width_D] ;
        
        cpu_din1[10*6*Width_D + (1+1)*Width_D -1 : 10*6*Width_D+1*Width_D]
               <=  vpu_din[9 * 3 * Width_D + 2*Width_D-1 : 9 * 3 * Width_D + Width_D] ;  
               
        cpu_din1[11*6*Width_D + (1+1)*Width_D -1 : 11*6*Width_D+1*Width_D]
               <=  vpu_din[9 * 3 * Width_D + 3*Width_D-1 : 9 * 3 * Width_D + 2*Width_D] ; 
        
        cpu_din1[7*6*Width_D + (1+1)*Width_D -1 : 7*6*Width_D+1*Width_D]
               <=  vpu_din[10 * 3 * Width_D + Width_D-1 : 10 * 3 * Width_D] ;
        
        cpu_din1[13*6*Width_D + (1+1)*Width_D -1 : 13*6*Width_D+1*Width_D]
               <=  vpu_din[10 * 3 * Width_D + 2*Width_D-1 : 10 * 3 * Width_D + Width_D] ;  
               
        cpu_din1[14*6*Width_D + (1+1)*Width_D -1 : 14*6*Width_D+1*Width_D]
               <=  vpu_din[10 * 3 * Width_D + 3*Width_D-1 : 10 * 3 * Width_D + 2*Width_D] ; 
        
        cpu_din1[8*6*Width_D + (1+1)*Width_D -1 : 8*6*Width_D+1*Width_D]
               <=  vpu_din[11 * 3 * Width_D + Width_D-1 : 11 * 3 * Width_D] ;
        
        cpu_din1[16*6*Width_D + (1+1)*Width_D -1 : 16*6*Width_D+1*Width_D]
               <=  vpu_din[11 * 3 * Width_D + 2*Width_D-1 : 11 * 3 * Width_D + Width_D] ;  
               
        cpu_din1[17*6*Width_D + (1+1)*Width_D -1 : 17*6*Width_D+1*Width_D]
               <=  vpu_din[11 * 3 * Width_D + 3*Width_D-1 : 11 * 3 * Width_D + 2*Width_D] ; 
        
        cpu_din1[0*6*Width_D + (2+1)*Width_D -1 : 0*6*Width_D+2*Width_D]
               <=  vpu_din[12 * 3 * Width_D + Width_D-1 : 12 * 3 * Width_D] ;
        
        cpu_din1[1*6*Width_D + (2+1)*Width_D -1 : 1*6*Width_D+2*Width_D]
               <=  vpu_din[12 * 3 * Width_D + 2*Width_D-1 : 12 * 3 * Width_D + Width_D] ;  
               
        cpu_din1[11*6*Width_D + (2+1)*Width_D -1 : 11*6*Width_D+2*Width_D]
               <=  vpu_din[12 * 3 * Width_D + 3*Width_D-1 : 12 * 3 * Width_D + 2*Width_D] ; 
        
        cpu_din1[2*6*Width_D + (2+1)*Width_D -1 : 2*6*Width_D+2*Width_D]
               <=  vpu_din[13 * 3 * Width_D + Width_D-1 : 13 * 3 * Width_D] ;
        
        cpu_din1[9*6*Width_D + (2+1)*Width_D -1 : 9*6*Width_D+2*Width_D]
               <=  vpu_din[13 * 3 * Width_D + 2*Width_D-1 : 13 * 3 * Width_D + Width_D] ;  
               
        cpu_din1[13*6*Width_D + (2+1)*Width_D -1 : 13*6*Width_D+2*Width_D]
               <=  vpu_din[13 * 3 * Width_D + 3*Width_D-1 : 13 * 3 * Width_D + 2*Width_D] ; 
        
        cpu_din1[3*6*Width_D + (2+1)*Width_D -1 : 3*6*Width_D+2*Width_D]
               <=  vpu_din[14 * 3 * Width_D + Width_D-1 : 14 * 3 * Width_D] ;
        
        cpu_din1[15*6*Width_D + (2+1)*Width_D -1 : 15*6*Width_D+2*Width_D]
               <=  vpu_din[14 * 3 * Width_D + 2*Width_D-1 : 14 * 3 * Width_D + Width_D] ;  
               
        cpu_din1[17*6*Width_D + (2+1)*Width_D -1 : 17*6*Width_D+2*Width_D]
               <=  vpu_din[14 * 3 * Width_D + 3*Width_D-1 : 14 * 3 * Width_D + 2*Width_D] ; 
        
        cpu_din1[4*6*Width_D + (2+1)*Width_D -1 : 4*6*Width_D+2*Width_D]
               <=  vpu_din[15 * 3 * Width_D + Width_D-1 : 15 * 3 * Width_D] ;
        
        cpu_din1[14*6*Width_D + (2+1)*Width_D -1 : 14*6*Width_D+2*Width_D]
               <=  vpu_din[15 * 3 * Width_D + 2*Width_D-1 : 15 * 3 * Width_D + Width_D] ;  
               
        cpu_din1[16*6*Width_D + (2+1)*Width_D -1 : 16*6*Width_D+2*Width_D]
               <=  vpu_din[15 * 3 * Width_D + 3*Width_D-1 : 15 * 3 * Width_D + 2*Width_D] ; 
        
        cpu_din1[5*6*Width_D + (2+1)*Width_D -1 : 5*6*Width_D+2*Width_D]
               <=  vpu_din[16 * 3 * Width_D + Width_D-1 : 16 * 3 * Width_D] ;
        
        cpu_din1[6*6*Width_D + (2+1)*Width_D -1 : 6*6*Width_D+2*Width_D]
               <=  vpu_din[16 * 3 * Width_D + 2*Width_D-1 : 16 * 3 * Width_D + Width_D] ;  
               
        cpu_din1[8*6*Width_D + (2+1)*Width_D -1 : 8*6*Width_D+2*Width_D]
               <=  vpu_din[16 * 3 * Width_D + 3*Width_D-1 : 16 * 3 * Width_D + 2*Width_D] ; 
               
        cpu_din1[7*6*Width_D + (2+1)*Width_D -1 : 7*6*Width_D+2*Width_D]
               <=  vpu_din[17 * 3 * Width_D + Width_D-1 : 17 * 3 * Width_D] ;
        
        cpu_din1[10*6*Width_D + (2+1)*Width_D -1 : 10*6*Width_D+2*Width_D]
               <=  vpu_din[17 * 3 * Width_D + 2*Width_D-1 : 17 * 3 * Width_D + Width_D] ;  
               
        cpu_din1[12*6*Width_D + (2+1)*Width_D -1 : 12*6*Width_D+2*Width_D]
               <=  vpu_din[17 * 3 * Width_D + 3*Width_D-1 : 17 * 3 * Width_D + 2*Width_D] ;        
        
        cpu_din1[0*6*Width_D + (3+1)*Width_D -1 : 0*6*Width_D+3*Width_D]
               <=  vpu_din[18 * 3 * Width_D + Width_D-1 : 18 * 3 * Width_D] ;
        
        cpu_din1[10*6*Width_D + (3+1)*Width_D -1 : 10*6*Width_D+3*Width_D]
               <=  vpu_din[18 * 3 * Width_D + 2*Width_D-1 : 18 * 3 * Width_D + Width_D] ;  
               
        cpu_din1[12*6*Width_D + (3+1)*Width_D -1 : 12*6*Width_D+3*Width_D]
               <=  vpu_din[18 * 3 * Width_D + 3*Width_D-1 : 18 * 3 * Width_D + 2*Width_D] ; 
        
        cpu_din1[1*6*Width_D + (3+1)*Width_D -1 : 1*6*Width_D+3*Width_D]
               <=  vpu_din[19 * 3 * Width_D + Width_D-1 : 19 * 3 * Width_D] ;
        
        cpu_din1[9*6*Width_D + (3+1)*Width_D -1 : 9*6*Width_D+3*Width_D]
               <=  vpu_din[19 * 3 * Width_D + 2*Width_D-1 : 19 * 3 * Width_D + Width_D] ;  
               
        cpu_din1[16*6*Width_D + (3+1)*Width_D -1 : 16*6*Width_D+3*Width_D]
               <=  vpu_din[19 * 3 * Width_D + 3*Width_D-1 : 19 * 3 * Width_D + 2*Width_D] ; 
        
        cpu_din1[2*6*Width_D + (3+1)*Width_D -1 : 2*6*Width_D+3*Width_D]
               <=  vpu_din[20 * 3 * Width_D + Width_D-1 : 20 * 3 * Width_D] ;
        
        cpu_din1[4*6*Width_D + (3+1)*Width_D -1 : 4*6*Width_D+3*Width_D]
               <=  vpu_din[20 * 3 * Width_D + 2*Width_D-1 : 20 * 3 * Width_D + Width_D] ;  
               
        cpu_din1[6*6*Width_D + (3+1)*Width_D -1 : 6*6*Width_D+3*Width_D]
               <=  vpu_din[20 * 3 * Width_D + 3*Width_D-1 : 20 * 3 * Width_D + 2*Width_D] ; 
               
        cpu_din1[3*6*Width_D + (3+1)*Width_D -1 : 3*6*Width_D+3*Width_D]
               <=  vpu_din[21 * 3 * Width_D + Width_D-1 : 21 * 3 * Width_D] ;
        
        cpu_din1[5*6*Width_D + (3+1)*Width_D -1 : 5*6*Width_D+3*Width_D]
               <=  vpu_din[21 * 3 * Width_D + 2*Width_D-1 : 21 * 3 * Width_D + Width_D] ;  
               
        cpu_din1[7*6*Width_D + (3+1)*Width_D -1 : 7*6*Width_D+3*Width_D]
               <=  vpu_din[21 * 3 * Width_D + 3*Width_D-1 : 21 * 3 * Width_D + 2*Width_D] ; 
               
        cpu_din1[8*6*Width_D + (3+1)*Width_D -1 : 8*6*Width_D+3*Width_D]
               <=  vpu_din[22 * 3 * Width_D + Width_D-1 : 22 * 3 * Width_D] ;
        
        cpu_din1[8*6*Width_D + (4+1)*Width_D -1 : 8*6*Width_D+4*Width_D]
               <=  vpu_din[22 * 3 * Width_D + 2*Width_D-1 : 22 * 3 * Width_D + Width_D] ;  
               
        cpu_din1[15*6*Width_D + (3+1)*Width_D -1 : 15*6*Width_D+3*Width_D]
               <=  vpu_din[22 * 3 * Width_D + 3*Width_D-1 : 22 * 3 * Width_D + 2*Width_D] ; 
               
        cpu_din1[11*6*Width_D + (3+1)*Width_D -1 : 11*6*Width_D+3*Width_D]
               <=  vpu_din[23 * 3 * Width_D + Width_D-1 : 23 * 3 * Width_D] ;
        
        cpu_din1[13*6*Width_D + (3+1)*Width_D -1 : 13*6*Width_D+3*Width_D]
               <=  vpu_din[23 * 3 * Width_D + 2*Width_D-1 : 23 * 3 * Width_D + Width_D] ;  
               
        cpu_din1[14*6*Width_D + (3+1)*Width_D -1 : 14*6*Width_D+3*Width_D]
               <=  vpu_din[23 * 3 * Width_D + 3*Width_D-1 : 23 * 3 * Width_D + 2*Width_D] ; 
               
        cpu_din1[11*6*Width_D + (4+1)*Width_D -1 : 11*6*Width_D+4*Width_D]
               <=  vpu_din[24 * 3 * Width_D + Width_D-1 : 24 * 3 * Width_D] ;
        
        cpu_din1[13*6*Width_D + (4+1)*Width_D -1 : 13*6*Width_D+4*Width_D]
               <=  vpu_din[24 * 3 * Width_D + 2*Width_D-1 : 24 * 3 * Width_D + Width_D] ;  
               
        cpu_din1[17*6*Width_D + (3+1)*Width_D -1 : 17*6*Width_D+3*Width_D]
               <=  vpu_din[24 * 3 * Width_D + 3*Width_D-1 : 24 * 3 * Width_D + 2*Width_D] ; 
               
        cpu_din1[0*6*Width_D + (4+1)*Width_D -1 : 0*6*Width_D+4*Width_D]
               <=  vpu_din[25 * 3 * Width_D + Width_D-1 : 25 * 3 * Width_D] ;
        
        cpu_din1[3*6*Width_D + (4+1)*Width_D -1 : 3*6*Width_D+4*Width_D]
               <=  vpu_din[25 * 3 * Width_D + 2*Width_D-1 : 25 * 3 * Width_D + Width_D] ;  
               
        cpu_din1[5*6*Width_D + (4+1)*Width_D -1 : 5*6*Width_D+4*Width_D]
               <=  vpu_din[25 * 3 * Width_D + 3*Width_D-1 : 25 * 3 * Width_D + 2*Width_D] ; 
               
        cpu_din1[1*6*Width_D + (4+1)*Width_D -1 : 1*6*Width_D+4*Width_D]
               <=  vpu_din[26 * 3 * Width_D + Width_D-1 : 26 * 3 * Width_D] ;
        
        cpu_din1[2*6*Width_D + (4+1)*Width_D -1 : 2*6*Width_D+4*Width_D]
               <=  vpu_din[26 * 3 * Width_D + 2*Width_D-1 : 26 * 3 * Width_D + Width_D] ;  
               
        cpu_din1[9*6*Width_D + (4+1)*Width_D -1 : 9*6*Width_D+4*Width_D]
               <=  vpu_din[26 * 3 * Width_D + 3*Width_D-1 : 26 * 3 * Width_D + 2*Width_D] ; 
               
        cpu_din1[4*6*Width_D + (4+1)*Width_D -1 : 4*6*Width_D+4*Width_D]
               <=  vpu_din[27 * 3 * Width_D + Width_D-1 : 27 * 3 * Width_D] ;
        
        cpu_din1[7*6*Width_D + (4+1)*Width_D -1 : 7*6*Width_D+4*Width_D]
               <=  vpu_din[27 * 3 * Width_D + 2*Width_D-1 : 27 * 3 * Width_D + Width_D] ;  
               
        cpu_din1[16*6*Width_D + (4+1)*Width_D -1 : 16*6*Width_D+4*Width_D]
               <=  vpu_din[27 * 3 * Width_D + 3*Width_D-1 : 27 * 3 * Width_D + 2*Width_D] ; 
               
        cpu_din1[6*6*Width_D + (4+1)*Width_D -1 : 6*6*Width_D+4*Width_D]
               <=  vpu_din[28 * 3 * Width_D + Width_D-1 : 28 * 3 * Width_D] ;
        
        cpu_din1[10*6*Width_D + (4+1)*Width_D -1 : 10*6*Width_D+4*Width_D]
               <=  vpu_din[28 * 3 * Width_D + 2*Width_D-1 : 28 * 3 * Width_D + Width_D] ;  
               
        cpu_din1[15*6*Width_D + (4+1)*Width_D -1 : 15*6*Width_D+4*Width_D]
               <=  vpu_din[28 * 3 * Width_D + 3*Width_D-1 : 28 * 3 * Width_D + 2*Width_D] ;                                                  
        cpu_din1[12*6*Width_D + (4+1)*Width_D -1 : 12*6*Width_D+4*Width_D]
               <=  vpu_din[29 * 3 * Width_D + Width_D-1 : 29 * 3 * Width_D] ;
        
        cpu_din1[14*6*Width_D + (4+1)*Width_D -1 : 14*6*Width_D+4*Width_D]
               <=  vpu_din[29 * 3 * Width_D + 2*Width_D-1 : 29 * 3 * Width_D + Width_D] ;  
               
        cpu_din1[17*6*Width_D + (4+1)*Width_D -1 : 17*6*Width_D+4*Width_D]
               <=  vpu_din[29 * 3 * Width_D + 3*Width_D-1 : 29 * 3 * Width_D + 2*Width_D] ; 
               
        cpu_din1[0*6*Width_D + (5+1)*Width_D -1 : 0*6*Width_D+5*Width_D]
               <=  vpu_din[30 * 3 * Width_D + Width_D-1 : 30 * 3 * Width_D] ;
        
        cpu_din1[7*6*Width_D + (5+1)*Width_D -1 : 7*6*Width_D+5*Width_D]
               <=  vpu_din[30 * 3 * Width_D + 2*Width_D-1 : 30 * 3 * Width_D + Width_D] ;  
               
        cpu_din1[15*6*Width_D + (5+1)*Width_D -1 : 15*6*Width_D+5*Width_D]
               <=  vpu_din[30 * 3 * Width_D + 3*Width_D-1 : 30 * 3 * Width_D + 2*Width_D] ; 
               
        cpu_din1[1*6*Width_D + (5+1)*Width_D -1 : 1*6*Width_D+5*Width_D]
               <=  vpu_din[31 * 3 * Width_D + Width_D-1 : 31 * 3 * Width_D] ;
        
        cpu_din1[3*6*Width_D + (5+1)*Width_D -1 : 3*6*Width_D+5*Width_D]
               <=  vpu_din[31 * 3 * Width_D + 2*Width_D-1 : 31 * 3 * Width_D + Width_D] ;  
               
        cpu_din1[10*6*Width_D + (5+1)*Width_D -1 : 10*6*Width_D+5*Width_D]
               <=  vpu_din[31 * 3 * Width_D + 3*Width_D-1 : 31 * 3 * Width_D + 2*Width_D] ;               
        
        cpu_din1[2*6*Width_D + (5+1)*Width_D -1 : 2*6*Width_D+5*Width_D]
               <=  vpu_din[32 * 3 * Width_D + Width_D-1 : 32 * 3 * Width_D] ;
        
        cpu_din1[13*6*Width_D + (5+1)*Width_D -1 : 13*6*Width_D+5*Width_D]
               <=  vpu_din[32 * 3 * Width_D + 2*Width_D-1 : 32 * 3 * Width_D + Width_D] ;  
               
        cpu_din1[14*6*Width_D + (5+1)*Width_D -1 : 14*6*Width_D+5*Width_D]
               <=  vpu_din[32 * 3 * Width_D + 3*Width_D-1 : 32 * 3 * Width_D + 2*Width_D] ; 
        
        cpu_din1[4*6*Width_D + (5+1)*Width_D -1 : 4*6*Width_D+5*Width_D]
               <=  vpu_din[33 * 3 * Width_D + Width_D-1 : 33 * 3 * Width_D] ;
               
        cpu_din1[9*6*Width_D + (5+1)*Width_D -1 : 9*6*Width_D+5*Width_D]
               <=  vpu_din[33 * 3 * Width_D + 2*Width_D-1 : 33 * 3 * Width_D + Width_D] ;  
               
        cpu_din1[16*6*Width_D + (5+1)*Width_D -1 : 16*6*Width_D+5*Width_D]
               <=  vpu_din[33 * 3 * Width_D + 3*Width_D-1 : 33 * 3 * Width_D + 2*Width_D] ; 
               
        cpu_din1[5*6*Width_D + (5+1)*Width_D -1 : 5*6*Width_D+5*Width_D]
               <=  vpu_din[34 * 3 * Width_D + Width_D-1 : 34 * 3 * Width_D] ;
        
        cpu_din1[8*6*Width_D + (5+1)*Width_D -1 : 8*6*Width_D+5*Width_D]
               <=  vpu_din[34 * 3 * Width_D + 2*Width_D-1 : 34 * 3 * Width_D + Width_D] ;  
               
        cpu_din1[12*6*Width_D + (5+1)*Width_D -1 : 12*6*Width_D+5*Width_D]
               <=  vpu_din[34 * 3 * Width_D + 3*Width_D-1 : 34 * 3 * Width_D + 2*Width_D] ; 
               
        cpu_din1[6*6*Width_D + (5+1)*Width_D -1 : 6*6*Width_D+5*Width_D]
               <=  vpu_din[35 * 3 * Width_D + Width_D-1 : 35 * 3 * Width_D] ;
        
        cpu_din1[11*6*Width_D + (5+1)*Width_D -1 : 11*6*Width_D+5*Width_D]
               <=  vpu_din[35 * 3 * Width_D + 2*Width_D-1 : 35 * 3 * Width_D + Width_D] ;  
               
        cpu_din1[17*6*Width_D + (5+1)*Width_D -1 : 17*6*Width_D+5*Width_D]
               <=  vpu_din[35 * 3 * Width_D + 3*Width_D-1 : 35 * 3 * Width_D + 2*Width_D] ; 
end

always@(*) begin   
        cpu_din2[0*6] <= ram_dout[0] ;
        cpu_din2[1*6] <= ram_dout[1] ;
        cpu_din2[2*6] <= ram_dout[2] ;
        
        cpu_din2[3*6] <= ram_dout[3  ] ;
        cpu_din2[4*6] <= ram_dout[3+1] ;
        cpu_din2[5*6] <= ram_dout[3+2] ;   
                                                             
        cpu_din2[6*6] <= ram_dout[2*3  ] ;
        cpu_din2[7*6] <= ram_dout[2*3+1] ;
        cpu_din2[8*6] <= ram_dout[2*3+2] ;  
        
        cpu_din2[9*6]  <= ram_dout[3*3  ] ;                     
        cpu_din2[10*6] <= ram_dout[3*3+1] ;         
        cpu_din2[11*6] <= ram_dout[3*3+2] ;  
        
        cpu_din2[12*6] <= ram_dout[4*3  ] ;                     
        cpu_din2[13*6] <= ram_dout[4*3+1] ;         
        cpu_din2[14*6] <= ram_dout[4*3+2] ;  
        
        cpu_din2[15*6] <= ram_dout[5*3  ] ;                     
        cpu_din2[16*6] <= ram_dout[5*3+1] ;         
        cpu_din2[17*6] <= ram_dout[5*3+2] ;  
        
        cpu_din2[0*6+1] <= ram_dout[6*3  ] ;                     
        cpu_din2[3*6+1] <= ram_dout[6*3+1] ;         
        cpu_din2[6*6+1] <= ram_dout[6*3+2] ;  
        
        cpu_din2[1*6+1]    <= ram_dout[7*3  ] ;                     
        cpu_din2[9*6+1]    <= ram_dout[7*3+1] ;         
        cpu_din2[12*6 + 1] <= ram_dout[7*3+2] ;  
        
        cpu_din2[2*6 + 1]  <= ram_dout[8*3  ] ;                     
        cpu_din2[4*6 + 1]  <= ram_dout[8*3+1] ;         
        cpu_din2[15*6 + 1] <= ram_dout[8*3+2] ;                                                 
        
        cpu_din2[5*6 + 1]  <= ram_dout[9*3  ] ;                     
        cpu_din2[10*6 + 1] <= ram_dout[9*3+1] ;         
        cpu_din2[11*6 + 1] <= ram_dout[9*3+2] ;  
        
        cpu_din2[7*6 + 1]  <= ram_dout[10*3  ] ;                     
        cpu_din2[13*6 + 1] <= ram_dout[10*3+1] ;         
        cpu_din2[14*6 + 1] <= ram_dout[10*3+2] ;  
        
        cpu_din2[8*6 + 1]  <= ram_dout[11*3  ] ;                     
        cpu_din2[16*6 + 1] <= ram_dout[11*3+1] ;         
        cpu_din2[17*6 + 1] <= ram_dout[11*3+2] ;  
        
        cpu_din2[0*6 + 2]  <= ram_dout[12*3  ] ;                     
        cpu_din2[1*6 + 2]  <= ram_dout[12*3+1] ;         
        cpu_din2[11*6 + 2] <= ram_dout[12*3+2] ;  
        
        cpu_din2[2*6 + 2]  <= ram_dout[13*3  ] ;                     
        cpu_din2[9*6 + 2]  <= ram_dout[13*3+1] ;         
        cpu_din2[13*6 + 2] <= ram_dout[13*3+2] ;   
        
        cpu_din2[3*6 + 2]  <= ram_dout[14*3  ] ;                     
        cpu_din2[15*6 + 2] <= ram_dout[14*3+1] ;         
        cpu_din2[17*6 + 2] <= ram_dout[14*3+2] ; 
        
        cpu_din2[4*6 + 2]  <= ram_dout[15*3  ] ;                     
        cpu_din2[14*6 + 2] <= ram_dout[15*3+1] ;         
        cpu_din2[16*6 + 2] <= ram_dout[15*3+2] ; 
        
        cpu_din2[5*6 + 2]  <= ram_dout[16*3  ] ;                     
        cpu_din2[6*6 + 2]  <= ram_dout[16*3+1] ;         
        cpu_din2[8*6 + 2]  <= ram_dout[16*3+2] ;    
        
         
        cpu_din2[7*6 + 2]  <= ram_dout[17*3  ] ;                     
        cpu_din2[10*6 + 2] <= ram_dout[17*3+1] ;         
        cpu_din2[12*6 + 2] <= ram_dout[17*3+2] ; 
        
        cpu_din2[0*6 + 3]  <= ram_dout[18*3  ] ;                     
        cpu_din2[10*6 + 3] <= ram_dout[18*3+1] ;         
        cpu_din2[12*6 + 3] <= ram_dout[18*3+2] ; 
        
        cpu_din2[1*6 + 3]  <= ram_dout[19*3  ] ;                     
        cpu_din2[9*6 + 3]  <= ram_dout[19*3+1] ;         
        cpu_din2[16*6 + 3] <= ram_dout[19*3+2] ; 
        
        cpu_din2[2*6 + 3]  <= ram_dout[20*3  ] ;                     
        cpu_din2[4*6 + 3]  <= ram_dout[20*3+1] ;         
        cpu_din2[6*6 + 3]  <= ram_dout[20*3+2] ;  
                                                                        
        cpu_din2[3*6 + 3]  <= ram_dout[21*3  ] ; 
        cpu_din2[5*6 + 3]  <= ram_dout[21*3+1] ; 
        cpu_din2[7*6 + 3]  <= ram_dout[21*3+2] ; 
                                                                        
        cpu_din2[8*6 + 3]  <= ram_dout[22*3  ] ; 
        cpu_din2[8*6 + 4]  <= ram_dout[22*3+1] ; 
        cpu_din2[15*6 + 3] <= ram_dout[22*3+2] ; 
                                                                        
        cpu_din2[11*6 + 3] <= ram_dout[23*3  ] ; 
        cpu_din2[13*6 + 3] <= ram_dout[23*3+1] ; 
        cpu_din2[14*6 + 3] <= ram_dout[23*3+2] ; 
                                                                        
        cpu_din2[11*6 + 4] <= ram_dout[24*3  ] ; 
        cpu_din2[13*6 + 4] <= ram_dout[24*3+1] ; 
        cpu_din2[17*6 + 3] <= ram_dout[24*3+2] ; 
                                                                        
        cpu_din2[0*6 + 4]  <= ram_dout[25*3  ] ; 
        cpu_din2[3*6 + 4]  <= ram_dout[25*3+1] ; 
        cpu_din2[5*6 + 4]  <= ram_dout[25*3+2] ; 
                                                                        
        cpu_din2[1*6 + 4]  <= ram_dout[26*3  ] ; 
        cpu_din2[2*6 + 4]  <= ram_dout[26*3+1] ; 
        cpu_din2[9*6 + 4]  <= ram_dout[26*3+2] ; 
                                                                        
        cpu_din2[4*6 + 4]  <= ram_dout[27*3  ] ; 
        cpu_din2[7*6 + 4]  <= ram_dout[27*3+1] ; 
        cpu_din2[16*6 + 4] <= ram_dout[27*3+2] ; 
                                                                        
        cpu_din2[6*6 + 4]  <= ram_dout[28*3  ] ; 
        cpu_din2[10*6 + 4] <= ram_dout[28*3+1] ; 
        cpu_din2[15*6 + 4] <= ram_dout[28*3+2] ; 
                                                                        
        cpu_din2[12*6 + 4] <= ram_dout[29*3  ] ; 
        cpu_din2[14*6 + 4] <= ram_dout[29*3+1] ; 
        cpu_din2[17*6 + 4] <= ram_dout[29*3+2] ; 
                                                                        
        cpu_din2[0*6 + 5]  <= ram_dout[30*3  ] ; 
        cpu_din2[7*6 + 5]  <= ram_dout[30*3+1] ; 
        cpu_din2[15*6 + 5] <= ram_dout[30*3+2] ; 
                                                                        
        cpu_din2[1*6 + 5]  <= ram_dout[31*3  ] ; 
        cpu_din2[3*6 + 5]  <= ram_dout[31*3+1] ; 
        cpu_din2[10*6 + 5] <= ram_dout[31*3+2] ; 
                                                                        
        cpu_din2[2*6 + 5]  <= ram_dout[32*3  ] ; 
        cpu_din2[13*6 + 5] <= ram_dout[32*3+1] ; 
        cpu_din2[14*6 + 5] <= ram_dout[32*3+2] ; 
                                                                        
        cpu_din2[4*6 + 5]  <= ram_dout[33*3  ] ; 
        cpu_din2[9*6 + 5]  <= ram_dout[33*3+1] ; 
        cpu_din2[16*6 + 5] <= ram_dout[33*3+2] ; 
                                                                        
        cpu_din2[5*6 + 5]  <= ram_dout[34*3  ] ; 
        cpu_din2[8*6 + 5]  <= ram_dout[34*3+1] ; 
        cpu_din2[12*6 + 5] <= ram_dout[34*3+2] ; 
                                                                        
        cpu_din2[6*6 + 5]  <= ram_dout[35*3  ] ; 
        cpu_din2[11*6 + 5] <= ram_dout[35*3+1] ; 
        cpu_din2[17*6 + 5] <= ram_dout[35*3+2] ; 
end    	
                                                                 

always@(*) begin
    	ram_din[0*3*Width_D + (0+1)*Width_D -1 : 0*3*Width_D+0*Width_D ]
    	   <= cpu_dout[Width_D-1 : 0] ;
    	ram_din[6*3*Width_D + (0+1)*Width_D -1 : 6*3*Width_D+0*Width_D ]
    	   <= cpu_dout[2 * Width_D-1 : Width_D] ; 
    	ram_din[12*3*Width_D + (0+1)*Width_D -1 : 12*3*Width_D+0*Width_D ]
    	   <= cpu_dout[3 * Width_D-1 : 2 * Width_D] ; 	
    	ram_din[18*3*Width_D + (0+1)*Width_D -1 : 18*3*Width_D+0*Width_D ]
    	   <= cpu_dout[4 * Width_D-1 : 3 * Width_D] ;
    	ram_din[25*3*Width_D + (0+1)*Width_D -1 : 25*3*Width_D+0*Width_D ]
    	   <= cpu_dout[5 * Width_D-1 : 4 * Width_D] ;
    	ram_din[30*3*Width_D + (0+1)*Width_D -1 : 30*3*Width_D+0*Width_D ]
    	   <= cpu_dout[6 * Width_D-1 : 5 * Width_D] ;
    	
    	ram_din[0*3*Width_D + (1+1)*Width_D -1 : 0*3*Width_D+1*Width_D ]
    	   <= cpu_dout[6 * Width_D + Width_D-1 : 6 * Width_D] ;
    	ram_din[7*3*Width_D + (0+1)*Width_D -1 : 7*3*Width_D+0*Width_D ]
    	   <= cpu_dout[6 * Width_D + 2 * Width_D-1 : 6 * Width_D + Width_D] ; 
    	ram_din[12*3*Width_D + (1+1)*Width_D -1 : 12*3*Width_D+1*Width_D ]
    	   <= cpu_dout[6 * Width_D + 3 * Width_D-1 : 6 * Width_D + 2 * Width_D] ; 	
    	ram_din[19*3*Width_D + (0+1)*Width_D -1 : 19*3*Width_D+0*Width_D ]
    	   <= cpu_dout[6 * Width_D + 4 * Width_D-1 : 6 * Width_D + 3 * Width_D] ;
    	ram_din[26*3*Width_D + (0+1)*Width_D -1 : 26*3*Width_D+0*Width_D ]
    	   <= cpu_dout[6 * Width_D + 5 * Width_D-1 : 6 * Width_D + 4 * Width_D] ;
    	ram_din[31*3*Width_D + (0+1)*Width_D -1 : 31*3*Width_D+0*Width_D ]
    	   <= cpu_dout[6 * Width_D + 6 * Width_D-1 : 6 * Width_D + 5 * Width_D] ;   
    	
    	ram_din[0*3*Width_D + (2+1)*Width_D -1 : 0*3*Width_D+2*Width_D ]
    	   <= cpu_dout[2 * 6 * Width_D + Width_D-1 : 2 * 6 * Width_D] ;
    	ram_din[8*3*Width_D + (0+1)*Width_D -1 : 8*3*Width_D+0*Width_D ]
    	   <= cpu_dout[2 * 6 * Width_D + 2 * Width_D-1 : 2 * 6 * Width_D + Width_D] ; 
    	ram_din[13*3*Width_D + (0+1)*Width_D -1 : 13*3*Width_D+0*Width_D ]
    	   <= cpu_dout[2 * 6 * Width_D + 3 * Width_D-1 : 2 * 6 * Width_D + 2 * Width_D] ; 	
    	ram_din[20*3*Width_D + (0+1)*Width_D -1 : 20*3*Width_D+0*Width_D ]
    	   <= cpu_dout[2 * 6 * Width_D + 4 * Width_D-1 : 2 * 6 * Width_D + 3 * Width_D] ;
    	ram_din[26*3*Width_D + (1+1)*Width_D -1 : 26*3*Width_D+1*Width_D ]
    	   <= cpu_dout[2 * 6 * Width_D + 5 * Width_D-1 : 2 * 6 * Width_D + 4 * Width_D] ;
    	ram_din[32*3*Width_D + (0+1)*Width_D -1 : 32*3*Width_D+0*Width_D ]
    	   <= cpu_dout[2 * 6 * Width_D + 6 * Width_D-1 : 2 * 6 * Width_D + 5 * Width_D] ;  
    	
    	ram_din[1*3*Width_D + (0+1)*Width_D -1 : 1*3*Width_D+0*Width_D ]
    	   <= cpu_dout[3 * 6 * Width_D + Width_D-1 : 3 * 6 * Width_D] ;
    	ram_din[6*3*Width_D + (1+1)*Width_D -1 : 6*3*Width_D+1*Width_D ]
    	   <= cpu_dout[3 * 6 * Width_D + 2 * Width_D-1 : 3 * 6 * Width_D + Width_D] ; 
    	ram_din[14*3*Width_D + (0+1)*Width_D -1 : 14*3*Width_D+0*Width_D ]
    	   <= cpu_dout[3 * 6 * Width_D + 3 * Width_D-1 : 3 * 6 * Width_D + 2 * Width_D] ; 	
    	ram_din[21*3*Width_D + (0+1)*Width_D -1 : 21*3*Width_D+0*Width_D ]
    	   <= cpu_dout[3 * 6 * Width_D + 4 * Width_D-1 : 3 * 6 * Width_D + 3 * Width_D] ;
    	ram_din[25*3*Width_D + (1+1)*Width_D -1 : 25*3*Width_D+1*Width_D ]
    	   <= cpu_dout[3 * 6 * Width_D + 5 * Width_D-1 : 3 * 6 * Width_D + 4 * Width_D] ;
    	ram_din[31*3*Width_D + (1+1)*Width_D -1 : 31*3*Width_D+1*Width_D ]
    	   <= cpu_dout[3 * 6 * Width_D + 6 * Width_D-1 : 3 * 6 * Width_D + 5 * Width_D] ;  
    	
    	ram_din[1*3*Width_D + (1+1)*Width_D -1 : 1*3*Width_D+1*Width_D ]
    	   <= cpu_dout[4 * 6 * Width_D + Width_D-1 : 4 * 6 * Width_D] ;
    	ram_din[8*3*Width_D + (1+1)*Width_D -1 : 8*3*Width_D+1*Width_D ]
    	   <= cpu_dout[4 * 6 * Width_D + 2 * Width_D-1 : 4 * 6 * Width_D + Width_D] ; 
    	ram_din[15*3*Width_D + (0+1)*Width_D -1 : 15*3*Width_D+0*Width_D ]
    	   <= cpu_dout[4 * 6 * Width_D + 3 * Width_D-1 : 4 * 6 * Width_D + 2 * Width_D] ; 	
    	ram_din[20*3*Width_D + (1+1)*Width_D -1 : 20*3*Width_D+1*Width_D ]
    	   <= cpu_dout[4 * 6 * Width_D + 4 * Width_D-1 : 4 * 6 * Width_D + 3 * Width_D] ;
    	ram_din[27*3*Width_D + (0+1)*Width_D -1 : 27*3*Width_D+0*Width_D ]
    	   <= cpu_dout[4 * 6 * Width_D + 5 * Width_D-1 : 4 * 6 * Width_D + 4 * Width_D] ;
    	ram_din[33*3*Width_D + (0+1)*Width_D -1 : 33*3*Width_D+0*Width_D ]
    	   <= cpu_dout[4 * 6 * Width_D + 6 * Width_D-1 : 4 * 6 * Width_D + 5 * Width_D] ;  
    	
    	ram_din[1*3*Width_D + (2+1)*Width_D -1 : 1*3*Width_D+2*Width_D ]
    	   <= cpu_dout[5 * 6 * Width_D + Width_D-1 : 5 * 6 * Width_D] ;
    	ram_din[9*3*Width_D + (0+1)*Width_D -1 : 9*3*Width_D+0*Width_D ]
    	   <= cpu_dout[5 * 6 * Width_D + 2 * Width_D-1 : 5 * 6 * Width_D + Width_D] ; 
    	ram_din[16*3*Width_D + (0+1)*Width_D -1 : 16*3*Width_D+0*Width_D ]
    	   <= cpu_dout[5 * 6 * Width_D + 3 * Width_D-1 : 5 * 6 * Width_D + 2 * Width_D] ; 	
    	ram_din[21*3*Width_D + (1+1)*Width_D -1 : 21*3*Width_D+1*Width_D ]
    	   <= cpu_dout[5 * 6 * Width_D + 4 * Width_D-1 : 5 * 6 * Width_D + 3 * Width_D] ;
    	ram_din[25*3*Width_D + (2+1)*Width_D -1 : 25*3*Width_D+2*Width_D ]
    	   <= cpu_dout[5 * 6 * Width_D + 5 * Width_D-1 : 5 * 6 * Width_D + 4 * Width_D] ;
    	ram_din[34*3*Width_D + (0+1)*Width_D -1 : 34*3*Width_D+0*Width_D ]
    	   <= cpu_dout[5 * 6 * Width_D + 6 * Width_D-1 : 5 * 6 * Width_D + 5 * Width_D] ; 
    	
    	ram_din[2*3*Width_D + (0+1)*Width_D -1 : 2*3*Width_D+0*Width_D ]
    	   <= cpu_dout[6 * 6 * Width_D + Width_D-1 : 6 * 6 * Width_D] ;
    	ram_din[6*3*Width_D + (2+1)*Width_D -1 : 6*3*Width_D+2*Width_D ]
    	   <= cpu_dout[6 * 6 * Width_D + 2 * Width_D-1 : 6 * 6 * Width_D + Width_D] ; 
    	ram_din[16*3*Width_D + (1+1)*Width_D -1 : 16*3*Width_D+1*Width_D ]
    	   <= cpu_dout[6 * 6 * Width_D + 3 * Width_D-1 : 6 * 6 * Width_D + 2 * Width_D] ; 	
    	ram_din[20*3*Width_D + (2+1)*Width_D -1 : 20*3*Width_D+2*Width_D ]
    	   <= cpu_dout[6 * 6 * Width_D + 4 * Width_D-1 : 6 * 6 * Width_D + 3 * Width_D] ;
    	ram_din[28*3*Width_D + (0+1)*Width_D -1 : 28*3*Width_D+0*Width_D ]
    	   <= cpu_dout[6 * 6 * Width_D + 5 * Width_D-1 : 6 * 6 * Width_D + 4 * Width_D] ;
    	ram_din[35*3*Width_D + (0+1)*Width_D -1 : 35*3*Width_D+0*Width_D ]
    	   <= cpu_dout[6 * 6 * Width_D + 6 * Width_D-1 : 6 * 6 * Width_D + 5 * Width_D] ; 
    	
    	ram_din[2*3*Width_D + (1+1)*Width_D -1 : 2*3*Width_D+1*Width_D ]
    	   <= cpu_dout[7 * 6 * Width_D + Width_D-1 : 7 * 6 * Width_D] ;
    	ram_din[10*3*Width_D + (0+1)*Width_D -1 : 10*3*Width_D+0*Width_D ]
    	   <= cpu_dout[7 * 6 * Width_D + 2 * Width_D-1 : 7 * 6 * Width_D + Width_D] ; 
    	ram_din[17*3*Width_D + (0+1)*Width_D -1 : 17*3*Width_D+0*Width_D ]
    	   <= cpu_dout[7 * 6 * Width_D + 3 * Width_D-1 : 7 * 6 * Width_D + 2 * Width_D] ; 	
    	ram_din[21*3*Width_D + (2+1)*Width_D -1 : 21*3*Width_D+2*Width_D ]
    	   <= cpu_dout[7 * 6 * Width_D + 4 * Width_D-1 : 7 * 6 * Width_D + 3 * Width_D] ;
    	ram_din[27*3*Width_D + (1+1)*Width_D -1 : 27*3*Width_D+1*Width_D ]
    	   <= cpu_dout[7 * 6 * Width_D + 5 * Width_D-1 : 7 * 6 * Width_D + 4 * Width_D] ;
    	ram_din[30*3*Width_D + (1+1)*Width_D -1 : 30*3*Width_D+1*Width_D ]
    	   <= cpu_dout[7 * 6 * Width_D + 6 * Width_D-1 : 7 * 6 * Width_D + 5 * Width_D] ;
    	
    	ram_din[2*3*Width_D + (2+1)*Width_D -1 : 2*3*Width_D+2*Width_D ]
    	   <= cpu_dout[8 * 6 * Width_D + Width_D-1 : 8 * 6 * Width_D] ;
    	ram_din[11*3*Width_D + (0+1)*Width_D -1 : 11*3*Width_D+0*Width_D ]
    	   <= cpu_dout[8 * 6 * Width_D + 2 * Width_D-1 : 8 * 6 * Width_D + Width_D] ; 
    	ram_din[16*3*Width_D + (2+1)*Width_D -1 : 16*3*Width_D+2*Width_D ]
    	   <= cpu_dout[8 * 6 * Width_D + 3 * Width_D-1 : 8 * 6 * Width_D + 2 * Width_D] ; 	
    	ram_din[22*3*Width_D + (0+1)*Width_D -1 : 22*3*Width_D+0*Width_D ]
    	   <= cpu_dout[8 * 6 * Width_D + 4 * Width_D-1 : 8 * 6 * Width_D + 3 * Width_D] ;
    	ram_din[22*3*Width_D + (1+1)*Width_D -1 : 22*3*Width_D+1*Width_D ]
    	   <= cpu_dout[8 * 6 * Width_D + 5 * Width_D-1 : 8 * 6 * Width_D + 4 * Width_D] ;
    	ram_din[34*3*Width_D + (1+1)*Width_D -1 : 34*3*Width_D+1*Width_D ]
    	   <= cpu_dout[8 * 6 * Width_D + 6 * Width_D-1 : 8 * 6 * Width_D + 5 * Width_D] ;  
    	
    	ram_din[3*3*Width_D + (0+1)*Width_D -1 : 3*3*Width_D+0*Width_D ]
    	   <= cpu_dout[9 * 6 * Width_D + Width_D-1 : 9 * 6 * Width_D] ;
    	ram_din[7*3*Width_D + (1+1)*Width_D -1 : 7*3*Width_D+1*Width_D ]
    	   <= cpu_dout[9 * 6 * Width_D + 2 * Width_D-1 : 9 * 6 * Width_D + Width_D] ; 
    	ram_din[13*3*Width_D + (1+1)*Width_D -1 : 13*3*Width_D+1*Width_D ]
    	   <= cpu_dout[9 * 6 * Width_D + 3 * Width_D-1 : 9 * 6 * Width_D + 2 * Width_D] ; 	
    	ram_din[19*3*Width_D + (1+1)*Width_D -1 : 19*3*Width_D+1*Width_D ]
    	   <= cpu_dout[9 * 6 * Width_D + 4 * Width_D-1 : 9 * 6 * Width_D + 3 * Width_D] ;
    	ram_din[26*3*Width_D + (2+1)*Width_D -1 : 26*3*Width_D+2*Width_D ]
    	   <= cpu_dout[9 * 6 * Width_D + 5 * Width_D-1 : 9 * 6 * Width_D + 4 * Width_D] ;
    	ram_din[33*3*Width_D + (1+1)*Width_D -1 : 33*3*Width_D+1*Width_D ]
    	   <= cpu_dout[9 * 6 * Width_D + 6 * Width_D-1 : 9 * 6 * Width_D + 5 * Width_D] ;  
    	
    	ram_din[3*3*Width_D + (1+1)*Width_D -1 : 3*3*Width_D+1*Width_D ]
    	   <= cpu_dout[10 * 6 * Width_D + Width_D-1 : 10 * 6 * Width_D] ;
    	ram_din[9*3*Width_D + (1+1)*Width_D -1 : 9*3*Width_D+1*Width_D ]
    	   <= cpu_dout[10 * 6 * Width_D + 2 * Width_D-1 : 10 * 6 * Width_D + Width_D] ; 
    	ram_din[17*3*Width_D + (1+1)*Width_D -1 : 17*3*Width_D+1*Width_D ]
    	   <= cpu_dout[10 * 6 * Width_D + 3 * Width_D-1 : 10 * 6 * Width_D + 2 * Width_D] ; 	
    	ram_din[18*3*Width_D + (1+1)*Width_D -1 : 18*3*Width_D+1*Width_D ]
    	   <= cpu_dout[10 * 6 * Width_D + 4 * Width_D-1 : 10 * 6 * Width_D + 3 * Width_D] ;
    	ram_din[28*3*Width_D + (1+1)*Width_D -1 : 28*3*Width_D+1*Width_D ]
    	   <= cpu_dout[10 * 6 * Width_D + 5 * Width_D-1 : 10 * 6 * Width_D + 4 * Width_D] ;
    	ram_din[31*3*Width_D + (2+1)*Width_D -1 : 31*3*Width_D+2*Width_D ]
    	   <= cpu_dout[10 * 6 * Width_D + 6 * Width_D-1 : 10 * 6 * Width_D + 5 * Width_D] ;  
    	
    	ram_din[3*3*Width_D + (2+1)*Width_D -1 : 3*3*Width_D+2*Width_D ]
    	   <= cpu_dout[11 * 6 * Width_D + Width_D-1 : 11 * 6 * Width_D] ;
    	ram_din[9*3*Width_D + (2+1)*Width_D -1 : 9*3*Width_D+2*Width_D ]
    	   <= cpu_dout[11 * 6 * Width_D + 2 * Width_D-1 : 11 * 6 * Width_D + Width_D] ; 
    	ram_din[12*3*Width_D + (2+1)*Width_D -1 : 12*3*Width_D+2*Width_D ]
    	   <= cpu_dout[11 * 6 * Width_D + 3 * Width_D-1 : 11 * 6 * Width_D + 2 * Width_D] ; 	
    	ram_din[23*3*Width_D + (0+1)*Width_D -1 : 23*3*Width_D+0*Width_D ]
    	   <= cpu_dout[11 * 6 * Width_D + 4 * Width_D-1 : 11 * 6 * Width_D + 3 * Width_D] ;
    	ram_din[24*3*Width_D + (0+1)*Width_D -1 : 24*3*Width_D+0*Width_D ]
    	   <= cpu_dout[11 * 6 * Width_D + 5 * Width_D-1 : 11 * 6 * Width_D + 4 * Width_D] ;
    	ram_din[35*3*Width_D + (1+1)*Width_D -1 : 35*3*Width_D+1*Width_D ]
    	   <= cpu_dout[11 * 6 * Width_D + 6 * Width_D-1 : 11 * 6 * Width_D + 5 * Width_D] ;  
    	
    	ram_din[4*3*Width_D + (0+1)*Width_D -1 : 4*3*Width_D+0*Width_D ]
    	   <= cpu_dout[12 * 6 * Width_D + Width_D-1 : 12 * 6 * Width_D] ;
    	ram_din[7*3*Width_D + (2+1)*Width_D -1 : 7*3*Width_D+2*Width_D ]
    	   <= cpu_dout[12 * 6 * Width_D + 2 * Width_D-1 : 12 * 6 * Width_D + Width_D] ; 
    	ram_din[17*3*Width_D + (2+1)*Width_D -1 : 17*3*Width_D+2*Width_D ]
    	   <= cpu_dout[12 * 6 * Width_D + 3 * Width_D-1 : 12 * 6 * Width_D + 2 * Width_D] ; 	
    	ram_din[18*3*Width_D + (2+1)*Width_D -1 : 18*3*Width_D+2*Width_D ]
    	   <= cpu_dout[12 * 6 * Width_D + 4 * Width_D-1 : 12 * 6 * Width_D + 3 * Width_D] ;
    	ram_din[29*3*Width_D + (0+1)*Width_D -1 : 29*3*Width_D+0*Width_D ]
    	   <= cpu_dout[12 * 6 * Width_D + 5 * Width_D-1 : 12 * 6 * Width_D + 4 * Width_D] ;
    	ram_din[34*3*Width_D + (2+1)*Width_D -1 : 34*3*Width_D+2*Width_D ]
    	   <= cpu_dout[12 * 6 * Width_D + 6 * Width_D-1 : 12 * 6 * Width_D + 5 * Width_D] ; 
    	
    	ram_din[4*3*Width_D + (1+1)*Width_D -1 : 4*3*Width_D+1*Width_D ]
    	   <= cpu_dout[13 * 6 * Width_D + Width_D-1 : 13 * 6 * Width_D] ;
    	ram_din[10*3*Width_D + (1+1)*Width_D -1 : 10*3*Width_D+1*Width_D ]
    	   <= cpu_dout[13 * 6 * Width_D + 2 * Width_D-1 : 13 * 6 * Width_D + Width_D] ; 
    	ram_din[13*3*Width_D + (2+1)*Width_D -1 : 13*3*Width_D+2*Width_D ]
    	   <= cpu_dout[13 * 6 * Width_D + 3 * Width_D-1 : 13 * 6 * Width_D + 2 * Width_D] ; 	
    	ram_din[23*3*Width_D + (1+1)*Width_D -1 : 23*3*Width_D+1*Width_D ]
    	   <= cpu_dout[13 * 6 * Width_D + 4 * Width_D-1 : 13 * 6 * Width_D + 3 * Width_D] ;
    	ram_din[24*3*Width_D + (1+1)*Width_D -1 : 24*3*Width_D+1*Width_D ]
    	   <= cpu_dout[13 * 6 * Width_D + 5 * Width_D-1 : 13 * 6 * Width_D + 4 * Width_D] ;
    	ram_din[32*3*Width_D + (1+1)*Width_D -1 : 32*3*Width_D+1*Width_D ]
    	   <= cpu_dout[13 * 6 * Width_D + 6 * Width_D-1 : 13 * 6 * Width_D + 5 * Width_D] ;  
    	
    	ram_din[4*3*Width_D + (2+1)*Width_D -1 : 4*3*Width_D+2*Width_D ]
    	   <= cpu_dout[14 * 6 * Width_D + Width_D-1 : 14 * 6 * Width_D] ;
    	ram_din[10*3*Width_D + (2+1)*Width_D -1 : 10*3*Width_D+2*Width_D ]
    	   <= cpu_dout[14 * 6 * Width_D + 2 * Width_D-1 : 14 * 6 * Width_D + Width_D] ; 
    	ram_din[15*3*Width_D + (1+1)*Width_D -1 : 15*3*Width_D+1*Width_D ]
    	   <= cpu_dout[14 * 6 * Width_D + 3 * Width_D-1 : 14 * 6 * Width_D + 2 * Width_D] ; 	
    	ram_din[23*3*Width_D + (2+1)*Width_D -1 : 23*3*Width_D+2*Width_D ]
    	   <= cpu_dout[14 * 6 * Width_D + 4 * Width_D-1 : 14 * 6 * Width_D + 3 * Width_D] ;
    	ram_din[29*3*Width_D + (1+1)*Width_D -1 : 29*3*Width_D+1*Width_D ]
    	   <= cpu_dout[14 * 6 * Width_D + 5 * Width_D-1 : 14 * 6 * Width_D + 4 * Width_D] ;
    	ram_din[32*3*Width_D + (2+1)*Width_D -1 : 32*3*Width_D+2*Width_D ]
    	   <= cpu_dout[14 * 6 * Width_D + 6 * Width_D-1 : 14 * 6 * Width_D + 5 * Width_D] ;  
    	
    	ram_din[5*3*Width_D + (0+1)*Width_D -1 : 5*3*Width_D+0*Width_D ]
    	   <= cpu_dout[15 * 6 * Width_D + Width_D-1 : 15 * 6 * Width_D] ;
    	ram_din[8*3*Width_D + (2+1)*Width_D -1 : 8*3*Width_D+2*Width_D ]
    	   <= cpu_dout[15 * 6 * Width_D + 2 * Width_D-1 : 15 * 6 * Width_D + Width_D] ; 
    	ram_din[14*3*Width_D + (1+1)*Width_D -1 : 14*3*Width_D+1*Width_D ]
    	   <= cpu_dout[15 * 6 * Width_D + 3 * Width_D-1 : 15 * 6 * Width_D + 2 * Width_D] ; 	
    	ram_din[22*3*Width_D + (2+1)*Width_D -1 : 22*3*Width_D+2*Width_D ]
    	   <= cpu_dout[15 * 6 * Width_D + 4 * Width_D-1 : 15 * 6 * Width_D + 3 * Width_D] ;
    	ram_din[28*3*Width_D + (2+1)*Width_D -1 : 28*3*Width_D+2*Width_D ]
    	   <= cpu_dout[15 * 6 * Width_D + 5 * Width_D-1 : 15 * 6 * Width_D + 4 * Width_D] ;
    	ram_din[30*3*Width_D + (2+1)*Width_D -1 : 30*3*Width_D+2*Width_D ]
    	   <= cpu_dout[15 * 6 * Width_D + 6 * Width_D-1 : 15 * 6 * Width_D + 5 * Width_D] ;  
    	    	    	    	   	
    	ram_din[5*3*Width_D + (1+1)*Width_D -1 : 5*3*Width_D+1*Width_D ]
    	   <= cpu_dout[16 *  6 * Width_D + Width_D-1 : 16 *  6 * Width_D] ;
    	ram_din[11*3*Width_D + (1+1)*Width_D -1 : 11*3*Width_D+1*Width_D ]
    	   <= cpu_dout[16 *  6 * Width_D + 2 * Width_D-1 : 16 *  6 * Width_D + Width_D] ; 
    	ram_din[15*3*Width_D + (2+1)*Width_D -1 : 15*3*Width_D+2*Width_D ]
    	   <= cpu_dout[16 *  6 * Width_D + 3 * Width_D-1 : 16 *  6 * Width_D + 2 * Width_D] ; 	
    	ram_din[19*3*Width_D + (2+1)*Width_D -1 : 19*3*Width_D+2*Width_D ]
    	   <= cpu_dout[16 *  6 * Width_D + 4 * Width_D-1 : 16 *  6 * Width_D + 3 * Width_D] ;
    	ram_din[27*3*Width_D + (2+1)*Width_D -1 : 27*3*Width_D+2*Width_D ]
    	   <= cpu_dout[16 *  6 * Width_D + 5 * Width_D-1 : 16 *  6 * Width_D + 4 * Width_D] ;
    	ram_din[33*3*Width_D + (2+1)*Width_D -1 : 33*3*Width_D+2*Width_D ]
    	   <= cpu_dout[16 *  6 * Width_D + 6 * Width_D-1 : 16 *  6 * Width_D + 5 * Width_D] ;  
    	
    	ram_din[5*3*Width_D + (2+1)*Width_D -1 : 5*3*Width_D+2*Width_D ]
    	   <= cpu_dout[17 *  6 * Width_D + Width_D-1 : 17 *  6 * Width_D] ;
    	ram_din[11*3*Width_D + (2+1)*Width_D -1 : 11*3*Width_D+2*Width_D ]
    	   <= cpu_dout[17 *  6 * Width_D + 2 * Width_D-1 : 17 *  6 * Width_D + Width_D] ; 
    	ram_din[14*3*Width_D + (2+1)*Width_D -1 : 14*3*Width_D+2*Width_D ]
    	   <= cpu_dout[17 *  6 * Width_D + 3 * Width_D-1 : 17 *  6 * Width_D + 2 * Width_D] ; 	
    	ram_din[24*3*Width_D + (2+1)*Width_D -1 : 24*3*Width_D+2*Width_D ]
    	   <= cpu_dout[17 *  6 * Width_D + 4 * Width_D-1 : 17 *  6 * Width_D + 3 * Width_D] ;
    	ram_din[29*3*Width_D + (2+1)*Width_D -1 : 29*3*Width_D+2*Width_D ]
    	   <= cpu_dout[17 *  6 * Width_D + 5 * Width_D-1 : 17 *  6 * Width_D + 4 * Width_D] ;
    	ram_din[35*3*Width_D + (2+1)*Width_D -1 : 35*3*Width_D+2*Width_D ]
    	   <= cpu_dout[17 *  6 * Width_D + 6 * Width_D-1 : 17 *  6 * Width_D + 5 * Width_D] ;  
end  



function [Width_A-1:0] add1;
input	 [Width_A-1:0]	a  ;
input	 [Width_A-1:0]	b  ;	
begin	
    if (a + b > 255)
        add1 = a + b - 255 ;
    else
        add1 = a + b     ;      
end
endfunction
 


function [Width_D-1 : 0] conv_s ;
input                       a    ;
input    signed [Width_D-2 : 0] b    ;
begin                  
    if (!a) 
        conv_s = {a,b} ;
    else begin
        conv_s[Width_D - 1]   =   a   ;
        conv_s[Width_D-2 : 0] = - b   ;
    end
end
endfunction



ldpc_ram    u_lram_0   ( clk, reset_n, lram_wren, lram_addr0, lram_din0, lram_dout0);
ldpc_ram    u_lram_1   ( clk, reset_n, lram_wren, lram_addr1, lram_din1, lram_dout1);
ldpc_ram    u_lram_2   ( clk, reset_n, lram_wren, lram_addr2, lram_din2, lram_dout2);
ldpc_ram    u_lram_3   ( clk, reset_n, lram_wren, lram_addr3, lram_din3, lram_dout3);
ldpc_ram    u_lram_4   ( clk, reset_n, lram_wren, lram_addr4, lram_din4, lram_dout4); 
ldpc_ram    u_lram_5   ( clk, reset_n, lram_wren, lram_addr5, lram_din5, lram_dout5);
ldpc_ram    u_lram_6   ( clk, reset_n, lram_wren, lram_addr6, lram_din6, lram_dout6); 
ldpc_ram    u_lram_7   ( clk, reset_n, lram_wren, lram_addr7, lram_din7, lram_dout7);
ldpc_ram    u_lram_8   ( clk, reset_n, lram_wren, lram_addr8, lram_din8, lram_dout8);
ldpc_ram    u_lram_9   ( clk, reset_n, lram_wren, lram_addr9, lram_din9, lram_dout9); 
               
ldpc_ram    u_lram_10   ( clk, reset_n, lram_wren, lram_addr10, lram_din10, lram_dout10);
ldpc_ram    u_lram_11   ( clk, reset_n, lram_wren, lram_addr11, lram_din11, lram_dout11);
ldpc_ram    u_lram_12   ( clk, reset_n, lram_wren, lram_addr12, lram_din12, lram_dout12);
ldpc_ram    u_lram_13   ( clk, reset_n, lram_wren, lram_addr13, lram_din13, lram_dout13);
ldpc_ram    u_lram_14   ( clk, reset_n, lram_wren, lram_addr14, lram_din14, lram_dout14); 
ldpc_ram    u_lram_15   ( clk, reset_n, lram_wren, lram_addr15, lram_din15, lram_dout15);
ldpc_ram    u_lram_16   ( clk, reset_n, lram_wren, lram_addr16, lram_din16, lram_dout16); 
ldpc_ram    u_lram_17   ( clk, reset_n, lram_wren, lram_addr17, lram_din17, lram_dout17);
ldpc_ram    u_lram_18   ( clk, reset_n, lram_wren, lram_addr18, lram_din18, lram_dout18);
ldpc_ram    u_lram_19   ( clk, reset_n, lram_wren, lram_addr19, lram_din19, lram_dout19);
              
ldpc_ram    u_lram_20   ( clk, reset_n, lram_wren, lram_addr20, lram_din20, lram_dout20);
ldpc_ram    u_lram_21   ( clk, reset_n, lram_wren, lram_addr21, lram_din21, lram_dout21);
ldpc_ram    u_lram_22   ( clk, reset_n, lram_wren, lram_addr22, lram_din22, lram_dout22);
ldpc_ram    u_lram_23   ( clk, reset_n, lram_wren, lram_addr23, lram_din23, lram_dout23);
ldpc_ram    u_lram_24   ( clk, reset_n, lram_wren, lram_addr24, lram_din24, lram_dout24); 
ldpc_ram    u_lram_25   ( clk, reset_n, lram_wren, lram_addr25, lram_din25, lram_dout25);
ldpc_ram    u_lram_26   ( clk, reset_n, lram_wren, lram_addr26, lram_din26, lram_dout26); 
ldpc_ram    u_lram_27   ( clk, reset_n, lram_wren, lram_addr27, lram_din27, lram_dout27);
ldpc_ram    u_lram_28   ( clk, reset_n, lram_wren, lram_addr28, lram_din28, lram_dout28);
ldpc_ram    u_lram_29   ( clk, reset_n, lram_wren, lram_addr29, lram_din29, lram_dout29);
              
ldpc_ram    u_lram_30   ( clk, reset_n, lram_wren, lram_addr30, lram_din30, lram_dout30);
ldpc_ram    u_lram_31   ( clk, reset_n, lram_wren, lram_addr31, lram_din31, lram_dout31);
ldpc_ram    u_lram_32   ( clk, reset_n, lram_wren, lram_addr32, lram_din32, lram_dout32);
ldpc_ram    u_lram_33   ( clk, reset_n, lram_wren, lram_addr33, lram_din33, lram_dout33);
ldpc_ram    u_lram_34   ( clk, reset_n, lram_wren, lram_addr34, lram_din34, lram_dout34); 
ldpc_ram    u_lram_35   ( clk, reset_n, lram_wren, lram_addr35, lram_din35, lram_dout35);

                        
ldpc_ram    u_ram_0   ( clk, reset_n, ram_wren, ram_addr0, ram_din0, ram_dout0);
ldpc_ram    u_ram_1   ( clk, reset_n, ram_wren, ram_addr1, ram_din1, ram_dout1);
ldpc_ram    u_ram_2   ( clk, reset_n, ram_wren, ram_addr2, ram_din2, ram_dout2);
ldpc_ram    u_ram_3   ( clk, reset_n, ram_wren, ram_addr3, ram_din3, ram_dout3);
ldpc_ram    u_ram_4   ( clk, reset_n, ram_wren, ram_addr4, ram_din4, ram_dout4); 
ldpc_ram    u_ram_5   ( clk, reset_n, ram_wren, ram_addr5, ram_din5, ram_dout5);
ldpc_ram    u_ram_6   ( clk, reset_n, ram_wren, ram_addr6, ram_din6, ram_dout6); 
ldpc_ram    u_ram_7   ( clk, reset_n, ram_wren, ram_addr7, ram_din7, ram_dout7);
ldpc_ram    u_ram_8   ( clk, reset_n, ram_wren, ram_addr8, ram_din8, ram_dout8);
ldpc_ram    u_ram_9   ( clk, reset_n, ram_wren, ram_addr9, ram_din9, ram_dout9);
               
ldpc_ram    u_ram_10  ( clk, reset_n, ram_wren, ram_addr10, ram_din10, ram_dout10);                                                     
ldpc_ram    u_ram_11  ( clk, reset_n, ram_wren, ram_addr11, ram_din11, ram_dout11);                                                      
ldpc_ram    u_ram_12  ( clk, reset_n, ram_wren, ram_addr12, ram_din12, ram_dout12);
ldpc_ram    u_ram_13  ( clk, reset_n, ram_wren, ram_addr13, ram_din13, ram_dout13);                                                     
ldpc_ram    u_ram_14  ( clk, reset_n, ram_wren, ram_addr14, ram_din14, ram_dout14); 
ldpc_ram    u_ram_15  ( clk, reset_n, ram_wren, ram_addr15, ram_din15, ram_dout15);
ldpc_ram    u_ram_16  ( clk, reset_n, ram_wren, ram_addr16, ram_din16, ram_dout16); 
ldpc_ram    u_ram_17  ( clk, reset_n, ram_wren, ram_addr17, ram_din17, ram_dout17);
ldpc_ram    u_ram_18  ( clk, reset_n, ram_wren, ram_addr18, ram_din18, ram_dout18);
ldpc_ram    u_ram_19  ( clk, reset_n, ram_wren, ram_addr19, ram_din19, ram_dout19);
               
ldpc_ram    u_ram_20   ( clk, reset_n, ram_wren, ram_addr20, ram_din20, ram_dout20);
ldpc_ram    u_ram_21   ( clk, reset_n, ram_wren, ram_addr21, ram_din21, ram_dout21);
ldpc_ram    u_ram_22   ( clk, reset_n, ram_wren, ram_addr22, ram_din22, ram_dout22);
ldpc_ram    u_ram_23   ( clk, reset_n, ram_wren, ram_addr23, ram_din23, ram_dout23);
ldpc_ram    u_ram_24   ( clk, reset_n, ram_wren, ram_addr24, ram_din24, ram_dout24); 
ldpc_ram    u_ram_25   ( clk, reset_n, ram_wren, ram_addr25, ram_din25, ram_dout25);
ldpc_ram    u_ram_26   ( clk, reset_n, ram_wren, ram_addr26, ram_din26, ram_dout26); 
ldpc_ram    u_ram_27   ( clk, reset_n, ram_wren, ram_addr27, ram_din27, ram_dout27);
ldpc_ram    u_ram_28   ( clk, reset_n, ram_wren, ram_addr28, ram_din28, ram_dout28);
ldpc_ram    u_ram_29   ( clk, reset_n, ram_wren, ram_addr29, ram_din29, ram_dout29);
               
ldpc_ram    u_ram_30   ( clk, reset_n, ram_wren, ram_addr30, ram_din30, ram_dout30);
ldpc_ram    u_ram_31   ( clk, reset_n, ram_wren, ram_addr31, ram_din31, ram_dout31);
ldpc_ram    u_ram_32   ( clk, reset_n, ram_wren, ram_addr32, ram_din32, ram_dout32);
ldpc_ram    u_ram_33   ( clk, reset_n, ram_wren, ram_addr33, ram_din33, ram_dout33);
ldpc_ram    u_ram_34   ( clk, reset_n, ram_wren, ram_addr34, ram_din34, ram_dout34); 
ldpc_ram    u_ram_35   ( clk, reset_n, ram_wren, ram_addr35, ram_din35, ram_dout35);
ldpc_ram    u_ram_36   ( clk, reset_n, ram_wren, ram_addr36, ram_din36, ram_dout36); 
ldpc_ram    u_ram_37   ( clk, reset_n, ram_wren, ram_addr37, ram_din37, ram_dout37);
ldpc_ram    u_ram_38   ( clk, reset_n, ram_wren, ram_addr38, ram_din38, ram_dout38);
ldpc_ram    u_ram_39   ( clk, reset_n, ram_wren, ram_addr39, ram_din39, ram_dout39);
               
ldpc_ram    u_ram_40   ( clk, reset_n, ram_wren, ram_addr40, ram_din40, ram_dout40);
ldpc_ram    u_ram_41   ( clk, reset_n, ram_wren, ram_addr41, ram_din41, ram_dout41);
ldpc_ram    u_ram_42   ( clk, reset_n, ram_wren, ram_addr42, ram_din42, ram_dout42);
ldpc_ram    u_ram_43   ( clk, reset_n, ram_wren, ram_addr43, ram_din43, ram_dout43);
ldpc_ram    u_ram_44   ( clk, reset_n, ram_wren, ram_addr44, ram_din44, ram_dout44); 
ldpc_ram    u_ram_45   ( clk, reset_n, ram_wren, ram_addr45, ram_din45, ram_dout45);
ldpc_ram    u_ram_46   ( clk, reset_n, ram_wren, ram_addr46, ram_din46, ram_dout46); 
ldpc_ram    u_ram_47   ( clk, reset_n, ram_wren, ram_addr47, ram_din47, ram_dout47);
ldpc_ram    u_ram_48   ( clk, reset_n, ram_wren, ram_addr48, ram_din48, ram_dout48);
ldpc_ram    u_ram_49   ( clk, reset_n, ram_wren, ram_addr49, ram_din49, ram_dout49);
               
ldpc_ram    u_ram_50   ( clk, reset_n, ram_wren, ram_addr50, ram_din50, ram_dout50);
ldpc_ram    u_ram_51   ( clk, reset_n, ram_wren, ram_addr51, ram_din51, ram_dout51);
ldpc_ram    u_ram_52   ( clk, reset_n, ram_wren, ram_addr52, ram_din52, ram_dout52);
ldpc_ram    u_ram_53   ( clk, reset_n, ram_wren, ram_addr53, ram_din53, ram_dout53);
ldpc_ram    u_ram_54   ( clk, reset_n, ram_wren, ram_addr54, ram_din54, ram_dout54); 
ldpc_ram    u_ram_55   ( clk, reset_n, ram_wren, ram_addr55, ram_din55, ram_dout55);
ldpc_ram    u_ram_56   ( clk, reset_n, ram_wren, ram_addr56, ram_din56, ram_dout56); 
ldpc_ram    u_ram_57   ( clk, reset_n, ram_wren, ram_addr57, ram_din57, ram_dout57);
ldpc_ram    u_ram_58   ( clk, reset_n, ram_wren, ram_addr58, ram_din58, ram_dout58);
ldpc_ram    u_ram_59   ( clk, reset_n, ram_wren, ram_addr59, ram_din59, ram_dout59);
               
ldpc_ram    u_ram_60   ( clk, reset_n, ram_wren, ram_addr60, ram_din60, ram_dout60);
ldpc_ram    u_ram_61   ( clk, reset_n, ram_wren, ram_addr61, ram_din61, ram_dout61);
ldpc_ram    u_ram_62   ( clk, reset_n, ram_wren, ram_addr62, ram_din62, ram_dout62);
ldpc_ram    u_ram_63   ( clk, reset_n, ram_wren, ram_addr63, ram_din63, ram_dout63);
ldpc_ram    u_ram_64   ( clk, reset_n, ram_wren, ram_addr64, ram_din64, ram_dout64); 
ldpc_ram    u_ram_65   ( clk, reset_n, ram_wren, ram_addr65, ram_din65, ram_dout65);
ldpc_ram    u_ram_66   ( clk, reset_n, ram_wren, ram_addr66, ram_din66, ram_dout66); 
ldpc_ram    u_ram_67   ( clk, reset_n, ram_wren, ram_addr67, ram_din67, ram_dout67);
ldpc_ram    u_ram_68   ( clk, reset_n, ram_wren, ram_addr68, ram_din68, ram_dout68);
ldpc_ram    u_ram_69   ( clk, reset_n, ram_wren, ram_addr69, ram_din69, ram_dout69);
              
ldpc_ram    u_ram_70   ( clk, reset_n, ram_wren, ram_addr70, ram_din70, ram_dout70);
ldpc_ram    u_ram_71   ( clk, reset_n, ram_wren, ram_addr71, ram_din71, ram_dout71);
ldpc_ram    u_ram_72   ( clk, reset_n, ram_wren, ram_addr72, ram_din72, ram_dout72);
ldpc_ram    u_ram_73   ( clk, reset_n, ram_wren, ram_addr73, ram_din73, ram_dout73);
ldpc_ram    u_ram_74   ( clk, reset_n, ram_wren, ram_addr74, ram_din74, ram_dout74); 
ldpc_ram    u_ram_75   ( clk, reset_n, ram_wren, ram_addr75, ram_din75, ram_dout75);
ldpc_ram    u_ram_76   ( clk, reset_n, ram_wren, ram_addr76, ram_din76, ram_dout76); 
ldpc_ram    u_ram_77   ( clk, reset_n, ram_wren, ram_addr77, ram_din77, ram_dout77);
ldpc_ram    u_ram_78   ( clk, reset_n, ram_wren, ram_addr78, ram_din78, ram_dout78);
ldpc_ram    u_ram_79   ( clk, reset_n, ram_wren, ram_addr79, ram_din79, ram_dout79);
             
ldpc_ram    u_ram_80   ( clk, reset_n, ram_wren, ram_addr80, ram_din80, ram_dout80);
ldpc_ram    u_ram_81   ( clk, reset_n, ram_wren, ram_addr81, ram_din81, ram_dout81);
ldpc_ram    u_ram_82   ( clk, reset_n, ram_wren, ram_addr82, ram_din82, ram_dout82);
ldpc_ram    u_ram_83   ( clk, reset_n, ram_wren, ram_addr83, ram_din83, ram_dout83);
ldpc_ram    u_ram_84   ( clk, reset_n, ram_wren, ram_addr84, ram_din84, ram_dout84); 
ldpc_ram    u_ram_85   ( clk, reset_n, ram_wren, ram_addr85, ram_din85, ram_dout85);
ldpc_ram    u_ram_86   ( clk, reset_n, ram_wren, ram_addr86, ram_din86, ram_dout86); 
ldpc_ram    u_ram_87   ( clk, reset_n, ram_wren, ram_addr87, ram_din87, ram_dout87);
ldpc_ram    u_ram_88   ( clk, reset_n, ram_wren, ram_addr88, ram_din88, ram_dout88);
ldpc_ram    u_ram_89   ( clk, reset_n, ram_wren, ram_addr89, ram_din89, ram_dout89);
             
ldpc_ram    u_ram_90   ( clk, reset_n, ram_wren, ram_addr90, ram_din90, ram_dout90);
ldpc_ram    u_ram_91   ( clk, reset_n, ram_wren, ram_addr91, ram_din91, ram_dout91);
ldpc_ram    u_ram_92   ( clk, reset_n, ram_wren, ram_addr92, ram_din92, ram_dout92);
ldpc_ram    u_ram_93   ( clk, reset_n, ram_wren, ram_addr93, ram_din93, ram_dout93);
ldpc_ram    u_ram_94   ( clk, reset_n, ram_wren, ram_addr94, ram_din94, ram_dout94); 
ldpc_ram    u_ram_95   ( clk, reset_n, ram_wren, ram_addr95, ram_din95, ram_dout95);
ldpc_ram    u_ram_96   ( clk, reset_n, ram_wren, ram_addr96, ram_din96, ram_dout96); 
ldpc_ram    u_ram_97   ( clk, reset_n, ram_wren, ram_addr97, ram_din97, ram_dout97);
ldpc_ram    u_ram_98   ( clk, reset_n, ram_wren, ram_addr98, ram_din98, ram_dout98);
ldpc_ram    u_ram_99   ( clk, reset_n, ram_wren, ram_addr99, ram_din99, ram_dout99);
             
ldpc_ram    u_ram_100   ( clk, reset_n, ram_wren, ram_addr100, ram_din100, ram_dout100);
ldpc_ram    u_ram_101   ( clk, reset_n, ram_wren, ram_addr101, ram_din101, ram_dout101);
ldpc_ram    u_ram_102   ( clk, reset_n, ram_wren, ram_addr102, ram_din102, ram_dout102);
ldpc_ram    u_ram_103   ( clk, reset_n, ram_wren, ram_addr103, ram_din103, ram_dout103);
ldpc_ram    u_ram_104   ( clk, reset_n, ram_wren, ram_addr104, ram_din104, ram_dout104); 
ldpc_ram    u_ram_105   ( clk, reset_n, ram_wren, ram_addr105, ram_din105, ram_dout105);
ldpc_ram    u_ram_106   ( clk, reset_n, ram_wren, ram_addr106, ram_din106, ram_dout106); 
ldpc_ram    u_ram_107   ( clk, reset_n, ram_wren, ram_addr107, ram_din107, ram_dout107);




endmodule







