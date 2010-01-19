# Synopsys, Inc. constraint file
# D:/Design/test/spi/fpga/sdc/spi.sdc
# Written on Wed Dec 02 16:20:15 2009
# by Synplify Premier, C-2009.03 Scope Editor

#
# Collections
#

#
# Clocks
#
define_clock   {clk} -name {clk}  -freq 80 -clockgroup default_clkgroup_0

#
# Clock to Clock
#

#
# Inputs/Outputs
#
define_input_delay -disable      -default -improve 0.00 -route 0.00
define_output_delay -disable     -default -improve 0.00 -route 0.00
define_input_delay -disable      {clk} -improve 0.00 -route 0.00
define_input_delay -disable      {reset_n} -improve 0.00 -route 0.00
define_input_delay -disable      {SS} -improve 0.00 -route 0.00
define_input_delay -disable      {SCK} -improve 0.00 -route 0.00
define_output_delay -disable     {MISO} -improve 0.00 -route 0.00
define_input_delay -disable      {MOSI} -improve 0.00 -route 0.00

#
# Registers
#

#
# Delay Paths
#
define_multicycle_path  -from {{u_SPI08V100.u_spi_slave_ctrl.rs_mode[1:0]}}  8
define_multicycle_path  -from {{u_SPI08V100.u_spi_slave_ctrl.block_size[2:0]}}  8

#
# Attributes
#
define_attribute {i:u_SPI08V100.u_spi_slave_ctrl.mrd_length[16:5]} syn_multstyle {logic}
define_attribute {i:u_bydin.un3_ram_addr[16:0]} syn_multstyle {logic}
define_attribute {b:clk} CLOCK_DEDICATED_ROUTE {0} 
define_attribute {p:clk} {xc_loc} {D20}
define_attribute {p:reset_n} {xc_loc} {F20}
define_attribute {p:SS} {xc_loc} {A26}
define_attribute {p:SCK} {xc_loc} {B31}
define_attribute {p:MOSI} {xc_loc} {A29}
define_attribute {p:MISO} {xc_loc} {B28}
define_attribute {p:int0} {xc_loc} {B32}

#
# I/O Standards
#
define_io_standard -disable      -default_input -delay_type input
define_io_standard -disable      -default_output -delay_type output
define_io_standard -disable      -default_bidir -delay_type bidir
define_io_standard -disable      {clk} -delay_type input
define_io_standard -disable      {reset_n} -delay_type input
define_io_standard -disable      {SS} -delay_type input
define_io_standard -disable      {SCK} -delay_type input
define_io_standard -disable      {MISO} -delay_type output
define_io_standard -disable      {MOSI} -delay_type input

#
# Compile Points
#

#
# Other
#