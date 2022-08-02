function rna = dna2rna(dna)
%DNA2RNA converts a DNA sequence into an RNA sequence.
%
%   RNA = DNA2RNA(DNA) converts any thymine nucleotides in a DNA sequence
%   into uracil (T-->U).
%
%   SEQ is returned in the same format as DNA, so if DNA is an integer
%   sequence then so is SEQ.
%
%   Example:
%
%       dna2rna('ACGATGAGTCATGCTT')
%
%   See also REGEXP, RNA2DNA, STRREP.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.4.4.3 $  $Date: 2004/01/24 09:17:20 $

% If the input is a structure then extract the Sequence data.
if isstruct(dna)
    try
        dna = seqfromstruct(dna);
    catch
        rethrow(lasterror);
    end
end

if ~ischar(dna)
    rna = dna;
    return
end
if ~isempty(regexpi(dna,'u','once'))
    warning('Bioinfo:DNAContainsU','Sequence is not DNA. It contains one or more U characters.');
end

rna = strrep(dna,'T','U');
rna = strrep(rna,'t','u');

if ~isempty(regexpi(rna,'[^ACGURYKMSWBDHVN-]','once'))
    warning('Bioinfo:UnknownSymbols','Sequence contains unknown characters.');
end




