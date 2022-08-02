# File : rm.pl
#
# Abstract :
# 
# 	Deletes a list of files from a set of glob patterns
#
# Usage
#
# 	perl rm.pl *.exe *.c *.f
#
#
# $Revision: 1.1.4.2 $
# $Date: 2004/04/19 01:24:52 $
#
# Copyright 2002-2003 The MathWorks, Inc.
$globpatterns = join(' ',@ARGV);
@files = glob($globpatterns);
$nfiles = $#files + 1;
if ($nfiles > 0){
	$_files = join("\n",@files);
	print "Deleting $nfiles file(s)\n"; 
	foreach $file (@files) {
		print " => $file -> ";
		if (unlink($file)){
			print "Deleted.\n";
		}else{
			print "Failed to delete.\n";
		}
	}
}

