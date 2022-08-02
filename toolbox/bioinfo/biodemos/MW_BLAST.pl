#!/usr/bin/perl -w
use Bio::Tools::Run::RemoteBlast;
use strict;

# A sample Blast program  based on the RemoteBlast.pm Bioperl module. Takes
# parameters for the BLAST search program, the database, and the expectation
# or E-value (defaults: blastp, pdb, 1e-10), followed by a list of FASTA files
# containing sequences to search.

# Copyright 2003-2004 The MathWorks, Inc.
# $Revision: 1.1 $ $Author: batserve $ $Date: 2004/01/24 09:20:29 $

# Retrieve arguments and set parameters
my $prog = shift @ARGV;
my $db   = shift @ARGV;
my $e_val= shift @ARGV;

my @params = ('-prog' => $prog,
	      '-data' => $db,
	      '-expect' => $e_val,
	      '-readmethod' => 'SearchIO' );

# Create a remote BLAST factory	          
my $factory = Bio::Tools::Run::RemoteBlast->new(@params);

# Change a paramter in RemoteBlast
$Bio::Tools::Run::RemoteBlast::HEADER{'ENTREZ_QUERY'} = 'Homo sapiens [ORGN]';

# Remove a parameter from RemoteBlast
delete $Bio::Tools::Run::RemoteBlast::HEADER{'FILTER'};

# Submit each file
while ( defined($ARGV[0])) {
    my $fa_file = shift @ARGV;
    my $str = Bio::SeqIO->new(-file=>$fa_file, '-format' => 'fasta' );    
    my $r = $factory->submit_blast($fa_file);

    # Wait for the reply and save the output file
    while ( my @rids = $factory->each_rid ) {
	foreach my $rid ( @rids ) {
	    my $rc = $factory->retrieve_blast($rid);
	    if( !ref($rc) ) {
    		if( $rc < 0 ) {
        	    $factory->remove_rid($rid);
            }
            sleep 5;
	    } else {
            my $result = $rc->next_result();
            my $filename = $result->query_name()."\.out";
            $factory->save_output($filename);
            $factory->remove_rid($rid);
            }
        }
    }
}
