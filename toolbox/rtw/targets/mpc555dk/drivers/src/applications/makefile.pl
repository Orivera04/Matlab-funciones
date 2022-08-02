# File : makefile.pl
#
# Abstract :
# 	Perl script for generating makefile to 
# 	build all directories in the current directory
#
# $Revision: 1.1.6.2 $
# $Date: 2004/04/19 01:25:15 $
#
# Copyright 1990-2002 The MathWorks, Inc.



@directories = get_dirs('.');

print <<EOT;
.PHONY : all
all :
EOT
foreach $d ( @directories ) {
	print <<EOT;
	\@echo
	\@echo +======================================================================
	\@echo + Building directory [$d] {
	\@echo +======================================================================
	\@echo
	\@\$(MAKE) -C $d all
	\@echo
	\@echo +======================================================================
	\@echo + } Finished building directory [$d] 
	\@echo +======================================================================
	\@echo

EOT
}

print <<EOT;

.PHONY : clean
clean :
EOT
foreach $d ( @directories ) {
	print <<EOT;
	\@echo
	\@echo +======================================================================
	\@echo + Cleaning directory [$d] 
	\@echo +======================================================================
	\@echo
	\$(MAKE) -C $d clean
	\@echo
	\@echo +======================================================================
	\@echo + Finished cleaning directory [$d]
	\@echo +======================================================================
	\@echo
EOT
}

# Return a list of directories under the argument directory.
sub get_dirs {
	my $dir = shift;
	opendir(DIR,$dir);
	my @dir = grep(!/^\.{1,2}$|^CVS$/, readdir(DIR));
	closedir(DIR);
	my @new_dirs = grep( -d "$dir/$_" , @dir );
	return @new_dirs;
}
