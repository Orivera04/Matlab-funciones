# Name of the makefile to open
my $makefile = shift;

$opened = open ( FH , $makefile ) );

die "Could not open $makefile" if !$opened;

@text = <FH>;
@newtext = ();

print "Cleaning up $makefile\n";
$changed = 0;
for $s  ( @s ) { 
	$old = $s;
	$s =~ s/(?<!\\)\\(?!($|\\))/\//g;
	if ( $s ne $old ){
		$changed = 1;
	}
	push @newtext, $s;
}

close FH;

if ( $changed ){
	$opened = open ( FH, ">$makefile" );
	die "Could not open $makefile for writing" if !$opened;
	print FH,@newtext;
	close FH;
}
print "Cleaned up $makefile\n";


