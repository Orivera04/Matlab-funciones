function dnarc = seqrcomplement(dna)
%SEQRCOMPLEMENT returns the reverse complementary strand of a DNA sequence.
%
%   SEQ = SEQRCOMPLEMENT(DNA) calculates the reverse complementary strand 
%   3' --> 5' (A-->T, C-->G, G-->C, T-->A) of sequence DNA.
%
%   SEQ is returned in the same format as DNA, so if DNA is an integer
%   sequence then so is SEQ.
%
%   Example:
% 
%       % Create a random sequence of nucleotides and the reverse complement.
%       seq = randseq(25)
%       revcompseq = seqrcomplement(seq)
%
%   See also CODONCOUNT, PALINDROMES, SEQCOMPLEMENT, SEQREVERSE.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.3.4.3 $  $Date: 2004/03/14 15:31:41 $

dnarc = seqreverse(seqcomplement(dna));




