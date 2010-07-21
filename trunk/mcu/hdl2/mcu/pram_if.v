module pram_if(
              sys_clk   ,
              sys_rst   ,
              r80515_reset,
              prog_mode ,
              rab_write ,
              rab_read  ,
              rab_addr  ,
              rab_wdata ,
              rab_rdata ,
              rab_ack   ,

              pram_rdata,
              pram_wen  ,
              pram_cen  ,
              pram_addr ,
              pram_wdata,

              memaddr   ,
              romdata   ,
              mempsrd   ,
              mempsrd_d
 );

input          sys_clk         ;
input          sys_rst         ;
input          r80515_reset    ;
input          prog_mode       ;  //0: sequential write; 1:sequential read

// Host IF
input          rab_write       ;
input          rab_read        ;
input   [8:0]  rab_addr        ;
input   [7:0]  rab_wdata       ;
output  [7:0]  rab_rdata       ;
output         rab_ack         ;

// PRAM IF
input  [7:0]   pram_rdata      ;
output         pram_wen        ;
output         pram_cen        ;
output  [15:0] pram_addr       ;
output  [7:0]  pram_wdata      ; 

// ROM XBUS
input  [15:0]  memaddr         ;
input          mempsrd         ;
output         mempsrd_d       ;
output  [7:0]  romdata         ; 

reg            mempsrd_d       ;   
reg     [7:0]  prog_addr_h     ;
reg     [7:0]  prog_addr_l     ;
reg     [7:0]  prog_data       ;
reg            prog_ram_rd     ;
reg            prog_ram_rd_d   ;
reg            prog_ram_wr     ;
reg            wr_1st_flag     ;
reg    [15:0]  ramaddr         ;
reg     [7:0]  ram_rdata       ; 
reg     [7:0]  rab_rdata       ;
reg            rab_ack         ;

wire    [7:0]  romdata         ;
wire   [15:0]  pram_addr       ;
wire           pram_cen        ;
wire           pram_wen        ;
wire    [7:0]  pram_wdata      ;

// Reg control address in reset hold status
// MCU control address in reset release status
assign  pram_addr = r80515_reset ? ramaddr : memaddr;
assign  pram_cen = r80515_reset ? (!(prog_ram_wr | prog_ram_rd )) : mempsrd ;
assign  pram_wen = r80515_reset ? (!prog_ram_wr) : 1'b1 ;
assign  pram_wdata = prog_data;

assign  romdata = (pram_addr[15:14] == 2'b00) ?  pram_rdata : 8'h00 ;

// Host IF Read & Write Operation
// register for store data
// Buffer WR data in WR operation
// Hold Read data in RD operation
always @(posedge sys_clk or posedge sys_rst) begin
  if(sys_rst) begin
    prog_data   <= 8'h00;
  end
  else if(prog_mode) begin   // sequential read
    if(prog_ram_rd_d) begin  // ram_rdata ready 1 cycle after prog_ram_rd 
      prog_data <= pram_rdata; 
    end
  end
  else begin //sequential write
    if((rab_addr == 9'h1c) && rab_write) begin  
      prog_data <= rab_wdata; 
    end
  end
end

// Host RD REG
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

// Host Command Acknoledge
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

// Read immediate After Write Low Address in SEQ_WR mode
// Read after Write 9'1c
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
  end
  else begin
    prog_ram_rd_d <= prog_ram_rd;
  end
end

//hold access addr
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

//delay for mempsrd
always @(negedge sys_clk or posedge sys_rst)begin
  if(sys_rst)
    mempsrd_d <= 1'b0;
  else
    mempsrd_d <= mempsrd;
end


endmodule
