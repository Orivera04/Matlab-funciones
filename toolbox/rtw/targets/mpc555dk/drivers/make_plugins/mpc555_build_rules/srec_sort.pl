# File: srec_sort.pl
#
# Abstract:
#	Sorts srecord files with 32 bit address fields
#
# Usage
#  perl srec_sort.pl in.s19 out.s19
#
# $Revision: 1.1.4.1 $
# $Date: 2004/04/19 01:24:43 $
#
# Copyright 1990-2002 The MathWorks, Inc.

$srec_file_name = shift;	# The name of the srecord to process
$target_file_name = shift;	# The name of the target file to write out

open ( IFH, $srec_file_name);
@srec_file = <IFH>;
close( IFH );

$header = shift(@srec_file);
$trailer = pop(@srec_file);
@sorted_file = sort {
	($a_address)=($a=~/....(........)/);
	($b_address)=($b=~/....(........)/);
	$eval  = "0x$a_address <=> 0x$b_address";
	$x = eval("0x$a_address <=> 0x$b_address") ;
	$x
} @srec_file;
unshift(@sorted_file,$header);
push(@sorted_file,$trailer);

open ( CFH,  ">$target_file_name" );
print CFH @sorted_file;
close CFH
