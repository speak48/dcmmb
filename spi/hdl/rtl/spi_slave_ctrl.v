////////////////////////////////////////////////////
//module name:spi_slave_ctrl
//file name:  spi_slave_ctrl.v
//version:    1.0
//author:     zxc
//date:       2008.09.05
//function:   spi slave control
///////////////////////////////////////////////////
//revision history

`timescale 1ns/1ns
module spi_slave_ctrl (
                        rstb_i,                 //reset,active if spi works as master
                        clk_i,                  //system clock                          
                        ss_i,                   //selave select
                        sck_i,                  //sck          
                        bit_i,                  //input data
                        lsbf_i,                 //lsbf
                        cpol_i,                 //cpol
                        cpha_i,                 //cpha
                        rx_ready_i,             //receive ready
                        tx_ready_i,             //send ready
                        send_data_i,            //data to send               
                        sdr_empty_i,            //send fifo empty flag
                        rdr_full_i,             //receive fifo full flag
                        stauts_reg_i,           //status reg
                        status_writing_i,       //status reg write singal
                        status_query_cmd_reg_i, //status_query_cmd_reg
                        load_end_o,             //load end signal
                        convey_end_o,           //convey end signal
                        frame_end_o,            //frame end signal
                        rcv_data_o,             //received data
                        bit_o,                  //output data
                        query_cmd_err_o,        //query command error
                        app_cmd_err_clr_o,      //application command error clear
                        rcv_ov_o,               //receive overflow
                        send_ov_o,              //send overflow    
// added for reg access			
	            reg_addr,
                    reg_data_i,
                    reg_data_o,
                    reg_rd,
                    reg_wr,
                    mem_rd_ena,
                    mem_data_out,
                    mem_ena_out
                      );

input rstb_i;
input clk_i;
input ss_i;
input sck_i;
input bit_i;
input lsbf_i;
input cpol_i;
input cpha_i;
input rx_ready_i;
input tx_ready_i;
input [7:0]send_data_i;
input sdr_empty_i;
input rdr_full_i;
input [5:0]stauts_reg_i;
input status_writing_i;
input [7:0]status_query_cmd_reg_i;

output load_end_o;
output convey_end_o;
output frame_end_o;
output [7:0]rcv_data_o;
output bit_o;
output query_cmd_err_o;
output app_cmd_err_clr_o;
output rcv_ov_o;
output send_ov_o;

output  [6:0]     reg_addr;
output  [7:0]     reg_data_i;
output            reg_rd;
output            reg_wr;
input   [7:0]     reg_data_o;

output            mem_rd_ena;
input   [7:0]     mem_data_out;
input             mem_ena_out;


reg [7:0]rcv_data_o;
reg load_end_o;
reg convey_end_o;
reg query_cmd_err_o;
reg app_cmd_err_clr_o;
reg rcv_ov_o;
reg send_ov_o;


//internal signal declaration
wire [1:0]load_massage;
wire [1:0]rx_tx;
wire sck_temp;
wire odd_edge;
wire even_edge;
wire shift_en;
wire sample_en;
wire frame_end_o;

reg [4:0]edge_cnt;
reg [7:0]send_shift_reg;
reg [7:0]rcv_shift_reg;
reg ss_d1;
reg ss_d2;
reg sck_d1;
reg sck_d2;
reg send_ov_temp;


//slave fsm
reg [15:0] slave_state,slave_next_state;

//fsm
parameter p_idle               = 16'h1;
parameter p_rcv_query_cmd	     = 16'h2;
parameter p_load_status        = 16'h4;
parameter p_status_return      = 16'h8;

parameter p_rcv_first_byte     = 16'h10;
parameter p_rcv_next_byte      = 16'h20;
parameter p_rcv_ov             = 16'h40;
parameter p_rcv_convey         = 16'h80;

parameter p_send_dummy_data    = 16'h100;
parameter p_load_data          = 16'h200;
parameter p_send_data          = 16'h400;
parameter p_send_ov            = 16'h800;

parameter p_duplex_dummy_data  = 16'h1000;
parameter p_duplex_load_convey = 16'h2000;
parameter p_duplex_ov          = 16'h4000;
parameter p_duplex             = 16'h8000;


//load_massage
assign load_massage = {cpha_i,lsbf_i};

//rx_tx
assign rx_tx = {rx_ready_i,tx_ready_i};

//-------------------------------------------------------------
//--------------------- slave fsm control ---------------------
//-------------------------------------------------------------
// New FSM for Hongqiao CMMB demodulator DEMO
//
reg     [7:0]   slave_fsm;
reg     [7:0]   slave_fsm_xt;
wire            valid_cmd;
//reg     [6:0]  srd_addr;
reg     [6:0]   swr_addr;
reg     [7:0]   swr_data;
reg             swr_en;
reg             srd_en;
wire    [7:0]   srd_data;
reg     [7:0]   send_shf_reg;
reg             srd_done;
reg             mrd_en;
wire    [7:0]   mrd_data;
wire            mrd_d_en;
reg             mrd_back;
reg   [16:0]    mrd_counter;
reg             mrd_en_counter;
wire            mrd_rst_counter;
reg             last_byte;

reg   [8:0]     block_line;
reg   [7:0]     k_depth  ;
reg   [2:0]     block_size;
reg   [1:0]     rs_mode  ;
wire  [16:0]    mrd_length;

assign reg_addr = swr_addr;
assign reg_data_i = swr_data;
assign reg_wr   = swr_en;
assign reg_rd   = srd_en;
assign srd_data = reg_data_o;
assign mem_rd_ena = mrd_en & !mrd_rst_counter;
assign mrd_data = mem_data_out;
assign mrd_d_en = mem_ena_out;

parameter  FSM_IDLE = 8'h0,
	   FSM_CMD  = 8'h1,
	   FSM_ADDR = 8'h2,
	   FSM_SWR  = 8'h4,
	   FSM_SRD  = 8'h8,
	   FSM_MADDR= 8'h10,
	   FSM_MRD  = 8'h20,
	   FSM_WAIT = 8'h40;
parameter  DUMMY_BYTE = 8'h55;


assign valid_cmd = frame_end_o & (rcv_shift_reg[7:1] == 7'b01_11010 );
wire byte_end = frame_end_o;
wire fsm_addr =  ( slave_fsm == FSM_ADDR ); 
wire fsm_wr_data = ( slave_fsm == FSM_SWR );
wire fsm_rd_data = ( slave_fsm == FSM_SRD );
wire fsm_maddr  = ( slave_fsm == FSM_MADDR );
wire fsm_mrd    = ( slave_fsm == FSM_MRD );
wire load_dummy = ( fsm_addr & byte_end & !rcv_shift_reg[7] ) | ( fsm_maddr & byte_end );
wire load_sdata = ( fsm_rd_data & byte_end );
wire load_mdata = ( fsm_mrd & byte_end );
`ifdef SIM
assign mrd_length = 'd10; 
`else
assign mrd_length = block_line * k_depth ;
`endif
assign mrd_rst_counter = ss_d2 | ( mrd_counter == mrd_length );
//reg  mrd_en_counter = byte_end & mrd_back;

always @ (posedge clk_i or negedge rstb_i)
begin
	if(rstb_i == 1'b0)
		slave_fsm <= FSM_IDLE;
	else
		slave_fsm <= slave_fsm_xt;
end

always @ (*)
begin
    if(ss_d2)
        slave_fsm_xt = FSM_IDLE;
    else begin
	case(slave_fsm)
        FSM_IDLE: begin
            slave_fsm_xt = FSM_CMD;
        end
	FSM_CMD: begin
	    if(valid_cmd & !rcv_shift_reg[0])
	    slave_fsm_xt = FSM_ADDR;
            else if( valid_cmd & rcv_shift_reg[0])
	    slave_fsm_xt = FSM_MADDR;
            else if( byte_end ) 
            slave_fsm_xt = FSM_WAIT;
            else
	    slave_fsm_xt = FSM_CMD;
            end
        FSM_ADDR: begin
	    if(byte_end & rcv_shift_reg[7])
            slave_fsm_xt = FSM_SWR;
            else if(byte_end & !rcv_shift_reg[7])
            slave_fsm_xt = FSM_SRD;
            else
	    slave_fsm_xt = FSM_ADDR;
            end
	FSM_SWR: begin
	    if(byte_end )
	    slave_fsm_xt = FSM_WAIT;
            else
	    slave_fsm_xt = FSM_SWR;
            end
        FSM_SRD: begin
	    if(byte_end & srd_done)
	    slave_fsm_xt = FSM_WAIT;
            else
	    slave_fsm_xt = FSM_SRD;
            end
        FSM_MADDR: begin
	    if(byte_end)
	    slave_fsm_xt = FSM_MRD;
            else
	    slave_fsm_xt = FSM_MADDR;
            end
        FSM_MRD: begin
            if(byte_end & last_byte)
            slave_fsm_xt = FSM_WAIT;
            else
	    slave_fsm_xt = FSM_MRD;
            end    
        FSM_WAIT: begin
	    if(ss_d2)
	    slave_fsm_xt = FSM_IDLE;
            else
            slave_fsm_xt = FSM_WAIT;
            end
        default:
	    slave_fsm_xt = FSM_IDLE;
        endcase
     end
end

always @ (posedge clk_i or negedge rstb_i)
begin
    if(rstb_i == 1'b0)
	 swr_addr <= 7'h0;
    else if(fsm_addr & byte_end)
	 swr_addr <= rcv_shift_reg;
end

always @ (posedge clk_i or negedge rstb_i)
begin
    if(rstb_i == 1'b0)
	 swr_data <= 7'h0;
    else if(fsm_wr_data & byte_end)
	 swr_data <= rcv_shift_reg;
end

always @ (posedge clk_i or negedge rstb_i)
begin
    if(rstb_i == 1'b0)
	 swr_en <= 1'b0;
    else
	 swr_en <= fsm_wr_data & byte_end;
end

always @ (posedge clk_i or negedge rstb_i)
begin
    if(rstb_i == 1'b0)
	 srd_en <= 1'b0;
    else
	 srd_en <= fsm_addr & byte_end & !rcv_shift_reg[7];
end

always @ (posedge clk_i or negedge rstb_i)
begin
    if(rstb_i == 1'b0)
	 srd_done <= 1'b0;
    else if(~fsm_rd_data)
	 srd_done <= 1'b0;
    else if(load_sdata)
	 srd_done <= 1'b1;
end


always @ (posedge clk_i or negedge rstb_i)
begin
    if(rstb_i == 1'b0) begin
	 block_size <= 3'h0;
	 rs_mode <= 2'h0; end
    else if(fsm_maddr & byte_end) begin
	 block_size <= rcv_shift_reg[6:4];
	 rs_mode <= rcv_shift_reg[3:2];
    end
end

always @ (block_size)
   case(block_size)
   3'b001: block_line = 9'd72;
   3'b010: block_line = 9'd144;
   3'b011: block_line = 9'd288;
   3'b101: block_line = 9'd108;
   3'b110: block_line = 9'd216;
   3'b111: block_line = 9'd432;
   3'b000: block_line = 9'd36;
   3'b100: block_line = 9'd54;
   endcase

always @ (rs_mode)
  case(rs_mode)
  2'b00: k_depth = 8'd240;
  2'b01: k_depth = 8'd224;
  2'b10: k_depth = 8'd192;
  2'b11: k_depth = 8'd176;
  endcase

always @ (posedge clk_i or negedge rstb_i)
begin
    if(rstb_i == 1'b0)
	mrd_counter <= 17'h0;
    else if(mrd_rst_counter)
	mrd_counter <= 17'h0;
    else if(mrd_en_counter)
	mrd_counter <= mrd_counter + 1'b1;
end

always @ (posedge clk_i or negedge rstb_i)
begin
    if(rstb_i == 1'b0)
	mrd_en_counter <= 1'b0;
    else if(mrd_rst_counter)
	mrd_en_counter <= 1'b0;
    else 
        mrd_en_counter <= byte_end & mrd_back;
end


always @ (posedge clk_i or negedge rstb_i)
begin
    if(rstb_i == 1'b0)
	 mrd_back <= 1'b0;
    else if(mrd_en_counter | !fsm_mrd)
	 mrd_back <= 1'b0;
    else if(mem_ena_out)
	 mrd_back <= 1'b1;
end

always @ (posedge clk_i or negedge rstb_i)
begin
    if(rstb_i == 1'b0)
	 mrd_en <= 1'b0;
    else 
	 mrd_en <=  ( fsm_maddr & byte_end ) | mrd_en_counter ;
end

always @ (posedge clk_i or negedge rstb_i)
begin
    if(rstb_i == 1'b0)
	 last_byte <= 1'b0;
    else if(~fsm_mrd)
	 last_byte <= 1'b0;
    else if(mrd_rst_counter)
	 last_byte <= 1'b1;
end 

always @ (posedge clk_i or negedge rstb_i)
begin
    if(rstb_i == 1'b0)
         send_shf_reg <= 8'h0;
    else if(load_dummy)
	 send_shf_reg <= DUMMY_BYTE;
    else if(load_sdata)
	 send_shf_reg <= srd_data;
    else if(load_mdata)
	 send_shf_reg <= mrd_data;
    else if( (fsm_rd_data | fsm_mrd ) & shift_en)
      begin
	if(lsbf_i)       
	  send_shf_reg <= {send_shf_reg[0], send_shf_reg[7:1]};
        else
	  send_shf_reg <= {send_shf_reg[6:0], send_shf_reg[7]};
      end
   else ;
end  


//timing logic of fsm
always @(posedge clk_i or negedge rstb_i)
  begin
    if(!rstb_i)
      slave_state <= p_idle;
    else if(ss_d2)
      slave_state <= p_idle;
    else
      slave_state <= slave_next_state;
  end

//combination logic of fsm
always @*
  begin
    case(slave_state)                                                     
                                 
      p_idle:                  begin
                                 if(!ss_d2)
                                   begin
                                     case(rx_tx)	 
                                       2'b00:   slave_next_state = p_rcv_query_cmd; 
                                       2'b01:   slave_next_state = p_send_dummy_data;
                                       2'b10:   slave_next_state = p_rcv_first_byte;
                                       2'b11:   slave_next_state = p_duplex_dummy_data; 
                                       default: slave_next_state = p_idle; 
                                     endcase
                                   end
                                 else
                                   slave_next_state = p_idle;                            
                               end
                               
      p_rcv_query_cmd:         begin
                                 if(frame_end_o)
                                   slave_next_state = p_load_status;
                                 else
                                   slave_next_state = p_rcv_query_cmd;
                               end
                               
      p_load_status:           begin
                                 slave_next_state = p_status_return;
                               end    
                               
      p_status_return:         begin
                                 if(frame_end_o)
                                   slave_next_state = p_load_status;
                                 else
                                   slave_next_state = p_status_return;
                               end                               
  
      p_rcv_first_byte:        begin
                                 if(frame_end_o)
                                   begin
                                     if(rcv_shift_reg == status_query_cmd_reg_i)
                                       slave_next_state = p_load_status;
                                     else if(rdr_full_i)
                                       slave_next_state = p_rcv_ov;
                                     else
                                       slave_next_state = p_rcv_convey;
                                   end 
                                 else
                                   slave_next_state = p_rcv_first_byte;  
                               end  
                          
       p_rcv_next_byte:        begin
                                 if(frame_end_o)
                                   begin
                                     if(rdr_full_i)
                                       slave_next_state = p_rcv_ov;
                                     else
                                       slave_next_state = p_rcv_convey;
                                   end
                                 else
                                   slave_next_state = p_rcv_next_byte;  
                               end
                          
       p_rcv_ov:               begin
                                 slave_next_state = p_rcv_ov;  
                               end
  
       p_rcv_convey:           begin
                                 slave_next_state = p_rcv_next_byte;  
                               end
  
       p_send_dummy_data:      begin
                                 if(frame_end_o)
                                   begin
                                     if(rcv_shift_reg == status_query_cmd_reg_i)
                                       slave_next_state = p_load_status;
                                     else if(sdr_empty_i)
                                       slave_next_state = p_send_ov;
                                     else
                                       slave_next_state = p_load_data; 
                                   end
                                 else
                                   slave_next_state = p_send_dummy_data;
                               end  
    
       p_load_data:            begin
                                 slave_next_state = p_send_data;
                               end  
    
       p_send_data:            begin
                                 if(frame_end_o)
                                   begin
                                     if(sdr_empty_i)
                                       slave_next_state = p_send_ov;
                                     else
                                       slave_next_state = p_load_data;
                                   end
                                 else
                                   slave_next_state = p_send_data;
                               end
  
       p_send_ov:              begin
                                 slave_next_state = p_send_ov;
                               end
                               
       p_duplex_dummy_data:    begin
                                 if(frame_end_o)
                                   begin
                                     if(rcv_shift_reg == status_query_cmd_reg_i)
                                       slave_next_state = p_load_status;
                                     else if(sdr_empty_i || rdr_full_i)
                                       slave_next_state = p_duplex_ov;
                                     else
                                       slave_next_state = p_duplex_load_convey; 
                                   end
                                 else
                                   slave_next_state = p_duplex_dummy_data;
                               end                                     
         
       p_duplex_load_convey:   begin
                                 slave_next_state = p_duplex;
                               end    
                               
       p_duplex:               begin
                                 if(frame_end_o)
                                   begin
                                     if(sdr_empty_i || rdr_full_i)
                                       slave_next_state = p_duplex_ov;
                                     else
                                       slave_next_state = p_duplex_load_convey;
                                   end
                                 else
                                   slave_next_state = p_duplex;
                               end                                      

       p_duplex_ov:            begin
                                 slave_next_state = p_duplex_ov;
                               end
         
      default:                 begin
                                 slave_next_state = p_idle;  
                               end                                  
    
    endcase
  end



//-------------------------------------------------------------
//------------ input signal synchronization sample ------------
//-------------------------------------------------------------	
//ss_d1
always @(negedge clk_i or negedge rstb_i)
	begin
    if(!rstb_i)
      ss_d1 <= 1'b1;
    else
    	ss_d1 <= ss_i;
	end

//ss_d2
always @(negedge clk_i or negedge rstb_i)
	begin
    if(!rstb_i)
      ss_d2 <= 1'b1;
    else
    	ss_d2 <= ss_d1;
	end

//sck_temp
assign sck_temp = rstb_i & (cpol_i ? (~sck_i) : sck_i);

//sck_d1
always @(negedge clk_i or negedge rstb_i)
	begin
    if(!rstb_i)
      sck_d1 <= 1'b0;
    else
    	sck_d1 <= sck_temp;
	end

//sck_d2
always @(negedge clk_i or negedge rstb_i)
	begin
    if(!rstb_i)
      sck_d2 <= 1'b0;
    else
    	sck_d2 <= sck_d1;
	end

//odd_edge
assign odd_edge = sck_d1 & (~sck_d2);

//even_edge
assign even_edge = (~sck_d1) & sck_d2;


//shift_en
assign shift_en = cpha_i ? odd_edge : even_edge;

//sample_en
assign sample_en = cpha_i ? even_edge : odd_edge;


//-------------------------------------------------------------
//---------------- status inqery signal control ---------------
//-------------------------------------------------------------
//edge_cnt 
always @(posedge clk_i or negedge rstb_i)
	begin
    if(!rstb_i) 
      edge_cnt <= 5'h0;
    else if(ss_d2 || (edge_cnt == 5'h10))
      edge_cnt <= 5'h0;
    else if(odd_edge || even_edge)
      edge_cnt <= edge_cnt + 1'b1;
	end

//generate frame_end_o signal
assign frame_end_o = (edge_cnt == 5'h10) ? 1'b1 :1'b0;

//query_cmd_err_o
always @(negedge clk_i or negedge rstb_i)
	begin
    if(!rstb_i) 
      query_cmd_err_o <= 1'b0;
    else if(ss_d2)
      query_cmd_err_o <= 1'b0;
    else if((slave_state == p_rcv_query_cmd) && frame_end_o && (rcv_shift_reg != status_query_cmd_reg_i))
      query_cmd_err_o <= 1'b1;
	end

//query_cmd_err, for avoiding the case that reading and writing the status reg simultaneously.
//always @(posedge clk_i or negedge rstb_i)
//	begin
//    if(!rstb_i) 
//      query_cmd_err <= 1'b0;
//    else
//      query_cmd_err <= query_cmd_err_temp;
//	end


//-------------------------------------------------------------
//--------------------- rcv signal control --------------------
//-------------------------------------------------------------
//receive
always @(posedge clk_i or negedge rstb_i)
  begin
    if(!rstb_i)
      rcv_shift_reg <= 8'b0;  
//    else if(((slave_state == p_rcv_query_cmd) || (slave_state == p_rcv_first_byte) || (slave_state == p_rcv_next_byte) || (slave_state == p_send_dummy_data) || (slave_state == p_duplex_dummy_data) || (slave_state == p_duplex)) && sample_en)
      else if (( slave_fsm == FSM_CMD || slave_fsm == FSM_ADDR || slave_fsm == FSM_SWR || slave_fsm == FSM_MADDR ) && sample_en )
      begin
        if(lsbf_i)
          rcv_shift_reg <= {bit_i,rcv_shift_reg[7:1]};
        else
          rcv_shift_reg <= {rcv_shift_reg[6:0],bit_i};
      end
  end

//convey data from rcv_shift_reg to rcv_fifo
always @(posedge clk_i or negedge rstb_i)
  begin
    if(!rstb_i)
      rcv_data_o <= 8'h0;
    else if((slave_state == p_rcv_convey) || (slave_state == p_duplex_load_convey))
      rcv_data_o <= rcv_shift_reg;
  end	

//generate convey_end_o signal
always @(posedge clk_i or negedge rstb_i)
  begin
    if(!rstb_i) 
      convey_end_o <= 1'b0;
    else if((slave_state == p_rcv_convey) || (slave_state == p_duplex_load_convey))
      convey_end_o <= 1'b1;
    else
      convey_end_o <= 1'b0;
  end
 
//generate app_cmd_err_clr_o signal
always @(posedge clk_i or negedge rstb_i)
  begin
    if(!rstb_i) 
      app_cmd_err_clr_o <= 1'b0;
    else if(frame_end_o && ((slave_state == p_rcv_first_byte) || (slave_state == p_duplex_dummy_data)) && (rcv_shift_reg != status_query_cmd_reg_i))
      app_cmd_err_clr_o <= 1'b1;
    else
      app_cmd_err_clr_o <= 1'b0;
  end 

//generate rcv_ov_o signal
always @(posedge clk_i or negedge rstb_i)
  begin
    if(!rstb_i) 
      rcv_ov_o <= 1'b0;
    else if((slave_state == p_rcv_ov) || ((slave_state == p_duplex_ov) && rdr_full_i))
      rcv_ov_o <= 1'b1;
    else
      rcv_ov_o <= 1'b0;
  end

 
//-------------------------------------------------------------
//-------------------- send signal control --------------------
//-------------------------------------------------------------
//load and send
always @(posedge clk_i or negedge rstb_i)
  begin
    if(!rstb_i) 
      send_shift_reg[7:0] <= 8'b0;
    else if((slave_state == p_load_status) && (!status_writing_i))
      begin
        case(load_massage)
          2'b00,
          2'b11:    send_shift_reg <= {1'b0,stauts_reg_i[5:0],1'b0};
          default:  send_shift_reg <= {2'b00,stauts_reg_i};
        endcase      	  	
      end
    else if((slave_state == p_load_data) || (slave_state == p_duplex_load_convey))
      begin
        case(load_massage)
          2'b00,
          2'b11:    send_shift_reg <= {send_data_i[6:0],send_data_i[7]};
          default:  send_shift_reg <= send_data_i;
        endcase
      end
    else if(((slave_state == p_status_return) || (slave_state == p_send_data) || (slave_state == p_duplex)) && shift_en)
      begin
        if(lsbf_i)
          send_shift_reg <= {send_shift_reg[0],send_shift_reg[7:1]};
        else
          send_shift_reg <= {send_shift_reg[6:0],send_shift_reg[7]};
      end	
  end	


//generate load_end_o signal
always @(posedge clk_i or negedge rstb_i)
  begin
    if(!rstb_i) 
      load_end_o <= 1'b0;
    else if((slave_state == p_load_data) || (slave_state == p_duplex_load_convey))
      load_end_o <= 1'b1;
    else
      load_end_o <= 1'b0;
  end

//generate send_ov_temp signal
always @(posedge clk_i or negedge rstb_i)
  begin
    if(!rstb_i) 
      send_ov_temp <= 1'b0;
    else if((slave_state == p_send_ov) || ((slave_state == p_duplex_ov) && sdr_empty_i))
      send_ov_temp <= 1'b1;
    else
      send_ov_temp <= 1'b0;
  end

//generate send_ov_o signal
always @(posedge clk_i or negedge rstb_i)
  begin
    if(!rstb_i) 
      send_ov_o <= 1'b0;
    else if(edge_cnt == 5'h00)
      send_ov_o <= 1'b0;
    else
      send_ov_o <= send_ov_temp;
  end

//generate bit_o signal
//assign bit_o = send_shift_reg[0];
assign bit_o = send_shf_reg[7];

endmodule
