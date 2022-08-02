# File: buildlib.pl
#
# Abstract:
#   Make a library or set of libraries from a directory
#   of object files
#
# Usage
#
#   perl buildlib.pl "d:\applications\diab\bin\dar.exe -r" "d:\project\objdir\*.o" "mylib.a" 
#   
# Notes
#
# 	 If the number of object files in a directory exceeds 50 then multiple libraries will be
# 	 built. For example if the name of your desired library is "mylib.a" then extra libraries
# 	 called
#
# 	 mylib1.a
# 	 mylib2.a
# 	 mylib3.a
#
# 	 etc will be created for every 50 extra files. This is to get round the fact that some
# 	 library archivers cannot append files to a current library and that the DOS command
# 	 line is only so long. If you have 500 files to archive then it doesn't work sometimes.
#
# $Revision: 1.2 $
# $Date: 2002/12/10 17:01:05 $
#
# Copyright 2002 The MathWorks, Inc.

my $libCmd 		= shift @ARGV; # The command to build the library. eg "dar -r"
my $objGlob 	= shift @ARGV; # Glob pattern to recognize files. eg "*.o" or "*.obj"
my $libName 	= shift @ARGV; # Name of the library. eg "mylib.a"

print "-----------------------------------\n";
print "libcmd = $libCmd\n";
print "objGlob = $objGlob\n";
print "libName = $libName\n";

# Get the list of object files from the directory then
# break them into subgroups 50 items long
@objects = glob("$objGlob");
$groups = break_down(\@objects,50);
print "object = @objects\n";
print "-----------------------------------\n";

# Delete library before rebuilding it
$libsToDelete = $libName;
$libsToDelete =~ s/\.(.*)/\*.\1/; # turn mylib.a into mylib*.a
print "Deleting Libraries => $libsToDelete\n";
unlink glob($libsToDelete);


# Process each group and for each group
# build a library ceilingd on the library
# name requested.
$length = $#$groups + 1;
for ( $i = 0; $i<$length; $i++ ){
	$group = $groups->[$i];
	$libNameInc = $libName;
	if ($i > 0){
		$libNameInc =~ s/\.(.*)/$i.\1/;
	}
	print "$libCmd  $libNameInc @$group\n";
	print `$libCmd  $libNameInc @$group\n`;
}



# Return a list regrouped into smaller sublists
# @param list The primary list reference
# @param group_size The size of each group
sub break_down {

	my $list = shift;				# The complete list
	my $group_size = shift;		# The size to be of the sub lists

	# Initialize the groups list
	@_tmp = ();
	$groups = \@_tmp;

	# Initialize the iteration
	$ceiling = $group_size;	
	$group = 0;
	$length = $#$list + 1;		
	for($i=0; $i<$length; $i++){
		if($i>$ceiling){
			# Create a new group
			$ceiling+=$group_size;
			$group++;
		}
		# Add the current item to the current group
		$tmp = $groups->[$group];
		unshift @$tmp,  $list->[$i];
		$groups->[$group] = $tmp;
	}
	return $groups;
}

