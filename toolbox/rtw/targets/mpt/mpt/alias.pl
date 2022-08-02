# $Revision: 1.3 $
#
#  alias('file.c','aliaslist.al ')
#

open (INFILE, "$ARGV[0]") or die ("Cannot open file $ARGV[0]: $!\n");
@parms = <INFILE>;
close (INFILE);

open (MATCHFILE, "$ARGV[1]") or die ("Cannot open match file $ARGV[1]: $!\n");
@match = <MATCHFILE>;
close (MATCHFILE);

foreach $match (@match)
{
  ($list,$aliaslist,$rest) = split(" ",$match);
   foreach(@parms){ s/\b$list(?!\.)\b/$aliaslist/xg}
}
open (OUTFILE, ">$ARGV[0]");
print OUTFILE @parms;    # print name field to file  
close (OUTFILE);
exit();