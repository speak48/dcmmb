////////////////////////////////////////////////////
//module name:spi_master_ctrl
//file name:  spi_master_ctrl.v
//version:    1.0
//author:     zxc
//date:       2008.06.10
//function:   spi master control
///////////////////////////////////////////////////
//revision history
//date:       2008.09.08
//by:         zxc
//modified record:
//  1.convey_en signal
//  2.module name and file name
///////////////////////////////////////////////////


`timescale 1ns/1ns
module spi_master_ctrl (
                        rstb_i,             //reset
                        clk_i,              //system clock
                        bit_i,              //input data
                        lsbf_i,             //lsbf
                        cpol_i,             //cpol
                        cpha_i,             //cpha
                        opr_mode_i,         //operation mode
                        frame_len_i,        //frame length
                        rcv_num_i,          //receive number
                        send_data_i,        //data to send
                        baud_i,             //baud rate
                        send_end_i,         //send end flag
                        rcv_end_i,          //receive end flag                    
                        sdr_empty_i,        //send fifo empty flag
                        rdr_full_i,         //receive fifo full flag                           
                        load_end_o,         //load end signal
                        convey_end_o,       //convey end signal
                        frame_end_o,        //frame end flag
                        rcv_data_o,         //received data
                        rcv_cnt_o,          //rcv data cnt
                        ss_o,               //selave select
                        sck_o,              //sck
                        bit_o               //output data
                      );

input rstb_i;
input clk_i;
input bit_i;
input lsbf_i;
input cpol_i;
input cpha_i;
input [1:0]opr_mode_i;
input [2:0]frame_len_i;
input [8:0]rcv_num_i;
input [7:0]send_data_i;
input [7:0]baud_i;
input send_end_i;
input rcv_end_i;
input sdr_empty_i;
input rdr_full_i;

output load_end_o;
output convey_end_o;
output frame_end_o;
output [7:0]rcv_data_o;
output [8:0]rcv_cnt_o;
output ss_o;
output sck_o;
output bit_o;

reg [7:0]rcv_data_o;
reg load_end_o;
reg convey_end_o;
reg ss_o;


//internal signal declaration
wire send_en;
wire rcv_en;
wire load_en;
wire convey_en;
wire shift_en;
wire sample_en;
wire edge_cnt_pre;
wire [4:0]load_massage;
reg [8:0]baud_cnt;
reg [4:0]edge_cnt;
reg [8:0]rcv_cnt_o;
reg [7:0]send_shift_reg;
reg [7:0]rcv_shift_reg;
reg baud_cnt_en;
reg sck_o_tmp;
reg odd_edge;
reg even_edge;

//shift fsm
reg [2:0] ss_state,ss_next_state;
reg [3:0] rs_state,rs_next_state;

//send shift fsm
parameter p_ss_idle     = 3'h1;
parameter p_ss_load     = 3'h2;
parameter p_ss_send	    = 3'h4;

//rcv shift fsm
parameter p_rs_idle     = 4'h1;
parameter p_rs_rcv      = 4'h2;
parameter p_rs_ov       = 4'h4;
parameter p_rs_convey   = 4'h8;




//send and rcv enable decode
assign send_en      = ((opr_mode_i == 2'b01) || (opr_mode_i == 2'b11)) ? 1'b1 : 1'b0;
assign rcv_en       = ((opr_mode_i == 2'b10) || (opr_mode_i == 2'b11)) ? 1'b1 : 1'b0;

//load_massage
assign load_massage =  {cpha_i,lsbf_i,frame_len_i};


//-------------------------------------------------------------
//------------------ send shift fsm control -------------------
//-------------------------------------------------------------
always @(posedge clk_i or negedge rstb_i)
  begin
    if(!rstb_i)
      ss_state <= p_ss_idle;
    else if(!send_en)
      ss_state <= p_ss_idle;
    else
      ss_state <= ss_next_state;
  end
  
//always @(ss_state or load_en or send_end_i)
always @*
begin
  case(ss_state)                                                     
                               
    p_ss_idle:          begin
                          if(load_en)
                            ss_next_state = p_ss_load;                          
                          else
                            ss_next_state = p_ss_idle;
                        end
                        
    p_ss_load:          begin
                          ss_next_state = p_ss_send;
                        end                               
                        
    p_ss_send:          begin
                          if(send_end_i)
                            ss_next_state = p_ss_idle; 
                          else if(load_en)
                            ss_next_state = p_ss_load;
                          else
                            ss_next_state = p_ss_send;
                        end                               
       
    default:            begin
                          ss_next_state = p_ss_idle;                                                 
                        end
  endcase                                                                                                                                                                  
end


//-------------------------------------------------------------
//------------------ rcv shift fsm control --------------------
//-------------------------------------------------------------
always @(posedge clk_i or negedge rstb_i)
  begin
    if(!rstb_i)
      rs_state <= p_rs_idle;
    else if(!rcv_en)
      rs_state <= p_rs_idle;
    else
      rs_state <= rs_next_state;
  end
  
//always @(rs_state or rcv_en or convey_en or rdr_full_i or rcv_end_i or rcv_cnt_o or rcv_num_i)
always @*
begin
  case(rs_state)                                                     
                               
    p_rs_idle:          begin
                          if(rcv_en && (!rcv_end_i))
                            rs_next_state = p_rs_rcv;                          
                          else
                            rs_next_state = p_rs_idle;
                        end
                        
    p_rs_rcv:           begin
                          if(convey_en)
                            begin
                              if(rdr_full_i)
                                rs_next_state = p_rs_ov;
                              else
                                rs_next_state = p_rs_convey;
                            end
                          else
                            rs_next_state = p_rs_rcv;
                        end

    p_rs_ov:            begin
                         if(rdr_full_i)
                           rs_next_state = p_rs_ov;
                         else
                           rs_next_state = p_rs_convey;
                        end    
                        
    p_rs_convey:        begin
                          if(rcv_cnt_o == rcv_num_i)
                            rs_next_state = p_rs_idle;
                          else
                            rs_next_state = p_rs_rcv;
                        end                               
       
    default:           begin
                         rs_next_state = p_rs_idle;  
                       end                                  
  endcase                                                                                                                                                                  
end


 
//-------------------------------------------------------------
//-------------------- send signal control --------------------
//-------------------------------------------------------------
//load_en
assign load_en = ((ss_state == p_ss_idle) | frame_end_o) & send_en & (~sdr_empty_i);


//load and send
always @(posedge clk_i or negedge rstb_i)
  begin
    if(!rstb_i) 
      send_shift_reg[7:0] <= 8'b0;
    else if(ss_state == p_ss_load)
      begin
        case(load_massage)
          //cpha_i=0,lsbf_i=0
          5'b00000,
          5'b00001,
          5'b00010,
          5'b00111:    send_shift_reg <= {send_data_i[6:0],send_data_i[7]};
          5'b00011:    send_shift_reg <= {send_data_i[2:0],4'b0,send_data_i[3]};
          5'b00100:    send_shift_reg <= {send_data_i[3:0],3'b0,send_data_i[4]};
          5'b00101:    send_shift_reg <= {send_data_i[4:0],2'b0,send_data_i[5]};
          5'b00110:    send_shift_reg <= {send_data_i[5:0],1'b0,send_data_i[6]};
          
          //cpha_i=1,lsbf_i=0   
          5'b10011:    send_shift_reg[7:4] <= send_data_i[3:0];
          5'b10100:    send_shift_reg[7:3] <= send_data_i[4:0];
          5'b10101:    send_shift_reg[7:2] <= send_data_i[5:0];
          5'b10110:    send_shift_reg[7:1] <= send_data_i[6:0];
          
          //cpha_i=1,lsbf_i=1
          5'b11000,
          5'b11001,
          5'b11010,
          5'b11111:    send_shift_reg <= {send_data_i[6:0],send_data_i[7]};
          5'b11011:    send_shift_reg[4:1] <= send_data_i[3:0];
          5'b11100:    send_shift_reg[5:1] <= send_data_i[4:0];
          5'b11101:    send_shift_reg[6:1] <= send_data_i[5:0];
          5'b11110:    send_shift_reg[7:1] <= send_data_i[6:0];
          
          //cpha_i=0,lsbf_i=1, and for some case of cpha_i=1,lsbf_i=0
          default:     send_shift_reg <= send_data_i;
        endcase
      end
    else if((ss_state == p_ss_send) && shift_en)
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
    else if(ss_state == p_ss_load)
      load_end_o <= 1'b1;
    else
      load_end_o <= 1'b0;
  end

//generate bit_o signal
assign bit_o = send_shift_reg[0];


//-------------------------------------------------------------
//--------------------- rcv signal control --------------------
//-------------------------------------------------------------
//convey_en
//assign convey_en = frame_end_o & (~rcv_end_i);      //modified at 080904, for correct the problem of switching from sending to revieving
assign convey_en = rcv_en & frame_end_o & (~rcv_end_i);

//receive
always @(posedge clk_i or negedge rstb_i)
  begin
    if(!rstb_i)
      rcv_shift_reg <= 8'b0;  
    else if((rs_state == p_rs_rcv) && sample_en)
      begin
        if(lsbf_i)
          rcv_shift_reg <= {bit_i,rcv_shift_reg[7:1]};
        else
          rcv_shift_reg <= {rcv_shift_reg[6:0],bit_i};
      end
  end	


//rcv_cnt_o
always @(posedge clk_i or negedge rstb_i)
  begin
    if(!rstb_i)
      rcv_cnt_o <= 9'h0;
    else if((rcv_cnt_o == rcv_num_i) && (!rcv_end_i))
      rcv_cnt_o <= 9'h0;
    else if(convey_en)
      rcv_cnt_o <= rcv_cnt_o + 1'b1;
  end


//convey data from rcv_shift_reg to rcv_fifo
always @(posedge clk_i or negedge rstb_i)
  begin
    if(!rstb_i)
      rcv_data_o <= 8'h0;
    else if(rs_state == p_rs_convey)
      begin
        case(frame_len_i)
          3'b011:  begin
                      if(lsbf_i)
                        rcv_data_o <= {4'b0,rcv_shift_reg[7:4]};
                      else
                        rcv_data_o <= {4'b0,rcv_shift_reg[3:0]};
                    end	   
                    
          3'b100:  begin
                      if(lsbf_i)
                        rcv_data_o <= {3'b0,rcv_shift_reg[7:3]};
                      else
                        rcv_data_o <= {3'b0,rcv_shift_reg[4:0]};
                    end	                      
                    
          3'b101:  begin
                      if(lsbf_i)
                        rcv_data_o <= {2'b0,rcv_shift_reg[7:2]};
                      else
                        rcv_data_o <= {2'b0,rcv_shift_reg[5:0]};
                    end	                         
                    
          3'b110:  begin
                      if(lsbf_i)
                        rcv_data_o <= {1'b0,rcv_shift_reg[7:1]};
                      else
                        rcv_data_o <= {1'b0,rcv_shift_reg[6:0]};
                   end

          default:  begin
                      rcv_data_o <= rcv_shift_reg;
                    end                    
        endcase
      end	
  end	

//generate convey_end_o signal
always @(posedge clk_i or negedge rstb_i)
  begin
    if(!rstb_i) 
      convey_end_o <= 1'b0;
    else if(rs_state == p_rs_convey)
      convey_end_o <= 1'b1;
    else
      convey_end_o <= 1'b0;
  end


//-------------------------------------------------------------
//-------------------- baud signal control --------------------
//-------------------------------------------------------------	
//edge_cnt_pre
assign	edge_cnt_pre = (frame_len_i == 3'b011) ? (edge_cnt == 5'h07) : 
                       (frame_len_i == 3'b100) ? (edge_cnt == 5'h09) : 
                       (frame_len_i == 3'b101) ? (edge_cnt == 5'h0b) : 
                       (frame_len_i == 3'b110) ? (edge_cnt == 5'h0d) : (edge_cnt == 5'h0f);

//edge_cnt 
always @(posedge clk_i or negedge rstb_i)
	begin
    if(!rstb_i) 
      edge_cnt <= 5'h0;
    else if(!baud_cnt_en)
      edge_cnt <= 5'h0;
    else if((baud_cnt[7:0] == baud_i) || (baud_cnt[8:1] == baud_i))
      edge_cnt <= edge_cnt + 1'b1;
	end

//baud_cnt_en
always @(posedge clk_i or negedge rstb_i)
	begin
    if(!rstb_i) 
      baud_cnt_en <= 1'b0;
    else
      begin
        case(opr_mode_i)
          2'b00:    begin
                      baud_cnt_en <= 1'b0;                      
                    end

          2'b01:    begin
                      if(ss_state == p_ss_load)
                        baud_cnt_en <= 1'b1;
                      else if(frame_end_o)
                        baud_cnt_en <= 1'b0;                      
                    end
                    
          2'b10:    begin
                      if(frame_end_o)
                        baud_cnt_en <= 1'b0;
                      else if((rs_state != p_rs_idle) && (!rcv_end_i) && (rs_state != p_rs_ov))
                        baud_cnt_en <= 1'b1;                    
                    end
                    
          2'b11:    begin
                      if(frame_end_o)
                        baud_cnt_en <= 1'b0;
                      else if((ss_state == p_ss_send) && (!send_end_i) && (rs_state != p_rs_convey) && (rs_state != p_rs_ov))
                        baud_cnt_en <= 1'b1;                   
                    end
                    
          default:  begin
                      baud_cnt_en <= 1'b0;
                    end                       
        endcase
      end
	end

//baud_cnt
always @(posedge clk_i or negedge rstb_i)
	begin
    if(!rstb_i) 
      baud_cnt <= 9'h1;
    else if(baud_cnt_en)
    	begin
        if(baud_cnt[8:1] == baud_i)
          baud_cnt <= 9'h1;
        else
          baud_cnt <= baud_cnt + 1'b1;
    	end      
    else
      baud_cnt <= 9'h1;
	end


//generate frame_end_o signal
//assign frame_end_o = (edge_cnt_pre && (baud_cnt[8:1] == baud_i)) ? 1'b1 : 1'b0;
assign frame_end_o = edge_cnt_pre & (baud_cnt[8:1] == baud_i);


//sck_o_tmp
always @(posedge clk_i or negedge rstb_i)
	begin
    if(!rstb_i)
      sck_o_tmp <= 1'b0;
    else if(!baud_cnt_en)
    	sck_o_tmp <= 1'b0;
    else if((baud_cnt[7:0] == baud_i) || (baud_cnt[8:1] == baud_i))
    	sck_o_tmp <= ~sck_o_tmp;
	end


//odd_edge
always @(negedge clk_i or negedge rstb_i)
	begin
    if(!rstb_i) 
      odd_edge <= 1'b0;
    else if(!(send_en || rcv_en))
      odd_edge <= 1'b0;
    else if((baud_cnt_en) && (baud_cnt[7:0] == baud_i))
      odd_edge <= 1'b1;
    else
      odd_edge <= 1'b0;
	end

//even_edge
always @(negedge clk_i or negedge rstb_i)
	begin
    if(!rstb_i) 
      even_edge <= 1'b0;
    else if(!(send_en || rcv_en))
      even_edge <= 1'b0;
    else if(baud_cnt[8:1] == baud_i)
      even_edge <= 1'b1;
    else
      even_edge <= 1'b0;
	end


//shift_en
assign shift_en = cpha_i ? odd_edge : even_edge;

//sample_en
assign sample_en = cpha_i ? even_edge : odd_edge;

//sck_o
assign sck_o = cpol_i ? (~sck_o_tmp) : sck_o_tmp;

//ss_o
always @(posedge clk_i or negedge rstb_i)
	begin
    if(!rstb_i) 
      ss_o <= 1'b1;
    else if(send_en || rcv_en)
      ss_o <= 1'b0;
    else
      ss_o <= 1'b1;
	end


endmodule