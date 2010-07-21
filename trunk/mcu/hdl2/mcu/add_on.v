module add_on(
              //ram interface
              sys_clk   ,
              sys_rst   ,
              r80515_reset,
              prog_mode ,
              rab_write ,
              rab_read  ,
              rab_addr  ,
              rab_wdata ,
              rab_ack   ,
              memaddr   ,
              memdatai  ,
              prog_ram_rdata_0,
              prog_ram_rdata_1,
              prog_ram_rdata_2,
              prog_ram_rdata_3,
              prog_ram_write_0,
              prog_ram_write_1,
              prog_ram_write_2,
              prog_ram_write_3,
              prog_ram_read_0 ,
              prog_ram_read_1 ,
              prog_ram_read_2 ,
              prog_ram_read_3 ,
              //
              rab_rdata ,
              ramaddr_o ,
              ram_wdata ,
              //mux 
              romdata   ,
              ram_mode  ,
              mux_data  ,
              mempswr   ,
              mempsrd   ,
              mempsrd_d
       );

input         sys_clk  ;
input         sys_rst  ;
input         r80515_reset;
input         prog_mode;  //0: sequential write; 1:sequential read

//i2c slave interface
input         rab_write;
input         rab_read ;
input   [8:0] rab_addr ;
input   [7:0] rab_wdata;
output  [7:0] rab_rdata;
output        rab_ack  ;

//ram interface
input [15:0]   memaddr         ;
input  [7:0]   memdatai        ;
input  [7:0]   prog_ram_rdata_0;
input  [7:0]   prog_ram_rdata_1;
input  [7:0]   prog_ram_rdata_2;
input  [7:0]   prog_ram_rdata_3;
output         prog_ram_write_0;
output         prog_ram_write_1;
output         prog_ram_write_2;
output         prog_ram_write_3;
output         prog_ram_read_0 ;
output         prog_ram_read_1 ;
output         prog_ram_read_2 ;
output         prog_ram_read_3 ;

output  [15:0]ramaddr_o ;
output  [7:0] ram_wdata; 

//mux for program rom/ram
input  [7:0]   romdata ;  //output from rom
input          ram_mode;  //1: select ram; 0:select rom

output [7:0]   mux_data;    

//mempsrd and mempswr
input          mempswr  ;
input          mempsrd  ;
output         mempsrd_d; 
reg            mempsrd_d;   

reg     [7:0] prog_addr_h;
reg     [7:0] prog_addr_l;
reg     [7:0] prog_data  ;

reg           prog_ram_rd;
reg           prog_ram_rd_d ;
//reg           prog_ram_rd_d1;
reg           prog_ram_wr;
reg    [15:0] ramaddr    ;
reg    [15:0] ramaddr_t  ;

//
reg     [7:0] ram_rdata  ; 
reg           prog_ram_write_0;
reg           prog_ram_write_1;
reg           prog_ram_write_2;
reg           prog_ram_write_3;
reg           prog_ram_read_0 ;
reg           prog_ram_read_1 ;
reg           prog_ram_read_2 ;
reg           prog_ram_read_3 ;
reg     [7:0] rab_rdata  ;
reg           rab_ack    ;

reg           wr_1st_flag;


wire    [7:0] ram_wdata  ;
wire   [15:0] ramaddr_o  ;

assign        ramaddr_o = r80515_reset ? ramaddr : memaddr;

///////////// data //////////////////
assign        mux_data  = ram_mode ? (mempsrd_d ? ram_rdata : memdatai) : romdata;
assign        ram_wdata = prog_data;

//register for store data
always @(posedge sys_clk or posedge sys_rst) begin
  if(sys_rst) begin
    prog_data   <= 8'h00;
  end
  else if(prog_mode) begin //sequential read
    if(prog_ram_rd_d) begin //because ram_rdata ready 1 cycle after prog_ram_rd 
      prog_data <= ram_rdata; 
    end
  end
  else begin //sequential write
    if((rab_addr == 9'h1c) && rab_write) begin  
      prog_data <= rab_wdata; 
    end
  end
end

always @(posedge sys_clk or posedge sys_rst) begin
  if(sys_rst)
    rab_rdata <= 8'h00;
  else if((rab_addr == 9'h1a) && rab_read)
    rab_rdata <= prog_addr_h;
  else if((rab_addr == 9'h1b) && rab_read)
    rab_rdata <= prog_addr_l;
  else if((rab_addr == 9'h1c) && rab_read)
    rab_rdata <= prog_data  ;
end

////////////// ack ///////////////
always @(posedge sys_clk or posedge sys_rst) begin
  if(sys_rst)
    rab_ack <= 1'b0;
  else if(rab_read||rab_write)
    case (rab_addr)
      9'h1a: rab_ack <= 1'b1;
      9'h1b: rab_ack <= 1'b1;
      9'h1c: rab_ack <= 1'b1;
      default: rab_ack <= 1'b0;
    endcase
  else
    rab_ack <= 1'b0;
end


////////////// wr/rd /////////////
always @(posedge sys_clk or posedge sys_rst) begin
  if(sys_rst) 
    prog_ram_wr <= 1'b0;
  else if(!prog_mode)  //sequential write
    prog_ram_wr <= rab_write;   
  else
    prog_ram_wr <= 1'b0;
end

always @(posedge sys_clk or posedge sys_rst) begin
  if(sys_rst) 
    prog_ram_rd <= 1'b0;
  else if((rab_addr == 9'h1b) && rab_write && prog_mode)
    prog_ram_rd <= 1'b1;
  else if((rab_addr == 9'h1c) && rab_read  && prog_mode)
    prog_ram_rd <= 1'b1;
  else
    prog_ram_rd <= 1'b0;
end
  


//generate a signal for 1 clock cycle delay of prog_ram_rd
always @(posedge sys_clk or posedge sys_rst) begin
  if(sys_rst) begin
    prog_ram_rd_d <= 1'b0;
    //prog_ram_rd_d1<= 1'b0;
  end
  else begin
    prog_ram_rd_d <= prog_ram_rd;
    //prog_ram_rd_d1<= prog_ram_rd_d;  
  end
end

/////////////// addr ///////////////
always @(posedge sys_clk or posedge sys_rst) begin
  if(sys_rst) begin
    prog_addr_h <= 8'h00;
    prog_addr_l <= 8'h00;       
  end
  else //sequential read/write
    if((rab_addr == 9'h1a) && rab_write)
      prog_addr_h <= rab_wdata;
    else if((rab_addr == 9'h1b) && rab_write)
      prog_addr_l <= rab_wdata;
end



//ramaddr for storing ram address; always get ready before write/read
always @(posedge sys_clk or posedge sys_rst) begin
  if(sys_rst) 
    ramaddr <= 16'h0000;
  //else if(prog_ram_rd_t3) //read 1st ram data after finish set prog_addr_l
  else if((rab_addr == 9'h1b) && rab_write && prog_mode)
    ramaddr <= {prog_addr_h,prog_addr_l};
  else if((rab_addr == 9'h1c) && rab_write && wr_1st_flag)   //addr of write 1st data
    ramaddr <= {prog_addr_h,prog_addr_l};
  else if(rab_addr == 9'h1c)   //write/read the rest data, address auto add 1
    ramaddr <= ramaddr + 1;  
//  else if(!r80515_reset)
//    ramaddr <= memaddr;
end

always @(posedge sys_clk or posedge sys_rst) begin
  if(sys_rst) 
    wr_1st_flag <= 1'b0;
  else if(!prog_mode && (rab_addr == 9'h1b) && rab_write) //write data mode
    wr_1st_flag <= 1'b1;
  else if(!prog_mode && (rab_addr == 9'h1c) && rab_write)
    wr_1st_flag <= 1'b0;
end
    


//////////// 4 ram select //////////////
always @(*) begin
  if(ramaddr_o[15:12]==4'b0000)
    ram_rdata = prog_ram_rdata_0;
  else if(ramaddr_o[15:12]==4'b0001)
    ram_rdata = prog_ram_rdata_1;
  else if(ramaddr_o[15:12]==4'b0010)
    ram_rdata = prog_ram_rdata_2;
  else if(ramaddr_o[15:12]==4'b0011)
    ram_rdata = prog_ram_rdata_3;
  else
    ram_rdata = 8'h00;
end

always @(*) begin
  if(ramaddr_o[15:12]==4'b0000) begin
    prog_ram_write_0 = r80515_reset ? prog_ram_wr : mempswr;
    prog_ram_read_0  = r80515_reset ? prog_ram_rd : mempsrd;
    prog_ram_write_1 = 1'b0;
    prog_ram_read_1  = 1'b0;
    prog_ram_write_2 = 1'b0;
    prog_ram_read_2  = 1'b0;
    prog_ram_write_3 = 1'b0;
    prog_ram_read_3  = 1'b0;
  end
  else if(ramaddr_o[15:12]==4'b0001) begin
    prog_ram_write_0 = 1'b0;
    prog_ram_read_0  = 1'b0;
    prog_ram_write_1 = r80515_reset ? prog_ram_wr : mempswr; 
    prog_ram_read_1  = r80515_reset ? prog_ram_rd : mempsrd;  
    prog_ram_write_2 = 1'b0;
    prog_ram_read_2  = 1'b0;
    prog_ram_write_3 = 1'b0;
    prog_ram_read_3  = 1'b0; 
  end
  else if(ramaddr_o[15:12]==4'b0010) begin
    prog_ram_write_0 = 1'b0;
    prog_ram_read_0  = 1'b0;
    prog_ram_write_1 = 1'b0;
    prog_ram_read_1  = 1'b0;
    prog_ram_write_2 = r80515_reset ? prog_ram_wr : mempswr; 
    prog_ram_read_2  = r80515_reset ? prog_ram_rd : mempsrd;
    prog_ram_write_3 = 1'b0;
    prog_ram_read_3  = 1'b0;
  end
  else if(ramaddr_o[15:12]==4'b0011) begin
    prog_ram_write_0 = 1'b0;
    prog_ram_read_0  = 1'b0;
    prog_ram_write_1 = 1'b0;
    prog_ram_read_1  = 1'b0;
    prog_ram_write_2 = 1'b0;
    prog_ram_read_2  = 1'b0;
    prog_ram_write_3 = r80515_reset ? prog_ram_wr : mempswr;
    prog_ram_read_3  = r80515_reset ? prog_ram_rd : mempsrd;
  end
  else begin
    prog_ram_write_0 = 1'b0;
    prog_ram_read_0  = 1'b0;
    prog_ram_write_1 = 1'b0;
    prog_ram_read_1  = 1'b0;
    prog_ram_write_2 = 1'b0;
    prog_ram_read_2  = 1'b0;
    prog_ram_write_3 = 1'b0;
    prog_ram_read_3  = 1'b0;        
  end
end   

//delay for mempsrd
always @(negedge sys_clk or posedge sys_rst)begin
  if(sys_rst)
    mempsrd_d <= 1'b0;
  else
    mempsrd_d <= mempsrd;
end


endmodule
