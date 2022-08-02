# File : grouplist.pl
#
# Abstract :
#
# 	Given an input list of files on <stdin> generate the <GROUPLIST> section of
# 	the CodeWarrior project import file
#

# Copyright 2002-2004 The MathWorks, Inc.
# $Revision: 1.1.4.2 $ 
# $Date: 2004/04/19 01:26:13 $
print "<GROUPLIST>\n";
while(<>){
	chomp;
	# Get just file name
	$_ =~ s/^.*[\\\/]([^\\\/]*$)/\1/;
	print <<EOT
	<FILEREF>
		<TARGETNAME>MathWorks Downloader</TARGETNAME>
		<PATHTYPE>Name</PATHTYPE>
		<PATH>$_</PATH>
		<PATHFORMAT>Windows</PATHFORMAT>
	</FILEREF>
EOT
}
print "</GROUPLIST>\n";
