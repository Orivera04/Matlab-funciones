function parts = cleave(seq,pattern,position,varargin)
%CLEAVE cuts an amino acid sequence at specified cleavage sites.
%
%   CLEAVE(SEQ,PATTERN,POSITION) cuts sequence SEQ into parts at specified
%   cleavage sites specified by peptide pattern PATTERN. POSITION
%   defines the position on the PATTERN where the sequence is cut. POSITION
%   0 corresponds to the N terminal end of the PATTERN. PATTERN can be a
%   regular expression. 
%
%   CLEAVE(...,'PARTIALDIGEST',P) simulates a partial digest where each
%   cleavage site in the sequence has a probability P of being cut.
%
%   Some common proteases and their cleavage sites are as follows:
%
%       Trypsin:         [KR][^P]     Position 1
%       Chymotrypsin:    [WYF][^P]    Position 1
%       Glu C:           [ED][^P]     Position 1
%       Lys C:           [K][^P]      Position 1
%       Asp N:           D            Position 1
%
%   Examples:
%
%       S = getgenpept('AAA59174')
%       % Trypsin cleaves after K or R when the next residue is not P.
%       parts = cleave(S.Sequence,'[KR][^P]',1)
%
%   See also REGEXP, RESTRICT, SEQSHOWWORDS.

%   Reference: Liebler, D. Introduction to Proteomics, Humana Press 2002.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.5.4.4 $  $Date: 2004/01/24 09:18:47 $


if nargin < 3 || (rem(nargin,2) == 0)
    error('Bioinfo:IncorrectNumberOfArguments',...
        'Incorrect number of arguments to %s.',mfilename);
end

% If the input is a structure then extract the Sequence data.
if isstruct(seq)
    try
        seq = seqfromstruct(seq);
    catch
        rethrow(lasterror);
    end
end

cut2 = [];
ratio = 1;

okargs = {'partialdigest',''};
for j=1:2:nargin-4
    pname = varargin{j};
    pval = varargin{j+1};
    k = strmatch(lower(pname), okargs);
    if isempty(k)
        error('Bioinfo:UnknownParameterName',...
                    'Unknown parameter name: %s.',pname);
    elseif length(k)>1
        error('Bioinfo:AmbigousParameterName',...
                    'Ambiguous parameter name: %s.',pname);
    else
        switch(k)
            case 1  % font
                ratio = pval;
                if ~isnumeric(ratio) || ratio <0 || ratio >1
                     error('Bioinfo:BadPartialDigestRatio',...
              'Probability for PartialDigest must be in the range 0 to 1.');
                end
        end
    end
end



pattern = seq2regexp(pattern,'alphabet','aa');

% deal with the posibility that seq is numeric

if isnumeric(seq)
    seq = int2aa(seq);
elseif ischar(seq)
    seq = upper(seq);   % make sure it is upper case
end

% where are the restriction sites?
sites = regexp(seq,pattern);
lpos = length(position);

if lpos > 1
    if lpos > 2
        warning('Bioinfo:CleaveOnlyTwoCuts','Cleave can only make at most two cuts.')
    end
    cut2 = position(2);
    position = position(1);
end

position = position - 1;  % regexp finds position of first match

% check that we don't have any overhangs at either end
seqLength = length(seq);
cutSites = sites + position;
if ~isempty(cut2)
    cut2Sites = sites + cut2 -1;
else
    cut2Sites = cutSites;
end
mask = (cutSites < 1) | (cutSites >= seqLength) | (cut2Sites >= seqLength) ;
sites = sites(~mask);

% how many sites are left

numSites = length(sites);

if ratio < 1    % discard some sites if ratio is not 1
    mask = rand(1,numSites)>ratio;
    sites = sites(mask);
    numSites = length(sites);
end

% now for each site we need to split the sequence

% set up output
parts = cell(numSites+1,1);

% loop through the
pos = 1;
chunk = 1;
for count = 1:numSites
    chunkEnd = sites(count)+position;
    parts{chunk} =  seq(pos:chunkEnd);
    pos = chunkEnd + 1;
    chunk = chunk + 1;
    if ~isempty(cut2)
        chunkEnd = sites(count)+cut2-1;
        parts{chunk} =  seq(pos:chunkEnd);
        pos = chunkEnd + 1;
        chunk = chunk + 1;
    end
end

parts{chunk} = seq(pos:seqLength);


