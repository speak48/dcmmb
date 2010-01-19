module spi_tb;

parameter CLK_PRD = 10;
parameter SPI_PRD = 100;

reg             clk      ;
reg             reset_n  ;

// SPI bus
reg              SS      ;
reg              SCK     ;
wire             MISO    ;
reg              MOSI    ;

task clock_gen;
   clk = 1'b0;
   forever #(CLK_PRD/2) clk = ~clk; 
endtask

task reset_gen;
   reset_n = 1'b0;
   #(10*CLK_PRD) reset_n = 1'b1;
   $disply("reset end");
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
   #(SPI_RRD/3)
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
     MISO = shifter[7];     
     for(i=0;i<8;i=i+1)
        begin
        #(SPI_PRD) SCK = ~SCK;
	#(SPI_PRD) shifter = {shifter[6:0],1'b0};
	           MOSI = shifter[7];
		   SCK = ~SCK;	
        end
     MISO = 1'b0;
     shifter = 8'h0;
     for(i=0;i<8;i=i+1)
        begin
        #(SPI_PRD) SCK = ~SCK;
	#(SPI_PRD) shifter[6:0] = shifter[7:1];
	           shifter[7] = MISO;
		   SCK = ~SCK;	
	end    
        c = shifter;
    end 	
endtask    

task read_reg;	
   begin
   #(500*CLK_PRD)
      spi_single_byte_rd;
   end
endtask	


initial
    begin
       SCK = 1'b0;
       MOSI = 1'b1;
       SS  = 1'b1;
end

initial
    fork
       clock_gen;
       reset_gen;
       read_reg;
    join


endmodule
