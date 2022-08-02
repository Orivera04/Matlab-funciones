function aminoAcids = aacount(peptide,varargin)
%AACOUNT reports amino acid counts for a sequence.
%
%   AACOUNT(SEQ) counts the number of occurrences of each amino acid in the
%   sequence and returns these numbers in a structure. If characters other
%   than the standard 20 amino acids are present in the sequence, then a
%   warning is given and the field Others is added to the structure.
%
%   AACOUNT(...,'CHART',STYLE) creates a chart showing the relative
%   proportions of the amino acids. Valid styles are 'Pie' and 'Bar'.
%
%   AACOUNT(...,'OTHERS','FULL') counts all the standard extended amino
%   acid symbols individually instead of bundling them all together into
%   the Others field of the output structure. Type doc aacount for a full
%   list of valid symbols.
%
%   AACOUNT(...,'STRUCTURE','FULL') blocks the unknown characters warning
%   and includes 'Others' or the full list of valid symbols in the returned
%   results. The setting of the 'OTHERS' argument determines the format of
%   the results structure.
%
%   Example:
%
%       S = getgenpept('AAA59174')
%       aacount(S)
%
%   See also BASECOUNT, CODONCOUNT, DIMERCOUNT.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.10.6.7 $  $Date: 2004/03/14 15:31:13 $

pieChart = false;
barChart = false;
bundle = true;
others = false;                       
showall = false;

% If the input is a structure then extract the Sequence data.
if isstruct(peptide)
    try
        peptide = seqfromstruct(peptide);
    catch
        rethrow(lasterror);
    end
end

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
                    labels = num2cell(int2aa(1:20));
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

if ischar(peptide)
    try
        peptide = aa2int(peptide);
    catch
        lasterr('');
        asterisk = (peptide == '*');
        hyphen = (peptide == '-');
        %       question = (peptide == '?');
        peptide = regexprep(peptide,'\W','J');  %J is not an amino acid
        %     peptide(question) = '?';
        peptide(hyphen) = '-';
        peptide(asterisk) = '*';
        peptide = aa2int(peptide);
    end
end

if any(peptide == 0)
    peptide(peptide == 0) = [];
    warning('Bioinfo:UnknownSymbols',...
        'Sequence contains unknown characters. These will be ignored.');
end


%
%   A R N D C Q E G H I  L  K  M  F  P  S  T  W  Y  V  B  Z  X  *  -  ?
%   1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 0

seqLength = length(peptide);
maxPeptideInt = double(aa2int('-'));
buckets = zeros(1,maxPeptideInt);

for count = 1:seqLength
    buckets(peptide(count)) = buckets(peptide(count)) + 1;
end

for count = 1:20
    aminoAcids.(upper(int2aa(count))) = buckets(count);
end

if any(buckets(21:end)) | showall   % others exist or structure is 'full'

    others = true;
    if(bundle)
        aminoAcids.Others = sum(buckets(21:end));
        if ~showall
            warning('Bioinfo:OTHERSYMBOLS',...
                'Symbols other than the standard 20 amino acids appear in the sequence.');
        end
    else
        aminoAcids.B = buckets(aa2int('b'));
        aminoAcids.Z = buckets(aa2int('z'));
        aminoAcids.X = buckets(aa2int('x'));
        aminoAcids.Stop = buckets(aa2int('*'));
        aminoAcids.Gap = buckets(aa2int('-'));
        %  aminoAcids.Unknown = buckets(maxPeptideInt);
    end
end

if pieChart
    if others
        if bundle
            buckets(21) = aminoAcids.Others;
            labels{21} = 'Others';
            pie(buckets(1:21),labels);
        else
            labels(21:maxPeptideInt) = {'B','Z','Any','Stop','Gap'};
            pie(buckets,labels);
        end
    else
        pie(buckets(1:20),labels);
    end
elseif barChart
    if others
        if bundle
            buckets(21) = aminoAcids.Others;
            h = bar(buckets(1:21));
            labels{21} = 'Others';
            set(get(h,'parent'),'XTickLabel',labels,'Xtick',1:21,'Xlim',[0 22]);
        else
            h = bar(buckets);
            labels(21:maxPeptideInt) = {'B','Z','Any','Stop','Gap'};
            set(get(h,'parent'),'XTickLabel',labels,'Xtick',1:maxPeptideInt,...
                'Xlim',[0 maxPeptideInt+1]);
        end
    else
        h = bar(buckets(1:20));
        set(get(h,'parent'),'XTickLabel',labels,'Xtick',1:20,'Xlim',[0 21]);
    end
end
