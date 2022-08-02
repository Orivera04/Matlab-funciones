# File : get_source_files.pl
#
# Abstract :
# 	Take the output from the command	
#
# 		mwldeppc -dis -show only,debug target.elf
#
#   and extract all the source files available in
#   the DWARF information

# Copyright 2002-2004 The MathWorks, Inc.
# $Revision: 1.1.4.2 $ 
# $Date: 2004/04/19 01:26:12 $
my %files = ();
while(<>){
	if ( $_ =~ /DW_AT_name\((.*\.\w*)\)/ ) {
		if ( $files{$_} !~ /found/ ){
			# Only include the file once
			$files{$_} = 'found';

			$_ = $1;
			$_ =~ s/^\s*//;
			$_ =~ s/\s*$//;
			print "$_\n";
		}
	}
}
