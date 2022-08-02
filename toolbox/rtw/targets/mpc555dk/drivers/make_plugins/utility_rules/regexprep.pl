# File : regexprep.pl
#
# Abstract :
#
# 	Simple perl script to perform regular expression
# 	replacement on an input string
#
# Usage
#
# 	perl regexprep.pl "my dog and cat are my friends" "dog.*cat" "goldfish"
#
# 	my goldfish are my friends
#
# $Revision: 1.1 $
# $Date: 2002/10/28 11:28:09 $
#
# Copyright 2002 The MathWorks, Inc.
$string = shift ARGV;
$pattern = shift ARGV;
$replace = shift ARGV;

$string =~ s/$pattern/$replace/g;

print $string;

