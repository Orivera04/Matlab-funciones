function dna = rna2dna(rna)
%RNA2DNA converts an RNA sequence into a DNA sequence.
%
%   rna = RNA2DNA(DNA) converts any uracil nucleotides in an RNA sequence
%   into thymine (U-->T).
%
%   SEQ is returned in the same format as DNA, so if DNA is an integer
%   sequence then so is SEQ.
%
%   Example:
%
%       rna2dna('ACGAUGAGUCAUGCUU')
%
%   See also DNA2RNA, REGEXP, STRREP.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.4.4.3 $  $Date: 2004/01/24 09:18:55 $

% If the input is a structure then extract the Sequence data.
if isstruct(rna)
    try
        rna = seqfromstruct(rna);
    catch
        rethrow(lasterror);
    end
end
if ~ischar(rna)
    dna = rna;
    return
end

if ~isempty(regexpi(rna,'t','once'))
    warning('Bioinfo:RNAContainsT',...
        'Sequence is not RNA. It contains one or more T characters.');
end

dna = strrep(rna,'U','T');
dna = strrep(dna,'u','t');

if ~isempty(regexpi(dna,'[^ACGTRYKMSWBDHVN-]','once'))
    warning('Bioinfo:UnknownSymbols',...
        'Sequence contains unknown characters.');
end



