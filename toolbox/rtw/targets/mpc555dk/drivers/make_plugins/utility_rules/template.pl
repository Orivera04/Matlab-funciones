# File : template.pl
#
# Provides a simple perl based template processor. 
#
# A template file with embedded perl ( See google => Template::Text )
# is given variable references read from a java style properties file.
# Note that within the template file { and } are used to deliniate
# perl blocks. To output { and } explicitly use \{ and \}
#
# Usage:
#
# perl template.pl -t=in.t -p=props.p -o=outfile.txt
#	
# Options
#		t	-	Name of the template file
#		p	-  Name of the properties file or a list of properties files seperated by semicolons
#		o	-	Name of the output file	
#
#  Example
#
#  Properties File
#  	title = Mr
#  	name  = Smith
#  
#  Template File
# 		Dear {$title} {$name},
#
# 		We are pleased to inform you that ...
#
#	Notes
#		The properties file can include other properties files. Add a
#		line to the properties file
#
#		include myfile.p
#
#		where myfile.p is the second properties file you wish to add.
#

# $Revision: 1.1.6.2 $
# $Date: 2003/12/11 03:48:36 $ 
# Copyright 2003 The MathWorks, Inc.

use Text::Template;
use Getopt::Long;

%opts = ();
GetOptions(\%opts, "p=s" , # Properties file
			 			 "t=s",  # Template file
			 			 "o=s",  # Output file
					 ) ;

$properties_files	= $opts{'p'};
$template_file 	= $opts{'t'};
$output_file 		= $opts{'o'};

@properties_files = split /;/,$properties_files;


# Define the global properties hash
%props = ();

# Fill out the properties hash
foreach $properties_file ( @properties_files ) { 
	readproperties($properties_file);
}

my $template = Text::Template->new(SOURCE => $template_file )
    or die "Couldn't construct template: $Text::Template::ERROR";

my $result = $template->fill_in(HASH => \%props);
if (defined $result) {
	if ( open FH, ">$output_file"){
		print FH $result;
		close FH;
	}else{
		die "Could not open $output_file for writing";
	}
} else {
    die "Couldn't fill in template: $Text::Template::ERROR"
}

# Read a Java style properties file
sub readproperties
{
    my ($propfile) = shift;
    my ($ln,$name,$value,@nv);
    
    open(PROPFILE,"$propfile") or die "Unable to open $propfile";
    while ($ln = <PROPFILE>)
	 {
		 chomp $ln;
		 $ln =~ s/#(.*$)//;    # Remove line comments in the properties file.
		 # if ($1 ne "") { print "# $1\n"; }  ### DEBUG ###
		 if ( $ln =~ /^\s*include/ ){
			 ($inc_file) = $ln =~/include\s*(.*)/;
			 if(open(_TMP,$inc_file)){
				 # The raw name of the file works
				 close(_TMP);
			 }else{
				 ( $current_path ) = $propfile =~ /(^.*[\/\\])/;
				 $mod_inc_file = "$current_path$inc_file";
				 if(open(_TMP,$mod_inc_file)){
					 $inc_file = $mod_inc_file;
					 close(_TMP);
				 }else{
					 die "Can't find included file $inc_file";
				 }
			 }
			 readproperties($inc_file);
		 }elsif ( $ln =~ /=/ ){
			 # An assignment
			 @nv = split /\s*=\s*/,$ln,2;
			 $value = pop @nv;
			 $value =~ s/^\s*=?\s*//;
			 $value =~ s/\s*$//;
			 $name = pop @nv;
			 $name =~ s/^\s*//;
			 $name =~ s/\s*$//;
			 if ($name ne "")
			 {
				 # Map a variable name to a value. For example if
				 # 
				 # $name = 'widget'
				 # $value = 10
				 # 
				 # then the below line will evaluate to
				 # $props{widget} = 10.
				 #
				 # This is the format the Template HASH parameter
				 # for fill_in should be in
				 $tmp = "\$props{$name} = \$value";
				 eval($tmp);
				 # print "$name=$value\n"; ### DEBUG ###
			 }
		 }
	 }
    close(PROPFILE);
}



