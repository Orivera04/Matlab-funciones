# File : mkdir.pl
#
# Abstract :
# 
# 	Creates a new directory
#
# Usage
#
# 	perl mkdir.pl bin/win32
# 	perl mkdir.pl d:/bin/win32
# 	perl mkdir.pl ../bin/win32
#
# Notes 
# 	this is able to create a directory path to any
# 	depth in one step.
#
# $Revision: 1.1.6.2 $
# $Date: 2004/04/19 01:24:51 $
#
# Copyright 2002-2003 The MathWorks, Inc.

$path = shift;
@d = split(/\//,$path);
while ( $d = shift @d ){
	if (not chdir $d) {
		print "mkdir.pl : Creating Directory $d\n";
		mkdir $d,0x0777;
		chdir $d;
	};
}
