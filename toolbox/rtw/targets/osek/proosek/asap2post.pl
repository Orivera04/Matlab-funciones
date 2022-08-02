# File: asap2post.pl
#
# Abstract:
#   Replace MemoryAddress placeholders in ASAP2 file.
#   @MemoryAddress@varName@ ==> MemoryAddress(varName)
#
# $Revision: 1.1 $
# $Date: 2002/10/23 20:42:42 $
#
# Copyright 2002 The MathWorks, Inc.

$addrPrefix = "@" . "MemoryAddress" . "@";
$addrSuffix = "@";
$ASAP2FileName = $ARGV[0];
$MAPFileName   = $ARGV[1];
$outputFileName = "temp_" . $ASAP2FileName;
$indent = "";
%MAPFileHash = ();

# Read MAPFILE and convert to Hash Table.
# - Read MAPFILE
open(MAPFILE, $MAPFileName) 
  || die "PERL Error: Could not open MAP file: ", $MAPFileName, ".\n";
undef $/; 
$MAPFileString = <MAPFILE>; 
$/ = "\n";
close(MAPFILE);

# process line by line - match the reg. expr and build the hashtable.
@lines = split(/\n/,$MAPFileString);
foreach $line (@lines) {
    # for gcc line matches -- <bol><whitespace>0x<Address><whitespace><VariableName><eol>
    my $MatchPrefix  = '[\s]*';		# <whitespace>
    my $MatchAddress = '0x[0-9a-f]*';	# <Address> = String like: 0x03fdc
    my $MatchInfix   = '[\s]*';		# <whitespace>
    my $MatchSymbol  = '[\S]*';		# <VariableName> = Valid C Symbol like: TestSig
    my $MatchSuffix  = '';		# empty
    if ($line =~ /^$MatchPrefix($MatchAddress)$MatchInfix($MatchSymbol)$MatchSuffix$/) {
	# Create entry in hash $MAPFileHash{<VariableName>} = <Address>; 
        $MAPFileHash{$2} = $1;
    }
}

# Read ASAP2FILE and replace MemoryAddress placeholders.
# - Read ASAP2FILE
open(ASAP2FILE, $ASAP2FileName) 
  || die "PERL Error: Could not open ASAP2 file: ", $ASAP2FileName, "\n";
undef $/; $ASAP2FileString = <ASAP2FILE>; $/ = "\n";
close(ASAP2FILE);

# - Replace MemoryAddress placeholder with actual address from MAP file
$ASAP2FileString =~ s/$addrPrefix(\S*)$addrSuffix/($MAPFileHash {$1} || ($addrPrefix . $1 . $addrSuffix))/egs;

# Open ASAP2FILE for writing
open(OUTPUTFILE, (">" . $outputFileName)) 
  || die "PERL Error: Could not open output file: ", $outputFileName, "\n";
print OUTPUTFILE $ASAP2FileString;
close(OUTPUTFILE);

# Rename OUTPUTFILE (overwrites ASAP2FILE)
rename $outputFileName, $ASAP2FileName;
