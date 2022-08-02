function out=seq2regexp(seq,varargin)
%SEQ2REGEXP converts extended NT or AA symbols into a regular expression.
%
%   SEQ2REGEXP(SEQUENCE) converts extended nucleotide or amino acid symbols
%   in SEQUENCE into regular expression format.
%
%   SEQ2REGEXP(...,'ALPHABET',type) specifies whether the sequence is amino
%   acids ('AA') or nucleotides ('NT'). The default is NT.
%
%   IUB/IUPAC nucleic acid code conversions:
%
%   A --> A                   M --> [AC] (amino)
%   C --> C                   S --> [GC] (strong)
%   G --> G                   W --> [AT] (weak)
%   T --> T                   B --> [GTC]
%   U --> U                   D --> [GAT]
%   R --> [GA] (purine)       H --> [ACT]
%   Y --> [TC] (pyrimidine)   V --> [GCA]
%   K --> [GT] (keto)         N --> [AGCT] (any)
%
%   Amino acid conversions:
%
%   B --> [DN] 	aspartic acid or asparagine
%   Z --> [EQ]	glutamic acid or glutamine
%   X --> [ARNDCQEGHILKMFPSTWYV]
%
%   Example:
%
%      r = seq2regexp('ACWTMAN')
%
%   See also REGEXP, REGEXPI, RESTRICT, SEQWORDCOUNT.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.14.6.4 $  $Date: 2004/03/14 15:31:40 $

isAminoAcid = false;
isNucleotide = false;
if nargin > 1
    if rem(nargin,2) == 0
        error('Bioinfo:IncorrectNumberOfArguments','Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'alphabet',''};
    for j=1:2:nargin-2
        pname = varargin{j};
        pval = varargin{j+1};
        k = strmatch(lower(pname), okargs);
        if isempty(k)
            error('Bioinfo:UnknownParameterName','Unknown parameter name: %s.',pname);
        elseif length(k)>1
            error('Bioinfo:AmbigousParameterName','Ambiguous parameter name: %s.',pname);
        else
            switch(k)
                case 1
                    if strcmpi(pval,'aa')
                        isAminoAcid = true;
                    elseif  strcmpi(pval,'nt')
                        isNucleotide = true;
                    end

            end
        end
    end
end


out=upper(seq);

if ~isAminoAcid && (isNucleotide || isnt(seq))
    iub = cell(11,1);
    iub{1,1}={'R','[GA]'};
    iub{2,1}={'Y','[TC]'};
    iub{3,1}={'M','[AC]'};
    iub{4,1}={'K','[GT]'};
    iub{5,1}={'S','[GC]'};
    iub{6,1}={'W','[AT]'};
    iub{7,1}={'B','[GTC]'};
    iub{8,1}={'D','[GAT]'};
    iub{9,1}={'H','[ACT]'};
    iub{10,1}={'V','[GCA]'};
    iub{11,1}={'N','[AGCT]'};
    % leave gaps as -
    %iub{12,1}={'-','*'};

    for j=1:size(iub,1)
        out=strrep(out,iub{j,1}{1,1},iub{j,1}{1,2});
    end
elseif isAminoAcid || isaa(seq)
    iub = cell(3,1);
    iub{1,1}={'B','[DN]'};
    iub{2,1}={'Z','[EQ]'};
    iub{3,1}={'X','[ARNDCQEGHILKMFPSTWYV]'};

    for j=1:size(iub,1)
        out=strrep(out,iub{j,1}{1,1},iub{j,1}{1,2});
    end


end
