# $Revision: 1.4 $
#
#  replace('file.c','matchlist.txt','user')
#      or
#  replace('file.c','matchlist.txt','base')
#
#

$type = @ARGV[2];

open (INFILE, "$ARGV[0]") or die ("Cannot open file $ARGV[0]: $!\n");
@parms = <INFILE>;
close (INFILE);

open (MATCHFILE, "$ARGV[1]") or die ("Cannot open match file $ARGV[1]: $!\n");
@match = <MATCHFILE>;
close (MATCHFILE);

foreach $match (@match)
{
 ($old,$new,$base,$rest) = split(" ",$match);
 if( $type eq "user" )
    {
      foreach(@parms){$tst = s/\b$old(?!\.)\b/$new/xg; if($tst==1){print "$new ";}}
    }
 elsif( $type eq "base" )
    {
      foreach(@parms){ s/\b$old(?!\.)\b/$base$rest/xg}
    }
 else
    {
    }
 }
 
open (OUTFILE, ">$ARGV[0]");
print OUTFILE @parms;    # print name field to file  
close (OUTFILE);
exit();