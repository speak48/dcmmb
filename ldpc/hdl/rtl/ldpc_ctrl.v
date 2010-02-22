//Module
module ldpc_ctrl(
    clk,
    reset_n,
    sync_in,
    rate,
    max_iter,
    ctv_out,

    fsm_state,
    cycle,
    finish,
    busy,
    iter_0,
    num_iter    
);

//Input ports
input                clk        ;
input                reset_n    ;
input                rate       ; // 0, 1/2 1, 3/4
input                sync_in    ;
input   [4:0]        max_iter   ;
input                ctv_out    ;

//Output ports
output  [3:0]        fsm_state  ;
output  [3:0]        cycle      ;
output               finish     ;
output               busy       ;
output  [4:0]        num_iter   ;
output               iter_0     ;

//Paramter
parameter IDLE     = 4'b0001,
          DATA_IN  = 4'b0010,
          CNU      = 4'b0100,
          DATA_OUT = 4'b1000;

//Intenal Reg and Wires Definition
reg     [3:0]        fsm_state  ;
reg                  finish     ;
reg                  busy       ;
reg     [4:0]        num_iter   ;
reg     [3:0]        cycle      ;

reg                  sync_dly   ;
reg                  sync_dly2  ;
reg     [3:0]        next_state ;
reg    [12:0]        counter    ;
reg                  wr_ena     ;

wire                 sync_end   ;
wire                 iter_end   ;
wire                 vnu_end    ;
wire                 sync_out_end;
wire   [12:0]        counter_max;
wire                 rd_ena     ;

assign counter_max = rate ? 'd6911 : 'd4607;
assign sync_end = sync_dly2 & (!sync_dly);
assign iter_end = (num_iter == max_iter); 
assign vnu_end  = (counter == counter_max) & fsm_state[2];
assign sync_out_end = (counter == counter_max) & fsm_state[3];
assign rd_ena = next_state == CNU;
assign iter_0 = ( num_iter == 0);

// sync in delay register
always @ (posedge clk or negedge reset_n)
begin : sync_d1 
    if(!reset_n)
        sync_dly <= #1 1'b0;
    else
        sync_dly <= #1 sync_in;
end

always @ (posedge clk or negedge reset_n)
begin : sync_d2 
    if(!reset_n)
        sync_dly2 <= #1 1'b0;
    else
        sync_dly2 <= #1 sync_dly;
end

// ldpc_busy status
always @ (posedge clk or negedge reset_n)
begin : busy_r
    if(!reset_n)
        busy <= #1 1'b0;
    else if(iter_end)
        busy <= #1 1'b0;
    else if(sync_end)
        busy <= #1 1'b1;    
end     

// FSM
always @ (posedge clk or negedge reset_n)
begin : fsm_state_r
    if(!reset_n)
        fsm_state <= #1 IDLE;
    else 
        fsm_state <= #1 next_state;
end

always @ (*)
begin : fsm_next_state_r
    case(fsm_state)
    IDLE: if(sync_in)
        next_state = DATA_IN;
    DATA_IN: if(sync_end)
        next_state = CNU;
    CNU: if(vnu_end)
             begin
                 if(iter_end)
                     next_state = DATA_OUT;
                 else 
                     next_state = CNU;
          end
     DATA_OUT: if(sync_out_end)
         next_state = IDLE;
     default:
         next_state = IDLE;
     endcase
end 
//(*)
// Cycle 01->10->11
always @ (posedge clk or negedge reset_n)
begin : cycle0_r
    if(!reset_n)
        cycle[3:2] <= #1 2'b0;
    else if((next_state == CNU) & rd_ena ) begin
        if(cycle[3:2] == 2'b11)
        cycle[3:2] <= #1 2'b01;
        else
        cycle[3:2] <= #1 cycle[3:2] + 1'b1;
    end
    else
        cycle[3:2] <= #1 2'b0;
end
        
always @ (posedge clk or negedge reset_n)
begin : cycle1_r
    if(!reset_n)
        cycle[1:0] <= #1 2'b0;
    else if((next_state == CNU) & wr_ena) begin
        if(cycle[1:0] == 2'b11)
        cycle[1:0] <= #1 2'b01;
        else
        cycle[1:0] <= #1 cycle[1:0] + 1'b1;
    end
    else
        cycle[1:0] <= #1 2'b0;
end

// Number of iteration
always @ (posedge clk or negedge reset_n)
begin: num_iter_r
    if(!reset_n)
        num_iter <= #1 5'h0;
    else if(sync_in)
        num_iter <= #1 5'h0;
    else if(vnu_end)
        num_iter <=#1 num_iter + 1'b1;
end

// This section is not implment in the end
//
always @ (posedge clk or negedge reset_n)
begin: counter_r
    if(!reset_n)
        counter <= #1 13'h0;
    else if(fsm_state[2]) begin 
        if(counter == counter_max)   
            counter <= #1 13'h0;
        else if(wr_ena)
            counter <= #1 counter + 1'b1;
    end
    else if(fsm_state[3]) begin
        if(counter == counter_max)
            counter <= #1 13'h0;
        else
            counter <= #1 counter + 1'b1;
    end
end     

always @ (posedge clk or negedge reset_n)
begin : wr_ena_r
    if(!reset_n)
        wr_ena <= #1 1'b0;
    else if(fsm_state[2]) begin
        if(counter == counter_max)
        wr_ena <= #1 1'b0;
        else if(ctv_out)
        wr_ena <= #1 1'b1;
        end
    else
        wr_ena <= #1 1'b0;
end        

endmodule
