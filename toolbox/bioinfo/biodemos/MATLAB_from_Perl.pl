#!/usr/bin/perl -w
use Win32::OLE;

# Simple perl script to execute commands in MATLAB.
# Note the name Win32::OLE is misleading and ths actually uses COM!
#
# $Revision: 1.0 $ $Author: batserve $ $Date: 2004/01/24 09:20:29 $

# use existing instance if MATLAB is already running

eval {$ml = Win32::OLE->GetActiveObject('Matlab.Application')};
die "MATLAB not installed" if $@;
unless (defined $ml) {
   $ml = Win32::OLE->new('Matlab.Application')
      or die "Oops, cannot start MATLAB";
}

@commands = ("IRK = pdbread('pdb1irk.ent');",
             "LCK = pdbread('pdb3lck.ent');",
             "seqdisp(IRK)",
             "seqdisp(LCK)",
             "[Score, Alignment] = swalign(IRK, LCK,'showscore',1);");

# send a command to MATLAB
foreach $command (@commands)
{  $status = &send_to_matlab($command);
   print "MATLAB status = ", $status, "\n";

}
undef $ml; # closes MATLAB if we opened it

sub send_to_matlab
{  my ($command) = @_;
   my $status = 0;
   $result = $ml->Invoke('Execute', $command);
   print ">> $command\n";
   unless ($result =~ s/^.\?{3}/Error:/)
   {  print "$result\n" unless ($result eq "");
   }
   else
   {  print "$result\n";
      $status = -1;
   }
   return $status;
}

