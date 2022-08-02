# $Revision: 1.3 $

open (INFILE, "$ARGV[0]") or die ("Cannot open file $ARGV[0]: $!\n");
@parms = <INFILE>;
close (INFILE);

foreach(@parms){ s/\%\<(\w+)\>/$\%\<SLibMPMResolveSymbol\(fileIdx,"$1\")\>/xg}
 

$outfile = @ARGV[0];
print "$outfile \n";
($tmp,$ext,$rest) = split(/\./,$outfile);

$temp1 = ".";
$outfile = $tmp.$temp1.$ext;
print "$outfile \n";
open (OUTFILE, ">$outfile");
print OUTFILE @parms;    # print name field to file  
close (OUTFILE);
exit();