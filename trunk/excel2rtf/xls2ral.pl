#!/usr/bin/perl
######################################################################
## Usage:
## Function:
##	covert register xls file to ral file
## History:
##	06/16/2009	Create File and pass for system sheet 
##			+ block sheet in divide sheet
##	07/07/2009	Support memory ralf generation
## Author:	Amber Yang
######################################################################

if ($ENV{HOST} ne "shserver39" && $ENV{HOST} ne "shserver28")
{
	die "your running host is not correct, you need to run the script under shserver30 or shserver28\n";
}

use Getopt::Long;
use File::Basename;
#use lib "$ENV{DVHOME}/cmn/scripts";
#use lib "/ecad/synopsys/pt_b200806sp3/ccsn/linux/perl/lib/site_perl/5.8.3";
#use lib "/ecad/synopsys/pt_b200806sp3/ccsn/linux/perl/lib/5.8.3";
#use dk_tools;

use Cwd;
#use Win32::OLE::Const 'Microsoft Excel';
use Spreadsheet::ParseExcel;
use Spreadsheet::ParseExcel::FmtUnicode; 
use Encode;
#use Unicode;
use Unicode::Map();


#
# Global Variables
#
my $cwd = cwd();
my $oBook;          # output workbook
my $IdexSheet = 0;  # sheet index
my $group = "";
my($iR, $iC, $oWkS,$oWkC);
my $PROJ = $ENV{'PROJ'};  #project name, initial by proj_login.csh
my $head;

sub help {
    print "\n";
  	print "Translate EXCEL file to RAL file\n",
  	print "Usage: xls2ral.pl\n",
  	print "     -input csv_file \n",
  	print "     -output opt_output(optional) \n",
  	print "     -debug(optional)\n",
    print "xls2gen.pl -input input.xls [-output output.ralf]\n";
    print "----------------------------------------------\n";
    print "\n";
    print "input.xls is the src data input file.\n";
    print "The output goes to projname.ralf by default unless an\n";
    print "output file is specified on the command line.\n";
    print "\n";
    exit;
}

#
# Parse the arguments and echo information
#
GetOptions(
    "input|i=s",
    "output|o=s",
		"debug|d",
		"help|h",
);

#print ("xls2dv - converts register xls file to RAL file\n");

if ( $opt_input ) {
    print("input file = $opt_input\n");
} else {
    help();
}

unless ( $opt_output ) {
	$opt_output= $ENV{PROJ}.".ralf" ;
}

print("output file = $opt_output\n");

if ($opt_help)
{
	help();
}

######################################################################
# Open the excel file
#
my $Map = new Unicode::Map("GB2312");

my $excelCODE='gb2312';
my $coslCODE='utf8';

my %parseCache ;
my %writeCache ;

my $oFmtJ = Spreadsheet::ParseExcel::FmtUnicode->new(Unicode_Map =>$excelCODE); 
my $oExcel = new Spreadsheet::ParseExcel;

$oBook = $oExcel->Parse("$cwd/$opt_input",$oFmtJ);
#$oBook = $oExcel->Parse("$cwd/$opt_input");
if ($opt_debug)
{
	print "input file is $cwd/$opt_input\n";
}
	print "Number of sheets = ", $oBook->{SheetCount}, "\n";
######################################################################
# default
#$output_block="block_out";
#$output_reg="reg_out" ;
my $opt_output_sys = "sys_out";
if (-e "$cwd/$opt_output_sys")
{
  system 'rm -rf sys_out';
	system 'touch', $opt_output_sys;
	print "the sys out file $opt_output_sys exist\n";
}
else
{
	system 'touch', $opt_output_sys;
	print "generate a sys out file $opt_output_sys\n";
}
my $opt_output_mem = "mem_out";
if (-e "$cwd/$opt_output_mem")
{
  system 'rm -rf sys_out';
	system 'touch', $opt_output_mem;
	print "the mem out file $opt_output_mem exist\n";
}
else
{
	system 'touch', $opt_output_mem;
	print "generate a sys out file $opt_output_mem\n";
}


my %hash_reg;
my %hash_mem;
#my %hash_reg = (
#                        mem_name => { _path => {},
#                                      _offaddr => {}
#                                 },
#			);		

$col_value;
$flag_reg=0 ;
$flag_block=0 ;
$flag_sys=0 ;
$col_value;
open (FO,">$opt_output") || die "Can not open $opt_output" ;
#open (FO,">$opt_output_block") || die "Can not open $opt_output_block" ;
#open (FO,">$opt_output_reg") || die "Can not open $opt_output_reg" ;
open (Fsys,">$opt_output_sys") || die "Can not open $opt_output_sys" ;
open (Fmem,">$opt_output_mem") || die "Can not open $opt_output_mem" ;
print "INFO: Read \"$opt_input\" ...\n" ;
print "INFO: Creat final output \"$opt_output\" ...\n" ;
print "INFO: Creat system output \"$output_sys\" ...\n" ;

#
# Loop through the existing worksheets looking for requested sheet.
#
for ($sheetCnt = 0; $sheetCnt <= $oBook->{SheetCount}; $sheetCnt++)
{
    $oWkS = $oBook->{Worksheet}[$sheetCnt];
    print "------------Processing SHEET:",$oWkS->{Name}, "\n";
   ###################processing proj sheet############ 
    if ( $oWkS->{Name} eq $ENV{'PROJ'} )
    {
    	print "The sheet is system sheet, name is $oWkS->{Name}\n";
        $flag_sys = 1; 
	for($iR = $oWkS->{MinRow} ;
	#for(my $iR = 4 ;
     	defined $oWkS->{MaxRow} && $iR <= $oWkS->{MaxRow} ;
     	$iR++){
		 
     #for(my $iC = $oWkS->{MinCol} ;
       #defined $oWkS->{MaxCol} && $iC <= $oWkS->{MaxCol} ;
       #$iC++){
			
       		$col_value=$oWkS->{Cells}[$iR][0];
		next if(!$col_value);
       		$head=encode($coslCODE,decode($excelCODE,$col_value->Value) );
		if($opt_debug){
			print "head string is $head\n";
			print "the string row is $iR\n";
			print "the string column is 0\n";
		}
		#chop($head) ;
  		#$head=~s/^\s+|\s+$|\"//g ;
		if ($head eq "system name")
	  	{
       			$col_value=$oWkS->{Cells}[$iR][1];
       			$name=encode($coslCODE,decode($excelCODE,$col_value->Value) );
			#chop($name) ;
  		  	#$name=~s/^\s+|\s+$|\"//g ;
    	 		print Fsys "system $name \{\n" ;
	   	}
		elsif ($head eq	"system bytes")
	  	{
       			$col_value=$oWkS->{Cells}[$iR][1];
       			$bytes=encode($coslCODE,decode($excelCODE,$col_value->Value) );
			#chop($bytes) ;
  		    	#$bytes=~s/^\s+|\s+$|\"//g ;
			my $bytes_sys = hex($bytes);
			printf Fsys "  bytes %d;\n", $bytes_sys ;
		}
        	elsif ($head =~/^\w+/)
		{
	    		my $block_name=$head ;
			printf "block name is %s\n", $head;
       			$col_value=$oWkS->{Cells}[$iR][1];
       			$block_offset=encode($coslCODE,decode($excelCODE,$col_value->Value) );
       			$col_value=$oWkS->{Cells}[$iR][2];
                if ($col_value ne "")
                {
                	$block_path=encode($coslCODE,decode($excelCODE,$col_value->Value) );
                }
			if ($block_name ne ""){
                if ($col_value ne "")
                {   
				    printf Fsys "  block $block_name \($block_path\) \@$block_offset\n";
                }
                else 
                {
                    printf Fsys "  block $block_name \@$block_offset\n";
                }
			}
		}
		else{
			print "Warning!: The cell not match any situation for system sheet.\n";
		}
     	} #end for
    #printf Fsys "  block MEM \@0\n";
	print Fsys "\}\n" 
    } #end if proj
    ################### processing memory sheet ###############
    elsif ( $oWkS->{Name} eq "MEM" )
    {
	print "The sheet is system sheet, name is $oWkS->{Name}\n";
        $flag_mem = 1; 
	for($iR = $oWkS->{MinRow} ;
     	defined $oWkS->{MaxRow} && $iR <= $oWkS->{MaxRow} ;
     	$iR++){
		 
       		$col_value=$oWkS->{Cells}[$iR][0];
		next if(!$col_value);
       		$head=encode($coslCODE,decode($excelCODE,$col_value->Value) );
		if($opt_debug){
			print "head string is $head\n";
			print "the string row is $iR\n";
			print "the string column is 0\n";
		}
		if ($head eq "memory name")
	  	{
			$col_value=$oWkS->{Cells}[$iR][1];
       			$mem_name=encode($coslCODE,decode($excelCODE,$col_value->Value) );
    	 		print Fmem "memory $mem_name \{\n" ;
		}
		elsif ($head eq	"memory address\(offset\)")
	  	{
       			$col_value=$oWkS->{Cells}[$iR][1];
       			$off_addr=encode($coslCODE,decode($excelCODE,$col_value->Value) );
			$hash_mem{$mem_name} = $off_addr;
			if($opt_debug) {
		  		print "DEBUG: find memory is $mem_name, offset is $off_addr\n";
			}
		}
		elsif ($head eq "memory bits")
		{
			$col_value=$oWkS->{Cells}[$iR][1];
       			$mem_bits=encode($coslCODE,decode($excelCODE,$col_value->Value) );
			printf Fmem "  bits %d;\n", $mem_bits ;

		}
		elsif ($head eq "memory size")
		{
			
			$col_value=$oWkS->{Cells}[$iR][1];
       			$mem_size=encode($coslCODE,decode($excelCODE,$col_value->Value) );
			printf Fmem "  size %d;\n", $mem_size ;
		}
		elsif ($head eq "memory access")
		{
			$col_value=$oWkS->{Cells}[$iR][1];
       			$mem_access=encode($coslCODE,decode($excelCODE,$col_value->Value) );
			printf Fmem "  access %s;\n", $mem_access ;
			print Fmem "\}\n";
		}
		elsif($head eq "block name"){
			if($opt_debug) { print "DEBUG: find block name \"$head\" \n" ; }
			$flag_block=1 ;
       			$col_value=$oWkS->{Cells}[$iR][1];
       			$name=encode($coslCODE,decode($excelCODE,$col_value->Value) );
			print Fmem "block $name \{\n" ;
	  	}
		elsif($head eq "block bytes" && $flag_block==1 ){
			if($opt_debug) { print "DEBUG: find block field name \"$head\" \n" ; }
       			$col_value=$oWkS->{Cells}[$iR][1];
       			$bytes=encode($coslCODE,decode($excelCODE,$col_value->Value) );
			printf Fmem "  bytes %d;\n", $bytes ;
	  		foreach $key (sort keys %hash_mem)
			{ 
		  		print Fmem "  memory $key \@$hash_mem{$key};\n" ;
			}
			undef %hash_mem;
			print Fmem "\}\n" ;
	  	} 
		else{
			print "Warning!: The cell not match any situation for memory sheet.\n";
		}
	}
    }
    else ##############processing block sheet##################
    {
    	print "The sheet is block sheet, name is $oWkS->{Name}\n";
	if($opt_debug){
		print "the sheet Min row number is $oWkS->{MinRow}, Max row number is $oWkS->{MaxRow}\n";;
	}		
	for($iR = $oWkS->{MinRow} ;
     	defined $oWkS->{MaxRow} && $iR <= $oWkS->{MaxRow} ;
     	$iR++)
	{
       		$col_value=$oWkS->{Cells}[$iR][0];
		next if(!$col_value);
	
		if($opt_debug)
		{print "\n\n\nThe min col for the Row is $oWkS->{MinCol}\n";};
		my $head;
       		$head=encode($coslCODE,decode($excelCODE,$col_value->Value) );
		#chop($head) ;
  		#$head=~s/^\s+|\s+$|\"//g ;
		if($opt_debug){
			print "current processing row number is $iR\n";
			print "head string is $head\n";
			print "the string row is $iR\n";
			print "the string column is 0\n";
		}	
		if($head eq "")
		{
			$head = "ak47";
		}	
		   
		if($head eq "register name"){
			my $bits_count = 0;
			if($opt_debug) { 
				print "DEBUG: find reg name \"$head\" \n" ; 
			}
			$flag_reg=1 ;
       			$col_value=$oWkS->{Cells}[$iR][1];
       			$name_reg=encode($coslCODE,decode($excelCODE,$col_value->Value) );
			print FO "register $name_reg \{\n" ;
	  	}
		elsif($head=~/register address\(offset\)/ &&  $flag_reg==1 ){
			if($opt_debug) { print "DEBUG: find reg offset\"$head\" \n" ; }
       			$col_value=$oWkS->{Cells}[$iR][1];
       			$offset=encode($coslCODE,decode($excelCODE,$col_value->Value) );
			$offset{$name_reg}=$offset ;
			$hash_reg{$name_reg}{_offaddr} = $offset;
			if($opt_debug) {
		  		print "DEBUG: find regname is $name_reg, offset is $offset\n";
			}
		}
		elsif($head=~/register hdl_path/ &&  $flag_reg==1 ){
			if($opt_debug) { print "DEBUG: find reg hdl path\"$head\" \n" ; }
       			$col_value=$oWkS->{Cells}[$iR][1];
       			$reg_path=encode($coslCODE,decode($excelCODE,$col_value->Value) );
			$hash_reg{$name_reg}{_path} = $reg_path;
			if($opt_debug) {
		  		print "DEBUG: find regname is $name_reg, path is $reg_path\n";
			}
		}
		elsif($head=~/^\[[0-9]/ && $flag_reg==1 ){
			if($opt_debug) { print "DEBUG: find reg field \"$head\" \n" ; }
       			$col_value=$oWkS->{Cells}[$iR][1];
       			$name=encode($coslCODE,decode($excelCODE,$col_value->Value) );
       			$col_value=$oWkS->{Cells}[$iR][0];
       			$field_space=encode($coslCODE,decode($excelCODE,$col_value->Value) );
			if ($field_space =~ /(\d*)\]$/)
			{
		  		$start_bit = $1;
			}
			else{
		  		print "Warning: not found start bit, found string is $field_space\n";
			}
			if ($field_space =~ /^\[(\d*)/)
			{
		  		$end_bit = $1;
				$num_bits = $end_bit - $start_bit +1;
			}
			else{
		  		print "Warning: not found end bit, found string is $field_space\n";
			}
			$bits_count = $bits_count + $num_bits;
			if($opt_debug) {
		  		print "bits count is $bits_count\n";
			}
       			$col_value=$oWkS->{Cells}[$iR][2];
       			$rw=encode($coslCODE,decode($excelCODE,$col_value->Value) );
       			$col_value=$oWkS->{Cells}[$iR][3];
       			$value=encode($coslCODE,decode($excelCODE,$col_value->Value) );
			print FO "  field $name \@$start_bit \{\n" ;
			print FO "    bits $num_bits;\n" ;
			$name =~ s/ *$//g; 
			$name =~ s/^ *//g; 
			if ($name ne "unused")
			{
		  		print FO "    access $rw;\n" ;
		  		print FO "    reset $value;\n" ;
			}
			print FO "  \}\n" ;
			if ($bits_count == 32)
			{
				print FO "\}\n";
		  		if($opt_debug) {
					print "register generated for $name_reg, bits count is $bits_count\n";
		  		}
			}
			if ($end_bit == 31){
				$bits_count = 0;
	  		}
		} # end if register
#########################block processing#########################
		elsif($head eq "block name"){
			if($opt_debug) { print "DEBUG: find block name \"$head\" \n" ; }
			$flag_block=1 ;
       			$col_value=$oWkS->{Cells}[$iR][1];
       			$name=encode($coslCODE,decode($excelCODE,$col_value->Value) );
			print FO "block $name \{\n" ;
	  	}
		elsif($head eq "block bytes" && $flag_block==1 ){
			if($opt_debug) { print "DEBUG: find block field name \"$head\" \n" ; }
       			$col_value=$oWkS->{Cells}[$iR][1];
       			$bytes=encode($coslCODE,decode($excelCODE,$col_value->Value) );
			my $bytes_tmp = hex($bytes);
			printf FO "  bytes %d;\n", $bytes_tmp ;
	  		foreach $key (sort keys %hash_reg)
			{ 
				if ($hash_reg{$key}{_path} eq "")
				{print FO "  register $key \@$hash_reg{$key}{_offaddr};\n" ;	
				}
				else{
		  		print FO "  register $key \($hash_reg{$key}{_path}\) \@$hash_reg{$key}{_offaddr};\n" ;
				}
			}
			undef %hash_reg;
			print FO "\}\n" ;
	  	} # end if block
##########################
###################################################################
		elsif( $head eq "" && ( $flag_reg == 1  || $flag_block == 1) ) 
		{	# reset reg,block
			$flag_reg=0 ;
			$flag_blok=0 ;
			$flag_sys=0 ;
			$head = "m16";
			print FO "\n" ;	# new lines
			if ($opt_debug){
		 		print "One transaction processing completed\n\tflag reg is $flag_reg\n\tflag block is $flag_block\n\tflag sys is $flag_sys \n";
			}
	  	}
		else
		{
		 print "This is a blank row, ignored!!\n";
	  	}

	} # end for block sheet 
    } # end else for block sheet
} # end for xcel
#####################merage system and blocks into ral file#######
system "cat $opt_output_mem  >> $opt_output";
system "cat $opt_output_sys  >> $opt_output";
#####################

###############################################################
#####################close all file###########################

close(Fsys) ;
close(Fmem) ;
close(FO) ;
#close(FO) ;
#close(FO) ;
printf "INFO: %s created successfully.\n",$opt_output ;
printf "INFO: %s created successfully.\n",$opt_output_sys ;
printf "INFO: %s created successfully.\n",$opt_output_mem ;


#system "cat block_out reg_out > $opt_output";
########################################################################
# Sub module => split line
########################################################################
#######################sub function#####################################
sub  get_xls_cell 
{
	my($iR, $iC, $oWkS) = @_;
  my $sub_oWkc;
	my $head;
  $sub_oWkC=$oWkS->{Cells}[$iR][$iC];
  if ($sub_oWkC)
	{
		$head=encode($coslCODE,decode($excelCODE,$sub_oWkC->Value) );
		chop($head) ;
  	$head=~s/^\s+|\s+$|\"//g ;
	}
}
