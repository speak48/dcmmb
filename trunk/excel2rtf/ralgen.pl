#!/usr/bin/perl
######################################################################
## Usage:
## Function:
##	1) sample
## History:
##	05/22/2009	Create File
##  05/26/2009  Fixed some bugs, generation ralf for single block successfully
##  06/04/2009  Added system level generation  
######################################################################

my @ERR_MSG = (
  "Translate EXCEL csv file to text\n",
  "Usage: sample.pl\n",
  "     -csv csv_file \n",
  "     -out outfile(optional) \n",
  "     -debug(optional)\n",
  ) ;

$argcount=@ARGV ;

#if($argcount==0) { die "@ERR_MSG\n" ; }

# default
$DEBUG=0 ;
$infile="demo/MY_BLOCK.csv" ;
$outfile="sample_out.txt" ;
$outfile_block="block_out" ;
$outfile_reg="reg_out" ;
while(@ARGV){
  $_ = shift;
  if ($_=~/^-csv/){
    $infile = shift;
    }
  elsif ($_=~/^-out/){
    $outfile = shift;
    }
  elsif ($_=~/^-debug/){
    $DEBUG = 1;
    }
  else {
    die "@ERR_MSG\n" ;
    }
  }

######################################################################
# Read csv file
# samples
#register DATA_reg0 {
#  field DATA @0 {
#    bits 32;
#    access rw;
#    reset 0x0;
#  }
#}
######################################################################
open (FI,"<$infile") || die "Can not open $infile" ;
open (FO,">$outfile") || die "Can not open $outfile" ;
#open (FO,">$outfile_block") || die "Can not open $outfile_block" ;
#open (FO,">$outfile_reg") || die "Can not open $outfile_reg" ;
print "INFO: Read \"$infile\" ...\n" ;

my %hash_reg;

$flag_reg=0 ;
$flag_block=0 ;
while($line=<FI>){
	chop($line) ;
	$line=~s/^\s+|\s+$|\"//g ;
	next if ($line=~/^#/) ;
	$tmp=&get_csvline_num($line) ;
	$head=&get_csvline_item($line,$tmp,0) ;
	if($head eq "register name"){
		my $bits_count = 0;
		if($DEBUG) { print "DEBUG: find reg name \"$head\" \n" ; 
			print "bit count is $bits_count\n";
		}
		$flag_reg=1 ;
	  $name_reg=&get_csvline_item($line,$tmp,1) ;
		print FO "register $name_reg \{\n" ;
	  }
	elsif($head=~/register address\(offset\)/ &&  $flag_reg==1 ){
		if($DEBUG) { print "DEBUG: find reg offset\"$head\" \n" ; }
		$offset=&get_csvline_item($line,$tmp,1) ;
		$offset{$name_reg}=$offset ;
		$hash_reg{$name_reg} = $offset;
		if($DEBUG) {
		  print "DEBUG: find regname is $name_reg, offset is $offset\n";
		}
	  }
	#elsif($head=~/^\[[0-9]+:[0-9]+\]$/ && $flag_reg==1 ){
	elsif($head=~/^\[[0-9]/ && $flag_reg==1 ){
		if($DEBUG) { print "DEBUG: find reg field \"$head\" \n" ; }
		$name=&get_csvline_item($line,$tmp,1) ;
		$field_space = &get_csvline_item($line,$tmp,0);
		if ($field_space =~ /(\d*)\]$/)
		{
		  $start_bit = $1;
		}
		else{
		  print "ERROR: not found start bit\n";
		}
		if ($field_space =~ /^\[(\d*)/)
		{
		  $end_bit = $1;
			$num_bits = $end_bit - $start_bit +1;
		}
		else{
		  print "ERROR: not found end bit\n";
		}
		#$start_bit=0 ;
		#$num_bits=32 ;
		$bits_count = $bits_count + $num_bits;
		if($DEBUG) {
		  print "bits count is $bits_count\n";
		}
		$rw=&get_csvline_item($line,$tmp,2) ;
		$value=&get_csvline_item($line,$tmp,3) ;
		print FO "  field $name \@$start_bit \{\n" ;
		print FO "    bits $num_bits;\n" ;
		if ($name ne "unused")
		{
		  print FO "    access $rw;\n" ;
		  print FO "    reset $value;\n" ;
		}
		print FO "  \}\n" ;
		if ($bits_count == 32)
		{
			print FO "\}\n";
		  if($DEBUG) {
			  print "register generated for $name_reg, bits count is $bits_count\n";
		  }
		if ($end_bit == 31){
			$bits_count = 0;
	  }
		}
	  }
# samples:
# input:
#  block name,MY_BLOCK,,,
#  block bytes,0x8,,,
# output:
# block MY_BLOCK {
#  bytes 0x8;
#  register DATA_reg0 @0x0;
#  register CTRL_reg1 @0x4;
#}
#########################block processing#########################
	elsif($head eq "block name"){
		if($DEBUG) { print "DEBUG: find block name \"$head\" \n" ; }
		$flag_block=1 ;
	  $name=&get_csvline_item($line,$tmp,1) ;
		print FO "block $name \{\n" ;
	  }
	elsif($head eq "block bytes" && $flag_block==1 ){
		if($DEBUG) { print "DEBUG: find block field name \"$head\" \n" ; }
		$bytes=&get_csvline_item($line,$tmp,1) ;
		my $bytes_tmp = hex($bytes);
		printf FO "  bytes %d;\n", $bytes_tmp ;
    #while(($reg_name,$reg_offset)=each(%offset)){
		#	print FO "  register $regname $offset;\n" ;
    #  }
	  foreach $key (sort keys %hash_reg)
		{ 
		  print FO "  register $key \@$hash_reg{$key};\n" ;
		}
		undef %hash_reg;
		print FO "\}\n" ;
	  }

########################system processing##########################
   elsif ($head eq "system name")
	 {
	   $name=&get_csvline_item($line,$tmp,1) ;
     	print FO "system $name \{\n" ;
	 }
	 elsif ($head eq	"system bytes")
	 {
	    $bytes=&get_csvline_item($line,$tmp,1) ;
			my $bytes_sys = hex($bytes);
			printf FO "  bytes %d;\n", $bytes_sys ;

			while($line=<FI>){
				chop($line) ;
				$line=~s/^\s+|\s+$|\"//g ;
				next if ($line=~/^#/) ;
				$tmp=&get_csvline_num($line) ;   #get a new line for blocks offset analyze
	    	my $block_name=&get_csvline_item($line,$tmp,0) ;
	    	my $block_offset=&get_csvline_item($line,$tmp,1) ;
				if ($block_name ne ""){
				  printf FO "  block $block_name \@$block_offset\n";
				}
      }
			print FO "\}\n" ;
	 }
###################################################################
	elsif( $head eq "" && ( $flag_reg == 1  || $flag_block == 1 ) ) {	# reset reg,block
		$flag_reg=0 ;
		$flag_blok=0 ;
		print FO "\n" ;	# new lines
	  }
	else {
	  }
  }

#####################merage reg and block into ral file#######
#system "cat block_out reg_out > $outfile";
#####################
#####################close all file###########################
close(FI) ;
close(FO) ;
#close(FO) ;
#close(FO) ;
print "INFO: \"$outfile\" created successfully.\n" ;


#system "cat block_out reg_out > $outfile";
########################################################################
# Sub module => split line
########################################################################
sub get_csvline_item {
  my ($line,$num,$seq) = @_ ;
  my $tmp ;
  #@sline=split(/\s+/,$line) ;
  @sline=split(/\,/,$line) ;
  $tmp=@sline ;
  if ($tmp != $num ) {
    print "Format erorr: $line\n" ;
    print "  number of line not equare $num\n" ;
    print "Please check $infile\n" ;
    exit 0 ;
    }
  return($sline[$seq]) ;
  }

########################################################################
# Sub module => split line, get number of elements
########################################################################
sub get_csvline_num {
  my ($line)=@_ ;
  my $tmp ;
  #@sline=split(/\s+/,$line) ;
  @sline=split(/\,/,$line) ;
  $tmp=@sline ;
  return($tmp) ;
  }


# vim: ts=2 ai
