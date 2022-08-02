function [dimers,matrix] = dimercount(dna,varargin)
%DIMERCOUNT report nucleotide dimer counts for a sequence.
%
%   DIMERCOUNT(SEQ) counts the number of occurrences of nucleotide dimers
%   in the sequence and returns these numbers in a structure with the
%   fields AA, AC, AG,..., GT, TT. If other characters are present in the
%   sequence, then a warning is given and the field Others is added to the
%   structure.
%
%   [DIMERS, P] = DIMERCOUNT(SEQ) returns a 4x4 matrix of the relative
%   proportions of the dimers in SEQ, with the rows corresponding to A,C,G
%   and T in as the first element of the dimer and the columns
%   corresponding to A,C,G, and T in the second element.
%
%   DIMERCOUNT(...,'CHART',STYLE) creates a chart showing the relative
%   proportions of the dimers. Valid styles are 'Pie' and 'Bar'.
%
%   Example:
%
%       dimercount('TAGCTGGCCAAGCGAGCTTG')
%
%   See also AACOUNT, BASECOUNT, BASELOOKUP, CODONCOUNT, NMERCOUNT,
%   NTDENSITY.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.16.6.7 $  $Date: 2004/03/14 15:31:17 $

pieChart = false;
barChart = false;
others = false;

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
    okargs = {'chart',''};
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
                case 1  % graph
                    if strmatch(lower(pval),'pie')
                        pieChart = true;
                    elseif strmatch(lower(pval),'bar')
                        barChart = true;
                    else
                        warning('Bioinfo:UnknownGraphType',...
                            'Unknown graph type.')
                    end
            end
        end
    end
end

if ischar(dna)
    e = lasterr;
    try

        dna = nt2int(dna,'unknown',5);
    catch
        lasterr(e);
        dna = regexprep(dna,'\W','?');
        dna = nt2int(dna,'unknown',5);
    end
else
    dna(dna == 0) = 5;
end

% * A C G T U N R Y K M S  W  B  D  H  V
% 0 1 2 3 4 4 5 6 7 8 9 10 11 12 13 14 15

%   'a  b c  d e f g  h i j k l m n o p q r  s t u  v  w x y z'
%   [1 12 2 13 0 0 3 14 0 0 8 0 9 5 0 0 0 6 10 4 4 15 11 0 7 0]);
%   map = 'acgtnrykmswbdhv';
seqLength = length(dna);
buckets = zeros(15,15);

for count = 1:seqLength-1
    buckets(dna(count),dna(count+1)) = buckets(dna(count),dna(count+1)) + 1;
end

aint = nt2int('a');cint = nt2int('c');
gint = nt2int('g');tint = nt2int('t');
dimers.AA = buckets(aint,aint);
dimers.AC = buckets(aint,cint);
dimers.AG = buckets(aint,gint);
dimers.AT = buckets(aint,tint);
dimers.CA = buckets(cint,aint);
dimers.CC = buckets(cint,cint);
dimers.CG = buckets(cint,gint);
dimers.CT = buckets(cint,tint);
dimers.GA = buckets(gint,aint);
dimers.GC = buckets(gint,cint);
dimers.GG = buckets(gint,gint);
dimers.GT = buckets(gint,tint);
dimers.TA = buckets(tint,aint);
dimers.TC = buckets(tint,cint);
dimers.TG = buckets(tint,gint);
dimers.TT = buckets(tint,tint);

countothers = seqLength - sum(sum(buckets(1:4,1:4))) -1;
matrix = (buckets(1:4,1:4)./(seqLength-1 - countothers));
if countothers > 0    % others exist
    dimers.Others = countothers;
    others = true;
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
warnState = warning('off', 'MATLAB:divideByZero');
if pieChart
    if others
        outputs = [reshape(buckets(1:4,1:4),16,1); countothers];
        pie(outputs,{'AA','CA','GA','TA','AC','CC','GC','TC','AG','CG','GG','TG','AT','CT','GT','TT','Others'});
    else
        pie(buckets(1:4,1:4),{'AA','CA','GA','TA','AC','CC','GC','TC','AG','CG','GG','TG','AT','CT','GT','TT'});
    end
elseif barChart
    if others
        outputs = [reshape(buckets(1:4,1:4),16,1); countothers];
        h = bar(outputs);
        set(get(h,'parent'),'XTickLabel',{'AA','CA','GA','TA','AC','CC','GC','TC','AG','CG','GG','TG','AT','CT','GT','TT','Others'});
    else
        h = bar3(buckets(1:4,1:4));
        set(get(h(1),'parent'),'XTickLabel',{'A','C','G','T'},'YTickLabel',{'A','C','G','T'});
        ylabel('First Base');
        xlabel('Second Base');
    end
end
warning(warnState);
