# File: jrever.pl
#
# Returns the JRE version that matlab is using
#
# Arguments
# 	matlabroot	-	The path to the matlab root directory
#
# Returns
# 	version number of the jre
 
# $Revision: 1.1.6.2 $
# $Date: 2004/04/19 01:24:49 $
#
# Copyright 2002-2003 The MathWorks, Inc.

my $matlabroot=shift;
$file = "$matlabroot/sys/java/jre/win32/jre.cfg";
$open = open FH,$file;
die "Unable to open $file" if !$open;
@lines = <FH>;
$jrever = $lines[0];
print $jrever;
