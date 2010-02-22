module data_comp(
    clk    ,
    reset_n,
    fsm    ,
    cycle  ,
    iter_0 ,
    rate   ,
    sync_in,
    data_in,
    ctv_out,
    dout00 ,
    dout01 ,
    dout02 ,
    dout03 ,
    dout04 ,
    dout05 ,
    dout06 ,
    dout07 ,
    dout08 ,
    dout09 ,
    dout10 ,
    dout11 ,
    dout12 ,
    dout13 ,
    dout14 ,
    dout15 ,
    dout16 ,
    dout17 ,
    dout18 ,
    dout19 ,
    dout20 ,
    dout21 ,
    dout22 ,
    dout23 ,
    dout24 ,
    dout25 ,
    dout26 ,
    dout27 ,
    dout28 ,
    dout29 ,
    dout30 ,
    dout31 ,
    dout32 ,
    dout33 ,
    dout34 ,
    dout35 ,
    din00 ,
    din01 ,
    din02 ,
    din03 ,
    din04 ,
    din05 ,
    din06 ,
    din07 ,
    din08 ,
    din09 ,
    din10 ,
    din11 ,
    din12 ,
    din13 ,
    din14 ,
    din15 ,
    din16 ,
    din17 ,
    din18 ,
    din19 ,
    din20 ,
    din21 ,
    din22 ,
    din23 ,
    din24 ,
    din25 ,
    din26 ,
    din27 ,
    din28 ,
    din29 ,
    din30 ,
    din31 ,
    din32 ,
    din33 ,
    din34 ,
    din35 
);

//Parameter
parameter D_WID = 8;

//Input ports
input                 clk        ;
input                 reset_n    ;
input   [3:0]         fsm        ;
input                 rate       ;
input   [1:0]         cycle      ;
input                 iter_0     ;
input   [35:0]        sync_in    ;
input   [D_WID-1:0]   data_in    ;

input   [D_WID-1:0]   dout00     ;
input   [D_WID-1:0]   dout01     ;
input   [D_WID-1:0]   dout02     ;
input   [D_WID-1:0]   dout03     ;
input   [D_WID-1:0]   dout04     ;
input   [D_WID-1:0]   dout05     ;
input   [D_WID-1:0]   dout06     ;
input   [D_WID-1:0]   dout07     ;
input   [D_WID-1:0]   dout08     ;
input   [D_WID-1:0]   dout09     ;
input   [D_WID-1:0]   dout10     ;
input   [D_WID-1:0]   dout11     ;
input   [D_WID-1:0]   dout12     ;
input   [D_WID-1:0]   dout13     ;
input   [D_WID-1:0]   dout14     ;
input   [D_WID-1:0]   dout15     ;
input   [D_WID-1:0]   dout16     ;
input   [D_WID-1:0]   dout17     ;
input   [D_WID-1:0]   dout18     ;
input   [D_WID-1:0]   dout19     ;
input   [D_WID-1:0]   dout20     ;
input   [D_WID-1:0]   dout21     ;
input   [D_WID-1:0]   dout22     ;
input   [D_WID-1:0]   dout23     ;
input   [D_WID-1:0]   dout24     ;
input   [D_WID-1:0]   dout25     ;
input   [D_WID-1:0]   dout26     ;
input   [D_WID-1:0]   dout27     ;
input   [D_WID-1:0]   dout28     ;
input   [D_WID-1:0]   dout29     ;
input   [D_WID-1:0]   dout30     ;
input   [D_WID-1:0]   dout31     ;
input   [D_WID-1:0]   dout32     ;
input   [D_WID-1:0]   dout33     ;
input   [D_WID-1:0]   dout34     ;
input   [D_WID-1:0]   dout35     ;

//Output ports
output                ctv_out   ;
output  [D_WID-1:0]   din00     ;
output  [D_WID-1:0]   din01     ;
output  [D_WID-1:0]   din02     ;
output  [D_WID-1:0]   din03     ;
output  [D_WID-1:0]   din04     ;
output  [D_WID-1:0]   din05     ;
output  [D_WID-1:0]   din06     ;
output  [D_WID-1:0]   din07     ;
output  [D_WID-1:0]   din08     ;
output  [D_WID-1:0]   din09     ;
output  [D_WID-1:0]   din10     ;
output  [D_WID-1:0]   din11     ;
output  [D_WID-1:0]   din12     ;
output  [D_WID-1:0]   din13     ;
output  [D_WID-1:0]   din14     ;
output  [D_WID-1:0]   din15     ;
output  [D_WID-1:0]   din16     ;
output  [D_WID-1:0]   din17     ;
output  [D_WID-1:0]   din18     ;
output  [D_WID-1:0]   din19     ;
output  [D_WID-1:0]   din20     ;
output  [D_WID-1:0]   din21     ;
output  [D_WID-1:0]   din22     ;
output  [D_WID-1:0]   din23     ;
output  [D_WID-1:0]   din24     ;
output  [D_WID-1:0]   din25     ;
output  [D_WID-1:0]   din26     ;
output  [D_WID-1:0]   din27     ;
output  [D_WID-1:0]   din28     ;
output  [D_WID-1:0]   din29     ;
output  [D_WID-1:0]   din30     ;
output  [D_WID-1:0]   din31     ;
output  [D_WID-1:0]   din32     ;
output  [D_WID-1:0]   din33     ;
output  [D_WID-1:0]   din34     ;
output  [D_WID-1:0]   din35     ;

reg     [1:0]         cycle_dly  ;
reg     [1:0]         cycle_dly2 ;
reg     [2:0]         vtc_en     ;
reg     [6:0]         cnu_in     ;
reg     [D_WID-1:0]   data_buffer0a     ;
reg     [D_WID-1:0]   data_buffer1a     ;
reg     [D_WID-1:0]   data_buffer2a     ;
reg     [D_WID-1:0]   data_buffer3a     ;
reg     [D_WID-1:0]   data_buffer4a     ;
reg     [D_WID-1:0]   data_buffer5a     ;
reg     [D_WID-1:0]   data_buffer6a     ;
reg     [D_WID-1:0]   data_buffer7a     ;
reg     [D_WID-1:0]   data_buffer8a     ;
reg     [D_WID-1:0]   data_buffer9a     ;
reg     [D_WID-1:0]   data_buffer10a    ;
reg     [D_WID-1:0]   data_buffer11a    ;
reg     [D_WID-1:0]   data_buffer12a    ;
reg     [D_WID-1:0]   data_buffer13a    ;
reg     [D_WID-1:0]   data_buffer14a    ;
reg     [D_WID-1:0]   data_buffer15a    ;
reg     [D_WID-1:0]   data_buffer16a    ;
reg     [D_WID-1:0]   data_buffer17a    ;
reg     [D_WID-1:0]   data_buffer18a    ;
reg     [D_WID-1:0]   data_buffer19a    ;
reg     [D_WID-1:0]   data_buffer20a    ;
reg     [D_WID-1:0]   data_buffer21a    ;
reg     [D_WID-1:0]   data_buffer22a    ;
reg     [D_WID-1:0]   data_buffer23a    ;
reg     [D_WID-1:0]   data_buffer24a    ;
reg     [D_WID-1:0]   data_buffer25a    ;
reg     [D_WID-1:0]   data_buffer26a    ;
reg     [D_WID-1:0]   data_buffer27a    ;
reg     [D_WID-1:0]   data_buffer28a    ;
reg     [D_WID-1:0]   data_buffer29a    ;
reg     [D_WID-1:0]   data_buffer30a    ;
reg     [D_WID-1:0]   data_buffer31a    ;
reg     [D_WID-1:0]   data_buffer32a    ;
reg     [D_WID-1:0]   data_buffer33a    ;
reg     [D_WID-1:0]   data_buffer34a    ;
reg     [D_WID-1:0]   data_buffer35a    ;
reg     [D_WID-1:0]   data_buffer0b     ;
reg     [D_WID-1:0]   data_buffer1b     ;
reg     [D_WID-1:0]   data_buffer2b     ;
reg     [D_WID-1:0]   data_buffer3b     ;
reg     [D_WID-1:0]   data_buffer4b     ;
reg     [D_WID-1:0]   data_buffer5b     ;
reg     [D_WID-1:0]   data_buffer6b     ;
reg     [D_WID-1:0]   data_buffer7b     ;
reg     [D_WID-1:0]   data_buffer8b     ;
reg     [D_WID-1:0]   data_buffer9b     ;
reg     [D_WID-1:0]   data_buffer10b    ;
reg     [D_WID-1:0]   data_buffer11b    ;
reg     [D_WID-1:0]   data_buffer12b    ;
reg     [D_WID-1:0]   data_buffer13b    ;
reg     [D_WID-1:0]   data_buffer14b    ;
reg     [D_WID-1:0]   data_buffer15b    ;
reg     [D_WID-1:0]   data_buffer16b    ;
reg     [D_WID-1:0]   data_buffer17b    ;
reg     [D_WID-1:0]   data_buffer18b    ;
reg     [D_WID-1:0]   data_buffer19b    ;
reg     [D_WID-1:0]   data_buffer20b    ;
reg     [D_WID-1:0]   data_buffer21b    ;
reg     [D_WID-1:0]   data_buffer22b    ;
reg     [D_WID-1:0]   data_buffer23b    ;
reg     [D_WID-1:0]   data_buffer24b    ;
reg     [D_WID-1:0]   data_buffer25b    ;
reg     [D_WID-1:0]   data_buffer26b    ;
reg     [D_WID-1:0]   data_buffer27b    ;
reg     [D_WID-1:0]   data_buffer28b    ;
reg     [D_WID-1:0]   data_buffer29b    ;
reg     [D_WID-1:0]   data_buffer30b    ;
reg     [D_WID-1:0]   data_buffer31b    ;
reg     [D_WID-1:0]   data_buffer32b    ;
reg     [D_WID-1:0]   data_buffer33b    ;
reg     [D_WID-1:0]   data_buffer34b    ;
reg     [D_WID-1:0]   data_buffer35b    ;
reg     [D_WID-1:0]   data_buffer0c     ;
reg     [D_WID-1:0]   data_buffer1c     ;
reg     [D_WID-1:0]   data_buffer2c     ;
reg     [D_WID-1:0]   data_buffer3c     ;
reg     [D_WID-1:0]   data_buffer4c     ;
reg     [D_WID-1:0]   data_buffer5c     ;
reg     [D_WID-1:0]   data_buffer6c     ;
reg     [D_WID-1:0]   data_buffer7c     ;
reg     [D_WID-1:0]   data_buffer8c     ;
reg     [D_WID-1:0]   data_buffer9c     ;
reg     [D_WID-1:0]   data_buffer10c    ;
reg     [D_WID-1:0]   data_buffer11c    ;
reg     [D_WID-1:0]   data_buffer12c    ;
reg     [D_WID-1:0]   data_buffer13c    ;
reg     [D_WID-1:0]   data_buffer14c    ;
reg     [D_WID-1:0]   data_buffer15c    ;
reg     [D_WID-1:0]   data_buffer16c    ;
reg     [D_WID-1:0]   data_buffer17c    ;
reg     [D_WID-1:0]   data_buffer18c    ;
reg     [D_WID-1:0]   data_buffer19c    ;
reg     [D_WID-1:0]   data_buffer20c    ;
reg     [D_WID-1:0]   data_buffer21c    ;
reg     [D_WID-1:0]   data_buffer22c    ;
reg     [D_WID-1:0]   data_buffer23c    ;
reg     [D_WID-1:0]   data_buffer24c    ;
reg     [D_WID-1:0]   data_buffer25c    ;
reg     [D_WID-1:0]   data_buffer26c    ;
reg     [D_WID-1:0]   data_buffer27c    ;
reg     [D_WID-1:0]   data_buffer28c    ;
reg     [D_WID-1:0]   data_buffer29c    ;
reg     [D_WID-1:0]   data_buffer30c    ;
reg     [D_WID-1:0]   data_buffer31c    ;
reg     [D_WID-1:0]   data_buffer32c    ;
reg     [D_WID-1:0]   data_buffer33c    ;
reg     [D_WID-1:0]   data_buffer34c    ;
reg     [D_WID-1:0]   data_buffer35c    ;
reg     [D_WID-1:0]   dvtc_0a           ;
reg     [D_WID-1:0]   dvtc_1a           ;
reg     [D_WID-1:0]   dvtc_2a           ;
reg     [D_WID-1:0]   dvtc_3a           ;
reg     [D_WID-1:0]   dvtc_4a           ;
reg     [D_WID-1:0]   dvtc_5a           ;
reg     [D_WID-1:0]   dvtc_6a           ;
reg     [D_WID-1:0]   dvtc_7a           ;
reg     [D_WID-1:0]   dvtc_8a           ;
reg     [D_WID-1:0]   dvtc_9a           ;
reg     [D_WID-1:0]   dvtc_10a          ;
reg     [D_WID-1:0]   dvtc_11a          ;
reg     [D_WID-1:0]   dvtc_12a          ;
reg     [D_WID-1:0]   dvtc_13a          ;
reg     [D_WID-1:0]   dvtc_14a          ;
reg     [D_WID-1:0]   dvtc_15a          ;
reg     [D_WID-1:0]   dvtc_16a          ;
reg     [D_WID-1:0]   dvtc_17a          ;
reg     [D_WID-1:0]   dvtc_18a          ;
reg     [D_WID-1:0]   dvtc_19a          ;
reg     [D_WID-1:0]   dvtc_20a          ;
reg     [D_WID-1:0]   dvtc_21a          ;
reg     [D_WID-1:0]   dvtc_22a          ;
reg     [D_WID-1:0]   dvtc_23a          ;
reg     [D_WID-1:0]   dvtc_24a          ;
reg     [D_WID-1:0]   dvtc_25a          ;
reg     [D_WID-1:0]   dvtc_26a          ;
reg     [D_WID-1:0]   dvtc_27a          ;
reg     [D_WID-1:0]   dvtc_28a          ;
reg     [D_WID-1:0]   dvtc_29a          ;
reg     [D_WID-1:0]   dvtc_30a          ;
reg     [D_WID-1:0]   dvtc_31a          ;
reg     [D_WID-1:0]   dvtc_32a          ;
reg     [D_WID-1:0]   dvtc_33a          ;
reg     [D_WID-1:0]   dvtc_34a          ;
reg     [D_WID-1:0]   dvtc_35a          ;
reg     [D_WID-1:0]   dvtc_0b           ;
reg     [D_WID-1:0]   dvtc_1b           ;
reg     [D_WID-1:0]   dvtc_2b           ;
reg     [D_WID-1:0]   dvtc_3b           ;
reg     [D_WID-1:0]   dvtc_4b           ;
reg     [D_WID-1:0]   dvtc_5b           ;
reg     [D_WID-1:0]   dvtc_6b           ;
reg     [D_WID-1:0]   dvtc_7b           ;
reg     [D_WID-1:0]   dvtc_8b           ;
reg     [D_WID-1:0]   dvtc_9b           ;
reg     [D_WID-1:0]   dvtc_10b          ;
reg     [D_WID-1:0]   dvtc_11b          ;
reg     [D_WID-1:0]   dvtc_12b          ;
reg     [D_WID-1:0]   dvtc_13b          ;
reg     [D_WID-1:0]   dvtc_14b          ;
reg     [D_WID-1:0]   dvtc_15b          ;
reg     [D_WID-1:0]   dvtc_16b          ;
reg     [D_WID-1:0]   dvtc_17b          ;
reg     [D_WID-1:0]   dvtc_18b          ;
reg     [D_WID-1:0]   dvtc_19b          ;
reg     [D_WID-1:0]   dvtc_20b          ;
reg     [D_WID-1:0]   dvtc_21b          ;
reg     [D_WID-1:0]   dvtc_22b          ;
reg     [D_WID-1:0]   dvtc_23b          ;
reg     [D_WID-1:0]   dvtc_24b          ;
reg     [D_WID-1:0]   dvtc_25b          ;
reg     [D_WID-1:0]   dvtc_26b          ;
reg     [D_WID-1:0]   dvtc_27b          ;
reg     [D_WID-1:0]   dvtc_28b          ;
reg     [D_WID-1:0]   dvtc_29b          ;
reg     [D_WID-1:0]   dvtc_30b          ;
reg     [D_WID-1:0]   dvtc_31b          ;
reg     [D_WID-1:0]   dvtc_32b          ;
reg     [D_WID-1:0]   dvtc_33b          ;
reg     [D_WID-1:0]   dvtc_34b          ;
reg     [D_WID-1:0]   dvtc_35b          ;
reg     [D_WID-1:0]   dvtc_0c           ;
reg     [D_WID-1:0]   dvtc_1c           ;
reg     [D_WID-1:0]   dvtc_2c           ;
reg     [D_WID-1:0]   dvtc_3c           ;
reg     [D_WID-1:0]   dvtc_4c           ;
reg     [D_WID-1:0]   dvtc_5c           ;
reg     [D_WID-1:0]   dvtc_6c           ;
reg     [D_WID-1:0]   dvtc_7c           ;
reg     [D_WID-1:0]   dvtc_8c           ;
reg     [D_WID-1:0]   dvtc_9c           ;
reg     [D_WID-1:0]   dvtc_10c          ;
reg     [D_WID-1:0]   dvtc_11c          ;
reg     [D_WID-1:0]   dvtc_12c          ;
reg     [D_WID-1:0]   dvtc_13c          ;
reg     [D_WID-1:0]   dvtc_14c          ;
reg     [D_WID-1:0]   dvtc_15c          ;
reg     [D_WID-1:0]   dvtc_16c          ;
reg     [D_WID-1:0]   dvtc_17c          ;
reg     [D_WID-1:0]   dvtc_18c          ;
reg     [D_WID-1:0]   dvtc_19c          ;
reg     [D_WID-1:0]   dvtc_20c          ;
reg     [D_WID-1:0]   dvtc_21c          ;
reg     [D_WID-1:0]   dvtc_22c          ;
reg     [D_WID-1:0]   dvtc_23c          ;
reg     [D_WID-1:0]   dvtc_24c          ;
reg     [D_WID-1:0]   dvtc_25c          ;
reg     [D_WID-1:0]   dvtc_26c          ;
reg     [D_WID-1:0]   dvtc_27c          ;
reg     [D_WID-1:0]   dvtc_28c          ;
reg     [D_WID-1:0]   dvtc_29c          ;
reg     [D_WID-1:0]   dvtc_30c          ;
reg     [D_WID-1:0]   dvtc_31c          ;
reg     [D_WID-1:0]   dvtc_32c          ;
reg     [D_WID-1:0]   dvtc_33c          ;
reg     [D_WID-1:0]   dvtc_34c          ;
reg     [D_WID-1:0]   dvtc_35c          ;

reg     [D_WID-1:0]   data_out0a     ;
reg     [D_WID-1:0]   data_out1a     ;
reg     [D_WID-1:0]   data_out2a     ;
reg     [D_WID-1:0]   data_out3a     ;
reg     [D_WID-1:0]   data_out4a     ;
reg     [D_WID-1:0]   data_out5a     ;
reg     [D_WID-1:0]   data_out6a     ;
reg     [D_WID-1:0]   data_out7a     ;
reg     [D_WID-1:0]   data_out8a     ;
reg     [D_WID-1:0]   data_out9a     ;
reg     [D_WID-1:0]   data_out10a    ;
reg     [D_WID-1:0]   data_out11a    ;
reg     [D_WID-1:0]   data_out12a    ;
reg     [D_WID-1:0]   data_out13a    ;
reg     [D_WID-1:0]   data_out14a    ;
reg     [D_WID-1:0]   data_out15a    ;
reg     [D_WID-1:0]   data_out16a    ;
reg     [D_WID-1:0]   data_out17a    ;
reg     [D_WID-1:0]   data_out18a    ;
reg     [D_WID-1:0]   data_out19a    ;
reg     [D_WID-1:0]   data_out20a    ;
reg     [D_WID-1:0]   data_out21a    ;
reg     [D_WID-1:0]   data_out22a    ;
reg     [D_WID-1:0]   data_out23a    ;
reg     [D_WID-1:0]   data_out24a    ;
reg     [D_WID-1:0]   data_out25a    ;
reg     [D_WID-1:0]   data_out26a    ;
reg     [D_WID-1:0]   data_out27a    ;
reg     [D_WID-1:0]   data_out28a    ;
reg     [D_WID-1:0]   data_out29a    ;
reg     [D_WID-1:0]   data_out30a    ;
reg     [D_WID-1:0]   data_out31a    ;
reg     [D_WID-1:0]   data_out32a    ;
reg     [D_WID-1:0]   data_out33a    ;
reg     [D_WID-1:0]   data_out34a    ;
reg     [D_WID-1:0]   data_out35a    ;
reg     [D_WID-1:0]   data_out0b     ;
reg     [D_WID-1:0]   data_out1b     ;
reg     [D_WID-1:0]   data_out2b     ;
reg     [D_WID-1:0]   data_out3b     ;
reg     [D_WID-1:0]   data_out4b     ;
reg     [D_WID-1:0]   data_out5b     ;
reg     [D_WID-1:0]   data_out6b     ;
reg     [D_WID-1:0]   data_out7b     ;
reg     [D_WID-1:0]   data_out8b     ;
reg     [D_WID-1:0]   data_out9b     ;
reg     [D_WID-1:0]   data_out10b    ;
reg     [D_WID-1:0]   data_out11b    ;
reg     [D_WID-1:0]   data_out12b    ;
reg     [D_WID-1:0]   data_out13b    ;
reg     [D_WID-1:0]   data_out14b    ;
reg     [D_WID-1:0]   data_out15b    ;
reg     [D_WID-1:0]   data_out16b    ;
reg     [D_WID-1:0]   data_out17b    ;
reg     [D_WID-1:0]   data_out18b    ;
reg     [D_WID-1:0]   data_out19b    ;
reg     [D_WID-1:0]   data_out20b    ;
reg     [D_WID-1:0]   data_out21b    ;
reg     [D_WID-1:0]   data_out22b    ;
reg     [D_WID-1:0]   data_out23b    ;
reg     [D_WID-1:0]   data_out24b    ;
reg     [D_WID-1:0]   data_out25b    ;
reg     [D_WID-1:0]   data_out26b    ;
reg     [D_WID-1:0]   data_out27b    ;
reg     [D_WID-1:0]   data_out28b    ;
reg     [D_WID-1:0]   data_out29b    ;
reg     [D_WID-1:0]   data_out30b    ;
reg     [D_WID-1:0]   data_out31b    ;
reg     [D_WID-1:0]   data_out32b    ;
reg     [D_WID-1:0]   data_out33b    ;
reg     [D_WID-1:0]   data_out34b    ;
reg     [D_WID-1:0]   data_out35b    ;
reg     [D_WID-1:0]   data_out0c     ;
reg     [D_WID-1:0]   data_out1c     ;
reg     [D_WID-1:0]   data_out2c     ;
reg     [D_WID-1:0]   data_out3c     ;
reg     [D_WID-1:0]   data_out4c     ;
reg     [D_WID-1:0]   data_out5c     ;
reg     [D_WID-1:0]   data_out6c     ;
reg     [D_WID-1:0]   data_out7c     ;
reg     [D_WID-1:0]   data_out8c     ;
reg     [D_WID-1:0]   data_out9c     ;
reg     [D_WID-1:0]   data_out10c    ;
reg     [D_WID-1:0]   data_out11c    ;
reg     [D_WID-1:0]   data_out12c    ;
reg     [D_WID-1:0]   data_out13c    ;
reg     [D_WID-1:0]   data_out14c    ;
reg     [D_WID-1:0]   data_out15c    ;
reg     [D_WID-1:0]   data_out16c    ;
reg     [D_WID-1:0]   data_out17c    ;
reg     [D_WID-1:0]   data_out18c    ;
reg     [D_WID-1:0]   data_out19c    ;
reg     [D_WID-1:0]   data_out20c    ;
reg     [D_WID-1:0]   data_out21c    ;
reg     [D_WID-1:0]   data_out22c    ;
reg     [D_WID-1:0]   data_out23c    ;
reg     [D_WID-1:0]   data_out24c    ;
reg     [D_WID-1:0]   data_out25c    ;
reg     [D_WID-1:0]   data_out26c    ;
reg     [D_WID-1:0]   data_out27c    ;
reg     [D_WID-1:0]   data_out28c    ;
reg     [D_WID-1:0]   data_out29c    ;
reg     [D_WID-1:0]   data_out30c    ;
reg     [D_WID-1:0]   data_out31c    ;
reg     [D_WID-1:0]   data_out32c    ;
reg     [D_WID-1:0]   data_out33c    ;
reg     [D_WID-1:0]   data_out34c    ;
reg     [D_WID-1:0]   data_out35c    ;
reg     [D_WID-1:0]   data_0     ;
reg     [D_WID-1:0]   data_1     ;
reg     [D_WID-1:0]   data_2     ;
reg     [D_WID-1:0]   data_3     ;
reg     [D_WID-1:0]   data_4     ;
reg     [D_WID-1:0]   data_5     ;
reg     [D_WID-1:0]   data_6     ;
reg     [D_WID-1:0]   data_7     ;
reg     [D_WID-1:0]   data_8     ;
reg   [6*D_WID-1:0]   cnu0_d     ;
reg   [6*D_WID-1:0]   cnu1_d     ;
reg   [6*D_WID-1:0]   cnu2_d     ;
reg   [6*D_WID-1:0]   cnu3_d     ;
reg   [6*D_WID-1:0]   cnu4_d     ;
reg   [6*D_WID-1:0]   cnu5_d     ;
reg   [6*D_WID-1:0]   cnu6_d     ;
reg   [6*D_WID-1:0]   cnu7_d     ;
reg   [6*D_WID-1:0]   cnu8_d     ;
reg   [6*D_WID-1:0]   cnu9_d     ;
reg   [6*D_WID-1:0]   cnua_d     ;
reg   [6*D_WID-1:0]   cnub_d     ;
reg   [6*D_WID-1:0]   cnuc_d     ;
reg   [6*D_WID-1:0]   cnud_d     ;
reg   [6*D_WID-1:0]   cnue_d     ;
reg   [6*D_WID-1:0]   cnuf_d     ;
reg   [6*D_WID-1:0]   cnug_d     ;
reg   [6*D_WID-1:0]   cnuh_d     ;
reg   [2*D_WID+9:0]   vnu0_d     ;
reg   [2*D_WID+9:0]   vnu1_d     ;
reg   [2*D_WID+9:0]   vnu2_d     ;
reg   [2*D_WID+9:0]   vnu3_d     ;
reg   [2*D_WID+9:0]   vnu4_d     ;
reg   [2*D_WID+9:0]   vnu5_d     ;
reg   [2*D_WID+9:0]   vnu6_d     ;
reg   [2*D_WID+9:0]   vnu7_d     ;
reg   [2*D_WID+9:0]   vnu8_d     ;
reg   [2*D_WID+9:0]   vnu9_d     ;
reg   [2*D_WID+9:0]   vnua_d     ;
reg   [2*D_WID+9:0]   vnub_d     ;
reg   [2*D_WID+9:0]   vnuc_d     ;
reg   [2*D_WID+9:0]   vnud_d     ;
reg   [2*D_WID+9:0]   vnue_d     ;
reg   [2*D_WID+9:0]   vnuf_d     ;
reg   [2*D_WID+9:0]   vnug_d     ;
reg   [2*D_WID+9:0]   vnuh_d     ;

wire  [6*D_WID-1:0]   cnu0_q     ;
wire  [6*D_WID-1:0]   cnu1_q     ;
wire  [6*D_WID-1:0]   cnu2_q     ;
wire  [6*D_WID-1:0]   cnu3_q     ;
wire  [6*D_WID-1:0]   cnu4_q     ;
wire  [6*D_WID-1:0]   cnu5_q     ;
wire  [6*D_WID-1:0]   cnu6_q     ;
wire  [6*D_WID-1:0]   cnu7_q     ;
wire  [6*D_WID-1:0]   cnu8_q     ;
wire  [6*D_WID-1:0]   cnu9_q     ;
wire  [6*D_WID-1:0]   cnua_q     ;
wire  [6*D_WID-1:0]   cnub_q     ;
wire  [6*D_WID-1:0]   cnuc_q     ;
wire  [6*D_WID-1:0]   cnud_q     ;
wire  [6*D_WID-1:0]   cnue_q     ;
wire  [6*D_WID-1:0]   cnuf_q     ;
wire  [6*D_WID-1:0]   cnug_q     ;
wire  [6*D_WID-1:0]   cnuh_q     ;
wire  [2*D_WID+9:0]   vnu0_q     ;
wire  [2*D_WID+9:0]   vnu1_q     ;
wire  [2*D_WID+9:0]   vnu2_q     ;
wire  [2*D_WID+9:0]   vnu3_q     ;
wire  [2*D_WID+9:0]   vnu4_q     ;
wire  [2*D_WID+9:0]   vnu5_q     ;
wire  [2*D_WID+9:0]   vnu6_q     ;
wire  [2*D_WID+9:0]   vnu7_q     ;
wire  [2*D_WID+9:0]   vnu8_q     ;
wire  [2*D_WID+9:0]   vnu9_q     ;
wire  [2*D_WID+9:0]   vnua_q     ;
wire  [2*D_WID+9:0]   vnub_q     ;
wire  [2*D_WID+9:0]   vnuc_q     ;
wire  [2*D_WID+9:0]   vnud_q     ;
wire  [2*D_WID+9:0]   vnue_q     ;
wire  [2*D_WID+9:0]   vnuf_q     ;
wire  [2*D_WID+9:0]   vnug_q     ;
wire  [2*D_WID+9:0]   vnuh_q     ;

assign ctv_out = cnu_in[5];

always @ (posedge clk or negedge reset_n)
begin : cycle_dly_r
    if(!reset_n)
        cycle_dly <= #1 2'b0;
    else
        cycle_dly <= #1 cycle;
end

always @ (posedge clk or negedge reset_n)
begin : cycle_d2_r
    if(!reset_n)
        cycle_dly2 <= #1 2'b0;
    else
        cycle_dly2 <= #1 cycle_dly;
end

always @ (posedge clk or negedge reset_n)
begin : cnu_init_r
    if(!reset_n)
        cnu_in <= #1 7'h0;
    else
        cnu_in <= #1 { cnu_in[5:0], (( cycle_dly == 2'b11 ) ? 1'b1 : 1'b0)};
end         

always @ (posedge clk or negedge reset_n)
begin : data_buffer_ar
    if(!reset_n) begin
        data_buffer0a  <= #1 8'h0;
        data_buffer1a  <= #1 8'h0;
        data_buffer2a  <= #1 8'h0;
        data_buffer3a  <= #1 8'h0;
        data_buffer4a  <= #1 8'h0;
        data_buffer5a  <= #1 8'h0;
        data_buffer6a  <= #1 8'h0;
        data_buffer7a  <= #1 8'h0;
        data_buffer8a  <= #1 8'h0;
        data_buffer9a  <= #1 8'h0;
        data_buffer10a <= #1 8'h0;
        data_buffer11a <= #1 8'h0;
        data_buffer12a <= #1 8'h0;
        data_buffer13a <= #1 8'h0;
        data_buffer14a <= #1 8'h0;
        data_buffer15a <= #1 8'h0;
        data_buffer16a <= #1 8'h0;
        data_buffer17a <= #1 8'h0;
        data_buffer18a <= #1 8'h0;
        data_buffer19a <= #1 8'h0;
        data_buffer20a <= #1 8'h0;
        data_buffer21a <= #1 8'h0;
        data_buffer22a <= #1 8'h0;
        data_buffer23a <= #1 8'h0;
        data_buffer24a <= #1 8'h0;
        data_buffer25a <= #1 8'h0;
        data_buffer26a <= #1 8'h0;
        data_buffer27a <= #1 8'h0;
        data_buffer28a <= #1 8'h0;
        data_buffer29a <= #1 8'h0;
        data_buffer30a <= #1 8'h0;
        data_buffer31a <= #1 8'h0;
        data_buffer32a <= #1 8'h0;
        data_buffer33a <= #1 8'h0;
        data_buffer34a <= #1 8'h0;
        data_buffer35a <= #1 8'h0;
        end
    else if(cycle_dly2 == 2'b01) begin
        data_buffer0a  <= #1 dout00;
        data_buffer1a  <= #1 dout01;
        data_buffer2a  <= #1 dout02;
        data_buffer3a  <= #1 dout03;
        data_buffer4a  <= #1 dout04;
        data_buffer5a  <= #1 dout05;
        data_buffer6a  <= #1 dout06;
        data_buffer7a  <= #1 dout07;
        data_buffer8a  <= #1 dout08;
        data_buffer9a  <= #1 dout09;
        data_buffer10a <= #1 dout10;
        data_buffer11a <= #1 dout11;
        data_buffer12a <= #1 dout12;
        data_buffer13a <= #1 dout13;
        data_buffer14a <= #1 dout14;
        data_buffer15a <= #1 dout15;
        data_buffer16a <= #1 dout16;
        data_buffer17a <= #1 dout17;
        data_buffer18a <= #1 dout18;
        data_buffer19a <= #1 dout19;
        data_buffer20a <= #1 dout20;
        data_buffer21a <= #1 dout21;
        data_buffer22a <= #1 dout22;
        data_buffer23a <= #1 dout23;
        data_buffer24a <= #1 dout24;
        data_buffer25a <= #1 dout25;
        data_buffer26a <= #1 dout26;
        data_buffer27a <= #1 dout27;
        data_buffer28a <= #1 dout28;
        data_buffer29a <= #1 dout29;
        data_buffer30a <= #1 dout30;
        data_buffer31a <= #1 dout31;
        data_buffer32a <= #1 dout32;
        data_buffer33a <= #1 dout33;
        data_buffer34a <= #1 dout34;
        data_buffer35a <= #1 dout35;
        end
end

always @ (posedge clk or negedge reset_n)
begin : data_buffer_br
    if(!reset_n) begin
        data_buffer0b  <= #1 8'h0;
        data_buffer1b  <= #1 8'h0;
        data_buffer2b  <= #1 8'h0;
        data_buffer3b  <= #1 8'h0;
        data_buffer4b  <= #1 8'h0;
        data_buffer5b  <= #1 8'h0;
        data_buffer6b  <= #1 8'h0;
        data_buffer7b  <= #1 8'h0;
        data_buffer8b  <= #1 8'h0;
        data_buffer9b  <= #1 8'h0;
        data_buffer10b <= #1 8'h0;
        data_buffer11b <= #1 8'h0;
        data_buffer12b <= #1 8'h0;
        data_buffer13b <= #1 8'h0;
        data_buffer14b <= #1 8'h0;
        data_buffer15b <= #1 8'h0;
        data_buffer16b <= #1 8'h0;
        data_buffer17b <= #1 8'h0;
        data_buffer18b <= #1 8'h0;
        data_buffer19b <= #1 8'h0;
        data_buffer20b <= #1 8'h0;
        data_buffer21b <= #1 8'h0;
        data_buffer22b <= #1 8'h0;
        data_buffer23b <= #1 8'h0;
        data_buffer24b <= #1 8'h0;
        data_buffer25b <= #1 8'h0;
        data_buffer26b <= #1 8'h0;
        data_buffer27b <= #1 8'h0;
        data_buffer28b <= #1 8'h0;
        data_buffer29b <= #1 8'h0;
        data_buffer30b <= #1 8'h0;
        data_buffer31b <= #1 8'h0;
        data_buffer32b <= #1 8'h0;
        data_buffer33b <= #1 8'h0;
        data_buffer34b <= #1 8'h0;
        data_buffer35b <= #1 8'h0;
        end
    else if(cycle_dly2 == 2'b10) begin
        data_buffer0b  <= #1 dout00;
        data_buffer1b  <= #1 dout01;
        data_buffer2b  <= #1 dout02;
        data_buffer3b  <= #1 dout03;
        data_buffer4b  <= #1 dout04;
        data_buffer5b  <= #1 dout05;
        data_buffer6b  <= #1 dout06;
        data_buffer7b  <= #1 dout07;
        data_buffer8b  <= #1 dout08;
        data_buffer9b  <= #1 dout09;
        data_buffer10b <= #1 dout10;
        data_buffer11b <= #1 dout11;
        data_buffer12b <= #1 dout12;
        data_buffer13b <= #1 dout13;
        data_buffer14b <= #1 dout14;
        data_buffer15b <= #1 dout15;
        data_buffer16b <= #1 dout16;
        data_buffer17b <= #1 dout17;
        data_buffer18b <= #1 dout18;
        data_buffer19b <= #1 dout19;
        data_buffer20b <= #1 dout20;
        data_buffer21b <= #1 dout21;
        data_buffer22b <= #1 dout22;
        data_buffer23b <= #1 dout23;
        data_buffer24b <= #1 dout24;
        data_buffer25b <= #1 dout25;
        data_buffer26b <= #1 dout26;
        data_buffer27b <= #1 dout27;
        data_buffer28b <= #1 dout28;
        data_buffer29b <= #1 dout29;
        data_buffer30b <= #1 dout30;
        data_buffer31b <= #1 dout31;
        data_buffer32b <= #1 dout32;
        data_buffer33b <= #1 dout33;
        data_buffer34b <= #1 dout34;
        data_buffer35b <= #1 dout35;
        end
end

always @ (posedge clk or negedge reset_n)
begin : data_buffer_cr                    
    if(!reset_n) begin                   
        data_buffer0c  <= #1 8'h0;       
        data_buffer1c  <= #1 8'h0;       
        data_buffer2c  <= #1 8'h0;       
        data_buffer3c  <= #1 8'h0;       
        data_buffer4c  <= #1 8'h0;       
        data_buffer5c  <= #1 8'h0;       
        data_buffer6c  <= #1 8'h0;       
        data_buffer7c  <= #1 8'h0;       
        data_buffer8c  <= #1 8'h0;       
        data_buffer9c  <= #1 8'h0;       
        data_buffer10c <= #1 8'h0;       
        data_buffer11c <= #1 8'h0;       
        data_buffer12c <= #1 8'h0;       
        data_buffer13c <= #1 8'h0;       
        data_buffer14c <= #1 8'h0;       
        data_buffer15c <= #1 8'h0;       
        data_buffer16c <= #1 8'h0;       
        data_buffer17c <= #1 8'h0;       
        data_buffer18c <= #1 8'h0;       
        data_buffer19c <= #1 8'h0;       
        data_buffer20c <= #1 8'h0;       
        data_buffer21c <= #1 8'h0;       
        data_buffer22c <= #1 8'h0;       
        data_buffer23c <= #1 8'h0;       
        data_buffer24c <= #1 8'h0;       
        data_buffer25c <= #1 8'h0;       
        data_buffer26c <= #1 8'h0;       
        data_buffer27c <= #1 8'h0;       
        data_buffer28c <= #1 8'h0;       
        data_buffer29c <= #1 8'h0;       
        data_buffer30c <= #1 8'h0;       
        data_buffer31c <= #1 8'h0;       
        data_buffer32c <= #1 8'h0;       
        data_buffer33c <= #1 8'h0;       
        data_buffer34c <= #1 8'h0;       
        data_buffer35c <= #1 8'h0;       
        end                              
    else if(cycle_dly2 == 2'b11) begin    
        data_buffer0c  <= #1 dout00;     
        data_buffer1c  <= #1 dout01;     
        data_buffer2c  <= #1 dout02;     
        data_buffer3c  <= #1 dout03;     
        data_buffer4c  <= #1 dout04;     
        data_buffer5c  <= #1 dout05;     
        data_buffer6c  <= #1 dout06;     
        data_buffer7c  <= #1 dout07;     
        data_buffer8c  <= #1 dout08;     
        data_buffer9c  <= #1 dout09;     
        data_buffer10c <= #1 dout10;     
        data_buffer11c <= #1 dout11;     
        data_buffer12c <= #1 dout12;     
        data_buffer13c <= #1 dout13;     
        data_buffer14c <= #1 dout14;     
        data_buffer15c <= #1 dout15;     
        data_buffer16c <= #1 dout16;     
        data_buffer17c <= #1 dout17;     
        data_buffer18c <= #1 dout18;     
        data_buffer19c <= #1 dout19;     
        data_buffer20c <= #1 dout20;     
        data_buffer21c <= #1 dout21;     
        data_buffer22c <= #1 dout22;     
        data_buffer23c <= #1 dout23;     
        data_buffer24c <= #1 dout24;     
        data_buffer25c <= #1 dout25;     
        data_buffer26c <= #1 dout26;     
        data_buffer27c <= #1 dout27;     
        data_buffer28c <= #1 dout28;     
        data_buffer29c <= #1 dout29;     
        data_buffer30c <= #1 dout30;     
        data_buffer31c <= #1 dout31;     
        data_buffer32c <= #1 dout32;     
        data_buffer33c <= #1 dout33;     
        data_buffer34c <= #1 dout34;     
        data_buffer35c <= #1 dout35;     
        end                              
end    

always @ (posedge clk or negedge reset_n)
begin : dvtc_ar
    if(!reset_n) begin
        dvtc_0a  <= #1 8'h0;
        dvtc_1a  <= #1 8'h0;
        dvtc_2a  <= #1 8'h0;
        dvtc_3a  <= #1 8'h0;
        dvtc_4a  <= #1 8'h0;
        dvtc_5a  <= #1 8'h0;
        dvtc_6a  <= #1 8'h0;
        dvtc_7a  <= #1 8'h0;
        dvtc_8a  <= #1 8'h0;
        dvtc_9a  <= #1 8'h0;
        dvtc_10a <= #1 8'h0;
        dvtc_11a <= #1 8'h0;
        dvtc_12a <= #1 8'h0;
        dvtc_13a <= #1 8'h0;
        dvtc_14a <= #1 8'h0;
        dvtc_15a <= #1 8'h0;
        dvtc_16a <= #1 8'h0;
        dvtc_17a <= #1 8'h0;
        dvtc_18a <= #1 8'h0;
        dvtc_19a <= #1 8'h0;
        dvtc_20a <= #1 8'h0;
        dvtc_21a <= #1 8'h0;
        dvtc_22a <= #1 8'h0;
        dvtc_23a <= #1 8'h0;
        dvtc_24a <= #1 8'h0;
        dvtc_25a <= #1 8'h0;
        dvtc_26a <= #1 8'h0;
        dvtc_27a <= #1 8'h0;
        dvtc_28a <= #1 8'h0;
        dvtc_29a <= #1 8'h0;
        dvtc_30a <= #1 8'h0;
        dvtc_31a <= #1 8'h0;
        dvtc_32a <= #1 8'h0;
        dvtc_33a <= #1 8'h0;
        dvtc_34a <= #1 8'h0;
        dvtc_35a <= #1 8'h0;
        end
    else if(cnu_in[6]) begin
        dvtc_0a  <= #1 data_out0a;
        dvtc_1a  <= #1 data_out1a;
        dvtc_2a  <= #1 data_out2a;
        dvtc_3a  <= #1 data_out3a;
        dvtc_4a  <= #1 data_out4a;
        dvtc_5a  <= #1 data_out5a;
        dvtc_6a  <= #1 data_out6a;
        dvtc_7a  <= #1 data_out7a;
        dvtc_8a  <= #1 data_out8a;
        dvtc_9a  <= #1 data_out9a;
        dvtc_10a <= #1 data_out10a;
        dvtc_11a <= #1 data_out11a;
        dvtc_12a <= #1 data_out12a;
        dvtc_13a <= #1 data_out13a;
        dvtc_14a <= #1 data_out14a;
        dvtc_15a <= #1 data_out15a;
        dvtc_16a <= #1 data_out16a;
        dvtc_17a <= #1 data_out17a;
        dvtc_18a <= #1 data_out18a;
        dvtc_19a <= #1 data_out19a;
        dvtc_20a <= #1 data_out20a;
        dvtc_21a <= #1 data_out21a;
        dvtc_22a <= #1 data_out22a;
        dvtc_23a <= #1 data_out23a;
        dvtc_24a <= #1 data_out24a;
        dvtc_25a <= #1 data_out25a;
        dvtc_26a <= #1 data_out26a;
        dvtc_27a <= #1 data_out27a;
        dvtc_28a <= #1 data_out28a;
        dvtc_29a <= #1 data_out29a;
        dvtc_30a <= #1 data_out30a;
        dvtc_31a <= #1 data_out31a;
        dvtc_32a <= #1 data_out32a;
        dvtc_33a <= #1 data_out33a;
        dvtc_34a <= #1 data_out34a;
        dvtc_35a <= #1 data_out35a;
        end
end

always @ (posedge clk or negedge reset_n)
begin : dvtc_br
    if(!reset_n) begin
        dvtc_0b  <= #1 8'h0;
        dvtc_1b  <= #1 8'h0;
        dvtc_2b  <= #1 8'h0;
        dvtc_3b  <= #1 8'h0;
        dvtc_4b  <= #1 8'h0;
        dvtc_5b  <= #1 8'h0;
        dvtc_6b  <= #1 8'h0;
        dvtc_7b  <= #1 8'h0;
        dvtc_8b  <= #1 8'h0;
        dvtc_9b  <= #1 8'h0;
        dvtc_10b <= #1 8'h0;
        dvtc_11b <= #1 8'h0;
        dvtc_12b <= #1 8'h0;
        dvtc_13b <= #1 8'h0;
        dvtc_14b <= #1 8'h0;
        dvtc_15b <= #1 8'h0;
        dvtc_16b <= #1 8'h0;
        dvtc_17b <= #1 8'h0;
        dvtc_18b <= #1 8'h0;
        dvtc_19b <= #1 8'h0;
        dvtc_20b <= #1 8'h0;
        dvtc_21b <= #1 8'h0;
        dvtc_22b <= #1 8'h0;
        dvtc_23b <= #1 8'h0;
        dvtc_24b <= #1 8'h0;
        dvtc_25b <= #1 8'h0;
        dvtc_26b <= #1 8'h0;
        dvtc_27b <= #1 8'h0;
        dvtc_28b <= #1 8'h0;
        dvtc_29b <= #1 8'h0;
        dvtc_30b <= #1 8'h0;
        dvtc_31b <= #1 8'h0;
        dvtc_32b <= #1 8'h0;
        dvtc_33b <= #1 8'h0;
        dvtc_34b <= #1 8'h0;
        dvtc_35b <= #1 8'h0;
        end
    else if(cnu_in[6]) begin
        dvtc_0b  <= #1 data_out0b;
        dvtc_1b  <= #1 data_out1b;
        dvtc_2b  <= #1 data_out2b;
        dvtc_3b  <= #1 data_out3b;
        dvtc_4b  <= #1 data_out4b;
        dvtc_5b  <= #1 data_out5b;
        dvtc_6b  <= #1 data_out6b;
        dvtc_7b  <= #1 data_out7b;
        dvtc_8b  <= #1 data_out8b;
        dvtc_9b  <= #1 data_out9b;
        dvtc_10b <= #1 data_out10b;
        dvtc_11b <= #1 data_out11b;
        dvtc_12b <= #1 data_out12b;
        dvtc_13b <= #1 data_out13b;
        dvtc_14b <= #1 data_out14b;
        dvtc_15b <= #1 data_out15b;
        dvtc_16b <= #1 data_out16b;
        dvtc_17b <= #1 data_out17b;
        dvtc_18b <= #1 data_out18b;
        dvtc_19b <= #1 data_out19b;
        dvtc_20b <= #1 data_out20b;
        dvtc_21b <= #1 data_out21b;
        dvtc_22b <= #1 data_out22b;
        dvtc_23b <= #1 data_out23b;
        dvtc_24b <= #1 data_out24b;
        dvtc_25b <= #1 data_out25b;
        dvtc_26b <= #1 data_out26b;
        dvtc_27b <= #1 data_out27b;
        dvtc_28b <= #1 data_out28b;
        dvtc_29b <= #1 data_out29b;
        dvtc_30b <= #1 data_out30b;
        dvtc_31b <= #1 data_out31b;
        dvtc_32b <= #1 data_out32b;
        dvtc_33b <= #1 data_out33b;
        dvtc_34b <= #1 data_out34b;
        dvtc_35b <= #1 data_out35b;
        end
end

always @ (posedge clk or negedge reset_n)
begin : dvtc_cr                    
    if(!reset_n) begin                   
        dvtc_0c  <= #1 8'h0;       
        dvtc_1c  <= #1 8'h0;       
        dvtc_2c  <= #1 8'h0;       
        dvtc_3c  <= #1 8'h0;       
        dvtc_4c  <= #1 8'h0;       
        dvtc_5c  <= #1 8'h0;       
        dvtc_6c  <= #1 8'h0;       
        dvtc_7c  <= #1 8'h0;       
        dvtc_8c  <= #1 8'h0;       
        dvtc_9c  <= #1 8'h0;       
        dvtc_10c <= #1 8'h0;       
        dvtc_11c <= #1 8'h0;       
        dvtc_12c <= #1 8'h0;       
        dvtc_13c <= #1 8'h0;       
        dvtc_14c <= #1 8'h0;       
        dvtc_15c <= #1 8'h0;       
        dvtc_16c <= #1 8'h0;       
        dvtc_17c <= #1 8'h0;       
        dvtc_18c <= #1 8'h0;       
        dvtc_19c <= #1 8'h0;       
        dvtc_20c <= #1 8'h0;       
        dvtc_21c <= #1 8'h0;       
        dvtc_22c <= #1 8'h0;       
        dvtc_23c <= #1 8'h0;       
        dvtc_24c <= #1 8'h0;       
        dvtc_25c <= #1 8'h0;       
        dvtc_26c <= #1 8'h0;       
        dvtc_27c <= #1 8'h0;       
        dvtc_28c <= #1 8'h0;       
        dvtc_29c <= #1 8'h0;       
        dvtc_30c <= #1 8'h0;       
        dvtc_31c <= #1 8'h0;       
        dvtc_32c <= #1 8'h0;       
        dvtc_33c <= #1 8'h0;       
        dvtc_34c <= #1 8'h0;       
        dvtc_35c <= #1 8'h0;       
        end                              
    else if(cnu_in[6]) begin    
        dvtc_0c  <= #1 data_out0c;     
        dvtc_1c  <= #1 data_out1c;     
        dvtc_2c  <= #1 data_out2c;     
        dvtc_3c  <= #1 data_out3c;     
        dvtc_4c  <= #1 data_out4c;     
        dvtc_5c  <= #1 data_out5c;     
        dvtc_6c  <= #1 data_out6c;     
        dvtc_7c  <= #1 data_out7c;     
        dvtc_8c  <= #1 data_out8c;     
        dvtc_9c  <= #1 data_out9c;     
        dvtc_10c <= #1 data_out10c;     
        dvtc_11c <= #1 data_out11c;     
        dvtc_12c <= #1 data_out12c;     
        dvtc_13c <= #1 data_out13c;     
        dvtc_14c <= #1 data_out14c;     
        dvtc_15c <= #1 data_out15c;     
        dvtc_16c <= #1 data_out16c;     
        dvtc_17c <= #1 data_out17c;     
        dvtc_18c <= #1 data_out18c;     
        dvtc_19c <= #1 data_out19c;     
        dvtc_20c <= #1 data_out20c;     
        dvtc_21c <= #1 data_out21c;     
        dvtc_22c <= #1 data_out22c;     
        dvtc_23c <= #1 data_out23c;     
        dvtc_24c <= #1 data_out24c;     
        dvtc_25c <= #1 data_out25c;     
        dvtc_26c <= #1 data_out26c;     
        dvtc_27c <= #1 data_out27c;     
        dvtc_28c <= #1 data_out28c;     
        dvtc_29c <= #1 data_out29c;     
        dvtc_30c <= #1 data_out30c;     
        dvtc_31c <= #1 data_out31c;     
        dvtc_32c <= #1 data_out32c;     
        dvtc_33c <= #1 data_out33c;     
        dvtc_34c <= #1 data_out34c;     
        dvtc_35c <= #1 data_out35c;     
        end                              
end    

always @ (*)
begin : cnu_sel_r
   if(!rate) begin
   cnu0_d = { data_buffer0a, data_buffer6a , data_buffer12a, data_buffer18a, data_buffer25a, data_buffer30a };
   cnu1_d = { data_buffer0a, data_buffer7a , data_buffer19a, data_buffer26a, data_buffer31a, data_buffer12b };
   cnu2_d = { data_buffer0a, data_buffer8a , data_buffer13a, data_buffer20a, data_buffer32a, data_buffer26b };
   cnu3_d = { data_buffer1a, data_buffer6b , data_buffer14a, data_buffer21a, data_buffer25b, data_buffer31b };
   cnu4_d = { data_buffer1a, data_buffer15a, data_buffer27a, data_buffer33a, data_buffer20b, data_buffer8b  };
   cnu5_d = { data_buffer1a, data_buffer9a , data_buffer16a, data_buffer34a, data_buffer25c, data_buffer21b };
   cnu6_d = { data_buffer2a, data_buffer6c , data_buffer28a, data_buffer35a, data_buffer16b, data_buffer20c };
   cnu7_d = { data_buffer2a, data_buffer10a, data_buffer17a, data_buffer27b, data_buffer21c, data_buffer30b };
   cnu8_d = { data_buffer2a, data_buffer11a, data_buffer22a, data_buffer22b, data_buffer16c, data_buffer34b };
   cnu9_d = { data_buffer3a, data_buffer7b , data_buffer26c, data_buffer13b, data_buffer33b, data_buffer19b };
   cnua_d = { data_buffer3a, data_buffer9b , data_buffer28b, data_buffer17b, data_buffer31c, data_buffer18b };
   cnub_d = { data_buffer3a, data_buffer23a, data_buffer9c , data_buffer12c, data_buffer35b, data_buffer24a };
   cnuc_d = { data_buffer4a, data_buffer7c , data_buffer29a, data_buffer17c, data_buffer34c, data_buffer18c };
   cnud_d = { data_buffer4a, data_buffer24b, data_buffer10b, data_buffer23b, data_buffer13c, data_buffer32b };
   cnue_d = { data_buffer4a, data_buffer29b, data_buffer10c, data_buffer32c, data_buffer23c, data_buffer15b };
   cnuf_d = { data_buffer5a, data_buffer8c , data_buffer14b, data_buffer22c, data_buffer28c, data_buffer30c };
   cnug_d = { data_buffer5a, data_buffer19c, data_buffer11b, data_buffer15c, data_buffer33c, data_buffer27c };
   cnuh_d = { data_buffer5a, data_buffer24c, data_buffer35c, data_buffer11c, data_buffer14c, data_buffer29c };
   end
   else;
end   

always @ (*)
begin : cnu_data_out_r
   if(!rate) begin
   { data_out0a, data_out6a , data_out12a, data_out18a, data_out25a, data_out30a } = cnu0_q;
   { data_out0b, data_out7a , data_out19a, data_out26a, data_out31a, data_out12b } = cnu1_q;
   { data_out0c, data_out8a , data_out13a, data_out20a, data_out32a, data_out26b } = cnu2_q;
   { data_out1a, data_out6b , data_out14a, data_out21a, data_out25b, data_out31b } = cnu3_q;
   { data_out1b, data_out15a, data_out27a, data_out33a, data_out20b, data_out8b  } = cnu4_q;
   { data_out1c, data_out9a , data_out16a, data_out34a, data_out25c, data_out21b } = cnu5_q;
   { data_out2a, data_out6c , data_out28a, data_out35a, data_out16b, data_out20c } = cnu6_q;
   { data_out2b, data_out10a, data_out17a, data_out27b, data_out21c, data_out30b } = cnu7_q;
   { data_out2c, data_out11a, data_out22a, data_out22b, data_out16c, data_out34b } = cnu8_q;
   { data_out3a, data_out7b , data_out26c, data_out13b, data_out33b, data_out19b } = cnu9_q;
   { data_out3b, data_out9b , data_out28b, data_out17b, data_out31c, data_out18b } = cnua_q;
   { data_out3c, data_out23a, data_out9c , data_out12c, data_out35b, data_out24a } = cnub_q;
   { data_out4a, data_out7c , data_out29a, data_out17c, data_out34c, data_out18c } = cnuc_q;
   { data_out4b, data_out24b, data_out10b, data_out23b, data_out13c, data_out32b } = cnud_q;
   { data_out4c, data_out29b, data_out10c, data_out32c, data_out23c, data_out15b } = cnue_q;
   { data_out5a, data_out8c , data_out14b, data_out22c, data_out28c, data_out30c } = cnuf_q;
   { data_out5b, data_out19c, data_out11b, data_out15c, data_out33c, data_out27c } = cnug_q;
   { data_out5c, data_out24c, data_out35c, data_out11c, data_out14c, data_out29c } = cnuh_q;
   end
   else;
end   

always @ (posedge clk or negedge reset_n)
begin : vtc_en_r
    if(!reset_n) 
        vtc_en <= #1 3'h0;
    else 
        vtc_en <= #1 {vtc_en[1:0],cnu_in[6]};
end

always @ (posedge clk or negedge reset_n)
begin : data_out_r
    if(!reset_n) begin
        data_0 <= #1 {D_WID{1'b0}};
        data_1 <= #1 {D_WID{1'b0}};
        data_2 <= #1 {D_WID{1'b0}};
        data_3 <= #1 {D_WID{1'b0}};
        data_4 <= #1 {D_WID{1'b0}};
        data_5 <= #1 {D_WID{1'b0}};
        data_6 <= #1 {D_WID{1'b0}};
        data_7 <= #1 {D_WID{1'b0}};
        data_8 <= #1 {D_WID{1'b0}};
        end
    else if(cnu_in[5]) begin
        data_0 <= #1 data_out0a;
        data_1 <= #1 data_out1a;
        data_2 <= #1 data_out2a;
        data_3 <= #1 data_out3a;
        data_4 <= #1 data_out4a;
        data_5 <= #1 data_out5a;
        data_6 <= #1 data_out6a;
        data_7 <= #1 data_out7a;
        data_8 <= #1 data_out8a;
        end
end                
        
comp_cell comp0(.clk(clk),.reset_n(reset_n),.iter_0(iter_0),.lq6_in(cnu0_d),.lr_in(vnu0_d),.cnu_in(cnu_in),.lq6_out(cnu0_q),.lr_out(vnu0_q));
comp_cell comp1(.clk(clk),.reset_n(reset_n),.iter_0(iter_0),.lq6_in(cnu1_d),.lr_in(vnu1_d),.cnu_in(cnu_in),.lq6_out(cnu1_q),.lr_out(vnu1_q));
comp_cell comp2(.clk(clk),.reset_n(reset_n),.iter_0(iter_0),.lq6_in(cnu2_d),.lr_in(vnu2_d),.cnu_in(cnu_in),.lq6_out(cnu2_q),.lr_out(vnu2_q));
comp_cell comp3(.clk(clk),.reset_n(reset_n),.iter_0(iter_0),.lq6_in(cnu3_d),.lr_in(vnu3_d),.cnu_in(cnu_in),.lq6_out(cnu3_q),.lr_out(vnu3_q));
comp_cell comp4(.clk(clk),.reset_n(reset_n),.iter_0(iter_0),.lq6_in(cnu4_d),.lr_in(vnu4_d),.cnu_in(cnu_in),.lq6_out(cnu4_q),.lr_out(vnu4_q));
comp_cell comp5(.clk(clk),.reset_n(reset_n),.iter_0(iter_0),.lq6_in(cnu5_d),.lr_in(vnu5_d),.cnu_in(cnu_in),.lq6_out(cnu5_q),.lr_out(vnu5_q));
comp_cell comp6(.clk(clk),.reset_n(reset_n),.iter_0(iter_0),.lq6_in(cnu6_d),.lr_in(vnu6_d),.cnu_in(cnu_in),.lq6_out(cnu6_q),.lr_out(vnu6_q));
comp_cell comp7(.clk(clk),.reset_n(reset_n),.iter_0(iter_0),.lq6_in(cnu7_d),.lr_in(vnu7_d),.cnu_in(cnu_in),.lq6_out(cnu7_q),.lr_out(vnu7_q));
comp_cell comp8(.clk(clk),.reset_n(reset_n),.iter_0(iter_0),.lq6_in(cnu8_d),.lr_in(vnu8_d),.cnu_in(cnu_in),.lq6_out(cnu8_q),.lr_out(vnu8_q));
comp_cell comp9(.clk(clk),.reset_n(reset_n),.iter_0(iter_0),.lq6_in(cnu9_d),.lr_in(vnu9_d),.cnu_in(cnu_in),.lq6_out(cnu9_q),.lr_out(vnu9_q));
comp_cell compa(.clk(clk),.reset_n(reset_n),.iter_0(iter_0),.lq6_in(cnua_d),.lr_in(vnua_d),.cnu_in(cnu_in),.lq6_out(cnua_q),.lr_out(vnua_q));
comp_cell compb(.clk(clk),.reset_n(reset_n),.iter_0(iter_0),.lq6_in(cnub_d),.lr_in(vnub_d),.cnu_in(cnu_in),.lq6_out(cnub_q),.lr_out(vnub_q));
comp_cell compc(.clk(clk),.reset_n(reset_n),.iter_0(iter_0),.lq6_in(cnuc_d),.lr_in(vnuc_d),.cnu_in(cnu_in),.lq6_out(cnuc_q),.lr_out(vnuc_q));
comp_cell compd(.clk(clk),.reset_n(reset_n),.iter_0(iter_0),.lq6_in(cnud_d),.lr_in(vnud_d),.cnu_in(cnu_in),.lq6_out(cnud_q),.lr_out(vnud_q));
comp_cell compe(.clk(clk),.reset_n(reset_n),.iter_0(iter_0),.lq6_in(cnue_d),.lr_in(vnue_d),.cnu_in(cnu_in),.lq6_out(cnue_q),.lr_out(vnue_q));
comp_cell compf(.clk(clk),.reset_n(reset_n),.iter_0(iter_0),.lq6_in(cnuf_d),.lr_in(vnuf_d),.cnu_in(cnu_in),.lq6_out(cnuf_q),.lr_out(vnuf_q));
comp_cell compg(.clk(clk),.reset_n(reset_n),.iter_0(iter_0),.lq6_in(cnug_d),.lr_in(vnug_d),.cnu_in(cnu_in),.lq6_out(cnug_q),.lr_out(vnug_q));
comp_cell comph(.clk(clk),.reset_n(reset_n),.iter_0(iter_0),.lq6_in(cnuh_d),.lr_in(vnuh_d),.cnu_in(cnu_in),.lq6_out(cnuh_q),.lr_out(vnuh_q));

data_cell2 data00(.clk(clk),.reset_n(reset_n),.fsm(fsm),.sin(sync_in[0]),.din(data_in),.vtc_en(vtc_en),.dvtc_a(dvtc_0a ),.dvtc_b(dvtc_0b ),.dvtc_c(dvtc_0c ),.ram_d(din00),.d_last(data_0));
data_cell2 data01(.clk(clk),.reset_n(reset_n),.fsm(fsm),.sin(sync_in[1]),.din(data_in),.vtc_en(vtc_en),.dvtc_a(dvtc_1a ),.dvtc_b(dvtc_1b ),.dvtc_c(dvtc_1c ),.ram_d(din01),.d_last(data_1));
data_cell2 data02(.clk(clk),.reset_n(reset_n),.fsm(fsm),.sin(sync_in[2]),.din(data_in),.vtc_en(vtc_en),.dvtc_a(dvtc_2a ),.dvtc_b(dvtc_2b ),.dvtc_c(dvtc_2c ),.ram_d(din02),.d_last(data_2));
data_cell2 data03(.clk(clk),.reset_n(reset_n),.fsm(fsm),.sin(sync_in[3]),.din(data_in),.vtc_en(vtc_en),.dvtc_a(dvtc_3a ),.dvtc_b(dvtc_3b ),.dvtc_c(dvtc_3c ),.ram_d(din03),.d_last(data_3));
data_cell2 data04(.clk(clk),.reset_n(reset_n),.fsm(fsm),.sin(sync_in[4]),.din(data_in),.vtc_en(vtc_en),.dvtc_a(dvtc_4a ),.dvtc_b(dvtc_4b ),.dvtc_c(dvtc_4c ),.ram_d(din04),.d_last(data_4));
data_cell2 data05(.clk(clk),.reset_n(reset_n),.fsm(fsm),.sin(sync_in[5]),.din(data_in),.vtc_en(vtc_en),.dvtc_a(dvtc_5a ),.dvtc_b(dvtc_5b ),.dvtc_c(dvtc_5c ),.ram_d(din05),.d_last(data_5));
data_cell2 data06(.clk(clk),.reset_n(reset_n),.fsm(fsm),.sin(sync_in[6]),.din(data_in),.vtc_en(vtc_en),.dvtc_a(dvtc_6a ),.dvtc_b(dvtc_6b ),.dvtc_c(dvtc_6c ),.ram_d(din06),.d_last(data_6));
data_cell2 data07(.clk(clk),.reset_n(reset_n),.fsm(fsm),.sin(sync_in[7]),.din(data_in),.vtc_en(vtc_en),.dvtc_a(dvtc_7a ),.dvtc_b(dvtc_7b ),.dvtc_c(dvtc_7c ),.ram_d(din07),.d_last(data_7));
data_cell1 data08(.clk(clk),.reset_n(reset_n),.fsm(fsm),.sin(sync_in[8]),.din(data_in),.vtc_en(vtc_en),.dvtc_a(dvtc_8a ),.dvtc_b(dvtc_8b ),.dvtc_c(dvtc_8c ),.ram_d(din08),.d_last(data_8));
data_cell data09(.clk(clk),.reset_n(reset_n),.fsm(fsm),.sin(sync_in[ 9]),.din(data_in),.vtc_en(vtc_en),.dvtc_a(dvtc_9a ),.dvtc_b(dvtc_9b ),.dvtc_c(dvtc_9c ),.ram_d(din09));
data_cell data10(.clk(clk),.reset_n(reset_n),.fsm(fsm),.sin(sync_in[10]),.din(data_in),.vtc_en(vtc_en),.dvtc_a(dvtc_10a),.dvtc_b(dvtc_10b),.dvtc_c(dvtc_10c),.ram_d(din10));
data_cell data11(.clk(clk),.reset_n(reset_n),.fsm(fsm),.sin(sync_in[11]),.din(data_in),.vtc_en(vtc_en),.dvtc_a(dvtc_11a),.dvtc_b(dvtc_11b),.dvtc_c(dvtc_11c),.ram_d(din11));
data_cell data12(.clk(clk),.reset_n(reset_n),.fsm(fsm),.sin(sync_in[12]),.din(data_in),.vtc_en(vtc_en),.dvtc_a(dvtc_12a),.dvtc_b(dvtc_12b),.dvtc_c(dvtc_12c),.ram_d(din12));
data_cell data13(.clk(clk),.reset_n(reset_n),.fsm(fsm),.sin(sync_in[13]),.din(data_in),.vtc_en(vtc_en),.dvtc_a(dvtc_13a),.dvtc_b(dvtc_13b),.dvtc_c(dvtc_13c),.ram_d(din13));
data_cell data14(.clk(clk),.reset_n(reset_n),.fsm(fsm),.sin(sync_in[14]),.din(data_in),.vtc_en(vtc_en),.dvtc_a(dvtc_14a),.dvtc_b(dvtc_14b),.dvtc_c(dvtc_14c),.ram_d(din14));
data_cell data15(.clk(clk),.reset_n(reset_n),.fsm(fsm),.sin(sync_in[15]),.din(data_in),.vtc_en(vtc_en),.dvtc_a(dvtc_15a),.dvtc_b(dvtc_15b),.dvtc_c(dvtc_15c),.ram_d(din15));
data_cell data16(.clk(clk),.reset_n(reset_n),.fsm(fsm),.sin(sync_in[16]),.din(data_in),.vtc_en(vtc_en),.dvtc_a(dvtc_16a),.dvtc_b(dvtc_16b),.dvtc_c(dvtc_16c),.ram_d(din16));
data_cell data17(.clk(clk),.reset_n(reset_n),.fsm(fsm),.sin(sync_in[17]),.din(data_in),.vtc_en(vtc_en),.dvtc_a(dvtc_17a),.dvtc_b(dvtc_17b),.dvtc_c(dvtc_17c),.ram_d(din17));
data_cell data18(.clk(clk),.reset_n(reset_n),.fsm(fsm),.sin(sync_in[18]),.din(data_in),.vtc_en(vtc_en),.dvtc_a(dvtc_18a),.dvtc_b(dvtc_18b),.dvtc_c(dvtc_18c),.ram_d(din18));
data_cell data19(.clk(clk),.reset_n(reset_n),.fsm(fsm),.sin(sync_in[19]),.din(data_in),.vtc_en(vtc_en),.dvtc_a(dvtc_19a),.dvtc_b(dvtc_19b),.dvtc_c(dvtc_19c),.ram_d(din19));
data_cell data20(.clk(clk),.reset_n(reset_n),.fsm(fsm),.sin(sync_in[20]),.din(data_in),.vtc_en(vtc_en),.dvtc_a(dvtc_20a),.dvtc_b(dvtc_20b),.dvtc_c(dvtc_20c),.ram_d(din20));
data_cell data21(.clk(clk),.reset_n(reset_n),.fsm(fsm),.sin(sync_in[21]),.din(data_in),.vtc_en(vtc_en),.dvtc_a(dvtc_21a),.dvtc_b(dvtc_21b),.dvtc_c(dvtc_21c),.ram_d(din21));
data_cell data22(.clk(clk),.reset_n(reset_n),.fsm(fsm),.sin(sync_in[22]),.din(data_in),.vtc_en(vtc_en),.dvtc_a(dvtc_22a),.dvtc_b(dvtc_22b),.dvtc_c(dvtc_22c),.ram_d(din22));
data_cell data23(.clk(clk),.reset_n(reset_n),.fsm(fsm),.sin(sync_in[23]),.din(data_in),.vtc_en(vtc_en),.dvtc_a(dvtc_23a),.dvtc_b(dvtc_23b),.dvtc_c(dvtc_23c),.ram_d(din23));
data_cell data24(.clk(clk),.reset_n(reset_n),.fsm(fsm),.sin(sync_in[24]),.din(data_in),.vtc_en(vtc_en),.dvtc_a(dvtc_24a),.dvtc_b(dvtc_24b),.dvtc_c(dvtc_24c),.ram_d(din24));
data_cell data25(.clk(clk),.reset_n(reset_n),.fsm(fsm),.sin(sync_in[25]),.din(data_in),.vtc_en(vtc_en),.dvtc_a(dvtc_25a),.dvtc_b(dvtc_25b),.dvtc_c(dvtc_25c),.ram_d(din25));
data_cell data26(.clk(clk),.reset_n(reset_n),.fsm(fsm),.sin(sync_in[26]),.din(data_in),.vtc_en(vtc_en),.dvtc_a(dvtc_26a),.dvtc_b(dvtc_26b),.dvtc_c(dvtc_26c),.ram_d(din26));
data_cell data27(.clk(clk),.reset_n(reset_n),.fsm(fsm),.sin(sync_in[27]),.din(data_in),.vtc_en(vtc_en),.dvtc_a(dvtc_27a),.dvtc_b(dvtc_27b),.dvtc_c(dvtc_27c),.ram_d(din27));
data_cell data28(.clk(clk),.reset_n(reset_n),.fsm(fsm),.sin(sync_in[28]),.din(data_in),.vtc_en(vtc_en),.dvtc_a(dvtc_28a),.dvtc_b(dvtc_28b),.dvtc_c(dvtc_28c),.ram_d(din28));
data_cell data29(.clk(clk),.reset_n(reset_n),.fsm(fsm),.sin(sync_in[29]),.din(data_in),.vtc_en(vtc_en),.dvtc_a(dvtc_29a),.dvtc_b(dvtc_29b),.dvtc_c(dvtc_29c),.ram_d(din29));
data_cell data30(.clk(clk),.reset_n(reset_n),.fsm(fsm),.sin(sync_in[30]),.din(data_in),.vtc_en(vtc_en),.dvtc_a(dvtc_30a),.dvtc_b(dvtc_30b),.dvtc_c(dvtc_30c),.ram_d(din30));
data_cell data31(.clk(clk),.reset_n(reset_n),.fsm(fsm),.sin(sync_in[31]),.din(data_in),.vtc_en(vtc_en),.dvtc_a(dvtc_31a),.dvtc_b(dvtc_31b),.dvtc_c(dvtc_31c),.ram_d(din31));
data_cell data32(.clk(clk),.reset_n(reset_n),.fsm(fsm),.sin(sync_in[32]),.din(data_in),.vtc_en(vtc_en),.dvtc_a(dvtc_32a),.dvtc_b(dvtc_32b),.dvtc_c(dvtc_32c),.ram_d(din32));
data_cell data33(.clk(clk),.reset_n(reset_n),.fsm(fsm),.sin(sync_in[33]),.din(data_in),.vtc_en(vtc_en),.dvtc_a(dvtc_33a),.dvtc_b(dvtc_33b),.dvtc_c(dvtc_33c),.ram_d(din33));
data_cell data34(.clk(clk),.reset_n(reset_n),.fsm(fsm),.sin(sync_in[34]),.din(data_in),.vtc_en(vtc_en),.dvtc_a(dvtc_34a),.dvtc_b(dvtc_34b),.dvtc_c(dvtc_34c),.ram_d(din34));
data_cell data35(.clk(clk),.reset_n(reset_n),.fsm(fsm),.sin(sync_in[35]),.din(data_in),.vtc_en(vtc_en),.dvtc_a(dvtc_35a),.dvtc_b(dvtc_35b),.dvtc_c(dvtc_35c),.ram_d(din35));

endmodule                                       