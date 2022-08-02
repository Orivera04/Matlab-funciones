function [outval,carray] = codoncount(dna,varargin)
%CODONCOUNT report codon counts for a sequence.
%
%   CODONCOUNT(SEQ) counts the number of occurrences of each codon in the
%   sequence and displays a formatted table of the result.
%
%   CODONS = CODONCOUNT(SEQ) returns these codon counts in a structure with
%   the fields AAA,AAC,AAG,..., TTG,TTT. If other characters are present in
%   the sequence, then a warning is given and the field Others is added to
%   the structure containing the number of undetermined codons found in the
%   sequence.
%
%   [CODONS, CARRAY] = CODONCOUNT(SEQ) returns a 4x4x4 array of the raw
%   count data for each codon. The three dimensions correspond to the three
%   positions in the codon. For example the (2,3,4) element of the array
%   gives the number of CGT codons where A <=> 1, C <=> 2, G <=> 3, and
%   T <=> 4.
%
%   CODONCOUNT(...,'FRAME',F) returns the codon count for reading frame
%   F, where F is 1, 2, or 3.
%
%   CODONCOUNT(SEQ, ... ,'REVERSE',true) returns the codon count for the
%   reverse complement of SEQ.
%
%   CODONCOUNT(SEQ, ... ,'FIGURE',true) creates a figure showing a heat map
%   of the codon counts.
%
%   Examples:
%
%       codons = codoncount('AAACGTTA')
%
%       r2codons = codoncount('AAACGTTA','Frame',2,'Reverse',true)
%
%   See also AACOUNT, BASECOUNT, BASELOOKUP, DIMERCOUNT, NMERCOUNT,
%   SEQRCOMPLEMENT, SEQSHOWORFS, SEQWORDCOUNT.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.15.6.7 $  $Date: 2004/03/14 15:31:16 $

reverseComp = false;
frame = 1;
showFig = false;

% If the input is a structure then extract the Sequence data.
if isstruct(dna)
    try
        dna = seqfromstruct(dna);
    catch
        rethrow(lasterror);
    end
end

% Get a copy for analyzing ambiguous and undefined characters
copy_dna = dna;

if nargin > 1
    if rem(nargin,2)== 0
        error('Bioinfo:IncorrectNumberOfArguments',...
            'Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'frame','reverse','figure'};
    for j=1:2:nargin-2
        pname = varargin{j};
        pval = varargin{j+1};
        k = strmatch(lower(pname), okargs);
        if isempty(k)
            error('Bioinfo:UnknownParameterName',...
                'Unknown parameter name: %s.',pname);
        elseif length(k)>1
            error('Bioinfo:AmbiguousParameterName',...
                'Ambiguous parameter name: %s.',pname);
        else
            switch(k)
                case 1  % frame
                    if ~isnumeric(pval) || pval > 3 || pval < 1
                        error('Bioinfo:BadFrameNumber',...
                            'Unrecognized frame number.')
                    end
                    frame = pval;
                case 2  % direction
                    reverseComp = opttf(pval);
                    if isempty(reverseComp)
                        error('Bioinfo:InputOptionNotLogical',...
                            '%s must be a logical value, true or false.',...
                            upper(char(okargs(k))));
                    end
                case 3  % figure
                    showFig = opttf(pval);
                    if isempty(showFig)
                        error('Bioinfo:InputOptionNotLogical',...
                            '%s must be a logical value, true or false.',...
                            upper(char(okargs(k))));
                    end
            end
        end
    end
end
if ischar(dna)
    dnai = nt2int(dna,'unknown',5,'acgtonly',true);
else
    dna(dna == 0) = 5;
    dna(dna > 5) = 5;
    dnai = dna;
end

if reverseComp
    dnai = seqrcomplement(dnai);
end

% Use 3D indexing to count the codons
codons = zeros(5,5,5);

ldnai = length(dnai);
for count = frame:3:ldnai-2
    codons(dnai(count),dnai(count+1),dnai(count+2)) = codons(dnai(count),dnai(count+1),dnai(count+2)) + 1;
end

labelcount = 0;
validcodons = 0;
labels = cell(1,64);
for first = 1:4
    for second = 1:4
        for third = 1:4
            codon = int2nt([first second third]);
            labelcount = labelcount + 1;
            labels{labelcount} = codon;
            output.(codon) = codons(first,second,third);
            validcodons = validcodons + codons(first,second,third);
        end
    end
end

% handle any other characters that were in the sequence.
others = sum(sum(sum(codons))) - validcodons;
if others > 0
    output.Others = others;
    if isnumeric(copy_dna)
        copy_dna = int2nt(dna);
    end
    undf_b = upper(char(regexpi(copy_dna,'[RYKMSWBDHVN-]','match')));
    unkn_b = upper(char(regexpi(copy_dna,'[^ACGTURYKMSWBDHVN-]','match')));
    if undf_b >0
        warning('Bioinfo:OtherSymbols',...
        'Ambiguous symbols ''%s'' appear in the sequence. These will be in Others.',undf_b);
    end
    if unkn_b >0
        warning('Bioinfo:UnknownSymbols',...
        'Unknown symbols ''%s'' appear in the sequence. These will be in Others.',unkn_b);
    end
end

% Create pretty output when no outputs.
if nargout == 0
    numSpaces = ceil(log10(max(codons(:))));
    formatString = sprintf('%%s - %%%dd     ',numSpaces);
    output = '';
    for outer = 0:3
        for middle = 0:3
            for inner = 1:4
                step = 16 * outer + 4 * middle + inner;
                output = [output, sprintf(formatString,labels{step},codons(outer+1,middle+1,inner))];
            end
            output = [output,sprintf('\n')];
        end
    end

    if others > 0
        output = [output, sprintf('Others - %d\n',others)];
    end
    disp(output);
else
    outval = output;
end
if nargout == 2 || showFig
    carray = codons(1:4,1:4,1:4);
end

if showFig
    im = [squeeze(carray(1,:,:)), squeeze(carray(2,:,:));
        squeeze(carray(3,:,:)), squeeze(carray(4,:,:))];

    imagesc(im);
    axis off;
    colormap(bone);
    colorbar;
    pos = [1,1;5,1;1,5;5,5];
    t = ['A','C','G','T'];
    for i = 1:4
        for j = 0:3
            for k = 0:3
                text(pos(i,1)+j,pos(i,2) +k,[t(i),t(k+1),t(j+1)],...
                    'color','r','horizontalAlignment','center');
            end
        end
    end
end

