`timescale 1ns/1ns
`define PRINT_DAT
module spi_tb;

parameter CLK_PRD = 10;
parameter SPI_PRD = 100;

reg             clk      ;
reg             reset_n  ;
reg   [8:0]     block_line;
reg   [7:0]     k_depth  ;
reg   [2:0]     block_size;
reg   [1:0]     rs_mode  ;

// SPI bus
reg              SS      ;
reg              SCK     ;
wire             MISO    ;
reg              MOSI    ;

// Demo reg
wire   [6:0]     reg_addr;
wire   [7:0]     reg_data_i;
wire             reg_rd;
wire             reg_wr;
wire   [7:0]     reg_data_o;
wire             mem_rd_ena;
wire     [7:0]   mem_data_out;
wire             mem_ena_out;
wire             bydin_int;

`ifdef PRINT_DAT
integer file_out;
initial begin
   file_out = $fopen("mass_result","wb");
end
`endif

task clock_gen;
begin	
   clk = 1'b0;
   forever #(CLK_PRD/2) clk = ~clk; 
end   
endtask

task reset_gen;
begin	
   reset_n = 1'b0;
   #(10*CLK_PRD) reset_n = 1'b1;
   $display("reset end");
end   
endtask

task spi_single_byte_rd;
   input [6:0] reg_addr;
   output [7:0] reg_data;
   parameter [7:0] SNG_CMD = 8'b01_110100;
   integer i;
   reg [7:0] shifter;
   begin
     SS  = 1'b1;
     SCK = 1'b0; // CPOL = 0
   #(SPI_PRD*2)
     SS  = 1'b0;
   #(SPI_PRD/3)
     shifter = SNG_CMD;
     MOSI = shifter[7];
     SCK  = 1'b0; 
     for(i=0;i<8;i=i+1)
        begin
        #(SPI_PRD) SCK = ~SCK;
	#(SPI_PRD) shifter = {shifter[6:0],1'b0};
	           MOSI = shifter[7];
		   SCK = ~SCK;
	end
     shifter = {1'b0, reg_addr};
     MOSI = shifter[7];     
     for(i=0;i<8;i=i+1)
        begin
        #(SPI_PRD) SCK = ~SCK;
	#(SPI_PRD) shifter = {shifter[6:0],1'b0};
	           MOSI = shifter[7];
		   SCK = ~SCK;	
        end
     MOSI = 1'b0;
     for(i=0;i<8;i=i+1)
        begin
        #(SPI_PRD) SCK = ~SCK;
	#(SPI_PRD) SCK = ~SCK;
        end
//     shifter = {7'h0, MISO};
     for(i=0;i<8;i=i+1)
        begin
        #(SPI_PRD) SCK = ~SCK;
	           shifter[7:0] = {shifter[6:0],MISO};
	#(SPI_PRD) SCK = ~SCK;	
	end
     SS = 1'b1; 	
     reg_data = shifter;
    end 	
endtask    

task spi_single_byte_wr;
   input [6:0] reg_addr;
   input [7:0] reg_data;
   parameter [7:0] SNG_CMD = 8'b01_110100;
   integer i;
   reg [7:0] shifter;
   begin
     SS  = 1'b1;
     SCK = 1'b0; // CPOL = 0
   #(SPI_PRD*2)
     SS  = 1'b0;
   #(SPI_PRD/3)
     shifter = SNG_CMD;
     MOSI = shifter[7];
     SCK  = 1'b0; 
     for(i=0;i<8;i=i+1)
        begin
        #(SPI_PRD) SCK = ~SCK;
	#(SPI_PRD) shifter = {shifter[6:0],1'b0};
	           MOSI = shifter[7];
		   SCK = ~SCK;
	end
     shifter = {1'b1, reg_addr}; //write register
     MOSI = shifter[7];     
     for(i=0;i<8;i=i+1)
        begin
        #(SPI_PRD) SCK = ~SCK;
	#(SPI_PRD) shifter = {shifter[6:0],1'b0};
	           MOSI = shifter[7];
		   SCK = ~SCK;	
        end
     shifter = reg_data;
     MOSI = shifter[7];
     for(i=0;i<8;i=i+1)
        begin
        #(SPI_PRD) SCK = ~SCK;
	#(SPI_PRD) shifter = {shifter[6:0],1'b0};
	           MOSI = shifter[7];
		   SCK = ~SCK;	
        end
//     shifter = {7'h0, MISO};
     MOSI = 1'b0;
     #(SPI_PRD)
     SS = 1'b1; 	
    end 	
endtask    

task spi_mass_byte_rd;
//   input [2:0] block_size;
//   input [1:0] rs_mode;
   output [7:0] reg_data;
   parameter [7:0] MAS_CMD = 8'b01_110101;
   integer i;
   integer j;
   reg [7:0] shifter;
   begin
     SS  = 1'b1;
     SCK = 1'b0; // CPOL = 0

   #(SPI_PRD*2)
     SS  = 1'b0;
   #(SPI_PRD/3)
     shifter = MAS_CMD;
     MOSI = shifter[7];
     SCK  = 1'b0; 
     for(i=0;i<8;i=i+1)
        begin
        #(SPI_PRD) SCK = ~SCK;
	#(SPI_PRD) shifter = {shifter[6:0],1'b0};
	           MOSI = shifter[7];
		   SCK = ~SCK;
	end
     shifter = {1'b0, block_size, rs_mode, 2'b0};
     MOSI = shifter[7];     
     for(i=0;i<8;i=i+1)
        begin
        #(SPI_PRD) SCK = ~SCK;
	#(SPI_PRD) shifter = {shifter[6:0],1'b0};
	           MOSI = shifter[7];
		   SCK = ~SCK;	
        end
     MOSI = 1'b0;
// dummy bytes      
     for(i=0;i<8;i=i+1)
        begin
        #(SPI_PRD) SCK = ~SCK;
	#(SPI_PRD) SCK = ~SCK;
        end
//     shifter = {7'h0, MISO};
     for(j=0;j<block_line*k_depth;j=j+1) begin
//     for(j=0;j<10;j=j+1) begin
       for(i=0;i<8;i=i+1)
        begin
        #(SPI_PRD) SCK = ~SCK;
	           shifter[7:0] = {shifter[6:0],MISO};
	#(SPI_PRD) SCK = ~SCK;	
	end
//	$display("read_data:%h",shifter);
`ifdef PRINT_DAT
        $fwrite(file_out,"%h\n",shifter);
`endif	
     end	
     #(SPI_PRD)
     SS = 1'b1; 	
     reg_data = shifter;
    end 	
endtask    


task read_reg;	
reg [7:0] data_rd; 	
   begin
   #(500*CLK_PRD)
       spi_single_byte_wr ( 8'h5a, 8'h77 ) ;
   #(10*CLK_PRD)
//       $finish;    
   #(500*CLK_PRD)
       spi_single_byte_rd ( 8'h5a, data_rd ) ;
       if(data_rd == 8'h77)
       $display("Write Operation Succeed, reg[%h] = %h", 8'h5a, data_rd);
//   #(10*CLK_PRD)
    #(500*CLK_PRD)
       spi_single_byte_wr ( 8'h36, 8'h15 ) ;
   #(10*CLK_PRD)
//       $finish;    
   #(500*CLK_PRD)
       spi_single_byte_rd ( 8'h36, data_rd ) ;
       if(data_rd == 8'h15)
       $display("Write Operation Succeed, reg[%h] = %h", 8'h36, data_rd);
       #(500*CLK_PRD)    
       wait(bydin_int) begin
       spi_mass_byte_rd ( data_rd);
    #(500*CLK_PRD)
       spi_single_byte_wr ( 8'h4e, 8'ha1 ) ;
   #(10*CLK_PRD)
//       $finish;    
   #(500*CLK_PRD)
       spi_single_byte_rd ( 8'h4e, data_rd ) ;
       if(data_rd == 8'ha1)
       $display("Write Operation Succeed, reg[%h] = %h", 8'h36, data_rd);
//       #(500*CLK_PRD)    
//       spi_mass_byte_rd ( data_rd);
       #(200*CLK_PRD)
       $finish;    
       end
   end
endtask	

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

initial
    begin
       SCK = 1'b0;
       MOSI = 1'b1;
       SS  = 1'b1;
       rs_mode = 2'b01;
       block_size = 3'b001;
end

//task dum_fsdb;
initial
begin
	$fsdbDumpfile("spi.fsdb");
	$fsdbDumpvars;
	$fsdbDumpflush;
end
//endtask

initial
    fork
       clock_gen;
       reset_gen;
       read_reg;
//       dump_fsdb;
    join


SPIP08V100 u_SPI08V100(
                    .rstb_i    (reset_n),     //ip reset
                    .clk_i     (clk    ),     //system clock
                    .sfr_sel_i (8'h0    ),     //spi sfr seclect
                    .sfr_en_i  (1'b0    ),     //spi sfr enable
                    .sfr_wr_i  (1'b0    ),     //spi sfr read and write control signal
                    .sfr_wdata_i (8'h0  ),     //spi sfr write data
             //       spi_en_i,        //spi enable
                    .ss_i       ( SS   ),     //spi ss pin input data
                    .sck_i      ( SCK  ),     //spi sck pin input data
                    .mosi_i     ( MOSI ),     //spi mosi pin input data
                    .miso_i     ( 1'b0 ),          //spi miso pin input data
                    .sdr_not_full_o (),  //spi send fifo full flag
                    .rdr_not_empty_o(),  //spi receive fifo empty flag
                    .ss_o           (),  //spi ss pin output data
                    .sck_o          (),  //spi sck pin output data
                    .mosi_o         (),  //spi mosi pin output data
                    .miso_o     ( MISO  ),          //spi miso pin output data
                    .ss_oe_o        (),  //spi ss pin output enable
                    .sck_oe_o       (),  //spi sck pin output enable
                    .mosi_oe_o      (),  //spi mosi pin output enable
                    .miso_oe_o      (),  //spi miso pin output enable                    
                    .int_o          (),  //spi interrupt request
                    .sfr_rdata_o    (),  //sfr read data        
                    .reg_addr    (reg_addr  ),
                    .reg_data_i  (reg_data_i),
                    .reg_data_o  (reg_data_o),
                    .reg_rd      (reg_rd    ),
                    .reg_wr      (reg_wr    ),
                    .mem_rd_ena  (mem_rd_ena),
                    .mem_data_out(mem_data_out),
                    .mem_ena_out (mem_ena_out )
                 );

demo_reg u_reg(
    .clk         (clk       ),
    .reset_n     (reset_n   ),
    .reg_addr    (reg_addr  ),
    .reg_data_i  (reg_data_i),
    .reg_data_o  (reg_data_o),
    .reg_rd      (reg_rd    ),
    .reg_wr      (reg_wr    )
);

bydin_sim u_bydin(
    .clk         (clk       ),
    .reset_n     (reset_n   ),
    .mem_rd_ena  (mem_rd_ena),
    .mem_data_out(mem_data_out),
    .mem_ena_out (mem_ena_out ),
    .bydin_int   (bydin_int   )
);

endmodule
