#!/usr/bin/perl -w
use Bio::SearchIO;
use strict;

# A sample BLAST parsing program based on the SearchIO.pm Bioperl module. Takes
# a list of BLAST report files and prints a list of the top hits from each
# report based on an arbitrary minimum score.

# Copyright 2003-2004 The MathWorks, Inc.
# $Revision: 1.1 $  $Date: 2004/03/29 17:57:02 $

# Set a cutoff value for the raw score.
my $min_score = 100;

# Take each report name and print information about the top hits.
my $seq_count = 0;
while ( defined($ARGV[0])) {
    my $breport = shift @ARGV;
    print "\n$breport\n";
    my $in = new Bio::SearchIO(-format => 'blast', 
                               -file   => $breport);
    my $num_hit = 0;
    my $short_desc;
    while ( my $result = $in->next_result) {
	while ( my $curr_hit = $result->next_hit ) {
	    if ( $curr_hit->raw_score >= $min_score ) {
		if (length($curr_hit->description) >= 60) {
		    $short_desc = substr($curr_hit->description, 0, 58)."...";
		} else {
		    $short_desc = $curr_hit->description;
		}
		print $curr_hit->accession, ", ",
		      $curr_hit->raw_score, ", ",
		      $curr_hit->significance, ", ",
		      $short_desc, "\n";
	    }
	    $num_hit++;
	}
    }
    $seq_count++;
}
