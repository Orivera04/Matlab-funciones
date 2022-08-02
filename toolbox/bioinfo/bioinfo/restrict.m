function parts = restrict(seq,pattern,varargin)
%RESTRICT Cuts SEQ sequences at specified restriction sites.
%
%   RESTRICT(SEQ,ENZYME) cuts a SEQ sequence into parts at the restriction
%   sites of restriction enzyme ENZYME where ENZYME is the name of a
%   restriction enzyme from REBASE Version 306. The return values are
%   stored in a cell array of sequences.
%
%   RESTRICT(SEQ,PATTERN,POSITION) cuts a SEQ sequence into parts at
%   specified restriction sites specified by nucleotide pattern PATTERN.
%   POSITION defines the position on the PATTERN where the sequence is cut.
%   POSITION 0 corresponds to the 5' end of the PATTERN. PATTERN can be a
%   regular expression.
%
%   RESTRICT(...,'PARTIALDIGEST',P) simulates a partial digest where each
%   restriction site in the sequence has a probability P of being cut.
%
%   REBASE, the Restriction Enzyme Database, is a collection of information
%   about restriction enzymes and related proteins. For more information on
%   REBASE, go to http://rebase.neb.com/rebase/rebase.html .
%
%   Examples:
%
%       seq = 'AGAGGGGTACGCGCTCTGAAAAGCGGGAACCTCGTGGCGCTTTATTAA'
%       partsP = restrict(seq,'GCGC',3)
%       partsE = restrict(seq,'HspAI')
%       partsPR = restrict(seq,'GCG[^C]',3)
%
%   See also CLEAVE, REGEXP, SEQ2REGEXP, SEQSHOWWORDS.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.9.4.4 $  $Date: 2004/01/24 09:18:53 $

% figure out whether we have a pattern or an enzyme name

if nargin < 2
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
checkOpts = false;
offset = 1;
switch nargin
    case 2  % must be an enzyme
        [pattern, position,cut2]=lookupEnzyme(pattern);
    case 3 % ambiguous case
        position = varargin{1};
    case 4
        checkOpts = true;
        [pattern, position,cut2]=lookupEnzyme(pattern);
    case 5
        checkOpts = true;
        offset = 2;
        position = varargin{1};
    otherwise
        error('Bioinfo:IncorrectNumberOfArguments',...
            'Incorrect number of arguments to %s.',mfilename);
end
if checkOpts
    if rem(nargin,2) == 2-offset
        error('Bioinfo:IncorrectNumberOfArguments',...
            'Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'partialdigest',''};
    for j=offset:2:nargin-2
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
                case 1  % ratio
                    ratio = pval;
                    if ~isnumeric(ratio) || ratio <0 || ratio >1
                        error('Bioinfo:BadPartialDigestRatio',...
                            'Probability for PartialDigest must be in the range 0 to 1.');
                    end

            end
        end
    end

end

pattern = seq2regexp(pattern,'alphabet','nt');

% deal with the posibility that seq is numeric

if isnumeric(seq)
    seq = int2nt(seq);
elseif ischar(seq)
    seq = upper(seq);   % make sure it is upper case
end

% where are the restriction sites?
sites = regexp(seq,pattern);
lpos = length(position);

if lpos > 1
    if lpos > 2
        warning('Bioinfo:RestrictOnlyTwoCuts','Restrict can only make at most two cuts.')
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


%-----------------------------------------------------------------------
function [pattern, c1,c3] = lookupEnzyme(theEnzyme)
[name, pattern,  len, ncuts,blunt,c1,c2,c3,c4]=readrebase;
match = find(strcmpi(name,theEnzyme));

if isempty(match)
    error('Bioinfo:CannotFindEnzyme',...
        'Could not find enzyme %s in the REBASE file.',theEnzyme);
end

pattern = upper(pattern{match});
c1 = c1(match);
if ncuts(match) > 2
    c3 = c3(match);
else
    c3 = [];
end


%-----------------------------------------------------------------
% Reference:  REBASE The Restriction Enzyme Database
%
% The Restriction Enzyme data BASE
% A collection of information about restriction enzymes and related proteins. It contains published and unpublished references,
% recognition and cleavage sites, isoschizomers, commercial availability, methylation sensitivity, crystal and sequence data.
% DNA methyltransferases, homing endonucleases, nicking enzymes, specificity subunits and control proteins are also included.
% Putative DNA methyltransferases and restriction enzymes, as predicted from analysis of genomic sequences, are also listed.
% REBASE is updated daily and is constantly expanding.
%
%  AUTHORS:
% Dr. Richard J. Roberts and Dana Macelis
%
% LATEST REVIEW:
% Nucleic Acids Research 29: 268-269 (2001).
%
% OFFICIAL REBASE WEB SITE:
% http://rebase.neb.com
%
