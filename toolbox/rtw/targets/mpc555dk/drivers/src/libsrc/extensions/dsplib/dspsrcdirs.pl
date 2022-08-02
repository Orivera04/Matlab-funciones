# File : dspsrcdirs.pl
#
# Abstract :
# 
# 	Creates a file list of sub dirs from an input dir 
#
# Usage
#
# 	perl dspsrcdirs.pl outputfile.mk d:/Aetargets/matlab/dirx
#
# $Revision: 1.1.6.1 $
# $Date: 2004/03/15 22:23:23 $
#
# Copyright 2004 The MathWorks, Inc.
$outputfile = shift(@ARGV);
$inputdir   = shift(@ARGV);

# header for the output file
$fileheader = "# $outputfile: Generated Makefile\n\n# Contains list of DSP SRC DIRS - DO NOT MODIFY\n\n";

# empty array for file list
@files = ();
opendir(DIR, $inputdir) || die "input dir not found: $!";
while ($name = readdir(DIR)) {
   # process dir entry
   push(@files, "$inputdir/$name");
}
closedir(DIR);

$newfile = $fileheader."DSPSRCDIRS :=";
$oldfile = "";
$writefile = 0;

$counter = 0;
# create dir list
foreach $file (@files) {
  # only interested in dirs
  if (-d $file) {
     # skip CVS dir
     if (! (($file =~ /CVS/) || ($file =~ /\./)) ) {
        # remove MATLABROOT
        $file =~ /matlab\/(.*)/;
        $newfile = "$newfile \\\n\t$1";
        $counter = $counter + 1;
     }
  }
}

if ($counter < 30) {
   die "Not found enough DSP src dirs!";
}

# if output file exists, read and compare
if (-e $outputfile) {
   open (FHANDLE, $outputfile);
   while (<FHANDLE>) {
      $oldfile = "$oldfile$_";
   }
   close(FHANDLE);
   if ($oldfile ne $newfile) {
      $writefile = 1;     
   }
}
else {
   $writefile = 1;
}

if ($writefile) {
   print("Updating file $outputfile");
   open(FHANDLE,">$outputfile");
   print FHANDLE $newfile;
   close(FHANDLE);
}
else {
   print("Not updating file $outputfile");
}
