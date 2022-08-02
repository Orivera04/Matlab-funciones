# File : filelist.pl
#
# Abstract :
#
# 	Given an input list of files generate the <FILELIST> section
# 	of the CodeWarrior project import file
#

# Copyright 2002 The MathWorks, Inc.
# $Revision: 1.1 $ 
# $Date: 2002/12/06 18:16:24 $
print "<FILELIST>\n";
while(<>){
	chomp;
	# Get just file name
	$_ =~ s/^.*[\\\/]([^\\\/]*$)/\1/;
	print <<EOT
   <FILE>
		<PATHTYPE>Name</PATHTYPE>
		<PATH>$_</PATH>
		<PATHFORMAT>Windows</PATHFORMAT>
		<FILEKIND>Text</FILEKIND>
		<FILEFLAGS>Debug</FILEFLAGS>
	</FILE>
EOT
}
print "</FILELIST>\n";
