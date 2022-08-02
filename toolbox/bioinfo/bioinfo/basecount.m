function bases = basecount(dna,varargin)
%BASECOUNT reports nucleotide counts for a sequence.
%
%   BASECOUNT(SEQ) counts the number of occurrences of each nucleotide in
%   the sequence and returns these numbers in a structure with the fields
%   A, C, G, T. If other characters are present in the sequence, then a
%   warning is given and the field Others is added to the structure.
%
%   BASECOUNT(...,'CHART',STYLE) creates a chart showing the relative
%   proportions of the nucleotides. Valid styles are 'Pie' and 'Bar'.
%
%   BASECOUNT(...,'OTHERS','FULL') counts all the standard nucleotide
%   symbols individually instead of bundling them all together into the
%   Others field of the output structure. Type doc basecount for a full
%   list of valid symbols.
%
%   BASECOUNT(...,'STRUCTURE','FULL') blocks the unknown characters warning
%   and includes 'Others' or the full list of valid symbols in the returned
%   results. The setting of the 'OTHERS' argument determines the format of
%   the results structure.
%
%   Example:
%
%       S = getgenbank('M10051')
%       basecount(S)
%
%   See also AACOUNT, BASELOOKUP, CODONCOUNT, DIMERCOUNT, NMERCOUNT,
%   NTDENSITY.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.16.6.8 $  $Date: 2004/03/14 15:31:14 $

pieChart = false;
barChart = false;
bundle = true;
others = false;
showall = false;

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

if  nargin > 1
    if rem(nargin,2)== 0
        error('Bioinfo:IncorrectNumberOfArguments',...
            'Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'chart','others','structure'};
    for j=1:2:nargin-2
        pname = varargin{j};
        pval = varargin{j+1};
        k = strmatch(lower(pname), okargs);%#ok
        if isempty(k)
            error('Bioinfo:UnknownParameterName',...
                'Unknown parameter name: %s.',pname);
        elseif length(k)>1
            error('Bioinfo:AmbiguousParameterName',...
                'Ambiguous parameter name: %s.',pname);
        else
            switch(k)
                case 1  % graph
                    if strcmpi(pval,'pie')
                        pieChart = true;
                    elseif strcmpi(pval,'bar')
                        barChart = true;
                    else
                        warning('Bioinfo:UnknownGraphType',...
                            'Unknown graph type.')
                    end
                case 2  % others
                    if strcmpi(pval,'full')
                        bundle = false;
                    end
                case 3  % structure
                    if strcmpi(pval,'full')
                        showall = true;
                    end
            end
        end
    end
end
[dummy, map] = nt2int('a'); %#ok
maxNtInt = double(max(map));
if ischar(dna)
    try
        dna = nt2int(dna,'unknown',maxNtInt+1);
    catch
        lasterr('');
        dna = regexprep(dna,'\W','?');
        dna = nt2int(dna,'unknown',maxNtInt+1);
    end
else
    dna(dna == 0) = maxNtInt+1;
end

% * A C G T U R Y K M S  W  B  D  H  V  N  -(gap)
% 0 1 2 3 4 4 5 6 7 8 9 10 11 12 13 14 15 16

%'a  b c  d e f g  h i j k l m  n o p q r s t u  v  w  x y z  -'
%[1 11 2 12 0 0 3 13 0 0 7 0 8 15 0 0 0 5 9 4 4 14 10 15 6 0 16]);

seqLength = length(dna);

buckets = zeros(1,maxNtInt+1);

for count = 1:seqLength
    buckets(dna(count)) = buckets(dna(count)) + 1;
end

bases.A = buckets(nt2int('a'));
bases.C = buckets(nt2int('c'));
bases.G = buckets(nt2int('g'));
bases.T = buckets(nt2int('t'));

if buckets(end)||any(buckets(5:end-1))
    if isnumeric(copy_dna)
    	copy_dna = int2nt(dna);
    end
end

if buckets(end)
    unkn_b = upper(char(regexpi(copy_dna,'[^ACGTURYKMSWBDHVN-]','match')));
    warning('Bioinfo:UnknownSymbols',...
        'Unknown symbols ''%s'' appear in the sequence. These will be ignored.',unkn_b);
end
if any(buckets(5:end-1)) | showall   % others exist or structure is 'full'
    others = true;
    if(bundle)
        bases.Others = sum(buckets(5:end-1));
        undf_b = upper(char(regexpi(copy_dna,'[RYKMSWBDHVN-]','match')));
        if ~showall
            warning('Bioinfo:OtherSymbols',...
                'Ambiguous symbols ''%s'' appear in the sequence. These will be in Others.',undf_b);
        end
    else
        bases.R = buckets(nt2int('r'));
        bases.Y = buckets(nt2int('y'));
        bases.K = buckets(nt2int('k'));
        bases.M = buckets(nt2int('m'));
        bases.S = buckets(nt2int('s'));
        bases.W = buckets(nt2int('w'));
        bases.B = buckets(nt2int('b'));
        bases.D = buckets(nt2int('d'));
        bases.H = buckets(nt2int('h'));
        bases.V = buckets(nt2int('v'));
        bases.N = buckets(nt2int('n'));
        bases.Gap = buckets(nt2int('-'));
    end
end

if pieChart
    if others
        if bundle
            buckets(5) = bases.Others;
            pie(buckets(1:5),{'A','C','G','T','Others'});
        else
            nonZero = (buckets(1:end-1)~=0);
            pielabels = num2cell(int2nt(find(nonZero)));
            pielabels = strrep(pielabels,'-','Gaps');
            pie(buckets(nonZero),pielabels);
        end
    else
        pie(buckets(1:4),{'A','C','G','T'});
    end
elseif barChart
    if others
        if bundle
            buckets(5) = bases.Others;
            h = bar(buckets(1:5));
            set(get(h,'parent'),'Xtick',1:5,'XTickLabel',{'A','C','G','T','Others'});
        else
            nonZero = (buckets(1:end-1)~=0);
            barlabels = num2cell(int2nt(find(nonZero)));
            barlabels = strrep(barlabels,'-','Gaps');
            h = bar(buckets(nonZero));
            set(get(h,'parent'),'Xtick',1:sum(nonZero),'XTickLabel',barlabels);
        end
    else
        h = bar(buckets(1:4));
        set(get(h,'parent'),'XTickLabel',{'A','C','G','T'});
    end
end
