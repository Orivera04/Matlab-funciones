# Abstract
#   Convert an S-Record file into a C file that can be compiled.
#
# $Revision: 1.2.6.2 $
# $Date: 2004/04/19 01:24:17 $ 
#
# Copyright 2002-2003 The MathWorks, Inc.

# Notes :
#
#   A structure will be generated of the following form
#
#   /* The decoding state table */
#   unsigned char state_table[][2];
#
#   /* The decoding symbol lookup */
#   unsigned char symbol_decoder[][2];
#
#   typedef struct {
#       unsigned int address;	   /* The address the data is to be loaded at */
#       const char * data;			/* This data is compressed */
#       unsigned int count;		/* The numbe of bytes is the data array */
#   } srecord;
#
#   SRecord srecord[] ; // An array of these structures
#
#   #define NUMBER_OF_RECORDS ??????


use huff

$srec_file_name = $ARGV[0];		# The name of the srecord to process
$target_file_name = $ARGV[1];	# The name of the target file to write out

# Gets a hash of addresses => data blocks for source data
%s_hash = read_in_srecord($srec_file_name); 

# Gets a hash of addresses => data blocks for compressed data
($c_hash, $huff ) = compress_s_record(\%s_hash); 

# Do not print this out in BAT as it may crash the build
# due to all the ascii characters being printed in a table
# $huff->print_symbol_hash();

open ( CFH,  ">$target_file_name.c" );

$cfh = *CFH;   # Create reference to C file handle

$hfh = open_header("$target_file_name.h");
print_c_data_record($c_hash, \%s_hash, $cfh, $hfh,"$target_file_name.h");
$huff->build_c_decoder($cfh,$hfh);

# Print the decode tree out the the header file
print $hfh "/***** HUFFMAN DECODE TREE \n\n";
$huff->print_tree($hfh);
print $hfh "****************************/\n\n";

close_header($hfh);

close (HFH);

#
# Opens the header file for output
#
sub open_header {
    my $name = shift;
    open ( HFH , ">$name" );

    $name =~ tr/a-z\./A-Z_/; 
    print HFH <<EOT;
/*

Copyright Mathworks 2002

Automatically Generated File.
DO NOT EDIT 

Copyright 2002 The MathWorks, Inc.
*/

#ifndef _${name}_
#define _${name}_
EOT
    $HFH = *HFH;
    return $HFH;
}

#
# Closes the header file
#
sub close_header {
    my $HFH = shift;

    print $HFH "#endif\n";
    close($HFH);
}

#
# Prints the compressed data record out to the C File
#
sub print_c_data_record{
    my $hash = shift;       # Compressed data
    my $s_hash = shift;     # Original data
    my $CFH = shift;        # File handle to C file
    my $HFH = shift;        # File handle to header file
    my $hfile = shift;

    # Generate the C file
    print $CFH <<END_PRINT;
    /* S-Record C image for file $srec_file_name
	 
	 Automatically Generated File
	 DO NOT EDIT
	 
    Copyright 2002 The MathWorks, Inc.
	 */
    #include \"${hfile}\"
    SRecord srecord[] = {
END_PRINT

    # Extract all the addresses in order from the hash
    # and then iterate over all the blocks writing
    # them out as C strings
	 @addresses = sort { $a <=> $b } keys %$hash;
    my $tmp=0;
    foreach $address ( @addresses ){
        print $CFH "," if $tmp == 1; # Comma at end of each record
        $tmp = 1;
        $data = %$hash->{$address};
        $data_len = length($data);
        $old_data_len = length(%$s_hash->{$address});

        # Turn the data blocks into sets of
        # quoted strings 32 characters wide
        $hex = unpack("H*",$data); 
        $hex =~ s/(..)/\\x\1/g;
        $hex =~ s/(.{64}|.+)/\t\t"\1"\n/g;

        $address = sprintf("0x%x",$address);


        $compression = 100 - $data_len / $old_data_len * 100;
    print $CFH <<END_PRINT
    { $address, 
      $hex\t,$data_len } /* $old_data_len -> $data_len => $compression % compression */
END_PRINT

    } # [ END ] foreach

    print $CFH "};\n";

    #
    # Define the S-Record data structure
    #

    $nrecords = @addresses;

    print $HFH <<EOT;

typedef struct {
    unsigned int address;
    const char * data;
    unsigned int count;
} SRecord;

/* The application image */
extern SRecord srecord [] ;

#define NUMBER_OF_RECORDS $nrecords


EOT
}

# SUB
# 	compress_s_record
#
# Purpose
# 	Compress the s_record 
#
# Arguments
# 	S-Record hash table as produced from read_in_srecord
#
# Returns
#  Compressed S-Record hash table
#  Huffman object
sub compress_s_record {
	my $s_hash = shift;     # Input S-Record hash

    # Initialize the huffman coder
	my @strings = values %$s_hash;
	$huff = HuffmanCoder->new();
	$huff->build_tree(\@strings);

    while ( ($address,$string) = each(%$s_hash) ){
        $huff->write_string($string);
        %c_hash->{$address} = $huff->close_write();
    }
    return (\%c_hash, $huff);
}

# SUB
# 	read_in_srecord
#
# Arguments
# 	filename	-	Should be the name of a valid SRecord file
#
# Returns
# 	A hashtable of addresses mapped to data blocks
#
# 	hash->{addresss} == string;
#
# 	
sub read_in_srecord {
	my $fname = shift;
	my @file;
	my @file;
	
	# Read the entire input SRecord
	open ( IFH,$fname);
	@file = <IFH>;
	close ( IFH );

	# Remove the header and trailer SRecords
	$header = shift(@file);
	$trailer = pop(@file);

	# Sort the file in accending address order
	@file = sort {
		($a_address)=($a=~/....(........)/);
		($b_address)=($b=~/....(........)/);
		$eval  = "0x$a_address <=> 0x$b_address";
		$x = eval("0x$a_address <=> 0x$b_address") ;
		$x
	} @file;


	# Combine the file into a structure of type
	# ( ( address, data ), ( address, data ), ..... )

	$next_address = -1;
	foreach $record ( @file) {
		( $address, $data ) = process_srecord_line($record);

		if ( $next_address != $address ){
			# The line is not contiguos with the last
			# one so we create a new block 
           $block_address = $address;
		    %blocks->{$block_address} = $data;
		}else{
		    %blocks->{$block_address} = join('',%blocks->{$block_address},$data);
		}

		# Calculate what the next SRecord address may be
		$next_address = $address + length($data);

	}
	return %blocks;
}

sub process_srecord_line {
	my $record = shift;   # Input the srecord line 

	($type,$count,$rest)=($record=~/(..)(..)(.*)/);

	# Extract the address part
	if ( $type =~ "S1" ){
		$addr_len = 2;
		($address,$rest)=($rest=~/(....)(.*)/);
	}elsif ( $type =~ "S2" ){
		$addr_len = 3;
		($address,$rest)=($rest=~/(......)(.*)/);
	}elsif ( $type =~ "S3" ){
		$addr_len = 4;
		($address,$rest)=($rest=~/(........)(.*)/);
	}else{
		die "Srecord lines of type $type are not supported by this program yet.";
	}

	# Extract the data and the checksum
	($data,$cs) = ( $rest =~ /(.*)(..)/ );
	# Convert the ascii hex data to raw data
	$data = pack("H*",$data);
	# Convert the ascii hex address to a real address
	$address = eval("0x$address");
	return ( $address, $data);
}
