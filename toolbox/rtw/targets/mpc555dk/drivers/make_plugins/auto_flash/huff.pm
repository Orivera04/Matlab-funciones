# File : huff.pm
#
# Abstract :
# 	Perl module for a huffman compressions algorithms.
#
# $Revision: 1.1.4.1 $
# $Date: 2004/04/19 01:24:13 $
#
# Copyright 1990-2002 The MathWorks, Inc.
#
#
package HuffmanCoder;
use strict;

#####################################################
#  Class
#   HuffmanCoder
#
#  Public Methods
#   new()
#       Create a new Huffman coder
#   build_tree($array_of_strings)
#   write_string($string)
#       Write a string to the output stream
#   write_array_of_strings($array_of_strings)
#       Write an array of strings to the output stream
#   close_write()
#       Close the output stream. No more write are allowed. It returns the compressed string
#   get_stream_as_string()
#       Return a string representing the compressed stream
#   print_tree()
#       Prints the huffman coding tree to the STDOUT
#   print_symbol_hash()
#       Prints the huffman symbol table to the STDOUT
#   build_decoding_tables()
#      Returns the decoding tables necessary for a single bit at a time
#       state machine based decoder
#
#  Private Methods
#   create_histogram(@array_of_strings)    
#       Creates a histogram of symbol occurances in the array_of_strings
#   create_huff_tree()
#       Processes the histogram to generate a huffman binary tree
#   create_symbol_table_from_tree() 
#       Processes the huffman tree to generate a compression symbol lookup
#
#

#
# Arguments 
#   Create the symbol output stream
#
sub new  {
    shift;
    my $self = {};
    my $self = {
        STREAM  => [],      # (ARRAY reference)  The byte output array
        TREE    => undef,   # (ARRAY reference ) Huffman encoding tree
        HIST    => undef,   # (HASH reference )  The histogram
        SYMBOLS => undef,   # (HASH reference )  The huffman symbol table
        BUFFER  => ""       # (STRING scalar )   A buffer of bits not yet written
    };
    bless($self);
    return $self;
}

#
# Use an input text array to build a
# symbol table
#
sub build_tree {
    my $self  = shift;       # Object self reference
    my $array = shift;       # Array of strings to process

    $self->create_histogram($array); 
    $self->create_huff_tree();
    $self->create_symbol_table_from_tree();
    
}

#
# Write a array of strings to the output stream
#
sub write_array_of_strings {
    my $self = shift;
    my $array = shift;
    my $line;

    foreach $line ( @$array ) {
        $self->write_string($line);
    }
}


#
# Write a single string
#
sub write_string {
    my $self = shift;
    my $symbols = shift;    #   Symbol string to pack
    my $bits;
    my @symbol_array;
    
    @symbol_array = split(//,$symbols);
    foreach (@symbol_array) {
        $self->write_symbol($_);
    }
}

my $symcount= 0;
#
# Write a single symbol
#
sub write_symbol {
    my $self = shift;
    my $symbol = shift;
    my $nextbyte;
    my $x;

    my $bits = $self->{SYMBOLS}->{$symbol};
    $self->{BUFFER} = join('',$self->{BUFFER},$bits);
    if (length($self->{BUFFER}) >= 8 ) {
        # Extract the next 8 bits and write to the stream
        ( $nextbyte, $self->{BUFFER} ) = $self->{BUFFER} =~ /(........)(.*)/;
        my $x = $self->{STREAM};
        push @$x, pack("B*",$nextbyte);
    }
}

sub close_write {
    my $self = shift;
    my $len;

    #
    # Fill out then write the last partially constructed byte
    #

    $len = 8 - length($self->{BUFFER});
    if ( $len < 8 ) {
        $self->{BUFFER} = join( '', $self->{BUFFER}, "0" x $len );
        my $x = $self->{STREAM};
        push @$x, pack("B*",$self->{BUFFER});
    }
    $self->{BUFFER} = "";

    #
    # Get a string representation of the compressed stream
    #
    my $compressed_stream = get_stream_as_string();

    #
    # Clear the stream
    #
    $self->{STREAM} = [];

    #
    # Return the compressed data
    #
    return $compressed_stream;


    sub get_stream_as_string{
        my $stream;
        $stream = $self->{STREAM}; 
        return join('',@$stream);
    }
}


# Count the symbols.
#
# Arguments
#   @file - Array of strings representing all the data in the file
#   
# Returns
#   %hist - A histogram hash table keying symbols to number of occurances
#
sub create_histogram {
    my $self = shift;

    my($file) = shift @_;  # An array of strings reference
    my $line;
    my @l_array;
    my %hist;

    foreach $line ( @$file ) {
        @l_array = split(//,$line);
        foreach (@l_array) {
            %hist->{$_}++;
        }
    }

    delete %hist->{''};

    $self->{HIST} = \%hist;

}


#
# Create the huffman tree
#
sub create_huff_tree {

    my $self  = shift;
    my $hist = $self->{HIST};

    #
    # Local Variables
    #
    my $key;
    my $value;
    my $len;
    my @node;
    my @heap;
    my $tree;

    #
    # Convert the histogram hash into a list of nodes
    #
    while ( ($key,$value) = each(%$hist) ){
        @node = ( "leaf", undef, undef, $value , $key );
        push @heap, [ @node ];
    }


    #
    # Convert the list into a huffman tree by repeatadly
    # sorting and replace the two smallest elements with
    # a single nodes that has the combinded weight of the
    # two child nodes
    #
    $len = @heap;
    while ($len > 1){
        # Sort the heap by frequency of node
        @heap = sort {
            @$a[3] <=> @$b[3];
        } @heap ; 

        # Take the two smallest elements off the heap
        my $na = shift @heap;
        my $nb = shift @heap;

        # Combine them into a new node with their frequency values
        # equal to the sum of the two child nodes
        $tree = [ "node", $na , $nb , $na->[3] + $nb->[3] ];
        push @heap, $tree; 

        $len = @heap;
    }

    $self->{TREE}=$tree;
}



#
# Generate symbol hash table
#
# This traverses the tree and creates a mapping
# between the 8 bit character and a bit string
# representing the symbol
#
# 'a' => "011001101"
#
sub create_symbol_table_from_tree{

    my $self = shift;
    my %hash; 

    sub tree_processor {
        my $node = shift;
        my $bitpattern = shift; 

        if($node->[0] eq "node"){
            
            # Get the two sub hashes
            tree_processor($node->[1],"${bitpattern}0");
            tree_processor($node->[2],"${bitpattern}1");

        }else{
            
            # Process a leaf node
            %hash->{$node->[4]} = $bitpattern;

        }

    }

    tree_processor($self->{TREE},"");

    $self->{SYMBOLS} = \%hash;
}



#
# #####################################################
#              
#              DISPLAY AND PRINTING FUNCTIONS
#
# ####################################################
#

#
# Print up a textual display of the huffman trie
#
sub print_tree{

    my $self = shift;
    my $FH = shift;

    sub _print_tree {

        my $xnode = shift;
        my $indent = shift;
        my $bitpattern = shift;

        if(@$xnode[0] eq "node" ){
            print $FH "$indent--+-";
            print $FH "($xnode->[3])\n";
            _print_tree($xnode->[1],"$indent  |","${bitpattern}0");
            _print_tree($xnode->[2],"$indent   ","${bitpattern}1");
        }else{
            print $FH "${indent}----";
            my $hex = sprintf("0x%x",ord($xnode->[4]));
            print $FH "'$hex'=>$bitpattern\n";
        }
    }

    _print_tree($self->{TREE},"","");
}

#
# Print the symbol table
#
# Displays the mappings betweent the symbol and the bit pattern
#
sub print_symbol_hash {

    my $self = shift;

    my $symbol_hash  = $self->{SYMBOLS}; # Reference to a hash table
    my $freq_hash  = $self->{HIST};     # Refernece to a hash table


    my $sum = 0;
    my $n = 0;
    my $c;
    my $b;

    while ( ($c,$b) = each(%$symbol_hash)){
        my $l = length($b);
        my $character_occurance = $$freq_hash{$c};
        $n+=$character_occurance;
        $sum += $l * $character_occurance;
        my $cc = sprintf("%x",ord($c));
        print "$c:$cc($character_occurance) \t=> $b\n";
    }

    $c = $sum / $n;
    print "Bits per character = $c\n";
}


#
# Build the decoding tables required to build
# a state machine based decoder. 
#
# The decode tables consist of a state transition
# table listing all internal nodes in the huffman
# tree as a value between 0 and 254 and a symbol
# lookup table for all internal to leaf transitions.
#
sub build_decoding_tables {

    # Some notation
    #
    # Internal0 nodes are nodes that have at least one transition to a leaf
    # Internal1 nodes are nodes that only have transitions to other internal nodes
    #
    # The tree is traversed recursively and the nodes are added to a list only
    # when both their transitions have been recursively processed. Two lists
    # are maintained. One list is for internal0 nodes and the other for internal1 nodes.
    #
    # when a transition is processed it returns a state id. If the state id is -ve
    # then it is an internal1 node. If the state id is +ve then it is an internal0 node.
    # If the state id is 0 then it is a leaf node.
    #
    # When adding a node to either internal0 or internal1 lists they are
    # added to the end of the list. The entry comprises the state id's of
    # the left and right node.

    my $self = shift;

    my @symbol_decode = ();

    my @internal_0_state_table = ();
    my @internal_1_state_table = ();

    my $internal_0_state_id = 0;               
    my $internal_1_state_id = 0;

    my $state;
    my $state_id;
    my $symbols;


    #
    # Make the top of the tree state 0
    #
    if ( build_decoder($self->{TREE}) < 0 ){
        # Top of the tree is an internal 1 node
        $state = pop @internal_1_state_table;
        $symbols = [ chr(0) , chr(0) ]; # Just dummy values
        print "############### INTERNAL 1 ##\n";
    }else{
        # Top of the tree is an internal 0 node
        $state = pop @internal_0_state_table;
        $symbols = pop @symbol_decode;
        print "############### INTERNAL 0 ##\n";
    }
    unshift @internal_0_state_table , $state;
    unshift @symbol_decode,$symbols;


    #
    # Merge the internal 0 and internal 1 nodes
    #
    my $length = @internal_0_state_table;
    push @internal_0_state_table, @internal_1_state_table;

    my $idx = 0;
    foreach $state ( @internal_0_state_table) {
        my $left_state = @$state[0];
        my $right_state= @$state[1];
        if ($left_state < 0){
            $left_state = -$left_state + $length - 1 ;
        }
        if ($right_state < 0){
            $right_state = -$right_state + $length - 1 ;
        }
        @internal_0_state_table[$idx]=[$left_state,$right_state];
        $idx ++;
    } 

    return ( \@internal_0_state_table, \@symbol_decode );

    sub build_decoder{
        my $node = shift;
        my $state_id;

        if(!isleaf($node)){
            my $left = $node->[1];
            my $right= $node->[2];

            my $left_state_id =  build_decoder($left);
            my $right_state_id = build_decoder($right);

            #
            # Test to see if we need to add to the decode
            # table
            #
            $node = [ $left_state_id, $right_state_id ] ;
            if ( ($left_state_id == 0) or ($right_state_id == 0) ) {
                #
                # Internal 0 Node
                #
                
                my $left_sym = $left->[4];
                my $right_sym = $right->[4];
                push @symbol_decode, [ $left_sym , $right_sym ]; 

                push @internal_0_state_table, $node;

                $state_id = ++$internal_0_state_id;

            }else{
                #
                # Internal 1 Node
                #

                push @internal_1_state_table, $node;

                $state_id = --$internal_1_state_id;

            }

        }else{
            $state_id = 0;
        }

        return $state_id;
    }


    sub isleaf(){
        my $node = shift;
        if ( $node->[0] eq "leaf" ) {
            return 1;
        }else{
            return 0;
        }
    }

}

#
# Build a C Decoder
#
# 
#
#
sub build_c_decoder {
    my $self = shift;
    my $CFH = shift;    # File handle to print this to
    my $HFH = shift;   # Header File handle to print this to

    my ($state_table, $symbol_decode_table ) = $self->build_decoding_tables();
    my $c;
    my $state;

    #
    # Print out the extern declerations
    #
    print $HFH <<EOT;
extern unsigned char state_table[][2];
extern unsigned char symbol_decode[][2];
EOT
    
    
    #
    # Print out the symbol decode table
    #
    print $CFH "/* The state transition table for the huffman decode tree */\n";
    print $CFH "unsigned char state_table[][2] = { \n";
    my $state_idx = 0;
	 foreach $state (  @$state_table ) {
		 print $CFH "\t$state->[0], \t$state->[1], /* $state_idx */\n";
		 $state_idx ++;
	 }
    print $CFH "};\n\n";

    #
    # Print out the state transition table
    #
    print $CFH "/* The symbol lookup table for decode transitions */";
    print $CFH "unsigned char symbol_decode[][2] = { \n";
    $state_idx = 0;
    foreach $state ( @$symbol_decode_table ) {
        my $c0 = sprintf('\x%x',ord($state->[0]));
        my $c1 = sprintf('\x%x',ord($state->[1]));
        print $CFH "\t'$c0',\t'$c1', /* $state_idx */\n";
        $state_idx ++;
    }
    print $CFH "};\n\n";
}

1;
