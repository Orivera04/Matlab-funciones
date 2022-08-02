# File: toolchaincheck.pl
#
# Abstract:
#	 Garuntees that a make clean has been run between swapping toolchains. 
#	 The method is that a file toolchain.txt will be written out with
#	 the toolchain name as contents. If this file is called and the toolchain.txt
#	 allready exists a check is made on the contents
#
# Arguments :
# 		$libcmd	-	The library command
# 		$libname -  The library name
# 		$objects -  List of object files
#
# $Revision: 1.1 $
# $Date: 2002/09/13 09:05:48 $
#
# Copyright 2002 The MathWorks, Inc.

$toolchain = shift(@ARGV);

if ( -e "toolchain.txt" ){
	open(fh,'toolchain.txt');

	$oldToolchain = <fh> ;
	chomp($oldToolchain);


	if ($toolchain !~ $oldToolchain ) {
		print "##################################################################\n";
		print "# TOOLCHAIN BUILD ENVIRONMENT ERROR\n";
		print "#-----------------------------------------------------------------\n";
		print "# $toolchain is the requested toolchain build environment.\n";
		print "# $oldToolchain is the previous toolchain build environment\n";
		print "#\n";
		print "# You must perform a make clean before changing toolchain\n";
		print "# build environments. Incompatible object files may exist.\n";
		print "##################################################################\n";
		die("Build environment failure");
	}
}else{
	open(fh,'>toolchain.txt');
	print fh "$toolchain\n";
	close fh
}
