# File: libcmd.pl
#
# Abstract:
#   Simple wrapper for building libraries. Does not build the
#   library if the number of objects is zero. This gets over
#   a bug in gmake with the $(if ... ) command.
#
# Arguments :
# 		$libcmd	-	The library command
# 		$libname -  The library name
# 		$objects -  List of object files
#
# $Revision: 1.1 $
# $Date: 2002/09/13 09:03:36 $
#
# Copyright 2002 The MathWorks, Inc.

$libcmd = shift(@ARGV);
$libname = shift(@ARGV);
@objects = @ARGV;
$nObjects = @objects;

if ($nObjects > 0){
	print "$libcmd $libname @objects\n"; 
	print `$libcmd $libname @objects`; 
}else{
	print "$libname not remade as there are no objects. Not an error.\n";
}
