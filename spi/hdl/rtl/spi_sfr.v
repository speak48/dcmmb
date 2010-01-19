////////////////////////////////////////////////////
//module name:spi_sfr
//file name:  spi_sfr.v
//version:    1.0
//author:     zxc
//date:       2008.06.08
//function:   sfr read and write control
///////////////////////////////////////////////////
//revision history

`timescale 1ns/1ns
module spi_sfr (
                  rstb_general_i,         //general reset
                  rstb_master_i,          //master mode reset
                  rstb_slave_i,           //slave mode reset
                  rst_local_i,            //reset local
                  clk_i,                  //system clock
                  sfr_en_i,               //spi sfr enable
                  sfr_wr_i,               //spi sfr read and write control signal
                  sfr_sel_i,              //spi sfr seclect
                  sfr_wdata_i,            //spi sfr write data
                  rcv_data_i,             //received data
                  load_end_i,             //load end
                  convey_end_i,           //convey end
                  frame_end_i,            //frame end
                  rcv_cnt_i,	            //received data counter
                  query_cmd_err_i,        //query command error
                  app_cmd_err_clr_i,      //application command error clear
                  rcv_ov_i,               //recevie fifo overflow
                  send_ov_i,              //send fifo overflow
                  master_o,               //master slave switch control
                  send_data_o,            //send data
                  sfr_rdata_o,            //sfr read data 
                  opr_mode_o,             //operation mode
                  lsbf_o,                 //lsbf
                  cpol_o,                 //cpol
                  cpha_o,                 //cpha
                  frame_len_o,            //frame len
                  rcv_num_o,              //receive num
                  baud_o,                 //baud rate
                  slave_status_o,         //status_reg_2
                  send_end_o,             //send end
                  rcv_end_o,              //receive end
                  sdr_not_full_o,         //send fifo not full flag
                  sdr_empty_o,            //send fifo empty flag                  
                  rdr_full_o,             //receive fifo full flag
                  rdr_not_empty_o,        //receive fifo not empty flag
                  rx_ready_o,             //recevie ready flag
                  tx_ready_o,             //send ready flag      
                  status_2_writing_o,     //status reg2 writing
                  status_query_cmd_reg_o, //status_query_cmd reg                        
                  spi_int_o               //spi int
             	 );

input rstb_general_i;
input rstb_master_i;
input rstb_slave_i;
input rst_local_i;
input clk_i;
input sfr_en_i;
input sfr_wr_i;
input [7:0]sfr_sel_i;
input [7:0]sfr_wdata_i;
input [7:0]rcv_data_i;
input load_end_i;
input convey_end_i;
input frame_end_i;
input [8:0]rcv_cnt_i;
input query_cmd_err_i;
input app_cmd_err_clr_i;
input rcv_ov_i;
input send_ov_i;

output master_o;
output [7:0]send_data_o;
output [7:0]sfr_rdata_o;
output [1:0]opr_mode_o;
output lsbf_o;
output cpol_o;
output cpha_o;
output [2:0]frame_len_o;
output [8:0]rcv_num_o;
output [7:0]baud_o;
output [5:0]slave_status_o;
output send_end_o;
output rcv_end_o;
output sdr_not_full_o;
output sdr_empty_o;
output rdr_full_o;
output rdr_not_empty_o;
output rx_ready_o;
output tx_ready_o;
output status_2_writing_o;
output [7:0]status_query_cmd_reg_o;
output spi_int_o;

reg [7:0]sfr_rdata_o;
reg [8:0]rcv_num_o;
reg sdr_empty_o;
reg rdr_full_o;
reg spi_int_o;


//internal reg
reg [2:0] ctrl_reg;
reg [6:0] config_reg;
reg [7:0] rcv_len_reg;
reg [7:0] baud_reg;
reg [3:0] status_reg_1;
reg [5:0] status_reg_2;
reg [7:0] send_data_reg;
reg [7:0] rcv_data_reg;
reg [7:0] status_query_cmd_reg;


//internal signal declaration
wire ctrl_reg_read;
wire ctrl_reg_write;
wire config_reg_read;
wire config_reg_write;
wire config_reg_write_en;
wire rcv_len_reg_read;
wire rcv_len_reg_write;
wire rcv_len_reg_write_en;
wire baud_reg_read;
wire baud_reg_write;
wire baud_reg_write_en;
wire status_reg_1_read;
wire status_reg_2_read;
wire status_reg_2_write;
wire send_data_reg_write;
wire rcv_data_reg_read;
wire status_query_cmd_reg_read;
wire status_query_cmd_reg_write;
wire sdr_fifo_full;
wire sdr_fifo_empty;
wire rdr_fifo_full;
wire rdr_fifo_empty;
wire fifo_clr;
wire [7:0]rcv_data_temp;
wire [7:0]sfr_read;

reg send_fifo_write_en;
reg rcv_fifo_read_en;



//----------------signal of ctrl_reg---------------------
assign opr_mode_o = 2'b11;// ctrl_reg[1:0]; ready for data transfer
assign fifo_clr         = ctrl_reg[2];

//---------------signal of config_reg---------------------
assign lsbf_o = 1'b0;    //config_reg[0]; support mode 0 only
assign cpol_o = 1'b0;    //config_reg[1]; 
assign cpha_o = 1'b0;    //config_reg[2];
assign frame_len_o = 3'b111; //config_reg[5:3]; always 8 bit mode
assign master_o = 1'b0;  //config_reg[6]; only slave mode

//-------------signal of rcv_len_reg---------------------    
//rcv_num_o
always @(posedge clk_i or negedge rstb_master_i)
  begin
    if(!rstb_master_i) 
      rcv_num_o <= 9'h100;
    else if(rcv_len_reg == 8'h00)
      rcv_num_o <= 9'h100;
    else
      rcv_num_o <= {1'b0,rcv_len_reg};
  end

//----------------signal of baud_reg----------------------    
assign baud_o          = baud_reg;

//---------------signal of status_reg_1---------------------     
assign send_end_o       = status_reg_1[0];
assign rcv_end_o        = status_reg_1[1];
//assign sdr_not_full_o   = status_reg_1[2];
//assign rdr_not_empty_o  = status_reg_1[3];
assign sdr_not_full_o   = ~sdr_fifo_full;  //for match DMA interface timing
assign rdr_not_empty_o  = ~rdr_fifo_empty; //for match DMA interface timing

//---------------signal of status_reg_2---------------------     
assign rx_ready_o          = 1'b1; //status_reg_2[0];  always ready for transfer
assign tx_ready_o          = 1'b1; //status_reg_2[1];
assign slave_status_o      = status_reg_2;
assign status_2_writing_o  = status_reg_2_write;

//------------signal of status_query_cmd_reg----------------     
assign status_query_cmd_reg_o = status_query_cmd_reg;


//sdr_empty_o
always @(posedge clk_i or negedge rstb_general_i)
	begin	
		if(!rstb_general_i)
			sdr_empty_o <= 1'b1;			
		else
			sdr_empty_o <= sdr_fifo_empty; 
	end	

//rdr_full_o
always @(posedge clk_i or negedge rstb_general_i)
	begin	
		if(!rstb_general_i)
			rdr_full_o <= 1'b0;			
		else
			rdr_full_o <= rdr_fifo_full; 
	end	


//spi_int_o
always @(posedge clk_i or negedge rstb_general_i)
	begin	
		if(!rstb_general_i)
			spi_int_o <= 1'b0;			
		else
		  begin
			  case(ctrl_reg[1:0])
			    2'b01:    spi_int_o <= status_reg_1[2];
			    2'b10:    spi_int_o <= status_reg_1[3];
			    2'b11:    spi_int_o <= status_reg_1[3] | status_reg_1[2];
			    default:  spi_int_o <= 1'b0; 
		    endcase
		  end
	end	
	

//------------------- ctrl_reg write control ------------------
assign ctrl_reg_read = sfr_en_i & (~sfr_wr_i) & (sfr_sel_i == 8'h0);
assign ctrl_reg_write = sfr_en_i & sfr_wr_i & (sfr_sel_i == 8'h0);  

always @(posedge clk_i or negedge rstb_general_i)
	begin	
		if(!rstb_general_i)
			ctrl_reg[1:0] <= 2'b0;			
		else if(ctrl_reg_write)
			ctrl_reg[1:0] <= sfr_wdata_i[1:0]; 
	end	

always @(posedge clk_i or negedge rstb_general_i)
	begin	
		if(!rstb_general_i)
			ctrl_reg[2] <= 1'b0;			
		else if(ctrl_reg_write)
			ctrl_reg[2] <= sfr_wdata_i[2]; 
    else
      ctrl_reg[2] <= 1'b0;	
	end		

//------------------ config_reg write control -----------------
assign config_reg_read = sfr_en_i & (~sfr_wr_i) & (sfr_sel_i == 8'h04);
assign config_reg_write = sfr_en_i & sfr_wr_i & (sfr_sel_i == 8'h04);
assign config_reg_write_en = config_reg_write & (ctrl_reg[1:0] == 2'b0); 	

//config_reg[6]
always @(posedge clk_i or negedge rst_local_i)
	begin
		if(!rst_local_i)
			config_reg[6] <= 1'b1;
		else if(config_reg_write_en)
			config_reg[6] <= sfr_wdata_i[6];	
  end

//config_reg[5:3]
always @(posedge clk_i or negedge rstb_master_i)
	begin
		if(!rstb_master_i)
			config_reg[5:3] <= 3'b0;
		else if(config_reg_write_en)
			config_reg[5:3] <= sfr_wdata_i[5:3];	
	end	

//config_reg[2:0]
always @(posedge clk_i or negedge rst_local_i)
	begin
		if(!rst_local_i)
			config_reg[2:0] <= 3'b0;
		else if(config_reg_write_en)
			config_reg[2:0] <= sfr_wdata_i[2:0];	
	end	


//------------------ rcv_len_reg write control ----------------
assign rcv_len_reg_read = sfr_en_i & (~sfr_wr_i) & (sfr_sel_i == 8'h08);
assign rcv_len_reg_write = sfr_en_i & sfr_wr_i & (sfr_sel_i == 8'h08);
assign rcv_len_reg_write_en = rcv_len_reg_write & (ctrl_reg[1:0] == 2'b0); 	

always @(posedge clk_i or negedge rstb_master_i)
	begin
		if(!rstb_master_i)
			rcv_len_reg <= 8'h0;
		else if(rcv_len_reg_write_en)
			rcv_len_reg <= sfr_wdata_i;				
	end	

//------------------- baud_reg write control ------------------
assign baud_reg_read = sfr_en_i & (~sfr_wr_i) & (sfr_sel_i == 8'h0c);
assign baud_reg_write = sfr_en_i & sfr_wr_i & (sfr_sel_i == 8'h0c);
assign baud_reg_write_en = baud_reg_write & (ctrl_reg[1:0] == 2'b0); 	

always @(posedge clk_i or negedge rstb_master_i)
	begin
		if(!rstb_master_i)
			baud_reg <= 8'h01;
		else if(baud_reg_write_en)
			begin
			  if(sfr_wdata_i[7:0] == 8'h00)
			    baud_reg <= 8'h01;
			  else  
			    baud_reg <= sfr_wdata_i;
		  end		
	end
	
//------------------ status_reg_1 control -----------------
assign status_reg_1_read = sfr_en_i & (~sfr_wr_i) & (sfr_sel_i == 8'h10);

//fifo flag
always @(posedge clk_i or negedge rstb_general_i)
	begin
		if(!rstb_general_i)
			status_reg_1[3:2] <= 2'b01;
		else
		  status_reg_1[3:2] <= {(~rdr_fifo_empty),(~sdr_fifo_full)};
  end	  

//send_end_o
always @(posedge clk_i or negedge rstb_general_i)
	begin
		if(!rstb_general_i)
			status_reg_1[0] <= 1'b0;  
	  else if(send_data_reg_write)
	    status_reg_1[0] <= 1'b0;			
		else if(opr_mode_o == 2'b00)
		  status_reg_1[0] <= 1'b0;				
	  else if(((opr_mode_o == 2'b01) || (opr_mode_o == 2'b11)) && frame_end_i && sdr_fifo_empty)
	    status_reg_1[0] <= 1'b1;
  end
 
//rcv_end_o
always @(posedge clk_i or negedge rstb_master_i)
	begin
    if(!rstb_master_i)
      status_reg_1[1] <= 1'b0;  
    else if(opr_mode_o == 2'b00)
      status_reg_1[1] <= 1'b0;		    
    else if(((opr_mode_o == 2'b10) || (opr_mode_o == 2'b11)) && frame_end_i && (rcv_cnt_i == rcv_num_o - 1'b1))
	    status_reg_1[1] <= 1'b1;
  end


//------------------ status_reg_2 control -----------------
assign status_reg_2_read  = sfr_en_i & (~sfr_wr_i) & (sfr_sel_i == 8'h14);
assign status_reg_2_write = sfr_en_i & sfr_wr_i & (sfr_sel_i == 8'h14);

//rx_ready
always @(posedge clk_i or negedge rstb_slave_i)
	begin
		if(!rstb_slave_i)
			status_reg_2[0] <= 1'b0;
		else if((opr_mode_o == 2'b10) || (opr_mode_o == 2'b11))
		  status_reg_2[0] <= 1'b1;
		else
		  status_reg_2[0] <= 1'b0;
  end	  

//tx_ready
always @(posedge clk_i or negedge rstb_slave_i)
	begin
		if(!rstb_slave_i)
			status_reg_2[1] <= 1'b0;
		else if((opr_mode_o == 2'b01) || (opr_mode_o == 2'b11))
		  status_reg_2[1] <= 1'b1;
		else
		  status_reg_2[1] <= 1'b0;
  end

//query_cmd_err
always @(posedge clk_i or negedge rstb_slave_i)
	begin
		if(!rstb_slave_i)
			status_reg_2[2] <= 1'b0;
		else
		  status_reg_2[2] <= query_cmd_err_i;
  end

//app_cmd_err
always @(posedge clk_i or negedge rstb_slave_i)
	begin
		if(!rstb_slave_i)
			status_reg_2[3] <= 1'b0;
		else if(status_reg_2_write)
		  status_reg_2[3] <= sfr_wdata_i[3];
		else if(app_cmd_err_clr_i)
		  status_reg_2[3] <= 1'b0;
  end

//rcv_ov
always @(posedge clk_i or negedge rstb_slave_i)
	begin
		if(!rstb_slave_i)
			status_reg_2[4] <= 1'b0;
		else if(status_reg_2_write)
		  status_reg_2[4] <= sfr_wdata_i[4];
		else if(rcv_ov_i)
		  status_reg_2[4] <= 1'b1;
  end  

//send_ov
always @(posedge clk_i or negedge rstb_slave_i)
	begin
		if(!rstb_slave_i)
			status_reg_2[5] <= 1'b0;
		else if(status_reg_2_write)
		  status_reg_2[5] <= sfr_wdata_i[5];
		else if(send_ov_i)
		  status_reg_2[5] <= 1'b1;
  end 

	
//---------------- send_data_reg write control ---------------
assign send_data_reg_write = sfr_en_i & sfr_wr_i & (sfr_sel_i == 8'h18);

always @(posedge clk_i or negedge rstb_general_i)
	begin
		if(!rstb_general_i)
		  send_data_reg <= 8'h0;
		else if(send_data_reg_write)
		  send_data_reg <= sfr_wdata_i;		  
	end	

always @(posedge clk_i or negedge rstb_general_i)
	begin
		if(!rstb_general_i)
		  send_fifo_write_en <= 1'b0;
		else if(send_data_reg_write)
		  send_fifo_write_en <= 1'b1;
		else
		  send_fifo_write_en <= 1'b0;
	end	

spi_fifo u_spi_send_fifo(
                                  .rstb_i           (rstb_general_i),
                                  .clk_i            (clk_i),
                                  .read_i           (load_end_i),
                                  .write_i          (send_fifo_write_en),
                                  .fifo_clr_i       (fifo_clr),
                                  .din_i            (send_data_reg),
                                  .dout_o           (send_data_o),
                                  .fifo_full_o      (sdr_fifo_full),
                                  .fifo_empty_o     (sdr_fifo_empty)
                        );


//---------------- rcv_data_reg control ---------------
assign rcv_data_reg_read = sfr_en_i & (~sfr_wr_i) & (sfr_sel_i == 8'h1c);

always @(posedge clk_i or negedge rstb_general_i)
	begin
		if(!rstb_general_i)
		  rcv_fifo_read_en <= 1'b0;
		else if(rcv_data_reg_read)
		  rcv_fifo_read_en <= 1'b1;
		else
		  rcv_fifo_read_en <= 1'b0;
	end	

always @(posedge clk_i or negedge rstb_general_i)
	begin
		if(!rstb_general_i)
		  rcv_data_reg <= 8'b0;
		else
		  rcv_data_reg <= rcv_data_temp;
	end

spi_fifo u_spi_rcv_fifo(
                                  .rstb_i           (rstb_general_i),
                                  .clk_i            (clk_i),
                                  .read_i           (rcv_fifo_read_en),
                                  .write_i          (convey_end_i),
                                  .fifo_clr_i       (fifo_clr),
                                  .din_i            (rcv_data_i),
                                  .dout_o           (rcv_data_temp),
                                  .fifo_full_o      (rdr_fifo_full),
                                  .fifo_empty_o     (rdr_fifo_empty)
                       );


//------------------- status_query_cmd_reg write control ------------------
assign status_query_cmd_reg_read  = sfr_en_i & (~sfr_wr_i) & (sfr_sel_i == 8'h20);
assign status_query_cmd_reg_write = sfr_en_i & sfr_wr_i & (sfr_sel_i == 8'h20);

always @(posedge clk_i or negedge rstb_slave_i)
  begin
    if(!rstb_slave_i)
      status_query_cmd_reg <= 8'h55;
    else if(status_query_cmd_reg_write)
      status_query_cmd_reg <= sfr_wdata_i;
  end
	

//-------------------- reg read control -----------------------
//assign sfr_rdata_o =  ctrl_reg_read       ? {5'b0,ctrl_reg}     : 
//                      config_reg_read     ? {1'b0,config_reg}   :
//                      rcv_len_reg_read    ? rcv_len_reg         :
//                      baud_reg_read       ? baud_reg 	          :  
//                      status_reg_1_read   ? {4'b0,status_reg_1} :
//                      status_reg_2_read   ? {2'b0,status_reg_2} :
//                      rcv_data_reg_read   ? rcv_data_reg        : 8'b0;

assign sfr_read = {ctrl_reg_read,config_reg_read,rcv_len_reg_read,baud_reg_read,status_reg_1_read,status_reg_2_read,rcv_data_reg_read,status_query_cmd_reg_read};

always @*
  begin
  	case(sfr_read)
  	  8'h80:    sfr_rdata_o = {5'b0,ctrl_reg};
  	  8'h40:    sfr_rdata_o = {1'b0,config_reg};
  	  8'h20:    sfr_rdata_o = rcv_len_reg;
  	  8'h10:    sfr_rdata_o = baud_reg;
  	  8'h08:    sfr_rdata_o = {4'b0,status_reg_1};
  	  8'h04:    sfr_rdata_o = {2'b0,status_reg_2};
  	  8'h02:    sfr_rdata_o = rcv_data_reg;
  	  8'h01:    sfr_rdata_o = status_query_cmd_reg;
  	  default:  sfr_rdata_o = 8'b0;
    endcase
  end

	
endmodule
