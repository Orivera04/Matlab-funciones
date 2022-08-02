# File : print.pl
#
# Abstract:
# 	Prints out some text to a file name
#
# 	
# Usage
#
# 	perl print.pl fname "<text>"

# $Revision: 1.1 $
# $Date: 2002/09/13 09:03:59 $
#
# Copyright 2002 The MathWorks, Inc.

# Notes
# 	
# 	this is really just to get around the fact the
# 	the > operator has problems in gmake macros.
# 	You can use this perl function to output text
# 	to a file without using the > operator.
# 	
$fname = shift;
$text  = shift;
open(FH, ">$fname") or die "Could not open $fname for writing";
print FH $text;
close FH;


