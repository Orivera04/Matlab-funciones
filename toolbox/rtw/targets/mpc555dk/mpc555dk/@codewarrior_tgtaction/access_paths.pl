# $Revision: 1.1 $
# File : grouplist.pl
#
# Abstract :
#
# 	Given an input list of files generate the UserSearchPaths section
# 	of the CodeWarrior project import file
#
my %paths= ();

print "<SETTING><NAME>UserSearchPaths</NAME>\n";
while(<>){
	chomp;
	# Get just the path
	if ( $_ =~ /[\\\/]/ ){
		$_ =~ s/(^.*)[\\\/][^\\\/]*$/\1/;
		if ($paths{$_} !~ /found/ ){
			# This is a new path
			$paths{$_} = 'found';
			print <<EOT
<SETTING>
<SETTING><NAME>SearchPath</NAME>
<SETTING><NAME>Path</NAME><VALUE>$_</VALUE></SETTING>
<SETTING><NAME>PathFormat</NAME><VALUE>Windows</VALUE></SETTING>
<SETTING><NAME>PathRoot</NAME><VALUE>Absolute</VALUE></SETTING>
</SETTING>
<SETTING><NAME>Recursive</NAME><VALUE>false</VALUE></SETTING>
<SETTING><NAME>HostFlags</NAME><VALUE>All</VALUE></SETTING>
</SETTING>
EOT
		}
	}
}
print "</SETTING>\n";
